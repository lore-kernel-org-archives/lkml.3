Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756461AbaDWOgB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 10:36:01 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:50091 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332AbaDWOf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 10:35:57 -0400
From: Masami Ichikawa <masami256@gmail.com>
To: masami256@gmail.com, plagnioj@jcrosoft.com, tomi.valkeinen@ti.com,
        udknight@gmail.com, gregkh@linuxfoundation.org, keithp@keithp.com,
        mika.kuoppala@linux.intel.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org
Subject: [PATCH] fbcon: Fix memory leak in con2fb_release_oldinfo()
Date: Wed, 23 Apr 2014 23:35:22 +0900
Message-Id: <1398263722-10436-1-git-send-email-masami256@gmail.com>
X-Mailer: git-send-email 1.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kmemleak reported a memory leak as below.

unreferenced object 0xffff8800dab6d8d8 (size 96):
  comm "swapper/0", pid 1, jiffies 4294877598 (age 38.483s)
  hex dump (first 32 bytes):
    00 00 00 00 00 01 00 00 08 00 00 00 10 00 00 00  ................
    07 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff814e8f2e>] kmemleak_alloc+0x4e/0xb0
    [<ffffffff811a0600>] __kmalloc+0x280/0x320
    [<ffffffff81309b61>] soft_cursor+0x231/0x290
    [<ffffffff81309393>] bit_cursor+0x613/0x650
    [<ffffffff8130556b>] fbcon_cursor+0x13b/0x1c0
    [<ffffffff813755f8>] hide_cursor+0x28/0xa0
    [<ffffffff81376e98>] redraw_screen+0x168/0x240
    [<ffffffff81303891>] fbcon_prepare_logo+0x381/0x420
    [<ffffffff81303c7e>] fbcon_init+0x34e/0x590
    [<ffffffff81375828>] visual_init+0xb8/0x120
    [<ffffffff81377c93>] do_bind_con_driver+0x163/0x380
    [<ffffffff81378494>] do_take_over_console+0x114/0x1c0
    [<ffffffff81303f23>] do_fbcon_takeover+0x63/0xd0
    [<ffffffff813086dd>] fbcon_event_notify+0x68d/0x7e0
    [<ffffffff814ff7ac>] notifier_call_chain+0x4c/0x70
    [<ffffffff8108c85d>] __blocking_notifier_call_chain+0x4d/0x70

This memory leak cause is, fbcon_ops's cursor_src is allocated in
soft_cursor() but not released in con2fb_release_oldinfo().
so, cursor_src is needed to be released when oldinfo is going to be
released.

Signed-off-by: Masami Ichikawa <masami256@gmail.com>
---
 drivers/video/console/fbcon.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
index f447734..57b1d44 100644
--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -748,6 +748,7 @@ static int con2fb_release_oldinfo(struct vc_data *vc, struct fb_info *oldinfo,
 		fbcon_del_cursor_timer(oldinfo);
 		kfree(ops->cursor_state.mask);
 		kfree(ops->cursor_data);
+		kfree(ops->cursor_src);
 		kfree(ops->fontbuffer);
 		kfree(oldinfo->fbcon_par);
 		oldinfo->fbcon_par = NULL;
-- 
1.9.1

