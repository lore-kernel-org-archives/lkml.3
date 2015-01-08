Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756478AbbAHMiD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 07:38:03 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:1378 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103AbbAHMh7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 07:37:59 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 08 Jan 2015 04:36:30 -0800
Date: Thu, 8 Jan 2015 14:37:09 +0200
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Thierry Reding <thierry.reding@gmail.com>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>, <stable@vger.kernel.org>,
        Joseph Lo <josephl@nvidia.com>, <linux-tegra@vger.kernel.org>,
        Dmitry Osipenko <digetx@gmail.com>, Shawn Guo <shawn.guo@linaro.org>,
        Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] ARM: tegra: Use PMC scratch register 40 for
 tegra_resume() location store
Message-ID: <20150108123709.GX10073@tbergstrom-lnx.Nvidia.com>
References: <1419202392-1159-1-git-send-email-digetx@gmail.com>
 <54984429.8040905@wwwdotorg.org>
 <5498549B.8070101@gmail.com>
 <54985C30.7020605@wwwdotorg.org>
 <20150108105742.GI1987@ulmo.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20150108105742.GI1987@ulmo.nvidia.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [10.21.24.170]
X-ClientProxiedBy: UKMAIL101.nvidia.com (10.26.138.13) To
 UKMAIL101.nvidia.com (10.26.138.13)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2015 at 11:57:43AM +0100, Thierry Reding wrote:
> * PGP Signed by an unknown key
> 
> On Mon, Dec 22, 2014 at 11:00:16AM -0700, Stephen Warren wrote:
> > On 12/22/2014 10:27 AM, Dmitry Osipenko wrote:
> > >22.12.2014 19:17, Stephen Warren пишет:
> > >>On 12/21/2014 03:52 PM, Dmitry Osipenko wrote:
> > >>>Commit 7232398abc6a ("ARM: tegra: Convert PMC to a driver") changed
> > >>>tegra_resume()
> > >>>location storing from late to early and as result broke suspend on tegra20.
> > >>>PMC scratch register 41 was used by tegra lp1 suspend core code for storing
> > >>>physical memory address of common resume function and in the same time used by
> > >>>tegra20 cpuidle driver for storing cpu1 "resettable" status, so it implied
> > >>>strict order of scratch register use. Fix it by using scratch 40 instead of 41
> > >>>for tegra_resume() location store.
> > >>
> > >>You likely can't simply change the PMC scratch register usage arbitrarily;
> > >>specific registers are designated for specific purposes, and code outside the
> > >>Linux kernel (bootloaders, LP0 resume code, secure monitors, etc.) may depend on
> > >>those specific values being in those registers. Without significant research,
> > >>I'd suggest not changing the PMC scratch register usage.
> > >
> > >Sure, that's why I asked to verify if scratch register 40 is in use in the
> > >comment after commit message.
> > 
> > Sorry, I didn't notice that.
> > 
> > >I've checked that u-boot doesn't use it (since
> > >upstream kernel doesn't care about any other bootloader), but no idea about
> > >secure monitor. It's definitely safer to avoid changing scratch regs usage, I
> > >thought that proposed solution would be best from the pure code point of view.
> > >So, I'm considering your answer as a rejection of the patch (please, let me know
> > >if I'm wrong) and will prepare another one. Btw, it would be nice to have
> > >scratch registers usage publicly documented somewhere (on "Tegra Public
> > >Application Notes" webpage for example), if it's possible, of course.
> > 
> > At this stage in Tegra20 development, I think it'd be best to avoid changing
> > any scratch register usage if at all possible.
> 
> Sorry, I had completely missed this discussion. When looking at the code
> it doesn't look like this particular "resettable" status needs to be
> stored in a PMC scratch register. It can't be stored in RAM because that
> goes into self-refresh as part of LP1, but how about just putting it
> into IRAM? That stays on in both LP1 and LP2, so should be suitable for
> this use-case. It would make the code slightly more complex but using a
> single scratch register for multiple purposes sounds brittle and easy to
> break (as evidenced by the offending commit).
> 
> Otherwise it would seem that PMC_SCRATCH40 is only used to store EMC
> configuration data across LP0 suspend/resume, so I wouldn't think it'd
> cause problems if we used that instead of PMC_SCRATCH41 to store the
> "resettable" state.
> 

No. Usually the scratch registers for EMC config data are setup once by the
bootloader and never touched by the kernel after that. So I would not
recommend reusing those registers for different purposes.

Cheers,

Peter.
