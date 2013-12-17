Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826Ab3LQUGk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 15:06:40 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:63904 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753782Ab3LQUGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 15:06:37 -0500
Message-ID: <52B0AEC8.4030003@gmail.com>
Date: Tue, 17 Dec 2013 12:06:32 -0800
From: Rajat Jain <rajatjain.linux@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
CC: Guenter Roeck <groeck@juniper.net>, Rajat Jain <rajatjain@juniper.net>,
        Rajat Jain <rajatxjain@gmail.com>
Subject: [PATCH v3 5/8] pciehp: Don't check for adapter or latch status while
 disabling
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It does not make much sense to refuse to disable a slot if an
adapter is not present or the latch is open. If an adapter is not
present, it provides an even better reason to disable the device
slot.

This is specially a problem for link state hot-plug, because some
ports use in band mechanism for presence detection. Thus
when link goes down, presence detect also goes down. We _want_ that
the removal should take place in such case.

Thus remove the checks for adapter and latch in pciehp_disable_slot()

Signed-off-by: Rajat Jain <rajatjain@juniper.net>
Signed-off-by: Guenter Roeck <groeck@juniper.net>
---
v3: * created by splitting the patch v2 [2/4]
    * Remove the check for latch as well
v2: (non existent)
v1: (non existent)

 drivers/pci/hotplug/pciehp_ctrl.c |   18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/drivers/pci/hotplug/pciehp_ctrl.c b/drivers/pci/hotplug/pciehp_ctrl.c
index 7ae7b02..e934618 100644
--- a/drivers/pci/hotplug/pciehp_ctrl.c
+++ b/drivers/pci/hotplug/pciehp_ctrl.c
@@ -612,24 +612,6 @@ int pciehp_disable_slot(struct slot *p_slot)
 	if (!p_slot->ctrl)
 		return 1;
 
-	if (!HP_SUPR_RM(p_slot->ctrl)) {
-		ret = pciehp_get_adapter_status(p_slot, &getstatus);
-		if (ret || !getstatus) {
-			ctrl_info(ctrl, "No adapter on slot(%s)\n",
-				  slot_name(p_slot));
-			return -ENODEV;
-		}
-	}
-
-	if (MRL_SENS(p_slot->ctrl)) {
-		ret = pciehp_get_latch_status(p_slot, &getstatus);
-		if (ret || getstatus) {
-			ctrl_info(ctrl, "Latch open on slot(%s)\n",
-				  slot_name(p_slot));
-			return -ENODEV;
-		}
-	}
-
 	if (POWER_CTRL(p_slot->ctrl)) {
 		ret = pciehp_get_power_status(p_slot, &getstatus);
 		if (ret || !getstatus) {
-- 
1.7.9.5

