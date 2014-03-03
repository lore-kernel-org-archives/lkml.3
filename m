Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297AbaCCLEp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 06:04:45 -0500
Received: from canardo.mork.no ([148.122.252.1]:46748 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753114AbaCCLEn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 06:04:43 -0500
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Shuduo Sang <shuduo.sang@canonical.com>
Cc: ibm-acpi-devel@lists.sourceforge.net, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, ibm-acpi@hmh.eng.br,
        matthew.garrett@nebula.com, platform-driver-x86@vger.kernel.org,
        bruce.ma@canonical.com
Subject: Re: [RFC PATCH] support Thinkpad X1 Carbon's adaptive keyboard
Organization: m
References: <53142D51.3010403@canonical.com>
Date: Mon, 03 Mar 2014 12:04:05 +0100
In-Reply-To: <53142D51.3010403@canonical.com> (Shuduo Sang's message of "Mon,
	03 Mar 2014 15:20:49 +0800")
Message-ID: <87mwh71r2y.fsf@nemi.mork.no>
User-Agent: Gnus/5.130009 (Ma Gnus v0.9) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shuduo Sang <shuduo.sang@canonical.com> writes:

> Hi all,
>
> We are working together with Lenovo to enable thinkpad X1 Carbon's
> fancy feature, Adaptive Keyboard[1] for Linux. Adaptive keyboard has
> five modes on Windows including Home mode, Web browser mode, Web
> conference mode, Function mode and Lay-flat mode. We enabled Home
> mode and Function mode currently. Will try to find out how to enable
> other modes later. Please review and comment attached patch.
>
> Thanks,
> Shuduo
>
> [1]:http://shop.lenovo.com/us/en/laptops/thinkpad/x-series/x1-carbon/#features
>
>
> From da9d43beaa23071558a8031950cc21cc93946ec6 Mon Sep 17 00:00:00 2001
> From: Shuduo Sang <sangshuduo@gmail.com>
> Date: Mon, 3 Mar 2014 14:29:32 +0800
> Subject: [PATCH] support thinkpad X1 Carbon's adaptive keyboard
>
> Thinkpad X1 Carbon's adaptive keyboard has five modes including Home
> mode, Web browser mode, Web conference mode, Function mode and Lay-flat
> mode. We support Home mode and Function mode currently.
>
> Signed-off-by: Bruce Ma <bruce.ma@canonical.com>
> Signed-off-by: Shuduo Sang <shuduo.sang@canonical.com>
> ---
>  drivers/platform/x86/thinkpad_acpi.c | 97
> ++++++++++++++++++++++++++++++++++++
>  1 file changed, 97 insertions(+)
>
> diff --git a/drivers/platform/x86/thinkpad_acpi.c
> b/drivers/platform/x86/thinkpad_acpi.c
> index defb6af..fcb738e 100644
> --- a/drivers/platform/x86/thinkpad_acpi.c
> +++ b/drivers/platform/x86/thinkpad_acpi.c
> @@ -3437,6 +3437,101 @@ err_exit:
>  	return (res < 0)? res : 1;
>  }
>
> +/* Thinkpad X1 Carbon support 5 modes including Home mode, Web browser
> + * mode, Web conference mode, Function mode and Lay-flat mode.
> + * We support Home mode and Function mode currently.
> + *
> + * Will consider support rest of modes in future.
> + *
> + */
> +enum ADAPTIVE_KEY_MODE {
> +	HOME_MODE,
> +	WEB_BROWSER_MODE,
> +	WEB_CONFERENCE_MODE,
> +	FUNCTION_MODE,
> +	LAYFLAT_MODE
> +};
> +
> +int adaptive_keyboard_modes[] = {
> +	HOME_MODE,
> +/*	WEB_BROWSER_MODE = 2,
> +	WEB_CONFERENCE_MODE = 3, */
> +	FUNCTION_MODE
> +};
> +
> +#define DFR_CHANGE_ROW			0x101
> +#define DFR_SHOW_QUICKVIEW_ROW		0x102
> +
> +/* press Fn key a while second, it will switch to Function Mode. Then
> + * release Fn key, previous mode be restored.
> + */
> +bool adaptive_keyboard_mode_is_saved;
> +int adaptive_keybarod_prev_mode;

speling:  s/keybarod/keyboard/

You need to change it where this variable is used below as well.

> +static int adaptive_keyboard_get_next_mode(int mode)
> +{
> +	int i;
> +	int max_mode = sizeof(adaptive_keyboard_modes)/sizeof(int) - 1;

ARRAY_SIZE


> +	for (i = 0; i <= max_mode; i++) {
> +		if (adaptive_keyboard_modes[i] == mode)
> +			break;
> +	}
> +
> +	if (i >= max_mode)
> +		i = 0;
> +	else
> +		i++;
> +
> +	return adaptive_keyboard_modes[i];
> +}
> +
> +static bool adaptive_keyboard_hotkey_notify_hotkey(unsigned int scancode)
> +{
> +	u32 current_mode = 0;
> +	int new_mode = 0;
> +
> +	switch (scancode) {
> +	case DFR_CHANGE_ROW:
> +		if (adaptive_keyboard_mode_is_saved) {
> +			new_mode = adaptive_keybarod_prev_mode;
> +			adaptive_keyboard_mode_is_saved = false;
> +		} else {
> +			if (!acpi_evalf(
> +					hkey_handle, &current_mode,
> +					"GTRW", "dd", 0)) {
> +				pr_err("Cannot read adaptive keyboard mode\n");
> +				return false;

Not sure about this return value (resulting in an "unhandled HKEY event"
message).  See below.

> +			} else {
> +				new_mode = adaptive_keyboard_get_next_mode(
> +						current_mode);
> +			}
> +		}
> +
> +		if (!acpi_evalf(hkey_handle, NULL, "STRW", "vd", new_mode))
> +			pr_err("Cannot set adaptive keyboard mode\n");
> +
> +		return true;
> +
> +	case DFR_SHOW_QUICKVIEW_ROW:
> +		if (!acpi_evalf(hkey_handle,
> +				&adaptive_keybarod_prev_mode,
> +				"GTRW", "dd", 0)) {
> +			pr_err("Cannot read adaptive keyboard mode\n");

You should at least return a consistent result for this error.  Either
return true above or false here.

> +		} else {
> +			adaptive_keyboard_mode_is_saved = true;
> +
> +			if (!acpi_evalf(hkey_handle,
> +					NULL, "STRW", "vd", FUNCTION_MODE))
> +				pr_err("Cannot set adaptive keyboard mode\n");
> +		}
> +		return true;
> +
> +	default:
> +		return false;
> +	}
> +}
> +
>  static bool hotkey_notify_hotkey(const u32 hkey,
>  				 bool *send_acpi_ev,
>  				 bool *ignore_acpi_ev)
> @@ -3456,6 +3551,8 @@ static bool hotkey_notify_hotkey(const u32 hkey,
>  			*ignore_acpi_ev = true;
>  		}
>  		return true;
> +	} else {
> +		return adaptive_keyboard_hotkey_notify_hotkey(scancode);
>  	}
>  	return false;

This isn't reached anymore...


>  }


I also think you should consider how this UI will look if you ever
decide to enable all the modes.  AFAICS, you will then have inconsistent
behaviour for the DFR_CHANGE_ROW scancode in FUNCTION_MODE:

 a) if FUNCTION_MODE was enabled by DFR_SHOW_QUICKVIEW_ROW then next
      mode is x, where x can be any mode active before the
      DFR_SHOW_QUICKVIEW_ROW event _including_ FUNCTION_MODE
 b) if FUNCTION_MODE was enabled by DFR_CHANGE_ROW then next
      mode is LAYFLAT_MODE

So the user won't really know the effect of a DFR_CHANGE_ROW event in
FUNCTION_MODE.

Wouldn't it make more sense if DFR_SHOW_QUICKVIEW_ROW always toggled
between FUNCTION_MODE and some other mode, and DFR_CHANGE_ROW always
cycled through the modes?  

Or is the UI locked by whatever the Windows driver does? (I don't have
any X1 Carbon, so I don't know how the users expect this to work)


Bjørn
