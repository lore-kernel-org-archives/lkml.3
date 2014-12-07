Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707AbaLGWl5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 17:41:57 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33258 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751414AbaLGWl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 17:41:56 -0500
Message-ID: <1417992102.11886.51.camel@decadent.org.uk>
Subject: Re: [RFC][PATCH] x86: Make x32 syscall support conditional on a
 kernel parameter
From: Ben Hutchings <ben@decadent.org.uk>
To: Andy Lutomirski <luto@amacapital.net>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 07 Dec 2014 22:41:42 +0000
In-Reply-To: <545BFA2A.5010504@amacapital.net>
References: <1415245982.3398.53.camel@decadent.org.uk>
	 <545BFA2A.5010504@amacapital.net>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-zV9KM1Qv5QhBb5wRDz9S"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-zV9KM1Qv5QhBb5wRDz9S
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2014-11-06 at 14:46 -0800, Andy Lutomirski wrote:
> On 11/05/2014 07:53 PM, Ben Hutchings wrote:
> > Enabling x32 in a distribution default kernel increases its attack
> > surface while providing no benefit to the vast majority of its users.
> > No-one seems interested in regularly checking for vulnerabilities
> > specific to x32 (at least no-one with a white hat).
> >=20
> > Still, requiring a separate or custom configuration just to turn on
> > x32 seems wasteful.  And the only differences on syscall entry are
> > two instructions (mask out the x32 flag and compare the syscall
> > number).
> >=20
> > So pad the standard comparison with a nop and add a kernel parameter
> > "syscall.x32" which controls whether this is replaced with the x32
> > version at boot time.  Add a Kconfig parameter to set the default.
[...]
> > --- a/arch/x86/kernel/entry_64.S
> > +++ b/arch/x86/kernel/entry_64.S
> > @@ -414,8 +414,12 @@ system_call_fastpath:
> >  #if __SYSCALL_MASK =3D=3D ~0
> >  	cmpq $__NR_syscall_max,%rax
> >  #else
> > -	andl $__SYSCALL_MASK,%eax
> > -	cmpl $__NR_syscall_max,%eax
> > +	.globl system_call_fast_compare
> > +	.globl system_call_fast_compare_end
> > +system_call_fast_compare:
> > +	cmpq $511,%rax			/* x32 syscalls start at 512 */
> > +	.byte P6_NOP4
> > +system_call_fast_compare_end:
> >  #endif
> >  	ja ret_from_sys_call  /* and return regs->ax */
> >  	movq %r10,%rcx
> > @@ -520,8 +524,12 @@ tracesys_phase2:
> >  #if __SYSCALL_MASK =3D=3D ~0
> >  	cmpq $__NR_syscall_max,%rax
> >  #else
> > -	andl $__SYSCALL_MASK,%eax
> > -	cmpl $__NR_syscall_max,%eax
> > +	.globl system_call_trace_compare
> > +	.globl system_call_trace_compare_end
> > +system_call_trace_compare:
> > +	cmpq $511,%rax			/* x32 syscalls start at 512 */
> > +	.byte P6_NOP4
> > +system_call_trace_compare_end:
>=20
> I think that, if x32 is disabled, that andl $__SYSCALL_MASK,%rax should
> be nopped out.

Yes, that's what happens.

> Can this, and the comparison, use the standard alternatives mechanism?

There isn't really a standard alternatives mechanism!  There is a CPU-
features alternatives mechanism, an SMP alternatives mechanism and a PV
alternatives mechanism, but they don't share anything above the
text_poke*() functions.

> And why are there extra syscall numbers in x32 land?  There's an x32 bit
> *and* extra numbers.  I'm confused.

I think the extra numbers are assigned for system calls where adjustment
is always needed on entry and exit, while the x32 bit is used to trigger
compat handling if it's needed at a deeper level.  is_compat_task()
tests the latter.

> That magic number is bad.  I would make it a real #define and put an
> appropriate assertion into whatever generates syscalls_64.h.
>=20
> Also, if you do this, can you change all four instances of %eax in there
> to %rax?  %eax is just wrong AFAICT.

I can only guess that %eax is currently used because it makes the code
slightly smaller (no REX prefix needed).

> Also, as a heads up to anyone who actually uses this: I was confused
> about the audit situation on x32-enabled kernels.  I thought that this
> patch had been applied:
>=20
> https://www.redhat.com/archives/linux-audit/2014-May/msg00099.html
>=20
> but it wasn't.  As a result, the commit message for this fix is wrong:
>=20
> 81f49a8fd708 x86, x32, audit: Fix x32's AUDIT_ARCH wrt audit
>=20
> It *is* a user-visible fix and should possibly go to -stable, especially
> if anyone actually uses this *!$@ thing.  Of course, audit is royally
> screwed up on x32-enabled kernels anyway.  I admit that I find myself
> barely caring.

Thanks; this went into 3.16.7-ckt2 and should go into a Debian kernel
update soon.

Ben.

--=20
Ben Hutchings
Experience is directly proportional to the value of equipment destroyed.
                                                         - Carolyn Scheppne=
r

--=-zV9KM1Qv5QhBb5wRDz9S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAVITXque/yOyVhhEJAQp34BAAiIwneR1ef5EyZSpIBIU9gHoxw/HzDqvs
C2yqWLKn/rBpUIE/uzGGjDAve+Uo3E5skpGjeAUXbt7hpOr5rY06t1UWYVhq1aPe
leUxNa68hwhIFPN23W1EmtAp/vDBmgB9BLizDARMw6REOlOlpU8MK9ZA8r/6DS3B
S98k2rfdPz5wVHEojxg/D/A0FAlDS+LG9nHLqAie9GrKPYRJKX0Dxo6mOSGVACZB
F+6T4JK1G0q+j7k0+jqHr13jgM4W8SfsUvRBMjBTKMl2JiB6nz8/eUbEq7JYDbi9
ALPapBiY7cdLlrBseoy3AYRUOe6F01fcf/rqa0mEJplEqivoPg8U7S94d9QULazw
eXEZOt2MA5lvxuIXhPNXU4IXS8mc9tf4685QjfHMTTEL+k4EuZOBo6Ohq3U2Bejo
ykqCv701XDzzRp7t9MrTFq6N1Yy9hGqRa6pmPD3d9idiwdhXXOFNI1JarlIx2UMt
nXQlwMjTk53Or1EPAmtITR+1/PJkpXfYGUHU8D+ZSCBfNAQ3htk2azkhCpyC3H7V
+sbtRm6Yr0KFpVZ6hgrJRVZuLaHYndvncEfqHlFdv+1I9ecO9Pgo08pYQTvVTr2u
Axyn11AdqinwMp1hY1nZjXOZOhWfvb6anhMHLXIz+3Hh94bMm4/ykekPeasH0I4z
BzLPg3lyWZc=
=TJWC
-----END PGP SIGNATURE-----

--=-zV9KM1Qv5QhBb5wRDz9S--
