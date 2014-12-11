Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758946AbaLKU0t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 15:26:49 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:63323 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758912AbaLKU0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 15:26:46 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Kevin Hilman <khilman@kernel.org>, Tomasz Figa <tfiga@chromium.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        iommu@lists.linux-foundation.org, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Heiko Stuebner <heiko@sntech.de>,
        Joerg Roedel <joro@8bytes.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC PATCH 2/2] iommu: rockchip: Handle system-wide and runtime PM
Date: Thu, 11 Dec 2014 21:48:17 +0100
Message-ID: <1576771.dIVCOxU0se@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAPDyKFo6zH4__Odm+RiJCbvXquAQqaLyCAiXrSN6s3KfQhok=A@mail.gmail.com>
References: <1418286387-9663-1-git-send-email-tfiga@chromium.org> <7h8uiemce7.fsf@deeprootsystems.com> <CAPDyKFo6zH4__Odm+RiJCbvXquAQqaLyCAiXrSN6s3KfQhok=A@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, December 11, 2014 04:51:37 PM Ulf Hansson wrote:
> On 11 December 2014 at 16:31, Kevin Hilman <khilman@kernel.org> wrote:
> > [+ Laurent Pinchart]
> >
> > Tomasz Figa <tfiga@chromium.org> writes:
> >
> >> On Thu, Dec 11, 2014 at 8:58 PM, Ulf Hansson <ulf.hansson@linaro.org> wrote:
> >
> > [...]
> >
> >>>> @@ -988,11 +1107,28 @@ static int rk_iommu_probe(struct platform_device *pdev)
> >>>>                 return -ENXIO;
> >>>>         }
> >>>>
> >>>> +       pm_runtime_no_callbacks(dev);
> >>>> +       pm_runtime_enable(dev);
> >>>> +
> >>>> +       /* Synchronize state of the domain with driver data. */
> >>>> +       pm_runtime_get_sync(dev);
> >>>> +       iommu->is_powered = true;
> >>>
> >>> Doesn't the runtime PM status reflect the value of "is_powered", thus
> >>> why do you need to have a copy of it? Could it perpahps be that you
> >>> try to cope with the case when CONFIG_PM is unset?
> >>>
> >>
> >> It's worth noting that this driver fully relies on status of other
> >> devices in the power domain the IOMMU is in and does not enforce the
> >> status on its own. So in general, as far as my understanding of PM
> >> runtime subsystem, the status of the IOMMU device will be always
> >> suspended, because nobody will call pm_runtime_get() on it (except the
> >> get and put pair in probe). So is_powered is here to track status of
> >> the domain, not the device. Feel free to suggest a better way, though.
> >
> > I still don't like these notifiers.  I think they add ways to bypass
> > having proper runtime PM implemented for devices/subsystems.
> 
> I do agree, but I haven't found another good solution to the problem.

For the record, I'm not liking this mostly because it "fixes" a generic problem
in a way that's hidden in the genpd code and very indirect.

> > From a high-level, the IOMMU is just another device inside the PM
> > domain, so ideally it should be doing it's own _get() and _put() calls
> > so the PM domain code would just do the right thing without the need for
> > notifiers.
> 
> As I understand it, the IOMMU (or for other similar cases) shouldn't
> be doing any get() and put() at all because there are no IO API to
> serve request from.
> 
> In principle we could consider these kind devices as "parent" devices
> to those other devices that needs them. Then runtime PM core would
> take care of things for us, right!?
> 
> Now, I am not so sure using the "parent" approach is actually viable,
> since it will likely have other complications, but I haven't
> thoroughly thought it though yet.

That actually need not be a "parent".

What's needed in this case is to do a pm_runtime_get_sync() on a device
depended on every time a dependent device is runtime-resumed (and analogously
for suspending).

The core doesn't have a way to do that, but it looks like we'll need to add
it anyway for various reasons (ACPI _DEP is one of them as I mentioned some
time ago, but people dismissed it basically as not their problem).


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
