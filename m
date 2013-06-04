Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759127Ab3FDBXY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 21:23:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39953 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757521Ab3FDBXX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 21:23:23 -0400
Date: Mon, 3 Jun 2013 22:22:58 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: John Stultz <john.stultz@linaro.org>, xen-devel@lists.xen.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86/xen: sync the wallclock when the system time
 changes
Message-ID: <20130604012258.GA15545@amt.cnet>
References: <1369765368-10823-1-git-send-email-david.vrabel@citrix.com>
 <1369765368-10823-3-git-send-email-david.vrabel@citrix.com>
 <51A4FD47.2030301@linaro.org>
 <51A5CD6C.8020908@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51A5CD6C.8020908@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 29, 2013 at 10:42:04AM +0100, David Vrabel wrote:
> On 28/05/13 19:53, John Stultz wrote:
> > On 05/28/2013 11:22 AM, David Vrabel wrote:
> >> From: David Vrabel <david.vrabel@citrix.com>
> >>
> >> Currently the Xen wallclock is only updated every 11 minutes if NTP is
> >> synchronized to its clock source.  If a guest is started before NTP is
> >> synchronized it may see an incorrect wallclock time.
> >>
> >> Use the pvclock_gtod notifier chain to receive a notification when the
> >> system time has changed and update the wallclock to match.
> >>
> >> This chain is called on every timer tick and we want to avoid an extra
> >> (expensive) hypercall on every tick.  Because dom0 has historically
> >> never provided a very accurate wallclock and guests do not expect one,
> >> we can do this simply.  The wallclock is only updated if the
> >> difference between now and the last update is more than 0.5 s.
> [...]
> >> index 4656165..81027b5 100644
> >> --- a/arch/x86/xen/time.c
> >> +++ b/arch/x86/xen/time.c
> [...]
> >> +    struct xen_platform_op op;
> >> +    int ret;
> >> +
> >> +    /*
> >> +     * Set the Xen wallclock from Linux system time.
> >> +     *
> >> +     * dom0 hasn't historically maintained a very accurate
> >> +     * wallclock so guests don't expect it. We can therefore
> >> +     * reduce the number of expensive hypercalls by only updating
> >> +     * the wallclock every 0.5 s.
> >> +     */
> >> +
> >> +    now.tv_sec = tk->xtime_sec;
> >> +    now.tv_nsec = tk->xtime_nsec >> tk->shift;
> > 
> > You probably want current_kernel_time() here.
> 
> Ah. I was looking for something like this but since the notifier chain
> is called with various locks held stuff kept deadlocking.  It looks like
> I can use __current_kernel_time() though.
> 
> >> +
> >>  +    if (timespec_compare(&now, &last) > 0
> >> +        && timespec_compare(&now, &next) < 0)
> >> +        return 0;
> >> +
> >>       op.cmd = XENPF_settime;
> >> -    op.u.settime.secs = now->tv_sec;
> >> -    op.u.settime.nsecs = now->tv_nsec;
> >> +    op.u.settime.secs = now.tv_sec;
> >> +    op.u.settime.nsecs = now.tv_nsec;
> >>       op.u.settime.system_time = xen_clocksource_read();
> >>         ret = HYPERVISOR_dom0_op(&op);
> >>       if (ret)
> >> -        return ret;
> >> +        return 0;
> >>   -    /* Set the hardware RTC. */
> >> -    return mach_set_rtc_mmss(now);
> >> +    last = now;
> >> +    next = timespec_add(now, ns_to_timespec(NSEC_PER_SEC / 2));
> >>   
> > 
> > Am I missing the xen_set_wallclock hook here? Your previous patch wanted
> > to call the dom0 op and then set the hardware RTC.
> 
> As Jan says, this is deliberate.  We now update the hardware CMOS RTC in
> the same way as bare metal and then use this notifier to only maintain
> the Xen wallclock for guests.
> 
> > And this notifier get called every timer tick? This seems out there...
> 
> This notifier was added to support similar functionality for KVM and I'm
> just reusing what's there.
> 
> See e0b306fef (time: export time information for KVM pvclock) [1] and
> 16e8d74d2 (KVM: x86: notifier for clocksource changes) [2].
> 
> Perhaps Marcelo can comment on why it was necessary for this to be
> called on every timer tick.

Just so to maintain similarity with the vsyscall notifier (as in updates
all fields the vsyscall notifier uses).

KVM only actually makes use of the clocksource change case.

