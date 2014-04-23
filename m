Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872AbaDWIuk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 04:50:40 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:43837 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709AbaDWIuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 04:50:35 -0400
Date: Wed, 23 Apr 2014 10:50:31 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>, Stanislav Meduna <stano@meduna.org>,
        "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: BUG: spinlock trylock failure on UP, i.MX28 3.12.15-rt25
Message-ID: <20140423085031.GI11096@twins.programming.kicks-ass.net>
References: <534C3606.7010206@meduna.org>
 <534C731F.1050406@meduna.org>
 <534DADF1.6060608@meduna.org>
 <20140422115439.GA20669@linutronix.de>
 <20140422094657.5b6ca1e2@gandalf.local.home>
 <20140422140918.GE11096@twins.programming.kicks-ass.net>
 <53577559.9090501@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53577559.9090501@linutronix.de>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 10:10:01AM +0200, Sebastian Andrzej Siewior wrote:
> On 04/22/2014 04:09 PM, Peter Zijlstra wrote:
> > On Tue, Apr 22, 2014 at 09:46:57AM -0400, Steven Rostedt wrote:
> >>>  According to lockdep a trylock should not fail on UP.
> > 
> > Oh!? Where does it say that? A trylock can fail at all times.
> 
> kernel/locking/spinlock_debug.c:
> 
> int do_raw_spin_trylock(raw_spinlock_t *lock)
>  {
>          int ret = arch_spin_trylock(&lock->raw_lock);
> 
>          if (ret)
>                  debug_spin_lock_after(lock);
>  #ifndef CONFIG_SMP
>          /*
>           * Must not happen on UP:
>           */
>          SPIN_BUG_ON(!ret, lock, "trylock failure on UP");
>  #endif
>          return ret;
>  }
> 
> How can a trylock (spinlock, not mutex) fail on UP? That would mean the
> lock is not interrupt safe.
> Unless, you attempt to take the lock from interrupt context via trylock
> while in general you take the spinlock in process context with
> interrupts enabled.

But that's not lockdep. That's the spinlock debugging code, entirely
different beasts.
