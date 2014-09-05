Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570AbaIEGsw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 02:48:52 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:46980 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbaIEGsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 02:48:50 -0400
From: Robert Richter <rric@kernel.org>
To: Olof Johansson <olof@lixom.net>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Michal Marek <mmarek@suse.cz>
Cc: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Robert Richter <rrichter@cavium.com>
Subject: [PATCH 0/6] dts, kbuild: Implement support for dtb vendor subdirs
Date: Fri,  5 Sep 2014 08:48:06 +0200
Message-Id: <1409899692-1455-1-git-send-email-rric@kernel.org>
X-Mailer: git-send-email 2.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <rrichter@cavium.com>

For arm64 we want to put dts files into vendor's subdirectories from
the beginning. This patch set implements this. As this is a generic
kbuild implementation, vendor subdirs will be also available for
arch/arm and other architectures. The subdirectory tree is also
reflected in the install path.

A new makefile variable dts-dirs is introduced to point to dts
subdirs. This variable is used by kbuild for building and installation
of dtb files.

A dts Makefile looks now as follows:

----
dtb-$(CONFIG_...) += some_file_1.dtb
dtb-$(CONFIG_...) += some_file_2.dtb

dts-dirs          += dir_vendor_a
dts-dirs          += dir_vendor_b

# come always afterwards:
always         := $(dtb-y)
subdir-y       := $(dts-dirs)
clean-files    := *.dtb
----

This patches also introduces the dtbs_install make target for
arm64. Install rules are moved to Makefile.dtbinst using the same
style and calling convention like for modinst and fwinst.

Robert Richter (6):
  dts, arm64: Add dtbs_install make target
  dts, kbuild: Factor out dtbs install rules to Makefile.dtbinst
  dts, arm/arm64: Remove dtbs build rules in sub-makes
  dts, kbuild: Implement support for dtb vendor subdirs
  dts, arm64: Move dts files to vendor subdirs
  dts, arm: Remove $(MACHINE) variable from dtbs make recipes

 arch/arm/Makefile                                |   8 +-
 arch/arm/boot/dts/Makefile                       |  12 +-
 arch/arm64/Makefile                              |  10 +-
 arch/arm64/boot/dts/Makefile                     |  13 +-
 arch/arm64/boot/dts/apm-mustang.dts              |  34 --
 arch/arm64/boot/dts/apm-storm.dtsi               | 425 -----------------------
 arch/arm64/boot/dts/apm/Makefile                 |   5 +
 arch/arm64/boot/dts/apm/apm-mustang.dts          |  34 ++
 arch/arm64/boot/dts/apm/apm-storm.dtsi           | 425 +++++++++++++++++++++++
 arch/arm64/boot/dts/arm/Makefile                 |   6 +
 arch/arm64/boot/dts/arm/foundation-v8.dts        | 232 +++++++++++++
 arch/arm64/boot/dts/arm/rtsm_ve-aemv8a.dts       | 159 +++++++++
 arch/arm64/boot/dts/arm/rtsm_ve-motherboard.dtsi | 240 +++++++++++++
 arch/arm64/boot/dts/foundation-v8.dts            | 232 -------------
 arch/arm64/boot/dts/rtsm_ve-aemv8a.dts           | 159 ---------
 arch/arm64/boot/dts/rtsm_ve-motherboard.dtsi     | 240 -------------
 scripts/Kbuild.include                           |   6 +
 scripts/Makefile.dtbinst                         |  51 +++
 scripts/Makefile.lib                             |  12 -
 19 files changed, 1179 insertions(+), 1124 deletions(-)
 delete mode 100644 arch/arm64/boot/dts/apm-mustang.dts
 delete mode 100644 arch/arm64/boot/dts/apm-storm.dtsi
 create mode 100644 arch/arm64/boot/dts/apm/Makefile
 create mode 100644 arch/arm64/boot/dts/apm/apm-mustang.dts
 create mode 100644 arch/arm64/boot/dts/apm/apm-storm.dtsi
 create mode 100644 arch/arm64/boot/dts/arm/Makefile
 create mode 100644 arch/arm64/boot/dts/arm/foundation-v8.dts
 create mode 100644 arch/arm64/boot/dts/arm/rtsm_ve-aemv8a.dts
 create mode 100644 arch/arm64/boot/dts/arm/rtsm_ve-motherboard.dtsi
 delete mode 100644 arch/arm64/boot/dts/foundation-v8.dts
 delete mode 100644 arch/arm64/boot/dts/rtsm_ve-aemv8a.dts
 delete mode 100644 arch/arm64/boot/dts/rtsm_ve-motherboard.dtsi
 create mode 100644 scripts/Makefile.dtbinst

-- 
2.0.1

