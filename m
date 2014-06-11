Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951AbaFKAKG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 20:10:06 -0400
Received: from ns.horizon.com ([71.41.210.147]:19923 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751554AbaFKAKE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 20:10:04 -0400
Date: 10 Jun 2014 20:10:03 -0400
Message-ID: <20140611001003.12979.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, tytso@mit.edu
Subject: Re: drivers/char/random.c: more ruminations
Cc: hpa@linux.intel.com, linux-kernel@vger.kernel.org, mingo@kernel.org,
        price@mit.edu
In-Reply-To: <20140610212032.GG12104@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> I don't care about the efficiency either; I just wanted to avoid the
>> stack usage of a "u32 tmp[OUTPUT_POOL_WORDS]" when the actual extraction
>> is done in EXTRACT_SIZE chunks anyhway.

> Huh?  The FIPS wankery requires:
>
>      __u8 tmp[10];
>
> not
>
>	u32 tmp[OUTPUT_POOL_WORDS];

Sorry, we're still not communicating right.  You seem to think I'm trying
to optimize the FIPS code, and nothing could be further from the truth.

Please consider the merits of my patch as if the FIPS stuff weas
#ifdefed out.  I don't care about it, I'm not trying to optimize it,
it was just *in my way* when I was trying to do something else, and I
only had to ask about it because it's a legal/regulatory requirement
rather than a technical one I couldn't understand it by logic.

What I wanted to do was eliminate that huge tmp buffer from
_xfer_secondary_pool.  There's no good reason why it needs to be there.
and several reasons for getting rid of it.

A big one for me is auditability, a.k.a. the current code confused me
when I was trying to understand it.  Based on static code analysis,
extract_entropy and xfer_secondary_pool appear to be recursive; the fact
that they're not in practice takes more insight.

extract_entropy_user(&nonblocking_pool)
-> xfer_secondary_pool(&nonblocking_pool)
   -> _xfer_secondary_pool(&nonblocking_pool)
      -> extract_entropy(&input_pool)
         -> xfer_secondary_pool(&input_pool)
            recursion terminates because input_pool.pull == NULL

> and when you replace the former with the latter, but still try to move 
> 
> The xfer_seconary_pool code does use OUTPUT_POOL_WORDS*sizeof(32), but
> only declare tmp as a 10-byte char array, it looks like you're end up
> overflowing the stack (have you actually tested your draft patch?)

Please look again; it doesn't overflow.

I hadn't tested the patch when I mailed it to you (I prepared it in
order to reply to your e-mail, and it's annoying to reboot the machine
I'm composing an e-mail on), but I have since.  It works.

> This is also why I objected to your change to use the stale stack
> contents for the input array.  That does something different from the
> rest of the changes in the patch.  I'm sorry if keep harping on this,
> but this is critically important.  It also means that we can accept
> the small, obviously correct changes, while we discuss the larger,
> more invasive changes.  It also makes it easier to backport the
> smaller and more important changes to stable kernels.
[...]
> In any case, this is another reason why I really request people to
> send a series of git commits, where each one is small, easy to read,
> and Obviously Correct.
[...]
> small patches really, REALLY, helps the review process.)

I'm very aware of this.  As I've said before on the git mailing list,
the reason that git bisect is such a killer feature is due to an even
more important, but also more subtle, killer feature of git: it makes
it practical to use lots of small commits, so it can point you at a very
small change.

If you had CVS-style weeks-in-preparation-and-testing "code drop"
commits, it wouldn't be nearly as useful.

Indeed, if you look at some of the 10-patch series I've posted recently
(I'm on a "clear my tree of private patches" binge), I think I'm doing
fairly well.  If anything I worry about erring on the side of too minor.
Does this meet with your approval:

http://www.spinics.net/lists/linux-media/msg76435.html

But even I get annoyed when I have a 1-line comment typo fix and wonder
if it really deserves its own commit or if I can just include it with
the other changes I'm making to that file.


Anwyay, please stop wearing out your fingers and consider the point Made.

I will do my utmost to divide things as finely as possible.

The one problem is that too small a change can be Obviously Correct
(to the extent that the overall code complexity allows *anything* to
be obvious), but not Obviously Useful.

Still, combining patches is a whole lot less effort than splitting them,
so I'll err far on that side.

> Sure, but you can put the deletion of the cmpxchg and the out[] array
> in separate commits, where the tree remains building and secure at
> each step.

Definitely!  I'm going to produce as long as patch series as I possibly
can.  But there's always an overall goal to the entire series, and
that's what I'm trying to discuss beforehand.

Looking back, I understand now how my words could lead to confusion.
To me, the race in add_interrupt_randomness is fairly inconsequential
and fixing it is a minor side effect of my overall goal of fixing *all*
the races.

The *fundamental* race, as I see it, is the one between modifying pools
and crediting entropy.

As I noted, you can't safely do the credit either before *or* after modifying
the pool; you will always end up with the wrong answer in some situation.
This is why the RNDADDENTROPY ioctl is required and the RNDADDTOENTCNT
ioctl is old legacy cruft that should never be used.  (Note to self:
add a warning if it's ever used, or even disable it entirely.)

When I said "it's a lot bigger job than that" I was thinking about *my*
agenda of the entire project, when I had just asked "which path do you
think I should take?".  I wasn't trying to imply it would be one patch.

I have half a dozen patches to random.c already waiting.  For example,
one is a bulk conversion of __u8 and __u32 to u8 and u32.  The underscore
versions are only intended for public header files where namespace
pollution is a problem.

But I have to think about ordering and how to present them; a patch like
that is annoying to reorder with others.

(Honestly, my personal preference is to the longer names from <stdint.h>
just because they *are* standard and so very widely used.  But that's
an issue for a maintainer's esthetic judgement.)
