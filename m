Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932960AbaAGALY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 19:11:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47394 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756763AbaAFWiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:38:18 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michael Grzeschik <mgr@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Peter Chen <peter.chen@freescale.com>
Subject: [PATCH 3.12 028/144] usb: chipidea: fix nobody cared IRQ when booting with host role
Date: Mon,  6 Jan 2014 14:36:29 -0800
Message-Id: <20140106223746.132695732@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223745.326293132@linuxfoundation.org>
References: <20140106223745.326293132@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Chen <peter.chen@freescale.com>

commit 5a1e1456fc633da5291285b1fff75d2a7507375b upstream.

If we connect Male-A-To-Male-A cable between otg-host and host pc,
the ci->vbus_active is set wrongly, and cause the controller run
at peripheral mode when we load gadget module (ci_udc_start will be run),
but the software runs at host mode due to id = 0. The ehci_irq
can't handle suspend (USBi_SLI) interrupt which is enabled for
peripheral mode, it causes no one will handle irq error.

This patch is needed for 3.12 stable

Acked-by: Michael Grzeschik <mgr@pengutronix.de>
Reported-by: Marc Kleine-Budde <mkl@pengutronix.de>
Tested-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Peter Chen <peter.chen@freescale.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/chipidea/core.c |    4 ++++
 drivers/usb/chipidea/udc.c  |    3 ---
 2 files changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/usb/chipidea/core.c
+++ b/drivers/usb/chipidea/core.c
@@ -575,6 +575,10 @@ static int ci_hdrc_probe(struct platform
 			: CI_ROLE_GADGET;
 	}
 
+	/* only update vbus status for peripheral */
+	if (ci->role == CI_ROLE_GADGET)
+		ci_handle_vbus_change(ci);
+
 	ret = ci_role_start(ci, ci->role);
 	if (ret) {
 		dev_err(dev, "can't start %s role\n", ci_role(ci)->name);
--- a/drivers/usb/chipidea/udc.c
+++ b/drivers/usb/chipidea/udc.c
@@ -1818,9 +1818,6 @@ static int udc_start(struct ci_hdrc *ci)
 	pm_runtime_no_callbacks(&ci->gadget.dev);
 	pm_runtime_enable(&ci->gadget.dev);
 
-	/* Update ci->vbus_active */
-	ci_handle_vbus_change(ci);
-
 	return retval;
 
 remove_trans:


