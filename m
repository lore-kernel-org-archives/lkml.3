Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582AbaFXN2i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 09:28:38 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:37855 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbaFXN2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 09:28:37 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-7f-53a97d0151de
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org, viro@zeniv.linux.org.uk
Cc: linux-kernel@vger.kernel.org, dmitry.kasatkin@gmail.com,
        Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH 1/1] ima: fix fallback to use new_sync_read()
Date: Tue, 24 Jun 2014 16:27:19 +0300
Message-id: <ffb4808ed8ce0dddbc96c566ccca2c9b39005643.1403616439.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMJMWRmVeSWpSXmKPExsVy+t/xq7qMtSuDDfqPmFrc+ruX2eLL0jqL
	lzPmsVtc3jWHzeJDzyM2i/N/j7NafFoxidmB3WPnrLvsHg8ObWbx2L3gM5NH35ZVjB6fN8l5
	bHrylimALYrLJiU1J7MstUjfLoErY+7qOawFa7grLs/dw9jAuI2zi5GTQ0LAROL3hl0sELaY
	xIV769m6GLk4hASWMkqcnzwDyulkklj9r5URpIpNQE9iQ/MPdpCEiEAro8SSr0vAEswC6RKf
	JvWyg9jCArYSa75vYQKxWQRUJXr6OlhBbF6BOIkf/dvZINbJSZw8Npl1AiP3AkaGVYyiqaXJ
	BcVJ6blGesWJucWleel6yfm5mxghAfN1B+PSY1aHGAU4GJV4eCt2rAgWYk0sK67MPcQowcGs
	JML7JW5lsBBvSmJlVWpRfnxRaU5q8SFGJg5OqQbGxr4NCaK1V/XuZJYe+Hqj7PzVu0+8dI2X
	O3seOaL8Wqf74YnnFoJzLBy3dyhX/Hc23/2kMHx205f5ddJPw8I7XDmstu/0Ff9h0dE/ab52
	qaN9WWd7pfpsp9TmY9xRwudLnoWFvjnJJCdwbtLFeO1TYipCU+f+Vc9fp7yqqrArPrcgoS7v
	UZYSS3FGoqEWc1FxIgAm5Hes9gEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16 commit aad4f8bb42af06371aa0e85bf0cd9d52c0494985
'switch simple generic_file_aio_read() users to ->read_iter()'
replaced ->aio_read with ->read_iter in most of the file systems
and introduced new_sync_read() as a replacement for do_sync_read().

Most of file systems set '->read' and ima_kernel_read is not affected.
When ->read is not set, this patch adopts fallback call changes from the
vfs_read.

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 security/integrity/ima/ima_crypto.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
index ccd0ac8..b126a78 100644
--- a/security/integrity/ima/ima_crypto.c
+++ b/security/integrity/ima/ima_crypto.c
@@ -40,19 +40,19 @@ static int ima_kernel_read(struct file *file, loff_t offset,
 {
 	mm_segment_t old_fs;
 	char __user *buf = addr;
-	ssize_t ret;
+	ssize_t ret = -EINVAL;
 
 	if (!(file->f_mode & FMODE_READ))
 		return -EBADF;
-	if (!file->f_op->read && !file->f_op->aio_read)
-		return -EINVAL;
 
 	old_fs = get_fs();
 	set_fs(get_ds());
 	if (file->f_op->read)
 		ret = file->f_op->read(file, buf, count, &offset);
-	else
+	else if (file->f_op->aio_read)
 		ret = do_sync_read(file, buf, count, &offset);
+	else if (file->f_op->read_iter)
+		ret = new_sync_read(file, buf, count, &offset);
 	set_fs(old_fs);
 	return ret;
 }
-- 
1.9.1

