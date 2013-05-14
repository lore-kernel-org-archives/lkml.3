Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319Ab3ENRPM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 13:15:12 -0400
Received: from mail-da0-f42.google.com ([209.85.210.42]:43437 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194Ab3ENRPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 13:15:10 -0400
Message-ID: <5192711B.1070607@linaro.org>
Date: Tue, 14 May 2013 10:15:07 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>
CC: "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] timekeeping: sync persistent clock and RTC on system
 time step changes
References: <1368467768-2316-1-git-send-email-david.vrabel@citrix.com> <1368467768-2316-3-git-send-email-david.vrabel@citrix.com> <5191880F.3030308@linaro.org> <5192082D.4020400@citrix.com>
In-Reply-To: <5192082D.4020400@citrix.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2013 02:47 AM, David Vrabel wrote:
> On 14/05/13 01:40, John Stultz wrote:
>> On 05/13/2013 10:56 AM, David Vrabel wrote:
>>> From: David Vrabel <david.vrabel@citrix.com>
>>>
>>> The persistent clock or the RTC is only synchronized with system time
>>> every 11 minutes if NTP is running.  This gives a window where the
>>> persistent clock may be incorrect after a step change in the time
>>> (such as on first boot).
>>>
>>> This particularly affects Xen guests as until an update to the control
>>> domain's persistent clock, new guests will start with the incorrect
>>> system time.
>>>
>>> When there is a step change in the system time, call
>>> update_persistent_clock or rtc_set_ntp_time() to synchronize the
>>> persistent clock or RTC to the new system time.
>> I'm sorry, this isn't quite making sense to me. Could you further
>> describe the exact problematic behavior you're seeing here, and why its
>> a problem?
> The Xen wallclock is used as the persistent clock for Xen guests.  This
> is initialized (by Xen) with the CMOS RTC at the start of day.

Start of the day? I assume you mean on dom0 bootup? Or is it done 
pre-dom0 bootup by Xen itself?

>    If the
> RTC is incorrect then guests will see an incorrect wallclock time until
> dom0 has corrected it.


Sorry, just a bit more clarifying context here: So there is a 1:1 
relationship between xen_wall_clock and the RTC for all domN guests? And 
even if dom0 has set its system time properly, domN guests will 
initialize (in effect) from the hardware RTC and not from dom0's system 
time?


So, let me see if I'm getting this right:

* Hardware has misconfigured RTC, set to the wrong date/time
* Xen boots up dom0 (or Xen itself) initializes the xen_wall_clock to 
the RTC
* dom0 finishes booting, and uses NTP to correct the system time
* dom1 starts up, uses xen_wall_clock to initialize its system time, but 
the RTC is still wrong, so it boots with the wrong time.
* After 11 minutes of sync w/ NTP, dom0 sets the RTC fixing the time.
* dom2 starts up, uses xen_wall_clock to initialize its system time 
correctly.

At this point, dom0 and dom2 have the correct time and dom1 is 
incorrect, right?

And with your other patches, after the next boot up (assuming dom0 is 
synced with NTP for > 11 minutes) everything will be fine (and if NTP 
doesn't set dom0's RTC, or the hwclock isn't otherwise corrected we'll 
see the same behavior).

Is this correct?


> Currently dom0 only updates the Xen wallclock with the 11 min periodic
> work when NTP is synced.  This leaves a window where newly started
> guests will see an incorrect wallclock time.  This can cause guests to
> fail to start correctly if the wallclock is now behind what it was when
> the guest last started. (e.g., fsck of its disk fails as its last mount
> time appears to be far into the future).
>
> Similarly (but less problematic), if a bare metal system is rebooted
> before the RTC is updated it will still have the incorrect time.

So this has been the existing behavior for quite some time. If the RTC 
is misconfigured, it has to be corrected either explicitly by the admin 
via hwclock or by the kernel but only if we're well synced with NTP.



>> You seem to be saying we should always set the RTC any time settimeofday
>> is called (regardless of the NTP sync state), which doesn't seem right
>> to me. Also I worry that this would cause the RTC to be set when the RTC
>> hctosys() code (or hwclock) sets the time to the RTC clock, which is a
>> bit circular.
> I'm not too concerned about the behaviour of manual syncs of the RTC
> because: a) if the kernel does this automatically then the use of manual
> syncs is no longer necessary;

Well, we can't break existing interface behavior. Even if its 
unnecessary at that point.

> and b) the RTC will still end up with the
> correct time.

But this isn't in fact the case. Imagine an networkless embedded system 
that's system clock drifts. Its setup to use a cron job to set the time 
a few times a day to correct this (its a bit naive, I know, but this is 
how these embedded systems often are configured).

The problem is, that every time it uses hwclock --hctosys, we read the 
RTC, and write it to the system time, which will then write that value 
back to the RTC. Since there will be some delay between the RTC read and 
the RTC write, we will inject some slight error into the RTC, such that 
it may be a second behind where it ought to be.

We do this regularly enough, and now the RTC clock is drifting behind.

And sure, this is somewhat of a contrived an example, but we can't break 
folks using these approaches.


So I think the other patches in this series are fine, and should help 
limit the effect of the problematic case of a  mis-configured RTC. But 
this one I don't think we can do reasonably.

If you really feel this tight-binding of the system time and the RTC is 
necessary (if NTP synced or not), you might continue working the 
approach with following modifications:

1) Limit the RTC syncing to settimeofday() and inject_time_offset(). 
Where it is now, we'd call it on every resume from suspend, which would 
cause the same problematic circular RTC drift on systems that do 
frequent suspend/resumes.

2) Modify the logic so we only set the RTC on settimeofday() if the 
current RTC value is more then N seconds off. This would limit the 
circular drift, allowing time being set by the RTC to not result in 
modifying the RTC.


With those two changes you might have a better chance, but I'm still 
hesitant. There may be use cases where the RTC and the system time are 
intentionally kept out of sync.

thanks
-john


