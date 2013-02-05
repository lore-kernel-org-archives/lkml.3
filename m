Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980Ab3BEDYa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 22:24:30 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:30561 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754484Ab3BEDY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 22:24:28 -0500
X-Authority-Analysis: v=2.0 cv=NqdTgrhJ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=-mX8_mtaSd8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=BnJ6rni4RVIA:10 a=E3WhOqUKMzCLwSn6_8QA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1360034667.27007.10.camel@gandalf.local.home>
Subject: Re: [GIT PULL] printk: Support for full dynticks mode
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Mon, 04 Feb 2013 22:24:27 -0500
In-Reply-To: <CAFTL4hyvvpqw2KwFzHLN5V5izKh4d0rp9mQhadZwRp8actRr+g@mail.gmail.com>
References: <1360025478-32741-1-git-send-email-fweisbec@gmail.com>
	 <20130204172001.8bb358b0.akpm@linux-foundation.org>
	 <CAFTL4hxHEknUfv0rt73Tb0YAUrypuGJArvCw4wmEPp_8PF_b0A@mail.gmail.com>
	 <20130204180948.68c206c0.akpm@linux-foundation.org>
	 <1360034041.27007.6.camel@gandalf.local.home>
	 <CAFTL4hyvvpqw2KwFzHLN5V5izKh4d0rp9mQhadZwRp8actRr+g@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-02-05 at 04:19 +0100, Frederic Weisbecker wrote:
> 2013/2/5 Steven Rostedt <rostedt@goodmis.org>:
> > On Mon, 2013-02-04 at 18:09 -0800, Andrew Morton wrote:
> >
> >> Maybe there were other deadlock scenarios, dunno.  That knowledge
> >> appears to be disappearing into the mists of time :(
> >
> > Discussing this on IRC with Frederic, he brought up that the
> > up(&console_sem) can do a wake_up as well. I guess that's the issue we
> > have :-/
> 
> Also if we delay the wakeup on klogd but not on the console_sem
> waiters, it looks like a general printk() problem. Not something that
> only printk_sched() would like to avoid.

printk_sched() is a delay to printk() to avoid calling printk() which
might take the rq lock. It's to prevent printk() deadlocking in case it
wakes up. printk_sched() just delays the printk() to the next timer
tick.

The reason to avoid the wake up of klogd() is that it also grabs the
wait queue spinlock every time it's called. up() is fast when there's no
waiters, but wake_up_interruptible() is not so fast.

There's no issue calling wake_up_process() from printk() as long as you
don't do it while holding a rq lock.

-- Steve


