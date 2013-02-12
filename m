Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933175Ab3BLMyd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 07:54:33 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:49767 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933099Ab3BLMyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 07:54:31 -0500
MIME-Version: 1.0
In-Reply-To: <51195A63.7080706@wwwdotorg.org>
References: <1360527070-18430-1-git-send-email-linus.walleij@stericsson.com>
	<51195A63.7080706@wwwdotorg.org>
Date: Tue, 12 Feb 2013 13:54:31 +0100
Message-ID: <CACRpkdZu0+maCE2GjuZcQPZPZbw=Fz0DUHYY8FXPdZEH0PeViQ@mail.gmail.com>
Subject: Re: [PATCH] pinctrl/pinconfig: add debug interface
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Laurent Meunier <laurent.meunier@st.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2013 at 9:53 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 02/10/2013 01:11 PM, Linus Walleij wrote:
>> From: Laurent Meunier <laurent.meunier@st.com>
>>
>> This update adds a debugfs interface to modify a pin configuration
>> for a given state in the pinctrl map. This allows to modify the
>> configuration for a non-active state, typically sleep state.
>> This configuration is not applied right away, but only when the state
>> will be entered.
>>
>> This solution is mandated for us by HW validation: in order
>> to test and verify several pin configurations during sleep without
>> recompiling the software.
>
> I never understood why HW engineers can't just recompile the kernel.
> Besides, it's just a device tree change these days - no recompile even
> required, right?

Oh well, they have their habits, like testing a range of different
HW configs after each other, say you have a reference design
with a nailed down mux+config, but you want to loop over a few
possible configurations (not for that hardware, but applicable for
other designs) and make sure they actually work too. The number
of recompiles and reboots soon goes through the roof.

So the HW people hack the kernel a lot to do this kind of things,
and then someone get to maintain their hacks. So this is a step
in the direction of letting them have a generic tool to do the trick.

>> diff --git a/drivers/pinctrl/pinconf.c b/drivers/pinctrl/pinconf.c
>
> To be worth including, hadn't this feature also better also allow
> editing of pin mux settings too, and even addition/removal of entries,
> so some more core file would be a better place?

I think it'll be orthogonal: one file for the pinconf stuff (something
like in this patch) and then another patch for the pinmux
stuff. I'm trying to keep these two separate.

>> +/* 32bit read/write ressources */
>> +#define MAX_NAME_LEN 16
>> +char dbg_pinname[MAX_NAME_LEN]; /* shared: name of the state of the pin*/
>> +char dbg_state_name[MAX_NAME_LEN]; /* shared: state of the pin*/
>> +static u32 dbg_config; /* shared: config to be read/set for the pin & state*/
>
> Rather than setting pin name, state name, and config separately,
> wouldn't it be better to accept a single write() with all those
> parameters contained in it at once, so no persistent state was required.
> Say something like:
>
> modify configs_pin devicename state pinname newvalue
>
> That would allow "add", "delete" to be implemented in addition to modify
> later if desired.

Hm. Sounds useful.

Laurent what do you say about this?

Could you augment the patch like that?

>> +static int pinconf_dbg_pinname_write(struct file *file,
>> +     const char __user *user_buf, size_t count, loff_t *ppos)
>> +{
>> +     int err;
>> +
>> +     if (count > MAX_NAME_LEN)
>> +             return -EINVAL;
>> +
>> +     err = sscanf(user_buf, "%15s", dbg_pinname);
>
> That %15 had better somehow be related to MAX_NAME_LEN.
>
> I'd suggest making MAX_NAME_LEN 15, and the variable declarations above
> use MAX_NAME_LEN + 1, so that MAX_NAME_LEN can be used as part of the
> scanf parameter here.

OK -> Laurent.

>> +/**
>> + * pinconf_dbg_config_write() - overwrite the pinctrl config in thepinctrl
>> + * map, of a pin/state pair based on pinname and state that have been
>> + * selected with the debugfs entries pinconf-name and pinconf-state
>> + */
>> +static int pinconf_dbg_config_write(struct file *file,
>> +     const char __user *user_buf, size_t count, loff_t *ppos)
>> +{
>> +     int err;
>> +     unsigned long config;
>> +     struct pinctrl_maps *maps_node;
>> +     struct pinctrl_map const *map;
>> +     int i, j;
>> +
>> +     err = kstrtoul_from_user(user_buf, count, 0, &config);
>> +
>> +     if (err)
>> +             return err;
>> +
>> +     dbg_config = config;
>
> That assumes that pin config values are a plain u32. While this is
> commonly true in existing pinctrl drivers, it certainly isn't something
> that the pinctrl core mandates;

So there is this unsigned long and it has a value.

The interface should support altering that unsigned long not
really caring for what it contains. It seems pretty straight-forward
to me.

Of course, if this unsigned long is a pointer, this is just a
fantastic recipe for shooting oneself in the foot, but again
debugfs is just one big gun aimed at ones foot anyway, that's
the whole point of debugfs.

> that's the whole point of
> dt_node_to_map() for example, to allow the individual pinctrl drivers to
> use whatever type (scalar, pointer-to-struct, ...) they want to
> represent their config values.

Yes. But it is an unsigned long, and we support altering it.

And the whole point of debugfs is to do crazy stuff like that.

>> +     mutex_lock(&pinctrl_mutex);
>> +
>> +     /* Parse the pinctrl map and look for the selected pin/state */
>> +     for_each_maps(maps_node, i, map) {
>> +             if (map->type != PIN_MAP_TYPE_CONFIGS_PIN)
>> +                     continue;
>> +
>> +             if (strncmp(map->name, dbg_state_name, MAX_NAME_LEN) > 0)
>> +                     continue;
>
> What about the device name; this changes that state in every device's
> map table entry.

OK.

Laurent, can you augment this to also take the device name into
account? (Shouldn't be a big deal.)

>> +             /*  we found the right pin / state, so overwrite config */
>> +             for (j = 0; j < map->data.configs.num_configs; j++) {
>> +                     if (strncmp(map->data.configs.group_or_pin, dbg_pinname,
>> +                                             MAX_NAME_LEN) == 0)
>
> Why compare this inside the per-config loop;
> map->data.configs.group_or_pin is something "global" to the entire
> struct, and not specific to each configs[] entry.

OK Laurent can you fix this?

>> +                             map->data.configs.configs[j] = dbg_config;
>
> Given that dbg_config is written to by this function, then used by this
> function, why even make it a global? The only other use is
> pinconf_dbg_config_print(), which can also make it a local variable.

OK Laurent can you fix this?

> Overall, I'm not convinced of the utility of this patch upstream. Sorry.

The utility is that it reduces the amount of code needed to be kept
out-of-tree, and it provides a nice gun for shooting oneself in the
foot using debugfs.

Yours,
Linus Walleij
