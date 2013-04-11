Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161079Ab3DKIgF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 04:36:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56675 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753853Ab3DKIgC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 04:36:02 -0400
Date: Thu, 11 Apr 2013 10:36:35 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, hpa@zytor.com,
        rostedt@goodmis.org, akpm@linux-foundation.org, tglx@linutronix.de,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 4/4] cputime: remove scaling
Message-ID: <20130411083634.GB1380@redhat.com>
References: <1364489605-5443-1-git-send-email-sgruszka@redhat.com>
 <1364489605-5443-5-git-send-email-sgruszka@redhat.com>
 <20130410120228.GC8083@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130410120228.GC8083@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 02:02:28PM +0200, Ingo Molnar wrote:
> 
> * Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> 
> > Scaling cputime cause problems, bunch of them was fixed, but still is possible 
> > to hit multiplication overflow issue, which make {u,s}time values incorrect. 
> > This problem has no good solution in kernel.
> 
> Wasn't 128-bit math a solution to the overflow problems? 128-bit math isn't nice, 
> but at least for multiplication it's defensible.

128 bit division is needed unfortunately. Though on 99.9% of cases, it will go
through 64 bit fast path.

> > This patch remove scaling code and export raw values of {u,t}ime . Procps 
> > programs can use newly introduced sum_exec_runtime to find out precisely 
> > calculated process cpu time and scale utime, stime values accordingly.
> > 
> > Unfortunately times(2) syscall has no such option.
> > 
> > This change affect kernels compiled without CONFIG_VIRT_CPU_ACCOUNTING_*.
> 
> So, the concern here is that 'top hiding' code can now hide again. It's also that 
> we are not really solving the problem, we are pushing it to user-space - which in 
> the best case gets updated to solve the problem in some similar fashion - and in 
> the worst case does not get updated or does it in a buggy way.
>
> So while user-space has it a bit easier because it can do floating point math, is 
> there really no workable solution to the current kernel side integer overflow bug? 

I do not see any. Basically all we have make problem less reproducible
or just defer it. The best solution, except full 128 bit math I found
is something like this (dropping precision if values are big and overflow
will happen):

u64 _scale_time(u64 rtime, u64 total, u64 time)
{
        const int zero_bits = clzll(time) + clzll(rtime);
        u64 scaled;

        if (zero_bits < 64) {
                /* Drop precision */
                const int drop_bits = 64 - zero_bits;

                time >>= drop_bits;
                rtime >>= drop_bits;
                total >>= 2*drop_bits;

                if (total == 0)
                        return time;
        }

        scaled = (time * rtime) / total;

        return scaled;
}

It defer problem to quite long period. My testing script detect failure at:

FAIL!
rtime: 1954463459156 <- 22621 days (one thread , CONFIG_HZ=1000) 
total: 1771603722423
stime: 354320744484
kernel: 391351504748 <- kernel value
python: 390892691830 <- correct value

For one thread this is fine, but for 512 threads inaccuracy will happen
after only 40 days (due to dropping too many of "total" variable bits).

> I really prefer robust kernel side accounting/instrumentation.

We have CONFIG_IRQ_TIME_ACCOUNTING and CONFIG_VIRT_CPU_ACCOUNTING_GEN.
Perhaps we can change to use one of those options by default. I wonder
if the additional performance cost related with them is really something
that we should care about. Are there any measurement that show those
will make performance worse ?

Stanislaw
