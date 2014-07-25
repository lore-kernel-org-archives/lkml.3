Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934094AbaGYQKY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 12:10:24 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:34443 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932605AbaGYQKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 12:10:22 -0400
Date: Fri, 25 Jul 2014 18:10:02 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Waiman Long <waiman.long@hp.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Subject: Re: Linux 3.16-rc6
Message-ID: <20140725161002.GE6758@twins.programming.kicks-ass.net>
References: <CA+55aFzJKxzw_as9iGgeM=MdQ6trUkQLDuoEr8nxj88sOqQnQA@mail.gmail.com>
 <20140723095327.GA23131@pd.tnic>
 <CA+55aFzPs4uF=eR7jCnpyBtgWNRkX-uDfXeo5u34VEvT8_yyzw@mail.gmail.com>
 <20140724064353.GW9918@twins.programming.kicks-ass.net>
 <20140724084126.GB19239@pd.tnic>
 <20140724122513.GM19239@pd.tnic>
 <20140724125814.GX6758@twins.programming.kicks-ass.net>
 <CA+55aFynW5xSRQvY6xO+mxmt6yh7mFkMjy-pgJXpXNy8qDMcPA@mail.gmail.com>
 <20140724183643.GM3935@laptop>
 <53D16EC4.1000801@hp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mio/lN7rX3OFvPvp"
Content-Disposition: inline
In-Reply-To: <53D16EC4.1000801@hp.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mio/lN7rX3OFvPvp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 24, 2014 at 04:38:28PM -0400, Waiman Long wrote:
> Yes, I think I may have a solution for that.
>=20
> Borislav, can you apply the following patch on top of the lockdep patch to
> see if it can fix the problem?
>=20
> diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
> index d24e433..507a8ce 100644
> --- a/kernel/locking/lockdep.c
> +++ b/kernel/locking/lockdep.c
> @@ -3595,6 +3595,12 @@ void lock_acquire(struct lockdep_map *lock, unsign=
ed int
>         raw_local_irq_save(flags);
>         check_flags(flags);
>=20
> +       /*
> +        * An interrupt recursive read in interrupt context can be consid=
ered
> +        * to be the same as a recursive read from checking perspective.
> +        */
> +       if ((read =3D=3D 3) && in_interrupt())
> +               read =3D 2;
>         current->lockdep_recursion =3D 1;
>         trace_lock_acquire(lock, subclass, trylock, read, check, nest_loc=
k, ip);
>         __lock_acquire(lock, subclass, trylock, read, check,

Just had another look at the initial patch and it cannot be right, even
with the above.

The problem is you cannot use in_interrupt() in check_deadlock().
Check_deadlock() must be context invariant, it should only test the
chain state and not rely on where or when its called.



--mio/lN7rX3OFvPvp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT0oFaAAoJEHZH4aRLwOS6+14P/2KJ9un5Fdb3CqY5Y3y1OW7p
4u82Df8al6up/dZHH8SnOqo5KH7a8Bk/nyzDpYYlbsaUvZydRrtY22fOaqxdCEkB
RQFIBigNaYQJ6WQos/yTehOvXOtchKry7ljQZsjMciVkmXFTsPESjsmvwcOT9EUr
XMb3PzpDhS45IFKRaDw95+UUPVWbvGb5orkz99DTyROTa7joVikDE5ykkyBVW+lz
wSMrCkDRYVcwQRKysf6zEaITnAccASJBZ320XjgSin64jScWTH8vabYsYUNaIy/v
e5CFaDVWsLbJz67Gu8P0aOTD/G+UhC372HV4EgOVw6vYdG+d/keDRAGL+e+T9ryL
nMPl7u01mr5W0bi6IjaA9tvULwaI6mqBRw5O/ivzHpOIxebtB8FSatzNNaWLoG8N
5jajbuuHH9dTbbCLhoa1Kjt+vphJd/6Y3YtCOx7oYnUj0VaoJdbaDQKiI4+nstk8
L/zVCOvn5QhAmR/2S2iFQAxcYIRUjmBBc8KiKKexmd/xLWK6zTAsLvPvho7yGnJm
d9DmDoDOtbN4SAIXDLCbL5VtkNpQ6dYoQG5pOfj0Q6wA+5tiZr3NhnChgHI/vBac
z0rHCIHwbXLFpU7XHZAZv2SRK7T/27F79LlZ4jbC01qK/W1IrzMcTQjRUDp0cq6I
Otfczwoir1is/N3Zd1mq
=gT4v
-----END PGP SIGNATURE-----

--mio/lN7rX3OFvPvp--
