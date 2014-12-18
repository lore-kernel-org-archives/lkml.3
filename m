Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751785AbaLRAfu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 19:35:50 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:63024 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751201AbaLRAfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 19:35:48 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Kevin Hilman <khilman@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Len Brown <len.brown@intel.com>, Ulf Hansson <ulf.hansson@linaro.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Thomas Abraham <thomas.ab@samsung.com>,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Enable runtime PM automatically?
Date: Thu, 18 Dec 2014 01:57:33 +0100
Message-ID: <2631000.5asdLXAEtK@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAMuHMdWY_ne+S3zKrEYqVyU8=S-at=+rGuEkYNauF4s2KaKNdw@mail.gmail.com>
References: <CAMuHMdWY_ne+S3zKrEYqVyU8=S-at=+rGuEkYNauF4s2KaKNdw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, December 17, 2014 08:33:13 PM Geert Uytterhoeven wrote:
> On Tue, Dec 16, 2014 at 11:10 PM, Kevin Hilman <khilman@kernel.org> wrote:
> > At a deeper level, the problem with this approach is that this is more
> > generically a runtime PM dependency problem, not a genpd problem.  For
> > example, what happens when the same kind of dependency exists on a
> > platform using a custom PM domain instead of genpd (like ACPI.) ?
> >
> > What's needed to solve this problem is a generalized way to have runtime
> > PM dependencies between devices.  Runtime PM already automatically
> > handles parent devices as one type of dependent device (e.g. a parent
> > device needs to be runtime PM resumed before its child.)  So what's
> > needed is a generic way to other PM dependencies with the runtime PM
> > core (not the genpd core.)
> >
> > If runtime PM handles the dependencies corretcly, then genpd (and any
> > other PM domain) will get them "for free".
> 
> Having the proper dependencies is not sufficient. Currently drivers have to do
> something to use runtime PM.
> 
> By default, runtime PM is disabled for a device
> ("device.power.disable_depth = 1").

Which isn't the case for PCI devices.

> However, if PM domains are active, drivers must be runtime PM-aware for the
> gpd_dev_ops.start() method to be called in the first place (perhaps this is just
> one bug that's easy to fix --- the device is "assumed suspended", but can be
> used). They must
>   1. call pm_runtime_enable() to enable runtime PM for the device,
>   2. call pm_runtime_get_sync() to prevent the device from being put in a
>     low-power state at any time. This second call has the
> "side-effect" of calling
>     gpd_dev_ops.start().
> 
> Hence, if PM domains are enabled, wouldn't it make sense to
>   1. enable runtime PM by default, for all devices (bound and unbound),

I guess you mean for devices with and without drivers here?

>   2. call pm_runtime_get_sync(), for all devices bound to a driver.
> Of course we have to keep track if drivers call any of the pm_runtime_*()
> methods theirselves, as that would have to move them from automatic to
> manual mode.
> 
> Would this be feasible?

PCI does something similar and IMO it would make sense to do that for all
devices, at least where we have a known way to power them up/down without a
driver.

There's a couple of questions, though.  First, how many drivers would break
if we enabled runtime PM by default?  Second, if we do that, how do we
figure out the initial value of runtime PM status in general?  Finally,
what about drivers that need to work with and without PM domains (for example,
some systems they run on have PM domains, while some other don't)?


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
