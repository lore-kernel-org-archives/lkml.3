Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933216Ab3LDSP2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 13:15:28 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:52512 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933069Ab3LDSNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 13:13:35 -0500
From: Serban Constantinescu <serban.constantinescu@arm.com>
To: gregkh@linuxfoundation.org, arve@android.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, john.stultz@linaro.org,
        ccross@android.com, Dave.Butcher@arm.com, irogers@google.com,
        romlem@android.com
Cc: Serban Constantinescu <serban.constantinescu@arm.com>
Subject: [PATCH v1 5/9] staging: android: binder: Add deref_helper() macro
Date: Wed,  4 Dec 2013 18:09:37 +0000
Message-Id: <1386180581-6710-6-git-send-email-serban.constantinescu@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386180581-6710-1-git-send-email-serban.constantinescu@arm.com>
References: <1386180581-6710-1-git-send-email-serban.constantinescu@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a deref_helper() macro that will be used to dereference
the binder offsets on 64bit systems where the offset is either a 32bit
or a 64bit value, depending on the userpace used (32bit /64bit)

This patch is a temporary patch that will be extended with 32bit compat
handling.

Signed-off-by: Serban Constantinescu <serban.constantinescu@arm.com>
---
 drivers/staging/android/binder.c |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index 6719a53..95c2581 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -141,6 +141,7 @@ module_param_call(stop_on_user_error, binder_set_stop_on_user_error,
 	} while (0)
 
 #define align_helper(ptr)	    ALIGN(ptr, sizeof(void *))
+#define deref_helper(ptr)	    (*(typeof(size_t *))ptr)
 
 enum binder_stat_types {
 	BINDER_STAT_PROC,
@@ -1230,7 +1231,7 @@ static void binder_transaction_buffer_release(struct binder_proc *proc,
 					      struct binder_buffer *buffer,
 					      size_t *failed_at)
 {
-	size_t *offp, *off_end;
+	void *offp, *off_end;
 	int debug_id = buffer->debug_id;
 
 	binder_debug(BINDER_DEBUG_TRANSACTION,
@@ -1246,16 +1247,16 @@ static void binder_transaction_buffer_release(struct binder_proc *proc,
 		off_end = failed_at;
 	else
 		off_end = (void *)offp + buffer->offsets_size;
-	for (; offp < off_end; offp++) {
+	for (; offp < off_end; offp += sizeof(size_t)) {
 		struct flat_binder_object *fp;
-		if (*offp > buffer->data_size - sizeof(*fp) ||
+		if (deref_helper(offp) > buffer->data_size - sizeof(*fp) ||
 		    buffer->data_size < sizeof(*fp) ||
-		    !IS_ALIGNED(*offp, sizeof(u32))) {
+		    !IS_ALIGNED(deref_helper(offp), sizeof(u32))) {
 			pr_err("transaction release %d bad offset %zd, size %zd\n",
-			 debug_id, *offp, buffer->data_size);
+			 debug_id, deref_helper(offp), buffer->data_size);
 			continue;
 		}
-		fp = (struct flat_binder_object *)(buffer->data + *offp);
+		fp = (struct flat_binder_object *)(buffer->data + deref_helper(offp));
 		switch (fp->type) {
 		case BINDER_TYPE_BINDER:
 		case BINDER_TYPE_WEAK_BINDER: {
@@ -1305,7 +1306,7 @@ static void binder_transaction(struct binder_proc *proc,
 {
 	struct binder_transaction *t;
 	struct binder_work *tcomplete;
-	size_t *offp, *off_end;
+	void *offp, *off_end;
 	struct binder_proc *target_proc;
 	struct binder_thread *target_thread = NULL;
 	struct binder_node *target_node = NULL;
@@ -1495,17 +1496,17 @@ static void binder_transaction(struct binder_proc *proc,
 		goto err_bad_offset;
 	}
 	off_end = (void *)offp + tr->offsets_size;
-	for (; offp < off_end; offp++) {
+	for (; offp < off_end; offp += sizeof(size_t)) {
 		struct flat_binder_object *fp;
-		if (*offp > t->buffer->data_size - sizeof(*fp) ||
+		if (deref_helper(offp) > t->buffer->data_size - sizeof(*fp) ||
 		    t->buffer->data_size < sizeof(*fp) ||
-		    !IS_ALIGNED(*offp, sizeof(u32))) {
+		    !IS_ALIGNED(deref_helper(offp), sizeof(u32))) {
 			binder_user_error("%d:%d got transaction with invalid offset, %zd\n",
-					proc->pid, thread->pid, *offp);
+					proc->pid, thread->pid, deref_helper(offp));
 			return_error = BR_FAILED_REPLY;
 			goto err_bad_offset;
 		}
-		fp = (struct flat_binder_object *)(t->buffer->data + *offp);
+		fp = (struct flat_binder_object *)(t->buffer->data + deref_helper(offp));
 		switch (fp->type) {
 		case BINDER_TYPE_BINDER:
 		case BINDER_TYPE_WEAK_BINDER: {
-- 
1.7.9.5

