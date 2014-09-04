Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828AbaIDPqT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 11:46:19 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:63325 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140AbaIDPqS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 11:46:18 -0400
From: =?ISO-8859-1?Q?Lo=EFc?= Pellegrino <oort10@gmail.com>
To: oleg.drokin@intel.com, andreas.dilger@intel.com,
        gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH] staging/lustre: Different prototypes between the declaration and the definition
Date: Thu, 04 Sep 2014 16:46:27 +0100
Message-ID: <2564350.JmmVODAHbu@localhost.localdomain>
User-Agent: KMail/4.13.3 (Linux/3.15.10-201.fc20.x86_64; KDE/4.13.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Align the prototype of lprocfs_wr_uint() in the declaration with the one used 
in the definition.

The prototype is:
int lprocfs_wr_uint(struct file *file, const char __user *buffer,
                             unsigned long count, void *data)
In obdclass/lprocfs_status.c

But in lustre/include/lprocfs_status.h, the __user annotation is missing for 
the attribute buffer.

The correct prototype is the first one (the definition) since:
- This function is eventually called by the write() function pointer of an 
instance of struct file_operations
- In this function, buffer is a parameter of copy_from_user()
- Before the commit 73bb1da692d0dc3e93b9c9e29084d6a5dcbc37a6, the declaration 
and the definition had the same prototype, but only the .c has been updated.

Correcting this will remove a sparse error and add sparse warnings.
This is a task of the Eudyptula challenge.

Signed-off-by: Loïc Pellegrino <oort10@gmail.com>

---
 drivers/staging/lustre/lustre/include/lprocfs_status.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/include/lprocfs_status.h b/drivers/staging/lustre/lustre/include/lprocfs_status.h
index 05b5285..ccb6cd4 100644
--- a/drivers/staging/lustre/lustre/include/lprocfs_status.h
+++ b/drivers/staging/lustre/lustre/include/lprocfs_status.h
@@ -611,7 +611,7 @@ extern int lprocfs_rd_atomic(struct seq_file *m, void *data);
 extern int lprocfs_wr_atomic(struct file *file, const char __user *buffer,
 			     unsigned long count, void *data);
 extern int lprocfs_rd_uint(struct seq_file *m, void *data);
-extern int lprocfs_wr_uint(struct file *file, const char *buffer,
+extern int lprocfs_wr_uint(struct file *file, const char __user *buffer,
 			   unsigned long count, void *data);
 extern int lprocfs_rd_uuid(struct seq_file *m, void *data);
 extern int lprocfs_rd_name(struct seq_file *m, void *data);
-- 
1.9.3

