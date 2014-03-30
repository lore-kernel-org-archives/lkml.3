Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222AbaC3Neb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 09:34:31 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:58703 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbaC3Nea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 09:34:30 -0400
From: Mathias Krause <minipli@googlemail.com>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org, Mathias Krause <minipli@googlemail.com>,
        PaX Team <pageexec@freemail.hu>, Felipe Balbi <balbi@ti.com>,
        Anton Vorontsov <anton@enomsg.org>
Subject: [PATCH 2/2] pda_power: Unregister USB notifier in pda_power_remove()
Date: Sun, 30 Mar 2014 15:34:15 +0200
Message-Id: <1396186455-3276-3-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1396186455-3276-1-git-send-email-minipli@googlemail.com>
References: <1396186455-3276-1-git-send-email-minipli@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we've registered a notifier in pda_power_probe() we must deregister
it in pda_power_remove() to not let it work on stale data like, e.g.,
the charger timer.

Cc: Felipe Balbi <balbi@ti.com>
Cc: Anton Vorontsov <anton@enomsg.org>
Signed-off-by: Mathias Krause <minipli@googlemail.com>
---
 drivers/power/pda_power.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/power/pda_power.c b/drivers/power/pda_power.c
index 87a963d0a8..aba23d6848 100644
--- a/drivers/power/pda_power.c
+++ b/drivers/power/pda_power.c
@@ -430,6 +430,11 @@ static int pda_power_remove(struct platform_device *pdev)
 	if (pdata->is_ac_online && ac_irq)
 		free_irq(ac_irq->start, &pda_psy_ac);
 
+#if IS_ENABLED(CONFIG_USB_PHY)
+	if (!IS_ERR_OR_NULL(transceiver) && pdata->use_otg_notifier)
+		usb_unregister_notifier(transceiver, &otg_nb);
+#endif
+
 	if (polling)
 		del_timer_sync(&polling_timer);
 	del_timer_sync(&charger_timer);
-- 
1.7.10.4

