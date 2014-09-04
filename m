Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906AbaIDWYU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 18:24:20 -0400
Received: from www.linutronix.de ([62.245.132.108]:55220 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755343AbaIDWYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 18:24:19 -0400
Date: Fri, 5 Sep 2014 00:24:14 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Paolo Bonzini <pbonzini@redhat.com>
cc: linux-kernel@vger.kernel.org, chris.j.arges@canonical.com,
        kvm@vger.kernel.org, John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH] KVM: x86: fix kvmclock breakage from timers branch
 merge
In-Reply-To: <5408D815.9090105@redhat.com>
Message-ID: <alpine.DEB.2.10.1409050021240.3333@nanos>
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
> 
> I find "offs_boot - offs_real + xtime" more readable than the
> alternative "base_mono + offs_boot + xtime_nsec", so the fix doubles as
> a cleanup for me and I'm fine with it.  But something must be wrong in
> the timekeeping code.

I think I have a vague idea what happened, but I'm way too tired now
to write it up fully. I'll do that tomorrow morning with brain awake.

Thanks,

	tglx


