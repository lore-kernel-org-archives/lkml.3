Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071AbaBNMx2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 07:53:28 -0500
Received: from www.linutronix.de ([62.245.132.108]:41536 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbaBNMx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 07:53:27 -0500
Date: Fri, 14 Feb 2014 13:53:25 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Nicholas Mc Guire <der.herr@hofr.at>
Cc: linux-rt-users@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, Carsten Emde <C.Emde@osadl.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andreas Platschek <platschek@ict.tuwien.ac.at>
Subject: Re: [PATCH RT 2/5] allow preemption in alloc and free _buffer_head
Message-ID: <20140214125325.GD28438@linutronix.de>
References: <20140210153759.GC20017@opentech.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140210153759.GC20017@opentech.at>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nicholas Mc Guire | 2014-02-10 16:37:59 [+0100]:

>2a) premption induced race in __this_cpu_dec
>  T1 dec:start
>               T2 dec
>  T1 dec:end
>
>__this_cpu_dec 
>  -> __this_cpu_sub 
>    -> __this_cpu_add
>      -> __this_cpu_add_#
>        -> __this_cpu_generic_to_op
>         -> __this_cpu_ptr += val
>
>
>so we end up with the possibilities of
>  T1 load
>          T2 load
>          T2 store
>  T1 store
>and the increment provided by T2 would be lost. The result of which
>is that reaching the buffer_heads_over_limit threshold in recalc_bh_state 

I don't like this very much. __this_cpu_inc() is not atomic as you say
and without the locking that is provided by preempt_disable() it might
lose one store in inc or dec direction. This error will never be
corrected again. That code path looks very short unless you have 4096
CPUs.

Sebastian
