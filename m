Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752341AbbAGOU0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 09:20:26 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:8365 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbbAGOUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 09:20:24 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 07 Jan 2015 06:13:06 -0800
Date: Wed, 7 Jan 2015 22:19:52 +0800
From: Vince Hsu <vinceh@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Thierry Reding <thierry.reding@gmail.com>, Lucas Stach <dev@lynxeye.de>,
        <swarren@wwwdotorg.org>, <gnurou@gmail.com>, <bskeggs@redhat.com>,
        <martin.peres@free.fr>, <seven@nimrod-online.com>,
        <samuel.pitoiset@gmail.com>, <nouveau@lists.freedesktop.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/11] ARM: tegra: add function to control the GPU rail
 clamp
Message-ID: <20150107141938.GA7392@nvidia.com>
References: <1419331204-26679-1-git-send-email-vinceh@nvidia.com>
 <1419331204-26679-2-git-send-email-vinceh@nvidia.com>
 <1419426990.2179.7.camel@lynxeye.de> <549B7638.2010405@nvidia.com>
 <20150105150932.GG12010@ulmo.nvidia.com>
 <20150107101900.GP10073@tbergstrom-lnx.Nvidia.com>
 <54AD0F37.5080609@nvidia.com>
 <20150107141254.GS10073@tbergstrom-lnx.Nvidia.com>
MIME-Version: 1.0
In-Reply-To: <20150107141254.GS10073@tbergstrom-lnx.Nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04:12:54PM Jan 07, Peter De Schrijver wrote:
> On Wed, Jan 07, 2015 at 06:49:27PM +0800, Vince Hsu wrote:
> > 
> > On 01/07/2015 06:19 PM, Peter De Schrijver wrote:
> > >On Mon, Jan 05, 2015 at 04:09:33PM +0100, Thierry Reding wrote:
> > >>* PGP Signed by an unknown key
> > >>
> > >>On Thu, Dec 25, 2014 at 10:28:08AM +0800, Vince Hsu wrote:
> > >>>On 12/24/2014 09:16 PM, Lucas Stach wrote:
> > >>>>Am Dienstag, den 23.12.2014, 18:39 +0800 schrieb Vince Hsu:
> > >>>>>The Tegra124 and later Tegra SoCs have a sepatate rail gating register
> > >>>>>to enable/disable the clamp. The original function
> > >>>>>tegra_powergate_remove_clamping() is not sufficient for the enable
> > >>>>>function. So add a new function which is dedicated to the GPU rail
> > >>>>>gating. Also don't refer to the powergate ID since the GPU ID makes no
> > >>>>>sense here.
> > >>>>>
> > >>>>>Signed-off-by: Vince Hsu <vinceh@nvidia.com>
> > >>>>To be honest I don't see the point of this patch.
> > >>>>You are bloating the PMC interface by introducing another exported
> > >>>>function that does nothing different than what the current function
> > >>>>already does.
> > >>>>
> > >>>>If you need a way to assert the clamp I would have expected you to
> > >>>>introduce a common function to do this for all power partitions.
> > >>>I thought about adding an tegra_powergate_assert_clamping(), but that
> > >>>doesn't make sense to all the power partitions except GPU. Note the
> > >>>difference in TRM. Any suggestion for the common function?
> > >>I don't think extending the powergate API is useful at this point. We've
> > >>long had an open TODO item to replace this with a generic API. I did
> > >>some prototyping a while ago to use generic power domains for this, that
> > >>way all the details and dependencies between the partitions could be
> > >>properly modeled.
> > >>
> > >>Can you take a look at my staging/powergate branch here:
> > >>
> > >>	https://github.com/thierryreding/linux/commits/staging/powergate
> > >>
> > >>and see if you can use that instead? The idea is to completely hide the
> > >>details of power partitions from drivers and use runtime PM instead.
> > >>
> > >>Also adding Peter whom I had discussed this with earlier. Can we finally
> > >>get this converted? I'd rather not keep complicating this custom API to
> > >>avoid making the conversion even more difficult.
> > >Conceptually I fully agree that we should use runtime PM and powerdomains.
> > >However I don't think the implementation you mentioned is correct. The resets
> > >of all modules in a domain need to be asserted and the memory clients need to
> > >be flushed. All this needs to be done with module clocks enabled (resets are
> > >synchronous).  Then all module clocks need to be disabled and then the
> > >partition can be powergated. After ungating, the module resets need to be
> > >deasserted and the FLUSH bit cleared with clocks enabled.
> > Yeah. I plan to have the information of all the clock client of the
> > partitions and
> > the memory clients be defined statically in c source, e.g. pmc-tegra124.c.
> > All modules can declare which domain they belong to in DT. One domain can
> > be really power gated only when no module is awake. Note the clock
> > clients of
> > one domain might not equal to the clocks of the module. The reset is
> > not either.
> > So I don't get the clock and reset from module. How do you think?
> > 
> 
> I think it's indeed better to have a direct reference to the required clocks
> to powergate/ungate a domain. As you said, there is no easy way to derive the
> required clocks from the DT module declarations. My suggestion would be to
> have powerdomain definitions in DT and for each domain have references to
> the required clocks and resets.
> 
And specify the dependencies between domains in DT?

Thanks,
Vince

