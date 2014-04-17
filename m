Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620AbaDQL3i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 07:29:38 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:30259 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986AbaDQL3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 07:29:35 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-8f-534fbb1cc0da
From: Andrzej Hajda <a.hajda@samsung.com>
To: dri-devel@lists.freedesktop.org
Cc: Andrzej Hajda <a.hajda@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Inki Dae <inki.dae@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org (moderated list:ARM/S5P EXYNOS AR...),
        Tomasz Figa <t.figa@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Airlie <airlied@linux.ie>,
        linux-kernel@vger.kernel.org (open list),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/S5P EXYNOS
	AR...),
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH RFC 0/3] drm/exynos: refactoring drm initialization/cleanup code
Date: Thu, 17 Apr 2014 13:28:47 +0200
Message-id: <1397734130-21019-1-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.8.3.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkluLIzCtJLcpLzFFi42I5/e/4VV2Z3f7BBovXqFjcWneO1aL33Ekm
	i7+TjrFbXPn6ns2iefF6NotJ9yewWJxtesNusenxNVaLy7vmsFnMOL+PyeL2ZV6LtUfuslus
	n/GaxYHXo6W5h83j969JjB7bvz1g9dg/dw27x/3u40wem5fUe/RtWcXo8XmTXABHFJdNSmpO
	Zllqkb5dAlfGwY5j7AXPJSqOn3rJ3sD4SriLkZNDQsBEYtL208wQtpjEhXvr2boYuTiEBJYy
	Sqxd8psJwuljkrg98TQjSBWbgKbE38032UBsEQFlib8TVzGCFDELbGeRaDo6ESwhLBAgcenD
	IjCbRUBV4vq3n6xdjBwcvALOEq8OukJsU5BY9mUt8wRG7gWMDKsYRVNLkwuKk9JzDfWKE3OL
	S/PS9ZLzczcxQoLvyw7GxcesDjEKcDAq8fBy/PYLFmJNLCuuzD3EKMHBrCTC27zeP1iINyWx
	siq1KD++qDQntfgQIxMHp1QDo/ZcEYFDO2VDA68L13rGiGVVCe2R2Oh058vqhFuv4xaJVt0x
	5NjFs0Y1sdRRQnp2wL+X/+3+Rc8rD7x992RfK1Os/qvQdua5fR9u92VvT048s0XQYPKDyd5G
	b1cfY/ps7nLMY+sDmWqZphSBm4ZfLdedezHJWbPwz7H8KDcX9ruC3DZB1vGlSizFGYmGWsxF
	xYkAjsPreRwCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The patchset presents alternative approach to superdevice DT node
and components framework. It also refactors Exynos DRM device initialization.

The first patch uses linker sections to get rid of ifdef macros, it is not
essential for the rest of patchset but it makes code more readable.
Similar approach is used by irqchip, clks and clk_sources.
Any comments are welcome, especially regarding linker script usage in drivers.

The second patch proposes pending_components framework - lightweight alternative
for componentized devices.
Details are described in the patch description. But as it is an alternative for
component framework I would like to show differences:
- it is simpler and more straightforward,
- it requires only minimal changes to component drivers,
- only one callback to implement,
- no unwinding, component framework in case of error removes all already added
  components and unbinds all already bound components,
- it is instantiated per superdevice, component framework uses global list,
  the disadvantage is that we create dependency between components and
  the superdevice, but in case of Exynos DRM the dependency is present already,
- no two stage component initialization: probe, bind,
- it is more lightweight,
- it clearly separates device probing order issue from registering interfaces
  provided by the device.

The third patch implements pending_components framework in Exynos DRM.
Details are in patch description.

The patchset is based on exynos-drm-next branch.

Regards
Andrzej


Andrzej Hajda (3):
  drm/exynos: refactor drm drivers registration code
  drivers/base: provide lightweight framework for componentized devices
  drm/exynos: use pending_components for components tracking

 drivers/base/Kconfig                        |   3 +
 drivers/base/Makefile                       |   1 +
 drivers/base/pending_components.c           |  93 +++++++++++
 drivers/gpu/drm/exynos/Kconfig              |   1 +
 drivers/gpu/drm/exynos/Makefile             |   2 +
 drivers/gpu/drm/exynos/exynos_dp_core.c     |  38 +++--
 drivers/gpu/drm/exynos/exynos_drm.lds.S     |   9 +
 drivers/gpu/drm/exynos/exynos_drm_drv.c     | 250 ++++++++++------------------
 drivers/gpu/drm/exynos/exynos_drm_drv.h     |  33 ++--
 drivers/gpu/drm/exynos/exynos_drm_dsi.c     |  43 +++--
 drivers/gpu/drm/exynos/exynos_drm_fimc.c    |  36 ++--
 drivers/gpu/drm/exynos/exynos_drm_fimd.c    |  39 +++--
 drivers/gpu/drm/exynos/exynos_drm_g2d.c     |  19 ++-
 drivers/gpu/drm/exynos/exynos_drm_gsc.c     |  32 ++--
 drivers/gpu/drm/exynos/exynos_drm_ipp.c     |  20 ++-
 drivers/gpu/drm/exynos/exynos_drm_rotator.c |  29 +++-
 drivers/gpu/drm/exynos/exynos_drm_vidi.c    |  18 +-
 drivers/gpu/drm/exynos/exynos_hdmi.c        |  55 ++++--
 drivers/gpu/drm/exynos/exynos_mixer.c       |  15 +-
 include/linux/pending_components.h          |  30 ++++
 20 files changed, 466 insertions(+), 300 deletions(-)
 create mode 100644 drivers/base/pending_components.c
 create mode 100644 drivers/gpu/drm/exynos/exynos_drm.lds.S
 create mode 100644 include/linux/pending_components.h

-- 
1.8.3.2

