Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987AbaIIHo3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 03:44:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21465 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755571AbaIIHo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 03:44:27 -0400
Message-ID: <540EAFD1.2040307@redhat.com>
Date: Tue, 09 Sep 2014 09:44:17 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org
CC: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Christopher Heiny <cheiny@synaptics.com>, linux-kernel@vger.kernel.org,
        Andrew Duggan <aduggan@synaptics.com>
Subject: Re: [PATCH] Input: synaptics - add support for ForcePads
References: <20140908165520.GA35051@core.coreip.homeip.net>
In-Reply-To: <20140908165520.GA35051@core.coreip.homeip.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 09/08/2014 06:55 PM, Dmitry Torokhov wrote:
> ForcePads are found on HP EliteBook 1040 laptops. They lack any kind of
> physical buttons, instead they generate primary button click when user
> presses somewhat hard on the surface of the touchpad. Unfortunately they
> also report primary button click whenever there are 2 or more contacts
> on the pad, messing up all multi-finger gestures (2-finger scrolling,
> multi-finger tapping, etc). To cope with this behavior we introduce a
> delay (currently 50 msecs) in reporting primary press in case more
> contacts appear.
> 
> For now we are using DMI matching to detect ForcePads, hopefully we'll
> be able to figure a better way down the road.

What about using the pnp-id, in my experience with the recent lenovo
laptops that tends to be more reliable.

Christopher, Andrew (added to the CC), can one of you tell us if there
is a capability bit to detect this, and if not can you perhaps provide
a list of pnp-ids of devices which behave like this ?

> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> ---
>  drivers/input/mouse/synaptics.c | 80 ++++++++++++++++++++++++++++++++---------
>  drivers/input/mouse/synaptics.h |  5 +++
>  2 files changed, 69 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
> index e8573c6..5de1bb6 100644
> --- a/drivers/input/mouse/synaptics.c
> +++ b/drivers/input/mouse/synaptics.c
> @@ -618,6 +618,8 @@ static void synaptics_parse_agm(const unsigned char buf[],
>  	priv->agm_pending = true;
>  }
>  
> +static bool is_forcepad;
> +
>  static int synaptics_parse_hw_state(const unsigned char buf[],
>  				    struct synaptics_data *priv,
>  				    struct synaptics_hw_state *hw)
> @@ -629,10 +631,58 @@ static int synaptics_parse_hw_state(const unsigned char buf[],
>  			 ((buf[0] & 0x04) >> 1) |
>  			 ((buf[3] & 0x04) >> 2));
>  
> +		if ((SYN_CAP_ADV_GESTURE(priv->ext_cap_0c) ||
> +			SYN_CAP_IMAGE_SENSOR(priv->ext_cap_0c)) &&
> +		    hw->w == 2) {
> +			synaptics_parse_agm(buf, priv, hw);
> +			return 1;
> +		}
> +
> +		hw->x = (((buf[3] & 0x10) << 8) |
> +			 ((buf[1] & 0x0f) << 8) |
> +			 buf[4]);
> +		hw->y = (((buf[3] & 0x20) << 7) |
> +			 ((buf[1] & 0xf0) << 4) |
> +			 buf[5]);
> +		hw->z = buf[2];
> +
>  		hw->left  = (buf[0] & 0x01) ? 1 : 0;
>  		hw->right = (buf[0] & 0x02) ? 1 : 0;
>  

Moving this up means that on clickpads the button will no longer
be checked + set for hw->w == 2 packets. That seems like an unintended
side effect. If this is intended then this should probably be in its own
patch.

> -		if (SYN_CAP_CLICKPAD(priv->ext_cap_0c)) {
> +		if (is_forcepad) {
> +			/* XXX is there a proper capability bit for this? */
> +			/*
> +			 * ForcePads, like Clickpads, use middle button
> +			 * bits to report primary button clicks.
> +			 * Unfortunately they report primary button not only
> +			 * when user presses on the pad above certain threshold,
> +			 * but also when there are more than one finger on the
> +			 * touchpad, which interferes with out multi-finger
> +			 * gestures.
> +			 */
> +			if (hw->z == 0) {
> +				/* No contacts */
> +				priv->press = priv->report_press = false;
> +			} else if (hw->w >= 4 && ((buf[0] ^ buf[3]) & 0x01)) {
> +				/*
> +				 * Single-finger touch with pressure above
> +				 * the threshold.
> +				 */
> +				if  (!priv->press) {
> +					priv->press_start = jiffies;
> +					priv->press = true;
> +				} else if (time_after(jiffies,
> +						priv->press_start +
> +							msecs_to_jiffies(50))) {
> +					priv->report_press = true;
> +				}

You're not setting a timer here, instead relying on there to be further events,
that is probably ok, but maybe put a comment to that extent here ?

> +			} else {
> +				priv->press = false;
> +			}
> +
> +			hw->left = priv->report_press;
> +
> +		} else if (SYN_CAP_CLICKPAD(priv->ext_cap_0c)) {
>  			/*
>  			 * Clickpad's button is transmitted as middle button,
>  			 * however, since it is primary button, we will report
> @@ -651,21 +701,6 @@ static int synaptics_parse_hw_state(const unsigned char buf[],
>  			hw->down = ((buf[0] ^ buf[3]) & 0x02) ? 1 : 0;
>  		}
>  
> -		if ((SYN_CAP_ADV_GESTURE(priv->ext_cap_0c) ||
> -			SYN_CAP_IMAGE_SENSOR(priv->ext_cap_0c)) &&
> -		    hw->w == 2) {
> -			synaptics_parse_agm(buf, priv, hw);
> -			return 1;
> -		}
> -
> -		hw->x = (((buf[3] & 0x10) << 8) |
> -			 ((buf[1] & 0x0f) << 8) |
> -			 buf[4]);
> -		hw->y = (((buf[3] & 0x20) << 7) |
> -			 ((buf[1] & 0xf0) << 4) |
> -			 buf[5]);
> -		hw->z = buf[2];
> -
>  		if (SYN_CAP_MULTI_BUTTON_NO(priv->ext_cap) &&
>  		    ((buf[0] ^ buf[3]) & 0x02)) {
>  			switch (SYN_CAP_MULTI_BUTTON_NO(priv->ext_cap) & ~0x01) {
> @@ -1642,11 +1677,24 @@ static const struct dmi_system_id __initconst cr48_dmi_table[] = {
>  	{ }
>  };
>  
> +static const struct dmi_system_id forcepad_dmi_table[] __initconst = {
> +#if defined(CONFIG_DMI) && defined(CONFIG_X86)
> +	{
> +		.matches = {
> +			DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "HP EliteBook Folio 1040 G1"),
> +		},
> +	},
> +#endif
> +	{ }
> +};
> +
>  void __init synaptics_module_init(void)
>  {
>  	impaired_toshiba_kbc = dmi_check_system(toshiba_dmi_table);
>  	broken_olpc_ec = dmi_check_system(olpc_dmi_table);
>  	cr48_profile_sensor = dmi_check_system(cr48_dmi_table);
> +	is_forcepad = dmi_check_system(forcepad_dmi_table);
>  }
>  
>  static int __synaptics_init(struct psmouse *psmouse, bool absolute_mode)
> diff --git a/drivers/input/mouse/synaptics.h b/drivers/input/mouse/synaptics.h
> index e594af0..adc80c9 100644
> --- a/drivers/input/mouse/synaptics.h
> +++ b/drivers/input/mouse/synaptics.h
> @@ -177,6 +177,11 @@ struct synaptics_data {
>  	 */
>  	struct synaptics_hw_state agm;
>  	bool agm_pending;			/* new AGM packet received */
> +
> +	/* ForcePad handling */
> +	unsigned long				press_start;
> +	bool					press;
> +	bool					report_press;
>  };
>  
>  void synaptics_module_init(void);
> 

Regards,

Hans
