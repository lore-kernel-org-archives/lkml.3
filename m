Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199AbaLAQPu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 11:15:50 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:51876 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890AbaLAQPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 11:15:48 -0500
Date: Mon, 1 Dec 2014 17:15:45 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Wu Fengguang <fengguang.wu@intel.com>, Ingo Molnar <mingo@kernel.org>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [RFC PATCH 24/30] cputime: Increment kcpustat directly on
 irqtime account
Message-ID: <20141201161543.GB27302@lerouge>
References: <1417199040-21044-1-git-send-email-fweisbec@gmail.com>
 <1417199040-21044-25-git-send-email-fweisbec@gmail.com>
 <20141201154128.2cbe08b0@mschwide>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141201154128.2cbe08b0@mschwide>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2014 at 03:41:28PM +0100, Martin Schwidefsky wrote:
> On Fri, 28 Nov 2014 19:23:54 +0100
> Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > The irqtime is accounted is nsecs and stored in
> > cpu_irq_time.hardirq_time and cpu_irq_time.softirq_time. Once the
> > accumulated amount reaches a new jiffy, this one gets accounted to the
> > kcpustat.
> > 
> > This was necessary when kcpustat was stored in cputime_t, which could at
> > worst have a jiffies granularity. But now kcpustat is stored in nsecs
> > so this whole discretization game with temporary irqtime storage has
> > become unnecessary.
> > 
> > We can now directly account the irqtime to the kcpustat.
> 
> Isn't the issue here that two different approaches to cputime accounting
> get mixed here? On the one hand a cputime_t based on jiffies and on the
> other CONFIG_IRQ_TIME_ACCOUNTING which uses sched_clock_cpu() to create
> the accounting deltas.

There is no other way really because cputime_t can wrap very low granularity
time unit such as jiffies. And there is no way to account irqtime with jiffies
since IRQ duration is supposed to be below 1 ms.

So irqtime is accounted with a high precision clock, nsecs based and periodically
accounted as cputime_t once we accumulate enough for a cputime_t unit.

And turning cputime_t to nsecs simplifies that.
