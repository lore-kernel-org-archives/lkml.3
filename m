Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965000AbaLKPae (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 10:30:34 -0500
Received: from mail-qa0-f43.google.com ([209.85.216.43]:44005 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbaLKPad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 10:30:33 -0500
MIME-Version: 1.0
In-Reply-To: <5489A227.8010907@samsung.com>
References: <1418286387-9663-1-git-send-email-tfiga@chromium.org>
	<1418286387-9663-2-git-send-email-tfiga@chromium.org>
	<548973B7.3050107@samsung.com>
	<CAAFQd5DrzYRCF3tW7cg=rZ3wB1G2kQtWbCx+Pby9obNTewsFdg@mail.gmail.com>
	<5489A227.8010907@samsung.com>
Date: Thu, 11 Dec 2014 16:30:23 +0100
Message-ID: <CAPDyKFpjPdj=uy-xAN7iMivDJFPYA-ykkkjEeyHh+6KFv4ktTg@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] pm: Add PM domain notifications
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Tomasz Figa <tfiga@chromium.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        iommu@lists.linux-foundation.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Heiko Stuebner <heiko@sntech.de>, Joerg Roedel <joro@8bytes.org>,
        Kevin Hilman <khilman@linaro.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Beata Michalska <b.michalska@samsung.com>,
        Amit Kachhap <amit.kachhap@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 December 2014 at 14:54, Sylwester Nawrocki <s.nawrocki@samsung.com> wrote:
> On 11/12/14 12:04, Tomasz Figa wrote:
> ...
>>> > On 11/12/14 09:26, Tomasz Figa wrote:
>>>> > > From: Sylwester Nawrocki <s.nawrocki@samsung.com>
>>>> > >
>>>> > > This patch adds notifiers to the runtime PM/genpd subsystem. It is now
>>>> > > possible to register a notifier, which will be called before and after
>>>> > > the generic power domain subsystem calls the power domain's power_on
>>>> > > and power_off callbacks.
>>>> > >
>>>> > > Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>>>> > > [tfiga@chromium.org: rebased]
>>>> > > Signed-off-by: Tomasz Figa <tfiga@chromium.org>
>>> >
>>> > Not sure if you've noticed it, I posted an updated version of this patch
>>> > recently [1]. The notifiers list is moved to struct generic_pm_domain
>>> > there and it also allows to register a notifier for selected power domain
>>> > by name.
>> [snip]
>>> > [1] http://www.spinics.net/lists/linux-samsung-soc/msg38549.html
>>
>> Ah, haven't noticed, sorry. The API using devices looks the same, so I
>> guess we can simply have patch 2/2 of this series applied on top of
>> your patch.
>
> Yes, that should work.
>
>> By the way, look-up by name (presumably hardcoded somewhere?) sounds a
>> bit strange to me. What was the reason for it to be added?
>
> Yes, that might not be a very elegant approach. We initially used it
> to implement power domain on/off sequence per specific domain and SoC,
> since it appeared resistant to generalize.  I.e. the control register
> write sequences are different per domain and per SoC (exynos).
> So we named the domains in the device tree in that way:
>
>         pm_domains: pm-domains@10024000 {
>                 compatible = "samsung,exynos4415-pd";
>                 reg-names = "cam", "tv", "mfc", "g3d",
>                             "lcd0", "isp0", "isp1";
>                 reg = <0x10024000 0x20>, <0x10024020 0x20>,
>                       <0x10024040 0x20>, <0x10024060 0x20>,
>                       <0x10024080 0x20>, <0x100240A0 0x20>,
>                       <0x100240E0 0x20>;
>                 #power-domain-cells = <1>;
>         };
>
> and then, for example, in the exynos CMU_ISP{0, 1} (clock controller)
> driver registered for notification on "isp0" and "isp1" power domains
> ("isp1" is a sub-domain of "isp0" and the consumer devices are normally
> attached to "isp1").
>
> We have been investigating if we could do without the notification
> at the clocks driver side, then the all SoC/power domain specific code
> would end up in the exynos power domain driver. But I'm afraid it's
> not going to work for all SoCs. Anyway lookup by name might be not
> needed.

Regarding "lookup by name", let's please move away from those APIs. I
am planning to remove all name based API from the genpd API as soon as
I can.

If you need to fetch domains, this might help you:
http://www.spinics.net/lists/arm-kernel/msg383743.html

Kind regards
Uffe
