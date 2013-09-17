Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166Ab3IQW4B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 18:56:01 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:43917 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371Ab3IQWz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 18:55:56 -0400
From: Ryan Mallon <rmallon@gmail.com>
To: dmitry.torokhov@gmail.com, rydberg@euromail.se
Cc: carl@ok-labs.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ryan Mallon <rmallon@gmail.com>
Subject: [PATCH 2/2] uinput: Support injecting multiple events in one write() call
Date: Wed, 18 Sep 2013 08:55:44 +1000
Message-Id: <1379458544-6508-2-git-send-email-rmallon@gmail.com>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1379458544-6508-1-git-send-email-rmallon@gmail.com>
References: <1379458544-6508-1-git-send-email-rmallon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rework the code in uinput_inject_event so that it matches the code in
evdev_write and allows injecting more than one event, or zero events.

Signed-off-by: Ryan Mallon <rmallon@gmail.com>
---
 drivers/input/misc/uinput.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/input/misc/uinput.c b/drivers/input/misc/uinput.c
index a0a4bba..0247a8a 100644
--- a/drivers/input/misc/uinput.c
+++ b/drivers/input/misc/uinput.c
@@ -434,16 +434,24 @@ static ssize_t uinput_inject_event(struct uinput_device *udev,
 				   const char __user *buffer, size_t count)
 {
 	struct input_event ev;
+	size_t bytes = 0;
 
-	if (count < input_event_size())
+	if (count != 0 && count < input_event_size())
 		return -EINVAL;
 
-	if (input_event_from_user(buffer, &ev))
-		return -EFAULT;
+	while (bytes + input_event_size() <= count) {
+		if (input_event_from_user(buffer + bytes, &ev)) {
+			if (!bytes)
+				bytes = -EFAULT;
+			goto out;
+		}
 
-	input_event(udev->dev, ev.type, ev.code, ev.value);
+		input_event(udev->dev, ev.type, ev.code, ev.value);
+		bytes += input_event_size();
+	}
 
-	return input_event_size();
+ out:
+	return bytes;
 }
 
 static ssize_t uinput_write(struct file *file, const char __user *buffer,
-- 
1.7.9.7

