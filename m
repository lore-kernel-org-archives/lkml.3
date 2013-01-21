Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632Ab3AUMHK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 07:07:10 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:48344 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754346Ab3AUMEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 07:04:54 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, anton.vorontsov@linaro.org,
        cbou@mail.ru, Jonas Aaberg <jonas.aberg@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 16/24] ab8500-bm: Flush all work queues before suspending
Date: Mon, 21 Jan 2013 12:03:52 +0000
Message-Id: <1358769840-4763-17-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358769840-4763-1-git-send-email-lee.jones@linaro.org>
References: <1358769840-4763-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonas Aaberg <jonas.aberg@stericsson.com>

Flush all workqueues at suspend time to avoid suspending during work.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Reviewed-by: Marcus COOPER <marcus.xm.cooper@stericsson.com>
Reviewed-on: http://gerrit.lud.stericsson.com/gerrit/61915
---
 drivers/power/ab8500_charger.c |   11 +++++++++++
 drivers/power/ab8500_fg.c      |    5 +++++
 2 files changed, 16 insertions(+)

diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
index da965ee..a632b94 100644
--- a/drivers/power/ab8500_charger.c
+++ b/drivers/power/ab8500_charger.c
@@ -2866,6 +2866,17 @@ static int ab8500_charger_suspend(struct platform_device *pdev,
 	if (delayed_work_pending(&di->check_hw_failure_work))
 		cancel_delayed_work(&di->check_hw_failure_work);
 
+	flush_delayed_work(&di->attach_work);
+	flush_delayed_work(&di->usb_charger_attached_work);
+	flush_delayed_work(&di->ac_charger_attached_work);
+	flush_delayed_work(&di->check_usbchgnotok_work);
+	flush_delayed_work(&di->check_vbat_work);
+	flush_delayed_work(&di->kick_wd_work);
+
+	flush_work(&di->usb_link_status_work);
+	flush_work(&di->ac_work);
+	flush_work(&di->detect_usb_type_work);
+
 	return 0;
 }
 #else
diff --git a/drivers/power/ab8500_fg.c b/drivers/power/ab8500_fg.c
index 0378aab..1a78116 100644
--- a/drivers/power/ab8500_fg.c
+++ b/drivers/power/ab8500_fg.c
@@ -2410,6 +2410,11 @@ static int ab8500_fg_suspend(struct platform_device *pdev,
 	struct ab8500_fg *di = platform_get_drvdata(pdev);
 
 	flush_delayed_work(&di->fg_periodic_work);
+	flush_work(&di->fg_work);
+	flush_work(&di->fg_acc_cur_work);
+	flush_delayed_work(&di->fg_reinit_work);
+	flush_delayed_work(&di->fg_low_bat_work);
+	flush_delayed_work(&di->fg_check_hw_failure_work);
 
 	/*
 	 * If the FG is enabled we will disable it before going to suspend
-- 
1.7.9.5

