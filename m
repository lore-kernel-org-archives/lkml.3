Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013Ab3IISRR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 14:17:17 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:44288 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061Ab3IISRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 14:17:16 -0400
From: Tom Gundersen <teg@jklm.no>
To: fuse-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Tom Gundersen <teg@jklm.no>,
        Kay Sievers <kay@vrfy.org>, Miklos Szeredi <miklos@szeredi.hu>
Subject: [PATCH v2] cuse: creat 'dead' device node for on-demand module loading
Date: Mon,  9 Sep 2013 20:18:27 +0200
Message-Id: <1378750707-1428-1-git-send-email-teg@jklm.no>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1378750298-965-1-git-send-email-teg@jklm.no>
References: <1378750298-965-1-git-send-email-teg@jklm.no>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows udev (or more recently systemd-tmpfiles) to create /dev/cuse on
boot, in the same way as /dev/fuse is currently created, and the corresponding
module to be loaded on first access.

The corresponding functionalty was introduced for fuse in commit 578454f.

Signed-off-by: Tom Gundersen <teg@jklm.no>
Cc: Kay Sievers <kay@vrfy.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
---

v2: also update Documentation/devices.txt (and pick a minor that is not taken)

 Documentation/devices.txt  | 1 +
 fs/fuse/cuse.c             | 5 ++++-
 include/linux/miscdevice.h | 1 +
 3 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/Documentation/devices.txt b/Documentation/devices.txt
index 23721d3..80b7241 100644
--- a/Documentation/devices.txt
+++ b/Documentation/devices.txt
@@ -414,6 +414,7 @@ Your cooperation is appreciated.
 		200 = /dev/net/tun	TAP/TUN network device
 		201 = /dev/button/gulpb	Transmeta GULP-B buttons
 		202 = /dev/emd/ctl	Enhanced Metadisk RAID (EMD) control
+		203 = /dev/cuse		Cuse (character device in user-space)
 		204 = /dev/video/em8300		EM8300 DVD decoder control
 		205 = /dev/video/em8300_mv	EM8300 DVD decoder video
 		206 = /dev/video/em8300_ma	EM8300 DVD decoder audio
diff --git a/fs/fuse/cuse.c b/fs/fuse/cuse.c
index adbfd66..24da581 100644
--- a/fs/fuse/cuse.c
+++ b/fs/fuse/cuse.c
@@ -589,11 +589,14 @@ static struct attribute *cuse_class_dev_attrs[] = {
 ATTRIBUTE_GROUPS(cuse_class_dev);
 
 static struct miscdevice cuse_miscdev = {
-	.minor		= MISC_DYNAMIC_MINOR,
+	.minor		= CUSE_MINOR,
 	.name		= "cuse",
 	.fops		= &cuse_channel_fops,
 };
 
+MODULE_ALIAS_MISCDEV(CUSE_MINOR);
+MODULE_ALIAS("devname:cuse");
+
 static int __init cuse_init(void)
 {
 	int i, rc;
diff --git a/include/linux/miscdevice.h b/include/linux/miscdevice.h
index cb35835..f7eaf2d 100644
--- a/include/linux/miscdevice.h
+++ b/include/linux/miscdevice.h
@@ -31,6 +31,7 @@
 #define I2O_MINOR		166
 #define MICROCODE_MINOR		184
 #define TUN_MINOR		200
+#define CUSE_MINOR		203
 #define MWAVE_MINOR		219	/* ACP/Mwave Modem */
 #define MPT_MINOR		220
 #define MPT2SAS_MINOR		221
-- 
1.8.4

