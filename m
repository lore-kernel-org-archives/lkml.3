Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751347AbaLRTMd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 14:12:33 -0500
Received: from galahad.ideasonboard.com ([185.26.127.97]:51288 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbaLRTMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 14:12:32 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Tomasz Figa <tfiga@chromium.org>, Ulf Hansson <ulf.hansson@linaro.org>,
        Kevin Hilman <khilman@kernel.org>,
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
        Daniel Kurtz <djkurtz@chromium.org>
Subject: Re: [RFC PATCH 2/2] iommu: rockchip: Handle system-wide and runtime PM
Date: Thu, 18 Dec 2014 21:12:34 +0200
Message-ID: <1462052.lBvkDoBROR@avalon>
User-Agent: KMail/4.14.3 (Linux/3.16.5-gentoo; KDE/4.14.3; x86_64; ; )
In-Reply-To: <1727491.gphUuq12bL@vostro.rjw.lan>
References: <1418286387-9663-1-git-send-email-tfiga@chromium.org> <2249350.4v5So9DQ9Z@avalon> <1727491.gphUuq12bL@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

On Thursday 18 December 2014 02:32:30 Rafael J. Wysocki wrote:
> On Wednesday, December 17, 2014 02:15:31 AM Laurent Pinchart wrote:
> > On Tuesday 16 December 2014 11:18:33 Tomasz Figa wrote:
> >> On Tue, Dec 16, 2014 at 4:53 AM, Laurent Pinchart wrote:
> >>> On Monday 15 December 2014 11:39:01 Tomasz Figa wrote:
> >>>> On Sat, Dec 13, 2014 at 5:47 AM, Laurent Pinchart wrote:
> >>>>> On Friday 12 December 2014 13:15:51 Tomasz Figa wrote:
> >>>>>> On Fri, Dec 12, 2014 at 5:48 AM, Rafael J. Wysocki wrote:
> >>>>>>> On Thursday, December 11, 2014 04:51:37 PM Ulf Hansson wrote:
> >>>>>>>> On 11 December 2014 at 16:31, Kevin Hilman wrote:
> >>>>>>>>> Tomasz Figa <tfiga@chromium.org> writes:
> >>>>>>>>>> On Thu, Dec 11, 2014 at 8:58 PM, Ulf Hansson wrote:
> >>>>>>>>> [...]
> >>>>>>>>> 
> >>>>>>>>>>>> @@ -988,11 +1107,28 @@ static int rk_iommu_probe(struct
> >>>>>>>>>>>> platform_device *pdev)
> >>>>>>>>>>>>                 return -ENXIO;
> >>>>>>>>>>>>         }
> >>>>>>>>>>>> 
> >>>>>>>>>>>> +       pm_runtime_no_callbacks(dev);
> >>>>>>>>>>>> +       pm_runtime_enable(dev);
> >>>>>>>>>>>> +
> >>>>>>>>>>>> +       /* Synchronize state of the domain with driver data.
> >>>>>>>>>>>> */
> >>>>>>>>>>>> +       pm_runtime_get_sync(dev);
> >>>>>>>>>>>> +       iommu->is_powered = true;
> >>>>>>>>>>> 
> >>>>>>>>>>> Doesn't the runtime PM status reflect the value of
> >>>>>>>>>>> "is_powered", thus why do you need to have a copy of it? Could
> >>>>>>>>>>> it perpahps be that you try to cope with the case when
> >>>>>>>>>>> CONFIG_PM is unset?
> >>>>>>>>>> 
> >>>>>>>>>> It's worth noting that this driver fully relies on status of
> >>>>>>>>>> other devices in the power domain the IOMMU is in and does not
> >>>>>>>>>> enforce the status on its own. So in general, as far as my
> >>>>>>>>>> understanding of PM runtime subsystem, the status of the IOMMU
> >>>>>>>>>> device will be always suspended, because nobody will call
> >>>>>>>>>> pm_runtime_get() on it (except the get and put pair in probe).
> >>>>>>>>>> So is_powered is here to track status of the domain, not the
> >>>>>>>>>> device. Feel free to suggest a better way, though.
> >>>>>>>>> 
> >>>>>>>>> I still don't like these notifiers.  I think they add ways to
> >>>>>>>>> bypass having proper runtime PM implemented for
> >>>>>>>>> devices/subsystems.
> >>>>>>>> 
> >>>>>>>> I do agree, but I haven't found another good solution to the
> >>>>>>>> problem.
> >>>>>>> 
> >>>>>>> For the record, I'm not liking this mostly because it "fixes" a
> >>>>>>> generic problem in a way that's hidden in the genpd code and very
> >>>>>>> indirect.
> >>>>>> 
> >>>>>> Well, that's true. This is indeed a generic problem of PM
> >>>>>> dependencies between devices (other than those represented by
> >>>>>> parent-child relation), which in fact doesn't have much to do with
> >>>>>> genpd, but rather with those devices directly. It is just that
> >>>>>> genpd is the most convenient location to solve this in current code
> >>>>>> and in a simple way. In other words, I see this solution as a
> >>>>>> reasonable way to get the problem solved quickly for now, so that
> >>>>>> we can start thinking about a more elegant solution.
> >>>>>> 
> >>>>>>>>> From a high-level, the IOMMU is just another device inside the
> >>>>>>>>> PM domain, so ideally it should be doing it's own _get() and
> >>>>>>>>> _put() calls so the PM domain code would just do the right thing
> >>>>>>>>> without the need for notifiers.
> >>>>>>>> 
> >>>>>>>> As I understand it, the IOMMU (or for other similar cases)
> >>>>>>>> shouldn't be doing any get() and put() at all because there are
> >>>>>>>> no IO API to serve request from.
> >>>>> 
> >>>>> Speaking purely from an IOMMU point of view that's not entirely
> >>>>> tree. IOMMU drivers expose map and unmap operations, so they can
> >>>>> track whether any memory is mapped. From a bus master point of view
> >>>>> the IOMMU map and unmap operations are hidden by the DMA mapping
> >>>>> API. The IOMMU can thus track the existence of mappings without any
> >>>>> IOMMU awareness in the bus master driver.
> >>>>> 
> >>>>> If no mapping exist the IOMMU shouldn't receive any translation
> >>>>> request. An IOMMU driver could thus call pm_runtime_get_sync() in
> >>>>> the map handler when creating the first mapping, and
> >>>>> pm_runtime_put() in the unmap handler when tearing the last mapping
> >>>>> down.
> >>>>> 
> >>>>> One could argue that the IOMMU would end up being powered more often
> >>>>> than strictly needed, as bus masters drivers, even when written
> >>>>> properly, could keep mappings around at times they don't perform bus
> >>>>> access. This is true, and that's an argument I've raised during the
> >>>>> last kernel summit. The general response (including Linus Torvald's)
> >>>>> was that micro-optimizing power management might not be worth it,
> >>>>> and that measurements proving that the gain is worth it are required
> >>>>> before introducing new APIs to solve the problem. I can't disagree
> >>>>> with that argument.
> >>>> 
> >>>> This would be a micro optimization if the IOMMU was located in its
> >>>> own power domain. Unfortunately in most cases it is not, so keeping
> >>>> all the devices in the domain powered on, because one of them have a
> >>>> mapping created doesn't sound like a good idea.
> >>>> 
> >>>> Moreover, most of the drivers will keep the mapping for much longer
> >>>> than one run cycle. Please take a look at V4L2's videobuf2 subsystem
> >>>> (which I guess you are more familiar with than me;)), which will keep
> >>>> MMAP buffers mapped in IOMMU address space for their whole lifetime.
> >>>> I believe similar is the case for DRM drivers.
> >>> 
> >>> Yes, but that doesn't mean it gets out of control. Buffers shouldn't
> >>> be allocated if they won't be used. Granted, they could be
> >>> preallocated (or rather premapped) slightly before being used, but in
> >>> sane use cases that shouldn't be long before the hardware needs to be
> >>> turned on.
> >> 
> >> Assuming that we don't have a third party, called "user", involved.
> > 
> > Who needs that ? :-D
> > 
> >> A simple use case is video playback pause. Usually all the software
> >> state (including output buffers that can be used as reference for
> >> decoding next frames) needs to be preserved to continue decoding after
> >> resume, but it would be nice to power off the decoder, if it is unused
> >> for some period. In addition, we would like the pause/resume operation
> >> to be fast, so unmapping/freeing buffers and then exactly the opposite
> >> on resume doesn't sound like a good idea.
> > 
> > OK, then we have one possible use case. I expect people to still want to
> > see power consumption numbers though.
> 
> Well, we have them, kind of.
> 
> In the ACPI world there's something called _DEP which gives us a list of
> devices depended on by the given one.  Those may be devices whose drivers
> provide so called "operation region" handling which means that an ACPI
> method executed for the dependent device may access a device it depends on
> indirectly.  Because of that indirection we basically need the devices
> listed by _DEP to be "on" whenever the dependent device is "on" or things
> may break in nasty ways otherwise.
> 
> Now, on (some) Intel SoCs some devices listed by _DEP cannot be "on" all the
> time, because the lowest-power states of the whole SoC cannot be used then,
> which makes hours of battery life of a difference.
> 
> This isn't exactly the same problem, but it maps to the IOMMU one quite well
> IMO.

Agreed, that's certainly a use case for a power dependency implementation.

> > You can call me annoying, but I'm not sure whether a generic PM dependency
> > implementation, while it could be a good idea in general, is the best
> > solution here, especially if the bus master and the IOMMU are in a
> > different power domain. The bus master could provide functions that don't
> > require DMA access. For instance a camera controller could feed its
> > output to the display directly, without going through memory. In that
> > case we probably don't want to power the IOMMU and its complete power
> > domain on when using the camera controller in that mode.
> 
> That's a fair point, but it really boils down to energy usage numbers again.
>
> > One alternative solution would be to extend the DMA mapping API with two
> > functions to signal that DMA is about to be started and that DMA has now
> > finished. It might be considered too ad-hoc though.
> 
> It would be better to be able to reference count the DMA engine from the
> bus master IMO and arguably you can use the runtime PM framework for that.
> Namely, give bus masters someting like
> 
> 	pm_runtime_get_my_DMA_engine(bus_master_device)
> 	pm_runtime_put_my_DMA_engine(bus_master_device)
> 
> and let them call these as they see fit.

Please note that we're not talking about DMA engines here, but about IOMMUs. 
DMA is involved through the DMA mapping API which hides the IOMMU completely 
from the bus master drivers, not the DMA engine API.

Exposing the IOMMU is something we want to avoid, but DMA mapping start/stop 
operations could certainly be implemented.

-- 
Regards,

Laurent Pinchart

