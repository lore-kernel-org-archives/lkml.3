Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758076AbaFSLwj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 07:52:39 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:7951 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757949AbaFSLwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 07:52:37 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 19 Jun 2014 04:43:11 -0700
From: Mikko Perttunen <mperttunen@nvidia.com>
To: <swarren@wwwdotorg.org>, <thierry.reding@gmail.com>,
        <pdeschrijver@nvidia.com>, <rui.zhang@intel.com>,
        <edubezval@gmail.com>
CC: <devicetree@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <mikko.perttunen@kapsi.fi>,
        <mlongnecker@nvidia.com>, <dtundlam@nvidia.com>, <talho@nvidia.com>,
        Mikko Perttunen <mperttunen@nvidia.com>
Subject: [RFC 0/5] Tegra124 thermal management
Date: Thu, 19 Jun 2014 14:50:35 +0300
Message-ID: <1403178640-16052-1-git-send-email-mperttunen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, this patchset implements basic polled thermal sensing support and
hardware initiated shutdown ("thermtrip") in an overheating situations 
for the Tegra124 system-on-chip.

The driver uses the of-thermal framework to expose the sensors to the
thermal subsystem, and this works well for the simplest case of polled
sensors. However, there are two features I'd like to implement that
as far as I know the framework isn't really ready for:
- hardware based trip points, i.e., interrupts at a configured temperature
- hardware initiated cooling

Thermtrip is an example of the latter, but the hardware is also capable
of less drastic measures. Currently, the driver doesn't attempt to expose
thermtrip using the framework, instead opting to use custom device tree
properties, but this is something I'd like to move away from.

To implement hardware based trip points, the sensor - of-thermal interface
would need a new function, which the of-thermal framework would use to
tell the driver of a new trip point. I suppose the best way to do this
would be to have of-thermal manage trip points, and when one is reached,
tell the driver to prepare for the next one. The sensor driver should
be capable of managing two trip points, and below and one above the
current temperature.

Hardware initiated cooling is a bit more interesting. The hardware that
initiates the cooling procedure necessarily has some view of the thermal
sensors / thermal zones, so the thermal zones defined in the device tree
should map exactly to those ones. Hardware based cooling devices should
be defined in the device tree just like any other cooling devices.
The problematic part is binding a trip point to a hardware cooling device.
There would need some additional interface to tell the cooling device
the temperature of the trip point it is bound to.

Hardware cooling devices can also track multiple thermal zones (for example,
thermtrip can trigger based on cpu, gpu, memory and tsense sensors). To
distinguish between these in the device tree, I can think of two options:
1. Implement each tracked zone as a separate cooling device. (Probably by 
   having an additional cooling-cell) This would make the interface simpler 
   but allow impossible cooling mappings to be made in the device tree.
2. When telling the cooling device of a particular trip point, also tell it
   which thermal zone it is related to. This would require the cooling device
   to have some kind of ability to detect that a thermal zone object is a
   specific thermal zone.

One more question related to hardware-initiated reset in an overheating
situation: the "critical" trip level is designed to initiate a controller
shutdown. Should there be a new trip level for an uncontrolled shutdown?

Any thoughts would be appreciated.

Thanks,
Mikko Perttunen

Mikko Perttunen (5):
  ARM: tegra: Add PMC thermtrip programming to Jetson TK1 device tree
  ARM: tegra: Add soctherm and thermal zones to Tegra124 device tree
  ARM: tegra: Add thermal reset (thermtrip) support to PMC
  clk: tegra: Add soctherm and tsensor clocks to T124 initialization
    table
  thermal: Add Tegra SOCTHERM thermal management driver

 arch/arm/boot/dts/tegra124-jetson-tk1.dts |   5 +
 arch/arm/boot/dts/tegra124.dtsi           |  47 +++
 arch/arm/mach-tegra/pmc.c                 |  95 +++++-
 drivers/clk/tegra/clk-tegra124.c          |   2 +
 drivers/thermal/Kconfig                   |   6 +
 drivers/thermal/Makefile                  |   1 +
 drivers/thermal/tegra_soctherm.c          | 502 ++++++++++++++++++++++++++++++
 7 files changed, 654 insertions(+), 4 deletions(-)
 create mode 100644 drivers/thermal/tegra_soctherm.c

-- 
1.8.1.5

