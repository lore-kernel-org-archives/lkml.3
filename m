Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395AbaFISRV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 14:17:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31524 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753748AbaFISRT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 14:17:19 -0400
Date: Mon, 9 Jun 2014 20:15:53 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Clark Williams <williams@redhat.com>
Subject: Re: safety of *mutex_unlock() (Was: [BUG] signal: sighand
	unprotected when accessed by /proc)
Message-ID: <20140609181553.GA13681@redhat.com>
References: <20140603130233.658a6a3c@gandalf.local.home> <20140603172632.GA27956@redhat.com> <CA+55aFzT5CGv_T60voAqR+4PfiMmJmsDZLid2DZ4=+X8uvF+ig@mail.gmail.com> <20140603200125.GB1105@redhat.com> <20140606203350.GU4581@linux.vnet.ibm.com> <20140608130718.GA11129@redhat.com> <20140609162613.GE4581@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140609162613.GE4581@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09, Paul E. McKenney wrote:
>
> On Sun, Jun 08, 2014 at 03:07:18PM +0200, Oleg Nesterov wrote:
> >
> > I only meant that afaics rcu_read_unlock_special() equally depends on the
> > fact that rt_mutex_unlock() does nothing with "struct rt_mutex" after it
> > makes another rt_mutex_lock() + rt_mutex_unlock() possible, otherwise this
> > code is wrong (and unlock_task_sighand() would be wrong too).
> >
> > Just to simplify the discussion... suppose we add "atomic_t nr_slow_unlock"
> > into "struct rt_mutex" and change rt_mutex_slowunlock() to do
> > atomic_inc(&lock->nr_slow_unlock) after it drops ->wait_lock. Of course this
> > would be ugly, just for illustration.
>
> That would indeed be a bad thing, as it could potentially lead to
> use-after-free bugs.  Though one could argue that any code that resulted
> in use-after-free would be quite aggressive.  But still...

And once again, note that the normal mutex is already unsafe (unless I missed
something).

> > So _perhaps_ we should not rely on this property of rt_mutex "too much".
>
> Well, I could easily move the rt_mutex from rcu_boost()'s stack to the
> rcu_node structure, if that would help.  That said, I still have my
> use-after-free concern above.

Or we can document that rt_mutex is special and rt_mutex_unlock() should be
"atomic" and safe as spin_unlock() or complete().

Oleg.

