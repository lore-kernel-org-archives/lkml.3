Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752441Ab3KYAnJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 19:43:09 -0500
Received: from mout.gmx.net ([212.227.17.22]:59911 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752068Ab3KYAnG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 19:43:06 -0500
Date: Mon, 25 Nov 2013 01:43:02 +0100
From: Christian Engelmayer <cengelma@gmx.at>
To: Stanislaw Gruszka <sgruszka@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, fweisbec@gmail.com,
        Paul Turner <pjt@google.com>
Subject: Re: [PROBLEM] possible divide by 0 in kernel/sched/cputime.c
 scale_stime()
Message-ID: <20131125014302.6a4394ce@spike>
In-Reply-To: <20131120120815.GA12860@redhat.com>
References: <20131116223740.3cd579cb@spike>
	<20131118140224.GA3330@redhat.com>
	<20131118172706.GI3866@twins.programming.kicks-ass.net>
	<20131120120815.GA12860@redhat.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:/yHvoMcrtkXYIpgLnxDHV1eq0+63XGynvRHLJZHIomxR4gTL0v8
 smo2fsS0n5FIe+EBVsbnOz8LmM/7EweG2atYeaGQnUTCYn/HefxaRkstYXF5gnImG3W4hSd
 Cnw6AMIaA4qw5bk6/DsI10gHehXaOLwfX/JbVtuR4FnuMjqJa2/e3vhCuFQhohJkbfdcU9Z
 F6sPuEs5KYro1tr76K+6A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Nov 2013 18:27:06 +0100, Peter Zijlstra <peterz@infradead.org> wrote:
> That is not actually correct in the case time wraps.
> 
> There's a further problem with this code though -- ever since Frederic
> added NO_HZ_FULL a CPU can in fact aggregate a runtime delta larger than
> 4 seconds, due to running without a tick.
> 
> Therefore we need to be able to deal with u64 deltas.
> 
> The below is a compile tested only attempt to deal with both these
> problems. Comments?

I had this patch applied during daily use. No systematic testing, but no user
perceived regressions either. The originally reported divide by 0 scenario
could no longer be reproduced with this change.

> +/* 
> + * delta_exec * weight / lw.weight
> + *   OR
> + * (delta_exec * (weight * lw->inv_weight)) >> WMULT_SHIFT
> + *
> + * Either weight := NICE_0_LOAD and lw \e prio_to_wmult[], in which case
> + * we're guaranteed shift stays positive because inv_weight is guaranteed to
> + * fit 32 bits, and NICE_0_LOAD gives another 10 bits; therefore shift >= 22.
> + *
> + * Or, weight =< lw.weight (because lw.weight is the runqueue weight), thus
> + * XXX mind got twisted, but I'm fairly sure shift will stay positive.
> + *
> + */
> +static u64 __calc_delta(u64 delta_exec, unsigned long weight, struct load_weight *lw)

The patch itself seems comprehensible to me, although I have to admit that I
would have to read into the code more deeply in order to understand why the
changed __calc_delta() will always prove correct.

On Mon, 18 Nov 2013 15:19:56 +0100, Peter Zijlstra <peterz@infradead.org> wrote:
> I'm not sure what tool you used to generate that, but its broken, that's
> model 0x25 (37), it somehow truncates the upper model bits.

Correct, that was the fairly outdated cpuid (http://www.ka9q.net/code/cpuid)
currently shipped with Ubuntu 13.10. Debian already switched to packaging a
maintained version (http://www.etallen.com/cpuid.html).

> That said, its a westmere core and I've seen wsm-ep (dual socket)
> machines loose their TSC sync quite regularly, but this would be the
> first case a single socket wsm would loose its TSC sync.
>
> That leads me to believe your BIOS is screwing you over with SMIs or the
> like.

Having rechecked the running microcode as hinted by Henrique de Moraes Holschuh
off-list and running the Intel BIOS Implementation Test Suite (http://biosbits.org)
that seems to be an educated guess.

Regards,
Christian
