Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682AbaJYTmi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 15:42:38 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:42262 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246AbaJYTmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 15:42:36 -0400
Date: Sat, 25 Oct 2014 10:37:33 +0200
From: Johan Hovold <johan@kernel.org>
To: Romain Perier <romain.perier@gmail.com>
Cc: Johan Hovold <johan@kernel.org>, devicetree <devicetree@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Grant Likely <grant.likely@linaro.org>, robh <robh@kernel.org>,
        mark.rutland@arm.com, linux-pm@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>, Lee Jones <lee.jones@linaro.org>,
        Felipe Balbi <balbi@ti.com>
Subject: Re: [RFC v3 PATCH 1/5] of: Add standard property for poweroff
 capability
Message-ID: <20141025083733.GG19377@localhost>
References: <1413268273-15151-1-git-send-email-romain.perier@gmail.com>
 <20141023095339.GC6641@localhost>
 <CABgxDoLcnzaAYuDMB3x=EdNrY=8mwjceVVCpfXUYBURVm44ZVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABgxDoLcnzaAYuDMB3x=EdNrY=8mwjceVVCpfXUYBURVm44ZVQ@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+CC: Felipe ]

On Sat, Oct 25, 2014 at 09:28:36AM +0200, Romain Perier wrote:
> Hi Johan,
> 
> If that's still possible to do these changes, I am opened to suggestions.

Before v3.18 comes out, we can always change it with a follow-up patch.

> 2014-10-23 11:53 GMT+02:00 Johan Hovold <johan@kernel.org>:
> > [ +CC: Guenter, Lee, linux-pm ]
> >
> > On Tue, Oct 14, 2014 at 06:31:09AM +0000, Romain Perier wrote:
> >> Several drivers create their own devicetree property when they register
> >> poweroff capabilities. This is for example the case for mfd, regulator
> >> or power drivers which define "vendor,system-power-controller" property.
> >> This patch adds support for a standard property "poweroff-source"
> >
> > Shouldn't this property really be called "power-off-source" or even
> > "power-off-controller"?
> >
> > The power-off handler call-chain infrastructure is about to be merged
> > and will be using power[-_ ]off (i.e. not "poweroff") consistently (at
> > least in its interface).
> 
> "poweroff" or "power-off", I don't care. If people prefer "power-off",
> choose this name :)

Let's try to stick to power off (and power_off) then.

> > Furthermore, isn't "controller" as in "power-off-controller" more
> > appropriate than "source" in this case? We have wake-up sources, which
> > might appear analogous, but that really isn't the same thing.
> 
> As I said, the idea with "power-off-source" (or "poweroff-source",
> that's not the point here) is to mark the device as able to poweroff
> the system, like "wakeup-source" which marks the device as able to
> wakeup the system.
> This is why I chose this name, because it is quite similar to wakeup
> property except that it is for handling power, so it did make sense to
> me.
> 
> The question is: what is the advantage of the suffix "controller"
> compared to "source" ?

Yeah, I figured you had been inspired by the "wakeup-source" property.

The problem is that "source" tends to be used for inputs, for example,
wake-up source, interrupt source, entropy source, etc. Something that is
outside of the control of the OS. Contrary to for instance an output
which turns the system-power off.

> > I now this has already been merged to the regulator tree, but there's
> > still still time to fix this.
> >
> >> which marks the device as able to shutdown the system.
> >>
> >> Signed-off-by: Romain Perier <romain.perier@gmail.com>
> >> ---
> >>  include/linux/of.h | 11 +++++++++++
> >>  1 file changed, 11 insertions(+)
> >>
> >> diff --git a/include/linux/of.h b/include/linux/of.h
> >> index 6545e7a..27b3ba1 100644
> >> --- a/include/linux/of.h
> >> +++ b/include/linux/of.h
> >> @@ -866,4 +866,15 @@ static inline int of_changeset_update_property(struct of_changeset *ocs,
> >>  /* CONFIG_OF_RESOLVE api */
> >>  extern int of_resolve_phandles(struct device_node *tree);
> >>
> >> +/**
> >> + * of_system_has_poweroff_source - Tells if poweroff-source is found for device_node
> >> + * @np: Pointer to the given device_node
> >> + *
> >> + * return true if present false otherwise
> >> + */
> >> +static inline bool of_system_has_poweroff_source(const struct device_node *np)
> >
> > Why "system_has"? Shouldn't this be of_is_power_off_source (controller)?
> 
> Note that the current custom vendor properties contain "system-" as prefix ;)

Yes, but you dropped it. ;)

And it's not the system that has the property (e.g. "poweroff-source"),
it's the node (or the device it describes).
 
> we have several possibilities:
> - of_system_has_power_off_source()
> - of_has_power_off_source()
> 
> We should either to use "has" or "is" as prefix because that's a
> predicate function.
> I would prefer "has" since it refers to a property inside a node :
> this node "has" the corresponding property, so "is" is not a good
> candidate.

The boolean property in question describes a feature of the node
(device). Say the feature would be redness and call the property "red".
You would then generally ask whether the node *is red*, rather than
whether it has (the property) red (or has redness).

I'm actually inclined to just sticking to the current name
"system-power-controller" and just drop the vendor prefixes. Perhaps
your helper function can be used to parse both versions (i.e. with or
without a vendor prefix) as we will still need to support both.

I suggest you call that helper function

	of_is_system_power_controller(node)

or alternatively

	of_is_power_off_controller(node)

if that property name is preferred.

Note also that in at least one case (rtc-omap, patches in mm, see [1])
the property describes that the RTC is used to control an external PMIC,
which both allows us to power off the system *and* power back on again
on subsequent RTC alarms. This seems to suggest that the more generic
"system-power-controller" property name should be preferred.

Thanks,
Johan

[1] https://lkml.org/lkml/2014/10/21/631
