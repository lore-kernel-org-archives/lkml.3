Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933187Ab3LDSOP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 13:14:15 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:52515 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933075Ab3LDSNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 13:13:36 -0500
From: Serban Constantinescu <serban.constantinescu@arm.com>
To: gregkh@linuxfoundation.org, arve@android.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, john.stultz@linaro.org,
        ccross@android.com, Dave.Butcher@arm.com, irogers@google.com,
        romlem@android.com
Cc: Serban Constantinescu <serban.constantinescu@arm.com>
Subject: [PATCH v1 7/9] staging: android: binder: Add copy_flat_binder_object()
Date: Wed,  4 Dec 2013 18:09:39 +0000
Message-Id: <1386180581-6710-8-git-send-email-serban.constantinescu@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386180581-6710-1-git-send-email-serban.constantinescu@arm.com>
References: <1386180581-6710-1-git-send-email-serban.constantinescu@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds copy_flat_binder_object macro() that will help
dereference struct flat_binder_object on 64bit systems where the
structure differs between 32bit and 64bit userspace.

This patch is a temporary patch that will be extended with 32bit compat
handling.

Signed-off-by: Serban Constantinescu <serban.constantinescu@arm.com>
---
 drivers/staging/android/binder.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index 6d22717..855d348 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -144,6 +144,11 @@ module_param_call(stop_on_user_error, binder_set_stop_on_user_error,
 #define deref_helper(ptr)	    (*(typeof(size_t *))ptr)
 #define size_helper(x)		    sizeof(x)
 
+static inline struct flat_binder_object *copy_flat_binder_object(void __user *ptr)
+{
+	return (struct flat_binder_object *)ptr;
+}
+
 enum binder_stat_types {
 	BINDER_STAT_PROC,
 	BINDER_STAT_THREAD,
@@ -1257,7 +1262,7 @@ static void binder_transaction_buffer_release(struct binder_proc *proc,
 			 debug_id, deref_helper(offp), buffer->data_size);
 			continue;
 		}
-		fp = (struct flat_binder_object *)(buffer->data + deref_helper(offp));
+		fp = copy_flat_binder_object(buffer->data + deref_helper(offp));
 		switch (fp->type) {
 		case BINDER_TYPE_BINDER:
 		case BINDER_TYPE_WEAK_BINDER: {
@@ -1507,7 +1512,7 @@ static void binder_transaction(struct binder_proc *proc,
 			return_error = BR_FAILED_REPLY;
 			goto err_bad_offset;
 		}
-		fp = (struct flat_binder_object *)(t->buffer->data + deref_helper(offp));
+		fp = copy_flat_binder_object(t->buffer->data + deref_helper(offp));
 		switch (fp->type) {
 		case BINDER_TYPE_BINDER:
 		case BINDER_TYPE_WEAK_BINDER: {
-- 
1.7.9.5

