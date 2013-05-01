Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751893Ab3EAQtW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 12:49:22 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:60443 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050Ab3EAQtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 12:49:15 -0400
Date: Wed, 1 May 2013 11:49:05 -0500
From: Nishanth Menon <nm@ti.com>
To: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Rob Landley <rob@landley.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Shawn Guo <shawn.guo@linaro.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH 1/2] PM / OPP: add support to specify phandle of another
 node for OPP
Message-ID: <20130501164905.GA21171@kahuna>
References: <1367406679-21603-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
 <1367406679-21603-2-git-send-email-Sudeep.KarkadaNagesha@arm.com>
 <20130501144120.GA17385@kahuna>
 <518142BD.2000804@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <518142BD.2000804@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17:28-20130501, Sudeep KarkadaNagesha wrote:
> On 01/05/13 15:41, Nishanth Menon wrote:
> > On 12:11-20130501, Sudeep.KarkadaNagesha@arm.com wrote:
> >> From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
> >>
> >> If more than one similar devices share the same OPPs, currently we
> >> need to replicate the OPP entries in all the nodes.
> > Nice, thanks.
> >>
> >> Few drivers like cpufreq depend on physical cpu0 node to specify the
> > cpufreq-cpu0?
> Yes when I originally wrote this patch cpufreq-cpu0 was using cpu0 node.
> But later sometimes it was changed to parse all the nodes.
giving an explicit example like cpufreq-cpu0 might be helpful - but we
may have more cases like this else where with co-processors (devfreq
world).
[...]
> >> +a SoC or in a single cluster on a SoC, then we need to avoid replicating the
> >> +OPPs in all the nodes. We can specify the phandle of the node with which the
> >> +current node shares the operating points instead.
> >> +
> >> +Examples:
> >> +Consider an SMP with 4 CPUs all sharing the same OPPs.
> > We might want to descr
> I could not get what exactly you mean by 'descr', do you mean more
> descriptive ? If so, what exactly you would like to add ?
Arrgh.. Typical of me to forget my reply thread and leave it dangling
when someone interrupts me :( Sigh.. Apologies about that.

I intended the following:
An example of bL might be 4 A15s and 3 a7s? A15s have different
frequencies Vs A7s?
The example below could easily be covered by cpufreq-cpu0 - so an actual
usage illustrated will help.
> 
> >> +
> >> +cpu0: cpu@0 {
> >> +	compatible = "arm,cortex-a9";
> >> +	reg = <0>;
> >> +	next-level-cache = <&L2>;
> >> +	operating-points = <
> >> +		/* kHz    uV */
> >> +		792000  1100000
> >> +		396000  950000
> >> +		198000  850000
> >> +	>;
> >> +};
> >> +
> >> +cpu1: cpu@1 {
> >> +	compatible = "arm,cortex-a9";
> >> +	reg = <1>;
> >> +	next-level-cache = <&L2>;
> >> +	operating-points = <&cpu0>;
> >> +};
[...]
> 
> >>  {
> >> +	struct device_opp *dev_opp = NULL;
> > dev_opp is not used until patch #2 - please introduce it in that patch.
> Correct it was meant to be in patch#2, will move in next version
I'd hold on to the rev 2 until we are clear that we have precedence for
allowing parameters to have two different formats.

I might optionally go with introducing a new parameter to indicate
phandle lists similar to pinctrl.. Just a thought. There may be other
usage for the same in addition to resolving the scenario you mention.
Trivial example:
cpu0 can take three different operating-point sets ->
default - 300MHz, 600MHz, 800MHz
regular performance - 300MHz, 600MHz, 800MHz, 1GHz
performance - 300MHz, 600MHz, 800MHz, 1GHz, 1.7GHz

Choice is made which set it picks up.
making operating-points as a phandle by itself is questionable as it
does not really represent an hardware device - but options for
operation.

-- 
Regards,
Nishanth Menon
