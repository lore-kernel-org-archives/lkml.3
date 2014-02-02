Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751645AbaBBJEL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 04:04:11 -0500
Received: from mail-ee0-f44.google.com ([74.125.83.44]:41682 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbaBBJED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 04:04:03 -0500
Date: Sun, 2 Feb 2014 10:03:57 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Waiman Long <waiman.long@hp.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, aswin@hp.com,
        Scott J Norton <scott.norton@hp.com>
Subject: Re: [PATCH v11 0/4] Introducing a queue read/write lock
 implementation
Message-ID: <20140202090357.GA1006@gmail.com>
References: <1390537731-45996-1-git-send-email-Waiman.Long@hp.com>
 <20140130130453.GB2936@laptop.programming.kicks-ass.net>
 <20140130151715.GA5126@laptop.programming.kicks-ass.net>
 <20140131092616.GC5126@laptop.programming.kicks-ass.net>
 <52EBF276.1020505@hp.com>
 <20140131201401.GD2936@laptop.programming.kicks-ass.net>
 <52EC110D.4030509@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52EC110D.4030509@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Waiman Long <waiman.long@hp.com> wrote:

> How about making the selection of MCS or ticket queuing either user 
> configurable or depending on the setting of NR_CPUS, NUMA, etc?

No!

There are lots of disadvantages to adding such CONFIG_NUMA Kconfig 
variants for locking primitives:

 - an doubling of the test matrix

 - an doubling of the review matrix and a halving of effective review 
   capacity: we've just about go the capacity to review and validate 
   patches like this. Splitting out a 'only NUMA cares' variant is a 
   non-starter really.

 - but most importantly, there's absolutely no reason to not be fast
   on 128 CPU systems in the low contended case either! Sacrificing
   the low contended case with 'on 128 CPU systems it is the contended
   path that matters' is an idiotic argument.

Essentially the only area were we allow Kconfig dependencies are 
unyielding physical forces: such as lots of CPUs needing a wider CPU 
mask.

As Peter said it, the right solution is to fix the contended case. If 
that also happens to speed up or better organize the uncondended code 
then that's good, but it should not make it worse.

Thanks,

	Ingo
