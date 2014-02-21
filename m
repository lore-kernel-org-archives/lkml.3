Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889AbaBUUnr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 15:43:47 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:64931 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754632AbaBUUnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 15:43:45 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Serban Constantinescu <serban.constantinescu@arm.com>,
        Greg KH <gregkh@linuxfoundation.org>, Colin Cross <ccross@android.com>,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 1/3] staging: binder: Fix ABI for 64bit Android
Date: Fri, 21 Feb 2014 12:43:32 -0800
Message-Id: <1393015414-12499-2-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393015414-12499-1-git-send-email-john.stultz@linaro.org>
References: <1393015414-12499-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Serban Constantinescu <serban.constantinescu@arm.com>

BC_REQUEST_DEATH_NOTIFICATION and BC_CLEAR_DEATH_NOTIFICATION were
defined with the wrong structure that did not match the code. Since a
binder pointer and handle are the same size on 32 bit systems, this
change does not affect them. The two commands claimed they were using
struct binder_ptr_cookie but they are using a 32bit handle and a pointer.

The main purpose of this patch is to add the binder_handle_cookie
struct so the service manager does not have to define its own version
(libbinder writes one field at a time so it does not use the struct).

On 32bit systems the payload size is the same as the size of struct
binder_ptr_cookie. On 64bit systems, the size does differ, and the
ioctl number does change. However, there are no known 64bit users of
this interface, and any 64bit systems will need the following patch to
run 32 bit processes anyway, so it is not expected that anyone will
ship a 64bit system without this change, so this change should not
affect any existing systems.

Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Colin Cross <ccross@android.com>
Cc: Arve Hjønnevåg <arve@android.com>
Cc: Serban Constantinescu <serban.constantinescu@arm.com>
Cc: Android Kernel Team <kernel-team@android.com>
Signed-off-by: Serban Constantinescu <serban.constantinescu@arm.com>
[jstultz: Few 80+ col fixes for checkpatch, improved commit message
with help from Serban, and included rational from Arve's email]
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

