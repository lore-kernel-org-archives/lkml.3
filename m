Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946174Ab3FUV07 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 17:26:59 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:34400 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946097Ab3FUV0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 17:26:40 -0400
From: Nishanth Menon <nm@ti.com>
To: =?UTF-8?q?Beno=C3=AEt=20Cousson?= <b-cousson@ti.com>,
        Mark Brown <broonie@kernel.org>, Tony Lindgren <tony@atomide.com>
CC: Kevin Hilman <khilman@deeprootsystems.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, Nishanth Menon <nm@ti.com>
Subject: [RFC PATCH V2 0/8] regulator/OMAP: support VC/VP support in dts
Date: Fri, 21 Jun 2013 16:25:41 -0500
Message-ID: <1371849949-12649-1-git-send-email-nm@ti.com>
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
branch: devel/vc-vp-regulator-setv-v1-rfc-2

This depends on a few patches for cpufreq/clock node I added in, merged with
3.10-rc6 master + the following for-next branches
benoit/for_3.11/dts
mturquette/clk-next
broonie/for-next
rafael/linux-next
Available as branch: devel/vc-vp-base

Note: 
1. AVS device tree conversion will have to depend on this due to dependency on VP
2. Clock node strategy used here is based on implementation I had posted here:
	http://marc.info/?t=136804008400001&r=1&w=2
3. I chose OMAP4460 based PandaBoard ES platform as my development platform
   and patch #4 in this series is an attempt to showcase how it will look like.
   Rationale: weird PMIC configuration was used in PandaBoard ES. Ability to
   handle that platform makes introduction to other platforms/SoCs trivial.
4. Once this approach is agreed upon, I can do the dts changes for all SoCs
   OMAP3-5 and will post a formal series.

Related defects:
  https://bugzilla.kernel.org/show_bug.cgi?id=58541
  https://bugzilla.kernel.org/show_bug.cgi?id=58611

Related discussion:
v1 of RFC: http://marc.info/?t=136924689600005&r=1&w=2
    related discussion: http://marc.info/?t=137166954900005&r=1&w=2

Nishanth Menon (8):
  regulator: Introduce OMAP regulator to control PMIC over VC/VP
  PM / AVS: Introduce support for OMAP Voltage Controller(VC) with
    device tree nodes
  PM / AVS: Introduce support for OMAP Voltage Processor(VP) with
    device tree nodes
  ARM: dts: OMAP4: add voltage controller nodes
  ARM: dts: OMAP4: add voltage processor nodes
  ARM: dts: TWL6030/OMAP4: Add OMAP voltage path linkage
  ARM: dts: omap4-panda-es: add TPS62361 supply for vdd_mpu
  ARM: dts: OMAP4-panda-es: use tps regulator as cpu0 supply

 .../devicetree/bindings/power/omap-vc.txt          |   99 ++
 .../devicetree/bindings/power/omap-vp.txt          |   39 +
 .../bindings/regulator/omap-pmic-regulator.txt     |   41 +
 arch/arm/boot/dts/omap4-panda-common.dtsi          |    1 +
 arch/arm/boot/dts/omap4-panda-es.dts               |   35 +
 arch/arm/boot/dts/omap4-sdp.dts                    |    1 +
 arch/arm/boot/dts/omap4-var-som.dts                |    1 +
 arch/arm/boot/dts/omap4.dtsi                       |   73 +-
 arch/arm/boot/dts/omap443x.dtsi                    |   32 +-
 arch/arm/boot/dts/omap4460.dtsi                    |   33 +-
 arch/arm/boot/dts/tps62361_omap.dtsi               |   18 +
 arch/arm/boot/dts/twl6030_omap4.dtsi               |   35 +
 drivers/power/avs/Kconfig                          |   15 +
 drivers/power/avs/Makefile                         |   20 +
 drivers/power/avs/omap_vc.c                        | 1513 ++++++++++++++++++++
 drivers/power/avs/omap_vc.h                        |   67 +
 drivers/power/avs/omap_vp.c                        |  892 ++++++++++++
 drivers/regulator/Kconfig                          |   12 +
 drivers/regulator/Makefile                         |    1 +
 drivers/regulator/omap-pmic-regulator.c            |  638 +++++++++
 include/linux/regulator/omap-pmic-regulator.h      |  162 +++
 21 files changed, 3724 insertions(+), 4 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/power/omap-vc.txt
 create mode 100644 Documentation/devicetree/bindings/power/omap-vp.txt
 create mode 100644 Documentation/devicetree/bindings/regulator/omap-pmic-regulator.txt
 create mode 100644 arch/arm/boot/dts/tps62361_omap.dtsi
 create mode 100644 arch/arm/boot/dts/twl6030_omap4.dtsi
 create mode 100644 drivers/power/avs/omap_vc.c
 create mode 100644 drivers/power/avs/omap_vc.h
 create mode 100644 drivers/power/avs/omap_vp.c
 create mode 100644 drivers/regulator/omap-pmic-regulator.c
 create mode 100644 include/linux/regulator/omap-pmic-regulator.h

-- 
1.7.9.5

