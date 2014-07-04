Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759974AbaGDBP3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 21:15:29 -0400
Received: from script.cs.helsinki.fi ([128.214.11.1]:52948 "EHLO
	script.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756227AbaGDBPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 21:15:22 -0400
X-DKIM: Courier DKIM Filter v0.50+pk-2014-03-23 mail.cs.helsinki.fi Fri, 04 Jul 2014 04:09:52 +0300
From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org,
        Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Subject: [PATCH v2 1/4] USB: tegra: Add resets & has-utmi-pad-registers flag to the PHY binding
Date: Fri,  4 Jul 2014 04:09:36 +0300
Message-Id: <1404436179-10745-2-git-send-email-ttynkkynen@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404436179-10745-1-git-send-email-ttynkkynen@nvidia.com>
References: <1404436179-10745-1-git-send-email-ttynkkynen@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When Tegra was converted to use the standard reset bindings, the PHY was
forgotten, probably because all the resetting of the USB blocks were
done in the EHCI driver. What also went unnoticed is that resetting the
1st on-chip USB module also wipes some of the UTMI pad configuration
registers that are also used by the other USB blocks. So this fact needs
to be described in the device tree, and the driver modified not to reset
the 1st module at inappropriate times.

In order to stay compatible with old device trees, the USB drivers will
still function without these properties but with the old,
potentially buggy behaviour.

Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
---
v2 changes: new patch, didn't exist in v1
 .../bindings/usb/nvidia,tegra20-usb-phy.txt        |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Documentation/devicetree/bindings/usb/nvidia,tegra20-usb-phy.txt b/Documentation/devicetree/bindings/usb/nvidia,tegra20-usb-phy.txt
index ba797d3..c9205fb 100644
--- a/Documentation/devicetree/bindings/usb/nvidia,tegra20-usb-phy.txt
+++ b/Documentation/devicetree/bindings/usb/nvidia,tegra20-usb-phy.txt
@@ -20,6 +20,12 @@ Required properties :
      Present if phy_type == utmi.
    - ulpi-link: The clock Tegra provides to the ULPI PHY (cdev2).
      Present if phy_type == ulpi, and ULPI link mode is in use.
+ - resets : Must contain an entry for each entry in reset-names.
+   See ../reset/reset.txt for details.
+ - reset-names : Must include the following entries:
+   - usb: The PHY's own reset signal.
+   - utmi-pads: The reset of the PHY containing the chip-wide UTMI pad control
+     registers. Required even if phy_type == ulpi.
 
 Required properties for phy_type == ulpi:
   - nvidia,phy-reset-gpio : The GPIO used to reset the PHY.
@@ -56,6 +62,8 @@ Optional properties:
       host means this is a host controller
       peripheral means it is device controller
       otg means it can operate as either ("on the go")
+  - nvidia,has-utmi-pad-registers : boolean indicates whether this controller
+    contains the UTMI pad control registers common to all USB controllers.
 
 VBUS control (required for dr_mode == otg, optional for dr_mode == host):
   - vbus-supply: regulator for VBUS
-- 
1.7.9.5

