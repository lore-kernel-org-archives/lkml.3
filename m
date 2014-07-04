Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759880AbaGDBP0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 21:15:26 -0400
Received: from script.cs.helsinki.fi ([128.214.11.1]:44263 "EHLO
	script.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756144AbaGDBPW (ORCPT
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
Subject: [PATCH v2 0/4] Tegra USB probe order issue fix
Date: Fri,  4 Jul 2014 04:09:35 +0300
Message-Id: <1404436179-10745-1-git-send-email-ttynkkynen@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here's a second version of the probe order issue series. This time I've
added the USB1 resets to the PHYs, thus replacing the really ugly parts
with something slightly better. Old device trees will still probe
successfully, but instead of this bugfix they'll get a dev_warn().

The reset control patch was dropped, as a similar patch from someone
else has landed in linux-next.

For a recap of the issue from the previous series:

Basically, the register area of the 1st USB controller contains some
registers that are global to all of the controllers, but that are also
cleared when reset is asserted to the 1st controller. So if (say) the
3rd controller would be the first one to finish probing successfully,
then the reset that happens during the 1st controller's probe would
result in broken USB. So the before doing anything with the USB HW,
we should reset the 1st controller once, and then never ever reset
it again.

While testing that the 1st USB controller still works without a reset
when the driver is unbound and bound again, I discovered an unbalanced
regulator_disable + clk_disable_unprepare in the PHY code if the EHCI
driver is unbound and rebound. This is fixed in patch 4.

Thanks,
Tuomas.

Tuomas Tynkkynen (4):
  USB: tegra: Add resets & has-utmi-pad-registers flag to the PHY
    binding
  ARM: tegra: Add resets & has-utmi-pad-registers flag to all USB PHYs
  USB: EHCI: tegra: Fix probe order issue leading to broken USB
  USB: PHY: tegra: Call tegra_usb_phy_close only on device removal

 .../bindings/usb/nvidia,tegra20-usb-phy.txt        |    8 +++
 arch/arm/boot/dts/tegra114.dtsi                    |    5 ++
 arch/arm/boot/dts/tegra124.dtsi                    |    7 +++
 arch/arm/boot/dts/tegra20.dtsi                     |    7 +++
 arch/arm/boot/dts/tegra30.dtsi                     |    7 +++
 drivers/usb/host/ehci-tegra.c                      |   62 +++++++++++++++++++-
 drivers/usb/phy/phy-tegra-usb.c                    |    8 +--
 7 files changed, 96 insertions(+), 8 deletions(-)

-- 
1.7.9.5

