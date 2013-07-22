Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049Ab3GVWyl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 18:54:41 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:50094 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387Ab3GVWyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 18:54:40 -0400
MIME-Version: 1.0
In-Reply-To: <20130718151507.30990.67174.stgit@localhost>
References: <20130718151213.30990.45828.stgit@localhost>
	<20130718151507.30990.67174.stgit@localhost>
Date: Tue, 23 Jul 2013 00:54:38 +0200
Message-ID: <CACRpkdY5-OFN4YQywPj06jkf493BhwgJGMEnmKmbovTh+co2Yg@mail.gmail.com>
Subject: Re: [PATCH 2/4] pinctrl: Allow pinctrl to have multiple active states
From: Linus Walleij <linus.walleij@linaro.org>
To: Tony Lindgren <tony@atomide.com>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, Linux-OMAP <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 18, 2013 at 5:15 PM, Tony Lindgren <tony@atomide.com> wrote:

> It's quite common that we need to dynamically change some pins for a
> device for runtime PM, or toggle a pin between rx and tx. Changing all

What does "change" mean above?

Please reword to "remux" if that is what is meant.

> the pins for a device is not efficient way of doing it.
>
> So let's allow setting up multiple active states for pinctrl.

Do you mean multiple default states?

I have a hard time understanding so please help me out :-/

> Currently
> we only need PINCTRL_STATIC and PINCTRL_DYNAMIC, where PINCTRL_STATIC
> covers the current default pins, and PINCTRL_DYNAMIC holds the dynamic
> pins that need to be toggled.

Toggled when?

When changing state to another one? Any other state? Or back to
this state? Sorry not following ... this needs to be more verbose.

>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Grygorii Strashko <grygorii.strashko@ti.com>
> Cc: Stephen Warren <swarren@wwwdotorg.org>
> Signed-off-by: Tony Lindgren <tony@atomide.com>
> ---
>  drivers/pinctrl/core.c |   18 ++++++++++--------
>  drivers/pinctrl/core.h |   10 ++++++++--
>  2 files changed, 18 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
> index a97b717..c9b709b 100644
> --- a/drivers/pinctrl/core.c
> +++ b/drivers/pinctrl/core.c
> @@ -885,7 +885,8 @@ static void pinctrl_free(struct pinctrl *p, bool inlist)
>         mutex_lock(&pinctrl_list_mutex);
>         list_for_each_entry_safe(state, n1, &p->states, node) {
>                 list_for_each_entry_safe(setting, n2, &state->settings, node) {
> -                       pinctrl_free_setting(state == p->state, setting);
> +                       pinctrl_free_setting(state == p->state[PINCTRL_STATIC],
> +                                            setting);
>                         list_del(&setting->node);
>                         kfree(setting);
>                 }
> @@ -955,13 +956,13 @@ EXPORT_SYMBOL_GPL(pinctrl_lookup_state);
>  int pinctrl_select_state(struct pinctrl *p, struct pinctrl_state *state)
>  {
>         struct pinctrl_setting *setting, *setting2;
> -       struct pinctrl_state *old_state = p->state;
> +       struct pinctrl_state *old_state = p->state[PINCTRL_STATIC];
>         int ret;
>
> -       if (p->state == state)
> +       if (old_state == state)
>                 return 0;
>
> -       if (p->state) {
> +       if (old_state) {
>                 /*
>                  * The set of groups with a mux configuration in the old state
>                  * may not be identical to the set of groups with a mux setting
> @@ -971,7 +972,7 @@ int pinctrl_select_state(struct pinctrl *p, struct pinctrl_state *state)
>                  * but not in the new state, this code puts that group into a
>                  * safe/disabled state.
>                  */
> -               list_for_each_entry(setting, &p->state->settings, node) {
> +               list_for_each_entry(setting, &old_state->settings, node) {
>                         bool found = false;
>                         if (setting->type != PIN_MAP_TYPE_MUX_GROUP)
>                                 continue;
> @@ -989,7 +990,7 @@ int pinctrl_select_state(struct pinctrl *p, struct pinctrl_state *state)
>                 }
>         }
>
> -       p->state = NULL;
> +       p->state[PINCTRL_STATIC] = NULL;
>
>         /* Apply all the settings for the new state */
>         list_for_each_entry(setting, &state->settings, node) {
> @@ -1011,7 +1012,7 @@ int pinctrl_select_state(struct pinctrl *p, struct pinctrl_state *state)
>                 }
>         }
>
> -       p->state = state;
> +       p->state[PINCTRL_STATIC] = state;
>
>         return 0;
>
> @@ -1492,7 +1493,8 @@ static int pinctrl_show(struct seq_file *s, void *what)
>         list_for_each_entry(p, &pinctrl_list, node) {
>                 seq_printf(s, "device: %s current state: %s\n",
>                            dev_name(p->dev),
> -                          p->state ? p->state->name : "none");
> +                          p->state[PINCTRL_STATIC] ?
> +                          p->state[PINCTRL_STATIC]->name : "none");
>
>                 list_for_each_entry(state, &p->states, node) {
>                         seq_printf(s, "  state: %s\n", state->name);
> diff --git a/drivers/pinctrl/core.h b/drivers/pinctrl/core.h
> index 75476b3..ac5a269 100644
> --- a/drivers/pinctrl/core.h
> +++ b/drivers/pinctrl/core.h
> @@ -53,12 +53,18 @@ struct pinctrl_dev {
>  #endif
>  };
>
> +enum pinctrl_states {
> +       PINCTRL_STATIC,
> +       PINCTRL_DYNAMIC,
> +       PINCTRL_NR_STATES,
> +};

This needs some very precise kerneldoc so it is chrystal clear what these
states are all about. "pinctrl_states" is not a good name for this enum,
please find some more precise name, because we have functions
with names like pinctrl_select_state() which is not related to this.

Is this substates or?

> +
>  /**
>   * struct pinctrl - per-device pin control state holder
>   * @node: global list node
>   * @dev: the device using this pin control handle
>   * @states: a list of states for this device
> - * @state: the current state
> + * @state: the current state(s)

How can more than one state be the current state? Sorry I don't get this.
This needs to be more precise I think.

>   * @dt_maps: the mapping table chunks dynamically parsed from device tree for
>   *     this device, if any
>   * @users: reference count
> @@ -67,7 +73,7 @@ struct pinctrl {
>         struct list_head node;
>         struct device *dev;
>         struct list_head states;
> -       struct pinctrl_state *state;
> +       struct pinctrl_state *state[PINCTRL_NR_STATES];
>         struct list_head dt_maps;
>         struct kref users;
>  };

Yours,
Linus Walleij
