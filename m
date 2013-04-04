Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759984Ab3DDMdq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 08:33:46 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:64435 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759844Ab3DDMcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 08:32:45 -0400
From: Serban Constantinescu <serban.constantinescu@arm.com>
To: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        kernel-team@android.com, arve@android.com, john.stultz@linaro.org,
        Dave.Butcher@arm.com
Cc: Serban Constantinescu <serban.constantinescu@arm.com>
Subject: [PATCH 7/8] staging: android: binder: fix alignment issues
Date: Thu,  4 Apr 2013 13:32:37 +0100
Message-Id: <1365078758-28674-8-git-send-email-serban.constantinescu@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1365078758-28674-1-git-send-email-serban.constantinescu@arm.com>
References: <1365078758-28674-1-git-send-email-serban.constantinescu@arm.com>
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

The change does not affect existing 32bit ABI.

Signed-off-by: Serban Constantinescu <serban.constantinescu@arm.com>
---
 drivers/staging/android/binder.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index a2cdd9e..b5c2b59 100644
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
@@ -1247,7 +1247,7 @@ static void binder_transaction_buffer_release(struct binder_proc *proc,
 		struct flat_binder_object *fp;
 		if (*offp > buffer->data_size - sizeof(*fp) ||
 		    buffer->data_size < sizeof(*fp) ||
-		    !IS_ALIGNED(*offp, sizeof(void *))) {
+		    !IS_ALIGNED(*offp, sizeof(u32))) {
 			pr_err("transaction release %d bad offset %zd, size %zd\n",
 			 debug_id, *offp, buffer->data_size);
 			continue;
@@ -1496,7 +1496,7 @@ static void binder_transaction(struct binder_proc *proc,
 		struct flat_binder_object *fp;
 		if (*offp > t->buffer->data_size - sizeof(*fp) ||
 		    t->buffer->data_size < sizeof(*fp) ||
-		    !IS_ALIGNED(*offp, sizeof(void *))) {
+		    !IS_ALIGNED(*offp, sizeof(u32))) {
 			binder_user_error("%d:%d got transaction with invalid offset, %zd\n",
 					proc->pid, thread->pid, *offp);
 			return_error = BR_FAILED_REPLY;
-- 
1.7.9.5

