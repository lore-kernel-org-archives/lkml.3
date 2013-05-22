Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888Ab3EVKNV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 06:13:21 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:35565 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755001Ab3EVKNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 06:13:16 -0400
From: Serban Constantinescu <serban.constantinescu@arm.com>
To: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        kernel-team@android.com, arve@android.com, john.stultz@linaro.org,
        Dave.Butcher@arm.com
Cc: Serban Constantinescu <serban.constantinescu@arm.com>
Subject: [PATCH v4 1/6] staging: android: binder: modify struct binder_write_read to use size_t
Date: Wed, 22 May 2013 11:12:56 +0100
Message-Id: <1369217581-16285-2-git-send-email-serban.constantinescu@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1369217581-16285-1-git-send-email-serban.constantinescu@arm.com>
References: <1369217581-16285-1-git-send-email-serban.constantinescu@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change mirrors the userspace operation where struct binder_write_read
members that specify the buffer size and consumed size are size_t elements.

The patch also fixes the binder_thread_write() and binder_thread_read()
functions prototypes to conform with the definition of binder_write_read.

The changes do not affect existing 32bit ABI.

Signed-off-by: Serban Constantinescu <serban.constantinescu@arm.com>
---
 drivers/staging/android/binder.c |   10 +++++-----
 drivers/staging/android/binder.h |    8 ++++----
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index 1567ac2..ce70909 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -1700,7 +1700,7 @@ err_no_context_mgr_node:
 }
 
 int binder_thread_write(struct binder_proc *proc, struct binder_thread *thread,
-			void __user *buffer, int size, signed long *consumed)
+			void __user *buffer, size_t size, size_t *consumed)
 {
 	uint32_t cmd;
 	void __user *ptr = buffer + *consumed;
@@ -2080,8 +2080,8 @@ static int binder_has_thread_work(struct binder_thread *thread)
 
 static int binder_thread_read(struct binder_proc *proc,
 			      struct binder_thread *thread,
-			      void  __user *buffer, int size,
-			      signed long *consumed, int non_block)
+			      void  __user *buffer, size_t size,
+			      size_t *consumed, int non_block)
 {
 	void __user *ptr = buffer + *consumed;
 	void __user *end = buffer + size;
@@ -2578,7 +2578,7 @@ static long binder_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 			goto err;
 		}
 		binder_debug(BINDER_DEBUG_READ_WRITE,
-			     "%d:%d write %ld at %08lx, read %ld at %08lx\n",
+			     "%d:%d write %zd at %08lx, read %zd at %08lx\n",
 			     proc->pid, thread->pid, bwr.write_size,
 			     bwr.write_buffer, bwr.read_size, bwr.read_buffer);
 
@@ -2604,7 +2604,7 @@ static long binder_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 			}
 		}
 		binder_debug(BINDER_DEBUG_READ_WRITE,
-			     "%d:%d wrote %ld of %ld, read return %ld of %ld\n",
+			     "%d:%d wrote %zd of %zd, read return %zd of %zd\n",
 			     proc->pid, thread->pid, bwr.write_consumed, bwr.write_size,
 			     bwr.read_consumed, bwr.read_size);
 		if (copy_to_user(ubuf, &bwr, sizeof(bwr))) {
diff --git a/drivers/staging/android/binder.h b/drivers/staging/android/binder.h
index dbe81ce..edab249 100644
--- a/drivers/staging/android/binder.h
+++ b/drivers/staging/android/binder.h
@@ -67,11 +67,11 @@ struct flat_binder_object {
  */
 
 struct binder_write_read {
-	signed long	write_size;	/* bytes to write */
-	signed long	write_consumed;	/* bytes consumed by driver */
+	size_t write_size;	/* bytes to write */
+	size_t write_consumed;	/* bytes consumed by driver */
 	unsigned long	write_buffer;
-	signed long	read_size;	/* bytes to read */
-	signed long	read_consumed;	/* bytes consumed by driver */
+	size_t read_size;	/* bytes to read */
+	size_t read_consumed;	/* bytes consumed by driver */
 	unsigned long	read_buffer;
 };
 
-- 
1.7.9.5

