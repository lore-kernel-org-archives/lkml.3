Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab3LROry (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 09:47:54 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:56764 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754066Ab3LROrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 09:47:52 -0500
Date: Wed, 18 Dec 2013 06:47:49 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: linux-input@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Peter Hutterer <peter.hutterer@who-t.net>,
        Antonio Ospite <ospite@studenti.unina.it>,
        linux-kernel@vger.kernel.org, input-tools@lists.freedesktop.org
Subject: Re: [PATCH 2/4] Input: introduce ABS_MAX2/CNT2 and friends
Message-ID: <20131218144749.GH28504@core.coreip.homeip.net>
References: <1387295334-1744-1-git-send-email-dh.herrmann@gmail.com>
 <1387295334-1744-3-git-send-email-dh.herrmann@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387295334-1744-3-git-send-email-dh.herrmann@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 17, 2013 at 04:48:52PM +0100, David Herrmann wrote:
> As we painfully noticed during the 3.12 merge-window our
> EVIOCGABS/EVIOCSABS API is limited to ABS_MAX<=0x3f. We tried several
> hacks to work around it but if we ever decide to increase ABS_MAX, the
> EVIOCSABS ioctl ABI might overflow into the next byte causing horrible
> misinterpretations in the kernel that we cannot catch.
> 
> Therefore, we decided to go with ABS_MAX2/CNT2 and introduce two new
> ioctls to get/set abs-params. They no longer encode the ABS code in the
> ioctl number and thus allow up to 4 billion ABS codes.
> 
> The new API also allows to query multiple ABS values with one call. To
> allow EVIOCSABS2(code = 0, cnt = ABS_CNT2) we need to silently ignore
> writes to ABS_MT_SLOT. Furthermore, for better compatibility with
> newer user-space, we ignore writes to unknown codes. Hence, if we ever
> increase ABS_MAX2, new user-space will work with code=0,cnt=ABS_CNT2 just
> fine even on old kernels.
> 
> Note that we also need to increase EV_VERSION so user-space can reliably
> know whether ABS2 is supported. Unfortunately, we return EINVAL instead of
> ENOSYS for unknown evdev ioctls so it's nearly impossible to catch
> reliably without EVIOCGVERSION.
> 
> Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
> ---
>  drivers/hid/hid-debug.c                  |  2 +-
>  drivers/hid/hid-input.c                  |  2 +-
>  drivers/input/evdev.c                    | 95 +++++++++++++++++++++++++++++++-
>  drivers/input/input.c                    | 14 ++---
>  drivers/input/keyboard/goldfish_events.c |  6 +-
>  drivers/input/keyboard/hil_kbd.c         |  2 +-
>  drivers/input/misc/uinput.c              |  6 +-
>  include/linux/hid.h                      |  2 +-
>  include/linux/input.h                    |  6 +-
>  include/uapi/linux/input.h               | 42 +++++++++++++-
>  include/uapi/linux/uinput.h              |  2 +-
>  11 files changed, 155 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/hid/hid-debug.c b/drivers/hid/hid-debug.c
> index 8453214..d32fa30 100644
> --- a/drivers/hid/hid-debug.c
> +++ b/drivers/hid/hid-debug.c
> @@ -862,7 +862,7 @@ static const char *relatives[REL_MAX + 1] = {
>  	[REL_WHEEL] = "Wheel",		[REL_MISC] = "Misc",
>  };
>  
> -static const char *absolutes[ABS_CNT] = {
> +static const char *absolutes[ABS_CNT2] = {
>  	[ABS_X] = "X",			[ABS_Y] = "Y",
>  	[ABS_Z] = "Z",			[ABS_RX] = "Rx",
>  	[ABS_RY] = "Ry",		[ABS_RZ] = "Rz",
> diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
> index d97f232..a02721c 100644
> --- a/drivers/hid/hid-input.c
> +++ b/drivers/hid/hid-input.c
> @@ -1300,7 +1300,7 @@ static bool hidinput_has_been_populated(struct hid_input *hidinput)
>  	for (i = 0; i < BITS_TO_LONGS(REL_CNT); i++)
>  		r |= hidinput->input->relbit[i];
>  
> -	for (i = 0; i < BITS_TO_LONGS(ABS_CNT); i++)
> +	for (i = 0; i < BITS_TO_LONGS(ABS_CNT2); i++)
>  		r |= hidinput->input->absbit[i];

I wonder if kittens will die if we do:

in include/uapi/linux/input:

#define ABS_MAX1	0x3f
#define ABS_MAX2	0xYY

/*
 * Keep old value of ABS_MAX exported to userspace. Users ready to
 * handle bigger range will have to use ABS_MAX2 explicitly.
 */
#define ABS_MAX		ABS_MAX1

in include/linux/input.h

...
/* Kernel should use the new ABS range by default */
#undef ABS_MAX
#define ABS_MAX		ABS_MAX2

Thanks.

-- 
Dmitry
