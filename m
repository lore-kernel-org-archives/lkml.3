Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758142Ab3FMAiR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 20:38:17 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:40994 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755889Ab3FMAiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 20:38:15 -0400
MIME-Version: 1.0
In-Reply-To: <20130613002058.GI4165@ZenIV.linux.org.uk>
References: <1370911480.9844.160.camel@gandalf.local.home>
	<CA+55aFxeLszgfTZeG7L6289DcaoKT+uhtf5nwB6r=2i9Sy4Mrg@mail.gmail.com>
	<1370973186.1744.9.camel@buesod1.americas.hpqcorp.net>
	<1370974231.9844.212.camel@gandalf.local.home>
	<1371059401.1746.33.camel@buesod1.americas.hpqcorp.net>
	<CA+55aFygedE80F3SvE7VvqwXaCthbFh7sMCwVnZt6wzst8YLHA@mail.gmail.com>
	<1371067399.1746.47.camel@buesod1.americas.hpqcorp.net>
	<CA+55aFwDYvCR9SavTQt62kibvmv37M4+GxzjxU1ZqZVVB9Ce9w@mail.gmail.com>
	<20130612233224.GH4165@ZenIV.linux.org.uk>
	<CA+55aFw2=3ua32vkpWc_9ckCNweFmmH3c0d-VqoaUD86rkR-=w@mail.gmail.com>
	<20130613002058.GI4165@ZenIV.linux.org.uk>
Date: Wed, 12 Jun 2013 17:38:13 -0700
X-Google-Sender-Auth: HlbosnEX6j9__skJwiWbna9wxRk
Message-ID: <CA+55aFxEnNvj1SoOL+ChVQqK+ouSNgsM+6cQt+=PpmTGdcFggg@mail.gmail.com>
Subject: Re: [PATCH RFC ticketlock] Auto-queued ticketlock
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, "?????????" <laijs@cn.fujitsu.com>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Josh Triplett <josh@joshtriplett.org>, niv@us.ibm.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        David Howells <dhowells@redhat.com>,
        Eric Dumazet <edumazet@google.com>, Darren Hart <darren@dvhart.com>,
        "Fr??d??ric Weisbecker" <fweisbec@gmail.com>,
        Silas Boyd-Wickizer <sbw@mit.edu>, Waiman Long <Waiman.Long@hp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 12, 2013 at 5:20 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Actually, dget_parent() change might be broken; the thing is, the assumptions
> are more subtle than "zero -> non-zero only happens under ->d_lock".  It's
> actually "new references are grabbed by somebody who's either already holding
> one on the same dentry _or_ holding ->d_lock".  That's what d_invalidate()
> check for ->d_count needs for correctness - caller holds one reference, so
> comparing ->d_count with 2 under ->d_lock means checking that there's no other
> holders _and_ there won't be any new ones appearing.

For the particular case of dget_parent() maybe dget_parent() should
just double-check the original dentry->d_parent pointer after getting
the refcount on it (and if the parent has changed, drop the refcount
again and go to the locked version). That might be a good idea anyway,
and should fix the possible race (which would be with another cpu
having to first rename the child to some other parent, and the
d_invalidate() the original parent)

That said, the case we'd really want to fix isn't dget_parent(), but
just the normal RCU lookup finishing touches (the__d_rcu_to_refcount()
case you already mentioned) . *If* we could do that without ever
taking the d_lock on the target, that would be lovely. But it would
seem to have the exact same issue. Although maybe the
dentry_rcuwalk_barrier() thing ends up solving it (ie if we had a
lookup at a bad time, we know it will fail the sequence count test, so
we're ok).

Subtle, subtle.

               Linus
