Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964AbaBQV7y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 16:59:54 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:50597 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843AbaBQV7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 16:59:08 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Serban Constantinescu <serban.constantinescu@arm.com>,
        Greg KH <gregkh@linuxfoundation.org>, Colin Cross <ccross@android.com>,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 12/14] staging: binder: Fix ABI for 64bit Android
Date: Mon, 17 Feb 2014 13:58:40 -0800
Message-Id: <1392674322-9036-13-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392674322-9036-1-git-send-email-john.stultz@linaro.org>
References: <1392674322-9036-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Serban Constantinescu <serban.constantinescu@arm.com>

This patch fixes the ABI for 64bit Android userspace.
BC_REQUEST_DEATH_NOTIFICATION and BC_CLEAR_DEATH_NOTIFICATION claim
to be using struct binder_ptr_cookie, but they are using a 32bit handle
and a pointer.

On 32bit systems the payload size is the same as the size of struct
binder_ptr_cookie, however for 64bit systems this will differ. This
patch adds struct binder_handle_cookie that fixes this issue for 64bit
Android.

Since there are no 64bit users of this interface that we know of this
change should not affect any existing systems.

Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Colin Cross <ccross@android.com>
Cc: Arve Hjønnevåg <arve@android.com>
Cc: Serban Constantinescu <serban.constantinescu@arm.com>
Cc: Android Kernel Team <kernel-team@android.com>
Signed-off-by: Serban Constantinescu <serban.constantinescu@arm.com>
[jstultz: Minor commit tweaks, few 80+ col fixes for checkpatch]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/uapi/binder.h | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/android/uapi/binder.h b/drivers/staging/android/uapi/binder.h
index 2b1eb81..4071fcf 100644
--- a/drivers/staging/android/uapi/binder.h
+++ b/drivers/staging/android/uapi/binder.h
@@ -152,6 +152,11 @@ struct binder_ptr_cookie {
 	void *cookie;
 };
 
+struct binder_handle_cookie {
+	__u32 handle;
+	void *cookie;
+} __attribute__((packed));
+
 struct binder_pri_desc {
 	__s32 priority;
 	__u32 desc;
@@ -308,15 +313,17 @@ enum binder_driver_command_protocol {
 	 * of looping threads it has available.
 	 */
 
-	BC_REQUEST_DEATH_NOTIFICATION = _IOW('c', 14, struct binder_ptr_cookie),
+	BC_REQUEST_DEATH_NOTIFICATION = _IOW('c', 14,
+						struct binder_handle_cookie),
 	/*
-	 * void *: ptr to binder
+	 * int: handle
 	 * void *: cookie
 	 */
 
-	BC_CLEAR_DEATH_NOTIFICATION = _IOW('c', 15, struct binder_ptr_cookie),
+	BC_CLEAR_DEATH_NOTIFICATION = _IOW('c', 15,
+						struct binder_handle_cookie),
 	/*
-	 * void *: ptr to binder
+	 * int: handle
 	 * void *: cookie
 	 */
 
-- 
1.8.3.2

