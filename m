Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764AbbAZUma (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 15:42:30 -0500
Received: from mx1.scotdoyle.com ([23.226.141.211]:43350 "EHLO
	mx1.scotdoyle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbbAZUm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 15:42:27 -0500
Date: Mon, 26 Jan 2015 20:40:26 +0000 (UTC)
From: Scot Doyle <lkml14@scotdoyle.com>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/2] fbcon: store cursor blink interval in fbcon_ops
In-Reply-To: <alpine.DEB.2.11.1501262034380.1945@localhost.localdomain>
Message-ID: <alpine.DEB.2.11.1501262038450.2052@localhost.localdomain>
References: <alpine.DEB.2.11.1501262034380.1945@localhost.localdomain>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The fbcon cursor, when set to blink, is hardcoded to toggle display
state five times per second. Move this setting to the driver's fbdev_ops
structure, retaining the default blink interval.

Signed-off-by: Scot Doyle <lkml14@scotdoyle.com>
---
 drivers/video/console/fbcon.c | 5 +++--
 drivers/video/console/fbcon.h | 1 +
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
index ea43724..7a2030b 100644
--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -405,7 +405,7 @@ static void cursor_timer_handler(unsigned long dev_addr)
 	struct fbcon_ops *ops = info->fbcon_par;
 
 	queue_work(system_power_efficient_wq, &info->queue);
-	mod_timer(&ops->cursor_timer, jiffies + HZ/5);
+	mod_timer(&ops->cursor_timer, jiffies + ops->blink_jiffies);
 }
 
 static void fbcon_add_cursor_timer(struct fb_info *info)
@@ -420,7 +420,7 @@ static void fbcon_add_cursor_timer(struct fb_info *info)
 
 		init_timer(&ops->cursor_timer);
 		ops->cursor_timer.function = cursor_timer_handler;
-		ops->cursor_timer.expires = jiffies + HZ / 5;
+		ops->cursor_timer.expires = jiffies + ops->blink_jiffies;
 		ops->cursor_timer.data = (unsigned long ) info;
 		add_timer(&ops->cursor_timer);
 		ops->flags |= FBCON_FLAGS_CURSOR_TIMER;
@@ -959,6 +959,7 @@ static const char *fbcon_startup(void)
 	ops->currcon = -1;
 	ops->graphics = 1;
 	ops->cur_rotate = -1;
+	ops->blink_jiffies = msecs_to_jiffies(200);
 	info->fbcon_par = ops;
 	p->con_rotate = initial_rotation;
 	set_blitting_type(vc, info);
diff --git a/drivers/video/console/fbcon.h b/drivers/video/console/fbcon.h
index 6bd2e0c..642c4e7 100644
--- a/drivers/video/console/fbcon.h
+++ b/drivers/video/console/fbcon.h
@@ -70,6 +70,7 @@ struct fbcon_ops {
 	struct fb_cursor cursor_state;
 	struct display *p;
         int    currcon;	                /* Current VC. */
+	int    blink_jiffies;
 	int    cursor_flash;
 	int    cursor_reset;
 	int    blank_state;
-- 
2.1.4

