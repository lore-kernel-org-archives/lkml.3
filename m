Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858AbaIEPOo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 11:14:44 -0400
Received: from www.linutronix.de ([62.245.132.108]:60509 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177AbaIEPOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 11:14:42 -0400
Date: Fri, 5 Sep 2014 17:14:38 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Paolo Bonzini <pbonzini@redhat.com>
cc: linux-kernel@vger.kernel.org, chris.j.arges@canonical.com,
        kvm@vger.kernel.org, John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH] KVM: x86: fix kvmclock breakage from timers branch
 merge
In-Reply-To: <5408D815.9090105@redhat.com>
Message-ID: <alpine.DEB.2.10.1409050000570.3333@nanos>
References: <1409835487-14371-1-git-send-email-pbonzini@redhat.com> <alpine.DEB.2.10.1409042230020.3333@nanos> <5408D815.9090105@redhat.com>
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

> Il 04/09/2014 22:58, Thomas Gleixner ha scritto:
> > This is simply wrong.
> 
> It is.
> 
> > Now I have no idea why you think it needs to add xtime_sec. If the
> > result is wrong, then we need to figure out which one of the supplied
> > values is wrong and not blindly add xtime_sec just because that makes
> > it magically correct.
> > 
> > Can you please provide a proper background why you think that adding
> > xtime_sec is a good idea?
> 
> It's not a good idea indeed.  I didn't fully digest the 3.16->3.17
> timekeeping changes and messed up this patch.
> 
> However, there is a bug in the "base_mono + offs_boot" formula, given
> that:
> 
> - bisection leads to the merge commit of John's timers branch
> 
> - bisecting within John's timers branch, with a KVM commit on top to
>   make the code much easier to trigger, leads to commit cbcf2dd3b3d4
>   (x86: kvm: Make kvm_get_time_and_clockread() nanoseconds based,
>   2014-07-16).
> 
> - I backported your patch to 3.16, using wall_to_monotonic +
>   total_sleep_time + xtime_sec (wtm+xtime_sec as in pre-cbcf2dd3b3d4
>   code, total_sleep_time from 3.16 monotonic_to_bootbased) and it works
> 
> - In v2 of the patch I fixed the bug by changing the formula
>   "base_mono + offs_boot" to "offs_boot - offs_real" (and then adding
>   xtime_sec separately as in the 3.16 backport), but the two formulas
>   "base_mono + offs_boot" and "offs_boot - offs_real + xtime_sec" ought
>   to be identical.

So lets look at the differences here:

3.16	     	       	    	    3.17

inject_sleeptime(delta)		    inject_sleeptime(delta)

    xtime += delta;			xtime += delta;

    wall_to_mono -= delta;		wall_to_mono -= delta;
    offs_real = -wall_to_mono;		offs_real = -wall_to_mono;

    sleeptime += delta;
    offs_boot = sleeptime;		offs_boot += delta;

getboottime()

    tmp = wall_to_mono + sleeptime;
    boottime = -tmp;

  So:
    boottime = -wall_to_mono - sleeptime;

  Because of the above:
    offs_real = -wall_to_mono;
    offs_boot = sleeptime;

  The result is:

  boottime = offs_real - offs_boot;	  boottime = offs_real - offs_boot;

monotomic_to_bootbased(mono)		monotomic_to_bootbased(mono)

   return mono + sleeptime;

  Because of the above:
    offs_boot = sleeptime;

  The result is:

    return mono + offs_boot;		  return mono + offs_boot;
  
Now on KVM side he have

update_pvclock_gtod()			update_pvclock_gtod()

    mono_base = xtime + wall_to_mono;	   boot_base = mono_base + offs_boot;

and

do_monotonic()				do_monotonic_boot()

    mono_now = mono_base + delta_ns;	   boot_now = boot_base + delta_ns;

kvm_get_time_and_clockread()

    mono_now = do_monotonic()

    boot_now = mono_to_boot(mono_now);

So that means on both side the same:

   boot_now = mono_base + offs_boot + delta_ns;

So that means the code is correct. Now where is the bug?

Well hidden and still so obvious that it's even visible through the
brown paperpag I'm wearing ...

Thanks,

	tglx

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index fb4a9c2cf8d9..ec1791fae965 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -442,11 +442,12 @@ static void timekeeping_update(struct timekeeper *tk, unsigned int action)
 		tk->ntp_error = 0;
 		ntp_clear();
 	}
-	update_vsyscall(tk);
-	update_pvclock_gtod(tk, action & TK_CLOCK_WAS_SET);
 
 	tk_update_ktime_data(tk);
 
+	update_vsyscall(tk);
+	update_pvclock_gtod(tk, action & TK_CLOCK_WAS_SET);
+
 	if (action & TK_MIRROR)
 		memcpy(&shadow_timekeeper, &tk_core.timekeeper,
 		       sizeof(tk_core.timekeeper));

