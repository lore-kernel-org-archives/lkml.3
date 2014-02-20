Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367AbaBTTC4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 14:02:56 -0500
Received: from mail-ve0-f176.google.com ([209.85.128.176]:52985 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754596AbaBTTCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 14:02:55 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFwV3pH+CP7Anv_YXzChL5V3_zre0+Ry-a1tJGYsbn-3iQ@mail.gmail.com>
References: <CA+55aFwTrt_6m1inNHQkk74i7uPkHNnacwHiBgioZSXieAs5Sw@mail.gmail.com>
	<1392666947.18779.6838.camel@triegel.csb>
	<CA+55aFwUnRVk6q3VZeYjWfduoHcExW=Pht6jgp=4bBSaLHNPMA@mail.gmail.com>
	<20140218030002.GA15857@linux.vnet.ibm.com>
	<CA+55aFyqLrj4d2TA+2aazRqXnbVsUvs0yaBL2D5rXF1G=Kiu_g@mail.gmail.com>
	<CA+55aFwsq5E8kMoEeHJJ1f2=+QAUCu_HndfPxHNz8fUBprS-jQ@mail.gmail.com>
	<1392740258.18779.7732.camel@triegel.csb>
	<CA+55aFw7QYEMFs0BCxqRJW3Cz=tLbaku-tmN6hLXPKP9jbom7Q@mail.gmail.com>
	<1392752867.18779.8120.camel@triegel.csb>
	<CA+55aFxQPxQ8WOaZL8yAqBA=Y4k2gDn4r4oepMyi0uL6XLzv3w@mail.gmail.com>
	<20140220040102.GM4250@linux.vnet.ibm.com>
	<CA+55aFwwscSzwTr+xRdirtTx7HzugmMY9HrDe0GBqNhn=AuNVA@mail.gmail.com>
	<1392918576.18779.10198.camel@triegel.csb>
	<CA+55aFwV3pH+CP7Anv_YXzChL5V3_zre0+Ry-a1tJGYsbn-3iQ@mail.gmail.com>
Date: Thu, 20 Feb 2014 11:02:53 -0800
X-Google-Sender-Auth: De2QuJUXSV1Nn3UT3TwlpBaw6Ww
Message-ID: <CA+55aFx9ZZeSEmZL2H69Mou=JcYr77Tb8SdDhMvV+GUVvEmd5Q@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Torvald Riegel <triegel@redhat.com>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Will Deacon <will.deacon@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        David Howells <dhowells@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 10:25 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> While in my *sane* model, where you can consume things even if they
> then result in control dependencies, there will still eventually be a
> "sync" instruction on powerpc (because you really need one between the
> load of 'initialized' and the load of 'calculated'), but the compiler
> would be free to schedule the load of 'magic_system_multiplier'
> earlier.

Actually, "consume" is more interesting than that. Looking at the
bugzilla entry Torvald pointed at, it has the trick to always turn any
"consume" dependency into an address data dependency.

So another reason why you *want* to allow "consume" + "control
dependency" is that it opens up the window for many more interesting
and relevant optimizations than "acquire" does.

Again, let's take that "trivial" expression:

     return atomic_read(&initialized, consume) ? value : -1;

and the compiler can actually turn this into an interesting address
data dependency and optimize it to basically use address arithmetic
and turn it into something like

    return *(&value + (&((int)-1)-value)*!atomic_read(&initialized, consume));

Of course, the *programmer* could have done that himself, but the
above is actually a *pessimization* on x86 or other strongly ordered
machines, so doing it at a source code level is actually a bad idea
(not to mention that it's horribly unreadable).

I could easily have gotten the address generation trick above wrong
(see my comment about "horribly unreadable" and no sane person doing
this at a source level), but that "complex" expression is not
necessarily at all complex for a compiler. If "value" is a static
variable, the compiler could create another read-only static variable
that contains that "-1" value, and the difference in addresses would
be a link-time constant, so it would not necessarily be all that ugly
from a code generation standpoint.

There are other ways to turn it into an address dependency, so the
whole "consume as an input to conditionals" really does seem to have
several optimization advantages (over "acquire").

Again, the way I'd expect a compiler writer to actually *do* this is
to just default to "ac

               Linus
