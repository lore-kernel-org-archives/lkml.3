Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751533AbaLDFen (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 00:34:43 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:50625 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbaLDFem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 00:34:42 -0500
Date: Wed, 3 Dec 2014 00:43:21 -0800
From: Darren Hart <dvhart@infradead.org>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org, libsmbios-devel@lists.us.dell.com,
        Srinivas_G_Gowda@dell.com, Michael_E_Brown@dell.com,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>
Subject: Re: [PATCH v2] platform: x86: dell-laptop: Add support for keyboard
 backlight
Message-ID: <20141203084319.GA52608@vmdeb7>
References: <1415967813-7223-1-git-send-email-pali.rohar@gmail.com>
 <1416754245-15550-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1416754245-15550-1-git-send-email-pali.rohar@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 23, 2014 at 03:50:45PM +0100, Pali Rohár wrote:
> This patch adds support for configuring keyboard backlight settings on supported
> Dell laptops. It exports kernel leds interface and uses Dell SMBIOS tokens or
> keyboard class interface.
> 
> With this patch it is possible to set:
> * keyboard backlight level
> * timeout after which will be backlight automatically turned off
> * input activity triggers (keyboard, touchpad, mouse) which enable backlight
> * ambient light settings
> 
> Settings are exported via sysfs:
> /sys/class/leds/dell::kbd_backlight/
> 
> Code is based on newly released documentation by Dell in libsmbios project.
> 

Hi Pali,

I would really like to see this broken up. Possibly adding levels and timeouts
as separate patches for example. It is quite difficult to review this all at
once in a reasonable amount of time.

During this review I caught a few more CodingStyle violations, and raised some
questions about the timeout and levels mechanisms.

> @@ -62,6 +71,10 @@ struct calling_interface_structure {
>  
>  struct quirk_entry {
>  	u8 touchpad_led;
> +
> +	/* Ordered list of timeouts expressed in seconds.
> +	 * The list must end with -1 */

Despite other instances in this file, block comments are documented in
CodingStyle as:

/*
 * Comment text.
 */

The old ones should be cleaned up eventually, but new ones need to be done
according to CodingStyle. Please correct throughout.

> +	int kbd_timeouts[];
>  };
>  
>  static struct quirk_entry *quirks;
> @@ -76,6 +89,10 @@ static int __init dmi_matched(const struct dmi_system_id *dmi)
>  	return 1;
>  }
>  
> +static struct quirk_entry quirk_dell_xps13_9333 = {
> +	.kbd_timeouts = { 0, 5, 15, 60, 5*60, 15*60, -1 },

Where did these values come from? Were they documented in the libsmbios project?
Can you provide a URL to that? These really should be described by the firmware,
but if they aren't, nothing we can do about it.

> @@ -790,6 +842,964 @@ static void touchpad_led_exit(void)
>  	led_classdev_unregister(&touchpad_led);
>  }
>  
> +/* Derived from information in smbios-keyboard-ctl:

See block comment above.

> +
> + cbClass 4
> + cbSelect 11
> + Keyboar illumination

Keyboard

> + cbArg1 determines the function to be performed
> +
> + cbArg1 0x0 = Get Feature Information
> +  cbRES1         Standard return codes (0, -1, -2)
> +  cbRES2, word0  Bitmap of user-selectable modes
> +     bit 0     Always off (All systems)
> +     bit 1     Always on (Travis ATG, Siberia)
> +     bit 2     Auto: ALS-based On; ALS-based Off (Travis ATG)
> +     bit 3     Auto: ALS- and input-activity-based On; input-activity based Off
> +     bit 4     Auto: Input-activity-based On; input-activity based Off
> +     bit 5     Auto: Input-activity-based On (illumination level 25%); input-activity based Off
> +     bit 6     Auto: Input-activity-based On (illumination level 50%); input-activity based Off
> +     bit 7     Auto: Input-activity-based On (illumination level 75%); input-activity based Off
> +     bit 8     Auto: Input-activity-based On (illumination level 100%); input-activity based Off
> +     bits 9-15 Reserved for future use
> +  cbRES2, byte2  Reserved for future use
> +  cbRES2, byte3  Keyboard illumination type
> +     0         Reserved
> +     1         Tasklight
> +     2         Backlight
> +     3-255     Reserved for future use
> +  cbRES3, byte0  Supported auto keyboard illumination trigger bitmap.
> +     bit 0     Any keystroke
> +     bit 1     Touchpad activity
> +     bit 2     Pointing stick
> +     bit 3     Any mouse
> +     bits 4-7  Reserved for future use
> +  cbRES3, byte1  Supported timeout unit bitmap
> +     bit 0     Seconds
> +     bit 1     Minutes
> +     bit 2     Hours
> +     bit 3     Days
> +     bits 4-7  Reserved for future use
> +  cbRES3, byte2  Number of keyboard light brightness levels
> +  cbRES4, byte0  Maximum acceptable seconds value (0 if seconds not supported).
> +  cbRES4, byte1  Maximum acceptable minutes value (0 if minutes not supported).
> +  cbRES4, byte2  Maximum acceptable hours value (0 if hours not supported).
> +  cbRES4, byte3  Maxiomum acceptable days value (0 if days not supported)

Maximum             ^

This interface appears to define all possible values for the timeout between
cbRES3[1] and cbRES4[*]. Why is the kbd_timeouts[] array a quirk with fixed
values? It seems it could indeed be dynamically determined.

> +
> +struct kbd_info {
> +	u16 modes;
> +	u8 type;
> +	u8 triggers;
> +	u8 levels;
> +	u8 seconds;
> +	u8 minutes;
> +	u8 hours;
> +	u8 days;
> +};
> +
> +
> +static u8 kbd_mode_levels[16];
> +static int kbd_mode_levels_count;

I'm confused by these. How are they different from kbd_info.levels?

We seem to check the latter first and fall back to these if that is 0.... why?

> +static int kbd_get_info(struct kbd_info *info)
> +{
> +	u8 units;
> +	int ret;
> +
> +	get_buffer();
> +
> +	buffer->input[0] = 0x0;
> +	dell_send_request(buffer, 4, 11);
> +	ret = buffer->output[0];
> +
> +	if (ret) {
> +		ret = dell_smi_error(ret);
> +		goto out;
> +	}
> +
> +	info->modes = buffer->output[1] & 0xFFFF;
> +	info->type = (buffer->output[1] >> 24) & 0xFF;
> +	info->triggers = buffer->output[2] & 0xFF;
> +	units = (buffer->output[2] >> 8) & 0xFF;
> +	info->levels = (buffer->output[2] >> 16) & 0xFF;
> +
> +	if (units & BIT(0))
> +		info->seconds = (buffer->output[3] >> 0) & 0xFF;
> +	if (units & BIT(1))
> +		info->minutes = (buffer->output[3] >> 8) & 0xFF;
> +	if (units & BIT(2))
> +		info->hours = (buffer->output[3] >> 16) & 0xFF;
> +	if (units & BIT(3))
> +		info->days = (buffer->output[3] >> 24) & 0xFF;
> +
> +out:

Please indent gotos by one space. This improves diffs context by not treating the goto label
like a function.

> +	release_buffer();
> +	return ret;
> +}
> +
> +static unsigned int kbd_get_max_level(void)
> +{
> +	if (kbd_info.levels != 0)
> +		return kbd_info.levels;
> +	if (kbd_mode_levels_count > 0)
> +		return kbd_mode_levels_count - 1;

Here for example. In what scenario does this happen?

> +	return 0;
> +}
> +



> +static inline int kbd_init_info(void)
> +{
> +	struct kbd_state state;
> +	int ret;
> +	int i;
> +
> +	ret = kbd_get_info(&kbd_info);
> +	if (ret)
> +		return ret;
> +
> +	kbd_get_state(&state);
> +
> +	/* NOTE: timeout value is stored in 6 bits so max value is 63 */
> +	if (kbd_info.seconds > 63)
> +		kbd_info.seconds = 63;
> +	if (kbd_info.minutes > 63)
> +		kbd_info.minutes = 63;
> +	if (kbd_info.hours > 63)
> +		kbd_info.hours = 63;
> +	if (kbd_info.days > 63)
> +		kbd_info.days = 63;
> +
> +	/* NOTE: On tested machines ON mode did not work and caused
> +	 *       problems (turned backlight off) so do not use it
> +	 */
> +	kbd_info.modes &= ~BIT(KBD_MODE_BIT_ON);
> +
> +	kbd_previous_level = kbd_get_level(&state);
> +	kbd_previous_mode_bit = state.mode_bit;
> +
> +	if (kbd_previous_level == 0 && kbd_get_max_level() != 0)
> +		kbd_previous_level = 1;
> +
> +	if (kbd_previous_mode_bit == KBD_MODE_BIT_OFF) {
> +		kbd_previous_mode_bit =
> +			ffs(kbd_info.modes & ~BIT(KBD_MODE_BIT_OFF));
> +		if (kbd_previous_mode_bit != 0)
> +			kbd_previous_mode_bit--;
> +	}
> +
> +	if (kbd_info.modes & (BIT(KBD_MODE_BIT_ALS) |
> +			      BIT(KBD_MODE_BIT_TRIGGER_ALS)))
> +		kbd_als_supported = true;
> +
> +	if (kbd_info.modes & (
> +	    BIT(KBD_MODE_BIT_TRIGGER_ALS) | BIT(KBD_MODE_BIT_TRIGGER) |
> +	    BIT(KBD_MODE_BIT_TRIGGER_25) | BIT(KBD_MODE_BIT_TRIGGER_50) |
> +	    BIT(KBD_MODE_BIT_TRIGGER_75) | BIT(KBD_MODE_BIT_TRIGGER_100)
> +	   ))
> +		kbd_triggers_supported = true;
> +
> +	for (i = 0; i < 16; ++i)

Doesn't this only apply to bits 5-8? Why not just loop through those?

for (i = KBD_MODE_BIT_TRIGGER_25; i <= KBD_MODE_BIT_TRIGGER_100)

The level_mode_bit check becomes unecessary.

> +		if (kbd_is_level_mode_bit(i) && (BIT(i) & kbd_info.modes))
> +			kbd_mode_levels[1+kbd_mode_levels_count++] = i;

One space around operators like + please.

What is kbd_mode_levels[0] reserved for? The current level? Isn't that what
kbd_state.level is for?

> +
> +	if (kbd_mode_levels_count > 0) {
> +		for (i = 0; i < 16; ++i) {

If 0-4 don't apply here, why loop through them? Should we just set levels[0] to
0 if it isn't one of 5-8?

If bits 9-16 are reserved, it seems it would be best to avoid checking for them
as they might return a false positive, and we'd be setting kbd_mode_levels to an
undefined value.

> +			if (BIT(i) & kbd_info.modes) {
> +				kbd_mode_levels[0] = i;
> +				break;
> +			}
> +		}
> +		kbd_mode_levels_count++;
> +	}
> +
> +	return 0;
-- 
Darren Hart
Intel Open Source Technology Center
