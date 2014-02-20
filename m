Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753677AbaBTUov (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 15:44:51 -0500
Received: from mail-qg0-f51.google.com ([209.85.192.51]:56399 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753482AbaBTUop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 15:44:45 -0500
From: Tejun Heo <tj@kernel.org>
To: laijs@cn.fujitsu.com
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: [PATCH 5/9] usb: don't use PREPARE_DELAYED_WORK
Date: Thu, 20 Feb 2014 15:44:27 -0500
Message-Id: <1392929071-16555-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1392929071-16555-1-git-send-email-tj@kernel.org>
References: <1392929071-16555-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PREPARE_[DELAYED_]WORK() are being phased out.  They have few users
and a nasty surprise in terms of reentrancy guarantee as workqueue
considers work items to be different if they don't have the same work
function.

usb_hub->init_work is multiplexed with multiple work functions.
Introduce hub_init_workfn() which invokes usb_hub->init_workfn and
always use it as the work function and update the users to set the
->init_workfn field instead of overriding the work function using
PREPARE_DELAYED_WORK().

It looks like that the work items are never queued while in-flight, so
simply using INIT_DELAYED_WORK() before each queueing could be enough.
This patch performs equivalent conversion just in case but we probably
wanna clean it up later if that's the case.

It would probably be best to route this with other related updates
through the workqueue tree.

Lightly tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org
---
 drivers/usb/core/hub.c | 13 ++++++++++---
 drivers/usb/core/hub.h |  1 +
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 64ea219..2bc61c0 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -1040,7 +1040,7 @@ static void hub_activate(struct usb_hub *hub, enum hub_activation_type type)
 		 */
 		if (type == HUB_INIT) {
 			delay = hub_power_on(hub, false);
-			PREPARE_DELAYED_WORK(&hub->init_work, hub_init_func2);
+			hub->init_workfn = hub_init_func2;
 			schedule_delayed_work(&hub->init_work,
 					msecs_to_jiffies(delay));
 
@@ -1194,7 +1194,7 @@ static void hub_activate(struct usb_hub *hub, enum hub_activation_type type)
 
 		/* Don't do a long sleep inside a workqueue routine */
 		if (type == HUB_INIT2) {
-			PREPARE_DELAYED_WORK(&hub->init_work, hub_init_func3);
+			hub->init_workfn = hub_init_func3;
 			schedule_delayed_work(&hub->init_work,
 					msecs_to_jiffies(delay));
 			return;		/* Continues at init3: below */
@@ -1634,6 +1634,13 @@ static void hub_disconnect(struct usb_interface *intf)
 	kref_put(&hub->kref, hub_release);
 }
 
+static void hub_init_workfn(struct work_struct *work)
+{
+	struct usb_hub *hub = container_of(to_delayed_work(work),
+					   struct usb_hub, init_work);
+	hub->init_workfn(work);
+}
+
 static int hub_probe(struct usb_interface *intf, const struct usb_device_id *id)
 {
 	struct usb_host_interface *desc;
@@ -1728,7 +1735,7 @@ descriptor_error:
 	hub->intfdev = &intf->dev;
 	hub->hdev = hdev;
 	INIT_DELAYED_WORK(&hub->leds, led_work);
-	INIT_DELAYED_WORK(&hub->init_work, NULL);
+	INIT_DELAYED_WORK(&hub->init_work, hub_init_workfn);
 	usb_get_intf(intf);
 
 	usb_set_intfdata (intf, hub);
diff --git a/drivers/usb/core/hub.h b/drivers/usb/core/hub.h
index df629a3..ef81463 100644
--- a/drivers/usb/core/hub.h
+++ b/drivers/usb/core/hub.h
@@ -72,6 +72,7 @@ struct usb_hub {
 	unsigned		has_indicators:1;
 	u8			indicator[USB_MAXCHILDREN];
 	struct delayed_work	leds;
+	work_func_t		init_workfn;
 	struct delayed_work	init_work;
 	struct usb_port		**ports;
 };
-- 
1.8.5.3

