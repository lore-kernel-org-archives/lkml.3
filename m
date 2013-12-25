Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229Ab3LYQXO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Dec 2013 11:23:14 -0500
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:38233 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752138Ab3LYQXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Dec 2013 11:23:13 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ag4MAC8Gu1JQyXDq/2dsb2JhbABYgws4pTGVC4EXF3SCZhwjGIECN4gIAckijkZXHYQgBJgWAYEwkGSDLjuBLQ
Date: Wed, 25 Dec 2013 17:23:10 +0100
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: [PATCH 1/1] selftests : Adding symbolic link limits test script
Message-Id: <20131225172310.6eb4aa79f79a9fa5a79b3f4e@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds fs directory in selftests and a script to explain recursive
and consecutive symbolic linking limits who have been debated
so many times.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 tools/testing/selftests/Makefile       |  1 +
 tools/testing/selftests/fs/Makefile    |  6 ++++
 tools/testing/selftests/fs/symlinks.sh | 64 ++++++++++++++++++++++++++++++++++
 3 files changed, 71 insertions(+)
 create mode 100644 tools/testing/selftests/fs/Makefile
 create mode 100755 tools/testing/selftests/fs/symlinks.sh

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 9f3eae2..10e2d80 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -9,6 +9,7 @@ TARGETS += ptrace
 TARGETS += timers
 TARGETS += vm
 TARGETS += powerpc
+TARGETS += fs
 
 all:
 	for TARGET in $(TARGETS); do \
diff --git a/tools/testing/selftests/fs/Makefile b/tools/testing/selftests/fs/Makefile
new file mode 100644
index 0000000..cf0fc21
--- /dev/null
+++ b/tools/testing/selftests/fs/Makefile
@@ -0,0 +1,6 @@
+all:
+
+run_tests:
+	@/bin/sh ./symlinks.sh || echo "symlinks selftests: [FAIL]"
+
+clean:
diff --git a/tools/testing/selftests/fs/symlinks.sh b/tools/testing/selftests/fs/symlinks.sh
new file mode 100755
index 0000000..5daeb05
--- /dev/null
+++ b/tools/testing/selftests/fs/symlinks.sh
@@ -0,0 +1,64 @@
+#!/bin/bash
+#
+# This script hits symbolic link limits.
+
+boldtext=`tput bold`
+normaltext=`tput sgr0`
+run_path=`pwd`
+appl_path="tmp_symlinks"
+mkdir -p $appl_path
+cd $appl_path
+
+function recursive_symbolic_links()
+{
+	path="origpath"`date +'%s'`
+	symlink=`date +'%s'`
+	echo $boldtext"Recursive symbolic link testing (vfs limit : 8)"\
+	     $normaltext
+	echo "original_path/1/2/3/4 ...  where 1=>original_path 2=>1 ..."
+	echo "Trying 10 steps ..."
+	mkdir $path
+
+	for i in {1..10}
+	do
+		cd $path 2>/dev/null|| break
+		echo  "Creating : "$path" =>" " [OK]"
+		if [ $i = 1 ] ;then
+			path="../"$path
+		fi
+		ln -s $path $symlink"_"$i
+		path=$symlink"_"$i
+	done
+	echo $boldtext"Maximum recursive symlink level:" `expr $i - 2 `\
+	     $normaltext
+}
+
+function consecutive_symbolic_links()
+{
+	origfile="orig"`date +'%s'`
+	symlink=`date +'%s'`
+	echo $boldtext"Consecutive symbolic link testing (vfs limit : 40)"\
+	     $normaltext
+	echo "original_file;1;2;3 ... where 1=>original_file 2=>1 ..."
+	echo "Trying 50 steps ..."
+
+	touch $origfile
+	for i in {1..50}
+	do
+		cat $origfile 2>/dev/null || break;
+		echo -n "[OK] |"
+		ln -s $origfile $symlink"_"$i
+		origfile=$symlink"_"$i
+		echo -n $i
+	done
+	echo -e $boldtext "\nMaximum consecutive symlink level:" `expr $i - 2`\
+	        $normaltext
+
+}
+
+recursive_symbolic_links
+echo "------------------------------------------------------"
+sleep 1
+consecutive_symbolic_links
+cd $run_path
+rm -rf $appl_path
-- 
1.8.1.4
