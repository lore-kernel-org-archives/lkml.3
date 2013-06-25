Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751706Ab3FYJEJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 05:04:09 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:33310 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219Ab3FYJEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 05:04:05 -0400
Subject: [PATCH v2] pstore: Fail to unlink if a driver has not defined
 pstore_erase
To: tony.luck@intel.com, linux-kernel@vger.kernel.org
From: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
Cc: jkenisto@linux.vnet.ibm.com, ananth@in.ibm.com, mahesh@linux.vnet.ibm.com,
        cbouatmailru@gmail.com, ccross@android.com, keescook@chromium.org
Date: Tue, 25 Jun 2013 14:33:56 +0530
Message-ID: <20130625090253.26584.65072.stgit@aruna-ThinkPad-T420>
User-Agent: StGit/0.16-41-gd1dd
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062508-5564-0000-0000-000008815226
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pstore_erase is used to erase the record from the persistent store.
So if a driver has not defined pstore_erase callback return
-EPERM instead of unlinking a file as deleting the file without
erasing its record in persistent store will give a wrong impression
to customers.

Signed-off-by: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
---
Changes from v1:
	Fix error return value

 fs/pstore/inode.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
index e4bcb2c..bfd95bf 100644
--- a/fs/pstore/inode.c
+++ b/fs/pstore/inode.c
@@ -178,6 +178,8 @@ static int pstore_unlink(struct inode *dir, struct dentry *dentry)
 	if (p->psi->erase)
 		p->psi->erase(p->type, p->id, p->count,
 			      dentry->d_inode->i_ctime, p->psi);
+	else
+		return -EPERM;
 
 	return simple_unlink(dir, dentry);
 }

