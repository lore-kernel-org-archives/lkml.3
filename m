Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818AbaDDRBe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 13:01:34 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:43527 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753790AbaDDRBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 13:01:32 -0400
From: Sasha Levin <sasha.levin@oracle.com>
To: cooloney@gmail.com, rpurdie@rpsys.net
Cc: linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] leds: make sure we unregister a trigger only once
Date: Fri,  4 Apr 2014 13:01:13 -0400
Message-Id: <1396630873-17372-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.3.2
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, we may attempt to unregister a trigger more than once, for
example when we receive two consecutive reboot notifications, or when
we do a regular unregistration plus reboot notification.

This leads to the following error since we try to delete the list node
twice:

[ 2780.254922] WARNING: CPU: 0 PID: 13764 at lib/list_debug.c:53 __list_del_entry+0x3e/0xe0()
[ 2780.265559] list_del corruption, ffffffffa5eb6470->next is LIST_POISON1 (dead000000100100)
[ 2780.271710] Modules linked in:
[ 2780.274156] CPU: 0 PID: 13764 Comm: kworker/0:2 Tainted: G        W     3.14.0-next-20140403-sasha-00012-gef5fa7d-dirty #373
[ 2780.283063] Workqueue: events do_poweroff
[ 2780.285644]  0000000000000009 ffff8800330dbb38 ffffffffa34bfa33 0000000000002fe0
[ 2780.291571]  ffff8800330dbb88 ffff8800330dbb78 ffffffffa015a37c ffff8800330dbb68
[ 2780.296670]  ffffffffa5eb6470 0000000000000000 ffffffffa5eb6400 ffffffffa5ad7430
[ 2780.299756] Call Trace:
[ 2780.301530] dump_stack (lib/dump_stack.c:52)
[ 2780.303802] warn_slowpath_common (kernel/panic.c:418)
[ 2780.306151] warn_slowpath_fmt (kernel/panic.c:433)
[ 2780.308156] __list_del_entry (lib/list_debug.c:51 (discriminator 1))
[ 2780.310800] list_del (lib/list_debug.c:78)
[ 2780.313175] led_trigger_unregister (drivers/leds/led-triggers.c:225)
[ 2780.315599] heartbeat_reboot_notifier (drivers/leds/trigger/ledtrig-heartbeat.c:119)
[ 2780.317247] notifier_call_chain (kernel/notifier.c:95)
[ 2780.320014] __blocking_notifier_call_chain (kernel/notifier.c:316)
[ 2780.323263] blocking_notifier_call_chain (kernel/notifier.c:326)
[ 2780.326096] kernel_power_off (include/linux/kmod.h:95 kernel/reboot.c:153 kernel/reboot.c:179)
[ 2780.327883] do_poweroff (kernel/power/poweroff.c:23)
[ 2780.330748] process_one_work (kernel/workqueue.c:2221 include/linux/jump_label.h:105 include/trace/events/workqueue.h:111 kernel/workqueue.c:2226)
[ 2780.333027] ? process_one_work (include/linux/workqueue.h:186 kernel/workqueue.c:611 kernel/workqueue.c:638 kernel/workqueue.c:2214)
[ 2780.335487] process_scheduled_works (include/linux/list.h:188 kernel/workqueue.c:2277)
[ 2780.337101] worker_thread (kernel/workqueue.c:2352)
[ 2780.338712] ? rescuer_thread (kernel/workqueue.c:2297)
[ 2780.341326] kthread (kernel/kthread.c:219)
[ 2780.343446] ? kthread_create_on_node (kernel/kthread.c:185)
[ 2780.345733] ret_from_fork (arch/x86/kernel/entry_64.S:555)
[ 2780.347168] ? kthread_create_on_node (kernel/kthread.c:185)

Prevent it by making sure we don't attempt to unregister a trigger that
is not in the triggers list.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 drivers/leds/led-triggers.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/leds/led-triggers.c b/drivers/leds/led-triggers.c
index df1a7c1..c3734f1 100644
--- a/drivers/leds/led-triggers.c
+++ b/drivers/leds/led-triggers.c
@@ -219,9 +219,12 @@ void led_trigger_unregister(struct led_trigger *trig)
 {
 	struct led_classdev *led_cdev;
 
+	if (list_empty_careful(&trig->next_trig))
+		return;
+
 	/* Remove from the list of led triggers */
 	down_write(&triggers_list_lock);
-	list_del(&trig->next_trig);
+	list_del_init(&trig->next_trig);
 	up_write(&triggers_list_lock);
 
 	/* Remove anyone actively using this trigger */
-- 
1.7.10.4

