Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533AbaGUHSw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 03:18:52 -0400
Received: from imap.thunk.org ([74.207.234.97]:46838 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753438AbaGUHSt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 03:18:49 -0400
Date: Mon, 21 Jul 2014 03:18:37 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Dwayne Litzenberger <dlitz@dlitz.net>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-abi@vger.kernel.org, linux-crypto@vger.kernel.org,
        beck@openbsd.org
Subject: Re: [PATCH, RFC] random: introduce getrandom(2) system call
Message-ID: <20140721071837.GA24960@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Dwayne Litzenberger <dlitz@dlitz.net>,
	Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
	linux-abi@vger.kernel.org, linux-crypto@vger.kernel.org,
	beck@openbsd.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140721061839.GA19200@rivest.lan>
 <20140721002540.GA20595@rivest.lan>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 20, 2014 at 05:25:40PM -0700, Dwayne Litzenberger wrote:
> 
> This could still return predictable bytes during early boot, though, right?

Read the suggetsed man page; especially, the version of the man page
in the commit description -v4 version of the patch.

getrandom(2) is a new interface, so I can afford do things differently
from redaing from /dev/urandom.  Specifically, it will block until it
is fully initialized, and in GRND_NONBLOCK mode, it will return
EAGAIN.

There have been some people kvetching and whining that this is less
convenient for seeding srand(3), but for non-crypto uses, using
getpid() and time() to seed random(3) or rand(3) is just fine, and if
they really want, they can open /dev/urandom.

> >	The system call getrandom() fills the buffer pointed to by buf
> >	with up to buflen random bytes which can be used to seed user
> >	space random number generators (i.e., DRBG's) or for other
> >	cryptographic processes.  It should not be used Monte Carlo
> >	simulations or for other probabilistic sampling applications.
> 
> Aside from poor performance for the offending application, will anything
> actually break if an application ignores this warning and makes heavy
> use of getrandom(2)?  

It will be slow, and then the graduate student will whine and complain
and send a bug report.  It will cause urandom to pull more heavily on
entropy, and if that means that you are using some kind of hardware
random generator on a laptop, such as tpm-rng, you will burn more
battery, but no, it will not break.  This is why the man page says
SHOULD not, and not MUST not.   :-)


> As the developer of a userspace crypto library, I can't always prevent
> downstream developers from doing silly things, and many developers
> simply don't understand different "kinds" of random numbers, so I prefer
> to tell them to just use the kernel CSPRNG by default, and to ask for
> help once they run into performance problems.  It's not ideal, but it's
> safer than the alternative.[1]

Yes, but the point is that Monte Carlo simulations don't need any kind
crypto guarantees.

> Hm.  Is it correct that, in blocking mode, the call is guaranteed either
> to return -EINVAL immediately, or to block until the buffer is
> *completely* populated with buflen bytes?  If so, I think a few small
> changes could make this a really nice interface to work with:
> 
> * Use blocking mode by default.

Read the -v4 version of the patch.  Blocking is now the default.

> * Add a new flag called GRND_PARTIAL (replacing GRND_BLOCK), which
>  indicates that the caller is prepared to handle a partial/incomplete
>  result.

This is not needed if you are using the preferred use of flags == 0,
and are extracting a sane amount of entropy.  For values of buflen <
256 bytes, once urandom pool is initialized, getrandom(buf, buflen, 0)
will not block and will always return the amount of entropy that you
asked for.

But if the user asks for INT_MAX bytes, getrandom(2) must be
interruptible, or else you will end up burning CPU time for a long,
LONG, LONG time.  The choice was to either pick some arbitrarily
limit, such as 256, and then return EIO, which is what OpenBSD did.  I
decided to simply allow getrandom(2) to be interruptible if buflen >
256.

Similarly, if you use GRND_RANDOM, you are also implicitly agreeing
for what you are calling GRND_PARTIAL semantics, because otherwise,
you could end up blocking for a very long time, with no way to
interrupt a buggy program.

I'd much rather keep things simple, and not add too many extra flags,
especially when certain combination of flags result in a really
unfriendly / insane result.

> * If GRND_PARTIAL is *not* set, just return 0 on success.  (This avoids
>  all signed-unsigned confusion when buflen > INT_MAX.)

We simply cap any requests for buflen > INT_MAX, and in practice, it
would take so long to generate the requested number of bytes that the
user would want to interrupt the process anyway.

I considered adding a printk to shame any application writer that
tried to ask for more than 256 bytes, but ultimately decided that was
a bit over the top.  But in any case, any request anywhere near
INT_MAX bytes is really not anything I'm concerned about.  If we do
start seeing evidence for that, I might reconsider and add some kind
of "Warning!  The author of [current->comm] is asking for insane
amounts of entropy" printk.

> With those changes, it would be trivial for a userspace library to
> implement a reliable RNG interface as recommended in [2] or [3]:

The userspace library should ideally be integrted into glibc, so it is
fork- and thread- aware, and it should use a proper CRNG, much like
OpenBSD's arcrandom(3).  There's been a proposal submitted to the
Austin Group for future standardization in Posix, and I'm all in favor
of something like that.

> P.S.  If I had my way, I would also drop GRND_RANDOM.  Most software
> won't use it, there's no legacy installed base, and no developer who
> still wants that behavior can legitimately claim to care about RNG
> availability guarantees, IMHO.

GnuPG uses /dev/random when generating long term public keys.  So
there are some use cases where I think GRND_RANDOM makes sense.  I
agree they are not the normal ones, but they do exist.

> [1] On more than one occasion, I've seen developers use Python's
>    standard "random" module to generate IVs.  I mean, why not?  IVs are
>    public, right?

Why are they writing code that needs raw IV's in the first place?
Sounds like a misdesigned crypto library for me, or they were using
low-level crypto when they should have been using a more higher-level
abstraction.

The fundamental problem is that it's impossible to make an interface
be moron-proof because morons are so ingenious.  :-) If they are so
misinformed that they are using random(3) to generate IV's, they are
extremely likely to be making other, much more fundamentally wrong
mistakes.  The only real solution is to not let them anywhere near
that level of crypto programming, which means you need to have high
level libraries which are so appealing and easy to use that they
aren't tempted to go low level on you...

Originally I thought that the answer was to have a userspace library
interface where you would ask the user to tell you whether they needed
the interface for Monte Carlo simulations, IV's, padding, session
keys, long-term keys, etc.  However, the counter argument was that the
morons that would be helped by this explicit statement of need would
likely be making other crypto-implementation mistakes anyway, so it's
not worth it.

The one reamining reason why specifying the usage of the random values
might be useful is if you are in a world where various NIST standards
or some Military- or credit-card-processing imposed standards might
require you to say, using a certified hardware RNG for long-term keys,
but allowed the use of a crypto-based DRBG for session keys (for
example), that's something that could be configured or controlled in a
single location.

Cheers,

						- Ted
