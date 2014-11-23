Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189AbaKWTNv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 14:13:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37119 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751273AbaKWTNu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 14:13:50 -0500
Date: Sun, 23 Nov 2014 14:12:53 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Pranith Kumar <bobby.prani@gmail.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Howells <dhowells@redhat.com>,
        Eric Dumazet <edumazet@google.com>, dvhart@linux.intel.com,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>,
        device-mapper development <dm-devel@redhat.com>
Subject: Re: [PATCH ] drivers/md: use proper rcu accessor
Message-ID: <20141123191252.GA30575@redhat.com>
References: <20141028220944.GA26114@linux.vnet.ibm.com>
 <1414534202-27312-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1414534202-27312-3-git-send-email-paulmck@linux.vnet.ibm.com>
 <20141121133145.GA17245@node.dhcp.inet.fi>
 <546F4C8C.4040904@gmail.com>
 <20141121145817.GA17710@node.dhcp.inet.fi>
 <CAJhHMCCE_p+xTibLZwoS5OqW--NO_uEVsW6tfN6LcgZGBquBTQ@mail.gmail.com>
 <1416760829.17888.19.camel@edumazet-glaptop2.roam.corp.google.com>
 <CAMM=eLe5mXBfg_W=bjkFN3_pVAYi1WqRr4nOb90aveA3LvaGDg@mail.gmail.com>
 <1416763873.17888.33.camel@edumazet-glaptop2.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416763873.17888.33.camel@edumazet-glaptop2.roam.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 23 2014 at 12:31pm -0500,
Eric Dumazet <eric.dumazet@gmail.com> wrote:

> On Sun, 2014-11-23 at 11:53 -0500, Mike Snitzer wrote:
> > On Sun, Nov 23, 2014 at 11:40 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > > From: Eric Dumazet <edumazet@google.com>
> > >
> > > rcu_dereference() should be used in sections protected by rcu_read_lock.
> > >
> > > For writers, holding some kind of mutex or lock,
> > > rcu_dereference_protected() is the way to go, adding explicit lockdep
> > > bits.
> > >
> > > In __unbind(), although there is no mutex or lock held, we are about
> > > to free the mapped device, so can use the constant '1' instead of a
> > > lockdep_is_held()
> > 
> > That isn't true.  dm_hash_remove_all() -- which calls dm_destroy --
> > holds _hash_lock.  Why leave __unbind() brittle in the face of future
> > DM locking changes?
> > 
> 
> Well, tell me. Before the 33423974bfc1 patch there was no protection.

Wasn't protected by _hash_lock or wasn't protected by use of rcu_deference()?
 
> If really you are about to delete an object, you have to be sure no one
> is going to use it.
> 
> rcu_dereference_protected(X, 1) is how we express this thing, there is
> nothing wrong here.
> 
> Fact that you hold a lock at this point is irrelevant and wont protect
> the bug from happening. If you believe so, then you are wrong.

My asking a question about the validity of your assertion given that
assertion wasn't 100% correct is perfectly fair no?  I just want to make
sure the change is accurately described.  Asking that question also
doesn't imply I felt you don't know what you're doing.  Fact is I really
trust you to be a _very_ capable developer.

But exactly which "bug" are we talking about?  A theoretical bug or a
reported bug that caused DM to fail?  So far all of these supposed rcu
deference fixes have _never_ substantiated with an actual bug (Other
than a splat from autochecking performed by rcu_dereference_check).

In fact the very first "fix" from 33423974bfc1 _seems_ to just be the
by-product from rcu janitor efforts.  I'm happy others are looking after
rcu consumers but pretty sure all of this churn is what is causing these
"bugs".

But maybe I'm mistaken and all these changes shoul dbe cc'ing
stable@vger.kernel.org?

> > > Reported-by: Kirill A. Shutemov <kirill@shutemov.name>
> > > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > > Fixes: 33423974bfc1 ("dm: Use rcu_dereference() for accessing rcu pointer")
> > > Cc: Pranith Kumar <bobby.prani@gmail.com>
> > 
> > Hi Eric,
> > 
> > I'll pick this up once I get clarification for why your __unbind
> > change is safe.. but it really would've helped if you cc'd
> > dm-devel@redhat.com or myself directly (not a single person that you
> > cc'd actively maintains DM).
> > 
> 
> Hmm, my mailer complained because the mail had too many recipients
> already. I did a 'reply' on the original thread.

It's OK, I missed the report from 2 days ago too (wasn't cc'd etc).

> > Hopefully these DM rcu "fixes" are finished after this.
> 
> You added a Signed-off-by on 33423974bfc1, not me.

Right, I don't pretend to keep my finger on the pulse of rcu API as much
as I probably should.  But I'm pretty sure Paul McKenney does and he
also provided his Signed-off-by -- and I really trust Paul on rcu stuff.

> Kirill gave the report 2 days ago and so far nobody fixed it.
> 
> I will send a v2 because other rcu_dereference() need to be changed as
> well.

I'm still wondering if they _need_ to be changed -- we aren't already
protected in these paths due to DM's existing locking (via suspend_lock
or _hash_lock, etc)?  But I'll circle back to try to properly understand
the need shortly.

Anyway, all being said: I appreciate your help here.  Not liking that we
got to baiting one another; I'll refrain from doing so in the future.
