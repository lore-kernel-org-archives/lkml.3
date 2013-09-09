Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751296Ab3IIIXR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 04:23:17 -0400
Received: from iron6.routit.net ([89.146.30.10]:46943 "EHLO iron6.routit.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751122Ab3IIIXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 04:23:13 -0400
X-Greylist: delayed 303 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Sep 2013 04:23:13 EDT
X-SenderBaseSpam: None
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqIEAGl6LVIuLKtN/2dsb2JhbABagz+De75rgTJ0giUBAQUjDwEFQQ4CCxgCAgUhAgIPAgo8BgEMAQUCAQGIAgi0ApEBBIEljSuBGBQHgmmBNAOZJIkAhzeDIjqBLg
X-IPAS-Result: AqIEAGl6LVIuLKtN/2dsb2JhbABagz+De75rgTJ0giUBAQUjDwEFQQ4CCxgCAgUhAgIPAgo8BgEMAQUCAQGIAgi0ApEBBIEljSuBGBQHgmmBNAOZJIkAhzeDIjqBLg
Message-ID: <522D843A.60401@raritan.com>
Date: Mon, 09 Sep 2013 10:18:02 +0200
From: Ronald Wahl <ronald.wahl@raritan.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Marc Kleine-Budde <mkl@pengutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        arm@kernel.org, John Stultz <john.stultz@linaro.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        Andres Salomon <dilinger@queued.net>, Shawn Guo <shawn.guo@linaro.org>,
        linux-ar@jasper.es
Subject: Re: RFC: [PATCH] clocksource: tcb: fix min_delta calculation
References: <517687AB.1040309@pengutronix.de> <1366722524-25991-1-git-send-email-mkl@pengutronix.de> <alpine.LFD.2.02.1304251618590.21884@ionos> <51794385.1030308@pengutronix.de> <51C31926.3060400@pengutronix.de>
In-Reply-To: <51C31926.3060400@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 09 Sep 2013 08:18:04.0877 (UTC) FILETIME=[1BA197D0:01CEAD35]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20.06.2013 17:00, Marc Kleine-Budde wrote:
> Hello Thomas,
>
> On 04/25/2013 04:53 PM, Marc Kleine-Budde wrote:
>> On 04/25/2013 04:21 PM, Thomas Gleixner wrote:
>>> On Tue, 23 Apr 2013, Marc Kleine-Budde wrote:
>>>> The commit
>>>>
>>>>      77cc982 clocksource: use clockevents_config_and_register() where possible
>>>>
>>>> switches from manually calculating min_delta_ns (and others) and
>>>> clockevents_register_device() to automatic calculation via
>>>> clockevents_config_and_register(). During this conversation the "+ 1" in
>>>>
>>>>      min_delta_ns = clockevent_delta2ns(1, &clkevt.clkevt) + 1;
>>>>
>>>> was lost. This leads to problems with schedule_delayed_work() with a delay of
>>>> "1". Resulting in the work not scheduled in time.
>>>
>>> Errm. How is schedule_delayed_work() related to this?

I also stumbled over this issue now after upgrading from 3.4.57 to 
3.10.10. Even sleep() is unreliable - sleeping for 2 seconds often 
sleeps just more than 3 seconds.

The now lost +1 has actually been added in 2007 to solve a rounding issue:

   http://permalink.gmane.org/gmane.linux.kernel/549744

So I think this should either be fixed by always rounding up in 
clockevent_delta2ns() or by adding +1 to the min_delta_ns in the 
clockevents_config_and_register() function. Dunno if rounding up will 
cause problems with the max_delta_ns as it might be too big then so 
probably the second approach is better.

Opinions?

- ron

-- 
Ronald Wahl - ronald.wahl@raritan.com - Phone +49 375271349-0 Fax -99
Raritan Deutschland GmbH, Kornmarkt 7, 08056 Zwickau, Germany
USt-IdNr. DE813094160, Steuer-Nr. 227/117/01749
Amtsgericht Chemnitz HRB 23605
Geschäftsführung: Stuart Hopper, Ralf Ploenes
