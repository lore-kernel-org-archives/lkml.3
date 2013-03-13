Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932070Ab3CMIr0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 04:47:26 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:46122 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755032Ab3CMIrX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 04:47:23 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <tony@atomide.com>, <notasas@gmail.com>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: [PATCH 2/5] usb: musb: omap: always glue have the correct vbus/id status
Date: Wed, 13 Mar 2013 14:17:07 +0530
Message-ID: <1363164430-19118-3-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363164430-19118-1-git-send-email-kishon@ti.com>
References: <1363164430-19118-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the case where omap glue is loaded and musb core is not, glue->status
wont have a valid status if the phy drivers call omap_musb_mailbox. So
fixed the conditions here.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/usb/musb/omap2430.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
index 78bfc50..28a0220 100644
--- a/drivers/usb/musb/omap2430.c
+++ b/drivers/usb/musb/omap2430.c
@@ -236,13 +236,10 @@ void omap_musb_mailbox(enum omap_musb_vbus_id_status status)
 {
 	struct omap2430_glue	*glue = _glue;
 
-	if (glue && glue_to_musb(glue)) {
-		glue->status = status;
-	} else {
-		pr_err("%s: musb core is not yet ready\n", __func__);
+	if (!glue)
 		return;
-	}
 
+	glue->status = status;
 	schedule_work(&glue->omap_musb_mailbox_work);
 }
 EXPORT_SYMBOL_GPL(omap_musb_mailbox);
@@ -307,7 +304,9 @@ static void omap_musb_mailbox_work(struct work_struct *mailbox_work)
 {
 	struct omap2430_glue *glue = container_of(mailbox_work,
 				struct omap2430_glue, omap_musb_mailbox_work);
-	omap_musb_set_mailbox(glue);
+
+	if (glue_to_musb(glue))
+		omap_musb_set_mailbox(glue);
 }
 
 static irqreturn_t omap2430_musb_interrupt(int irq, void *__hci)
-- 
1.7.10.4

