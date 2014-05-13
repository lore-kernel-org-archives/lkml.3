Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550AbaEMPdF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 11:33:05 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:47377 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346AbaEMPcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 11:32:51 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        dri-devel@lists.freedesktop.org
Cc: Daniel Vetter <daniel@ffwll.ch>, Rob Clark <robdclark@gmail.com>,
        David Herrmann <dh.herrmann@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/7] drm/tegra: Convert to master/component framework
Date: Tue, 13 May 2014 17:30:43 +0200
Message-Id: <1399995050-28435-1-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 1.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

Hi,

This series converts the Tegra DRM driver to the master/component
framework. The length of the series and the list of people in Cc is
mostly due to the fact that Tegra has some special requirements as
opposed to other drivers and therefore requires some changes outside
of DRM.

Patch 1 introduces a helper function that can be used by new DRM drivers
that don't rely on legacy userspace ABIs. It allows them to register DRM
devices much more easily and without much of the midlayer that currently
exists in the DRM subsystem.

Patches 2 and 3 make some changes to the master/component framework
which are necessary to convert Tegra DRM to use it. All current users of
the API have been converted as part of this patch. Note that at the same
time the drivers are converted to no longer use drm_platform_init() in
favour of the drm_set_unique() from patch 1 in conjunction with
drm_dev_alloc() and drm_dev_register(). I would've liked to avoid such
invasive changes in a single patch, but unfortunately I couldn't think
of a way how to do that. I'm open to suggestions.

Patch 4 adds a new interface framework that supplements the master/
component framework and can be used in situations where there is no
struct device * that a driver can bind to.

The Tegra DRM driver is converted to using the master/component
framework in patch 5 using the above four patches.

Finally patches 6 and 7 add some documentation about the new way of
registering DRM devices that don't need legacy support.

Each patch has a somewhat more elaborate description of why it is needed
or what problem it solves. The patchset applies on top of linux-next.

I welcome any questions or comments you might have.

Thierry

Thierry Reding (7):
  drm: Introduce drm_set_unique()
  drivers/base: Allow driver-data to be attached to a master
  drivers/base: Allow multiple masters per device
  drivers/base: Add interface framework
  drm/tegra: Convert to master/component framework
  drm: Add device registration documentation
  drm: Document how to register devices without struct drm_bus

 Documentation/DocBook/drm.tmpl             |  38 ++
 drivers/base/Makefile                      |   2 +-
 drivers/base/component.c                   |  31 +-
 drivers/base/interface.c                   | 186 ++++++++++
 drivers/gpu/drm/drm_ioctl.c                |  23 +-
 drivers/gpu/drm/drm_pci.c                  |  80 ++---
 drivers/gpu/drm/drm_platform.c             |  15 +-
 drivers/gpu/drm/drm_stub.c                 |  43 ++-
 drivers/gpu/drm/drm_usb.c                  |  20 +-
 drivers/gpu/drm/msm/adreno/a3xx_gpu.c      |   8 +-
 drivers/gpu/drm/msm/hdmi/hdmi.c            |   8 +-
 drivers/gpu/drm/msm/msm_drv.c              |  75 ++--
 drivers/gpu/drm/msm/msm_drv.h              |   1 +
 drivers/gpu/drm/tegra/Makefile             |   1 -
 drivers/gpu/drm/tegra/bus.c                |  64 ----
 drivers/gpu/drm/tegra/dc.c                 |  58 ++-
 drivers/gpu/drm/tegra/drm.c                | 171 ++++++---
 drivers/gpu/drm/tegra/drm.h                |  27 +-
 drivers/gpu/drm/tegra/dsi.c                | 144 ++++----
 drivers/gpu/drm/tegra/gr2d.c               |  78 ++--
 drivers/gpu/drm/tegra/gr3d.c               |  77 ++--
 drivers/gpu/drm/tegra/hdmi.c               |  69 ++--
 drivers/gpu/drm/tegra/sor.c                |  71 ++--
 drivers/gpu/host1x/Makefile                |   1 -
 drivers/gpu/host1x/bus.c                   | 553 -----------------------------
 drivers/gpu/host1x/bus.h                   |  29 --
 drivers/gpu/host1x/dev.c                   |  21 +-
 drivers/gpu/host1x/dev.h                   |   7 +-
 drivers/staging/imx-drm/imx-drm-core.c     |  58 +--
 drivers/staging/imx-drm/imx-hdmi.c         |   4 +-
 drivers/staging/imx-drm/imx-ldb.c          |   4 +-
 drivers/staging/imx-drm/imx-tve.c          |   4 +-
 drivers/staging/imx-drm/ipuv3-crtc.c       |   4 +-
 drivers/staging/imx-drm/parallel-display.c |   4 +-
 include/drm/drmP.h                         |   3 +
 include/linux/component.h                  |  20 +-
 include/linux/host1x.h                     |  64 +---
 include/linux/interface.h                  |  40 +++
 38 files changed, 849 insertions(+), 1257 deletions(-)
 create mode 100644 drivers/base/interface.c
 delete mode 100644 drivers/gpu/drm/tegra/bus.c
 delete mode 100644 drivers/gpu/host1x/bus.c
 delete mode 100644 drivers/gpu/host1x/bus.h
 create mode 100644 include/linux/interface.h

-- 
1.9.2

