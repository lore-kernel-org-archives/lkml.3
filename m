Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932065AbaENRAd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 13:00:33 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:37916 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754703AbaENRAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 13:00:32 -0400
Date: Wed, 14 May 2014 19:00:16 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc: Waiman Long <waiman.long@hp.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Paolo Bonzini <paolo.bonzini@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Oleg Nesterov <oleg@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Scott J Norton <scott.norton@hp.com>, Chegu Vinod <chegu_vinod@hp.com>
Subject: Re: [PATCH v10 03/19] qspinlock: Add pending bit
Message-ID: <20140514170016.GW30445@twins.programming.kicks-ass.net>
References: <1399474907-22206-1-git-send-email-Waiman.Long@hp.com>
 <1399474907-22206-4-git-send-email-Waiman.Long@hp.com>
 <20140512152208.GA12309@potion.brq.redhat.com>
 <537276B4.10209@hp.com>
 <20140514165121.GA21370@potion.redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EnT6sQnqsTJq4oDy"
Content-Disposition: inline
In-Reply-To: <20140514165121.GA21370@potion.redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EnT6sQnqsTJq4oDy
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 14, 2014 at 06:51:24PM +0200, Radim Kr=C4=8Dm=C3=A1=C5=99 wrote:
> Ok.
> I've seen merit in pvqspinlock even with slightly slower first-waiter,
> so I would have happily sacrificed those horrible branches.
> (I prefer elegant to optimized code, but I can see why we want to be
>  strictly better than ticketlock.)
> Peter mentioned that we are focusing on bare-metal patches, so I'll
> withold my other paravirt rants until they are polished.

Well, paravirt must happen too, but comes later in this series, patch 3
which we're replying to is still very much in the bare metal part of the
series.

I've not had time yet to decode all that Waiman has done to make
paravirt work.

But as a general rule I like patches that start with something simple
and working and then optimize it, this series doesn't seem to quite
grasp that.

> And to forcefully bring this thread a little bit on-topic:
>=20
> Pending-bit is effectively a lock in a lock, so I was wondering why
> don't we use more pending bits; advantages are the same, just diminished
> by the probability of having an ideally contended lock:
>  - waiter won't be blocked on RAM access if critical section (or more)
>    ends sooner
>  - some unlucky cacheline is not forgotten
>  - faster unlock (no need for tail operations)
> (- ?)
> disadvantages are magnified:
>  - increased complexity
>  - intense cacheline sharing
>    (I thought that this is the main disadvantage of ticketlock.)
> (- ?)
>=20
> One bit still improved performance, is it the best we got?

So, the advantage of one bit is that if we use a whole byte for 1 bit we
can avoid some atomic ops.

The entire reason for this in-word spinner is to amortize the cost of
hitting the external node cacheline.

So traditional locks like test-and-test and the ticket lock only ever
access the spinlock word itsef, this MCS style queueing lock has a
second (and, see my other rants in this thread, when done wrong more
than 2) cacheline to touch.

That said, all our benchmarking is pretty much for the cache-hot case,
so I'm not entirely convinced yet that the one pending bit makes up for
it, it does in the cache-hot case.

But... writing cache-cold benchmarks is _hard_ :/

--EnT6sQnqsTJq4oDy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTc6EgAAoJEHZH4aRLwOS6YbQQAKinRXw0QntsvwaHuZgv+lW5
tWDt5Yal7nlRalCmtFPgpuvbryv0YW+JXtqe8dDraLlhVEfOMzdxLstlp4gTnMF6
W+taUUOOnK5EWFlYLCH2pTl2jPET+2eE3VS2i86VWx+yTIpci2avAqyh5rr1U5xp
xXnrlcYnAJwgfGL30DNpeT9RY7CvrBJPdgRxiMkyKztesgsKnszM7vp/TOJLAES/
N1P4PSDNT6Nq+xfNgww4mqUeh4VVDEAamxwrTgciNn293BrZkGpMfnWNZLFtcjpK
8b97heHhgGryhFjjZi5AqCb6tn2lidmB8FfSYHJa8KLrQ2ZhjYqvH94lL3rhsNFa
ow8zhqBqNqNJCoavWv33WYICuC5X4+StAPjKfBzv8czucMkemElirsjVtfPmB81L
WAvLrqgiMLrQpzT/CspIjH96UnkdDGbc+znOaBBHZVvBceiqeHVbuJEEe1Y4H70W
psNfoOpZJg5HxEdGsBA3QRPTkYRC37/5rF2DhMZLx4QJkEvN2pRSdqm7j0xQxNBY
Ufwf7h5s6wJRVGCtqI1VcDZNJFBVv633EF1Y/h8sTAA3+HITwqcT5B+gpOUR0Y/Z
CtLXP28NU2WWB7p403VoFkwzJozhjdmXBK0W2fdqoZcuAVESpPhdiikj4cu0zr83
Vn3uwO+kYODw5+MUt+dB
=JLaw
-----END PGP SIGNATURE-----

--EnT6sQnqsTJq4oDy--
