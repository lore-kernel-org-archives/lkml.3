Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757958AbaLJPs4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 10:48:56 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:60962 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756341AbaLJPsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 10:48:54 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-7a-54886b62f7c7
From: Andrzej Hajda <a.hajda@samsung.com>
To: linux-kernel@vger.kernel.org (open list)
Cc: Andrzej Hajda <a.hajda@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mike Turquette <mturquette@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Inki Dae <inki.dae@samsung.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/CLKDEV SUPPORT),
        linux-gpio@vger.kernel.org (open list:GPIO SUBSYSTEM),
        dri-devel@lists.freedesktop.org (open list:DRM PANEL DRIVERS),
        linux-samsung-soc@vger.kernel.org (moderated list:ARM/S5P EXYNOS AR...),
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND...),
        boris.brezillon@free-electrons.com
Subject: [RFC 00/15] Resource tracking/allocation framework
Date: Wed, 10 Dec 2014 16:48:18 +0100
Message-id: <1418226513-14105-1-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrILMWRmVeSWpSXmKPExsVy+t/xy7pJ2R0hBl2/TCxurTvHanHgxUIW
	i6kPn7BZzD8C5F75+p7N4tyrRywWB/7sYLRoXryezWLS/QksFhee9rBZfLvSwWQx5c9yJotN
	j6+xWmye/4fR4vKuOWwWM87vY7K4fZnXYu2Ru+wWTydcZLNo3XuE3eLnrnksDqIeLc09bB5P
	Nl1k9Ng56y67x6ZVnWwed67tYfPYP3cNu8f97uNMHpuX1Hv0bVnF6HH8xnYmj8+b5AK4o7hs
	UlJzMstSi/TtErgy2r8/Zi5YalOx48lnlgbGHr0uRk4OCQETiQvT1rJB2GISF+6tB7K5OIQE
	ljJKzP3VwgLh9DFJPL97nBmkik1AU+Lv5ptgHSICOhLXe7qZQYqYBTawS6ybvg8sISxgLdGz
	6z4LiM0ioCqx4/R8MJtXwFni56MuJoh1chInj01mncDIvYCRYRWjaGppckFxUnquoV5xYm5x
	aV66XnJ+7iZGSLB/2cG4+JjVIUYBDkYlHl5zxdYQIdbEsuLK3EOMEhzMSiK8C5M7QoR4UxIr
	q1KL8uOLSnNSiw8xMnFwSjUwSgWd6qnPOeK+4vqOuSFz1bR4zzEflF7wbp2zJpvWo8zotEqu
	HQ+WlUxm/iD8LPsZY6puzpT/Xx0ZDxiFBiTKqIZJS00O+RDNdm/le3HFVrmNNewLOJMjpwu+
	eF+y2y86IjBVpDWkzURsxr0ZZrnXV33sbFyUaFOjb697oPc/h7xutUpol4YSS3FGoqEWc1Fx
	IgAavK7DVAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Many kernel frameworks that uses provider/consumer schema suffer from
few issues:
1. They have broken driver unbinding handling. When device driver of the provider
  is unbound from the device, its consumers stay with reference to non-existing
  objects, as a result we can observe oopses, crashes, hangs.
  Frameworks tries to handle it by using:
  - module refcounting (try_module_get/module_put) - as the name says it
    protects only from module unloading, not driver unbinding. Additionally
    it can cause circular dependencies of modules and inability to unload them.
  - ghost providers - when driver is unbound provider is replaced with phony one,
    which returns errors on every access. It also does not solve the issue -
    consumer device can hang if the hardware represented by the provider is off.
2. Consumer does not know when required resource becomes available. Currently it
  is solved by deferred probing. The main problem with this solution is that it
  delays deferred device probe to late_initcall, for some devices it is
  unacceptable/undesirable.
3. There are drivers which can work without specific resource, but if
  the resource becomes available/unavailable it can do some additional stuff.
  An example of such driver is DRM driver (more precisely drm_connector) -
  it can start without attached drm_panel, but if the panel becomes available it
  can react by generating HPD event and start using it. Delaying drm
  initialization due to lack of panel should be avoided - drm can still be
  usable without it, for example it can still use HDMI monitor.
  Currently it can be handled by periodic polling drm_panel framework for
  the panel, but it is rather an workaround, not a real solution.

The main problem with the 1st issue is that drivers cannot be protected from
unbinding. So there is no way to prevent removal of resources they provide.
The only solution I see is to provide notifications to consumers about incoming
removal of resources they are using, so they can react appropriately.
Symmetrically we can add notifications about appearance of specific resources,
this way the 2nd issue can be solved.
And finally with both notifications we can solve the 3rd issue.

In the 1st patch I propose generic framework providing such notifications, named
track - propositions for better name are welcome.
Its main feature is that callbacks are serialized but are not called under lock,
it allows two important things:
- avoid additional locks in the consumers to protect data access from different
  callbacks,
- call the framework from within the callback, so complex dependencies can be
  modelled this way, without worries about deadlocks due to framework.

The 2nd patch contains restrack framework which uses internally track framework
to track and automatically allocate different resources. In short it can replace
all resource allocations with single call + callback. Of course it is just
a bonus. The most important thing is that it solves all described issues:
- it can properly handle provider unbind/re-bind,
- it avoids late init due to deferred probing,
- it allows to track optional resources.

Simple example taken from restrack commit message:

    static int lcd_probe(...)
    {
        struct restrack *rtrack;

    (...initialization w/o resource allocation ...)

        rtrack = devm_restrack_register(dev, lcd_callback,
                regulator_bulk_restrack_desc(&ctx->supplies[0]),
                regulator_bulk_restrack_desc(&ctx->supplies[1]),
                clk_restrack_desc(&ctx->pll_clk, "pll_clk"),
                clk_restrack_desc(&ctx->bus_clk, "bus_clk"),
                phy_restrack_desc(&ctx->phy, "dsim"),
        );

        return PTR_ERR_OR_NULL(rtrack);
    }

    void lcd_callback(struct device *dev, int ret)
    {
        struct lcd_ctx *ctx = dev_get_drvdata(dev);

        if (ret == 0)
                drm_panel_add(&ctx->panel);
        else if (ret == -EPROBE_DEFER)
                drm_panel_remove(&ctx->panel);
        else
                dev_err(dev, "restrack error %d\n", ret);
    }

For other examples look at patches 11, 13, 15.

Patches 3,4,6,8,9 adds restrack support to various frameworks. Restrack support
is added only to resources exposed via Device Tree. Adding support for non-DT
resources should be also possible, but I guess it can be more complicated as
resource lookup mechanism is more fuzzy. Anyway I can work on it if necessary.
Moreover these patches in some cases adds redundant code for DT lookup,
this redundancy can be removed in final version of the patchset.
Also another frameworks may need similar patches.

Patch 11 converts exynos-dsi driver to restrack API. It solves issues of
provider unbind (1st issue) and late init due to deferred probing (2nd issue).

Patch 13 shows how to deal with optional resources (3rd issue).

Patch 15 is a simple example how to deal with resources depending on other
resources. In this particular case ld9040 lcd panel driver requires presence
of regulators and gpio prior to expose drm_panel resource.

Patches 5 and 7 adds helper functions for DT node lookup of resource providers.

Patches 10,12,14 are just fixes or cleanups.

The patchset is based on exynos-drm-next [1] due to fact I have developed it
on exynos platforms. I can rebase it on other branch, if necessary.

[1]: https://git.kernel.org/cgit/linux/kernel/git/daeinki/drm-exynos.git/log/?h=exynos-drm-next

Regards
Andrzej


Andrzej Hajda (15):
  drivers/base: add track framework
  drivers/base: add restrack framework
  drm/panel: add restrack support
  regulator: add restrack support
  gpio: move DT parsing code to separate functions
  gpio: add restrack support
  clk: add DT parsing function
  clk: add restrack support
  phy: add restrack support
  drm/exynos/dsi: simplify hotplug code
  drm/exynos/dsi: convert to restrack API
  drm/exynos/dpi: use common of_graph functions
  drm/exynos/dpi: convert to restrack API
  drm/panel/ld9040: do not power off panel on removal
  drm/panel/ld9040: convert to restrack API

 drivers/base/Makefile                    |   2 +-
 drivers/base/restrack.c                  | 344 +++++++++++++++++++++++++++++++
 drivers/base/track.c                     | 241 ++++++++++++++++++++++
 drivers/clk/clk.c                        |   6 +
 drivers/clk/clkdev.c                     |  97 +++++++++
 drivers/gpio/gpiolib-of.c                |  59 +++---
 drivers/gpio/gpiolib.c                   | 114 +++++++++-
 drivers/gpio/gpiolib.h                   |   4 +-
 drivers/gpu/drm/drm_panel.c              |  97 +++++++++
 drivers/gpu/drm/exynos/exynos_drm_dpi.c  | 193 +++++++----------
 drivers/gpu/drm/exynos/exynos_drm_dsi.c  | 113 +++++-----
 drivers/gpu/drm/exynos/exynos_drm_fimd.c |   7 +
 drivers/gpu/drm/panel/panel-ld9040.c     |  42 ++--
 drivers/phy/phy-core.c                   |  90 ++++++++
 drivers/regulator/core.c                 |  77 +++++++
 include/drm/drm_panel.h                  |   4 +
 include/linux/clk.h                      |   3 +
 include/linux/gpio/consumer.h            |   4 +
 include/linux/phy/phy.h                  |   3 +
 include/linux/regulator/consumer.h       |  10 +
 include/linux/restrack.h                 | 143 +++++++++++++
 include/linux/track.h                    | 148 +++++++++++++
 22 files changed, 1567 insertions(+), 234 deletions(-)
 create mode 100644 drivers/base/restrack.c
 create mode 100644 drivers/base/track.c
 create mode 100644 include/linux/restrack.h
 create mode 100644 include/linux/track.h

-- 
1.9.1

