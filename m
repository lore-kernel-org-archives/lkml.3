Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879AbaBXAjJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 19:39:09 -0500
Received: from sinikuusama.dnainternet.net ([83.102.40.134]:43876 "EHLO
	sinikuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750838AbaBXAjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 19:39:07 -0500
X-Greylist: delayed 389 seconds by postgrey-1.27 at vger.kernel.org; Sun, 23 Feb 2014 19:39:07 EST
X-Spam-Flag: NO
X-Spam-Score: -1
Message-ID: <530A931D.9030308@iki.fi>
Date: Mon, 24 Feb 2014 02:32:29 +0200
From: Anssi Hannula <anssi.hannula@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Michal_Mal=FD?= <madcatxster@prifuk.cz>
CC: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmitry.torokhov@gmail.com, elias.vds@gmail.com, jkosina@suse.cz,
        simon@mungewell.org
Subject: Re: [PATCH v2 1/4] Add ff-memless-next driver
References: <1516865.M993BQAYe4@geidi-prime> <3364546.xScl1m6sdc@geidi-prime>
In-Reply-To: <3364546.xScl1m6sdc@geidi-prime>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

24.02.2014 01:29, Michal Malý kirjoitti:
> Introduce ff-memless-next module as a possible future replacement of
> ff-memless.
> 
> Tested-by: Elias Vanderstuyft <elias.vds@gmail.com>
> Signed-off-by: Michal Malý <madcatxster@prifuk.cz>

Some comments below.

> ---
>  v2:
>   Handle upload and removal of uncombinable effects correctly
>   Remove redundant information from the documentation file
>   Invert direction of force along Y axis to conform to common conventions
>   Set FF_GAIN bit
> 
>  Documentation/input/ff-memless-next.txt | 141 ++++++
>  drivers/input/Kconfig                   |  11 +
>  drivers/input/Makefile                  |   1 +
>  drivers/input/ff-memless-next.c         | 789 ++++++++++++++++++++++++++++++++
>  include/linux/input/ff-memless-next.h   |  32 ++
>  5 files changed, 974 insertions(+)
>  create mode 100644 Documentation/input/ff-memless-next.txt
>  create mode 100644 drivers/input/ff-memless-next.c
>  create mode 100644 include/linux/input/ff-memless-next.h
> 
> diff --git a/Documentation/input/ff-memless-next.txt b/Documentation/input/ff-memless-next.txt
> new file mode 100644
> index 0000000..1b550dc
> --- /dev/null
> +++ b/Documentation/input/ff-memless-next.txt
> @@ -0,0 +1,141 @@
[...]
> +3. API provided by "ff-memless-next"
> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> +"ff-memless-next" provides an API for developers of hardware-specific
> +drivers. In order to use the API, the hardware-specific driver should
> +include <linux/input/ff-memless-next.h>
> +Functions and structs defined by this API are:
[...]

This kind of basic API documentation belongs in the headers (kernel-doc
format).

[...]
> +	MLNX_UPLOAD_UNCOMB - Check if the device can accept and play
> +			     "uncombinable" effect and upload the effect into
> +			     the device's internal memory.
> +			     Hardware-specific driver should return 0
> +			     on success.
> +	MLNX_ERASE_UNCOMB - Remove "uncombinable" effect from device's
> +			    internal memory.
> +			    Hardware-specific driver should return 0
> +			    on success.
> +	MLNX_START_UNCOMB - Start playback of "uncombinable" effect.
> +	MLNX_STOP_UNCOMB - Stop playback of "uncombinable" effect.

These seem to be unused by any drivers?

I don't think they should be added to the kernel before there is an
implementation using them (it also makes reviewing them more difficult).

[...]
> +4. Specifics of "ff-memless-next" for userspace developers
> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> +None of the persons involved in development or testing of "ff-memless-next"
> +is aware of any reference force feedback specifications. "ff-memless-next"
> +tries to adhere to Microsoft's DirectInput specifications because we
> +believe that is what most developers have experience with.
> +
> +- Waveforms of periodic effects do not start at the origin, but as follows:
> +	SAW_UP: At minimum
> +	SAW_DOWN: At maximum
> +	SQUARE: At maximum
> +	TRIANGLE: At maximum
> +	SINE: At origin
> +
> +- Updating periodic effects:
> +	- All periodic effects are restarted when their parameters are updated.
> +
> +- Updating effects of finite duration:
> +	- Once an effect of finite length finishes playing, it is considered
> +	  stopped. Only effects that are playing can be updated on the fly.
> +	  Therefore effects of finite duration can be updated only until
> +	  they finish playing.

Stopped effects should still be able to be updated.

Anyway, if you want to target userspace developers with this
information, you should put it in generic documentation ("it is not
guaranteed that X", etc.). If not, don't say "for userspace developers".

[...]
> diff --git a/drivers/input/ff-memless-next.c b/drivers/input/ff-memless-next.c
> new file mode 100644
> index 0000000..843a223
> --- /dev/null
> +++ b/drivers/input/ff-memless-next.c
> @@ -0,0 +1,789 @@
> +/*
> + * Force feedback support for memoryless devices
> + *
> + * This module is based on "ff-memless" orignally written by Anssi Hannula.
> + * It is extended to support all force feedback effects currently supported
> + * by the Linux input stack.
> + *
> + * Copyright(c) 2013 Michal Maly <madcatxster@prifuk.cz>
> + *
> + */
[...]
> +static int mlnx_upload(struct input_dev *dev, struct ff_effect *effect,
> +		       struct ff_effect *old)
> +{
[...]
> +		}
> +
> +		mlnx_schedule_playback(mlnxdev);
> +		spin_unlock_irq(&dev->event_lock);
> +		return 0;

The above two lines are unneeded.

> +	}
> +
> +	spin_unlock_irq(&dev->event_lock);
> +
> +	return 0;
> +}
> +
[...]
> diff --git a/include/linux/input/ff-memless-next.h b/include/linux/input/ff-memless-next.h
> new file mode 100644
> index 0000000..ba89ba1
> --- /dev/null
> +++ b/include/linux/input/ff-memless-next.h
> @@ -0,0 +1,32 @@
[...]
> +int input_ff_create_mlnx(struct input_dev *dev, void *data,
> +			 int(*control_effect)(struct input_dev *, void *, const struct mlnx_effect_command *),
> +			 const u16 update_rate);

Why is update_rate now driver-selectable?

-- 
Anssi Hannula

