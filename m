Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757473AbaDWIKh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 04:10:37 -0400
Received: from www.linutronix.de ([62.245.132.108]:53646 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435AbaDWIK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 04:10:26 -0400
Message-ID: <53577559.9090501@linutronix.de>
Date: Wed, 23 Apr 2014 10:10:01 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.4.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>
CC: Stanislav Meduna <stano@meduna.org>,
        "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: BUG: spinlock trylock failure on UP, i.MX28 3.12.15-rt25
References: <534C3606.7010206@meduna.org> <534C731F.1050406@meduna.org> <534DADF1.6060608@meduna.org> <20140422115439.GA20669@linutronix.de> <20140422094657.5b6ca1e2@gandalf.local.home> <20140422140918.GE11096@twins.programming.kicks-ass.net>
In-Reply-To: <20140422140918.GE11096@twins.programming.kicks-ass.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2014 04:09 PM, Peter Zijlstra wrote:
> On Tue, Apr 22, 2014 at 09:46:57AM -0400, Steven Rostedt wrote:
>>>  According to lockdep a trylock should not fail on UP.
> 
> Oh!? Where does it say that? A trylock can fail at all times.

kernel/locking/spinlock_debug.c:

int do_raw_spin_trylock(raw_spinlock_t *lock)
 {
         int ret = arch_spin_trylock(&lock->raw_lock);

         if (ret)
                 debug_spin_lock_after(lock);
 #ifndef CONFIG_SMP
         /*
          * Must not happen on UP:
          */
         SPIN_BUG_ON(!ret, lock, "trylock failure on UP");
 #endif
         return ret;
 }

How can a trylock (spinlock, not mutex) fail on UP? That would mean the
lock is not interrupt safe.
Unless, you attempt to take the lock from interrupt context via trylock
while in general you take the spinlock in process context with
interrupts enabled.

Sebastian
