Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757899Ab3KMD15 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 22:27:57 -0500
Received: from mga09.intel.com ([134.134.136.24]:26624 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755444Ab3KMD1t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 22:27:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="434309665"
From: Lan Tianyu <tianyu.lan@intel.com>
To: lenb@kernel.org, rjw@rjwysocki.net, rui.zhang@intel.com
Cc: Lan Tianyu <tianyu.lan@intel.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ACPI/AC: Remove the pointer of struct acpi_device in the struct acpi_ac
Date: Wed, 13 Nov 2013 11:27:42 +0800
Message-Id: <1384313262-20029-1-git-send-email-tianyu.lan@intel.com>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now the pointer of struct acpi_device can be got by
ACPI_COMPANION(struct acpi_ac->pdev->dev). So the pointer
is not necessary and remove it.

Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
---
 drivers/acpi/ac.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/acpi/ac.c b/drivers/acpi/ac.c
index b9f0d5f..8711e37 100644
--- a/drivers/acpi/ac.c
+++ b/drivers/acpi/ac.c
@@ -56,7 +56,6 @@ static int ac_sleep_before_get_state_ms;
 
 struct acpi_ac {
 	struct power_supply charger;
-	struct acpi_device *adev;
 	struct platform_device *pdev;
 	unsigned long long state;
 };
@@ -70,8 +69,9 @@ struct acpi_ac {
 static int acpi_ac_get_state(struct acpi_ac *ac)
 {
 	acpi_status status;
+	acpi_handle handle = ACPI_HANDLE(&ac->pdev->dev);
 
-	status = acpi_evaluate_integer(ac->adev->handle, "_PSR", NULL,
+	status = acpi_evaluate_integer(handle, "_PSR", NULL,
 				       &ac->state);
 	if (ACPI_FAILURE(status)) {
 		ACPI_EXCEPTION((AE_INFO, status,
@@ -119,6 +119,7 @@ static enum power_supply_property ac_props[] = {
 static void acpi_ac_notify_handler(acpi_handle handle, u32 event, void *data)
 {
 	struct acpi_ac *ac = data;
+	struct acpi_device *adev;
 
 	if (!ac)
 		return;
@@ -141,10 +142,11 @@ static void acpi_ac_notify_handler(acpi_handle handle, u32 event, void *data)
 			msleep(ac_sleep_before_get_state_ms);
 
 		acpi_ac_get_state(ac);
-		acpi_bus_generate_netlink_event(ac->adev->pnp.device_class,
+		adev = ACPI_COMPANION(&ac->pdev->dev);
+		acpi_bus_generate_netlink_event(adev->pnp.device_class,
 						dev_name(&ac->pdev->dev),
 						event, (u32) ac->state);
-		acpi_notifier_call_chain(ac->adev, event, (u32) ac->state);
+		acpi_notifier_call_chain(adev, event, (u32) ac->state);
 		kobject_uevent(&ac->charger.dev->kobj, KOBJ_CHANGE);
 	}
 
@@ -178,8 +180,8 @@ static int acpi_ac_probe(struct platform_device *pdev)
 	if (!pdev)
 		return -EINVAL;
 
-	result = acpi_bus_get_device(ACPI_HANDLE(&pdev->dev), &adev);
-	if (result)
+	adev = ACPI_COMPANION(&pdev->dev);
+	if (!adev)
 		return -ENODEV;
 
 	ac = kzalloc(sizeof(struct acpi_ac), GFP_KERNEL);
@@ -188,7 +190,6 @@ static int acpi_ac_probe(struct platform_device *pdev)
 
 	strcpy(acpi_device_name(adev), ACPI_AC_DEVICE_NAME);
 	strcpy(acpi_device_class(adev), ACPI_AC_CLASS);
-	ac->adev = adev;
 	ac->pdev = pdev;
 	platform_set_drvdata(pdev, ac);
 
-- 
1.8.2.1

