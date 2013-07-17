Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757891Ab3GRAhO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 20:37:14 -0400
Received: from microbel.pvv.ntnu.no ([129.241.210.179]:42578 "EHLO
	microbel.pvv.ntnu.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755164Ab3GRAhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 20:37:12 -0400
X-Greylist: delayed 2617 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Jul 2013 20:37:12 EDT
Date: Thu, 18 Jul 2013 01:53:23 +0200
From: Torstein Hegge <hegge@resisty.net>
To: Chris J Arges <christopherarges@gmail.com>
Cc: alsa-devel@alsa-project.org, martin@meltin.net,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Eldad Zack <eldad@fogrefinery.com>, Trulan Martin <trulanm@gmail.com>,
        Damien Zammit <damien@zamaudio.com>, Mark Hills <mark@xwax.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ALSA: usb-audio: Add quirk for Focusrite Scarlett 18i8
Message-ID: <20130717235323.GA21885@pvv.ntnu.no>
References: <1374095558-9949-1-git-send-email-christopherarges@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1374095558-9949-1-git-send-email-christopherarges@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 17, 2013 at 16:12:12 -0500, Chris J Arges wrote:
> This patch is similar to commit 1762a59d8e8b5e99f6f4a0f292b40f3cacb108ba.
> The same non-standard interface descriptor causes snd_usb_create_mixer()
> to fail for the Focusrite Scarlett 18i8 as well.

Did you test this on a recent kernel? I don't think this quirk or the quirk
introduced by 1762a59d "ALSA: usb-audio: Add quirk for Focusrite Scarlett
18i6" is necessary since kernel 3.9, as it includes:

4d7b86c98 "ALSA: snd-usb: mixer: propagate errors up the call chain"
83ea5d18d "ALSA: snd-usb: mixer: ignore -EINVAL in snd_usb_mixer_controls()"
61ac51301 "ALSA: usb: Parse UAC2 extension unit like for UAC1"

Those were tested on a Focusrite Scarlett 8i6, but the lsusb output
from 18i6 and 8i6 looks similar,
http://www.mail-archive.com/alsa-user@lists.sourceforge.net/msg29426.html
http://www.mail-archive.com/alsa-user@lists.sourceforge.net/msg27776.html
I'm guessing the 18i8 isn't that different.


Torstein

> ---
>  sound/usb/quirks-table.h |   46 ++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 46 insertions(+)
> 
> diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
> index 7f1585b..b954ec5 100644
> --- a/sound/usb/quirks-table.h
> +++ b/sound/usb/quirks-table.h
> @@ -3232,6 +3232,52 @@ YAMAHA_DEVICE(0x7010, "UB99"),
>  		}
>  	}
>  },
> +{
> +	/*
> +	 * Focusrite Scarlett 18i8
> +	 *
> +	 * Avoid mixer creation similar to the Scarlett 18i6 interface.
> +	 */
> +	USB_DEVICE(0x1235, 0x8014),
> +	.driver_info = (unsigned long) & (const struct snd_usb_audio_quirk) {
> +		.vendor_name = "Focusrite",
> +		.product_name = "Scarlett 18i8",
> +		.ifnum = QUIRK_ANY_INTERFACE,
> +		.type = QUIRK_COMPOSITE,
> +		.data = & (const struct snd_usb_audio_quirk[]) {
> +			{
> +				/* InterfaceSubClass 1 (Control Device) */
> +				.ifnum = 0,
> +				.type = QUIRK_IGNORE_INTERFACE
> +			},
> +			{
> +				.ifnum = 1,
> +				.type = QUIRK_AUDIO_STANDARD_INTERFACE
> +			},
> +			{
> +				.ifnum = 2,
> +				.type = QUIRK_AUDIO_STANDARD_INTERFACE
> +			},
> +			{
> +				/* InterfaceSubClass 1 (Control Device) */
> +				.ifnum = 3,
> +				.type = QUIRK_IGNORE_INTERFACE
> +			},
> +			{
> +				.ifnum = 4,
> +				.type = QUIRK_MIDI_STANDARD_INTERFACE
> +			},
> +			{
> +				/* InterfaceSubClass 1 (Device Firmware Update) */
> +				.ifnum = 5,
> +				.type = QUIRK_IGNORE_INTERFACE
> +			},
> +			{
> +				.ifnum = -1
> +			}
> +		}
> +	}
> +},
>  
>  {
>  	/*
> -- 
> 1.7.9.5
