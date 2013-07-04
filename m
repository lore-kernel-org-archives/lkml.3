Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933025Ab3GDJzQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 05:55:16 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:49465 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755123Ab3GDJyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 05:54:41 -0400
From: Serban Constantinescu <serban.constantinescu@arm.com>
To: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        kernel-team@android.com, arve@android.com, john.stultz@linaro.org,
        Dave.Butcher@arm.com
Cc: Serban Constantinescu <serban.constantinescu@arm.com>
Subject: [PATCH v6 4/6] staging: android: binder: fix alignment issues
Date: Thu,  4 Jul 2013 10:54:46 +0100
Message-Id: <1372931688-18553-5-git-send-email-serban.constantinescu@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1372931688-18553-1-git-send-email-serban.constantinescu@arm.com>
References: <1372931688-18553-1-git-send-email-serban.constantinescu@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
Acked-by: Arve Hjønnevåg <arve@android.com>
---
 drivers/staging/android/binder.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index ce70909..7450d56 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
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

