Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517Ab3EPOWG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 10:22:06 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:2022 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754466Ab3EPOWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 10:22:02 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 16 May 2013 07:22:01 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: <gregkh@linuxfoundation.org>, <stern@rowland.harvard.edu>, <balbi@ti.com>,
        <swarren@wwwdotorg.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>,
        Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: [PATCH v4 1/8] ARM: tegra: finalize USB EHCI and PHY bindings
Date: Thu, 16 May 2013 19:42:55 +0530
Message-ID: <1368713582-29038-2-git-send-email-vbyravarasu@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1368713582-29038-1-git-send-email-vbyravarasu@nvidia.com>
References: <1368713582-29038-1-git-send-email-vbyravarasu@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The existing Tegra USB bindings have a few issues:

1) Many properties are documented as being part of the EHCI controller
node, yet they apply more to the PHY device. They should be moved.

2) Some registers in PHY1 are shared with PHY3, and hence PHY3 needs a
reg entry to point at PHY1's register space. We can't assume the PHY1
driver is present, so the PHY3 driver will directly access those
registers.

3) The list of clocks required by the PHY was missing some required
entries.

4) UTMI PHY Timing parameters are added

5) VBUS control is now specified using a regulator rather than a plain GPIO

6) Added nvidia,is-wired property to indicate whether the device is
hard wired on the board, or pluggable.

This patch fixes the binding definition to resolve these issues.

Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
---
delta from v3:
Added a blank line at EOF of nvidia,tegra20-usb-phy.txt.

delta from v2:
Moved vbus-supply under "Required properties for dr_mode == otg" heading.

delta from v1:
1. added UTMI PHY timing params.
2. replaced gadget with peripheral in dr_mode
3. added nvidia,is-wired & vbus-supply params.

 
.../bindings/usb/nvidia,tegra20-ehci.txt           |   27 ++----------
 .../bindings/usb/nvidia,tegra20-usb-phy.txt        |   41 ++++++++++++++++++-
 2 files changed, 43 insertions(+), 25 deletions(-)

diff --git a/Documentation/devicetree/bindings/usb/nvidia,tegra20-ehci.txt b/Documentation/devicetree/bindings/usb/nvidia,tegra20-ehci.txt
index 34c9528..df09330 100644
--- a/Documentation/devicetree/bindings/usb/nvidia,tegra20-ehci.txt
+++ b/Documentation/devicetree/bindings/usb/nvidia,tegra20-ehci.txt
@@ -6,27 +6,10 @@ Practice : Universal Serial Bus" with the following modifications
 and additions :
 
 Required properties :
- - compatible : Should be "nvidia,tegra20-ehci" for USB controllers
-   used in host mode.
- - phy_type : Should be one of "ulpi" or "utmi".
- - nvidia,vbus-gpio : If present, specifies a gpio that needs to be
-   activated for the bus to be powered.
- - nvidia,phy : phandle of the PHY instance, the controller is connected to.
-
-Required properties for phy_type == ulpi:
-  - nvidia,phy-reset-gpio : The GPIO used to reset the PHY.
+ - compatible : Should be "nvidia,tegra20-ehci".
+ - nvidia,phy : phandle of the PHY that the controller is connected to.
+ - clocks : Contains a single entry which defines the USB controller's clock.
 
 Optional properties:
-  - dr_mode : dual role mode. Indicates the working mode for
-   nvidia,tegra20-ehci compatible controllers.  Can be "host", "peripheral",
-   or "otg".  Default to "host" if not defined for backward compatibility.
-      host means this is a host controller
-      peripheral means it is device controller
-      otg means it can operate as either ("on the go")
-  - nvidia,has-legacy-mode : boolean indicates whether this controller can
-    operate in legacy mode (as APX 2500 / 2600). In legacy mode some
-    registers are accessed through the APB_MISC base address instead of
-    the USB controller. Since this is a legacy issue it probably does not
-    warrant a compatible string of its own.
-  - nvidia,needs-double-reset : boolean is to be set for some of the Tegra2
-    USB ports, which need reset twice due to hardware issues.
+ - nvidia,needs-double-reset : boolean is to be set for some of the Tegra20
+   USB ports, which need reset twice due to hardware issues.
diff --git a/Documentation/devicetree/bindings/usb/nvidia,tegra20-usb-phy.txt b/Documentation/devicetree/bindings/usb/nvidia,tegra20-usb-phy.txt
index 6bdaba2..c4c9e9e 100644
--- a/Documentation/devicetree/bindings/usb/nvidia,tegra20-usb-phy.txt
+++ b/Documentation/devicetree/bindings/usb/nvidia,tegra20-usb-phy.txt
@@ -4,14 +4,49 @@ The device node for Tegra SOC USB PHY:
 
 Required properties :
  - compatible : Should be "nvidia,tegra20-usb-phy".
- - reg : Address and length of the register set for the USB PHY interface.
- - phy_type : Should be one of "ulpi" or "utmi".
+ - reg : Defines the following set of registers, in the order listed:
+   - The PHY's own register set.
+     Always present.
+   - The register set of the PHY containing the UTMI pad control registers.
+     Present if-and-only-if phy_type == utmi.
+ - phy_type : Should be one of "utmi", "ulpi" or "hsic".
+ - clocks : Defines the clocks listed in the clock-names property.
+ - clock-names : The following clock names must be present:
+   - reg: The clock needed to access the PHY's own registers. This is the
+     associated EHCI controller's clock. Always present.
+   - pll_u: PLL_U. Always present.
+   - timer: The timeout clock (clk_m). Present if phy_type == utmi.
+   - utmi-pads: The clock needed to access the UTMI pad control registers.
+     Present if phy_type == utmi.
+   - ulpi-link: The clock Tegra provides to the ULPI PHY (cdev2).
+     Present if phy_type == ulpi, and ULPI link mode is in use.
 
 Required properties for phy_type == ulpi:
   - nvidia,phy-reset-gpio : The GPIO used to reset the PHY.
 
+Required PHY timing params for utmi phy:
+  - nvidia,hssync-start-delay : Number of 480 Mhz clock cycles to wait before
+    start of sync launches RxActive
+  - nvidia,elastic-limit : Variable FIFO Depth of elastic input store
+  - nvidia,idle-wait-delay : Number of 480 Mhz clock cycles of idle to wait
+    before declare IDLE.
+  - nvidia,term-range-adj : Range adjusment on terminations
+  - nvidia,xcvr-setup : HS driver output control
+  - nvidia,xcvr-lsfslew : LS falling slew rate control.
+  - nvidia,xcvr-lsrslew :  LS rising slew rate control.
+
 Optional properties:
   - nvidia,has-legacy-mode : boolean indicates whether this controller can
     operate in legacy mode (as APX 2500 / 2600). In legacy mode some
     registers are accessed through the APB_MISC base address instead of
-    the USB controller.
\ No newline at end of file
+    the USB controller.
+  - nvidia,is-wired : boolean. Indicates whether we can do certain kind of power
+    optimizations for the devices that are always connected. e.g. modem.
+  - dr_mode : dual role mode. Indicates the working mode for the PHY. Can be
+    "host", "peripheral", or "otg". Defaults to "host" if not defined.
+      host means this is a host controller
+      peripheral means it is device controller
+      otg means it can operate as either ("on the go")
+
+Required properties for dr_mode == otg:
+  - vbus-supply: regulator for VBUS
-- 
1.7.0.4

