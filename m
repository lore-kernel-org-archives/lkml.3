Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751165AbaLQTdR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 14:33:17 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:39696 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbaLQTdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 14:33:15 -0500
MIME-Version: 1.0
Date: Wed, 17 Dec 2014 20:33:13 +0100
X-Google-Sender-Auth: PXd5SXijgr6LnJr6WFlCtm_fs2o
Message-ID: <CAMuHMdWY_ne+S3zKrEYqVyU8=S-at=+rGuEkYNauF4s2KaKNdw@mail.gmail.com>
Subject: Enable runtime PM automatically?
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Kevin Hilman <khilman@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Ulf Hansson <ulf.hansson@linaro.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Thomas Abraham <thomas.ab@samsung.com>,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 11:10 PM, Kevin Hilman <khilman@kernel.org> wrote:
> At a deeper level, the problem with this approach is that this is more
> generically a runtime PM dependency problem, not a genpd problem.  For
> example, what happens when the same kind of dependency exists on a
> platform using a custom PM domain instead of genpd (like ACPI.) ?
>
> What's needed to solve this problem is a generalized way to have runtime
> PM dependencies between devices.  Runtime PM already automatically
> handles parent devices as one type of dependent device (e.g. a parent
> device needs to be runtime PM resumed before its child.)  So what's
> needed is a generic way to other PM dependencies with the runtime PM
> core (not the genpd core.)
>
> If runtime PM handles the dependencies corretcly, then genpd (and any
> other PM domain) will get them "for free".

Having the proper dependencies is not sufficient. Currently drivers have to do
something to use runtime PM.

By default, runtime PM is disabled for a device
("device.power.disable_depth = 1").

However, if PM domains are active, drivers must be runtime PM-aware for the
gpd_dev_ops.start() method to be called in the first place (perhaps this is just
one bug that's easy to fix --- the device is "assumed suspended", but can be
used). They must
  1. call pm_runtime_enable() to enable runtime PM for the device,
  2. call pm_runtime_get_sync() to prevent the device from being put in a
    low-power state at any time. This second call has the
"side-effect" of calling
    gpd_dev_ops.start().

Hence, if PM domains are enabled, wouldn't it make sense to
  1. enable runtime PM by default, for all devices (bound and unbound),
  2. call pm_runtime_get_sync(), for all devices bound to a driver.
Of course we have to keep track if drivers call any of the pm_runtime_*()
methods theirselves, as that would have to move them from automatic to
manual mode.

Would this be feasible?

This would avoid the need to add minimal runtime PM support to each and every
driver, because:
  - its device resides in a PM domain, cfr. e.g. commit df0c6c80232f2ad4
    ("gpio: rcar: Add minimal runtime PM support"),
  - its device is a child of a device in a PM domain, cfr. e.g. commit
    3a611e26e958b037 ("net/smsc911x: Add minimal runtime PM support").

There's a similar issue for "transparent" buses that don't need a kernel driver
(compatible = "simple-bus"). If they're in a PM domain, runtime PM must be
enabled for them, so their bus devices are resumed when a child device on the
bus is resumed by runtime PM. Having runtime PM enabled by default
would avoid the need to add a minimal driver for the bus which just
enables runtime PM, cfr. [PATCH v2 0/8] Add Simple Power-Managed Bus Support
(https://lkml.org/lkml/2014/12/17/359).

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
