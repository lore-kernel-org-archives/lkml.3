Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758114Ab3GMHlU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 03:41:20 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:54138 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988Ab3GMHlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 03:41:18 -0400
From: Alexandru Juncu <alexj@rosedu.org>
Cc: alexj@rosedu.org, linux-kernel@vger.kernel.org
Subject: [RFC] Script for isolating maintainer email.
Date: Sat, 13 Jul 2013 10:40:41 +0300
Message-Id: <1373701241-6499-1-git-send-email-alexj@rosedu.org>
X-Mailer: git-send-email 1.7.10.4
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

I found the need for a script that doesn't require me to copy part of the
output from get_maintainer.pl into git send-email and could do both with
one command.

I don't know if there is something similar already implemented. If there is,
please point me to it. If not, maybe somebody finds it useful.

Used on top of get_maintainer.pl, it generates the list of
emails required for git send-email.

The output can be used as a process expansion into the arguments of
git send-email. Example:

git send-email $(scripts/get_email.sh my.patch) my.patch

Signed-off-by: Alexandru Juncu <alexj@rosedu.org>
---
 scripts/get_email.sh |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)
 create mode 100755 scripts/get_email.sh

diff --git a/scripts/get_email.sh b/scripts/get_email.sh
new file mode 100755
index 0000000..a71d56d
--- /dev/null
+++ b/scripts/get_email.sh
@@ -0,0 +1,24 @@
+#!/bin/bash
+
+if [ -e scripts/get_maintainer.pl ]; then
+	if [ $# -lt 1 ]; then
+		echo "Script needs a patch file as a parameter."
+	exit 1
+fi
+
+	IFS=$'\n'
+	for line in $(scripts/get_maintainer.pl $1); do
+		email_regexp="\b[a-zA-Z0-9.-]+@[a-zA-Z0-9.-]+\.[a-zA-Z0-9.-]+\b"
+		email=$(grep -E -o $email_regexp<<<$line)
+		if [ $(grep "maintainer" <<< $line) ]; then
+			list="$list --to $email"
+		else
+			list="$list --cc $email"
+		fi
+	done
+	echo $list
+
+else
+	echo "You should run this from the root of the source tree."
+	exit 1
+fi
-- 
1.7.10.4

