Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752361AbaL3KRA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 05:17:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35286 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752073AbaL3KQ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 05:16:59 -0500
Message-ID: <54A27B8D.8040404@redhat.com>
Date: Tue, 30 Dec 2014 11:16:45 +0100
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org
CC: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Andrew Duggan <aduggan@synaptics.com>,
        Christopher Heiny <cheiny@synaptics.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: synaptics - switch ForcePad detection to PNP IDs
References: <20141229225113.GA13847@dtor-ws>
In-Reply-To: <20141229225113.GA13847@dtor-ws>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Looks good to me:

Acked-by: Hans de Goede <hdegoede@redhat.com>

Regards,

Hans

On 29-12-14 23:51, Dmitry Torokhov wrote:
> According to Synaptics devices with ForcePads use SYN300D and SYN3014 as
> PNP IDs, so let's switch from DMI-bases detection scheme to PNP-based
> one, which should be more reliable.
>
> Suggested-by: Hans de Goede <hdegoede@redhat.com>
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> ---
>   drivers/input/mouse/synaptics.c | 35 ++++++++++++++---------------------
>   drivers/input/mouse/synaptics.h |  1 +
>   2 files changed, 15 insertions(+), 21 deletions(-)
>
> diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
> index d2ab13a..f04017e 100644
> --- a/drivers/input/mouse/synaptics.c
> +++ b/drivers/input/mouse/synaptics.c
> @@ -190,6 +190,13 @@ static const char * const topbuttonpad_pnp_ids[] = {
>   	NULL
>   };
>
> +/* This list has been kindly provided by Synaptics. */
> +static const char * const forcepad_pnp_ids[] = {
> +	"SYN300D",
> +	"SYN3014",
> +	NULL
> +};
> +
>   /*****************************************************************************
>    *	Synaptics communications functions
>    ****************************************************************************/
> @@ -601,8 +608,6 @@ static void synaptics_parse_agm(const unsigned char buf[],
>   	}
>   }
>
> -static bool is_forcepad;
> -
>   static int synaptics_parse_hw_state(const unsigned char buf[],
>   				    struct synaptics_data *priv,
>   				    struct synaptics_hw_state *hw)
> @@ -632,7 +637,7 @@ static int synaptics_parse_hw_state(const unsigned char buf[],
>   		hw->left  = (buf[0] & 0x01) ? 1 : 0;
>   		hw->right = (buf[0] & 0x02) ? 1 : 0;
>
> -		if (is_forcepad) {
> +		if (priv->is_forcepad) {
>   			/*
>   			 * ForcePads, like Clickpads, use middle button
>   			 * bits to report primary button clicks.
> @@ -1307,29 +1312,11 @@ static const struct dmi_system_id __initconst cr48_dmi_table[] = {
>   	{ }
>   };
>
> -static const struct dmi_system_id forcepad_dmi_table[] __initconst = {
> -#if defined(CONFIG_DMI) && defined(CONFIG_X86)
> -	{
> -		.matches = {
> -			DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
> -			DMI_MATCH(DMI_PRODUCT_NAME, "HP EliteBook Folio 1040 G1"),
> -		},
> -	},
> -#endif
> -	{ }
> -};
> -
>   void __init synaptics_module_init(void)
>   {
>   	impaired_toshiba_kbc = dmi_check_system(toshiba_dmi_table);
>   	broken_olpc_ec = dmi_check_system(olpc_dmi_table);
>   	cr48_profile_sensor = dmi_check_system(cr48_dmi_table);
> -
> -	/*
> -	 * Unfortunately ForcePad capability is not exported over PS/2,
> -	 * so we have to resort to checking DMI.
> -	 */
> -	is_forcepad = dmi_check_system(forcepad_dmi_table);
>   }
>
>   static int __synaptics_init(struct psmouse *psmouse, bool absolute_mode)
> @@ -1364,6 +1351,12 @@ static int __synaptics_init(struct psmouse *psmouse, bool absolute_mode)
>   	if (SYN_ID_DISGEST_SUPPORTED(priv->identity))
>   		priv->disable_gesture = true;
>
> +	/*
> +	 * Unfortunately ForcePad capability is not exported over PS/2,
> +	 * so we have to resort to checking PNP IDs.
> +	 */
> +	priv->is_forcepad = psmouse_matches_pnp_id(psmouse, forcepad_pnp_ids);
> +
>   	if (synaptics_set_mode(psmouse)) {
>   		psmouse_err(psmouse, "Unable to initialize device.\n");
>   		goto init_fail;
> diff --git a/drivers/input/mouse/synaptics.h b/drivers/input/mouse/synaptics.h
> index aedc329..fb3838c 100644
> --- a/drivers/input/mouse/synaptics.h
> +++ b/drivers/input/mouse/synaptics.h
> @@ -168,6 +168,7 @@ struct synaptics_data {
>   	unsigned long				press_start;
>   	bool					press;
>   	bool					report_press;
> +	bool					is_forcepad;
>   };
>
>   void synaptics_module_init(void);
>
