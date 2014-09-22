Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966AbaIVKsZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 06:48:25 -0400
Received: from regular1.263xmail.com ([211.150.99.134]:45099 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572AbaIVKsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 06:48:21 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: mark.yao@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: mark.yao@rock-chips.com
X-UNIQUE-TAG: <585655ffad79bec79d25d2b028f1b4fe>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
From: Mark yao <mark.yao@rock-chips.com>
To: heiko@sntech.de, Boris BREZILLON <boris.brezillon@free-electrons.com>,
        David Airlie <airlied@gmail.com>, Rob Clark <robdclark@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Rom Lemarchand <romlem@google.com>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-api@vger.kernel.org, linux-rockchip@lists.infradead.org,
        dianders@chromium.org, marcheu@chromium.org, dbehr@chromium.org,
        olof@lixom.net, djkurtz@chromium.org, xjq@rock-chips.com,
        kfx@rock-chips.com, cym@rock-chips.com, cf@rock-chips.com,
        zyw@rock-chips.com, xxm@rock-chips.com, huangtao@rock-chips.com,
        kever.yang@rock-chips.com, yxj@rock-chips.com, wxt@rock-chips.com,
        xw@rock-chips.com, Mark yao <mark.yao@rock-chips.com>
Subject: [PATCH v4 0/5] Add drm driver for Rockchip Socs
Date: Mon, 22 Sep 2014 18:47:00 +0800
Message-Id: <1411382820-1615-1-git-send-email-mark.yao@rock-chips.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This a series of patches is a DRM Driver for Rockchip Socs, add support
for vop devices, eDP. Future patches will add additional encoders/connectors,
such as HDMI.

The basic "crtc" for rockchip is a "VOP" - Video Output Processor.
the vop devices found on Rockchip rk3288 Soc, rk3288 soc have two similar
Vop devices. Vop devices support iommu mapping, we use dma-mapping API with
ARM_DMA_USE_IOMMU.

Changes in v2:
- add DRM master device node to list all display nodes that comprise
  the graphics subsystem.
- use the component framework to defer main drm driver probe
  until all VOP devices have been probed.
- use dma-mapping API with ARM_DMA_USE_IOMMU, create dma mapping by
  master device and each vop device can shared the drm dma mapping.
- use drm_crtc_init_with_planes and drm_universal_plane_init.
- remove unnecessary middle layers.
- add cursor set, move funcs to rockchip drm crtc.
- use panel-simple driver for primary display.
- add vop and edp reset.

Changes in v3:
- change "crtc->fb" to "crtc->primary-fb"
Adviced by Daniel Vetter
- init cursor plane with universal api, remove unnecessary cursor set,move 

Changes in v4:
Adviced by David Herrmann
- remove drm_platform_*() usage, use register drm device directly.
Adviced by Rob Clark
- remove special mmap ioctl, do userspace mmap with normal mmap() or mmap offset

Tested on rk3288 pinky board, use eDP encoders/connector, boot and display OK

Mark yao (5):
  drm/rockchip: Add basic drm driver
  dt-bindings: video: Add for rockchip display subsytem
  dt-bindings: video: Add documentation for rockchip vop
  dt-bindings: video: Add documentation for rockchip edp
  drm/rockchip: Add support for Rockchip Soc EDP

 .../devicetree/bindings/video/rockchip-drm.txt     |   19 +
 .../devicetree/bindings/video/rockchip-edp.txt     |   50 +
 .../devicetree/bindings/video/rockchip-vop.txt     |   58 +
 drivers/gpu/drm/Kconfig                            |    2 +
 drivers/gpu/drm/Makefile                           |    1 +
 drivers/gpu/drm/rockchip/Kconfig                   |   28 +
 drivers/gpu/drm/rockchip/Makefile                  |   12 +
 drivers/gpu/drm/rockchip/rockchip_drm_drv.c        |  524 ++++++++
 drivers/gpu/drm/rockchip/rockchip_drm_drv.h        |  120 ++
 drivers/gpu/drm/rockchip/rockchip_drm_fb.c         |  201 +++
 drivers/gpu/drm/rockchip/rockchip_drm_fb.h         |   28 +
 drivers/gpu/drm/rockchip/rockchip_drm_fbdev.c      |  231 ++++
 drivers/gpu/drm/rockchip/rockchip_drm_fbdev.h      |   20 +
 drivers/gpu/drm/rockchip/rockchip_drm_gem.c        |  404 ++++++
 drivers/gpu/drm/rockchip/rockchip_drm_gem.h        |   72 +
 drivers/gpu/drm/rockchip/rockchip_drm_vop.c        | 1372 ++++++++++++++++++++
 drivers/gpu/drm/rockchip/rockchip_drm_vop.h        |  187 +++
 drivers/gpu/drm/rockchip/rockchip_edp_core.c       |  853 ++++++++++++
 drivers/gpu/drm/rockchip/rockchip_edp_core.h       |  309 +++++
 drivers/gpu/drm/rockchip/rockchip_edp_reg.c        | 1202 +++++++++++++++++
 drivers/gpu/drm/rockchip/rockchip_edp_reg.h        |  345 +++++
 include/uapi/drm/rockchip_drm.h                    |   75 ++
 22 files changed, 6113 insertions(+)

-- 
1.7.9.5


