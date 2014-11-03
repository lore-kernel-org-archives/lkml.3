Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751820AbaKCNvX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 08:51:23 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41337 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751130AbaKCNvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 08:51:21 -0500
Message-ID: <1415022668.27313.26.camel@decadent.org.uk>
Subject: Re: [PATCH 3.2 091/102] KVM: x86: Emulator fixes for eip canonical
 checks on near branches
From: Ben Hutchings <ben@decadent.org.uk>
To: Nadav Amit <nadav.amit@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Nadav Amit <namit@cs.technion.ac.il>,
        Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 03 Nov 2014 13:51:08 +0000
In-Reply-To: <5662151C-90D9-425C-A271-25040AC995C9@gmail.com>
References: <lsq.1414880883.456017848@decadent.org.uk>
	 <5662151C-90D9-425C-A271-25040AC995C9@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-VzMum9LDQcl9Kev07ZR5"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-VzMum9LDQcl9Kev07ZR5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2014-11-02 at 10:44 +0200, Nadav Amit wrote:
> Sorry, but this patch is incomplete due to a bug.
> The following patch - http://www.spinics.net/lists/kvm/msg109664.html - i=
s needed as well (on top of the previous one).

Thanks, I've added that (commit 7e46dddd6f6c).

Ben.

> Nadav
>=20
> > On Nov 2, 2014, at 00:28, Ben Hutchings <ben@decadent.org.uk> wrote:
> >=20
> > 3.2.64-rc1 review patch.  If anyone has any objections, please let me k=
now.
> >=20
> > ------------------
> >=20
> > From: Nadav Amit <namit@cs.technion.ac.il>
> >=20
> > commit 234f3ce485d54017f15cf5e0699cff4100121601 upstream.
> >=20
> > Before changing rip (during jmp, call, ret, etc.) the target should be =
asserted
> > to be canonical one, as real CPUs do.  During sysret, both target rsp a=
nd rip
> > should be canonical. If any of these values is noncanonical, a #GP exce=
ption
> > should occur.  The exception to this rule are syscall and sysenter inst=
ructions
> > in which the assigned rip is checked during the assignment to the relev=
ant
> > MSRs.
> >=20
> > This patch fixes the emulator to behave as real CPUs do for near branch=
es.
> > Far branches are handled by the next patch.
> >=20
> > This fixes CVE-2014-3647.
> >=20
> > Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > [bwh: Backported to 3.2:
> > - Adjust context
> > - Use ctxt->regs[] instead of reg_read(), reg_write(), reg_rmw()]
> > Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> > ---
> > arch/x86/kvm/emulate.c | 78 ++++++++++++++++++++++++++++++++++---------=
-------
> > 1 file changed, 54 insertions(+), 24 deletions(-)
> >=20
> > --- a/arch/x86/kvm/emulate.c
> > +++ b/arch/x86/kvm/emulate.c
> > @@ -529,7 +529,8 @@ static int emulate_nm(struct x86_emulate
> > 	return emulate_exception(ctxt, NM_VECTOR, 0, false);
> > }
> >=20
> > -static inline void assign_eip_near(struct x86_emulate_ctxt *ctxt, ulon=
g dst)
> > +static inline int assign_eip_far(struct x86_emulate_ctxt *ctxt, ulong =
dst,
> > +			       int cs_l)
> > {
> > 	switch (ctxt->op_bytes) {
> > 	case 2:
> > @@ -539,16 +540,25 @@ static inline void assign_eip_near(struc
> > 		ctxt->_eip =3D (u32)dst;
> > 		break;
> > 	case 8:
> > +		if ((cs_l && is_noncanonical_address(dst)) ||
> > +		    (!cs_l && (dst & ~(u32)-1)))
> > +			return emulate_gp(ctxt, 0);
> > 		ctxt->_eip =3D dst;
> > 		break;
> > 	default:
> > 		WARN(1, "unsupported eip assignment size\n");
> > 	}
> > +	return X86EMUL_CONTINUE;
> > +}
> > +
> > +static inline int assign_eip_near(struct x86_emulate_ctxt *ctxt, ulong=
 dst)
> > +{
> > +	return assign_eip_far(ctxt, dst, ctxt->mode =3D=3D X86EMUL_MODE_PROT6=
4);
> > }
> >=20
> > -static inline void jmp_rel(struct x86_emulate_ctxt *ctxt, int rel)
> > +static inline int jmp_rel(struct x86_emulate_ctxt *ctxt, int rel)
> > {
> > -	assign_eip_near(ctxt, ctxt->_eip + rel);
> > +	return assign_eip_near(ctxt, ctxt->_eip + rel);
> > }
> >=20
> > static u16 get_segment_selector(struct x86_emulate_ctxt *ctxt, unsigned=
 seg)
> > @@ -1787,13 +1797,15 @@ static int em_grp45(struct x86_emulate_c
> > 	case 2: /* call near abs */ {
> > 		long int old_eip;
> > 		old_eip =3D ctxt->_eip;
> > -		ctxt->_eip =3D ctxt->src.val;
> > +		rc =3D assign_eip_near(ctxt, ctxt->src.val);
> > +		if (rc !=3D X86EMUL_CONTINUE)
> > +			break;
> > 		ctxt->src.val =3D old_eip;
> > 		rc =3D em_push(ctxt);
> > 		break;
> > 	}
> > 	case 4: /* jmp abs */
> > -		ctxt->_eip =3D ctxt->src.val;
> > +		rc =3D assign_eip_near(ctxt, ctxt->src.val);
> > 		break;
> > 	case 5: /* jmp far */
> > 		rc =3D em_jmp_far(ctxt);
> > @@ -1825,10 +1837,14 @@ static int em_grp9(struct x86_emulate_ct
> >=20
> > static int em_ret(struct x86_emulate_ctxt *ctxt)
> > {
> > -	ctxt->dst.type =3D OP_REG;
> > -	ctxt->dst.addr.reg =3D &ctxt->_eip;
> > -	ctxt->dst.bytes =3D ctxt->op_bytes;
> > -	return em_pop(ctxt);
> > +	int rc;
> > +	unsigned long eip;
> > +
> > +	rc =3D emulate_pop(ctxt, &eip, ctxt->op_bytes);
> > +	if (rc !=3D X86EMUL_CONTINUE)
> > +		return rc;
> > +
> > +	return assign_eip_near(ctxt, eip);
> > }
> >=20
> > static int em_ret_far(struct x86_emulate_ctxt *ctxt)
> > @@ -2060,7 +2076,7 @@ static int em_sysexit(struct x86_emulate
> > {
> > 	struct x86_emulate_ops *ops =3D ctxt->ops;
> > 	struct desc_struct cs, ss;
> > -	u64 msr_data;
> > +	u64 msr_data, rcx, rdx;
> > 	int usermode;
> > 	u16 cs_sel =3D 0, ss_sel =3D 0;
> >=20
> > @@ -2076,6 +2092,9 @@ static int em_sysexit(struct x86_emulate
> > 	else
> > 		usermode =3D X86EMUL_MODE_PROT32;
> >=20
> > +	rcx =3D ctxt->regs[VCPU_REGS_RCX];
> > +	rdx =3D ctxt->regs[VCPU_REGS_RDX];
> > +
> > 	cs.dpl =3D 3;
> > 	ss.dpl =3D 3;
> > 	ops->get_msr(ctxt, MSR_IA32_SYSENTER_CS, &msr_data);
> > @@ -2093,6 +2112,9 @@ static int em_sysexit(struct x86_emulate
> > 		ss_sel =3D cs_sel + 8;
> > 		cs.d =3D 0;
> > 		cs.l =3D 1;
> > +		if (is_noncanonical_address(rcx) ||
> > +		    is_noncanonical_address(rdx))
> > +			return emulate_gp(ctxt, 0);
> > 		break;
> > 	}
> > 	cs_sel |=3D SELECTOR_RPL_MASK;
> > @@ -2101,8 +2123,8 @@ static int em_sysexit(struct x86_emulate
> > 	ops->set_segment(ctxt, cs_sel, &cs, 0, VCPU_SREG_CS);
> > 	ops->set_segment(ctxt, ss_sel, &ss, 0, VCPU_SREG_SS);
> >=20
> > -	ctxt->_eip =3D ctxt->regs[VCPU_REGS_RDX];
> > -	ctxt->regs[VCPU_REGS_RSP] =3D ctxt->regs[VCPU_REGS_RCX];
> > +	ctxt->_eip =3D rdx;
> > +	ctxt->regs[VCPU_REGS_RSP] =3D rcx;
> >=20
> > 	return X86EMUL_CONTINUE;
> > }
> > @@ -2555,10 +2577,13 @@ static int em_das(struct x86_emulate_ctx
> >=20
> > static int em_call(struct x86_emulate_ctxt *ctxt)
> > {
> > +	int rc;
> > 	long rel =3D ctxt->src.val;
> >=20
> > 	ctxt->src.val =3D (unsigned long)ctxt->_eip;
> > -	jmp_rel(ctxt, rel);
> > +	rc =3D jmp_rel(ctxt, rel);
> > +	if (rc !=3D X86EMUL_CONTINUE)
> > +		return rc;
> > 	return em_push(ctxt);
> > }
> >=20
> > @@ -2590,11 +2615,12 @@ static int em_call_far(struct x86_emulat
> > static int em_ret_near_imm(struct x86_emulate_ctxt *ctxt)
> > {
> > 	int rc;
> > +	unsigned long eip;
> >=20
> > -	ctxt->dst.type =3D OP_REG;
> > -	ctxt->dst.addr.reg =3D &ctxt->_eip;
> > -	ctxt->dst.bytes =3D ctxt->op_bytes;
> > -	rc =3D emulate_pop(ctxt, &ctxt->dst.val, ctxt->op_bytes);
> > +	rc =3D emulate_pop(ctxt, &eip, ctxt->op_bytes);
> > +	if (rc !=3D X86EMUL_CONTINUE)
> > +		return rc;
> > +	rc =3D assign_eip_near(ctxt, eip);
> > 	if (rc !=3D X86EMUL_CONTINUE)
> > 		return rc;
> > 	register_address_increment(ctxt, &ctxt->regs[VCPU_REGS_RSP], ctxt->src=
.val);
> > @@ -2840,20 +2866,24 @@ static int em_lmsw(struct x86_emulate_ct
> >=20
> > static int em_loop(struct x86_emulate_ctxt *ctxt)
> > {
> > +	int rc =3D X86EMUL_CONTINUE;
> > +
> > 	register_address_increment(ctxt, &ctxt->regs[VCPU_REGS_RCX], -1);
> > 	if ((address_mask(ctxt, ctxt->regs[VCPU_REGS_RCX]) !=3D 0) &&
> > 	    (ctxt->b =3D=3D 0xe2 || test_cc(ctxt->b ^ 0x5, ctxt->eflags)))
> > -		jmp_rel(ctxt, ctxt->src.val);
> > +		rc =3D jmp_rel(ctxt, ctxt->src.val);
> >=20
> > -	return X86EMUL_CONTINUE;
> > +	return rc;
> > }
> >=20
> > static int em_jcxz(struct x86_emulate_ctxt *ctxt)
> > {
> > +	int rc =3D X86EMUL_CONTINUE;
> > +
> > 	if (address_mask(ctxt, ctxt->regs[VCPU_REGS_RCX]) =3D=3D 0)
> > -		jmp_rel(ctxt, ctxt->src.val);
> > +		rc =3D jmp_rel(ctxt, ctxt->src.val);
> >=20
> > -	return X86EMUL_CONTINUE;
> > +	return rc;
> > }
> >=20
> > static int em_cli(struct x86_emulate_ctxt *ctxt)
> > @@ -3946,7 +3976,7 @@ special_insn:
> > 		break;
> > 	case 0x70 ... 0x7f: /* jcc (short) */
> > 		if (test_cc(ctxt->b, ctxt->eflags))
> > -			jmp_rel(ctxt, ctxt->src.val);
> > +			rc =3D jmp_rel(ctxt, ctxt->src.val);
> > 		break;
> > 	case 0x8d: /* lea r16/r32, m */
> > 		ctxt->dst.val =3D ctxt->src.addr.mem.ea;
> > @@ -3994,7 +4024,7 @@ special_insn:
> > 		goto do_io_out;
> > 	case 0xe9: /* jmp rel */
> > 	case 0xeb: /* jmp rel short */
> > -		jmp_rel(ctxt, ctxt->src.val);
> > +		rc =3D jmp_rel(ctxt, ctxt->src.val);
> > 		ctxt->dst.type =3D OP_NONE; /* Disable writeback. */
> > 		break;
> > 	case 0xec: /* in al,dx */
> > @@ -4160,7 +4190,7 @@ twobyte_insn:
> > 		break;
> > 	case 0x80 ... 0x8f: /* jnz rel, etc*/
> > 		if (test_cc(ctxt->b, ctxt->eflags))
> > -			jmp_rel(ctxt, ctxt->src.val);
> > +			rc =3D jmp_rel(ctxt, ctxt->src.val);
> > 		break;
> > 	case 0x90 ... 0x9f:     /* setcc r/m8 */
> > 		ctxt->dst.val =3D test_cc(ctxt->b, ctxt->eflags);
> >=20
>=20

--=20
Ben Hutchings
Power corrupts.  Absolute power is kind of neat.
                           - John Lehman, Secretary of the US Navy 1981-198=
7

--=-VzMum9LDQcl9Kev07ZR5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAVFeIUee/yOyVhhEJAQoTxxAA1OiZ4br9AIf6DyJGXNsM8LbKN59XF7vJ
232zweysJMXdVA0Wnp7D96hQfIst3jD2C74BneSTbodEz9YzJxTc4bSaKg1pprf5
c9bXqR1QaxFcmAIXxUQgVVLrVifXqMOtPhta+gvLYotGxNnrg0zY2djPPAniKmW8
7h0Pw+p7eHvpVyoXUNgvQea1SLghwCRewtU8ww+CZApUjnfTp2/D6pw5b53YDAUq
31FxL/OCH5S1tEMX3X2zRMS8HiK4E18sTPcBgLsFF6hVmfFTfOlNKN5Geq7SHE6c
SarQUZApRy6YePEJiqNKnMXxARHnR39UyO0pgPE+rXndfEn1XTTkMCwntKsC2loI
dwL3UVJpcxXR5hzmyQHQa412eR8CxRjaQYJY/ykj8/X8vmotssH+UIOsPyTPve89
TRqCBQifp+/yJcV5aUh9kwZTunyPInTHcHyEC4o5dqCoYrBjMGXfpGNS/kLTxmPJ
lZEr698+LKmzJ+2C8EGUSV5AIkMRVFvPL7pPo2vQa/b0fM6CC1nioAMzg5EhvDUr
+XvYcvN22+5iJVMiL2DEVDBZqorpHCagvzrmv9lTbvxccE+UoUQlP4FMlFJLvSDo
JY9VO5fj8hyVOQgo0KVk186mfz13H5C0HLB4k7U0a78dyfcoSRWTd8GLdT9y00Es
trMl9+1HWv0=
=nLSJ
-----END PGP SIGNATURE-----

--=-VzMum9LDQcl9Kev07ZR5--
