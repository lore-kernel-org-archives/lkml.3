Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813AbaE1QGw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 12:06:52 -0400
Received: from cmta7.telus.net ([209.171.16.80]:48959 "EHLO cmta7.telus.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753425AbaE1QGu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 12:06:50 -0400
X-Authority-Analysis: v=2.0 cv=JPrlRb2b c=1 sm=2
 a=zJWegnE7BH9C0Gl4FFgQyA==:17 a=wC_tZcyTK_MA:10 a=LGgl8L9ij00A:10
 a=kj9zAlcOel0A:10 a=aatUQebYAAAA:8 a=Pyq9K9CWowscuQLKlpiwfMBGOR0=:19
 a=D19gQVrFAAAA:8 a=VwQbUJbxAAAA:8 a=z7FW5Oor5zB5G4pvPMgA:9 a=CjuIK1q_8ugA:10
 a=TyNiYCGxJotRh7XF:21 a=yCggSeVB3T8-4yk1:21 a=zJWegnE7BH9C0Gl4FFgQyA==:117
X-Telus-Outbound-IP: 173.180.45.4
From: "Doug Smythies" <dsmythies@telus.net>
To: "'Yuyang Du'" <yuyang.du@intel.com>, "'Johan Hovold'" <jhovold@gmail.com>
Cc: "'Dirk Brandewie'" <dirk.brandewie@gmail.com>,
        "'Viresh Kumar'" <viresh.kumar@linaro.org>,
        <dirk.j.brandewie@intel.com>,
        "'Rafael J. Wysocki'" <rafael.j.wysocki@intel.com>,
        <cpufreq@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        "'Stratos Karafotis'" <stratosk@semaphore.gr>,
        "Doug Smythies" <dsmythies@telus.net>
References: <20140506163559.GA5308@localhost> <CAKohpokYEvazxm0-JJXPzq-4OgLXmROfaCMcgHDZwugChOxtsQ@mail.gmail.com> <536A3EE9.5050409@intel.com> <20140521090051.GO21412@localhost> <20140528075945.GA21705@localhost> <20140528003540.GA2296@intel.com>
In-Reply-To: <20140528003540.GA2296@intel.com>
Subject: RE: Performance regression in v3.14
Date: Wed, 28 May 2014 09:00:43 -0700
Message-ID: <002401cf7a8d$fc6d9090$f548b1b0$@net>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Ac96UGghk9YVnWftS4iVA1U5o2bnUwANbbTg
Content-Language: en-ca
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2014.05.27 01:40 Yuyang Du wrote:
>> On 2014.05.27 01:00, Johan Hovold wrote:
>> I tried applying your (rejected) patch "intel_pstate: Remove C0
>> tracking" posted here:
>> 
>> 	https://lkml.org/lkml/2014/5/8/574
>> 
>> to v3.14.4 and it fixes the problem as expected.
>> 
>> So we have a commit fcb6a15c2e7e ("intel_pstate: Take core C0 time into
>> account for core busy calculation") that went into v3.14-rc2 (and was
>> even marked for *stable*) that first broke Greg KH's system:
>> 
>> 	https://lkml.org/lkml/2014/2/19/626
>> 
>> That was apparently fixed by e66c17683746 ("intel_pstate: Change
>> busy calculation to use fixed point math."), but still left v3.14
>> basically unusable for lower-intensity workloads such as my
>> bash-completion example and other reported regressions:
>> 
>> 	https://bugzilla.kernel.org/show_bug.cgi?id=75121
>> 
>> Sure there may be issues with v3.13 not hitting the lowest frequencies
>> but at least the system was *usable*.
>> 
>> In my opinion there's really no other option than to restore the 3.13
>> behaviour by effectively reverting fcb6a15c2e7e ("intel_pstate: Take
>> core C0 time into account for core busy calculation") until you have
>> figured out a way to take C0 into account without breaking things too
>> badly.

> Hi all,

> My posts before and now are only relevant to why C0 tracking can't be
> removed. Maybe I need to elaborate on it a little bit more.

> In a nutshell, without C0 tracking, the intel_pstate is effectively
> performance governor in terms of frequency control.

That is not true. The CPU Frequency Verses Load response curve
is different and considerably more aggressive for performance mode
when compared to powersave mode with C0 tracking removed.

I'll add a relevant graph to the bugzilla report referenced above.
(but it will be a few hours before I do.)

> Why? Without C0 trakcing, the machinery of the freq control
> is as I formed:
> last_freq_average / last_requested_freq ==> setpoint
> which can be virtually formed into:
> last_freq_average / last_requested_freq * last_C0_pct ==>
> setpoint * last_C0_pct

> which said, the control machinery will increase the frequency
> at ANY frequency at ANY C0_pct (which is the CPU utilization),
> since setpoint is less then 100 percent.

That is not true. Yes, and due to the setpoint being less than
100, which is needed or the driver won't work at all, there is
a tendency to drive the target pstate upwards.
However that is tempered by both the PID proportional gain,
and ultimately integer math. More importantly, the CPU
itself tells the driver when it is operating below the target
pstate and driver responds.

Additionally, the tendency to drive up the target pstate
too much is exasperated by some extra rounding up at a
couple of spots. Dirk has a pending fix.

> And a few iterations
> later, we will reach max (possible) frequency,
> then we are effectively performance governor
> (highest frequency all the time).

Please do not confuse highest target pstate with
highest frequency. They are not the same. The processor
itself can back off.

... Doug


