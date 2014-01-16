Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012AbaAPThU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 14:37:20 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:43820 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751616AbaAPThQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 14:37:16 -0500
Date: Thu, 16 Jan 2014 19:36:52 +0000
From: Will Deacon <will.deacon@arm.com>
To: Robert Richter <rric@kernel.org>
Cc: Weng Meiling <wengmeiling.weng@huawei.com>,
        "oprofile-list@lists.sf.net" <oprofile-list@lists.sf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>,
        "wangnan0@huawei.com" <wangnan0@huawei.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Huang Qiang <h.huangqiang@huawei.com>,
        "sdu.liu@huawei.com" <sdu.liu@huawei.com>
Subject: Re: [PATCH] oprofile: check whether oprofile perf enabled in
 op_overflow_handler()
Message-ID: <20140116193652.GD22105@mudshark.cambridge.arm.com>
References: <52B3F66D.6060707@huawei.com>
 <20140113084555.GU20315@rric.localhost>
 <52D4984B.9090600@huawei.com>
 <20140114150553.GC20315@rric.localhost>
 <52D5EC44.30101@huawei.com>
 <20140115102445.GE20315@rric.localhost>
 <52D73148.4090408@huawei.com>
 <52D7A750.50906@huawei.com>
 <20140116115245.GB8360@rric.localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140116115245.GB8360@rric.localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 16, 2014 at 11:52:45AM +0000, Robert Richter wrote:
> (cc'ing Will)

Thanks Robert,

> On 16.01.14 17:33:04, Weng Meiling wrote:
> > Using the same test case, the problem also exists in the same kernel with the new patch applied:
> > 
> > 
> > # opcontrol --start
> > 
> > Using 2.6+ OProfile kernel interface.
> > Using log file /var/lib/oprofile/samples/oprofiled.log
> > Daemon started.
> > [  508.456878] INFO: rcu_sched self-detected stall on CPU { 0}  (t=2100 jiffies g=685 c=684 q=83)
> > [  571.496856] INFO: rcu_sched self-detected stall on CPU { 0}  (t=8404 jiffies g=685 c=684 q=83)
> > [  634.526855] INFO: rcu_sched self-detected stall on CPU { 0}  (t=14707 jiffies g=685 c=684 q=83)
> 
> Yes, the patch does not prevent an interrupt storm. The same happened
> on x86 and was there solved also by limiting the minimum cycle period
> as the kernel was not able to ratelimit.
> 
> > ARM: events: increase minimum cycle period to 100k
> 
> > -event:0xFF counters:0 um:zero minimum:500 name:CPU_CYCLES : CPU cycle
> > +event:0xFF counters:0 um:zero minimum:100000 name:CPU_CYCLES : CPU cycle
> 
> However, an arbitrary hardcoded value migth not fit for all kind of
> cpus esp. on ARM where the variety is high. It also looks like there
> is no way other than patching the events file to force lower values
> than the minimum on cpus there this might be necessary.

Yeah, it's pretty much impossible to pick a one-size-fits-all value for ARM.

> The problem of too low sample periods could be solved on ARM by using
> perf's interrupt throttling, you might play around with:
> 
>  /proc/sys/kernel/perf_event_max_sample_rate:100000
> 
> I am not quite sure whether this works esp. for kernel counters and
> how userland can be notified about throttling. Throttling could be
> worth for operf too, not only for the oprofile kernel driver.
> 
> From a quick look it seems there is also code in x86 that dynamically
> adjusts the rate which might be worth being implemented for ARM too.

Are you referring to the perf_sample_event_took callback? If so, that
certainly looks worth persuing. I'll stick it on my list, thanks!

Will
