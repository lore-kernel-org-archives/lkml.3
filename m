Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524Ab3LMWb6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:31:58 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:32973 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754113Ab3LMW2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:28:10 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        Rom Lemarchand <romlem@google.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 079/115] ion: add new ion_user_handle_t type for the user-space token
Date: Fri, 13 Dec 2013 14:24:53 -0800
Message-Id: <1386973529-4884-80-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rom Lemarchand <romlem@google.com>

Declare new ion_user_handle_t type to contain the token returned to user-space.
This allows a 2-step migration of the user-space code to a new kernel header
first, then will allow us to change the definition of the ion_user_handle_type_t
to int without breaking the API.

Signed-off-by: Rom Lemarchand <romlem@google.com>
(cherry picked from commit ebb8269bbb05b06ecedca3e21b3e65f23d48eadd)
[jstultz: modified patch to apply to staging directory]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion.c | 4 ++--
 drivers/staging/android/ion/ion.h | 8 +++++---
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index 273ec3a..e2a3033 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -1139,7 +1139,7 @@ static long ion_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		if (IS_ERR(handle))
 			return PTR_ERR(handle);
 
-		data.handle = (struct ion_handle *)handle->id;
+		data.handle = (ion_user_handle_t)handle->id;
 
 		if (copy_to_user((void __user *)arg, &data, sizeof(data))) {
 			ion_free(client, handle);
@@ -1191,7 +1191,7 @@ static long ion_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		if (IS_ERR(handle))
 			ret = PTR_ERR(handle);
 		else
-			data.handle = (struct ion_handle *)handle->id;
+			data.handle = (ion_user_handle_t)handle->id;
 
 		if (copy_to_user((void __user *)arg, &data,
 				 sizeof(struct ion_fd_data)))
diff --git a/drivers/staging/android/ion/ion.h b/drivers/staging/android/ion/ion.h
index 3942b3e..244f085 100644
--- a/drivers/staging/android/ion/ion.h
+++ b/drivers/staging/android/ion/ion.h
@@ -20,6 +20,8 @@
 #include <linux/types.h>
 
 struct ion_handle;
+typedef struct ion_handle *ion_user_handle_t;
+
 /**
  * enum ion_heap_types - list of all possible types of heaps
  * @ION_HEAP_TYPE_SYSTEM:	 memory allocated via vmalloc
@@ -268,7 +270,7 @@ struct ion_allocation_data {
 	size_t align;
 	unsigned int heap_id_mask;
 	unsigned int flags;
-	struct ion_handle *handle;
+	ion_user_handle_t handle;
 };
 
 /**
@@ -282,7 +284,7 @@ struct ion_allocation_data {
  * provides the file descriptor and the kernel returns the handle.
  */
 struct ion_fd_data {
-	struct ion_handle *handle;
+	ion_user_handle_t handle;
 	int fd;
 };
 
@@ -291,7 +293,7 @@ struct ion_fd_data {
  * @handle:	a handle
  */
 struct ion_handle_data {
-	struct ion_handle *handle;
+	ion_user_handle_t handle;
 };
 
 /**
-- 
1.8.3.2

