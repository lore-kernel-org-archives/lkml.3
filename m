Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262AbaLCL1I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:27:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54451 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750840AbaLCL1F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:27:05 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 001/101] Input: evdev - fix EVIOCG{type} ioctl
Date: Wed,  3 Dec 2014 12:25:23 +0100
Message-Id: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <cover.1417605922.git.jslaby@suse.cz>
References: <cover.1417605922.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 7c4f56070fde2367766fa1fb04852599b5e1ad35 upstream.

The 'max' size passed into the function is measured in number of bits
(KEY_MAX, LED_MAX, etc) so we need to convert it accordingly before trying
to copy the data out, otherwise we will try copying too much and end up
with up with a page fault.

Reported-by: Pavel Machek <pavel@ucw.cz>
Reviewed-by: Pavel Machek <pavel@ucw.cz>
Reviewed-by: David Herrmann <dh.herrmann@gmail.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/input/evdev.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index a06e12552886..694af4958a98 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -757,20 +757,23 @@ static int evdev_handle_set_keycode_v2(struct input_dev *dev, void __user *p)
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
 
@@ -778,7 +781,7 @@ static int evdev_handle_get_val(struct evdev_client *client,
 
 	spin_unlock_irq(&client->buffer_lock);
 
-	ret = bits_to_user(mem, max, size, p, compat);
+	ret = bits_to_user(mem, maxbit, maxlen, p, compat);
 	if (ret < 0)
 		evdev_queue_syn_dropped(client);
 
-- 
2.1.3

