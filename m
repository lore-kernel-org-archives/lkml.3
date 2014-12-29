Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232AbaL2QfC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 11:35:02 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:55203 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbaL2QfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 11:35:00 -0500
Date: Mon, 29 Dec 2014 17:34:56 +0100
From: Sylvain BERTRAND <sylvain.bertrand@gmail.com>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org
Subject: [PATCH] scripts: fix link-vmlinux.sh bash-ism
Message-ID: <20141229163456.GB27533@dhcppc1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chocked while compiling linux with dash shell instead of bash shell.
See:
http://pubs.opengroup.org/onlinepubs/000095399/utilities/trap.html

Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sylvain BERTRAND <sylvain.bertrand@gmail.com>
---
--- a/scripts/link-vmlinux.sh	2014-12-29 15:10:29.436431249 +0000
+++ b/scripts/link-vmlinux.sh	2014-12-29 16:23:06.010853608 +0000
@@ -111,7 +111,6 @@
 }
 
 # Delete output files in case of error
-trap cleanup SIGHUP SIGINT SIGQUIT SIGTERM ERR
 cleanup()
 {
 	rm -f .old_version
@@ -124,6 +123,20 @@
 	rm -f vmlinux.o
 }
 
+on_exit()
+{
+	if [ $? -ne 0 ]; then
+		cleanup
+	fi
+}
+trap on_exit EXIT
+
+on_signals()
+{
+	exit 1
+}
+trap on_signals HUP INT QUIT TERM
+
 #
 #
 # Use "make V=1" to debug this script
@@ -231,7 +244,6 @@
 	if ! cmp -s System.map .tmp_System.map; then
 		echo >&2 Inconsistent kallsyms data
 		echo >&2 Try "make KALLSYMS_EXTRA_PASS=1" as a workaround
-		cleanup
 		exit 1
 	fi
 fi
