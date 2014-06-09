Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141AbaFITFZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 15:05:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36400 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992AbaFITFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 15:05:23 -0400
Date: Mon, 9 Jun 2014 21:04:02 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Clark Williams <williams@redhat.com>
Subject: Re: safety of *mutex_unlock() (Was: [BUG] signal: sighand
	unprotected when accessed by /proc)
Message-ID: <20140609190402.GA15612@redhat.com>
References: <20140603130233.658a6a3c@gandalf.local.home> <20140603172632.GA27956@redhat.com> <CA+55aFzT5CGv_T60voAqR+4PfiMmJmsDZLid2DZ4=+X8uvF+ig@mail.gmail.com> <20140603200125.GB1105@redhat.com> <20140606203350.GU4581@linux.vnet.ibm.com> <20140608130718.GA11129@redhat.com> <20140609162613.GE4581@linux.vnet.ibm.com> <20140609181553.GA13681@redhat.com> <20140609142956.3d79e9d1@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140609142956.3d79e9d1@gandalf.local.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09, Steven Rostedt wrote:
>
> On Mon, 9 Jun 2014 20:15:53 +0200
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > > That would indeed be a bad thing, as it could potentially lead to
> > > use-after-free bugs.  Though one could argue that any code that resulted
> > > in use-after-free would be quite aggressive.  But still...
> >
> > And once again, note that the normal mutex is already unsafe (unless I missed
> > something).
>
> Is it unsafe?

Only in a sense that UNLOCK is not atomic.

IOW, you can't, say, declare a mutex or semaphore on stack, and use lock/unlock
to serialize with another thread.

But rt_mutex seems fine in this case, and for example rcu_boost() does this.
I do not know if this is by design or not, and can we rely on this or not.

> This thread was started because of a bug we triggered in -rt, which
> ended up being a change specific to -rt that modified the way slub
> handled SLAB_DESTROY_BY_RCU. What else was wrong with it?

And I specially changed the subject to avoid the confusion with
SLAB_DESTROY_BY_RCU bug we discussed before, but apparently I need to
apologize for confusion again ;)

But. Note that if rt_mutex is changed so that UNLOCK becomes non-atomic
in a sense above, then lock_task_sighand()/unlock_task_sighand() will be
buggy in -rt.

Oleg.

