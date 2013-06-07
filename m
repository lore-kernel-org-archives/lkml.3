Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751062Ab3FGEIN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 00:08:13 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50020 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750737Ab3FGEIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 00:08:10 -0400
Message-ID: <1370578083.4021.67.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 058/184] KVM: x86: invalid opcode oops on SET_SREGS with
From: Ben Hutchings <ben@decadent.org.uk>
To: Willy Tarreau <w@1wt.eu>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Petr Matousek <pmatouse@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Date: Fri, 07 Jun 2013 05:08:03 +0100
In-Reply-To: <20130604172132.712738520@1wt.eu>
References: <20130604172132.712738520@1wt.eu>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-jYMPYzeDK90VmRSAZ/ha"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-jYMPYzeDK90VmRSAZ/ha
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2013-06-04 at 19:22 +0200, Willy Tarreau wrote:
> 2.6.32-longterm review patch.  If anyone has any objections, please let m=
e know.
>=20
> ------------------
>  OSXSAVE bit set (CVE-2012-4461)
>=20
> From: Petr Matousek <pmatouse@redhat.com>
>=20
> commit 6d1068b3a98519247d8ba4ec85cd40ac136dbdf9 upstream.
>=20
> On hosts without the XSAVE support unprivileged local user can trigger
> oops similar to the one below by setting X86_CR4_OSXSAVE bit in guest
> cr4 register using KVM_SET_SREGS ioctl and later issuing KVM_RUN
> ioctl.
>=20
> invalid opcode: 0000 [#2] SMP
> Modules linked in: tun ip6table_filter ip6_tables ebtable_nat ebtables
> ...
> Pid: 24935, comm: zoog_kvm_monito Tainted: G      D      3.2.0-3-686-pae
> EIP: 0060:[<f8b9550c>] EFLAGS: 00210246 CPU: 0
> EIP is at kvm_arch_vcpu_ioctl_run+0x92a/0xd13 [kvm]
> EAX: 00000001 EBX: 000f387e ECX: 00000000 EDX: 00000000
> ESI: 00000000 EDI: 00000000 EBP: ef5a0060 ESP: d7c63e70
>  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> Process zoog_kvm_monito (pid: 24935, ti=3Dd7c62000 task=3Ded84a0c0
> task.ti=3Dd7c62000)
> Stack:
>  00000001 f70a1200 f8b940a9 ef5a0060 00000000 00200202 f8769009 00000000
>  ef5a0060 000f387e eda5c020 8722f9c8 00015bae 00000000 ed84a0c0 ed84a0c0
>  c12bf02d 0000ae80 ef7f8740 fffffffb f359b740 ef5a0060 f8b85dc1 0000ae80
> Call Trace:
>  [<f8b940a9>] ? kvm_arch_vcpu_ioctl_set_sregs+0x2fe/0x308 [kvm]
> ...
>  [<c12bfb44>] ? syscall_call+0x7/0xb
> Code: 89 e8 e8 14 ee ff ff ba 00 00 04 00 89 e8 e8 98 48 ff ff 85 c0 74
> 1e 83 7d 48 00 75 18 8b 85 08 07 00 00 31 c9 8b 95 0c 07 00 00 <0f> 01
> d1 c7 45 48 01 00 00 00 c7 45 1c 01 00 00 00 0f ae f0 89
> EIP: [<f8b9550c>] kvm_arch_vcpu_ioctl_run+0x92a/0xd13 [kvm] SS:ESP
> 0068:d7c63e70
>=20
> QEMU first retrieves the supported features via KVM_GET_SUPPORTED_CPUID
> and then sets them later. So guest's X86_FEATURE_XSAVE should be masked
> out on hosts without X86_FEATURE_XSAVE, making kvm_set_cr4 with
> X86_CR4_OSXSAVE fail. Userspaces that allow specifying guest cpuid with
> X86_FEATURE_XSAVE even on hosts that do not support it, might be
> susceptible to this attack from inside the guest as well.
>=20
> Allow setting X86_CR4_OSXSAVE bit only if host has XSAVE support.
>=20
> Signed-off-by: Petr Matousek <pmatouse@redhat.com>
> Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
> [bwh: Backported to 2.6.32: XSAVE is not supported at all, so always
>  deny setting OSXSAVE]

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>

> Signed-off-by: Willy Tarreau <w@1wt.eu>
> ---
>  arch/x86/kvm/x86.c | 3 +++
>  1 file changed, 3 insertions(+)
>=20
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 79905f2..ec9728f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4719,6 +4719,9 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *=
vcpu,
>  	int pending_vec, max_bits;
>  	struct descriptor_table dt;
> =20
> +	if (sregs->cr4 & X86_CR4_OSXSAVE)
> +		return -EINVAL;
> +
>  	vcpu_load(vcpu);
> =20
>  	dt.limit =3D sregs->idt.limit;

--=20
Ben Hutchings
Theory and practice are closer in theory than in practice.
                                - John Levine, moderator of comp.compilers

--=-jYMPYzeDK90VmRSAZ/ha
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUbFco+e/yOyVhhEJAQq6ihAAv3p8xvKsLrbWGbHrkvBWayI4YNKY49wi
XB4fYJ0ubMYdP1Pv8ASdrutef4phfkGVo5MbSnnnYGyq8bBKdj/ogYeJNX1n4Edl
Y071xobIZY19pavTyXQlNZxvdsqBxvjNG+jO0nYTR2ozUZqtGdXc8uZ84n80TshX
usKptJ+F4Z3MjqcJOt7e1gu3JnT+Xtpvh4hrNJ7Tv0KokLpsnAT2niXPaNYoSP1O
wPJqNL9KvHn0TSefM5+k95qyJeGf8HB6z27j1oj/89r275H4mksStlVyutGtBawi
Un5yNnZ0fAfTHcttnuYs/TJgLl+p91GpMUiBMJlWUahlzGLu+QOgXUC1mJJ6pGv1
cVk+LmzsBL7ywqphO68SLe1KrhDscWiLijE6JqTUr7P4xKzNyjYav+2/MAOgtsEl
5LpSnyhlmsjqvHPVo4bStr0+MhGIhHqf+Ic3N6n/MvvDhL0WJFNNQXFkuwvTULaR
F8eo1k/cDqYu/KcCreN/Vev3+eH5hhKVtsjh/Z0P3yDyQZAAtLn/Twb4rwNIF3y+
Vi1yy3H03zJP6t3EUPmv5lU2wYU9sBKYlODaJ5FtR9d+mfn+Fce8KU2W+Gf0tXkn
wxCIcAEWJkD7WvvTerVqwvGVNU9TI7JYYlHetX1rDL29eTSDOtRbg3VAlRGvPDAB
ca6IE1/aMtM=
=7xwZ
-----END PGP SIGNATURE-----

--=-jYMPYzeDK90VmRSAZ/ha--
