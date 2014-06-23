Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034AbaFWKOs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 06:14:48 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:4597 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748AbaFWKOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 06:14:45 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 23 Jun 2014 03:05:03 -0700
Date: Mon, 23 Jun 2014 13:14:42 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Thierry Reding <thierry.reding@gmail.com>,
        Mikko Perttunen <mperttunen@nvidia.com>,
        "tj@kernel.org" <tj@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: [PATCH 6/9] ARM: tegra: Export tegra_powergate_power_on
Message-ID: <20140623101441.GU3407@tbergstrom-lnx.Nvidia.com>
References: <1401881559-18469-1-git-send-email-mperttunen@nvidia.com>
 <1401881559-18469-7-git-send-email-mperttunen@nvidia.com>
 <539F691E.5030204@wwwdotorg.org>
 <20140617121313.GE18816@ulmo>
 <20140617140146.GH3407@tbergstrom-lnx.Nvidia.com>
 <20140617215119.GC24743@mithrandir>
 <20140618121806.GJ3407@tbergstrom-lnx.Nvidia.com>
 <53A1B252.1030204@wwwdotorg.org>
 <20140619080234.GK3407@tbergstrom-lnx.Nvidia.com>
 <53A3096B.1040409@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <53A3096B.1040409@wwwdotorg.org>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 06:01:47PM +0200, Stephen Warren wrote:
> On 06/19/2014 02:02 AM, Peter De Schrijver wrote:
> > On Wed, Jun 18, 2014 at 05:37:54PM +0200, Stephen Warren wrote:
> >> On 06/18/2014 06:18 AM, Peter De Schrijver wrote:
> >>> On Tue, Jun 17, 2014 at 11:51:20PM +0200, Thierry Reding wrote:
> >>>> * PGP Signed by an unknown key
> >>>>
> >>>> On Tue, Jun 17, 2014 at 05:01:46PM +0300, Peter De Schrijver wrote:
> >>>>> On Tue, Jun 17, 2014 at 02:13:15PM +0200, Thierry Reding wrote:
> >>>>>>> Old Signed by an unknown key
> >>>>>>
> >>>>>> On Mon, Jun 16, 2014 at 04:01:02PM -0600, Stephen Warren wrote:
> >>>>>>> On 06/04/2014 05:32 AM, Mikko Perttunen wrote:
> >>>>>>>> This symbol needs to be exported to power on rails without using
> >>>>>>>> tegra_powergate_sequence_power_up. tegra_powergate_sequence_power_up
> >>>>>>>> cannot be used in situations where the driver wants to handle clocking
> >>>>>>>> by itself.
> >>>>>>>
> >>>>>>> Thierry, are you OK with this change?
> >>>>>>
> >>>>>> I would've preferred tegra_powergate_sequence_power_up() to be used
> >>>>>
> >>>>> I don't think the current tegra_powergate_sequence_power_up() API is very well
> >>>>> defined though. I don't think the clocks and resets required by the sequence
> >>>>> should be provided by the driver. For one, there can be several clocks and
> >>>>> resets that need to be controlled for a single domain.
> >>>>
> >>>> Do you have any suggestions for what the API should look like? Even if
> >>>> we plan to move to some different API, I think there's some advantage in
> >>>> using it consistently if for no other reason than to make it easier to
> >>>> replace occurrences later on.
> >>>>
> >>>
> >>> I think the API should only have the domain ID as input so:
> >>>
> >>> int tegra_powerdomain_on(int id) 
> >>>
> >>> /*
> >>>  * Prerequisites: domain is off
> >>>  * Result: domain is on, clocks of the modules in the domain are off, modules are in reset
> >>>  */
> >>>
> >>> int tegra_powerdomain_off(int id)
> >>>
> >>> /*
> >>>  * Prerequisites: all clocks of the modules in the domain are off
> >>>  * result: domain is off
> >>>  */
> >>
> >> That doesn't make sense; the PMC doesn't have access to the clock and
> >> reset IDs - that's why the API requires them to be passed in.
> >>
> > 
> > We should make driver look them up by name then. It doesn't make sense to
> > move this knowledge to the drivers as there can be several modules in 1
> > powerdomain. So every driver would then need to have access to all clock
> > and reset IDs of the modules of the domain?
> 
> Having the drivers know the clocks, resets, and power domains that
> affect their HW module seems perfectly reasonable.
> 

Yes, but the problem is that you also need clocks and reset of other modules
in the same domain to safely control the domain's status. Eg: the ISPs, VI and
CSI share a domain. VI and CSI are useable without ISP and the ISP lacks
public documentation. So it's not unlikely a VI and CSI driver will upstreamed
someday which means we would need to control the domain and therefore would
need to tell that driver about the ISPs clocks and resets even though the
driver doesn't know anything about the ISP hw otherwise.

> Do we actually have any case where unrelated modules are in the same
> power domain /and/ there's some need for those drivers to manipulate the
> power domain?
> 

According to the TRM, the reset state of the power domains is undefined. While
that seems unlikely, I do think the kernel should not assume any domain is on
apart from the obvious ones (like the CPU domain it is running on),

> BTW, any objections here should have been raised when the initial API
> design for powergating was created. Now that we have the current API,
> which in turn has driven the DT bindings for at least some HW modules,
> we're stuck with it due to DT ABIness. Well, perhaps we can introduce
> something new, but we'll always have to support the old way, so there's
> little point.

I don't think the bindings need to be changed at all as long as the PMC driver
can parse the relevant DT nodes to get the clock and reset information.

Cheers,

Peter.
