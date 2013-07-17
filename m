Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757395Ab3GQVPG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 17:15:06 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:45597 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756151Ab3GQVPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 17:15:02 -0400
Message-ID: <51E70953.1000601@wwwdotorg.org>
Date: Wed, 17 Jul 2013 15:14:59 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: linus.walleij@linaro.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/4] pinctrl: Add support for additional dynamic states
References: <20130716090310.5541.36777.stgit@localhost> <20130716090536.5541.36289.stgit@localhost>
In-Reply-To: <20130716090536.5541.36289.stgit@localhost>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2013 03:05 AM, Tony Lindgren wrote:
> To toggle dynamic states, let's add the optional active state in
> addition to the static default state. Then if the optional active
> state is defined, we can require that idle and sleep states cover
> the same pingroups as the active state.
> 
> Then let's add pinctrl_check_dynamic() and pinctrl_select_dynamic()
> to use instead of pinctrl_select() to avoid breaking existing users.
> 
> With pinctrl_check_dynamic() we can check that idle and sleep states
> match the active state for pingroups during init, and don't need to
> do it during runtime.
> 
> Then with the states pre-validated, pinctrl_select_dynamic() can
> just toggle between the dynamic states without extra checks.
> 
> Note that pinctr_select_state() still has valid use cases, such as
> changing states when the pins can be shared between two drivers
> and don't necessarily cover the same pingroups. For dynamic runtime
> toggling of pin states, we should eventually always use just
> pinctrl_select_dynamic().

> diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c

> @@ -887,6 +887,8 @@ static void pinctrl_free(struct pinctrl *p, bool inlist)
>  		list_for_each_entry_safe(setting, n2, &state->settings, node) {
>  			pinctrl_free_setting(state == p->state[PINCTRL_STATIC],
>  					     setting);
> +			pinctrl_free_setting(state == p->state[PINCTRL_DYNAMIC],
> +					     setting);

This will cause pinmux_free_setting() or pinconf_free_setting() to be
called twice on the setting object. Right now they don't do anything,
but if they start to kfree() some dynamically-allocated data that's
stored within the setting, that'll cause problems. I would suggest a
loop body something more like:

bool disable_setting = state == XXX || state == YYY;
pinctrl_free_setting(disable_setting, setting);

> +int pinctrl_check_dynamic(struct device *dev, struct pinctrl_state *st1,
> +			  struct pinctrl_state *st2)
> +{
> +	struct pinctrl_setting *s1, *s2;
> +
> +	list_for_each_entry(s1, &st1->settings, node) {
...
> +		list_for_each_entry(s2, &st2->settings, node) {
...
> +			if (pctldev1 != pctldev2) {
> +				dev_dbg(dev, "pctldev must be the same for states\n");
> +				return -EINVAL;
> +			}

I don't think we should require that; it's perfectly legal at the moment
for some device's pinctrl configuration to include settings from
multiple different pin controllers.

> +			for (i = 0; i < num_pins1; i++) {
> +				int pin1 = pins1[i];
> +
> +				for (j = 0; j < num_pins2; j++) {
> +					int pin2 = pins2[j];
> +
> +					if (pin1 == pin2) {
> +						found++;
> +						break;
> +					}
> +				}
> +			}
> +
> +			if (found != num_pins1) {

I guess this make sure that every entry in the dynamic state is in the
state state, but not vice-versa; the static state can affect more stuff
than the dynamic state?

If so, shouldn't that check be if (found != num_pins2)?

> +int pinctrl_select_dynamic(struct pinctrl *p, struct pinctrl_state *state)

The body of this function is rather duplicated with pinctrl_select().

> @@ -1241,7 +1371,13 @@ static int pinctrl_pm_select_state(struct device *dev, struct pinctrl_state *sta
>  		return 0;
>  	if (IS_ERR(state))
>  		return 0; /* No such state */
> -	ret = pinctrl_select_state(pins->p, state);
> +
> +	/* Configured for proper dynamic muxing? */

I don't think "proper" is correct here; it's just fine not to have any
dynamic configuration.

> +	if (!IS_ERR(dev->pins->active_state))
> +		ret = pinctrl_select_dynamic(pins->p, state);
> +	else
> +		ret = pinctrl_select_state(pins->p, state);

Hmmm. I'm not quite sure this is right... Surely this function should
just do nothing if the dynamic states aren't defined? The system should
just, and only, be in the "default" state and never do anything else.

Looking back at patch 1, I see the are
pinctrl_pm_select_{default,sleep,idle}_state(). Shouldn't that list be
active/sleep/idle, since I assume default is that "static" state, and
the other three are the "dynamic" states?

> +static int pinctrl_pm_check_state(struct device *dev,
> +				  struct pinctrl_state *state)

Naming this pinctrl_pm_is_state_error() or pinctrl_pm_is_state_ok()
might give more clue what its return value is expected to be.
