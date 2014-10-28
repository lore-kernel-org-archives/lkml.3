Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961AbaJ1Qia (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 12:38:30 -0400
Received: from down.free-electrons.com ([37.187.137.238]:34782 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752220AbaJ1Qft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 12:35:49 -0400
From: Antoine Tenart <antoine.tenart@free-electrons.com>
To: balbi@ti.com, gregkh@linuxfoundation.org, Peter.Chen@freescale.com,
        kishon@ti.com, stern@rowland.harvard.edu
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v7 6/7] usb: chipidea: move usb_otg into struct ci_hdrc
Date: Tue, 28 Oct 2014 17:35:40 +0100
Message-Id: <1414514141-31767-7-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414514141-31767-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1414514141-31767-1-git-send-email-antoine.tenart@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the usb_otg member from struct usb_phy to struct ci_hdrc. Rework
its initialization taking in account this modification.

Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
Acked-by: Peter Chen <peter.chen@freescale.com>
---
 drivers/usb/chipidea/ci.h      |  1 +
 drivers/usb/chipidea/debug.c   |  2 +-
 drivers/usb/chipidea/host.c    |  5 +++--
 drivers/usb/chipidea/otg_fsm.c | 16 +++-------------
 4 files changed, 8 insertions(+), 16 deletions(-)

diff --git a/drivers/usb/chipidea/ci.h b/drivers/usb/chipidea/ci.h
index b7f589b348e6..9015139a8027 100644
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
diff --git a/drivers/usb/chipidea/debug.c b/drivers/usb/chipidea/debug.c
index 8f437e1512fa..999e9d683d7a 100644
--- a/drivers/usb/chipidea/debug.c
+++ b/drivers/usb/chipidea/debug.c
@@ -220,7 +220,7 @@ static int ci_otg_show(struct seq_file *s, void *unused)
 
 	/* ------ State ----- */
 	seq_printf(s, "OTG state: %s\n\n",
-		usb_otg_state_string(ci->usb_phy->otg.state));
+		   usb_otg_state_string(ci->otg.state));
 
 	/* ------ State Machine Variables ----- */
 	seq_printf(s, "a_bus_drop: %d\n", fsm->a_bus_drop);
diff --git a/drivers/usb/chipidea/host.c b/drivers/usb/chipidea/host.c
index 51b086d3bb11..789809f680aa 100644
--- a/drivers/usb/chipidea/host.c
+++ b/drivers/usb/chipidea/host.c
@@ -86,10 +86,11 @@ static int host_start(struct ci_hdrc *ci)
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

