Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476AbaFZFeG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 01:34:06 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:3785 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765AbaFZFeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 01:34:05 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 25 Jun 2014 22:27:53 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Ben Skeggs <bskeggs@redhat.com>, Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>
CC: <nouveau@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gnurou@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH v3 0/3] drm/nouveau: support for probing platform devices
Date: Thu, 26 Jun 2014 14:33:31 +0900
Message-ID: <1403760814-26148-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 2.0.0
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds support for probing platform devices on Nouveau, as well as
the DT bindings for GK20A. It doesn't enable the GPU yet on Tegra boards since
a few extra things need to be supported before that.

This version is mostly identical to v2 but fixes an important issue: the drvdata
must be set to the drm_device for sysfs to work, so the platform device
structure now includes the nouveau_device flattened into it to let us compute
the address of one from the other. Since the platform device resources (clocks,
regulators, ...) need to live longer than the nouveau_device, they are stored
into their own structure which is allocated separately.

Changes since v2:
* Allocate the nouveau_device flattened into the nouveau_platform_device to
  be able to compute one from another easily, without having to ressort on the
  drvdata which is required to store the drm_device.
* Only propose the platform driver if a supported arch (Tegra for now) is
  enabled.
* Move structure definitions into their own header file as some subdevs (e.g.
  clocks) will need to use them.

Changes since v1:
* Moved the platform device driver to its own module. This allows it to be more
  self-contained and saves us the need to export too many functions from
  nouveau_drm and nouveau_platform.
* Register the DRM device without using the platform helpers, which is made
  possible by drm_dev_set_unique(). This allows us to catch and register the
  DRM device during platform probe.
* Fixed the clock names in the DT bindings.
* Removed the patches enabling GK20A on Venice2 and Jetson TK1 as support
  is not complete yet.

Alexandre Courbot (2):
  drm/nouveau: support for probing platform devices
  ARM: tegra: of: add GK20A device tree binding

Thierry Reding (1):
  ARM: tegra: add GK20A GPU to Tegra124 DT

 .../devicetree/bindings/gpu/nvidia,gk20a.txt       |  43 +++++
 arch/arm/boot/dts/tegra124.dtsi                    |  15 ++
 drivers/gpu/drm/nouveau/Kconfig                    |   8 +
 drivers/gpu/drm/nouveau/Makefile                   |   3 +
 drivers/gpu/drm/nouveau/nouveau_drm.c              |  53 ++++--
 drivers/gpu/drm/nouveau/nouveau_drm.h              |   8 +
 drivers/gpu/drm/nouveau/nouveau_platform.c         | 182 +++++++++++++++++++++
 drivers/gpu/drm/nouveau/nouveau_platform.h         |  49 ++++++
 8 files changed, 347 insertions(+), 14 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/gpu/nvidia,gk20a.txt
 create mode 100644 drivers/gpu/drm/nouveau/nouveau_platform.c
 create mode 100644 drivers/gpu/drm/nouveau/nouveau_platform.h

-- 
2.0.0

