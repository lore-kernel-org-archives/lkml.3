Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756702AbaCDJ0T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 04:26:19 -0500
Received: from sym2.noone.org ([178.63.92.236]:60431 "EHLO sym2.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756410AbaCDJ0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 04:26:16 -0500
X-Greylist: delayed 418 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Mar 2014 04:26:16 EST
Date: Tue, 4 Mar 2014 10:19:16 +0100
From: Tobias Klauser <tklauser@distanz.ch>
To: Shuduo Sang <shuduo.sang@canonical.com>
Cc: bjorn@mork.no, ibm-acpi-devel@lists.sourceforge.net,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        ibm-acpi@hmh.eng.br, matthew.garrett@nebula.net,
        platform-driver-x86@vger.kernel.org, bruce.ma@canonical.com
Subject: Re: [PATCH V2] support Thinkpad X1 Carbon's adaptive keyboard
Message-ID: <20140304091916.GE1883@distanz.ch>
References: <5314AE4C.4090502@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5314AE4C.4090502@canonical.com>
X-Editor: Vi IMproved 7.2
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-03-03 at 17:31:08 +0100, Shuduo Sang <shuduo.sang@canonical.com> wrote:
[...]
> +/* press Fn key a while second, it will switch to Function Mode. Then
> + * release Fn key, previous mode be restored.
> + */
> +bool adaptive_keyboard_mode_is_saved;
> +int adaptive_keybarod_prev_mode;

These should probably be made static, since they're only used inside the
module.

> +static int adaptive_keyboard_get_next_mode(int mode)
> +{
> +	int i;
> +	int max_mode = ARRAY_SIZE(adaptive_keyboard_modes) - 1;

sizeof and thus ARRAY_SIZE returns a size_t, so i and max_mode could be
of type size_t as well.

> +
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
> +			} else {
> +				new_mode = adaptive_keyboard_get_next_mode(
> +						current_mode);
> +			}
> +		}
> +
> +		if (!acpi_evalf(hkey_handle, NULL, "STRW", "vd", new_mode)) {
> +			pr_err("Cannot set adaptive keyboard mode\n");
> +			return false;
> +		}
> +
> +		return true;
> +
> +	case DFR_SHOW_QUICKVIEW_ROW:
> +		if (!acpi_evalf(hkey_handle,
> +				&adaptive_keybarod_prev_mode,
> +				"GTRW", "dd", 0)) {
> +			pr_err("Cannot read adaptive keyboard mode\n");
> +			return false;
> +		} else {
> +			adaptive_keyboard_mode_is_saved = true;
> +
> +			if (!acpi_evalf(hkey_handle,
> +					NULL, "STRW", "vd", FUNCTION_MODE)) {
> +				pr_err("Cannot set adaptive keyboard mode\n");
> +				return false;
> +			}
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
> @@ -3456,6 +3556,8 @@ static bool hotkey_notify_hotkey(const u32 hkey,
>  			*ignore_acpi_ev = true;
>  		}
>  		return true;
> +	} else {
> +		return adaptive_keyboard_hotkey_notify_hotkey(scancode);
>  	}
>  	return false;
>  }
> -- 
> 1.9.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
