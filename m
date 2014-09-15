Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442AbaIOTeO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 15:34:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54580 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755092AbaIOT1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:27:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sebastian Reichel <sre@kernel.org>
Subject: [PATCH 3.16 092/158] bq2415x_charger: Fix Atomic Sleep Bug
Date: Mon, 15 Sep 2014 12:25:31 -0700
Message-Id: <20140915192545.648623320@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192542.872134685@linuxfoundation.org>
References: <20140915192542.872134685@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Reichel <sre@kernel.org>

commit 3c0185046c0ee49a6e55c714612ef3bcd5385df3 upstream.

Move sysfs_notify and i2c_transfer calls from bq2415x_notifier_call
to bq2415x_timer_work to avoid sleeping in atomic context.

This fixes the following bug:

[ 7.667449] Workqueue: events power_supply_changed_work
[ 7.673034] [<c0015c28>] (unwind_backtrace+0x0/0xe0) from [<c0011e1c>] (show_stack+0x10/0x14)
[ 7.682098] [<c0011e1c>] (show_stack+0x10/0x14) from [<c052cdd0>] (dump_stack+0x78/0xac)
[ 7.690704] [<c052cdd0>] (dump_stack+0x78/0xac) from [<c052a044>] (__schedule_bug+0x48/0x60)
[ 7.699645] [<c052a044>] (__schedule_bug+0x48/0x60) from [<c053071c>] (__schedule+0x74/0x638)
[ 7.708618] [<c053071c>] (__schedule+0x74/0x638) from [<c05301fc>] (schedule_timeout+0x1dc/0x24c)
[ 7.718017] [<c05301fc>] (schedule_timeout+0x1dc/0x24c) from [<c05316ec>] (wait_for_common+0x138/0x17c)
[ 7.727966] [<c05316ec>] (wait_for_common+0x138/0x17c) from [<c0362a70>] (omap_i2c_xfer+0x340/0x4a0)
[ 7.737640] [<c0362a70>] (omap_i2c_xfer+0x340/0x4a0) from [<c035d928>] (__i2c_transfer+0x40/0x74)
[ 7.747039] [<c035d928>] (__i2c_transfer+0x40/0x74) from [<c035e22c>] (i2c_transfer+0x6c/0x90)
[ 7.756195] [<c035e22c>] (i2c_transfer+0x6c/0x90) from [<c037ad24>] (bq2415x_i2c_write+0x48/0x78)
[ 7.765563] [<c037ad24>] (bq2415x_i2c_write+0x48/0x78) from [<c037ae60>] (bq2415x_set_weak_battery_voltage+0x4c/0x50)
[ 7.776824] [<c037ae60>] (bq2415x_set_weak_battery_voltage+0x4c/0x50) from [<c037bce8>] (bq2415x_set_mode+0xdc/0x14c)
[ 7.788085] [<c037bce8>] (bq2415x_set_mode+0xdc/0x14c) from [<c037bfb8>] (bq2415x_notifier_call+0xa8/0xb4)
[ 7.798309] [<c037bfb8>] (bq2415x_notifier_call+0xa8/0xb4) from [<c005f228>] (notifier_call_chain+0x38/0x68)
[ 7.808715] [<c005f228>] (notifier_call_chain+0x38/0x68) from [<c005f284>] (__atomic_notifier_call_chain+0x2c/0x3c)
[ 7.819732] [<c005f284>] (__atomic_notifier_call_chain+0x2c/0x3c) from [<c005f2a8>] (atomic_notifier_call_chain+0x14/0x18)
[ 7.831420] [<c005f2a8>] (atomic_notifier_call_chain+0x14/0x18) from [<c0378078>] (power_supply_changed_work+0x6c/0xb8)
[ 7.842864] [<c0378078>] (power_supply_changed_work+0x6c/0xb8) from [<c00556c0>] (process_one_work+0x248/0x440)
[ 7.853546] [<c00556c0>] (process_one_work+0x248/0x440) from [<c0055d6c>] (worker_thread+0x208/0x350)
[ 7.863372] [<c0055d6c>] (worker_thread+0x208/0x350) from [<c005b0ac>] (kthread+0xc8/0xdc)
[ 7.872131] [<c005b0ac>] (kthread+0xc8/0xdc) from [<c000e138>] (ret_from_fork+0x14/0x3c)

Fixes: 32260308b4ca ("bq2415x_charger: Use power_supply notifier for automode")
Signed-off-by: Sebastian Reichel <sre@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/power/bq2415x_charger.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/power/bq2415x_charger.c
+++ b/drivers/power/bq2415x_charger.c
@@ -840,8 +840,7 @@ static int bq2415x_notifier_call(struct
 	if (bq->automode < 1)
 		return NOTIFY_OK;
 
-	sysfs_notify(&bq->charger.dev->kobj, NULL, "reported_mode");
-	bq2415x_set_mode(bq, bq->reported_mode);
+	schedule_delayed_work(&bq->work, 0);
 
 	return NOTIFY_OK;
 }
@@ -892,6 +891,11 @@ static void bq2415x_timer_work(struct wo
 	int error;
 	int boost;
 
+	if (bq->automode > 0 && (bq->reported_mode != bq->mode)) {
+		sysfs_notify(&bq->charger.dev->kobj, NULL, "reported_mode");
+		bq2415x_set_mode(bq, bq->reported_mode);
+	}
+
 	if (!bq->autotimer)
 		return;
 


