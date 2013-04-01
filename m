Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757919Ab3DARiG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 13:38:06 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:43193 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757329Ab3DARiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 13:38:04 -0400
Message-ID: <5159C4AE.2050504@linaro.org>
Date: Mon, 01 Apr 2013 10:32:30 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Feng Tang <feng.tang@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@linux.intel.com>,
        x86@kernel.org, Len Brown <lenb@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/5] Add support for S3 non-stop TSC support.
References: <1358750325-21217-1-git-send-email-feng.tang@intel.com> <50FD48B6.9010202@intel.com> <20130330181451.GF28947@amd.pavel.ucw.cz>
In-Reply-To: <20130330181451.GF28947@amd.pavel.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30/2013 11:14 AM, Pavel Machek wrote:
> Hi!
>
>>> On some new Intel Atom processors (Penwell and Cloverview), there is
>>> a feature that the TSC won't stop S3, say the TSC value won't be
>>> reset to 0 after resume. This feature makes TSC a more reliable
>>> clocksource and could benefit the timekeeping code during system
>>> suspend/resume cycles.
>>>
>>> The enabling efforts include adding new flags for this feature,
>>> modifying clocksource.c and timekeeping.c to support and utilizing
>>> it.
>>>
>>> One remaining question is inside the timekeeping_resume(), we don't
>>> know if it is called by resuming from suspend(s2ram) or from
>>> hibernate(s2disk), as there is no easy way to check it currently.
>>> But it doesn't hurt as these Penwell/Cloverview platforms only have
>>> S3 state, and no S4.
>>>
>>> Please help to review them, thanks!
>> The patches look reasonable to me.
> Not sure... what are advantages? TSC is high resolution, but not
> exactly precise time source... and this only makes resume more
> complex.
Providing sub-second granularity for suspend time measurement is a 
pretty compelling use, which greatly reduces time error across 
suspend/resume.

I agree that the code logic is more complex, but the TSC path should be 
a good bit faster then hitting the CMOS.
And overall, I'm hoping we can eventually move the RTC based 
read_persistent_clock() implementations into the rtc core, then allow 
for clocksource based suspend timing where available (since ARM boards 
are already basically doing this, but hiding it behind 
read_persistent_clock() calls).

There is the open concern that given their history, x86 designers will 
find yet another way to break the TSC in some future chip and we'll end 
up with non-stop TSCs that run at different frequencies in suspend or 
some other such nonsense. But we'll just have to detect that and disable 
functionality where appropriate, much as we do with the TSC now.

thanks
-john


