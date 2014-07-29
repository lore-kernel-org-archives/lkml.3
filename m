Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984AbaG2QfB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 12:35:01 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:49300 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321AbaG2Qe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 12:34:59 -0400
Date: Tue, 29 Jul 2014 11:33:45 -0500
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
CC: Tony Lindgren <tony@atomide.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        <bcousson@baylibre.com>, <linux@arm.linux.org.uk>,
        <khilman@deeprootsystems.com>, <tglx@linutronix.de>,
        <jason@lakedaemon.net>, <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 29/35] arm: omap: intc: switch over to linear irq domain
Message-ID: <20140729163345.GF17808@saruman.home>
Reply-To: <balbi@ti.com>
References: <1406582183-696-1-git-send-email-balbi@ti.com>
 <1406582183-696-30-git-send-email-balbi@ti.com>
 <20140729121425.GR29045@atomide.com>
 <20140729141522.GB17808@saruman.home>
 <20140729152052.GV29045@atomide.com>
 <20140729154057.GE17808@saruman.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Pql/uPZNXIm1JCle"
Content-Disposition: inline
In-Reply-To: <20140729154057.GE17808@saruman.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Pql/uPZNXIm1JCle
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jul 29, 2014 at 10:40:57AM -0500, Felipe Balbi wrote:
> On Tue, Jul 29, 2014 at 08:20:52AM -0700, Tony Lindgren wrote:
> > * Felipe Balbi <balbi@ti.com> [140729 07:18]:
> > > Hi,
> > >=20
> > > On Tue, Jul 29, 2014 at 05:14:25AM -0700, Tony Lindgren wrote:
> > > > * Felipe Balbi <balbi@ti.com> [140728 14:19]:
> > > > > now that we don't need to support legacy board-files,
> > > > > we can completely switch over to a linear irq domain
> > > > > and make use of irq_alloc_domain_generic_chips() to
> > > > > allocate all generic irq chips for us.
> > > >=20
> > > > This patch seems to somehow break off-idle for omap3=20
> > > > where it no longer wakes up.
> > >=20
> > > Sure your bisection is correct ? This patch just switches from legacy
> > > irq domain to linear irq domain.
> >=20
> > Yes, I tried it a few times. Just enabling
> > retention idle hangs too with this patch.
> >=20
> > Maybe it's omap3_prcm_irq_setup that relies on
> > 11 + OMAP_INTC_START? There may be other such issues
>=20
> lol.
>=20
> OMAP4 has the same nonsense.

made me think why (if) OMAP4 works with that same setup. Does wake from
OFF work with OMAP4 ?

Anyway, here's a quick little hack to check if that's the reason for the
regression:

diff --git a/arch/arm/boot/dts/omap3.dtsi b/arch/arm/boot/dts/omap3.dtsi
index ff953c9..c234b98 100644
--- a/arch/arm/boot/dts/omap3.dtsi
+++ b/arch/arm/boot/dts/omap3.dtsi
@@ -97,6 +97,7 @@
 		prm: prm@48306000 {
 			compatible =3D "ti,omap3-prm";
 			reg =3D <0x48306000 0x4000>;
+			interrupts =3D <11>;
=20
 			prm_clocks: clocks {
 				#address-cells =3D <1>;
diff --git a/arch/arm/mach-omap2/prm_common.c b/arch/arm/mach-omap2/prm_com=
mon.c
index 25e8b82..3d11377 100644
--- a/arch/arm/mach-omap2/prm_common.c
+++ b/arch/arm/mach-omap2/prm_common.c
@@ -242,6 +242,11 @@ void omap_prcm_irq_complete(void)
 	prcm_irq_setup->restore_irqen(prcm_irq_setup->saved_mask);
 }
=20
+static struct of_device_id tmp[] =3D {
+	{ .compatible =3D "ti,omap3-prm" },
+	{ }
+};
+
 /**
  * omap_prcm_register_chain_handler - initializes the prcm chained interru=
pt
  * handler based on provided parameters
@@ -254,17 +259,24 @@ void omap_prcm_irq_complete(void)
  */
 int omap_prcm_register_chain_handler(struct omap_prcm_irq_setup *irq_setup)
 {
+	struct device_node *node;
 	int nr_regs;
 	u32 mask[OMAP_PRCM_MAX_NR_PENDING_REG];
 	int offset, i;
+	int irq;
 	struct irq_chip_generic *gc;
 	struct irq_chip_type *ct;
=20
 	if (!irq_setup)
 		return -EINVAL;
=20
+	irq =3D irq_setup->irq;
 	nr_regs =3D irq_setup->nr_regs;
=20
+	node =3D of_find_matching_node(NULL, tmp);
+	if (node)
+		irq =3D of_irq_get(node, 0);
+
 	if (prcm_irq_setup) {
 		pr_err("PRCM: already initialized; won't reinitialize\n");
 		return -EINVAL;
@@ -298,7 +310,7 @@ int omap_prcm_register_chain_handler(struct omap_prcm_i=
rq_setup *irq_setup)
 				1 << (offset & 0x1f);
 	}
=20
-	irq_set_chained_handler(irq_setup->irq, omap_prcm_irq_handler);
+	irq_set_chained_handler(irq, omap_prcm_irq_handler);
=20
 	irq_setup->base_irq =3D irq_alloc_descs(-1, 0, irq_setup->nr_regs * 32,
 		0);

--=20
balbi

--Pql/uPZNXIm1JCle
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT18zpAAoJEIaOsuA1yqRE1+0P/0LBahhkxT97T8au3XIRSTw7
E+riMUXLHJqgN7a6o6pg93FeFqhOPpm/4A4T1lVDp3uWhbexpbTbiSR+cj9ty+HP
K6Uhf9nqB+B8KN0U2baXw0IeSM8c79riBeTxKo4Rt11qd8PZYeuRLbHaQTou3FW7
HwD+1XxJpvjjV0qEIm4P86FPduHYPC3w1afsV2O2PVt+0/E0EtfolULzLwvlU7Je
hTzvP2Kf0YHqbfLnxhAjKjv1kZINK/GCvx8VF9wPWrSa2967EyXzh98cW2SbiVEi
IA0sZXLcU+I243suxOuFFcv3bZDclO2m1IqKg2er564gdCwAizE49xcvBF82ml0N
nMR79mH1jgUQF+Zv7jwry08i6Ydb0aEvFPnITxGlO4x1IWOX6xi2FiQo2UQ4+PWo
fCPED+Uy7LllL/prXoDDU9afqL3EVOPQIY1WYjdLqPcUs4BOLruzG0/E9GIvLxvo
3iiBMMUVh4ju1K7PQzHOWGU9JIvXk5chFoHbeNe3lQh7J7msiRWAKOBvcGpFdh60
eYOUW+sEa+VA4P4JZdTg0uEydMqgUETdyUjbYym8nA6JRTUzhQtraMHvE8LjWkjy
tYBHHq/hWLYQchSOKQhNhL7Wfwd1QQo0+QMSYaHmF5nV0/vwnlh++pkJk1EsqHgJ
QE/ca/4jxy8HkWboOEkR
=HOWE
-----END PGP SIGNATURE-----

--Pql/uPZNXIm1JCle--
