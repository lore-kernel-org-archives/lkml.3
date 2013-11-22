Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940Ab3KVU0N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 15:26:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17450 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755605Ab3KVU0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 15:26:08 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CA+55aFwF8BV+YAD1RzV=yvcN2qVZ5sajBaeR=exqeZL6R-iYqw@mail.gmail.com>
References: <CA+55aFwF8BV+YAD1RzV=yvcN2qVZ5sajBaeR=exqeZL6R-iYqw@mail.gmail.com> <alpine.LRH.2.02.1311071146450.31522@tundra.namei.org> <CA+5PVA7C-SSg5TyQ14kUN2SbLi-=bk6isi05xgtR5j8MC7-Uhg@mail.gmail.com> <alpine.LRH.2.02.1311191029050.20131@tundra.namei.org> <CA+55aFyp2HnMATV1v81QwZFqXcyca-RTD93=55ba37kF4ANfCw@mail.gmail.com> <alpine.LRH.2.02.1311192319180.27775@tundra.namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        James Morris <jmorris@namei.org>
Cc: dhowells@redhat.com, Josh Boyer <jwboyer@fedoraproject.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>
Subject: Re: [GIT] Security subsystem updates for 3.13
Date: Fri, 22 Nov 2013 20:25:58 +0000
Message-ID: <28109.1385151958@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> So for future cases: if there are big independent overhauls of core
> subsystems, I'd really like to see them kept separate, ok?

Since the trusted and encrypted keys that Mimi and Dmitry deal with are also
more akin to the keyring stuff, should they go through the keyring branch?
And does James want to hold that branch?

> Also, David, with (for example) 1700+ new lines in lib/assoc_array.c,
> I would really *really* like code like this to have some review by
> outsiders. Maybe you did have that, but I saw absolutely no sign of it
> in the tree when I merged it. That code alone made me go "Hmm, where
> did this come from, how was it tested, why should I merge it?".

I wrote it in userspace where I could easily drive it with huge numbers of
entries (add a million keys, say, delete them randomly and check at each step
that each remaining key can still be found) and also valground it.  For
reference, what's the best way of showing you something like this?  I could
include it in the commit message, but the driver is actually fairly large.
Since it went through James's tree in the middle of a pile of patches, it
would be awkward for you to then discard that information to trim things.

I did show it to Paul McKenney - and he gave me some comments on it, though I
didn't ask for a Reviewed-by line, which in retrospect I should've done.

> I do see *some* minimal comments on it from George Spelvin on lkml.  I don't
> see any sign of that in the commit messages, though.

Should we have a "Comments-from: x <y@z>" line for this?  So that people who
made comments but don't want to say they've properly reviewed it can be
recognised formally?

I'd prefer to avoid adding changelogs into the patch description - though
maybe that's the best way to do this.

> I'd also see no comments on where the algorithm came from etc.

The basic algorithm was actually something I came up with myself to use on
disk in one of the earliest implementations of fscache that I tried.  I then
adapted it to this.  I suspected that I couldn't've been the only one to have
thought this up, so I asked Paul to take a peek at the code and see what he
thought.

> It clearly has subtle memory ordering (smp_read_barrier_depends() etc),

Actually, it's just where I'm doing RCU-type stuff.  There's an argument I
should be using the RCU functions anyway, but:

 (1) A flag would have to be passed down to say whether the callers of the
     assoc_array functions are holding the write lock or whether they're
     dependent on the RCU readlock - at least for the iterate and find
     functions.  I suppose this flag would be ignored if LOCKDEP=n though the
     parameter would still have to exist.

 (2) Sometimes I want to read the pointers in a node and examine bit 0 (which
     is a tag to indicate metadata or leaf) and then decide what to do based
     on that.  I don't want to interpolate a barrier there unless I'm actually
     going to follow the pointer and I don't want to have to read the pointer
     value again if I've determined it is what I'm looking for.  For example:

	struct assoc_array_node *n1 = ...;
	struct assoc_array_node *n2 = rcu_access_pointer(n1->slots[x]);
	/* Did an ACCESS_ONCE() */
	if (is_bit0_set(n2)) {
		/* Now we need a barrier */
		n2 = rcu_dereference_check(n1->slots[x], check);
		/* Did another ACCESS_ONCE() */
	}

 (3) I'm using the undefined struct assoc_array_ptr to prevent accidental
     dereferences of tagged pointers in the tree.  Either Sparse or GCC will
     throw a errors if these are passed to rcu functions, depending on how you
     do it.

> In short: this is exactly the kind of thing I *don't* enjoy merging,
> because the code that needed review was
> 
>  - mixed up with other changes that had nothing to do with it
>  - had no pointers to help me review it
>  - had zero information about others who had possibly reviewed it before
> 
> and quite frankly, without the extended explanation of what the
> changes were for (which I also didn't get initially), I'd probably
> have decided half-way that it's not worth the headache.

Is there some way in the GIT repo to associate an 'extended explanation' with
several patches?

> In the end, the code didn't look bad, and I didn't find any obvious
> problems, but there's very much a reason why I merged this over two
> weeks after the first pull request was originally sent to me.
> 
> So guys, make it easier for me to merge these kinds of things, and
> *don't* do what happened this time. Ok? Pretty please?

Ok.

David
