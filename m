Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437AbaIESd2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 14:33:28 -0400
Received: from www.linutronix.de ([62.245.132.108]:33464 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302AbaIESd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 14:33:26 -0400
Date: Fri, 5 Sep 2014 20:33:22 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Paolo Bonzini <pbonzini@redhat.com>
cc: linux-kernel@vger.kernel.org, chris.j.arges@canonical.com,
        kvm@vger.kernel.org, John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH] KVM: x86: fix kvmclock breakage from timers branch
 merge
In-Reply-To: <5409E755.4040905@redhat.com>
Message-ID: <alpine.DEB.2.10.1409052031140.5472@nanos>
References: <1409835487-14371-1-git-send-email-pbonzini@redhat.com> <alpine.DEB.2.10.1409042230020.3333@nanos> <5408D815.9090105@redhat.com> <alpine.DEB.2.10.1409050000570.3333@nanos> <5409E755.4040905@redhat.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Sep 2014, Paolo Bonzini wrote:

> Il 05/09/2014 17:14, Thomas Gleixner ha scritto:
> > So that means the code is correct. Now where is the bug?
> 
> In kernel/time/timekeeping.c?
> 
> We know that we should have
> 
>   base_mono             =     wall_to_monotonic + xtime_sec
> 
> Instead it is
> 
>   base_mono             = wall_to_monotonic + xtime_sec
>                           - seconds from boot time
> 
> which is... zero.  Given this is the only use of base_mono in a
> notifier, I wonder if it is as simple as this (which I don't have time
> to test right now):
> 
> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index fb4a9c2cf8d9..f6807a85b8c9 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -443,9 +443,9 @@ static void timekeeping_update(struct timekeeper
> *tk, unsigned int action)
>  		ntp_clear();
>  	}
>  	update_vsyscall(tk);
> -	update_pvclock_gtod(tk, action & TK_CLOCK_WAS_SET);
> 
>  	tk_update_ktime_data(tk);
> +	update_pvclock_gtod(tk, action & TK_CLOCK_WAS_SET);

Why are you moving the update between vsycall and pvclock update as I
did in my patch? We really need to update everything before calling
somewhere.
 
And yes it is that simple. I instrumented the stuff and its correct
now.

Thanks

	tglx
