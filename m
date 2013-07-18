Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755621Ab3GRHZX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 03:25:23 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:15717 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753Ab3GRHZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 03:25:21 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/6qXjGKX1/O+ALUGmYNqU8
Date: Thu, 18 Jul 2013 00:25:16 -0700
From: Tony Lindgren <tony@atomide.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linus.walleij@linaro.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/4] pinctrl: Add support for additional dynamic states
Message-ID: <20130718072034.GO7656@atomide.com>
References: <20130716090310.5541.36777.stgit@localhost>
 <20130716090536.5541.36289.stgit@localhost>
 <51E70953.1000601@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E70953.1000601@wwwdotorg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Stephen Warren <swarren@wwwdotorg.org> [130717 14:21]:
> On 07/16/2013 03:05 AM, Tony Lindgren wrote:
> > To toggle dynamic states, let's add the optional active state in
> > addition to the static default state. Then if the optional active
> > state is defined, we can require that idle and sleep states cover
> > the same pingroups as the active state.
> > 
> > Then let's add pinctrl_check_dynamic() and pinctrl_select_dynamic()
> > to use instead of pinctrl_select() to avoid breaking existing users.
> > 
> > With pinctrl_check_dynamic() we can check that idle and sleep states
> > match the active state for pingroups during init, and don't need to
> > do it during runtime.
> > 
> > Then with the states pre-validated, pinctrl_select_dynamic() can
> > just toggle between the dynamic states without extra checks.
> > 
> > Note that pinctr_select_state() still has valid use cases, such as
> > changing states when the pins can be shared between two drivers
> > and don't necessarily cover the same pingroups. For dynamic runtime
> > toggling of pin states, we should eventually always use just
> > pinctrl_select_dynamic().
> 
> > diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
> 
> > @@ -887,6 +887,8 @@ static void pinctrl_free(struct pinctrl *p, bool inlist)
> >  		list_for_each_entry_safe(setting, n2, &state->settings, node) {
> >  			pinctrl_free_setting(state == p->state[PINCTRL_STATIC],
> >  					     setting);
> > +			pinctrl_free_setting(state == p->state[PINCTRL_DYNAMIC],
> > +					     setting);
> 
> This will cause pinmux_free_setting() or pinconf_free_setting() to be
> called twice on the setting object. Right now they don't do anything,
> but if they start to kfree() some dynamically-allocated data that's
> stored within the setting, that'll cause problems. I would suggest a
> loop body something more like:
> 
> bool disable_setting = state == XXX || state == YYY;
> pinctrl_free_setting(disable_setting, setting);

OK good point, I'll check it.
 
> > +int pinctrl_check_dynamic(struct device *dev, struct pinctrl_state *st1,
> > +			  struct pinctrl_state *st2)
> > +{
> > +	struct pinctrl_setting *s1, *s2;
> > +
> > +	list_for_each_entry(s1, &st1->settings, node) {
> ...
> > +		list_for_each_entry(s2, &st2->settings, node) {
> ...
> > +			if (pctldev1 != pctldev2) {
> > +				dev_dbg(dev, "pctldev must be the same for states\n");
> > +				return -EINVAL;
> > +			}
> 
> I don't think we should require that; it's perfectly legal at the moment
> for some device's pinctrl configuration to include settings from
> multiple different pin controllers.

Yes that's fine for pinctrl_select(), but let's not do that for
runtime muxing.

Here we want to do a one-time check during init to make  sure that
if active_state is defined, then the idle_state and sleep_state
must match active_state for pins.

This way we can avoid checking things over and over again during
runtime like pinctrl_select() is currently doing.
 
> > +			for (i = 0; i < num_pins1; i++) {
> > +				int pin1 = pins1[i];
> > +
> > +				for (j = 0; j < num_pins2; j++) {
> > +					int pin2 = pins2[j];
> > +
> > +					if (pin1 == pin2) {
> > +						found++;
> > +						break;
> > +					}
> > +				}
> > +			}
> > +
> > +			if (found != num_pins1) {
> 
> I guess this make sure that every entry in the dynamic state is in the
> state state, but not vice-versa; the static state can affect more stuff
> than the dynamic state?
> 
> If so, shouldn't that check be if (found != num_pins2)?

The check is that idle_state and sleep_state pins must match the
active_state pins. This is intentionally different from the current
pinctrl_select() logic.
 
> > +int pinctrl_select_dynamic(struct pinctrl *p, struct pinctrl_state *state)
> 
> The body of this function is rather duplicated with pinctrl_select().

Well we may be able to make pinctrl_select() use this too, I'll take
a look. Initially I'd rather not start messing with pinctrl_select()
to avoid breaking existing users.
 
> > @@ -1241,7 +1371,13 @@ static int pinctrl_pm_select_state(struct device *dev, struct pinctrl_state *sta
> >  		return 0;
> >  	if (IS_ERR(state))
> >  		return 0; /* No such state */
> > -	ret = pinctrl_select_state(pins->p, state);
> > +
> > +	/* Configured for proper dynamic muxing? */
> 
> I don't think "proper" is correct here; it's just fine not to have any
> dynamic configuration.

Right, that's the most common case. I'll drop the "proper".
 
> > +	if (!IS_ERR(dev->pins->active_state))
> > +		ret = pinctrl_select_dynamic(pins->p, state);
> > +	else
> > +		ret = pinctrl_select_state(pins->p, state);
> 
> Hmmm. I'm not quite sure this is right... Surely this function should
> just do nothing if the dynamic states aren't defined? The system should
> just, and only, be in the "default" state and never do anything else.

This keeps the existing behaviour. We should be able to drop the
call to pinctrl_select_state() here after the existing use in
drivers has been fixed.
 
> Looking back at patch 1, I see the are
> pinctrl_pm_select_{default,sleep,idle}_state(). Shouldn't that list be
> active/sleep/idle, since I assume default is that "static" state, and
> the other three are the "dynamic" states?

Yes after this patch set that's the case, then we have default
plus optional active. Then if active is defined, sleep and idle
pins must match active. 
 
> > +static int pinctrl_pm_check_state(struct device *dev,
> > +				  struct pinctrl_state *state)
> 
> Naming this pinctrl_pm_is_state_error() or pinctrl_pm_is_state_ok()
> might give more clue what its return value is expected to be.

OK yeah I did not like that naming either, pinctrl_pm_is_state_error()
sounds good to me.

Regards,

Tony
