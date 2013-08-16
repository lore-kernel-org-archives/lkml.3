Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368Ab3HPWYP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:24:15 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:38923 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984Ab3HPWYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:24:13 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC 0/4] Early device registration
Date: Fri, 16 Aug 2013 22:39:19 +0200
Message-Id: <1376685563-1053-1-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series is the result of some earlier discussion[0]. Some
drivers need to probe their devices very early in the boot process (such
as IRQ chip drivers). However there is no struct device available at
that time because they are added a lot later.

The most notable case where this happens is for systems that are booted
using a device tree. A lot of those early drivers work around the issue
by "binding" themselves to the struct device_node. One disadvantage of
that is that they cannot use APIs that require a struct device (such as
regmap). Another downside is that it introduces inconsistencies in how
drivers are written.

In order to remedy that situation, this patch series introduces a way to
register devices earlier. This is more difficult than it sounds. One of
the problems is that kmalloc() is required during device registration.
Another prerequisite is sysfs since every device is represented in the
sysfs tree. To allow a device to be created before sysfs is available,
only the very minimal set of operations are performed at the early stage
and the device is added to a list of early devices that will be fully
registered once all the necessary infrastructure is available. This is
somewhat inspired by and therefore similar to deferred driver probing.

By no means is this patch series complete. I was able to boot a Tegra
device to a boot prompt without any serious regressions. One thing I did
notice is that somehow this series causes udev not to rename ethernet
devices (f.e. eth0 to enp1s0) which it does without that patch set.

One thing that this set of patches doesn't address yet is a way to probe
devices early, which might be required for some use-cases. However I'm
looking for some feedback before going further down this road.

Thierry

[0]: https://lists.ozlabs.org/pipermail/devicetree-discuss/2013-June/036542.html

Thierry Reding (4):
  driver core: Register SoC bus after platform bus
  driver core: Allow early registration of devices
  ARM: tegra: Call of_platform_populate() early
  OF: Add device pointer to struct device_node

 arch/arm/mach-tegra/common.c |  33 +++++++++++++
 arch/arm/mach-tegra/tegra.c  |  32 -------------
 drivers/base/base.h          |   8 ++++
 drivers/base/core.c          | 107 +++++++++++++++++++++++++++++++++++++++++++
 drivers/base/init.c          |   3 ++
 drivers/base/soc.c           |  11 +----
 drivers/of/device.c          |   2 +
 drivers/of/platform.c        |  10 +---
 include/linux/of.h           |   2 +
 9 files changed, 157 insertions(+), 51 deletions(-)

-- 
1.8.3.4

