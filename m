Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933895AbbA1B4I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 20:56:08 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41450 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933273AbbA1Bi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 20:38:26 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Pavel Machek <pavel@ucw.cz>, David Herrmann <dh.herrmann@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 3.14 42/77] Input: evdev - fix EVIOCG{type} ioctl
Date: Tue, 27 Jan 2015 17:27:20 -0800
Message-Id: <20150128012747.220032574@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150128012745.971137091@linuxfoundation.org>
References: <20150128012745.971137091@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 7c4f56070fde2367766fa1fb04852599b5e1ad35 upstream.

The 'max' size passed into the function is measured in number of bits
(KEY_MAX, LED_MAX, etc) so we need to convert it accordingly before trying
to copy the data out, otherwise we will try copying too much and end up
with up with a page fault.

Reported-by: Pavel Machek <pavel@ucw.cz>
Reviewed-by: Pavel Machek <pavel@ucw.cz>
Reviewed-by: David Herrmann <dh.herrmann@gmail.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/evdev.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -757,20 +757,23 @@ static int evdev_handle_set_keycode_v2(s
  */
 static int evdev_handle_get_val(struct evdev_client *client,
 				struct input_dev *dev, unsigned int type,
-				unsigned long *bits, unsigned int max,
-				unsigned int size, void __user *p, int compat)
+				unsigned long *bits, unsigned int maxbit,
+				unsigned int maxlen, void __user *p,
+				int compat)
 {
 	int ret;
 	unsigned long *mem;
+	size_t len;
 
-	mem = kmalloc(sizeof(unsigned long) * max, GFP_KERNEL);
+	len = BITS_TO_LONGS(maxbit) * sizeof(unsigned long);
+	mem = kmalloc(len, GFP_KERNEL);
 	if (!mem)
 		return -ENOMEM;
 
 	spin_lock_irq(&dev->event_lock);
 	spin_lock(&client->buffer_lock);
 
-	memcpy(mem, bits, sizeof(unsigned long) * max);
+	memcpy(mem, bits, len);
 
 	spin_unlock(&dev->event_lock);
 
@@ -778,7 +781,7 @@ static int evdev_handle_get_val(struct e
 
 	spin_unlock_irq(&client->buffer_lock);
 
-	ret = bits_to_user(mem, max, size, p, compat);
+	ret = bits_to_user(mem, maxbit, maxlen, p, compat);
 	if (ret < 0)
 		evdev_queue_syn_dropped(client);
 


