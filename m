Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164Ab3BRNuQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 08:50:16 -0500
Received: from mail.skyhub.de ([78.46.96.112]:43891 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754090Ab3BRNuO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 08:50:14 -0500
Date: Mon, 18 Feb 2013 14:50:12 +0100
From: Borislav Petkov <bp@alien8.de>
To: Peter Feuerer <peter@piie.net>
Cc: Alexander Lam <azl@andrew.cmu.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andreas Mohr <andi@lisas.de>
Subject: Re: thermal governor: does it actually work??
Message-ID: <20130218135012.GB16622@pd.tnic>
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
 <20130217140908.GA20323@pd.tnic>
 <cone.1361115717.636831.25189.1000@galar>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cone.1361115717.636831.25189.1000@galar>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 17, 2013 at 04:41:57PM +0100, Peter Feuerer wrote:
> Don't think so, I think this was already in since 2.6.<something> and
> I assume with this patch applied, acerhdf works from at least this
> 2.6.<something> up to new 3.8 and will still work in the future.

Well, it can't be because there wouldn't be breakage otherwise, right?
I've been running 3.5 on the atom for a long time and it was ok but 3.8
is showing the issue. So something *has* changed.

> As far as I understand the code (and
> Documentation/thermal/cpu-cooling-api.txt), the thermal api finds the
> appropriate trip point and then set's the fan to the corresponding
> state, defined by the thermal/fan driver.

Right, but the low level driver defines what to do at each trip point.

> This is nice thing, if you can completely control the speed of the
> fan, because you have then a good fan speed to temperature
> regulation. But we do only have a two point regulation (on and off),
> that's why we have to handle our thresholds within the trip=1 on our
> own to not get an all the time on-off-toggling of the fan.

Ok.

> I think this is how the developer of thermal_sys intended drivers to
> work. But he forgot about two-point regulators (most probably because
> there's no one besides acerhdf)

Fair enough.

> I don't understand what you mean by "in our case it doesn't do
> anything", acerhdf is reporting the trip temperatures correctly, when
> get_trip_temp is called.

Well, we have the thermal_sys.c deal which is at the top-level, then
there's the governor, i.e. step_wise.c in our case. The actual thing
doing the work is ->set_cur_state in acerhdf.c And you've added logic
there too:

> >>+           if ((cur_state == ACERHDF_FAN_OFF) &&
> >>+               (cur_temp > fanon))
> >>                    acerhdf_change_fanstate(ACERHDF_FAN_AUTO);

which I was expecting the thermal layer to do for us and acerhdf to do
only the switching like the cpufreq drivers to, for example. Btw, if we
did this, acerhdf would be even simpler.

But, as you say above, I guess the two-point scheme of acerhdf doesn't
have a governor that fits. So maybe the correct solution is to have an
"on_off" stupid governor which gets used by acerhdf and does simply call
into acerhdf to switch on the fan to auto above a specified trip point.

It could be a lot of overhead for nothing in the end, though.

> You are right, we should at least add the THERMAL_TRIP_CRITICAL, so
> that we handle this, but I think we can ignore THERMAL_TRIP_HOT, as
> it is not really serving anything of value in our case.
> 
> 
> >
> >> 	return 0;
> >>@@ -409,6 +413,10 @@ static int acerhdf_get_trip_temp(struct thermal_zone_device *thermal, int trip,
> >> 				 unsigned long *temp)
> >> {
> >> 	if (trip == 0)
> >>+		*temp = 0;
> >>+	if (trip == 1)
> >>+		*temp = fanoff;
> >>+	if (trip == 2)
> >> 		*temp = fanon;
> >
> >Maybe the critical and hot types need to go here? I.e., 3 and 4?
> 
> Yes, crit has to go there.

Right, I'll wait for that version of the patch to test. :)

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
