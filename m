Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800AbaBZAQi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 19:16:38 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:48502 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773AbaBZAQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 19:16:33 -0500
Date: Tue, 25 Feb 2014 16:15:58 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Torvald Riegel <triegel@redhat.com>, Will Deacon <will.deacon@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        David Howells <dhowells@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
Message-ID: <20140226001558.GY8264@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140223063426.GT4250@linux.vnet.ibm.com>
 <CA+55aFxMJvaQhoEwqgN=XA6gDOdZwoZQHdcAnB-FhAri_hK-6Q@mail.gmail.com>
 <CA+55aFw5tdjmNyHCdcyZ8NPpd1wCgOjLRzstRhp0Njs9azpi8Q@mail.gmail.com>
 <20140224172110.GO8264@linux.vnet.ibm.com>
 <CA+55aFyi45f7oaG4MYP41TOc=E8Ze8Om88dV2Lq4F=qebhxt4A@mail.gmail.com>
 <20140224185341.GU8264@linux.vnet.ibm.com>
 <CA+55aFzXyob0aKnv1u7Stbu0rH5Aq2jaA1rHb=TvQe9c1KY0oQ@mail.gmail.com>
 <20140224223701.GC8264@linux.vnet.ibm.com>
 <CA+55aFxGaKtvx5YnOFC5hU9+ischxn=LN_yWiqjXwpNZePvWmw@mail.gmail.com>
 <CA+55aFwo9ZKxyN76cnkN7iQi7pKB+_tVD=re+RoMP4MiSajC8w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwo9ZKxyN76cnkN7iQi7pKB+_tVD=re+RoMP4MiSajC8w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14022600-1542-0000-0000-0000069E3CEF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 10:05:52PM -0800, Linus Torvalds wrote:
> On Mon, Feb 24, 2014 at 3:35 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > Litmus test 1:
> >
> >     p = atomic_read(pp, consume);
> >     if (p == &variable)
> >         return p->val;
> >
> >    is *NOT* ordered
> 
> Btw, don't get me wrong. I don't _like_ it not being ordered, and I
> actually did spend some time thinking about my earlier proposal on
> strengthening the 'consume' ordering.

Understood.

> I have for the last several years been 100% convinced that the Intel
> memory ordering is the right thing, and that people who like weak
> memory ordering are wrong and should try to avoid reproducing if at
> all possible. But given that we have memory orderings like power and
> ARM, I don't actually see a sane way to get a good strong ordering.
> You can teach compilers about cases like the above when they actually
> see all the code and they could poison the value chain etc. But it
> would be fairly painful, and once you cross object files (or even just
> functions in the same compilation unit, for that matter), it goes from
> painful to just "ridiculously not worth it".

And I have indeed seen a post or two from you favoring stronger memory
ordering over the past few years.  ;-)

> So I think the C semantics should mirror what the hardware gives us -
> and do so even in the face of reasonable optimizations - not try to do
> something else that requires compilers to treat "consume" very
> differently.

I am sure that a great many people would jump for joy at the chance to
drop any and all RCU-related verbiage from the C11 and C++11 standards.
(I know, you aren't necessarily advocating this, but given what you
say above, I cannot think what verbiage that would remain.)

The thing that makes me very nervous is how much the definition of
"reasonable optimization" has changed.  For example, before the
2.6.10 Linux kernel, we didn't even apply volatile semantics to
fetches of RCU-protected pointers -- and as far as I know, never
needed to.  But since then, there have been several cases where the
compiler happily hoisted a normal load out of a surprisingly large loop.
Hardware advances can come into play as well.  For example, my very first
RCU work back in the early 90s was on a parallel system whose CPUs had
no branch-prediction hardware (80386 or 80486, I don't remember which).
Now people talk about compilers using branch prediction hardware to
implement value-speculation optimizations.  Five or ten years from now,
who knows what crazy optimizations might be considered to be completely
reasonable?

Are ARM and Power really the bad boys here?  Or are they instead playing
the role of the canary in the coal mine?

> If people made me king of the world, I'd outlaw weak memory ordering.
> You can re-order as much as you want in hardware with speculation etc,
> but you should always *check* your speculation and make it *look* like
> you did everything in order. Which is pretty much the intel memory
> ordering (ignoring the write buffering).

Speaking as someone who got whacked over the head with DEC Alpha when
first presenting RCU to the Digital UNIX folks long ago, I do have some
sympathy with this line of thought.  But as you say, it is not the world
we currently live in.

Of course, in the final analysis, your kernel, your call.

							Thanx, Paul

