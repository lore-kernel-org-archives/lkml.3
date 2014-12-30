Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047AbaL3Pml (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 10:42:41 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:59230 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbaL3Pmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 10:42:39 -0500
Date: Tue, 30 Dec 2014 16:36:54 +0100
From: Sylvain BERTRAND <sylvain.bertrand@gmail.com>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] x86: tools: shell-ify calc_run_size perl-ism
Message-ID: <20141230153654.GA5103@dhcppc1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove perl script.

Signed-off-by: Sylvain BERTRAND <sylvain.bertrand@gmail.com>
---
--- a/arch/x86/tools/calc_run_size.pl
+++ b/arch/x86/tools/calc_run_size.pl
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
