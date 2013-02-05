Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228Ab3BECmH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 21:42:07 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21683 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753641Ab3BECmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 21:42:06 -0500
X-Authority-Analysis: v=2.0 cv=f8jK9ZOM c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=-mX8_mtaSd8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=BnJ6rni4RVIA:10 a=uOf1YziIQF0kGRSXqWQA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1360032122.27007.4.camel@gandalf.local.home>
Subject: Re: [GIT PULL] printk: Support for full dynticks mode
From: Steven Rostedt <rostedt@goodmis.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Mon, 04 Feb 2013 21:42:02 -0500
In-Reply-To: <20130204180948.68c206c0.akpm@linux-foundation.org>
References: <1360025478-32741-1-git-send-email-fweisbec@gmail.com>
	 <20130204172001.8bb358b0.akpm@linux-foundation.org>
	 <CAFTL4hxHEknUfv0rt73Tb0YAUrypuGJArvCw4wmEPp_8PF_b0A@mail.gmail.com>
	 <20130204180948.68c206c0.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-02-04 at 18:09 -0800, Andrew Morton wrote:

> I don't think so.  Conceptually printk() should be "inner" to the
> scheduler and shouldn't call into sched things at all.  The (afaik
> sole) exception to that was the klogd wakeup.
> 
> Traditionally the deadlock happened when calling printk() with
> tasklist_lock (now q->lock) held.  printk() would call wake_up(klogd)
> and wake_up() tries to take tasklist_lock and boom.  Moving the
> wake_up() out to the tick "thread" fixed that.
> 
> Maybe there were other deadlock scenarios, dunno.  That knowledge
> appears to be disappearing into the mists of time :(

Even without the printk irq_work the current printk method uses a
delayed wakeup anyway.

The wake_up_klogd() sets PRINTK_PENDING_WAKEUP, and the wakeup happens
at time of the tick. I don't see where there is a deadlock. I added a
printk in __sched_setscheduler() where the run queue lock is held, and
booted that with full lockdep debugging enabled. No deadlock is
detected.

Do we really even need that printk_sched()?

-- Steve


