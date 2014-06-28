Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755675AbaF1Ru7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 13:50:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53774 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754766AbaF1Ru5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:50:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 3.15 001/139] imx-drm: fix hdmi hotplug detection initial state
Date: Sat, 28 Jun 2014 10:46:02 -0700
Message-Id: <20140628174605.419288110@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174605.352098823@linuxfoundation.org>
References: <20140628174605.352098823@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King <rmk+kernel@arm.linux.org.uk>

commit 98dbeadaf050335df8655d8d9be7a324b6cd896e upstream.

The initial state at boot is assumed to be disconnected, and we hope
to receive an interrupt to update the status.  Let's be more explicit
about the current state - reading the PHY status register tells us
the current level of the hotplug signal, which we can report back in
the _detect() method.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/imx-drm/imx-hdmi.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/drivers/staging/imx-drm/imx-hdmi.c
+++ b/drivers/staging/imx-drm/imx-hdmi.c
@@ -120,8 +120,6 @@ struct imx_hdmi {
 	struct clk *isfr_clk;
 	struct clk *iahb_clk;
 
-	enum drm_connector_status connector_status;
-
 	struct hdmi_data_info hdmi_data;
 	int vic;
 
@@ -1382,7 +1380,9 @@ static enum drm_connector_status imx_hdm
 {
 	struct imx_hdmi *hdmi = container_of(connector, struct imx_hdmi,
 					     connector);
-	return hdmi->connector_status;
+
+	return hdmi_readb(hdmi, HDMI_PHY_STAT0) & HDMI_PHY_HPD ?
+		connector_status_connected : connector_status_disconnected;
 }
 
 static int imx_hdmi_connector_get_modes(struct drm_connector *connector)
@@ -1524,7 +1524,6 @@ static irqreturn_t imx_hdmi_irq(int irq,
 
 			hdmi_modb(hdmi, 0, HDMI_PHY_HPD, HDMI_PHY_POL0);
 
-			hdmi->connector_status = connector_status_connected;
 			imx_hdmi_poweron(hdmi);
 		} else {
 			dev_dbg(hdmi->dev, "EVENT=plugout\n");
@@ -1532,7 +1531,6 @@ static irqreturn_t imx_hdmi_irq(int irq,
 			hdmi_modb(hdmi, HDMI_PHY_HPD, HDMI_PHY_HPD,
 				HDMI_PHY_POL0);
 
-			hdmi->connector_status = connector_status_disconnected;
 			imx_hdmi_poweroff(hdmi);
 		}
 		drm_helper_hpd_irq_event(hdmi->connector.dev);
@@ -1606,7 +1604,6 @@ static int imx_hdmi_bind(struct device *
 		return -ENOMEM;
 
 	hdmi->dev = dev;
-	hdmi->connector_status = connector_status_disconnected;
 	hdmi->sample_rate = 48000;
 	hdmi->ratio = 100;
 


