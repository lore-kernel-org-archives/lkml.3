Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207Ab3EVST2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 14:19:28 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:55108 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753310Ab3EVSTZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 14:19:25 -0400
From: Nishanth Menon <nm@ti.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Tony Lindgren <tony@atomide.com>
CC: <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Nishanth Menon <nm@ti.com>
Subject: [RFC PATCH 0/4] regulator/OMAP: support VC/VP support in dts
Date: Wed, 22 May 2013 13:18:33 -0500
Message-ID: <1369246717-4167-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Texas Instrument's OMAP Processor have a dedicated hardware module
which is customised to operate with Power Management IC(PMIC) over an dedicated
I2C. The communication involves a few SoC internal modules as follows:
PMIC - The power management chip on the dedicated I2C (sometimes called I2C_SR)
Voltage controller - consists of an hardware i2c controller and interface
customized for PMICs. VC consists of multiple VC Channels, each channel
representing a variable voltage rail supply to the SoC.
Voltage Processor(VP) - controls the voltage requests to VC channel
SmartReflex(Adaptive Voltage control) - (SR/AVS)- specialized hardware block
which can dynamically control device voltage without software intervention. This
module communicates with VP.

In the simplest view, a simple voltage set operation is as follows:
Vp->VC Channel -> VC -> PMIC

Note, there may be dedicated PMIC per variable voltage rail OR PMICs which
provide control for multiple SMPS supplying variable rails etc.

In addition, there is an Adaptive Voltage Control (AVS) technique called
SmartReflex which can operate (in a configuration called continous monitoring
hardware loop or class 3 mode of operation), in which the SmartReflex block
communicates with Voltage Processor.

We have an OMAP specific implementation in arch/arm/mach-omap2 which does not
tree VC/VP or PMIC as Linux devices, but as data which is configured as needed.

In this series, we introduce replacement approach which has support for only
Device Tree as OMAP is transitioning completely away from non-DT approach.

As an overview, the following approach is taken.

PMIC is now the regulator driver - generic omap-pmic-regulator (patch #1)
Voltage controller and voltage controller channel is handled by
driver/power/avs/omap_vc.c

Voltage processor is handled by driver/power/avs/omap_vp.c

Benefit of using drivers/power/avs is also to set the foundation to convert
SmartReflex AVS into device tree based solution. (next stage).

S/w dependency is as follows:
Voltage controller <- Voltage Processor
Voltage Processor registers with OMAP_PMIC it's controller operations
OMAP_PMIC uses the controller operations to call vp which in turn calls VC to
setup the communication chain.

This allows us to maintain this as a module if needed as well (something our
existing implementation was not capable  of doing).

The series is also available here:
https://github.com/nmenon/linux-2.6-playground/commits/devel/vc-vp-regulator-rfc
git://github.com/nmenon/linux-2.6-playground.git
branch: devel/vc-vp-regulator-rfc

This depends on a few patches for cpufreq/clock node i added in, merged with
3.10-rc2 master and a intermediate GPIO fix from Dan that I picked up available in
branch devel/vc-vp-base

Note: 
1. AVS device tree conversion will have to depend on this due to dependency on VP
2. Clock node strategy used here is based on implementation I had posted here:
	http://marc.info/?t=136804008400001&r=1&w=2
3. I chose OMAP4460 based PandaBoard ES platform as my development platform
   and patch #4 in this series is an attempt to showcase how it will look like.
   Rationale: weird PMIC configuration was used in PandaBoard ES. Ability to
   handle that platform makes introduction to other platforms/SoCs trivial.
   example patch for 4430 sdp: http://pastebin.com/SkAGB273
4. Once this approach is agreed upon, I can do the dts changes for all SoCs
   OMAP3-5 and will post a formal series.

Related defects:
  https://bugzilla.kernel.org/show_bug.cgi?id=58541
  https://bugzilla.kernel.org/show_bug.cgi?id=58611

Nishanth Menon (4):
  regulator: Introduce OMAP regulator to control PMIC over VC/VP
  PM / AVS: Introduce support for OMAP Voltage Controller(VC) with
    device tree nodes
  PM / AVS: Introduce support for OMAP Voltage Processor(VP) with
    device tree nodes
  HACK: OMAP4460/TPS/TWL/PandaBoardES - Enable VP regulator for cpufreq

 .../devicetree/bindings/power/omap-vc.txt          |   99 ++
 .../devicetree/bindings/power/omap-vp.txt          |   39 +
 .../bindings/regulator/omap-pmic-regulator.txt     |  121 ++
 arch/arm/boot/dts/omap4-panda-es.dts               |   55 +-
 arch/arm/boot/dts/omap4.dtsi                       |   84 ++
 arch/arm/boot/dts/omap4460.dtsi                    |    1 +
 arch/arm/boot/dts/tps62361.dtsi                    |   90 ++
 arch/arm/boot/dts/twl6030.dtsi                     |   68 +
 drivers/power/avs/Kconfig                          |   15 +
 drivers/power/avs/Makefile                         |   20 +
 drivers/power/avs/omap_vc.c                        | 1508 ++++++++++++++++++++
 drivers/power/avs/omap_vc.h                        |   67 +
 drivers/power/avs/omap_vp.c                        |  886 ++++++++++++
 drivers/regulator/Kconfig                          |   12 +
 drivers/regulator/Makefile                         |    1 +
 drivers/regulator/omap-pmic-regulator.c            |  554 +++++++
 include/linux/regulator/omap-pmic-regulator.h      |  147 ++
 17 files changed, 3763 insertions(+), 4 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/power/omap-vc.txt
 create mode 100644 Documentation/devicetree/bindings/power/omap-vp.txt
 create mode 100644 Documentation/devicetree/bindings/regulator/omap-pmic-regulator.txt
 create mode 100644 arch/arm/boot/dts/tps62361.dtsi
 create mode 100644 drivers/power/avs/omap_vc.c
 create mode 100644 drivers/power/avs/omap_vc.h
 create mode 100644 drivers/power/avs/omap_vp.c
 create mode 100644 drivers/regulator/omap-pmic-regulator.c
 create mode 100644 include/linux/regulator/omap-pmic-regulator.h

Regards,
Nishanth Menon
-- 
1.7.9.5
