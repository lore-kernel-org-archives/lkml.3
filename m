Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967769Ab3HILMN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 07:12:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56065 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967445Ab3HILML (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 07:12:11 -0400
Date: Fri, 9 Aug 2013 13:12:07 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Alexander Holler <holler@ahsoftware.de>
Cc: rtc-linux@googlegroups.com, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>,
        Andrew de los Reyes <adlr@chromium.org>
Subject: Re: [rtc-linux] Re: [PATCH 2/2 RESEND] rtc: rtc-hid-sensor-time:
 enable HID input processing early
In-Reply-To: <5204BA2E.8000100@ahsoftware.de>
Message-ID: <alpine.LNX.2.00.1308091310490.13089@pobox.suse.cz>
References: <1375382342-25454-1-git-send-email-holler@ahsoftware.de> <1375382342-25454-2-git-send-email-holler@ahsoftware.de> <20130808151106.7ccaedd4ea3d4e5faa6aa220@linux-foundation.org> <5204BA2E.8000100@ahsoftware.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Aug 2013, Alexander Holler wrote:


> =================================
> [ INFO: inconsistent lock state ]
> 3.10.5-dockstar-00038-g03242d1-dirty #408 Not tainted
> ---------------------------------
> inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage.
> swapper/0 [HC1[1]:SC0[0]:HE0:SE1] takes:
>  (&(&sd->dyn_callback_lock)->rlock){?.+...}, at: [<c02af9f8>]
> sensor_hub_raw_event+0x10c/0x204
> {HARDIRQ-ON-W} state was registered at:

I think you need the patch below. Please let me know if it fixes it.





From: Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH] HID: sensor-hub: make dyn_callback_lock IRQ-safe

dyn_callback_lock is being taken from IRQ context through hid_irq_in() ->
hid_input_report() -> sensor_hub_raw_event() -> sensor_hub_get_callback(),
therefore anyone else acquiring it needs to disable IRQs to disable deadlocks.

Reported-by: Alexander Holler <holler@ahsoftware.de>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 drivers/hid/hid-sensor-hub.c |   24 ++++++++++++++----------
 1 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/hid/hid-sensor-hub.c b/drivers/hid/hid-sensor-hub.c
index ca749810..b334e50 100644
--- a/drivers/hid/hid-sensor-hub.c
+++ b/drivers/hid/hid-sensor-hub.c
@@ -147,23 +147,24 @@ int sensor_hub_register_callback(struct hid_sensor_hub_device *hsdev,
 {
 	struct hid_sensor_hub_callbacks_list *callback;
 	struct sensor_hub_data *pdata = hid_get_drvdata(hsdev->hdev);
+	unsigned long flags;
 
-	spin_lock(&pdata->dyn_callback_lock);
+	spin_lock_irqsave(&pdata->dyn_callback_lock, flags);
 	list_for_each_entry(callback, &pdata->dyn_callback_list, list)
 		if (callback->usage_id == usage_id) {
-			spin_unlock(&pdata->dyn_callback_lock);
+			spin_unlock_irqrestore(&pdata->dyn_callback_lock, flags);
 			return -EINVAL;
 		}
 	callback = kzalloc(sizeof(*callback), GFP_ATOMIC);
 	if (!callback) {
-		spin_unlock(&pdata->dyn_callback_lock);
+		spin_unlock_irqrestore(&pdata->dyn_callback_lock, flags);
 		return -ENOMEM;
 	}
 	callback->usage_callback = usage_callback;
 	callback->usage_id = usage_id;
 	callback->priv = NULL;
 	list_add_tail(&callback->list, &pdata->dyn_callback_list);
-	spin_unlock(&pdata->dyn_callback_lock);
+	spin_unlock_irqrestore(&pdata->dyn_callback_lock, flags);
 
 	return 0;
 }
@@ -174,15 +175,16 @@ int sensor_hub_remove_callback(struct hid_sensor_hub_device *hsdev,
 {
 	struct hid_sensor_hub_callbacks_list *callback;
 	struct sensor_hub_data *pdata = hid_get_drvdata(hsdev->hdev);
+	unsigned long flags;
 
-	spin_lock(&pdata->dyn_callback_lock);
+	spin_lock_irqsave(&pdata->dyn_callback_lock, flags);
 	list_for_each_entry(callback, &pdata->dyn_callback_list, list)
 		if (callback->usage_id == usage_id) {
 			list_del(&callback->list);
 			kfree(callback);
 			break;
 		}
-	spin_unlock(&pdata->dyn_callback_lock);
+	spin_unlock_irqrestore(&pdata->dyn_callback_lock, flags);
 
 	return 0;
 }
@@ -359,15 +361,16 @@ static int sensor_hub_suspend(struct hid_device *hdev, pm_message_t message)
 {
 	struct sensor_hub_data *pdata =  hid_get_drvdata(hdev);
 	struct hid_sensor_hub_callbacks_list *callback;
+	unsigned long flags;
 
 	hid_dbg(hdev, " sensor_hub_suspend\n");
-	spin_lock(&pdata->dyn_callback_lock);
+	spin_lock_irqsave(&pdata->dyn_callback_lock, flags);
 	list_for_each_entry(callback, &pdata->dyn_callback_list, list) {
 		if (callback->usage_callback->suspend)
 			callback->usage_callback->suspend(
 					pdata->hsdev, callback->priv);
 	}
-	spin_unlock(&pdata->dyn_callback_lock);
+	spin_unlock_irqrestore(&pdata->dyn_callback_lock, flags);
 
 	return 0;
 }
@@ -376,15 +379,16 @@ static int sensor_hub_resume(struct hid_device *hdev)
 {
 	struct sensor_hub_data *pdata =  hid_get_drvdata(hdev);
 	struct hid_sensor_hub_callbacks_list *callback;
+	unsigned long flags;
 
 	hid_dbg(hdev, " sensor_hub_resume\n");
-	spin_lock(&pdata->dyn_callback_lock);
+	spin_lock_irqsave(&pdata->dyn_callback_lock, flags);
 	list_for_each_entry(callback, &pdata->dyn_callback_list, list) {
 		if (callback->usage_callback->resume)
 			callback->usage_callback->resume(
 					pdata->hsdev, callback->priv);
 	}
-	spin_unlock(&pdata->dyn_callback_lock);
+	spin_unlock_irqrestore(&pdata->dyn_callback_lock, flags);
 
 	return 0;
 }

-- 
Jiri Kosina
SUSE Labs
