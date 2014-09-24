Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291AbaIXPsf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 11:48:35 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:40178 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751088AbaIXPse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 11:48:34 -0400
Date: Wed, 24 Sep 2014 16:48:02 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Sudeep Holla <Sudeep.Holla@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH v2] clocksource: arm_arch_timer: discard unavailable
 timers correctly
Message-ID: <20140924154802.GK5729@leverpostej>
References: <1410911445-19067-1-git-send-email-sudeep.holla@arm.com>
 <1410982774-4724-1-git-send-email-sudeep.holla@arm.com>
 <5422E05F.4070405@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5422E05F.4070405@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 04:16:47PM +0100, Sudeep Holla wrote:
> Hi Mark,
> 
> On 17/09/14 20:39, Sudeep Holla wrote:
> > Currently we wait until both cp15 and mem timers are probed if we
> > have both timer device nodes present in the device tree without
> > checking if the device is actually available. If one of the timer
> > device node present is disabled, the system locks up on the boot
> > as no timer gets registered.
> >
> > This patch adds the check for the availablity of the timer device
> > so that we unavailable timers are discarded correctly. It also adds
> > the missing of_node_put.
> >
> > Cc: Stephen Boyd <sboyd@codeaurora.org>
> > Cc: Mark Rutland <mark.rutland@arm.com>
> 
> If your are fine with this, can I ask Daniel you pick this up ?

While I'd prefer to see the cp15 and mmio timer driver pulled apart,
that's not going to happen at any point soon. For the moment, this is
far better than the current state of affairs. So:

Acked-by: Mark Rutland <mark.rutland@arm.com>

Mark.

> 
> Regards,
> Sudeep
> 
> > Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
> > ---
> >   drivers/clocksource/arm_arch_timer.c | 20 ++++++++++++++++----
> >   1 file changed, 16 insertions(+), 4 deletions(-)
> >
> > Changes v1->v2:
> > 	- Added missing of_node_put in the original code
> > 	- Updated the commit log as suggested
> >
> > diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
> > index 5163ec13429d..7e267e3990ab 100644
> > --- a/drivers/clocksource/arm_arch_timer.c
> > +++ b/drivers/clocksource/arm_arch_timer.c
> > @@ -616,17 +616,29 @@ static const struct of_device_id arch_timer_mem_of_match[] __initconst = {
> >   	{},
> >   };
> >
> > +static bool __init
> > +arch_timer_probed(int type, const struct of_device_id *matches)
> > +{
> > +	struct device_node *dn;
> > +	bool probed = false;
> > +
> > +	dn = of_find_matching_node(NULL, matches);
> > +	if (dn && of_device_is_available(dn) && (arch_timers_present & type))
> > +		probed = true;
> > +	of_node_put(dn);
> > +
> > +	return probed;
> > +}
> > +
> >   static void __init arch_timer_common_init(void)
> >   {
> >   	unsigned mask = ARCH_CP15_TIMER | ARCH_MEM_TIMER;
> >
> >   	/* Wait until both nodes are probed if we have two timers */
> >   	if ((arch_timers_present & mask) != mask) {
> > -		if (of_find_matching_node(NULL, arch_timer_mem_of_match) &&
> > -				!(arch_timers_present & ARCH_MEM_TIMER))
> > +		if (!arch_timer_probed(ARCH_MEM_TIMER, arch_timer_mem_of_match))
> >   			return;
> > -		if (of_find_matching_node(NULL, arch_timer_of_match) &&
> > -				!(arch_timers_present & ARCH_CP15_TIMER))
> > +		if (!arch_timer_probed(ARCH_CP15_TIMER, arch_timer_of_match))
> >   			return;
> >   	}
> >
> >
