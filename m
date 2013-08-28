Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626Ab3H1HWe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 03:22:34 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:43040 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058Ab3H1HWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 03:22:32 -0400
Date: Wed, 28 Aug 2013 17:22:25 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mike Turquette <mturquette@linaro.org>
Cc: =?UTF-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>,
        James Hogan <james.hogan@imgtec.com>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Michal Simek <michal.simek@xilinx.com>
Subject: Re: linux-next: manual merge of the clk tree with Linus' tree
Message-Id: <20130828172225.97f295645c9de0bbd2979fcd@canb.auug.org.au>
In-Reply-To: <20130828100431.3005d52d77c565c241399269@canb.auug.org.au>
References: <20130827190304.c3f2f891f20d078d66b703b1@canb.auug.org.au>
	<521C7AF0.1020903@imgtec.com>
	<20f57100-4440-4353-9c84-6e5781f7c6d3@DB9EHSMHS025.ehs.local>
	<20130827165319.8231.9@quantum>
	<20130828100431.3005d52d77c565c241399269@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__28_Aug_2013_17_22_25_+1000_Vjx63zM.t0BTFvg2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__28_Aug_2013_17_22_25_+1000_Vjx63zM.t0BTFvg2
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Wed, 28 Aug 2013 10:04:31 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> On Tue, 27 Aug 2013 09:53:19 -0700 Mike Turquette <mturquette@linaro.org>=
 wrote:
> >
> > Quoting S=C3=B6ren Brinkmann (2013-08-27 08:44:11)
> > > On Tue, Aug 27, 2013 at 11:09:52AM +0100, James Hogan wrote:
> > > > On 27/08/13 10:03, Stephen Rothwell wrote:
> > > > > Hi Mike,
> > > > >=20
> > > > > Today's linux-next merge of the clk tree got a conflict in
> > > > > drivers/clk/zynq/clkc.c between commits 252957cc3a2d ("clk/zynq/c=
lkc: Add
> > > > > dedicated spinlock for the SWDT") and 765b7d4c4cb3
> > > > > ("clk/zynq/clkc: Add CLK_SET_RATE_PARENT flag to ethernet muxes")=
 from
> > > > > Linus' tree and commit 819c1de344c5 ("clk: add CLK_SET_RATE_NO_RE=
PARENT
> > > > > flag") from the clk tree.
> > > > >=20
> > > > > I fixed it up (see below and in a couple of places I chose
> > > > > CLK_SET_RATE_NO_REPARENT over CLK_SET_RATE_PARENT, which may, of =
course,
> > > > > be wrong) and can carry the fix as necessary (no action is requir=
ed).
> > > >=20
> > > > The case you mentioned looks correct to me.
> > > >=20
> > > > I can't see todays -next yet, but if by "choose CLK_SET_RATE_NO_REP=
ARENT
> > > > over CLK_SET_RATE_PARENT" you mean one branch adds CLK_SET_RATE_PAR=
ENT,
> > > > clk-next adds CLK_SET_RATE_NO_REPARENT, and the resolution ends up =
with
> > > > only CLK_SET_RATE_NOREPARENT then that sounds wrong, as the two fla=
gs
> > > > are orthogonal.
> > >=20
> > > I can just agree, the case included in the mail looks correct, but in
> > > case of other conflicts both flags should be set. Just like in the ca=
se
> > > shown here.
> >=20
> > Stephen's fix is correct. The Zynq patches came in as fixes so I think
> > this will be a rare event.
>=20
> Can you guys discuss this and come up with a single answer.  I read the a=
bove as:
>=20
> (for the two places I used CLK_SET_RATE_NO_REPARENT where the two
> branches each added that and CLK_SET_RATE_NOREPARENT respectively)
>=20
> "Stephen was wrong"
> "Stephen should have taken both"
> "Stephen was right"
>=20
> :-)
>=20
> I can fix up my merge resolution if you tell me the correct fix.  Also,
> you will need to know so that you can tell Linus (or whoever else has to
> resolve these conflicts).

OK, I thought about it some more and the resolution now looks like
below.  Is this correct/better?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

6c92037c7a4574c16bc86873fe603b39b7fbe98a
diff --cc drivers/clk/zynq/clkc.c
index 089d3e3,e05c9e3..6f104db
--- a/drivers/clk/zynq/clkc.c
+++ b/drivers/clk/zynq/clkc.c
@@@ -293,8 -294,9 +295,9 @@@ static void __init zynq_clk_setup(struc
  			swdt_ext_clk_mux_parents[i + 1] =3D dummy_nm;
  	}
  	clks[swdt] =3D clk_register_mux(NULL, clk_output_name[swdt],
- 			swdt_ext_clk_mux_parents, 2, CLK_SET_RATE_PARENT,
- 			SLCR_SWDT_CLK_SEL, 0, 1, 0, &swdtclk_lock);
+ 			swdt_ext_clk_mux_parents, 2, CLK_SET_RATE_PARENT |
+ 			CLK_SET_RATE_NO_REPARENT, SLCR_SWDT_CLK_SEL, 0, 1, 0,
 -			&gem0clk_lock);
++			&swdtclk_lock);
 =20
  	/* DDR clocks */
  	clk =3D clk_register_divider(NULL, "ddr2x_div", "ddrpll", 0,
@@@ -366,8 -369,8 +370,8 @@@
  			CLK_DIVIDER_ONE_BASED | CLK_DIVIDER_ALLOW_ZERO,
  			&gem0clk_lock);
  	clk =3D clk_register_mux(NULL, "gem0_emio_mux", gem0_mux_parents, 2,
- 			CLK_SET_RATE_PARENT, SLCR_GEM0_CLK_CTRL, 6, 1, 0,
 -			CLK_SET_RATE_NO_REPARENT, SLCR_GEM0_CLK_CTRL, 6, 1, 0,
--			&gem0clk_lock);
++			CLK_SET_RATE_PARENT | CLK_SET_RATE_NO_REPARENT,
++			SLCR_GEM0_CLK_CTRL, 6, 1, 0, &gem0clk_lock);
  	clks[gem0] =3D clk_register_gate(NULL, clk_output_name[gem0],
  			"gem0_emio_mux", CLK_SET_RATE_PARENT,
  			SLCR_GEM0_CLK_CTRL, 0, 0, &gem0clk_lock);
@@@ -389,8 -393,8 +394,8 @@@
  			CLK_DIVIDER_ONE_BASED | CLK_DIVIDER_ALLOW_ZERO,
  			&gem1clk_lock);
  	clk =3D clk_register_mux(NULL, "gem1_emio_mux", gem1_mux_parents, 2,
- 			CLK_SET_RATE_PARENT, SLCR_GEM1_CLK_CTRL, 6, 1, 0,
 -			CLK_SET_RATE_NO_REPARENT, SLCR_GEM1_CLK_CTRL, 6, 1, 0,
--			&gem1clk_lock);
++			CLK_SET_RATE_PARENT | CLK_SET_RATE_NO_REPARENT,
++			SLCR_GEM1_CLK_CTRL, 6, 1, 0, &gem1clk_lock);
  	clks[gem1] =3D clk_register_gate(NULL, clk_output_name[gem1],
  			"gem1_emio_mux", CLK_SET_RATE_PARENT,
  			SLCR_GEM1_CLK_CTRL, 0, 0, &gem1clk_lock);

--Signature=_Wed__28_Aug_2013_17_22_25_+1000_Vjx63zM.t0BTFvg2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSHaU1AAoJEECxmPOUX5FEmnoP/j4WCZ21BJxwt61HhBvsre5i
NzVafZHpFAzx03NAEQLQE3poV1cYiPMwr/8vcfH9/qHBskoihf/cdrJkG0YEFnmI
JT8AhqoWj/eKLtRUyjElJJdujFWg7S0B9aVJv/lE+uStyfzsDYRfRRYv335VxBhb
0PaQKEPatWc+PbuFFqzy31IWZbrUD1H/D8q4MyuuCZm8BnhNBplSb1u2sCa08yra
fHBFDsVDu3zDXwzwQn2AmNZfhk0aOmiihZZzrkXu1RzgPFevwn0PdrzRopwdg5Yh
GBDyrjFk86ke1uMauDw5DLse943r8hRKIeiSi/SfdLxhEG1KDc1YsG2m46rLd03M
Zx8VtIwEnnUgj8/0uv2jXIrJ3x+R2PhbPbwZsUMtd5ABNFM2DkNspXwz6lJmbXs0
IjTKye/FfQLHDAlNVrKspr2/0jlgZVWy9i/fjXftNSVe6M0HdVc14fhmdEJchUpU
TebcX57l2JbO21DwwJux/iiYwa9XbU9svTg4PYGRvN+F7yJxauJAgiTrTlPZx3Yl
U1sRL+U8771HMFaB+2dpiJ3g5H5qERwAiUhWiSa5lhA47OlsQlzs9ZZGh+ARtNRt
5HxCJBvLIgGg060DAc8vCMnanXNhdhsZ6EUhGFv7ajzLVXdCsHs29Z8zSktY7ZhV
91IuAIkIDtVrnyXl6VLh
=VxNu
-----END PGP SIGNATURE-----

--Signature=_Wed__28_Aug_2013_17_22_25_+1000_Vjx63zM.t0BTFvg2--
