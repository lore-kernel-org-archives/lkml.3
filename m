Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529AbbAFXlc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 18:41:32 -0500
Received: from mail-oi0-f43.google.com ([209.85.218.43]:57222 "EHLO
	mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbbAFXlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 18:41:31 -0500
Message-ID: <54AC72AF.5090609@landley.net>
Date: Tue, 06 Jan 2015 17:41:35 -0600
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] out out damn perl
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Landley <rob@landley.net>

Commit e6023367d779 added perl back to the kernel build in -rc6.
Replace 39 lines of perl with 4 lines of shell script.

Signed-off-by: Rob Landley <rob@landley.net>
---

 arch/x86/boot/compressed/Makefile |    6 ++--
 arch/x86/tools/calc_run_size.pl   |   39 ----------------------------
 2 files changed, 4 insertions(+), 41 deletions(-)

Commit e6023367d779 added perl back to the kernel build. KILL IT WITH FIRE.

--- linux/arch/x86/boot/compressed/Makefile
+++ linux/arch/x86/boot/compressed/Makefile
@@ -89,8 +76,10 @@
 suffix-$(CONFIG_KERNEL_LZO) 	:= lzo
 suffix-$(CONFIG_KERNEL_LZ4) 	:= lz4
 
-RUN_SIZE = $(shell $(OBJDUMP) -h vmlinux | \
-	     perl $(srctree)/arch/x86/tools/calc_run_size.pl)
+RUN_SIZE = $(shell NUM='\([0-9a-fA-F]*[ \t]*\)'; $(OBJDUMP) -h vmlinux | \
+sed -n 's/^[ \t0-9]*.b[sr][sk][ \t]*'"$$NUM$$NUM$$NUM$$NUM"'.*/\1\4/p' | \
+xargs | while read a b c d; do [ "$$b" != "$$d" ] && exit 1; \
+expr $$(printf "%d + %d + %d" 0x$$a 0x$$b 0x$$c); done)
 quiet_cmd_mkpiggy = MKPIGGY $@
       cmd_mkpiggy = $(obj)/mkpiggy $< $(RUN_SIZE) > $@ || ( rm -f $@ ; false )
 
--- linux/arch/x86/tools/calc_run_size.pl
+++ /dev/null
@@ -1,39 +0,0 @@
-#!/usr/bin/perl
-#
-# Calculate the amount of space needed to run the kernel, including room for
-# the .bss and .brk sections.
-#
-# Usage:
-# objdump -h a.out | perl calc_run_size.pl
-use strict;
-
-my $mem_size = 0;
-my $file_offset = 0;
-
-my $sections=" *[0-9]+ \.(?:bss|brk) +";
-while (<>) {
-	if (/^$sections([0-9a-f]+) +(?:[0-9a-f]+ +){2}([0-9a-f]+)/) {
-		my $size = hex($1);
-		my $offset = hex($2);
-		$mem_size += $size;
-		if ($file_offset == 0) {
-			$file_offset = $offset;
-		} elsif ($file_offset != $offset) {
-			# BFD linker shows the same file offset in ELF.
-			# Gold linker shows them as consecutive.
-			next if ($file_offset + $mem_size == $offset + $size);
-
-			printf STDERR "file_offset: 0x%lx\n", $file_offset;
-			printf STDERR "mem_size: 0x%lx\n", $mem_size;
-			printf STDERR "offset: 0x%lx\n", $offset;
-			printf STDERR "size: 0x%lx\n", $size;
-
-			die ".bss and .brk are non-contiguous\n";
-		}
-	}
-}
-
-if ($file_offset == 0) {
-	die "Never found .bss or .brk file offset\n";
-}
-printf("%d\n", $mem_size + $file_offset);
