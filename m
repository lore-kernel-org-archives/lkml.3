Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213Ab3EJK3t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 06:29:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39790 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750867Ab3EJK3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 06:29:47 -0400
From: Lingzhu Xiang <lxiang@redhat.com>
To: Matt Fleming <matt.fleming@intel.com>, Jeremy Kerr <jk@ozlabs.org>,
        Matthew Garrett <matthew.garrett@nebula.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Josh Boyer <jwboyer@redhat.com>, "Lee, Chun-Yi" <jlee@suse.com>,
        Andy Whitcroft <apw@canonical.com>
Subject: [PATCH] efivarfs: Never return ENOENT from firmware again
Date: Fri, 10 May 2013 18:29:21 +0800
Message-Id: <5b6476bf31dc699a0e6f3983e78447eeac34d831.1368180585.git.lxiang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously in 1fa7e69 efi_status_to_err() translated firmware status
EFI_NOT_FOUND to -EIO instead of -ENOENT for efivarfs operations to
avoid confusion. After refactoring in e14ab23, it is also used in other
places where the translation may be unnecessary.

So move the translation to efivarfs specific code. Also return EOF
for reading zero-length files, which is what users would expect.

Cc: Josh Boyer <jwboyer@redhat.com>
Cc: Jeremy Kerr <jk@ozlabs.org>
Cc: Lee, Chun-Yi <jlee@suse.com>
Cc: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Lingzhu Xiang <lxiang@redhat.com>
---
This is to be applied against mainline or Matt Fleming's chainsaw branch.

 fs/efivarfs/file.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/efivarfs/file.c b/fs/efivarfs/file.c
index bfb5315..8dd524f 100644
--- a/fs/efivarfs/file.c
+++ b/fs/efivarfs/file.c
@@ -44,8 +44,11 @@ static ssize_t efivarfs_file_write(struct file *file,
 
 	bytes = efivar_entry_set_get_size(var, attributes, &datasize,
 					  data, &set);
-	if (!set && bytes)
+	if (!set && bytes) {
+		if (bytes == -ENOENT)
+			bytes = -EIO;
 		goto out;
+	}
 
 	if (bytes == -ENOENT) {
 		drop_nlink(inode);
@@ -76,7 +79,14 @@ static ssize_t efivarfs_file_read(struct file *file, char __user *userbuf,
 	int err;
 
 	err = efivar_entry_size(var, &datasize);
-	if (err)
+
+	/*
+	 * efivarfs represents uncommitted variables with
+	 * zero-length files. Reading them should return EOF.
+	 */
+	if (err == -ENOENT)
+		return 0;
+	else if (err)
 		return err;
 
 	data = kmalloc(datasize + sizeof(attributes), GFP_KERNEL);
-- 
1.7.11.7

