Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932390AbaHVPvJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 11:51:09 -0400
Received: from top.free-electrons.com ([176.31.233.9]:55529 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932263AbaHVPua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 11:50:30 -0400
From: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>
To: balbi@ti.com, gregkh@linuxfoundation.org, Peter.Chen@freescale.com,
        kishon@ti.com, stern@rowland.harvard.edu
Cc: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        sergei.shtylyov@cogentembedded.com, yoshihiro.shimoda.uh@renesas.com,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 8/9] usb: chipidea: move usb_otg into struct ci_hdrc
Date: Fri, 22 Aug 2014 17:50:19 +0200
Message-Id: <1408722621-3635-9-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408722621-3635-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1408722621-3635-1-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the usb_otg member from struct usb_phy to struct ci_hdrc. Rework
its initialization taking in account this modification.

Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
---
 drivers/usb/chipidea/ci.h      |  1 +
 drivers/usb/chipidea/host.c    |  8 +++-----
 drivers/usb/chipidea/otg_fsm.c | 15 ++-------------
 3 files changed, 6 insertions(+), 18 deletions(-)

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
index 0b67d78dd953..0952d4adfa4c 100644
--- a/drivers/usb/chipidea/host.c
+++ b/drivers/usb/chipidea/host.c
@@ -85,13 +85,11 @@ static int host_start(struct ci_hdrc *ci)
 	if (ret) {
 		goto disable_reg;
 	} else {
-		struct usb_otg *otg = ci->usb_phy->otg;
+		struct usb_otg *otg = &ci->otg;
 
 		ci->hcd = hcd;
-		if (otg) {
-			otg->host = &hcd->self;
-			hcd->self.otg_port = 1;
-		}
+		otg->host = &hcd->self;
+		hcd->self.otg_port = 1;
 	}
 
 	if (ci->platdata->flags & CI_HDRC_DISABLE_STREAMING)
diff --git a/drivers/usb/chipidea/otg_fsm.c b/drivers/usb/chipidea/otg_fsm.c
index 8a64ce87364e..7eb86863fb3c 100644
--- a/drivers/usb/chipidea/otg_fsm.c
+++ b/drivers/usb/chipidea/otg_fsm.c
@@ -778,20 +778,9 @@ void ci_hdrc_otg_fsm_start(struct ci_hdrc *ci)
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
+	ci->fsm.otg = &ci->otg;
 	ci->fsm.power_up = 1;
 	ci->fsm.id = hw_read_otgsc(ci, OTGSC_ID) ? 1 : 0;
 	ci->fsm.otg->state = OTG_STATE_UNDEFINED;
-- 
1.9.1

