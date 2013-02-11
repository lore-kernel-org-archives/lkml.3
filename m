Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932284Ab3BKUyA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 15:54:00 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:47588 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759671Ab3BKUx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 15:53:59 -0500
Message-ID: <51195A63.7080706@wwwdotorg.org>
Date: Mon, 11 Feb 2013 13:53:55 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@stericsson.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Laurent Meunier <laurent.meunier@st.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] pinctrl/pinconfig: add debug interface
References: <1360527070-18430-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1360527070-18430-1-git-send-email-linus.walleij@stericsson.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10/2013 01:11 PM, Linus Walleij wrote:
> From: Laurent Meunier <laurent.meunier@st.com>
> 
> This update adds a debugfs interface to modify a pin configuration
> for a given state in the pinctrl map. This allows to modify the
> configuration for a non-active state, typically sleep state.
> This configuration is not applied right away, but only when the state
> will be entered.
> 
> This solution is mandated for us by HW validation: in order
> to test and verify several pin configurations during sleep without
> recompiling the software.

I never understood why HW engineers can't just recompile the kernel.
Besides, it's just a device tree change these days - no recompile even
required, right?

> diff --git a/drivers/pinctrl/pinconf.c b/drivers/pinctrl/pinconf.c

To be worth including, hadn't this feature also better also allow
editing of pin mux settings too, and even addition/removal of entries,
so some more core file would be a better place?

> +/* 32bit read/write ressources */
> +#define MAX_NAME_LEN 16
> +char dbg_pinname[MAX_NAME_LEN]; /* shared: name of the state of the pin*/
> +char dbg_state_name[MAX_NAME_LEN]; /* shared: state of the pin*/
> +static u32 dbg_config; /* shared: config to be read/set for the pin & state*/

Rather than setting pin name, state name, and config separately,
wouldn't it be better to accept a single write() with all those
parameters contained in it at once, so no persistent state was required.
Say something like:

modify configs_pin devicename state pinname newvalue

That would allow "add", "delete" to be implemented in addition to modify
later if desired.

> +static int pinconf_dbg_pinname_write(struct file *file,
> +	const char __user *user_buf, size_t count, loff_t *ppos)
> +{
> +	int err;
> +
> +	if (count > MAX_NAME_LEN)
> +		return -EINVAL;
> +
> +	err = sscanf(user_buf, "%15s", dbg_pinname);

That %15 had better somehow be related to MAX_NAME_LEN.

I'd suggest making MAX_NAME_LEN 15, and the variable declarations above
use MAX_NAME_LEN + 1, so that MAX_NAME_LEN can be used as part of the
scanf parameter here.

> +/**
> + * pinconf_dbg_config_write() - overwrite the pinctrl config in thepinctrl
> + * map, of a pin/state pair based on pinname and state that have been
> + * selected with the debugfs entries pinconf-name and pinconf-state
> + */
> +static int pinconf_dbg_config_write(struct file *file,
> +	const char __user *user_buf, size_t count, loff_t *ppos)
> +{
> +	int err;
> +	unsigned long config;
> +	struct pinctrl_maps *maps_node;
> +	struct pinctrl_map const *map;
> +	int i, j;
> +
> +	err = kstrtoul_from_user(user_buf, count, 0, &config);
> +
> +	if (err)
> +		return err;
> +
> +	dbg_config = config;

That assumes that pin config values are a plain u32. While this is
commonly true in existing pinctrl drivers, it certainly isn't something
that the pinctrl core mandates; that's the whole point of
dt_node_to_map() for example, to allow the individual pinctrl drivers to
use whatever type (scalar, pointer-to-struct, ...) they want to
represent their config values.

> +
> +	mutex_lock(&pinctrl_mutex);
> +
> +	/* Parse the pinctrl map and look for the selected pin/state */
> +	for_each_maps(maps_node, i, map) {
> +		if (map->type != PIN_MAP_TYPE_CONFIGS_PIN)
> +			continue;
> +
> +		if (strncmp(map->name, dbg_state_name, MAX_NAME_LEN) > 0)
> +			continue;

What about the device name; this changes that state in every device's
map table entry.

> +
> +		/*  we found the right pin / state, so overwrite config */
> +		for (j = 0; j < map->data.configs.num_configs; j++) {
> +			if (strncmp(map->data.configs.group_or_pin, dbg_pinname,
> +						MAX_NAME_LEN) == 0)

Why compare this inside the per-config loop;
map->data.configs.group_or_pin is something "global" to the entire
struct, and not specific to each configs[] entry.

> +				map->data.configs.configs[j] = dbg_config;

Given that dbg_config is written to by this function, then used by this
function, why even make it a global? The only other use is
pinconf_dbg_config_print(), which can also make it a local variable.

Overall, I'm not convinced of the utility of this patch upstream. Sorry.
