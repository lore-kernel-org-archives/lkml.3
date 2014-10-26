Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751610AbaJZO6T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 10:58:19 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:54709 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbaJZO6R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 10:58:17 -0400
MIME-Version: 1.0
In-Reply-To: <1788971.BnbvZ8bisu@diego>
References: <1413268273-15151-1-git-send-email-romain.perier@gmail.com>
	<CABgxDoLcnzaAYuDMB3x=EdNrY=8mwjceVVCpfXUYBURVm44ZVQ@mail.gmail.com>
	<20141025083733.GG19377@localhost>
	<1788971.BnbvZ8bisu@diego>
Date: Sun, 26 Oct 2014 15:58:16 +0100
Message-ID: <CABgxDoLsH_eaSeEHdktCkJYzjEgS+w+kkM6AXuzMW12TSom4LQ@mail.gmail.com>
Subject: Re: [RFC v3 PATCH 1/5] of: Add standard property for poweroff capability
From: Romain Perier <romain.perier@gmail.com>
To: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>
Cc: Johan Hovold <johan@kernel.org>, devicetree <devicetree@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>, robh <robh@kernel.org>,
        mark.rutland@arm.com, linux-pm@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>, Lee Jones <lee.jones@linaro.org>,
        Felipe Balbi <balbi@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johan,

You convinced me. I will add an helper function
"of_is_system_power_controller(node)" which is compatible with both
properties: with or without the vendor prefix (until everything switch
to the new one).
In this case , we can adapt all drivers without break compatibility
and in few months if we plan to remove this compability we will just
need to modify this helper function.

Heiko: will do, thanks your help. I will use the regulator tree as
based repository and then send fixes to Mark.

Romain



2014-10-26 12:53 GMT+01:00 Heiko Stübner <heiko@sntech.de>:
> Am Samstag, 25. Oktober 2014, 10:37:33 schrieb Johan Hovold:
>> [+CC: Felipe ]
>>
>> On Sat, Oct 25, 2014 at 09:28:36AM +0200, Romain Perier wrote:
>> > Hi Johan,
>> >
>> > If that's still possible to do these changes, I am opened to suggestions.
>>
>> Before v3.18 comes out, we can always change it with a follow-up patch.
>>
>> > 2014-10-23 11:53 GMT+02:00 Johan Hovold <johan@kernel.org>:
>> > > [ +CC: Guenter, Lee, linux-pm ]
>> > >
>> > > On Tue, Oct 14, 2014 at 06:31:09AM +0000, Romain Perier wrote:
>> > >> Several drivers create their own devicetree property when they register
>> > >> poweroff capabilities. This is for example the case for mfd, regulator
>> > >> or power drivers which define "vendor,system-power-controller"
>> > >> property.
>> > >> This patch adds support for a standard property "poweroff-source"
>> > >
>> > > Shouldn't this property really be called "power-off-source" or even
>> > > "power-off-controller"?
>> > >
>> > > The power-off handler call-chain infrastructure is about to be merged
>> > > and will be using power[-_ ]off (i.e. not "poweroff") consistently (at
>> > > least in its interface).
>> >
>> > "poweroff" or "power-off", I don't care. If people prefer "power-off",
>> > choose this name :)
>>
>> Let's try to stick to power off (and power_off) then.
>>
>> > > Furthermore, isn't "controller" as in "power-off-controller" more
>> > > appropriate than "source" in this case? We have wake-up sources, which
>> > > might appear analogous, but that really isn't the same thing.
>> >
>> > As I said, the idea with "power-off-source" (or "poweroff-source",
>> > that's not the point here) is to mark the device as able to poweroff
>> > the system, like "wakeup-source" which marks the device as able to
>> > wakeup the system.
>> > This is why I chose this name, because it is quite similar to wakeup
>> > property except that it is for handling power, so it did make sense to
>> > me.
>> >
>> > The question is: what is the advantage of the suffix "controller"
>> > compared to "source" ?
>>
>> Yeah, I figured you had been inspired by the "wakeup-source" property.
>>
>> The problem is that "source" tends to be used for inputs, for example,
>> wake-up source, interrupt source, entropy source, etc. Something that is
>> outside of the control of the OS. Contrary to for instance an output
>> which turns the system-power off.
>>
>> > > I now this has already been merged to the regulator tree, but there's
>> > > still still time to fix this.
>> > >
>> > >> which marks the device as able to shutdown the system.
>> > >>
>> > >> Signed-off-by: Romain Perier <romain.perier@gmail.com>
>> > >> ---
>> > >>
>> > >>  include/linux/of.h | 11 +++++++++++
>> > >>  1 file changed, 11 insertions(+)
>> > >>
>> > >> diff --git a/include/linux/of.h b/include/linux/of.h
>> > >> index 6545e7a..27b3ba1 100644
>> > >> --- a/include/linux/of.h
>> > >> +++ b/include/linux/of.h
>> > >> @@ -866,4 +866,15 @@ static inline int
>> > >> of_changeset_update_property(struct of_changeset *ocs,> >>
>> > >>  /* CONFIG_OF_RESOLVE api */
>> > >>  extern int of_resolve_phandles(struct device_node *tree);
>> > >>
>> > >> +/**
>> > >> + * of_system_has_poweroff_source - Tells if poweroff-source is found
>> > >> for device_node + * @np: Pointer to the given device_node
>> > >> + *
>> > >> + * return true if present false otherwise
>> > >> + */
>> > >> +static inline bool of_system_has_poweroff_source(const struct
>> > >> device_node *np)> >
>> > > Why "system_has"? Shouldn't this be of_is_power_off_source (controller)?
>> >
>> > Note that the current custom vendor properties contain "system-" as prefix
>> > ;)
>> Yes, but you dropped it. ;)
>>
>> And it's not the system that has the property (e.g. "poweroff-source"),
>> it's the node (or the device it describes).
>>
>> > we have several possibilities:
>> > - of_system_has_power_off_source()
>> > - of_has_power_off_source()
>> >
>> > We should either to use "has" or "is" as prefix because that's a
>> > predicate function.
>> > I would prefer "has" since it refers to a property inside a node :
>> > this node "has" the corresponding property, so "is" is not a good
>> > candidate.
>>
>> The boolean property in question describes a feature of the node
>> (device). Say the feature would be redness and call the property "red".
>> You would then generally ask whether the node *is red*, rather than
>> whether it has (the property) red (or has redness).
>>
>> I'm actually inclined to just sticking to the current name
>> "system-power-controller" and just drop the vendor prefixes. Perhaps
>> your helper function can be used to parse both versions (i.e. with or
>> without a vendor prefix) as we will still need to support both.
>>
>> I suggest you call that helper function
>>
>>       of_is_system_power_controller(node)
>>
>> or alternatively
>>
>>       of_is_power_off_controller(node)
>>
>> if that property name is preferred.
>>
>> Note also that in at least one case (rtc-omap, patches in mm, see [1])
>> the property describes that the RTC is used to control an external PMIC,
>> which both allows us to power off the system *and* power back on again
>> on subsequent RTC alarms. This seems to suggest that the more generic
>> "system-power-controller" property name should be preferred.
>
> just as sidenote, I'll hold off on applying patch3 (the dts change) then.
>
> Romain, after you two (and maybe Mark) agree on the final naming of the
> property and function you'd need to
> - send a followup patch against Marks tree, implementing the changes
> - a new patch adding the property to the Radxa board
>
>
> Heiko
