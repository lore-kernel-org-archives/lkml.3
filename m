Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754922AbaJ1Dkg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 23:40:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44826 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754871AbaJ1Dkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:40:31 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dmitry Kasatkin <d.kasatkin@samsung.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: [PATCH 3.17 117/146] ima: fix fallback to use new_sync_read()
Date: Tue, 28 Oct 2014 11:34:19 +0800
Message-Id: <20141028033348.514713819@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033343.441992423@linuxfoundation.org>
References: <20141028033343.441992423@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Kasatkin <d.kasatkin@samsung.com>

commit 27cd1fc3ae5374a4a86662c67033f15ef27b2461 upstream.

3.16 commit aad4f8bb42af06371aa0e85bf0cd9d52c0494985
'switch simple generic_file_aio_read() users to ->read_iter()'
replaced ->aio_read with ->read_iter in most of the file systems
and introduced new_sync_read() as a replacement for do_sync_read().

Most of file systems set '->read' and ima_kernel_read is not affected.
When ->read is not set, this patch adopts fallback call changes from the
vfs_read.

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 security/integrity/ima/ima_crypto.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/security/integrity/ima/ima_crypto.c
+++ b/security/integrity/ima/ima_crypto.c
@@ -80,19 +80,19 @@ static int ima_kernel_read(struct file *
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


