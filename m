Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933230Ab3LDSPb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 13:15:31 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:52508 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933067Ab3LDSNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 13:13:34 -0500
From: Serban Constantinescu <serban.constantinescu@arm.com>
To: gregkh@linuxfoundation.org, arve@android.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, john.stultz@linaro.org,
        ccross@android.com, Dave.Butcher@arm.com, irogers@google.com,
        romlem@android.com
Cc: Serban Constantinescu <serban.constantinescu@arm.com>
Subject: [PATCH v1 4/9] staging: android: binder: Add align_helper() macro
Date: Wed,  4 Dec 2013 18:09:36 +0000
Message-Id: <1386180581-6710-5-git-send-email-serban.constantinescu@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386180581-6710-1-git-send-email-serban.constantinescu@arm.com>
References: <1386180581-6710-1-git-send-email-serban.constantinescu@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds align_helper() macro that will be used for enforcing
the desired alignment on 64bit systems where the alignment will differ
depending on the userspace used (32bit /64bit).

This patch is a temporary patch that will be extended with 32bit compat
handling.

Signed-off-by: Serban Constantinescu <serban.constantinescu@arm.com>
---
 drivers/staging/android/binder.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index 16109cd..6719a53 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -140,6 +140,8 @@ module_param_call(stop_on_user_error, binder_set_stop_on_user_error,
 			binder_stop_on_user_error = 2; \
 	} while (0)
 
+#define align_helper(ptr)	    ALIGN(ptr, sizeof(void *))
+
 enum binder_stat_types {
 	BINDER_STAT_PROC,
 	BINDER_STAT_THREAD,
@@ -1239,7 +1241,7 @@ static void binder_transaction_buffer_release(struct binder_proc *proc,
 	if (buffer->target_node)
 		binder_dec_node(buffer->target_node, 1, 0);
 
-	offp = (size_t *)(buffer->data + ALIGN(buffer->data_size, sizeof(void *)));
+	offp = (size_t *)(buffer->data + align_helper(buffer->data_size));
 	if (failed_at)
 		off_end = failed_at;
 	else
@@ -1472,7 +1474,7 @@ static void binder_transaction(struct binder_proc *proc,
 	if (target_node)
 		binder_inc_node(target_node, 1, 0, NULL);
 
-	offp = (size_t *)(t->buffer->data + ALIGN(tr->data_size, sizeof(void *)));
+	offp = (size_t *)(t->buffer->data + align_helper(tr->data_size));
 
 	if (copy_from_user(t->buffer->data, tr->data.ptr.buffer, tr->data_size)) {
 		binder_user_error("%d:%d got transaction with invalid data ptr\n",
@@ -2378,8 +2380,7 @@ retry:
 		tr.data.ptr.buffer = (void *)t->buffer->data +
 					proc->user_buffer_offset;
 		tr.data.ptr.offsets = tr.data.ptr.buffer +
-					ALIGN(t->buffer->data_size,
-					    sizeof(void *));
+					align_helper(t->buffer->data_size);
 
 		if (binder_copy_to_user(cmd, &tr, &ptr, sizeof(struct binder_transaction_data)))
 			return -EFAULT;
-- 
1.7.9.5

