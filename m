Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483AbaJIATT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 20:19:19 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:42804 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478AbaJIATJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 20:19:09 -0400
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: mpe <mpe@ellerman.id.au>
Cc: greg <greg@kroah.com>, arnd <arnd@arndb.de>,
        benh <benh@kernel.crashing.org>, mikey <mikey@neuling.org>,
        anton <anton@samba.org>, linux-kernel <linux-kernel@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@ozlabs.org>, jk <jk@ozlabs.org>,
        imunsie <imunsie@au1.ibm.com>,
        cbe-oss-dev <cbe-oss-dev@lists.ozlabs.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] CXL: Fix afu_read() not doing finish_wait() on signal or non-blocking
Date: Thu,  9 Oct 2014 11:17:46 +1100
Message-Id: <1412813866-22717-1-git-send-email-imunsie@au.ibm.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1412764803-sup-6790@delenn.ozlabs.ibm.com>
References: <1412764803-sup-6790@delenn.ozlabs.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14100900-0021-0000-0000-0000004F5BB4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

If afu_read() returned due to a signal or the AFU file descriptor being
opened non-blocking it would not call finish_wait() before returning,
which could lead to a crash later when something else wakes up the wait
queue.

This patch restructures the wait logic to ensure that the cleanup is
done correctly.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---

Resending with correct whitespace as my mailer decided to replace tabs with
spaces on the last try.

 drivers/misc/cxl/file.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/misc/cxl/file.c b/drivers/misc/cxl/file.c
index 847b7e6..378b099 100644
--- a/drivers/misc/cxl/file.c
+++ b/drivers/misc/cxl/file.c
@@ -273,6 +273,7 @@ static ssize_t afu_read(struct file *file, char __user *buf, size_t count,
 	struct cxl_context *ctx = file->private_data;
 	struct cxl_event event;
 	unsigned long flags;
+	int rc;
 	DEFINE_WAIT(wait);
 
 	if (count < CXL_READ_MIN_SIZE)
@@ -285,13 +286,17 @@ static ssize_t afu_read(struct file *file, char __user *buf, size_t count,
 		if (ctx_event_pending(ctx))
 			break;
 
-		spin_unlock_irqrestore(&ctx->lock, flags);
-		if (file->f_flags & O_NONBLOCK)
-			return -EAGAIN;
+		if (file->f_flags & O_NONBLOCK) {
+			rc = -EAGAIN;
+			goto out;
+		}
 
-		if (signal_pending(current))
-			return -ERESTARTSYS;
+		if (signal_pending(current)) {
+			rc = -ERESTARTSYS;
+			goto out;
+		}
 
+		spin_unlock_irqrestore(&ctx->lock, flags);
 		pr_devel("afu_read going to sleep...\n");
 		schedule();
 		pr_devel("afu_read woken up\n");
@@ -336,6 +341,11 @@ static ssize_t afu_read(struct file *file, char __user *buf, size_t count,
 	if (copy_to_user(buf, &event, event.header.size))
 		return -EFAULT;
 	return event.header.size;
+
+out:
+	finish_wait(&ctx->wq, &wait);
+	spin_unlock_irqrestore(&ctx->lock, flags);
+	return rc;
 }
 
 static const struct file_operations afu_fops = {
-- 
2.1.0

