Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511AbaIDU6q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 16:58:46 -0400
Received: from www.linutronix.de ([62.245.132.108]:54833 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755457AbaIDU6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 16:58:43 -0400
Date: Thu, 4 Sep 2014 22:58:40 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Paolo Bonzini <pbonzini@redhat.com>
cc: linux-kernel@vger.kernel.org, chris.j.arges@canonical.com,
        kvm@vger.kernel.org, John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH] KVM: x86: fix kvmclock breakage from timers branch
 merge
In-Reply-To: <1409835487-14371-1-git-send-email-pbonzini@redhat.com>
Message-ID: <alpine.DEB.2.10.1409042230020.3333@nanos>
References: <1409835487-14371-1-git-send-email-pbonzini@redhat.com>
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
> based, 2014-07-16) forgot to add tk->xtime_sec, thus breaking kvmclock on

Errm. How is boottime related to xtime_sec?

> hosts that have a reliable TSC.  Add it back; and since the field boot_ns
> is not anymore related to the host boot-based clock, rename boot_ns->nsec_base
> and the existing nsec_base->snsec_base.

This is simply wrong.

The original code before that changed did:

       vdata->monotonic_time_sec       = tk->xtime_sec
                                       + tk->wall_to_monotonic.tv_sec;
       vdata->monotonic_time_snsec     = tk->xtime_nsec
                                       + (tk->wall_to_monotonic.tv_nsec
                                               << tk->shift);
So this is the momentary monotonic base time

And the readout function did:

       ts->tv_nsec = 0;
       do {
               seq = read_seqcount_begin(&gtod->seq);
               mode = gtod->clock.vclock_mode;
               ts->tv_sec = gtod->monotonic_time_sec;
               ns = gtod->monotonic_time_snsec;
               ns += vgettsc(cycle_now);
               ns >>= gtod->clock.shift;
        } while (unlikely(read_seqcount_retry(&gtod->seq, seq)));
       timespec_add_ns(ts, ns);

So this does:

   now = monotonic_base + delta_nsec

And the caller converted it to boot time with:

       monotonic_to_bootbased(&ts);

So the time calculation does:

  now = monotonic_base + delta_nsec + mono_to_boot

Because:     monotonic_base + mono_to_boot = boot_time_base
 
The calculation can be written as:

  now = boot_time_base + delta_nsec


The new code does

    boot_ns = ktime_to_ns(ktime_add(tk->base_mono, tk->offs_boot));

So thats

   boot_time_base = monotonic_base + mono_to_boot;

    vdata->boot_ns                  = boot_ns;
    vdata->nsec_base                = tk->tkr.xtime_nsec;

And the readout does:

    do {
           seq = read_seqcount_begin(&gtod->seq);
           mode = gtod->clock.vclock_mode;
     	   ns = gtod->nsec_base;
           ns += vgettsc(cycle_now);
           ns >>= gtod->clock.shift;
           ns += gtod->boot_ns;
   } while (unlikely(read_seqcount_retry(&gtod->seq, seq)));
   *t = ns;

Which is:

   boot_time_base + delta_nsec

Now I have no idea why you think it needs to add xtime_sec. If the
result is wrong, then we need to figure out which one of the supplied
values is wrong and not blindly add xtime_sec just because that makes
it magically correct.

Can you please provide a proper background why you think that adding
xtime_sec is a good idea?

Thanks,

	tglx


