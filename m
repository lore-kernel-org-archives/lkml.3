Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751327AbaDXF1Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 01:27:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36354 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbaDXF1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 01:27:23 -0400
Date: Wed, 23 Apr 2014 22:27:20 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: linux-input@vger.kernel.org
Cc: David Herrmann <dh.herrmann@gmail.com>,
        Peter Hutterer <peter.hutterer@who-t.net>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Input: evdev - get rid of old workaround for EVIOCGBIT
Message-ID: <20140424052719.GA29764@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We put this workaround in 2008 and the offending userspace has been fixed
up long time ago; the link in the message is no longer valid either, so it
is time to retire it.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/evdev.c | 18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index ce953d8..fd325ec 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -629,12 +629,10 @@ static int str_to_user(const char *str, unsigned int maxlen, void __user *p)
 	return copy_to_user(p, str, len) ? -EFAULT : len;
 }
 
-#define OLD_KEY_MAX	0x1ff
 static int handle_eviocgbit(struct input_dev *dev,
 			    unsigned int type, unsigned int size,
 			    void __user *p, int compat_mode)
 {
-	static unsigned long keymax_warn_time;
 	unsigned long *bits;
 	int len;
 
@@ -652,24 +650,8 @@ static int handle_eviocgbit(struct input_dev *dev,
 	default: return -EINVAL;
 	}
 
-	/*
-	 * Work around bugs in userspace programs that like to do
-	 * EVIOCGBIT(EV_KEY, KEY_MAX) and not realize that 'len'
-	 * should be in bytes, not in bits.
-	 */
-	if (type == EV_KEY && size == OLD_KEY_MAX) {
-		len = OLD_KEY_MAX;
-		if (printk_timed_ratelimit(&keymax_warn_time, 10 * 1000))
-			pr_warning("(EVIOCGBIT): Suspicious buffer size %u, "
-				   "limiting output to %zu bytes. See "
-				   "http://userweb.kernel.org/~dtor/eviocgbit-bug.html\n",
-				   OLD_KEY_MAX,
-				   BITS_TO_LONGS(OLD_KEY_MAX) * sizeof(long));
-	}
-
 	return bits_to_user(bits, len, size, p, compat_mode);
 }
-#undef OLD_KEY_MAX
 
 static int evdev_handle_get_keycode(struct input_dev *dev, void __user *p)
 {
-- 
1.9.0


-- 
Dmitry
