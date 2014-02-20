Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271AbaBTKQB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 05:16:01 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:61595 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbaBTKP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 05:15:59 -0500
MIME-Version: 1.0
Date: Thu, 20 Feb 2014 15:45:56 +0530
Message-ID: <CABPv_jf7Sy26C=LUzFkYyDSFrvtk05Snv-PQJEu2fpm5dhJWrQ@mail.gmail.com>
Subject: [PATCH] smack lsm bug fixes
From: Pankaj Kumar <pankaj13lvs3@gmail.com>
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        casey@schaufler-ca.com
Cc: pankaj.k2@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pankaj Kumar <pankaj.k2@samsung.com>

1. In order to remove any SMACK extended attribute from a file, a user
should have CAP_MAC_ADMIN capability. But any user without this
capability is able to remove SMACK64MMAP security attribute. This error
has been corrected by a modification in smack_inode_removexattr hook.

2. While setting extended attribute in smack_inode_setsecurity hook,
'-EACCES' error is returned if extended attribute size or value is not
correct. This is wrong error rather this is invalid extended attribute
case. Corrected error '-EINVAL' shall be returned.

Signed-off-by: Pankaj Kumar <pankaj.k2@samsung.com>
Signed-off-by: Himanshu Shukla <himanshu.sh@samsung.com>
---
 security/smack/smack_lsm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 14f52be..e1b1650 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -938,7 +938,7 @@ static int smack_inode_removexattr(struct dentry
*dentry, const char *name)
         strcmp(name, XATTR_NAME_SMACKIPOUT) == 0 ||
         strcmp(name, XATTR_NAME_SMACKEXEC) == 0 ||
         strcmp(name, XATTR_NAME_SMACKTRANSMUTE) == 0 ||
-        strcmp(name, XATTR_NAME_SMACKMMAP)) {
+        strcmp(name, XATTR_NAME_SMACKMMAP) == 0) {
         if (!smack_privileged(CAP_MAC_ADMIN))
             rc = -EPERM;
     } else
@@ -2076,7 +2076,7 @@ static int smack_inode_setsecurity(struct inode
*inode, const char *name,
     int rc = 0;

     if (value == NULL || size > SMK_LONGLABEL || size == 0)
-        return -EACCES;
+        return -EINVAL;

     skp = smk_import_entry(value, size);
     if (skp == NULL)
-- 
1.8.1.2
