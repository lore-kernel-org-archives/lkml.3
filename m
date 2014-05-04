Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756368AbaEDQ0d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 12:26:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36300 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754354AbaEDPmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:42:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Daniel Mack <zonque@gmail.com>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH 3.14 128/158] usb: phy: am335x-control: wait 1ms after power-up transitions
Date: Sun,  4 May 2014 11:40:37 -0400
Message-Id: <20140504154047.392642634@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154029.975081050@linuxfoundation.org>
References: <20140504154029.975081050@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Mack <zonque@gmail.com>

commit a31a942a148e0083ce560ffeb54fb60e06ab7201 upstream.

Tests have shown that when a power-up transition is followed by other
PHY operations too quickly, the USB port appears dead. Waiting 1ms fixes
this problem.

Signed-off-by: Daniel Mack <zonque@gmail.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/phy/phy-am335x-control.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/usb/phy/phy-am335x-control.c
+++ b/drivers/usb/phy/phy-am335x-control.c
@@ -3,6 +3,7 @@
 #include <linux/err.h>
 #include <linux/of.h>
 #include <linux/io.h>
+#include <linux/delay.h>
 #include "am35x-phy-control.h"
 
 struct am335x_control_usb {
@@ -86,6 +87,14 @@ static void am335x_phy_power(struct phy_
 	}
 
 	writel(val, usb_ctrl->phy_reg + reg);
+
+	/*
+	 * Give the PHY ~1ms to complete the power up operation.
+	 * Tests have shown unstable behaviour if other USB PHY related
+	 * registers are written too shortly after such a transition.
+	 */
+	if (on)
+		mdelay(1);
 }
 
 static const struct phy_control ctrl_am335x = {


