Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758172Ab3FMAt5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 20:49:57 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54396 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755889Ab3FMAt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 20:49:56 -0400
Date: Thu, 13 Jun 2013 01:49:41 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, ????????? <laijs@cn.fujitsu.com>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Josh Triplett <josh@joshtriplett.org>, niv@us.ibm.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        David Howells <dhowells@redhat.com>,
        Eric Dumazet <edumazet@google.com>, Darren Hart <darren@dvhart.com>,
        Fr??d??ric Weisbecker <fweisbec@gmail.com>,
        Silas Boyd-Wickizer <sbw@mit.edu>, Waiman Long <Waiman.Long@hp.com>
Subject: Re: [PATCH RFC ticketlock] Auto-queued ticketlock
Message-ID: <20130613004941.GJ4165@ZenIV.linux.org.uk>
References: <1370973186.1744.9.camel@buesod1.americas.hpqcorp.net>
 <1370974231.9844.212.camel@gandalf.local.home>
 <1371059401.1746.33.camel@buesod1.americas.hpqcorp.net>
 <CA+55aFygedE80F3SvE7VvqwXaCthbFh7sMCwVnZt6wzst8YLHA@mail.gmail.com>
 <1371067399.1746.47.camel@buesod1.americas.hpqcorp.net>
 <CA+55aFwDYvCR9SavTQt62kibvmv37M4+GxzjxU1ZqZVVB9Ce9w@mail.gmail.com>
 <20130612233224.GH4165@ZenIV.linux.org.uk>
 <CA+55aFw2=3ua32vkpWc_9ckCNweFmmH3c0d-VqoaUD86rkR-=w@mail.gmail.com>
 <20130613002058.GI4165@ZenIV.linux.org.uk>
 <CA+55aFxEnNvj1SoOL+ChVQqK+ouSNgsM+6cQt+=PpmTGdcFggg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxEnNvj1SoOL+ChVQqK+ouSNgsM+6cQt+=PpmTGdcFggg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 12, 2013 at 05:38:13PM -0700, Linus Torvalds wrote:
> On Wed, Jun 12, 2013 at 5:20 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > Actually, dget_parent() change might be broken; the thing is, the assumptions
> > are more subtle than "zero -> non-zero only happens under ->d_lock".  It's
> > actually "new references are grabbed by somebody who's either already holding
> > one on the same dentry _or_ holding ->d_lock".  That's what d_invalidate()
> > check for ->d_count needs for correctness - caller holds one reference, so
> > comparing ->d_count with 2 under ->d_lock means checking that there's no other
> > holders _and_ there won't be any new ones appearing.
> 
> For the particular case of dget_parent() maybe dget_parent() should
> just double-check the original dentry->d_parent pointer after getting
> the refcount on it (and if the parent has changed, drop the refcount
> again and go to the locked version). That might be a good idea anyway,
> and should fix the possible race (which would be with another cpu
> having to first rename the child to some other parent, and the
> d_invalidate() the original parent)

Yes, but...  Then we'd need to dput() that sucker if we decide we shouldn't
have grabbed that reference, after all, which would make dget_parent()
potentially blocking.

> That said, the case we'd really want to fix isn't dget_parent(), but
> just the normal RCU lookup finishing touches (the__d_rcu_to_refcount()
> case you already mentioned) . *If* we could do that without ever
> taking the d_lock on the target, that would be lovely. But it would
> seem to have the exact same issue. Although maybe the
> dentry_rcuwalk_barrier() thing ends up solving it (ie if we had a
> lookup at a bad time, we know it will fail the sequence count test, so
> we're ok).

Maybe, but that would require dentry_rcuwalk_barrier() between any such
check and corresponding grabbing of ->d_lock done for it, so it's not
just d_invalidate().

> Subtle, subtle.

Yes ;-/  The current variant is using ->d_lock as a brute-force mechanism
for avoiding all that fun, and I'm not sure that getting rid of it would
buy us enough to make it worth the trouble.  I'm absolutely sure that if
we go for that, we _MUST_ document the entire scheme as explicitly as
possible, or we'll end up with the shitload of recurring bugs in that
area.  Preferably with the formal proof of correctness spelled out somewhere...
