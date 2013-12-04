Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933121Ab3LDSNo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 13:13:44 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:52526 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933104Ab3LDSNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 13:13:40 -0500
From: Serban Constantinescu <serban.constantinescu@arm.com>
To: gregkh@linuxfoundation.org, arve@android.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, john.stultz@linaro.org,
        ccross@android.com, Dave.Butcher@arm.com, irogers@google.com,
        romlem@android.com
Cc: Serban Constantinescu <serban.constantinescu@arm.com>
Subject: [PATCH v1 6/9] staging: android: binder: Add size_helper() macro
Date: Wed,  4 Dec 2013 18:09:38 +0000
Message-Id: <1386180581-6710-7-git-send-email-serban.constantinescu@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386180581-6710-1-git-send-email-serban.constantinescu@arm.com>
References: <1386180581-6710-1-git-send-email-serban.constantinescu@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds size_helper() macro that will be used for indexing into
different buffers on 64bit systems where the size of particular
structures will differ depending on the userspace used (32bit /64bit).

This patch is a temporary patch that will be extended with 32bit compat
handling.

Signed-off-by: Serban Constantinescu <serban.constantinescu@arm.com>
---
 drivers/staging/android/binder.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index 95c2581..6d22717 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -142,6 +142,7 @@ module_param_call(stop_on_user_error, binder_set_stop_on_user_error,
 
 #define align_helper(ptr)	    ALIGN(ptr, sizeof(void *))
 #define deref_helper(ptr)	    (*(typeof(size_t *))ptr)
+#define size_helper(x)		    sizeof(x)
 
 enum binder_stat_types {
 	BINDER_STAT_PROC,
@@ -1247,10 +1248,10 @@ static void binder_transaction_buffer_release(struct binder_proc *proc,
 		off_end = failed_at;
 	else
 		off_end = (void *)offp + buffer->offsets_size;
-	for (; offp < off_end; offp += sizeof(size_t)) {
+	for (; offp < off_end; offp += size_helper(size_t)) {
 		struct flat_binder_object *fp;
-		if (deref_helper(offp) > buffer->data_size - sizeof(*fp) ||
-		    buffer->data_size < sizeof(*fp) ||
+		if (deref_helper(offp) > buffer->data_size - size_helper(*fp) ||
+		    buffer->data_size < size_helper(*fp) ||
 		    !IS_ALIGNED(deref_helper(offp), sizeof(u32))) {
 			pr_err("transaction release %d bad offset %zd, size %zd\n",
 			 debug_id, deref_helper(offp), buffer->data_size);
@@ -1489,17 +1490,17 @@ static void binder_transaction(struct binder_proc *proc,
 		return_error = BR_FAILED_REPLY;
 		goto err_copy_data_failed;
 	}
-	if (!IS_ALIGNED(tr->offsets_size, sizeof(size_t))) {
+	if (!IS_ALIGNED(tr->offsets_size, size_helper(size_t))) {
 		binder_user_error("%d:%d got transaction with invalid offsets size, %zd\n",
 				proc->pid, thread->pid, tr->offsets_size);
 		return_error = BR_FAILED_REPLY;
 		goto err_bad_offset;
 	}
 	off_end = (void *)offp + tr->offsets_size;
-	for (; offp < off_end; offp += sizeof(size_t)) {
+	for (; offp < off_end; offp += size_helper(size_t)) {
 		struct flat_binder_object *fp;
-		if (deref_helper(offp) > t->buffer->data_size - sizeof(*fp) ||
-		    t->buffer->data_size < sizeof(*fp) ||
+		if (deref_helper(offp) > t->buffer->data_size - size_helper(*fp) ||
+		    t->buffer->data_size < size_helper(*fp) ||
 		    !IS_ALIGNED(deref_helper(offp), sizeof(u32))) {
 			binder_user_error("%d:%d got transaction with invalid offset, %zd\n",
 					proc->pid, thread->pid, deref_helper(offp));
@@ -2229,7 +2230,7 @@ retry:
 			break;
 		}
 
-		if (end - ptr < sizeof(tr) + 4)
+		if (end - ptr < size_helper(tr) + 4)
 			break;
 
 		switch (w->type) {
-- 
1.7.9.5

