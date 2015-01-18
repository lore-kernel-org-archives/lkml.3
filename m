Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975AbbARHo7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 02:44:59 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:44233 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbbARHo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 02:44:58 -0500
From: Tristan Lelong <tristan@lelong.xyz>
To: gregkh@linuxfoundation.org
Cc: oleg.drokin@intel.com, andreas.dilger@intel.com, askb23@gmail.com,
        john.hammond@intel.com, gdonald@gmail.com, anhlq2110@gmail.com,
        fabio.falzoi84@gmail.com, oort10@gmail.com, agimenez@sysvalve.es,
        rupran@einserver.de, surya.seetharaman9@gmail.com,
        Julia.Lawall@lip6.fr, joe@perches.com, a.terekhov@gmail.com,
        liang.zhen@intel.com, vthakkar1994@gmail.com, amk@cray.com,
        srikrishanmalik@gmail.com, rd@radekdostal.com, bergwolf@gmail.com,
        dan.carpenter@oracle.com, paul.gortmaker@windriver.com,
        tapaswenipathak@gmail.com, email@chrisccphjaeger.info,
        uja.ornl@gmail.com, brillianccv@inbox.ru, dmitry.eremin@intel.com,
        HPDD-discuss@ml01.01.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Tristan Lelong <tristan@lelong.xyz>
Subject: [PATCH] staging: lustre: remove kmalloc from fld_proc_hash_seq_write
Date: Sat, 17 Jan 2015 23:44:49 -0800
Message-Id: <1421567089-7907-1-git-send-email-tristan@lelong.xyz>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch simplifies the fld_proc_hash_seq_write function
by removing the dynamic memory allocation.
The longest fh_name used so far in lustre is 4 characters.
We use a 8 bytes variable to be on the safe side.

Signed-off-by: Tristan Lelong <tristan@lelong.xyz>
---
Hi Greg,
 
This patch is a rework of "staging: lustre: fix sparse warning on LPROC_SEQ_FOPS macros" v3.
It applies on top of your latest staging-testing branch.

Regards
---
 drivers/staging/lustre/lustre/fld/lproc_fld.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/lustre/lustre/fld/lproc_fld.c b/drivers/staging/lustre/lustre/fld/lproc_fld.c
index 74b4db9..9b26bb5 100644
--- a/drivers/staging/lustre/lustre/fld/lproc_fld.c
+++ b/drivers/staging/lustre/lustre/fld/lproc_fld.c
@@ -93,17 +93,13 @@ fld_proc_hash_seq_write(struct file *file,
 {
 	struct lu_client_fld *fld;
 	struct lu_fld_hash *hash = NULL;
-	char *name;
+	char fh_name[8];
 	int i;
 
-	if (count > 80)
+	if (count > sizeof(fh_name))
 		return -ENAMETOOLONG;
 
-	name = kmalloc(count, GFP_KERNEL);
-	if (!name)
-		return -ENOMEM;
-
-	if (copy_from_user(name, buffer, count) != 0)
+	if (copy_from_user(fh_name, buffer, count) != 0)
 		return -EFAULT;
 
 	fld = ((struct seq_file *)file->private_data)->private;
@@ -113,7 +109,7 @@ fld_proc_hash_seq_write(struct file *file,
 		if (count != strlen(fld_hash[i].fh_name))
 			continue;
 
-		if (!strncmp(fld_hash[i].fh_name, name, count)) {
+		if (!strncmp(fld_hash[i].fh_name, fh_name, count)) {
 			hash = &fld_hash[i];
 			break;
 		}
@@ -128,7 +124,6 @@ fld_proc_hash_seq_write(struct file *file,
 		       fld->lcf_name, hash->fh_name);
 	}
 
-	kfree(name);
 	return count;
 }
 
-- 
2.1.3

