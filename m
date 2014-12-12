Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965906AbaLLUq2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 15:46:28 -0500
Received: from galahad.ideasonboard.com ([185.26.127.97]:44465 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756478AbaLLUq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 15:46:26 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tomasz Figa <tfiga@chromium.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Ulf Hansson <ulf.hansson@linaro.org>,
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
Date: Fri, 12 Dec 2014 22:47:15 +0200
Message-ID: <1508486.LLFuttrbI2@avalon>
User-Agent: KMail/4.12.5 (Linux/3.16.5-gentoo; KDE/4.12.5; x86_64; ; )
In-Reply-To: <CAAFQd5B28WiWUqmbmROJUa3H25R=Y774NuemTZDvkoa=CvZUsw@mail.gmail.com>
References: <1418286387-9663-1-git-send-email-tfiga@chromium.org> <1576771.dIVCOxU0se@vostro.rjw.lan> <CAAFQd5B28WiWUqmbmROJUa3H25R=Y774NuemTZDvkoa=CvZUsw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Friday 12 December 2014 13:15:51 Tomasz Figa wrote:
> On Fri, Dec 12, 2014 at 5:48 AM, Rafael J. Wysocki wrote:
> > On Thursday, December 11, 2014 04:51:37 PM Ulf Hansson wrote:
> >> On 11 December 2014 at 16:31, Kevin Hilman <khilman@kernel.org> wrote:
> >> > [+ Laurent Pinchart]
> >> > 
> >> > Tomasz Figa <tfiga@chromium.org> writes:
> >> >> On Thu, Dec 11, 2014 at 8:58 PM, Ulf Hansson wrote:
> >> > [...]
> >> > 
> >> >>>> @@ -988,11 +1107,28 @@ static int rk_iommu_probe(struct
> >> >>>> platform_device *pdev)>> >>>> 
> >> >>>>                 return -ENXIO;
> >> >>>>         
> >> >>>>         }
> >> >>>> 
> >> >>>> +       pm_runtime_no_callbacks(dev);
> >> >>>> +       pm_runtime_enable(dev);
> >> >>>> +
> >> >>>> +       /* Synchronize state of the domain with driver data. */
> >> >>>> +       pm_runtime_get_sync(dev);
> >> >>>> +       iommu->is_powered = true;
> >> >>> 
> >> >>> Doesn't the runtime PM status reflect the value of "is_powered", thus
> >> >>> why do you need to have a copy of it? Could it perpahps be that you
> >> >>> try to cope with the case when CONFIG_PM is unset?
> >> >> 
> >> >> It's worth noting that this driver fully relies on status of other
> >> >> devices in the power domain the IOMMU is in and does not enforce the
> >> >> status on its own. So in general, as far as my understanding of PM
> >> >> runtime subsystem, the status of the IOMMU device will be always
> >> >> suspended, because nobody will call pm_runtime_get() on it (except the
> >> >> get and put pair in probe). So is_powered is here to track status of
> >> >> the domain, not the device. Feel free to suggest a better way, though.
> >> > 
> >> > I still don't like these notifiers.  I think they add ways to bypass
> >> > having proper runtime PM implemented for devices/subsystems.
> >> 
> >> I do agree, but I haven't found another good solution to the problem.
> > 
> > For the record, I'm not liking this mostly because it "fixes" a generic
> > problem in a way that's hidden in the genpd code and very indirect.
> 
> Well, that's true. This is indeed a generic problem of PM dependencies
> between devices (other than those represented by parent-child
> relation), which in fact doesn't have much to do with genpd, but
> rather with those devices directly. It is just that genpd is the most
> convenient location to solve this in current code and in a simple way.
> In other words, I see this solution as a reasonable way to get the
> problem solved quickly for now, so that we can start thinking about a
> more elegant solution.
> 
> >> > From a high-level, the IOMMU is just another device inside the PM
> >> > domain, so ideally it should be doing it's own _get() and _put() calls
> >> > so the PM domain code would just do the right thing without the need
> >> > for notifiers.
> >> 
> >> As I understand it, the IOMMU (or for other similar cases) shouldn't
> >> be doing any get() and put() at all because there are no IO API to
> >> serve request from.

Speaking purely from an IOMMU point of view that's not entirely tree. IOMMU 
drivers expose map and unmap operations, so they can track whether any memory 
is mapped. From a bus master point of view the IOMMU map and unmap operations 
are hidden by the DMA mapping API. The IOMMU can thus track the existence of 
mappings without any IOMMU awareness in the bus master driver.

If no mapping exist the IOMMU shouldn't receive any translation request. An 
IOMMU driver could thus call pm_runtime_get_sync() in the map handler when 
creating the first mapping, and pm_runtime_put() in the unmap handler when 
tearing the last mapping down.

One could argue that the IOMMU would end up being powered more often than 
strictly needed, as bus masters drivers, even when written properly, could 
keep mappings around at times they don't perform bus access. This is true, and 
that's an argument I've raised during the last kernel summit. The general 
response (including Linus Torvald's) was that micro-optimizing power 
management might not be worth it, and that measurements proving that the gain 
is worth it are required before introducing new APIs to solve the problem. I 
can't disagree with that argument.

> >> In principle we could consider these kind devices as "parent" devices
> >> to those other devices that needs them. Then runtime PM core would
> >> take care of things for us, right!?
> >> 
> >> Now, I am not so sure using the "parent" approach is actually viable,
> >> since it will likely have other complications, but I haven't
> >> thoroughly thought it though yet.
> > 
> > That actually need not be a "parent".
> > 
> > What's needed in this case is to do a pm_runtime_get_sync() on a device
> > depended on every time a dependent device is runtime-resumed (and
> > analogously for suspending).
> > 
> > The core doesn't have a way to do that, but it looks like we'll need to
> > add it anyway for various reasons (ACPI _DEP is one of them as I mentioned
> > some time ago, but people dismissed it basically as not their problem).
> 
> Let me show you our exact use case.
> 
> We have a power domain, which contains an IOMMU and an IP block, which
> can do bus transactions through that IOMMU. Of course the IP block is
> not aware of the IOMMU, because this is just an integration detail and
> on other platforms using the same IP block the IOMMU might not be
> there. This implies that the driver for this IP block should not be
> aware of the IOMMU either, which, on the buffer allocation and mapping
> side, is achieved by DMA mapping subsystem. We would also want the
> IOMMU to be fully transparent to that driver on PM side.
> 
> Now, for PM related details, they are located in the same power
> domain, which means that whenever the power domain is turned off, the
> CPU can't access their registers and all the hardware state is gone.
> To make the case more interesting, there is no point in programming
> the IOMMU unless the device using it is powered on. Similarly, there
> is no point in powering the domain on to just access the IOMMU. This
> implies that the power domain should be fully controlled by the
> stand-alone IP block, while the peripheral IOMMU shouldn't affect its
> state and its driver only respond to operations performed by driver of
> that stand-alone IP block.
> 
> A solution like below could work for the above:
> 
> - There is a per-device list of peripheral devices, which need to be
> powered on for this device to work.
> - Whenever the IOMMU subsystem/driver binds an IOMMU to a device, it
> adds the IOMMU device to the list of peripheral devices of that device
> (and similarly for removal).
> - A runtime PM operation on a device will also perform the same
> operation on all its peripheral devices.
> 
> Another way would be to extend what the PM runtime core does with
> parent-child relations to handle the whole list of peripheral devices
> instead of just the parent.
> 
> Would this design sound somehow reasonable to you?

-- 
Regards,

Laurent Pinchart

