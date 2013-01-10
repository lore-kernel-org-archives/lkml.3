Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896Ab3AJTpQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 14:45:16 -0500
Received: from mail-bk0-f41.google.com ([209.85.214.41]:62984 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755863Ab3AJTpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 14:45:12 -0500
Date: Thu, 10 Jan 2013 20:45:02 +0100 (CET)
From: Eldad Zack <eldad@fogrefinery.com>
X-X-Sender: eldad@xoschi
To: Takashi Iwai <tiwai@suse.de>
cc: Jens Axboe <axboe@kernel.dk>, perex@perex.cz, alsa-devel@alsa-project.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Oops in sound/usb/pcm.c:match_endpoint_audioformats() in current
 -git
In-Reply-To: <s5hsj696tgw.wl%tiwai@suse.de>
Message-ID: <alpine.LNX.2.00.1301102038560.1321@xoschi>
References: <50EE7A94.60409@kernel.dk> <s5hobgx72zf.wl%tiwai@suse.de> <50EEB8D2.2030702@kernel.dk> <s5hsj696tgw.wl%tiwai@suse.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 10 Jan 2013, Takashi Iwai wrote:

> At Thu, 10 Jan 2013 13:49:22 +0100,
> Jens Axboe wrote:
> > 
> > Here it is, it's from the one introducing the audioformat lookup.
> > Confirmed that 3.8-rc3 with this backed out works fine, too. So should
> > be fairly confident in that result.

> From: Takashi Iwai <tiwai@suse.de>
> Subject: [PATCH] ALSA: usb-audio: Fix NULL dereference by access to
>  non-existing substream
> 
> The commit [0d9741c0: ALSA: usb-audio: sync ep init fix for
> audioformat mismatch] introduced the correction of parameters to be
> set for sync EP.  But since the new code assumes that the sync EP is
> always paired with the data EP of another direction, it triggers Oops
> when a device only with a single direction is used.

Yes - sorry, I didn't consider this at all.

> This patch adds a proper check of sync EP type and the presence of the
> paired substream for avoiding the crash.
> 
> Reported-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> ---
>  sound/usb/pcm.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/sound/usb/pcm.c b/sound/usb/pcm.c
> index c659310..21c0001 100644
> --- a/sound/usb/pcm.c
> +++ b/sound/usb/pcm.c
> @@ -511,6 +511,17 @@ static int configure_sync_endpoint(struct snd_usb_substream *subs)
>  	struct snd_usb_substream *sync_subs =
>  		&subs->stream->substream[subs->direction ^ 1];
>  
> +	if (subs->sync_endpoint->type != SND_USB_ENDPOINT_TYPE_DATA ||
> +	    !subs->stream) {
> +		ret = snd_usb_endpoint_set_params(subs->sync_endpoint,
> +						  subs->pcm_format,
> +						  subs->channels,
> +						  subs->period_bytes,
> +						  subs->cur_rate,
> +						  subs->cur_audiofmt,
> +						  NULL);
> +	}
> +

I think you want to return here, no?



Jens, could you please send me the device's descriptors (lsusb -v)?
I'd like to take a closer look at this.

Cheers,
Eldad

