Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934Ab3BDBD7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 20:03:59 -0500
Received: from host171.canaca.com ([67.55.55.225]:36213 "EHLO
	host171.canaca.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881Ab3BDBD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 20:03:57 -0500
Message-ID: <96112ebd84b1a60890c01bb6e2dfa181.squirrel@mungewell.org>
In-Reply-To: <CAGf+dShLdE8hPYdfKw417hYyiox8cqCL3Jm6OQ3P4HfnE63CPw@mail.gmail.com>
References: <1359837925-6383-1-git-send-email-sbarra.paul@gmail.com>
    <1359837925-6383-3-git-send-email-sbarra.paul@gmail.com>
    <CAGf+dShLdE8hPYdfKw417hYyiox8cqCL3Jm6OQ3P4HfnE63CPw@mail.gmail.com>
Date: Sun, 3 Feb 2013 20:03:54 -0500
Subject: Re: [PATCH 3/3] hid: Calibrate Logitech Driving Force axes
From: simon@mungewell.org
To: "Paul Sbarra" <sbarra.paul@gmail.com>
Cc: jkosina@suse.cz, simon@mungewell.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Paul Sbarra" <sbarra.paul@gmail.com>
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - host171.canaca.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - mungewell.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,
I think it is unwise to calibrated the 'Driving Force' wheel by adjusting
the report descriptor as it might just be your wheel at fault. Calibration
should be done either with jscal (or eqivilant) or 'in-game'.

In your more recent patch your calibration would be enforced on all wheels
with the USB ID 046d:c294, which is not appropriate.

One thing which might be distorting the values read is the default values
for 'fuzz' and 'flat', which are applied by the kernel.

Probably not the best/only way, but you can use the application
'G25_Manage' to do this...

https://github.com/VDrift/vdrift/tree/master/tools/G25manage

I think that we should work to ensure that these are set to 0 for all
logitech wheels (DFP already has something - although non-ideal). Perhaps
the 'mapped' callback can be used to zero flat/fuzz after the controls
have been mapped, without the need to know what the range is.

Simon.


> This patch should be used in favor of the previous.
>
> Signed-off-by: Paul Sbarra <sbarra.paul@gmail.com>
> ---
>  drivers/hid/hid-lg4ff.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
>
> diff --git a/drivers/hid/hid-lg4ff.c b/drivers/hid/hid-lg4ff.c
> index d7947c7..4b72029e 100644
> --- a/drivers/hid/hid-lg4ff.c
> +++ b/drivers/hid/hid-lg4ff.c
> @@ -43,6 +43,13 @@
>  #define G27_REV_MAJ 0x12
>  #define G27_REV_MIN 0x38
>
> +#define DF_X_MIN 45
> +#define DF_X_MAX 935
> +#define DF_ACCEL_PEDAL_MIN 30
> +#define DF_ACCEL_PEDAL_MAX 175
> +#define DF_BRAKE_PEDAL_MIN 70
> +#define DF_BRAKE_PEDAL_MAX 215
> +
>  #define DFP_X_MIN 0
>  #define DFP_X_MAX 16383
>  #define DFP_PEDAL_MIN 0
> @@ -600,6 +607,12 @@ int lg4ff_init(struct hid_device *hid)
>
>   /* Set default axes parameters */
>   switch (lg4ff_devices[i].product_id) {
> + case USB_DEVICE_ID_LOGITECH_WHEEL:
> + dbg_hid("Setting axes parameters for Driving Force\n");
> + input_set_abs_params(dev, ABS_X, DF_X_MIN, DF_X_MAX, 0, 0);
> + input_set_abs_params(dev, ABS_Y, DF_ACCEL_PEDAL_MIN, DF_ACCEL_PEDAL_MAX,
> 0, 0);
> + input_set_abs_params(dev, ABS_RZ, DF_BRAKE_PEDAL_MIN,
> DF_BRAKE_PEDAL_MAX,
> 0, 0);
> + break;
>   case USB_DEVICE_ID_LOGITECH_DFP_WHEEL:
>   dbg_hid("Setting axes parameters for Driving Force Pro\n");
>   input_set_abs_params(dev, ABS_X, DFP_X_MIN, DFP_X_MAX, 0, 0);
> --
> 1.8.1.1
>


