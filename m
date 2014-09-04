Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755613AbaIDV1y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 17:27:54 -0400
Received: from www.linutronix.de ([62.245.132.108]:55002 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754910AbaIDV1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 17:27:52 -0400
Date: Thu, 4 Sep 2014 23:27:49 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Paolo Bonzini <pbonzini@redhat.com>
cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        chris.j.arges@canonical.com, John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH] KVM: x86: fix kvmclock breakage from timers branch
 merge
In-Reply-To: <1409864744-26417-1-git-send-email-pbonzini@redhat.com>
Message-ID: <alpine.DEB.2.10.1409042317560.3333@nanos>
References: <1409864744-26417-1-git-send-email-pbonzini@redhat.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Sep 2014, Paolo Bonzini wrote:

> Commit cbcf2dd3b3d4 (x86: kvm: Make kvm_get_time_and_clockread() nanoseconds
> based, 2014-07-16) used the wrong formula for boot_ns, thus breaking kvmclock on
> hosts that have a reliable TSC.
> 
> To find the right formula, let's first backport the switch to nanoseconds
> to 3.16-era timekeeping logic.  The full patch (which works) is at
> https://lkml.org/lkml/2014/9/4/462.  The key line here is
> 
>         boot_ns = timespec_to_ns(&tk->total_sleep_time)
>                 + timespec_to_ns(&tk->wall_to_monotonic)
>                 + tk->xtime_sec * (u64)NSEC_PER_SEC;
> 
> Because the above patch works, the conclusion is that the above formula
> is not the same as commit cbcf2dd3b3d4's
> 
>         boot_ns = ktime_to_ns(ktime_add(tk->tkr.base_mono, tk->offs_boot));
> 
> As to what is the right one, commit 02cba1598a2a (timekeeping: Simplify getboottime(),
> 2014-07-16) provides a hint:
> 
>    offs_real             = -wall-to_monotonic
>    offs_boot             =  total_sleep_time
> 
>    offs_real - offs_boot = -wall_to_monotonic - total_sleep_time
> 
> that is
> 
>    offs_boot - offs_real =  wall_to_monotonic + total_sleep_time
> 
> which is what this patch uses, adding xtime_sec separately.  The "boot_ns"
> moniker is not too clear, so rename boot_ns to nsec_base and the existing
> nsec_base to snsec_base.
> 
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: John Stultz <john.stultz@linaro.org>
> Reported-by: Chris J Arges <chris.j.arges@canonical.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
> 	Thomas/John, the problem with the above explanation is that
> 	tk_update_ktime_data has "base_mono = xtime_sec + wtm", and from
> 	there "base_mono + offs_boot = xtime_sec + wtm + total_sleep_time".
> 	Except that doesn't work, so something must be wrong in
> 	tk_update_ktime_data's comment.

Right. I'm staring into it and we need to fix the core code issue and
not the usage site.

Thanks,

	tglx
