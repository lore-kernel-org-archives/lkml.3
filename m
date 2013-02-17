Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756343Ab3BQOJZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 09:09:25 -0500
Received: from mail.skyhub.de ([78.46.96.112]:35881 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756189Ab3BQOJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 09:09:23 -0500
Date: Sun, 17 Feb 2013 15:09:08 +0100
From: Borislav Petkov <bp@alien8.de>
To: Peter Feuerer <peter@piie.net>
Cc: Alexander Lam <azl@andrew.cmu.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andreas Mohr <andi@lisas.de>
Subject: Re: thermal governor: does it actually work??
Message-ID: <20130217140908.GA20323@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Peter Feuerer <peter@piie.net>, Alexander Lam <azl@andrew.cmu.edu>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Andreas Mohr <andi@lisas.de>
References: <20130214153255.GA5033@rhlx01.hs-esslingen.de>
 <744357E9AAD1214791ACBA4B0B90926329ED72@SHSMSX101.ccr.corp.intel.com>
 <20130215154931.GA26213@rhlx01.hs-esslingen.de>
 <CACWwPiuk0GynEwe3RuKndWnsYwTuPhO0ob6sJ6ve34u1_RtkYw@mail.gmail.com>
 <20130216214712.GA13494@pd.tnic>
 <cone.1361068993.271211.4532.1000@galar>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cone.1361068993.271211.4532.1000@galar>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 17, 2013 at 03:43:13AM +0100, Peter Feuerer wrote:
> Hi Boris, Alex, Andreas,
> 
> what do you think about this acerhdf patch?
> I think it makes things straight and implements the two-point regulation of 
> acerhdf to be for correctly handled by the thermal layer:
> 
> 
> From 7b39bd8837de6dc5658ac3e54ac5d4df9d351528 Mon Sep 17 00:00:00 2001
> From: Peter Feuerer <peter@piie.net>
> Date: Sun, 17 Feb 2013 03:29:19 +0100
> Subject: [PATCH] added two more trip points to acerhdf, this allows thermal
>  layer to correctly handle the two point regulation of acerhdf. Trip point 0
>  will be active from 0 degree to "fanoff" and is marked as passive, then trip
>  point 1 is valid from "fanoff" to "fanon" value and is marked as active,
>  even if it's only really active in case temperature is going down from trip
>  point 2. Trip point 2 will be valid above "fanon" value and is also marked
>  as active.

Right, so this is clearly something new in the thermal pile of code. I
still don't understand the big picture all that clearly but whatever...

> ---
>  drivers/platform/x86/acerhdf.c | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
> index f94467c..c36633b 100644
> --- a/drivers/platform/x86/acerhdf.c
> +++ b/drivers/platform/x86/acerhdf.c
> @@ -400,6 +400,10 @@ static int acerhdf_get_trip_type(struct thermal_zone_device *thermal, int trip,
>  				 enum thermal_trip_type *type)
>  {
>  	if (trip == 0)
> +		*type = THERMAL_TRIP_PASSIVE;
> +	if (trip == 1)
> +		*type = THERMAL_TRIP_ACTIVE;
> +	if (trip == 2)
>  		*type = THERMAL_TRIP_ACTIVE;

So, digging deep into thermal_sys.c, those naked numbers which we get
handed down for 'trip' are some sort of trip points. Now, I'd very much
like to know what those are and there are no defines what they mean -
code simply iterates over a number of thermal_zone trips - tz->trips -
and we (try to) act accordingly.

Now this is very fragile, IMO.

/me stares at the code a bit more.

Ok, from the looks of it, I'm guessing each driver has to do its own
mapping of what each trip point is, IIUC. And the thermal_zone doodles
over those and for those which the driver has defined, it asks the
driver itself what it wants done (i.e. ->get_trip_temp) and, in our case
it doesn't do anything...

Also, come to think of it, why don't we have THERMAL_TRIP_CRITICAL and
THERMAL_TRIP_HOT trip types?

>  	return 0;
> @@ -409,6 +413,10 @@ static int acerhdf_get_trip_temp(struct thermal_zone_device *thermal, int trip,
>  				 unsigned long *temp)
>  {
>  	if (trip == 0)
> +		*temp = 0;
> +	if (trip == 1)
> +		*temp = fanoff;
> +	if (trip == 2)
>  		*temp = fanon;

Maybe the critical and hot types need to go here? I.e., 3 and 4?

>  	return 0;
> @@ -486,7 +494,8 @@ static int acerhdf_set_cur_state(struct thermal_cooling_device *cdev,
>  		    (cur_temp < fanoff))
>  			acerhdf_change_fanstate(ACERHDF_FAN_OFF);
>  	} else {
> -		if (cur_state == ACERHDF_FAN_OFF)
> +		if ((cur_state == ACERHDF_FAN_OFF) &&
> +		    (cur_temp > fanon))
>  			acerhdf_change_fanstate(ACERHDF_FAN_AUTO);

... and we hook in into the thermal_cdev_update() call here and do the
correction ourselves.

Oh well. I need to befriend myself with the whole concept of thermal
- still have a bad feeling about it, like a star wars character:
http://www.youtube.com/watch?v=sBknAcTaMiI :-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
