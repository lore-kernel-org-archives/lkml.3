Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751990AbaL1Qpi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 11:45:38 -0500
Received: from www.osadl.org ([62.245.132.105]:38634 "EHLO www.osadl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751935AbaL1Qpg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 11:45:36 -0500
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Andy Whitcroft <apw@canonical.com>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        Nicholas Mc Guire <der.herr@hofr.at>
Subject: [PATCH RFC] checkpatch: fix for catching all world writable settings
Date: Sun, 28 Dec 2014 11:41:47 -0500
Message-Id: <1419784907-6614-1-git-send-email-der.herr@hofr.at>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently checkpatch will fuss if one uses world writable settings in debugfs
files by passing S_IWUGO but not when passing S_IRWXUGO. This patch extends
the check to cover the S_IRWXUGO case.

tested on trivial examples:
WARNING: Exporting world writable files is usually an error. Consider more 
restrictive permissions.
#72: FILE: test.c:72:
+       id_file = debugfs_create_file("id", S_IRUGO | S_IWUGO, my_dir,

with the patch applied it also fusses now in the S_IRWXUGO case.
WARNING: Exporting world writable files is usually an error. Consider more 
restrictive permissions.
#72: FILE: test.c:72:
+       id_file = debugfs_create_file("id", S_IRWXUGO, my_dir,

patch is against linux-next 3.19.0-rc1 -next-20141226

Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
---
 scripts/checkpatch.pl |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index f0bb6d6..48120b1 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -5227,7 +5227,9 @@ sub process {
 		}
 
 		if ($line =~ /debugfs_create_file.*S_IWUGO/ ||
-		    $line =~ /DEVICE_ATTR.*S_IWUGO/ ) {
+		    $line =~ /debugfs_create_file.*S_IRWXUGO/ ||
+		    $line =~ /DEVICE_ATTR.*S_IWUGO/ ||
+		    $line =~ /DEVICE_ATTR.*S_IRWXUGO/ ) {
 			WARN("EXPORTED_WORLD_WRITABLE",
 			     "Exporting world writable files is usually an error. Consider more restrictive permissions.\n" . $herecurr);
 		}
--
1.7.10.4

