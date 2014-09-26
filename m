Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657AbaIZLuw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 07:50:52 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:37198 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453AbaIZLut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 07:50:49 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-0a-54255317d852
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, Felipe Balbi <balbi@ti.com>,
        Sangjung Woo <sangjung.woo@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jingoo Han <jg1.han@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [RFC PATCH] extcon: Fix sleeping in atomic context after connecting
 USB cable
Date: Fri, 26 Sep 2014 13:50:41 +0200
Message-id: <1411732241-5212-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1411732241-5212-1-git-send-email-k.kozlowski@samsung.com>
References: <1411732241-5212-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmluLIzCtJLcpLzFFi42I5/e/4NV3xYNUQg/PTmSw2zljPanHwfr3F
	9S/PWS2aF69ns7i88BKrxesXhhZnm96wW1zeNYfNYu2Ru+wWtxtXsFks2FPiwO2xf+4ado++
	LasYPY7f2M7k8XmTXABLFJdNSmpOZllqkb5dAlfGnIcT2Av2GlUcnn6NrYFxtVYXIweHhICJ
	xPrjsl2MnECmmMSFe+vZuhi5OIQEljJKdE2aBuX0MUmcPnePGaSKTcBYYvPyJWAJEYGDTBKz
	T25mAnGYBaYwSjRPWsoEUiUsECGx6vsTsA4WAVWJb8tWsoDYvAJuEvdm32eG2CcncfLYZFYQ
	m1PAXeLi8bVgNUJANVumzGOawMi7gJFhFaNoamlyQXFSeq6hXnFibnFpXrpecn7uJkZIwH3Z
	wbj4mNUhRgEORiUe3hvrVEKEWBPLiitzDzFKcDArifBe8lYNEeJNSaysSi3Kjy8qzUktPsTI
	xMEp1cCozPq97ErpH/Yby//onDrSVPRX4YRVcJx173ZN/rSldxye/DsV5sDqdPFawxuh7VF6
	B87Y6P6fKOLFuPioVpk6m+1cG8kXM5ofcN8u6av9qzPxF9fT1+8+5a44xtMnduRY3ZUtnMUZ
	Nh+K5wQ90N+3M17R1GDpg70fbijb9Ea86EurnyP0j49FiaU4I9FQi7moOBEAPtaTZxYCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel built with extcon and charger-manager.

After connecting the USB cable sleeping function was called from atomic
context:
[   63.328648] BUG: sleeping function called from invalid context at kernel/locking/mutex.c:586
[   63.331449] in_atomic(): 1, irqs_disabled(): 128, pid: 906, name: kworker/1:2
[   63.338562] INFO: lockdep is turned off.
[   63.342468] irq event stamp: 0
[   63.345507] hardirqs last  enabled at (0): [<  (null)>]   (null)
[   63.351495] hardirqs last disabled at (0): [<c00246c8>] copy_process.part.46+0x4a0/0x1684
[   63.359654] softirqs last  enabled at (0): [<c00246c8>] copy_process.part.46+0x4a0/0x1684
[   63.367813] softirqs last disabled at (0): [<  (null)>]   (null)
[   63.373802] Preemption disabled at:[<  (null)>]   (null)
[   63.379097]
[   63.380581] CPU: 1 PID: 906 Comm: kworker/1:2 Not tainted 3.16.2-00822-g691a2ac4e574 #954
[   63.388743] Workqueue: events max14577_muic_irq_work
[   63.393707] [<c00167a4>] (unwind_backtrace) from [<c0012c08>] (show_stack+0x10/0x14)
[   63.401422] [<c0012c08>] (show_stack) from [<c06232ec>] (dump_stack+0x70/0xbc)
[   63.408625] [<c06232ec>] (dump_stack) from [<c0629d0c>] (mutex_lock_nested+0x24/0x410)
[   63.416525] [<c0629d0c>] (mutex_lock_nested) from [<c0354474>] (regmap_read+0x30/0x60)
[   63.424424] [<c0354474>] (regmap_read) from [<c0406b84>] (max14577_charger_get_property+0x1e4/0x250)
[   63.433535] [<c0406b84>] (max14577_charger_get_property) from [<c0403834>] (is_ext_pwr_online+0x30/0x6c)
[   63.442994] [<c0403834>] (is_ext_pwr_online) from [<c0404a54>] (charger_extcon_notifier+0x40/0x70)
[   63.451934] [<c0404a54>] (charger_extcon_notifier) from [<c044cbe4>] (_call_per_cable+0x40/0x4c)
[   63.460704] [<c044cbe4>] (_call_per_cable) from [<c0051560>] (notifier_call_chain+0x64/0x128)
[   63.469209] [<c0051560>] (notifier_call_chain) from [<c0051640>] (raw_notifier_call_chain+0x18/0x20)
[   63.478321] [<c0051640>] (raw_notifier_call_chain) from [<c044d0fc>] (extcon_update_state+0xa8/0x204)
[   63.487522] [<c044d0fc>] (extcon_update_state) from [<c044e5f8>] (max14577_muic_chg_handler+0xdc/0x180)
[   63.496897] [<c044e5f8>] (max14577_muic_chg_handler) from [<c044e924>] (max14577_muic_irq_work+0x7c/0xd8)
[   63.506445] [<c044e924>] (max14577_muic_irq_work) from [<c004480c>] (process_one_work+0x198/0x66c)
[   63.515385] [<c004480c>] (process_one_work) from [<c0044d4c>] (worker_thread+0x38/0x564)
[   63.523455] [<c0044d4c>] (worker_thread) from [<c004c4ec>] (kthread+0xcc/0xe8)
[   63.530661] [<c004c4ec>] (kthread) from [<c000f1f8>] (ret_from_fork+0x14/0x3c)
[   63.543926] charger_manager: Set current limit of CHARGER : 450000uA ~ 450000uA
[   63.548870] extcon-port jack: jack event CHGDET=usb
[   63.550592] extcon-port jack: jack event CHGDET=charger
[   64.188607] charger-manager charger-manager@0: Failed to get battery temperature
[   64.200684] charger-manager charger-manager@0: CHARGING

The first sleeping function is is_ext_pwr_online()
(drivers/power/charger-manager.c). The atomic context initiating the
flow is set up in extcon_update_state() (drivers/extcon/extcon-class.c).

The extcon_update_state() uses spin locks which are not necessary
because the function is not called from interrupt service routines.
Instead, the extcon_update_state() is called from:
1. Threaded interrupt handlers.
2. Work queues.

Replace the spin lock with mutex and update the documentation of this
function.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/extcon/extcon-class.c | 15 ++++++++-------
 include/linux/extcon.h        |  3 ++-
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
index 4c2f2c543bb7..7485600baeff 100644
--- a/drivers/extcon/extcon-class.c
+++ b/drivers/extcon/extcon-class.c
@@ -201,6 +201,8 @@ static ssize_t cable_state_show(struct device *dev,
  *
  * Note that the notifier provides which bits are changed in the state
  * variable with the val parameter (second) to the callback.
+ *
+ * The function may sleep thus may not be called from atomic context.
  */
 int extcon_update_state(struct extcon_dev *edev, u32 mask, u32 state)
 {
@@ -210,16 +212,15 @@ int extcon_update_state(struct extcon_dev *edev, u32 mask, u32 state)
 	char *envp[3];
 	int env_offset = 0;
 	int length;
-	unsigned long flags;
 
-	spin_lock_irqsave(&edev->lock, flags);
+	mutex_lock(&edev->lock);
 
 	if (edev->state != ((edev->state & ~mask) | (state & mask))) {
 		u32 old_state = edev->state;
 
 		if (check_mutually_exclusive(edev, (edev->state & ~mask) |
 						   (state & mask))) {
-			spin_unlock_irqrestore(&edev->lock, flags);
+			mutex_unlock(&edev->lock);
 			return -EPERM;
 		}
 
@@ -248,20 +249,20 @@ int extcon_update_state(struct extcon_dev *edev, u32 mask, u32 state)
 			}
 			envp[env_offset] = NULL;
 			/* Unlock early before uevent */
-			spin_unlock_irqrestore(&edev->lock, flags);
+			mutex_unlock(&edev->lock);
 
 			kobject_uevent_env(&edev->dev.kobj, KOBJ_CHANGE, envp);
 			free_page((unsigned long)prop_buf);
 		} else {
 			/* Unlock early before uevent */
-			spin_unlock_irqrestore(&edev->lock, flags);
+			mutex_unlock(&edev->lock);
 
 			dev_err(&edev->dev, "out of memory in extcon_set_state\n");
 			kobject_uevent(&edev->dev.kobj, KOBJ_CHANGE);
 		}
 	} else {
 		/* No changes */
-		spin_unlock_irqrestore(&edev->lock, flags);
+		mutex_unlock(&edev->lock);
 	}
 
 	return 0;
@@ -834,7 +835,7 @@ int extcon_dev_register(struct extcon_dev *edev)
 		ret = class_compat_create_link(switch_class, &edev->dev, NULL);
 #endif /* CONFIG_ANDROID */
 
-	spin_lock_init(&edev->lock);
+	mutex_init(&edev->lock);
 
 	RAW_INIT_NOTIFIER_HEAD(&edev->nh);
 
diff --git a/include/linux/extcon.h b/include/linux/extcon.h
index 36f49c405dfb..166f42cecd5a 100644
--- a/include/linux/extcon.h
+++ b/include/linux/extcon.h
@@ -26,6 +26,7 @@
 #include <linux/device.h>
 #include <linux/notifier.h>
 #include <linux/sysfs.h>
+#include <linux/mutex.h>
 
 #define SUPPORTED_CABLE_MAX	32
 #define CABLE_NAME_MAX		30
@@ -125,7 +126,7 @@ struct extcon_dev {
 	struct raw_notifier_head nh;
 	struct list_head entry;
 	int max_supported;
-	spinlock_t lock;	/* could be called by irq handler */
+	struct mutex lock;
 	u32 state;
 
 	/* /sys/class/extcon/.../cable.n/... */
-- 
1.9.1

