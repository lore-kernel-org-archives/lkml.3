Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803Ab3FXK7U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 06:59:20 -0400
Received: from smtp.citrix.com ([66.165.176.89]:20998 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752208Ab3FXKvX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 06:51:23 -0400
X-IronPort-AV: E=Sophos;i="4.87,928,1363132800"; 
   d="scan'208";a="32984726"
Message-ID: <51C824A8.1080305@citrix.com>
Date: Mon, 24 Jun 2013 11:51:20 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120428 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: <xen-devel@lists.xen.org>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 2/4] time: add a notifier chain for when the system time
 is stepped
References: <1371755792-25962-1-git-send-email-david.vrabel@citrix.com> <1371755792-25962-3-git-send-email-david.vrabel@citrix.com> <alpine.DEB.2.02.1306210953480.4013@ionos.tec.linutronix.de> <51C44A09.9010402@citrix.com> <alpine.DEB.2.02.1306212328350.4013@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1306212328350.4013@ionos.tec.linutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/06/13 00:06, Thomas Gleixner wrote:
> On Fri, 21 Jun 2013, David Vrabel wrote:
>> On 21/06/13 08:57, Thomas Gleixner wrote:
>>> On Thu, 20 Jun 2013, David Vrabel wrote:
>>>
>>>> From: David Vrabel <david.vrabel@citrix.com>
>>>>
>>>> The high resolution timer code gets notified of step changes to the
>>>> system time with clock_was_set() or clock_was_set_delayed() calls.  If
>>>> other parts of the kernel require similar notification there is no
>>>> clear place to hook into.
>>>
>>> You fail to explain why any other part of the kernel requires a
>>> notification.
>>
>> This is needed by patch 3 in this series.
>>
>> "The Xen wallclock is a software only clock within the Xen hypervisor
>> that is used by: a) PV guests as the equivalent of a hardware RTC; and
>> b) the hypervisor as the clock source for the emulated RTC provided to
>> HVM guests.
>>
>> Currently the Xen wallclock is only updated every 11 minutes if NTP is
>> synchronized to its clock source.  If a guest is started before NTP is
>> synchronized it may see an incorrect wallclock time.
> 
> What you are saying is, that you are fixing Xens failure to implement
> a proper RTC emulation by hacking a notifier into the core code. You
> can't be serious about that.

Xen does provide proper emulation of an RTC for guests.  Both full
hardware emulation for fully-virtualized guest (HVM) and a lighter
weight interface for paravirtualized guests (PV).

As with any emulated RTC, there needs to be underlying clocksource
providing the time.  Under Xen, this is the Xen wallclock and it is
implemented as a record of the date/time timestamped with the
corresponding Xen clocksource value[1].

KVM provides an identical wallclock to its guests -- see the common
pvclock_read_wallclock() function.

Xen has hardware drivers for only the minimal amount of hardware
necessary for the scheduling and isolation of guests.  It does not have
drivers for any hardware RTC nor does it have a network stack or an
implementation of NTP.  Therefore it has no way to maintain the
correctness of the Xen wallclock and relies on the control domain (dom0)
to do this.

Dom0 updates the Xen wallclock with the XENPF_settime platform_op hypercall.

To ensure the correctness of the Xen wallclock it is kept in sync with
dom0's system time (which is assumed to be correct and would typically
be corrected by NTP).

This requires that the Xen wallclock is both:

a) updated on step changes to system time.
b) updated periodically to correct for any drift.

This behaviour (keeping the wallclock in sync with dom0 system time) is
part of the ABI provided by the kernel and changing it would break
existing user space.

This patch set is fixing the rare case where a guest is started before
NTP has synced and thus sees an incorrect wallclock time which may cause
the guest to fail to boot.

> According to your changelog:
> 
>   Currently the Xen wallclock is only updated every 11 minutes if NTP is
>   synchronized to its clocksource.
> 
> How is that related to clock_was_set() ?

It's not. This is the update_persistent_clock() call from the periodic
sync_cmos_clock() work.

> clock_was_set*() is invoked from:
> 
> 	do_settimeofday()
> 	timekeeping_inject_offset()
> 	timekeeping_set_tai_offset()
> 	timekeeping_inject_sleeptime()
> 	update_wall_time()
> 	do_adjtimex()
> 
> The only function which calls clock_was_set() and can affect RTC is
> do_adjtimex(). Though you claim that the natural place to add a
> notifier is clock_was_set().
> 
> So you went the other way round this time. In the hrtimers case you
> tried to fix shortcomings of the core code in some random Xen
> code. With this patch you try to fix Xen nonsense in the core code.

KVM uses a very similar mechanism to maintain system time for a guest so
guest system time is synchronized with host system time.  See the
pvclock_gtod notifier chain and its usage in arch/x86/kvm/x86.c.

v3 of this series did use this existing notifier but it is called on
every timer tick so this is more expensive than necessary to meet the
requirements (see (a) and (b) above) for maintaining the Xen wallclock.
 John suggested hooking into clock_was_set().

> Can you please provide a proper explanation of the problem you are
> trying to solve? This means that you should explain the semantics of
> the desired XEN RTC emulation and not the desired workarounds to fix
> the shortcommings current implementation.

In summary, both Xen and KVM need to solve similar problems with keeping
time synchronized between a host and guests.

The key difference between the two hypervisors is that Xen synchronizes
the wallclock and KVM synchronizes system time.

David

[1] The Xen clocksource is monotonic, nanosecond resolution clocksource
provided by Xen for use internally and by guests.
