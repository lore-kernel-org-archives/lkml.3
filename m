Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936310Ab3DQRil (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 13:38:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7906 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752272Ab3DQRik (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 13:38:40 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH 3/4] HID: debug: empty output queue on read
Date: Wed, 17 Apr 2013 19:38:15 +0200
Message-Id: <1366220296-14346-4-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1366220296-14346-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1366220296-14346-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If an event occurs while the hid debugfs is forwarding events, list->tail
is updated during copy_to_user().

Remove the gotos and use a regular while-loop to empty the queue.

Second benefit, it checks that we are not writing more than count bytes
to the user-space output buffer.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/hid-debug.c | 27 +++++++++++----------------
 1 file changed, 11 insertions(+), 16 deletions(-)

diff --git a/drivers/hid/hid-debug.c b/drivers/hid/hid-debug.c
index 094cbcf..1dc8104 100644
--- a/drivers/hid/hid-debug.c
+++ b/drivers/hid/hid-debug.c
@@ -1000,6 +1000,7 @@ static ssize_t hid_debug_events_read(struct file *file, char __user *buffer,
 		size_t count, loff_t *ppos)
 {
 	struct hid_debug_list *list = file->private_data;
+	char *buf_head;
 	int ret = 0, len;
 	DECLARE_WAITQUEUE(wait, current);
 
@@ -1039,28 +1040,22 @@ static ssize_t hid_debug_events_read(struct file *file, char __user *buffer,
 			goto out;
 
 		/* pass the ringbuffer contents to userspace */
-copy_rest:
-		if (list->tail == list->head)
-			goto out;
-		if (list->tail > list->head) {
-			len = list->tail - list->head;
+		while (list->tail != list->head && ret < count) {
+			buf_head = &list->hid_debug_buf[list->head];
 
-			if (copy_to_user(buffer + ret, &list->hid_debug_buf[list->head], len)) {
-				ret = -EFAULT;
-				goto out;
-			}
-			ret += len;
-			list->head += len;
-		} else {
-			len = HID_DEBUG_BUFSIZE - list->head;
+			if (list->tail > list->head)
+				len = list->tail - list->head;
+			else
+				len = HID_DEBUG_BUFSIZE - list->head;
+
+			len = min(count - ret, len);
 
-			if (copy_to_user(buffer, &list->hid_debug_buf[list->head], len)) {
+			if (copy_to_user(buffer + ret, buf_head, len)) {
 				ret = -EFAULT;
 				goto out;
 			}
-			list->head = 0;
 			ret += len;
-			goto copy_rest;
+			list->head = (list->head + len) % HID_DEBUG_BUFSIZE;
 		}
 
 	}
-- 
1.8.1.4

