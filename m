Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981Ab3EVKNh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 06:13:37 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:35584 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755001Ab3EVKNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 06:13:34 -0400
From: Serban Constantinescu <serban.constantinescu@arm.com>
To: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        kernel-team@android.com, arve@android.com, john.stultz@linaro.org,
        Dave.Butcher@arm.com
Cc: Serban Constantinescu <serban.constantinescu@arm.com>
Subject: [PATCH v4 5/6] staging: android: binder: fix alignment issues
Date: Wed, 22 May 2013 11:13:00 +0100
Message-Id: <1369217581-16285-6-git-send-email-serban.constantinescu@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1369217581-16285-1-git-send-email-serban.constantinescu@arm.com>
References: <1369217581-16285-1-git-send-email-serban.constantinescu@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Android userspace aligns the data written to the binder buffers to
4bytes. Thus for 32bit platforms or 64bit platforms running an 32bit
Android userspace we can have a buffer looking like this:

platform    buffer(binder_cmd   pointer)      size
32/32                 32b         32b          8B
64/32                 32b         64b          12B
64/64                 32b         64b          12B

Thus the kernel needs to check that the buffer size is aligned to 4bytes
not to (void *) that will be 8bytes on 64bit machines.

The patch also fixes the alignment issues for the offsets buffer, where
on 64bit systems, if the data_size is not aligned to 8bytes the offset's
start address will be incorrectly calculated.

The change does not affect existing 32bit ABI.

Signed-off-by: Serban Constantinescu <serban.constantinescu@arm.com>
---
 drivers/staging/android/binder.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index ca79084..72f5bb9 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -658,8 +658,8 @@ static struct binder_buffer *binder_alloc_buf(struct binder_proc *proc,
 		return NULL;
 	}
 
-	size = ALIGN(data_size, sizeof(void *)) +
-		ALIGN(offsets_size, sizeof(void *));
+	size = ALIGN(data_size, sizeof(u32)) +
+		ALIGN(offsets_size, sizeof(u32));
 
 	if (size < data_size || size < offsets_size) {
 		binder_user_error("%d: got transaction with invalid size %zd-%zd\n",
@@ -807,8 +807,8 @@ static void binder_free_buf(struct binder_proc *proc,
 
 	buffer_size = binder_buffer_size(proc, buffer);
 
-	size = ALIGN(buffer->data_size, sizeof(void *)) +
-		ALIGN(buffer->offsets_size, sizeof(void *));
+	size = ALIGN(buffer->data_size, sizeof(u32)) +
+		ALIGN(buffer->offsets_size, sizeof(u32));
 
 	binder_debug(BINDER_DEBUG_BUFFER_ALLOC,
 		     "%d: binder_free_buf %p size %zd buffer_size %zd\n",
@@ -1238,7 +1238,7 @@ static void binder_transaction_buffer_release(struct binder_proc *proc,
 	if (buffer->target_node)
 		binder_dec_node(buffer->target_node, 1, 0);
 
-	offp = (size_t *)(buffer->data + ALIGN(buffer->data_size, sizeof(void *)));
+	offp = (size_t *)(buffer->data + ALIGN(buffer->data_size, sizeof(u32)));
 	if (failed_at)
 		off_end = failed_at;
 	else
@@ -1247,7 +1247,7 @@ static void binder_transaction_buffer_release(struct binder_proc *proc,
 		struct flat_binder_object *fp;
 		if (*offp > buffer->data_size - sizeof(*fp) ||
 		    buffer->data_size < sizeof(*fp) ||
-		    !IS_ALIGNED(*offp, sizeof(void *))) {
+		    !IS_ALIGNED(*offp, sizeof(u32))) {
 			pr_err("transaction release %d bad offset %zd, size %zd\n",
 			 debug_id, *offp, buffer->data_size);
 			continue;
@@ -1471,7 +1471,7 @@ static void binder_transaction(struct binder_proc *proc,
 	if (target_node)
 		binder_inc_node(target_node, 1, 0, NULL);
 
-	offp = (size_t *)(t->buffer->data + ALIGN(tr->data_size, sizeof(void *)));
+	offp = (size_t *)(t->buffer->data + ALIGN(tr->data_size, sizeof(u32)));
 
 	if (copy_from_user(t->buffer->data, tr->data.ptr.buffer, tr->data_size)) {
 		binder_user_error("%d:%d got transaction with invalid data ptr\n",
@@ -1496,7 +1496,7 @@ static void binder_transaction(struct binder_proc *proc,
 		struct flat_binder_object *fp;
 		if (*offp > t->buffer->data_size - sizeof(*fp) ||
 		    t->buffer->data_size < sizeof(*fp) ||
-		    !IS_ALIGNED(*offp, sizeof(void *))) {
+		    !IS_ALIGNED(*offp, sizeof(u32))) {
 			binder_user_error("%d:%d got transaction with invalid offset, %zd\n",
 					proc->pid, thread->pid, *offp);
 			return_error = BR_FAILED_REPLY;
@@ -2332,7 +2332,7 @@ retry:
 					proc->user_buffer_offset;
 		tr.data.ptr.offsets = tr.data.ptr.buffer +
 					ALIGN(t->buffer->data_size,
-					    sizeof(void *));
+					    sizeof(u32));
 
 		if (put_user(cmd, (uint32_t __user *)ptr))
 			return -EFAULT;
-- 
1.7.9.5

