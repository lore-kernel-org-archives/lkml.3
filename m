Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423AbaENVfd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 17:35:33 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:51356 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055AbaENVf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 17:35:27 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, Arnd Bergmann <arnd@arndb.de>,
        Eric Biederman <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        lxc-devel@lists.linuxcontainers.org,
        Seth Forshee <seth.forshee@canonical.com>
Subject: [RFC PATCH 11/11] loop: Allow priveleged operations for root in the namespace which owns a device
Date: Wed, 14 May 2014 16:34:59 -0500
Message-Id: <1400103299-144589-12-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1400103299-144589-1-git-send-email-seth.forshee@canonical.com>
References: <1400103299-144589-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/block/loop.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 66bd938bcc1c..2cc19868ea0d 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1074,7 +1074,7 @@ loop_set_status(struct loop_device *lo, const struct loop_info64 *info)
 
 	if (lo->lo_encrypt_key_size &&
 	    !uid_eq(lo->lo_key_owner, uid) &&
-	    !capable(CAP_SYS_ADMIN))
+	    !ns_capable(disk_to_dev(lo->lo_disk)->ns, CAP_SYS_ADMIN))
 		return -EPERM;
 	if (lo->lo_state != Lo_bound)
 		return -ENXIO;
@@ -1164,7 +1164,8 @@ loop_get_status(struct loop_device *lo, struct loop_info64 *info)
 	memcpy(info->lo_crypt_name, lo->lo_crypt_name, LO_NAME_SIZE);
 	info->lo_encrypt_type =
 		lo->lo_encryption ? lo->lo_encryption->number : 0;
-	if (lo->lo_encrypt_key_size && capable(CAP_SYS_ADMIN)) {
+	if (lo->lo_encrypt_key_size &&
+	    ns_capable(disk_to_dev(lo->lo_disk)->ns, CAP_SYS_ADMIN)) {
 		info->lo_encrypt_key_size = lo->lo_encrypt_key_size;
 		memcpy(info->lo_encrypt_key, lo->lo_encrypt_key,
 		       lo->lo_encrypt_key_size);
@@ -1309,7 +1310,8 @@ static int lo_ioctl(struct block_device *bdev, fmode_t mode,
 		break;
 	case LOOP_SET_STATUS:
 		err = -EPERM;
-		if ((mode & FMODE_WRITE) || capable(CAP_SYS_ADMIN))
+		if ((mode & FMODE_WRITE) ||
+		    ns_capable(disk_to_dev(lo->lo_disk)->ns, CAP_SYS_ADMIN))
 			err = loop_set_status_old(lo,
 					(struct loop_info __user *)arg);
 		break;
@@ -1318,7 +1320,8 @@ static int lo_ioctl(struct block_device *bdev, fmode_t mode,
 		break;
 	case LOOP_SET_STATUS64:
 		err = -EPERM;
-		if ((mode & FMODE_WRITE) || capable(CAP_SYS_ADMIN))
+		if ((mode & FMODE_WRITE) ||
+		    ns_capable(disk_to_dev(lo->lo_disk)->ns, CAP_SYS_ADMIN))
 			err = loop_set_status64(lo,
 					(struct loop_info64 __user *) arg);
 		break;
@@ -1327,7 +1330,8 @@ static int lo_ioctl(struct block_device *bdev, fmode_t mode,
 		break;
 	case LOOP_SET_CAPACITY:
 		err = -EPERM;
-		if ((mode & FMODE_WRITE) || capable(CAP_SYS_ADMIN))
+		if ((mode & FMODE_WRITE) ||
+		    ns_capable(disk_to_dev(lo->lo_disk)->ns, CAP_SYS_ADMIN))
 			err = loop_set_capacity(lo, bdev);
 		break;
 	default:
-- 
1.9.1

