Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760AbaDRJXe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 05:23:34 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:45908 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752055AbaDRJWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 05:22:48 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Gu Zheng <guz.fnst@cn.fujitsu.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 19/72] fb: reorder the lock sequence to fix potential dead lock
Date: Fri, 18 Apr 2014 11:21:52 +0200
Message-Id: <be5289088d0dd45d1b05753eba1cb9252375dff2.1397812482.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
References: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
In-Reply-To: <cover.1397812482.git.jslaby@suse.cz>
References: <cover.1397812482.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gu Zheng <guz.fnst@cn.fujitsu.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 3a41c5dbe8bc396a7fb16ca8739e945bb003342e upstream.

Following commits:

50e244cc79 fb: rework locking to fix lock ordering on takeover
e93a9a8687 fb: Yet another band-aid for fixing lockdep mess
054430e773 fbcon: fix locking harder

reworked locking to fix related lock ordering on takeover, and introduced console_lock
into fbmem, but it seems that the new lock sequence(fb_info->lock ---> console_lock)
is against with the one in console_callback(console_lock ---> fb_info->lock), and leads to
a potential dead lock as following:

[  601.079000] ======================================================
[  601.079000] [ INFO: possible circular locking dependency detected ]
[  601.079000] 3.11.0 #189 Not tainted
[  601.079000] -------------------------------------------------------
[  601.079000] kworker/0:3/619 is trying to acquire lock:
[  601.079000]  (&fb_info->lock){+.+.+.}, at: [<ffffffff81397566>] lock_fb_info+0x26/0x60
[  601.079000]
but task is already holding lock:
[  601.079000]  (console_lock){+.+.+.}, at: [<ffffffff8141aae3>] console_callback+0x13/0x160
[  601.079000]
which lock already depends on the new lock.

[  601.079000]
the existing dependency chain (in reverse order) is:
[  601.079000]
-> #1 (console_lock){+.+.+.}:
[  601.079000]        [<ffffffff810dc971>] lock_acquire+0xa1/0x140
[  601.079000]        [<ffffffff810c6267>] console_lock+0x77/0x80
[  601.079000]        [<ffffffff81399448>] register_framebuffer+0x1d8/0x320
[  601.079000]        [<ffffffff81cfb4c8>] efifb_probe+0x408/0x48f
[  601.079000]        [<ffffffff8144a963>] platform_drv_probe+0x43/0x80
[  601.079000]        [<ffffffff8144853b>] driver_probe_device+0x8b/0x390
[  601.079000]        [<ffffffff814488eb>] __driver_attach+0xab/0xb0
[  601.079000]        [<ffffffff814463bd>] bus_for_each_dev+0x5d/0xa0
[  601.079000]        [<ffffffff81447e6e>] driver_attach+0x1e/0x20
[  601.079000]        [<ffffffff81447a07>] bus_add_driver+0x117/0x290
[  601.079000]        [<ffffffff81448fea>] driver_register+0x7a/0x170
[  601.079000]        [<ffffffff8144a10a>] __platform_driver_register+0x4a/0x50
[  601.079000]        [<ffffffff8144a12d>] platform_driver_probe+0x1d/0xb0
[  601.079000]        [<ffffffff81cfb0a1>] efifb_init+0x273/0x292
[  601.079000]        [<ffffffff81002132>] do_one_initcall+0x102/0x1c0
[  601.079000]        [<ffffffff81cb80a6>] kernel_init_freeable+0x15d/0x1ef
[  601.079000]        [<ffffffff8166d2de>] kernel_init+0xe/0xf0
[  601.079000]        [<ffffffff816914ec>] ret_from_fork+0x7c/0xb0
[  601.079000]
-> #0 (&fb_info->lock){+.+.+.}:
[  601.079000]        [<ffffffff810dc1d8>] __lock_acquire+0x1e18/0x1f10
[  601.079000]        [<ffffffff810dc971>] lock_acquire+0xa1/0x140
[  601.079000]        [<ffffffff816835ca>] mutex_lock_nested+0x7a/0x3b0
[  601.079000]        [<ffffffff81397566>] lock_fb_info+0x26/0x60
[  601.079000]        [<ffffffff813a4aeb>] fbcon_blank+0x29b/0x2e0
[  601.079000]        [<ffffffff81418658>] do_blank_screen+0x1d8/0x280
[  601.079000]        [<ffffffff8141ab34>] console_callback+0x64/0x160
[  601.079000]        [<ffffffff8108d855>] process_one_work+0x1f5/0x540
[  601.079000]        [<ffffffff8108e04c>] worker_thread+0x11c/0x370
[  601.079000]        [<ffffffff81095fbd>] kthread+0xed/0x100
[  601.079000]        [<ffffffff816914ec>] ret_from_fork+0x7c/0xb0
[  601.079000]
other info that might help us debug this:

[  601.079000]  Possible unsafe locking scenario:

[  601.079000]        CPU0                    CPU1
[  601.079000]        ----                    ----
[  601.079000]   lock(console_lock);
[  601.079000]                                lock(&fb_info->lock);
[  601.079000]                                lock(console_lock);
[  601.079000]   lock(&fb_info->lock);
[  601.079000]
 *** DEADLOCK ***

so we reorder the lock sequence the same as it in console_callback() to
avoid this issue. And following Tomi's suggestion, fix these similar
issues all in fb subsystem.

Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/video/fbmem.c            | 50 +++++++++++++++++++++++++---------------
 drivers/video/fbsysfs.c          | 19 ++++++++++-----
 drivers/video/sh_mobile_lcdcfb.c | 10 ++++----
 3 files changed, 51 insertions(+), 28 deletions(-)

diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
index 8659eb160b4d..cde461932760 100644
--- a/drivers/video/fbmem.c
+++ b/drivers/video/fbmem.c
@@ -1108,14 +1108,16 @@ static long do_fb_ioctl(struct fb_info *info, unsigned int cmd,
 	case FBIOPUT_VSCREENINFO:
 		if (copy_from_user(&var, argp, sizeof(var)))
 			return -EFAULT;
-		if (!lock_fb_info(info))
-			return -ENODEV;
 		console_lock();
+		if (!lock_fb_info(info)) {
+			console_unlock();
+			return -ENODEV;
+		}
 		info->flags |= FBINFO_MISC_USEREVENT;
 		ret = fb_set_var(info, &var);
 		info->flags &= ~FBINFO_MISC_USEREVENT;
-		console_unlock();
 		unlock_fb_info(info);
+		console_unlock();
 		if (!ret && copy_to_user(argp, &var, sizeof(var)))
 			ret = -EFAULT;
 		break;
@@ -1144,12 +1146,14 @@ static long do_fb_ioctl(struct fb_info *info, unsigned int cmd,
 	case FBIOPAN_DISPLAY:
 		if (copy_from_user(&var, argp, sizeof(var)))
 			return -EFAULT;
-		if (!lock_fb_info(info))
-			return -ENODEV;
 		console_lock();
+		if (!lock_fb_info(info)) {
+			console_unlock();
+			return -ENODEV;
+		}
 		ret = fb_pan_display(info, &var);
-		console_unlock();
 		unlock_fb_info(info);
+		console_unlock();
 		if (ret == 0 && copy_to_user(argp, &var, sizeof(var)))
 			return -EFAULT;
 		break;
@@ -1184,23 +1188,27 @@ static long do_fb_ioctl(struct fb_info *info, unsigned int cmd,
 			break;
 		}
 		event.data = &con2fb;
-		if (!lock_fb_info(info))
-			return -ENODEV;
 		console_lock();
+		if (!lock_fb_info(info)) {
+			console_unlock();
+			return -ENODEV;
+		}
 		event.info = info;
 		ret = fb_notifier_call_chain(FB_EVENT_SET_CONSOLE_MAP, &event);
-		console_unlock();
 		unlock_fb_info(info);
+		console_unlock();
 		break;
 	case FBIOBLANK:
-		if (!lock_fb_info(info))
-			return -ENODEV;
 		console_lock();
+		if (!lock_fb_info(info)) {
+			console_unlock();
+			return -ENODEV;
+		}
 		info->flags |= FBINFO_MISC_USEREVENT;
 		ret = fb_blank(info, arg);
 		info->flags &= ~FBINFO_MISC_USEREVENT;
-		console_unlock();
 		unlock_fb_info(info);
+		console_unlock();
 		break;
 	default:
 		if (!lock_fb_info(info))
@@ -1660,12 +1668,15 @@ static int do_register_framebuffer(struct fb_info *fb_info)
 	registered_fb[i] = fb_info;
 
 	event.info = fb_info;
-	if (!lock_fb_info(fb_info))
-		return -ENODEV;
 	console_lock();
+	if (!lock_fb_info(fb_info)) {
+		console_unlock();
+		return -ENODEV;
+	}
+
 	fb_notifier_call_chain(FB_EVENT_FB_REGISTERED, &event);
-	console_unlock();
 	unlock_fb_info(fb_info);
+	console_unlock();
 	return 0;
 }
 
@@ -1678,13 +1689,16 @@ static int do_unregister_framebuffer(struct fb_info *fb_info)
 	if (i < 0 || i >= FB_MAX || registered_fb[i] != fb_info)
 		return -EINVAL;
 
-	if (!lock_fb_info(fb_info))
-		return -ENODEV;
 	console_lock();
+	if (!lock_fb_info(fb_info)) {
+		console_unlock();
+		return -ENODEV;
+	}
+
 	event.info = fb_info;
 	ret = fb_notifier_call_chain(FB_EVENT_FB_UNBIND, &event);
-	console_unlock();
 	unlock_fb_info(fb_info);
+	console_unlock();
 
 	if (ret)
 		return -EINVAL;
diff --git a/drivers/video/fbsysfs.c b/drivers/video/fbsysfs.c
index ef476b02fbe5..53444ac19fe0 100644
--- a/drivers/video/fbsysfs.c
+++ b/drivers/video/fbsysfs.c
@@ -177,9 +177,12 @@ static ssize_t store_modes(struct device *device,
 	if (i * sizeof(struct fb_videomode) != count)
 		return -EINVAL;
 
-	if (!lock_fb_info(fb_info))
-		return -ENODEV;
 	console_lock();
+	if (!lock_fb_info(fb_info)) {
+		console_unlock();
+		return -ENODEV;
+	}
+
 	list_splice(&fb_info->modelist, &old_list);
 	fb_videomode_to_modelist((const struct fb_videomode *)buf, i,
 				 &fb_info->modelist);
@@ -189,8 +192,8 @@ static ssize_t store_modes(struct device *device,
 	} else
 		fb_destroy_modelist(&old_list);
 
-	console_unlock();
 	unlock_fb_info(fb_info);
+	console_unlock();
 
 	return 0;
 }
@@ -404,12 +407,16 @@ static ssize_t store_fbstate(struct device *device,
 
 	state = simple_strtoul(buf, &last, 0);
 
-	if (!lock_fb_info(fb_info))
-		return -ENODEV;
 	console_lock();
+	if (!lock_fb_info(fb_info)) {
+		console_unlock();
+		return -ENODEV;
+	}
+
 	fb_set_suspend(fb_info, (int)state);
-	console_unlock();
+
 	unlock_fb_info(fb_info);
+	console_unlock();
 
 	return count;
 }
diff --git a/drivers/video/sh_mobile_lcdcfb.c b/drivers/video/sh_mobile_lcdcfb.c
index 0264704a52be..45d031233253 100644
--- a/drivers/video/sh_mobile_lcdcfb.c
+++ b/drivers/video/sh_mobile_lcdcfb.c
@@ -574,8 +574,9 @@ static int sh_mobile_lcdc_display_notify(struct sh_mobile_lcdc_chan *ch,
 	switch (event) {
 	case SH_MOBILE_LCDC_EVENT_DISPLAY_CONNECT:
 		/* HDMI plug in */
+		console_lock();
 		if (lock_fb_info(info)) {
-			console_lock();
+
 
 			ch->display.width = monspec->max_x * 10;
 			ch->display.height = monspec->max_y * 10;
@@ -594,19 +595,20 @@ static int sh_mobile_lcdc_display_notify(struct sh_mobile_lcdc_chan *ch,
 				fb_set_suspend(info, 0);
 			}
 
-			console_unlock();
+
 			unlock_fb_info(info);
 		}
+		console_unlock();
 		break;
 
 	case SH_MOBILE_LCDC_EVENT_DISPLAY_DISCONNECT:
 		/* HDMI disconnect */
+		console_lock();
 		if (lock_fb_info(info)) {
-			console_lock();
 			fb_set_suspend(info, 1);
-			console_unlock();
 			unlock_fb_info(info);
 		}
+		console_unlock();
 		break;
 
 	case SH_MOBILE_LCDC_EVENT_DISPLAY_MODE:
-- 
1.9.2

