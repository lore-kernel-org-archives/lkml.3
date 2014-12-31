Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751620AbaLaQn1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 11:43:27 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:49032 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520AbaLaQnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 11:43:10 -0500
Date: Wed, 31 Dec 2014 17:43:06 +0100
From: Sylvain BERTRAND <sylvain.bertrand@gmail.com>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/3] x86: tools: shell-ify calc_run_size perl-ism
Message-ID: <20141231164306.GA1872@dhcppc1>
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
--- arch/x86/tools/calc_run_size.sh
+++ arch/x86/tools/calc_run_size.sh
@@ -0,0 +1,46 @@
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
+while read Idx Name Size_hex VMA_hex LMA_hex File_off_hex Algn
+do
+	if [ "$Name" = ".bss" -o "$Name" = ".brk" ]; then
+		Size=$((0x$Size_hex))
+		File_off=$((0x$File_off_hex))
+
+		mem_size=$(($mem_size + $Size))
+
+		if [ $file_offset -eq 0 ]; then
+			file_offset=$File_off
+		elif [ $file_offset -ne $File_off ]; then
+			# BFD linker shows the same file offset in ELF.
+			# Gold linker shows them as consecutive.
+			if [ $(($file_offset + $mem_size)) -eq $(($File_off + $Size)) ]; then
+				continue
+			fi
+			
+			printf "file_offset: 0x%x\n" $file_offset >&2
+			printf "mem_size: 0x%x\n" $mem_size >&2
+			printf "offset: 0x%x\n" $File_off >&2
+			printf "size: 0x%x\n" $Size >&2
+
+			echo ".bss and .brk are non-contiguous" >&2
+			exit 1
+		fi
+	fi
+done
+
+if [ $file_offset -eq 0 ]; then
+	echo "Never found .bss or .brk file offset" >&2
+	exit 1
+fi
+printf "%d\n" $(($mem_size + $file_offset))
