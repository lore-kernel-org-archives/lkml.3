Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751784AbaL3Pgv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 10:36:51 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:64382 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbaL3Pgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 10:36:50 -0500
Date: Tue, 30 Dec 2014 16:36:47 +0100
From: Sylvain BERTRAND <sylvain.bertrand@gmail.com>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] x86: tools: shell-ify calc_run_size perl-ism
Message-ID: <20141230153647.GA5031@dhcppc1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the shell script.

Signed-off-by: Sylvain BERTRAND <sylvain.bertrand@gmail.com>
---
--- a/arch/x86/tools/calc_run_size.sh
+++ b/arch/x86/tools/calc_run_size.sh
@@ -0,0 +1,42 @@
+#!/bin/sh
+#
+# Calculate the amount of space needed to run the kernel, including room for
+# the .bss and .brk sections.
+#
+# Usage:
+# objdump -h a.out | sh calc_run_size.sh
+
+set -e
+
+file_offset=0
+mem_size=0
+
+while read Idx Name Size VMA LMA File_off Algn
+do
+	if [ "$Name" = ".bss" -o "$Name" = ".brk" ]; then
+		mem_size=$(($mem_size + 0x$Size))
+		if [ $((0x$file_offset)) -eq 0 ]; then
+			file_offset=$File_off
+		elif [ $((0x$file_offset)) -ne $((0x$File_off)) ]; then
+			# BFD linker shows the same file offset in ELF.
+			# Gold linker shows them as consecutive.
+			if [ $((0x$file_offset + $mem_size)) -eq $((0x$File_off + 0x$Size)) ]; then
+				continue
+			fi
+			
+			printf "file_offset: 0x%x\n" $((0x$file_offset))
+			printf "mem_size: 0x%x\n" $mem_size
+			printf "offset: 0x%x\n" $((0x$File_off))
+			printf "size: 0x%x\n" $((0x$Size))
+
+			echo ".bss and .brk are non-contiguous"
+			exit 1
+		fi
+	fi
+done
+
+if [ $((0x$file_offset)) -eq 0 ]; then
+	echo "Never found .bss or .brk file offset"
+	exit 1
+fi
+printf "%d\n" $(($mem_size + 0x$file_offset))
