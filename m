Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417AbaIOKlx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 06:41:53 -0400
Received: from top.free-electrons.com ([176.31.233.9]:36842 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753440AbaIOKfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 06:35:20 -0400
From: Antoine Tenart <antoine.tenart@free-electrons.com>
To: balbi@ti.com, gregkh@linuxfoundation.org, Peter.Chen@freescale.com,
        kishon@ti.com, stern@rowland.harvard.edu
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        sergei.shtylyov@cogentembedded.com, yoshihiro.shimoda.uh@renesas.com,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 8/9] usb: chipidea: move usb_otg into struct ci_hdrc
Date: Mon, 15 Sep 2014 12:35:08 +0200
Message-Id: <1410777309-12552-9-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410777309-12552-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1410777309-12552-1-git-send-email-antoine.tenart@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the usb_otg member from struct usb_phy to struct ci_hdrc. Rework
its initialization taking in account this modification.

Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
Acked-by: Peter Chen <peter.chen@freescale.com>
---
 drivers/usb/chipidea/ci.h      |  1 +
 drivers/usb/chipidea/host.c    |  5 +++--
 drivers/usb/chipidea/otg_fsm.c | 16 +++-------------
 3 files changed, 7 insertions(+), 15 deletions(-)

diff --git a/drivers/usb/chipidea/ci.h b/drivers/usb/chipidea/ci.h
index b2caa1772712..dac5ab6adfa2 100644
--- a/drivers/usb/chipidea/ci.h
+++ b/drivers/usb/chipidea/ci.h
@@ -177,6 +177,7 @@ struct ci_hdrc {
 	struct ci_role_driver		*roles[CI_ROLE_END];
 	enum ci_role			role;
 	bool				is_otg;
+	struct usb_otg			otg;
 	struct otg_fsm			fsm;
 	struct ci_otg_fsm_timer_list	*fsm_timer;
 	struct work_struct		work;
diff --git a/drivers/usb/chipidea/host.c b/drivers/usb/chipidea/host.c
index 0b67d78dd953..4fcebb6a6d14 100644
--- a/drivers/usb/chipidea/host.c
+++ b/drivers/usb/chipidea/host.c
@@ -85,10 +85,11 @@ static int host_start(struct ci_hdrc *ci)
 	if (ret) {
 		goto disable_reg;
 	} else {
-		struct usb_otg *otg = ci->usb_phy->otg;
+		struct usb_otg *otg = &ci->otg;
 
 		ci->hcd = hcd;
-		if (otg) {
+
+		if (ci_otg_is_fsm_mode(ci)) {
 			otg->host = &hcd->self;
 			hcd->self.otg_port = 1;
 		}
diff --git a/drivers/usb/chipidea/otg_fsm.c b/drivers/usb/chipidea/otg_fsm.c
index 8a64ce87364e..862d7cb01b92 100644
--- a/drivers/usb/chipidea/otg_fsm.c
+++ b/drivers/usb/chipidea/otg_fsm.c
@@ -778,20 +778,10 @@ void ci_hdrc_otg_fsm_start(struct ci_hdrc *ci)
 int ci_hdrc_otg_fsm_init(struct ci_hdrc *ci)
 {
 	int retval = 0;
-	struct usb_otg *otg;
 
-	otg = devm_kzalloc(ci->dev,
-			sizeof(struct usb_otg), GFP_KERNEL);
-	if (!otg) {
-		dev_err(ci->dev,
-		"Failed to allocate usb_otg structure for ci hdrc otg!\n");
-		return -ENOMEM;
-	}
-
-	otg->usb_phy = ci->usb_phy;
-	otg->gadget = &ci->gadget;
-	ci->fsm.otg = otg;
-	ci->usb_phy->otg = ci->fsm.otg;
+	ci->otg.usb_phy = ci->usb_phy;
+	ci->otg.gadget = &ci->gadget;
+	ci->fsm.otg = &ci->otg;
 	ci->fsm.power_up = 1;
 	ci->fsm.id = hw_read_otgsc(ci, OTGSC_ID) ? 1 : 0;
 	ci->fsm.otg->state = OTG_STATE_UNDEFINED;
-- 
1.9.1

