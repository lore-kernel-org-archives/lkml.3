Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469Ab3LSLCI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 06:02:08 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:52585 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455Ab3LSLCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:02:06 -0500
From: Masami Ichikawa <masami256@gmail.com>
To: len.brown@intel.com, pavel@ucw.cz, rjw@rjwysocki.net,
        linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, masami256@gmail.com
Subject: [PATCH] PM: Fix memory leak in pm_vt_switch_unregister().
Date: Thu, 19 Dec 2013 20:00:47 +0900
Message-Id: <1387450847-23797-1-git-send-email-masami256@gmail.com>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kmemleak reported a memory leak as below.

unreferenced object 0xffff880118f14700 (size 32):
  comm "swapper/0", pid 1, jiffies 4294877401 (age 123.283s)
  hex dump (first 32 bytes):
    00 01 10 00 00 00 ad de 00 02 20 00 00 00 ad de  .......... .....
    00 d4 d2 18 01 88 ff ff 01 00 00 00 00 04 00 00  ................
  backtrace:
    [<ffffffff814edb1e>] kmemleak_alloc+0x4e/0xb0
    [<ffffffff811889dc>] kmem_cache_alloc_trace+0x1ec/0x260
    [<ffffffff810aba66>] pm_vt_switch_required+0x76/0xb0
    [<ffffffff812f39f5>] register_framebuffer+0x195/0x320
    [<ffffffff8130af18>] efifb_probe+0x718/0x780
    [<ffffffff81391495>] platform_drv_probe+0x45/0xb0
    [<ffffffff8138f407>] driver_probe_device+0x87/0x3a0
    [<ffffffff8138f7f3>] __driver_attach+0x93/0xa0
    [<ffffffff8138d413>] bus_for_each_dev+0x63/0xa0
    [<ffffffff8138ee5e>] driver_attach+0x1e/0x20
    [<ffffffff8138ea40>] bus_add_driver+0x180/0x250
    [<ffffffff8138fe74>] driver_register+0x64/0xf0
    [<ffffffff813913ba>] __platform_driver_register+0x4a/0x50
    [<ffffffff8191e028>] efifb_driver_init+0x12/0x14
    [<ffffffff8100214a>] do_one_initcall+0xfa/0x1b0
    [<ffffffff818e40e0>] kernel_init_freeable+0x17b/0x201

In pm_vt_switch_required(), "entry" variable is allocated via kmalloc().
So, in pm_vt_switch_unregister(), it needs to call kfree() when object
is deleted from list.

Signed-off-by: Masami Ichikawa <masami256@gmail.com>
---
 kernel/power/console.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/power/console.c b/kernel/power/console.c
index 463aa673..eacb8bd 100644
--- a/kernel/power/console.c
+++ b/kernel/power/console.c
@@ -81,6 +81,7 @@ void pm_vt_switch_unregister(struct device *dev)
 	list_for_each_entry(tmp, &pm_vt_switch_list, head) {
 		if (tmp->dev == dev) {
 			list_del(&tmp->head);
+			kfree(tmp);
 			break;
 		}
 	}
-- 
1.8.4.2

