Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164Ab3LYOs5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Dec 2013 09:48:57 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:55078 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035Ab3LYOsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Dec 2013 09:48:55 -0500
From: Masami Ichikawa <masami256@gmail.com>
To: plagnioj@jcrosoft.com, tomi.valkeinen@ti.com, linux-fbdev@vger.kernel.org
Cc: airlied@redhat.com, udknight@gmail.com, gregkh@linuxfoundation.org,
        akpm@linux-foundation.org, tiwai@suse.de, linux-kernel@vger.kernel.org,
        masami256@gmail.com
Subject: [PATCH] fbcon: Fix memory leak in fbcon_exit().
Date: Wed, 25 Dec 2013 23:47:37 +0900
Message-Id: <1387982857-14500-1-git-send-email-masami256@gmail.com>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kmemleak reported a memory leak as below.

unreferenced object 0xffff880036ca84c0 (size 16):
  comm "swapper/0", pid 1, jiffies 4294877407 (age 4434.633s)
  hex dump (first 16 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 ff ff  ................
  backtrace:
    [<ffffffff814ed01e>] kmemleak_alloc+0x4e/0xb0
    [<ffffffff8118913c>] __kmalloc+0x1fc/0x290
    [<ffffffff81302c9e>] bit_cursor+0x24e/0x6c0
    [<ffffffff812ff2f4>] fbcon_cursor+0x154/0x1d0
    [<ffffffff813675d8>] hide_cursor+0x28/0xa0
    [<ffffffff81368acf>] update_region+0x6f/0x90
    [<ffffffff81300268>] fbcon_switch+0x518/0x550
    [<ffffffff813695b9>] redraw_screen+0x189/0x240
    [<ffffffff8136a0e0>] do_bind_con_driver+0x360/0x380
    [<ffffffff8136a6e4>] do_take_over_console+0x114/0x1c0
    [<ffffffff812fdc83>] do_fbcon_takeover+0x63/0xd0
    [<ffffffff813023e5>] fbcon_event_notify+0x605/0x720
    [<ffffffff81501dcc>] notifier_call_chain+0x4c/0x70
    [<ffffffff81087f8d>] __blocking_notifier_call_chain+0x4d/0x70
    [<ffffffff81087fc6>] blocking_notifier_call_chain+0x16/0x20
    [<ffffffff812f201b>] fb_notifier_call_chain+0x1b/0x20

In this case ops->cursor_state.mask is allocated in bit_cursor() but
not freed in fbcon_exit(). So, fbcon_exit() needs to free buffer in its
process.
In the case, fbcon_exit() was called from fbcon_deinit() when driver
called remove_conflicting_framebuffers().

Signed-off-by: Masami Ichikawa <masami256@gmail.com>
---
 drivers/video/console/fbcon.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
index cd8a802..4f02375 100644
--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -3561,6 +3561,7 @@ static void fbcon_exit(void)
 
 				fbcon_del_cursor_timer(info);
 				kfree(ops->cursor_src);
+				kfree(ops->cursor_state.mask);
 				kfree(info->fbcon_par);
 				info->fbcon_par = NULL;
 			}
-- 
1.8.4.2

