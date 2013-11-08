Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757340Ab3KHPaR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 10:30:17 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:53788 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752504Ab3KHPaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 10:30:15 -0500
Date: Fri, 8 Nov 2013 15:29:44 +0000
From: Matt Fleming <matt@console-pimps.org>
To: "Geyslan G. Bem" <geyslan@gmail.com>
Cc: kernel-br@googlegroups.com, Matthew Garrett <matthew.garrett@nebula.com>,
        Jeremy Kerr <jk@ozlabs.org>, Matt Fleming <matt.fleming@intel.com>,
        "open list:EFI VARIABLE FILE..." <linux-efi@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] efivarfs: 'efivarfs_file_write' function
 reorganization
Message-ID: <20131108152944.GC22636@console-pimps.org>
References: <1383159461-29668-1-git-send-email-geyslan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383159461-29668-1-git-send-email-geyslan@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Oct, at 03:57:41PM, Geyslan G. Bem wrote:
> This reorganization:
> 
> Removes useless 'bytes' prior assignment.
> 
> Uses 'memdup_user' instead 'kmalloc' + 'copy_from_user'.
> 
> Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
> ---
>  fs/efivarfs/file.c | 13 ++++---------
>  1 file changed, 4 insertions(+), 9 deletions(-)

Thanks, this is what I applied,

---

>From 00ad8da13638dba692eaa58b0cba25f3f1a801b1 Mon Sep 17 00:00:00 2001
From: "Geyslan G. Bem" <geyslan@gmail.com>
Date: Wed, 30 Oct 2013 15:57:41 -0300
Subject: [PATCH] efivarfs: 'efivarfs_file_write' function reorganization

This reorganization removes useless 'bytes' prior assignment and uses
'memdup_user' instead 'kmalloc' + 'copy_from_user'.

Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 fs/efivarfs/file.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/fs/efivarfs/file.c b/fs/efivarfs/file.c
index 8dd524f32284..cdb2971192a5 100644
--- a/fs/efivarfs/file.c
+++ b/fs/efivarfs/file.c
@@ -21,7 +21,7 @@ static ssize_t efivarfs_file_write(struct file *file,
 	u32 attributes;
 	struct inode *inode = file->f_mapping->host;
 	unsigned long datasize = count - sizeof(attributes);
-	ssize_t bytes = 0;
+	ssize_t bytes;
 	bool set = false;
 
 	if (count < sizeof(attributes))
@@ -33,14 +33,9 @@ static ssize_t efivarfs_file_write(struct file *file,
 	if (attributes & ~(EFI_VARIABLE_MASK))
 		return -EINVAL;
 
-	data = kmalloc(datasize, GFP_KERNEL);
-	if (!data)
-		return -ENOMEM;
-
-	if (copy_from_user(data, userbuf + sizeof(attributes), datasize)) {
-		bytes = -EFAULT;
-		goto out;
-	}
+	data = memdup_user(userbuf + sizeof(attributes), datasize);
+	if (IS_ERR(data))
+		return PTR_ERR(data);
 
 	bytes = efivar_entry_set_get_size(var, attributes, &datasize,
 					  data, &set);
-- 
1.8.1.4

-- 
Matt Fleming, Intel Open Source Technology Center
