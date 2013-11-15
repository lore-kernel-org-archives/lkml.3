Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751768Ab3KOOXJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 09:23:09 -0500
Received: from mail-bk0-f48.google.com ([209.85.214.48]:61148 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023Ab3KOOWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 09:22:45 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Nicolas Pitre <nico@fluxnic.net>, Chris Ball <cjb@laptop.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] mmc: mvsdio: workaround for spurious irqs
Date: Fri, 15 Nov 2013 15:22:33 +0100
Message-Id: <1384525354-901-3-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1384525354-901-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1384525354-901-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SDIO controllers found on Marvell Kirkwood SoCs seem to cause a late,
spurious irq although all interrupts have been disabled. This irq
doesn't do any harm, neither to HW nor driver. To avoid some
"unexpected irq" warning later, we workaround above issue by bailing
out of irq handler early, if we didn't expect any.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Nicolas Pitre <nico@fluxnic.net>
Cc: Chris Ball <cjb@laptop.org>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: linux-mmc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/mmc/host/mvsdio.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/host/mvsdio.c b/drivers/mmc/host/mvsdio.c
index 06c5b0b..25f51be 100644
--- a/drivers/mmc/host/mvsdio.c
+++ b/drivers/mmc/host/mvsdio.c
@@ -354,6 +354,21 @@ static irqreturn_t mvsd_irq(int irq, void *dev)
 		intr_status, mvsd_read(MVSD_NOR_INTR_EN),
 		mvsd_read(MVSD_HW_STATE));
 
+	/*
+	 * It looks like, SDIO IP can issue one late, spurious irq
+	 * although all irqs should be disabled. To work around this,
+	 * bail out early, if we didn't expect any irqs to occur.
+	 */
+	if (!mvsd_read(MVSD_NOR_INTR_EN) && !mvsd_read(MVSD_ERR_INTR_EN)) {
+		dev_dbg(host->dev,
+			"spurious irq detected intr 0x%04x intr_en 0x%04x erri 0x%04x erri_en 0x%04x\n",
+			mvsd_read(MVSD_NOR_INTR_STATUS),
+			mvsd_read(MVSD_NOR_INTR_EN),
+			mvsd_read(MVSD_ERR_INTR_STATUS),
+			mvsd_read(MVSD_ERR_INTR_EN));
+		return IRQ_HANDLED;
+	}
+
 	spin_lock(&host->lock);
 
 	/* PIO handling, if needed. Messy business... */
-- 
1.7.2.5

