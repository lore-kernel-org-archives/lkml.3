Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914AbaKJBt2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 20:49:28 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:39128 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535AbaKJBoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 20:44:39 -0500
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Julian Andres Klode <jak@jak-linux.org>,
        Marc Dietrich <marvin24@gmx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ac100@lists.launchpad.net, devel@driverdev.osuosl.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH v6 33/48] staging: nvec: Register with kernel power-off handler
Date: Sun,  9 Nov 2014 17:42:50 -0800
Message-Id: <1415583785-6980-34-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415583785-6980-1-git-send-email-linux@roeck-us.net>
References: <1415583785-6980-1-git-send-email-linux@roeck-us.net>
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A02020A.54601886.016B,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 184
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Register with kernel power-off handler instead of setting pm_power_off
directly. Register with default priority since we don't know any better.

Cc: Julian Andres Klode <jak@jak-linux.org>
Cc: Marc Dietrich <marvin24@gmx.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Acked-by: Marc Dietrich <marvin24@gmx.de>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
v6:
- This patch: No change.
  Global: Replaced priority defines with enum.
v5:
- Rebase to v3.18-rc3
v4:
- Do not use notifiers but internal functions and data structures to manage
  the list of power-off handlers. Drop unused parameters from callbacks, and
  make the power-off function type void
v3:
- Replace poweroff in all newly introduced variables and in text
  with power_off or power-off as appropriate
- Replace POWEROFF_PRIORITY_xxx with POWER_OFF_PRIORITY_xxx
v2:
- Use define to specify poweroff handler priority
- Use dev_warn instead of dev_err

 drivers/staging/nvec/nvec.c | 21 ++++++++++++---------
 drivers/staging/nvec/nvec.h |  2 ++
 2 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/nvec/nvec.c b/drivers/staging/nvec/nvec.c
index a93208a..acf2ea6 100644
--- a/drivers/staging/nvec/nvec.c
+++ b/drivers/staging/nvec/nvec.c
@@ -33,6 +33,7 @@
 #include <linux/mfd/core.h>
 #include <linux/mutex.h>
 #include <linux/notifier.h>
+#include <linux/pm.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/workqueue.h>
@@ -80,8 +81,6 @@ enum nvec_sleep_subcmds {
 #define LID_SWITCH BIT(1)
 #define PWR_BUTTON BIT(15)
 
-static struct nvec_chip *nvec_power_handle;
-
 static const struct mfd_cell nvec_devices[] = {
 	{
 		.name = "nvec-kbd",
@@ -759,12 +758,14 @@ static void nvec_disable_i2c_slave(struct nvec_chip *nvec)
 }
 #endif
 
-static void nvec_power_off(void)
+static void nvec_power_off(struct power_off_handler_block *this)
 {
+	struct nvec_chip *nvec = container_of(this, struct nvec_chip,
+					      power_off_hb);
 	char ap_pwr_down[] = { NVEC_SLEEP, AP_PWR_DOWN };
 
-	nvec_toggle_global_events(nvec_power_handle, false);
-	nvec_write_async(nvec_power_handle, ap_pwr_down, 2);
+	nvec_toggle_global_events(nvec, false);
+	nvec_write_async(nvec, ap_pwr_down, 2);
 }
 
 /*
@@ -878,8 +879,11 @@ static int tegra_nvec_probe(struct platform_device *pdev)
 	nvec->nvec_status_notifier.notifier_call = nvec_status_notifier;
 	nvec_register_notifier(nvec, &nvec->nvec_status_notifier, 0);
 
-	nvec_power_handle = nvec;
-	pm_power_off = nvec_power_off;
+	nvec->power_off_hb.handler = nvec_power_off;
+	nvec->power_off_hb.priority = POWER_OFF_PRIORITY_DEFAULT;
+	ret = register_power_off_handler(&nvec->power_off_hb);
+	if (ret)
+		dev_warn(nvec->dev, "Failed to register power-off handler\n");
 
 	/* Get Firmware Version */
 	msg = nvec_write_sync(nvec, get_firmware_version, 2);
@@ -914,13 +918,12 @@ static int tegra_nvec_remove(struct platform_device *pdev)
 {
 	struct nvec_chip *nvec = platform_get_drvdata(pdev);
 
+	unregister_power_off_handler(&nvec->power_off_hb);
 	nvec_toggle_global_events(nvec, false);
 	mfd_remove_devices(nvec->dev);
 	nvec_unregister_notifier(nvec, &nvec->nvec_status_notifier);
 	cancel_work_sync(&nvec->rx_work);
 	cancel_work_sync(&nvec->tx_work);
-	/* FIXME: needs check wether nvec is responsible for power off */
-	pm_power_off = NULL;
 
 	return 0;
 }
diff --git a/drivers/staging/nvec/nvec.h b/drivers/staging/nvec/nvec.h
index e271375..d4145da 100644
--- a/drivers/staging/nvec/nvec.h
+++ b/drivers/staging/nvec/nvec.h
@@ -163,6 +163,8 @@ struct nvec_chip {
 	struct nvec_msg *last_sync_msg;
 
 	int state;
+
+	struct power_off_handler_block power_off_hb;
 };
 
 extern int nvec_write_async(struct nvec_chip *nvec, const unsigned char *data,
-- 
1.9.1

