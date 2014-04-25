Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676AbaDYQOT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 12:14:19 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:41157 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752362AbaDYQOO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 12:14:14 -0400
Date: Fri, 25 Apr 2014 11:13:36 -0500
From: Felipe Balbi <balbi@ti.com>
To: Andrew Lunn <andrew@lunn.ch>
CC: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Lior Amsalem <alior@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2 14/18] ARM: mvebu: Add support for USB cluster on the
 Armada 375 SoC
Message-ID: <20140425161336.GR29632@saruman.home>
Reply-To: <balbi@ti.com>
References: <1398434836-18908-1-git-send-email-gregory.clement@free-electrons.com>
 <1398434836-18908-15-git-send-email-gregory.clement@free-electrons.com>
 <20140425160705.GE12472@lunn.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tgGnixv3tJWXBxdL"
Content-Disposition: inline
In-Reply-To: <20140425160705.GE12472@lunn.ch>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--tgGnixv3tJWXBxdL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 25, 2014 at 06:07:05PM +0200, Andrew Lunn wrote:
> On Fri, Apr 25, 2014 at 04:07:12PM +0200, Gregory CLEMENT wrote:
> > The Armada 375 SoC comes with an USB2 host and device controller and
> > an USB3 controller. The USB cluster control register allows to manage
> > common features of both USB controllers.
> >=20
> > Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
> > ---
> >  arch/arm/mach-mvebu/Makefile      |  2 +-
> >  arch/arm/mach-mvebu/usb-cluster.c | 96 +++++++++++++++++++++++++++++++=
++++++++
> >  2 files changed, 97 insertions(+), 1 deletion(-)
> >  create mode 100644 arch/arm/mach-mvebu/usb-cluster.c
> >=20
> > diff --git a/arch/arm/mach-mvebu/Makefile b/arch/arm/mach-mvebu/Makefile
> > index a63e43b6b451..dec05e7e1802 100644
> > --- a/arch/arm/mach-mvebu/Makefile
> > +++ b/arch/arm/mach-mvebu/Makefile
> > @@ -4,7 +4,7 @@ ccflags-$(CONFIG_ARCH_MULTIPLATFORM) :=3D -I$(srctree)/=
$(src)/include \
> >  AFLAGS_coherency_ll.o		:=3D -Wa,-march=3Darmv7-a
> > =20
> >  obj-y				 +=3D system-controller.o mvebu-soc-id.o
> > -obj-$(CONFIG_MACH_MVEBU_V7)      +=3D board-v7.o
> > +obj-$(CONFIG_MACH_MVEBU_V7)      +=3D board-v7.o usb-cluster.o
> >  obj-$(CONFIG_MACH_DOVE)		 +=3D dove.o
> >  obj-$(CONFIG_ARCH_MVEBU)	 +=3D coherency.o coherency_ll.o pmsu.o
> >  obj-$(CONFIG_SMP)                +=3D platsmp.o headsmp.o
> > diff --git a/arch/arm/mach-mvebu/usb-cluster.c b/arch/arm/mach-mvebu/us=
b-cluster.c
> > new file mode 100644
> > index 000000000000..4c15d282db23
> > --- /dev/null
> > +++ b/arch/arm/mach-mvebu/usb-cluster.c
> > @@ -0,0 +1,96 @@
> > +/*
> > + * USB cluster support for Armada 375 platform.
> > + *
> > + * Copyright (C) 2014 Marvell
> > + *
> > + * Gregory CLEMENT <gregory.clement@free-electrons.com>
> > + *
> > + * This file is licensed under the terms of the GNU General Public
> > + * License version 2.  This program is licensed "as is" without any
> > + * warranty of any kind, whether express or implied.
> > + *
> > + * Armada 375 comes with an USB2 host and device controller and an
> > + * USB3 controller. The USB cluster control register allows to manage
> > + * common features of both USB controller.
> > + */
> > +
> > +#include <linux/kernel.h>
> > +#include <linux/init.h>
> > +#include <linux/of_address.h>
> > +#include <linux/io.h>
> > +#include <linux/slab.h>
> > +
> > +#define USB2_PHY_CONFIG_ENABLE BIT(0) /* active low */
> > +
> > +static struct of_device_id of_usb_cluster_table[] =3D {
> > +	{ .compatible =3D "marvell,armada-375-usb-cluster", },
> > +	{ /* end of list */ },
> > +};
> > +
> > +static int __init mvebu_usb_cluster_init(void)
> > +{
> > +	struct device_node *np;
> > +
> > +	np =3D of_find_matching_node(NULL, of_usb_cluster_table);
> > +	if (np) {
> > +		void __iomem *usb_cluster_base;
> > +		u32 reg;
> > +		struct device_node *ehci_node, *xhci_node;
> > +		struct property *ehci_status;
> > +		bool use_usb3 =3D false;
> > +
> > +		usb_cluster_base =3D of_iomap(np, 0);
> > +		BUG_ON(!usb_cluster_base);
> > +
> > +		xhci_node =3D of_find_compatible_node(NULL, NULL,
> > +						"marvell,armada-375-xhci");
> > +
> > +		if (xhci_node && of_device_is_available(xhci_node))
> > +			use_usb3 =3D true;
> > +
> > +		ehci_node =3D of_find_compatible_node(NULL, NULL,
> > +						"marvell,orion-ehci");
> > +
> > +		if (ehci_node && of_device_is_available(ehci_node)
> > +			&& use_usb3) {
> > +			/*
> > +			 * We can't use usb2 and usb3 in the same time, so let's
> > +			 * disbale usb2 and complain about it to the user askinf
> > +			 * to fix the device tree.
> > +			 */
> > +
> > +			ehci_status =3D kzalloc(sizeof(struct property),
> > +					GFP_KERNEL);
> > +			WARN_ON(!ehci_status);
> > +
> > +			ehci_status->value =3D kstrdup("disabled", GFP_KERNEL);
> > +			WARN_ON(!ehci_status->value);
> > +
> > +			ehci_status->length =3D 8;
> > +			ehci_status->name =3D kstrdup("status", GFP_KERNEL);
> > +			WARN_ON(!ehci_status->name);
> > +
> > +			of_update_property(ehci_node, ehci_status);
> > +			pr_err("%s: armada-375-xhci and orion-ehci are incompatible for thi=
s SoC.\n",
> > +				__func__);
> > +			pr_err("Please fix your dts!\n");
> > +			pr_err("orion-ehci have been disabled by default...\n");
> > +
> > +		}
> > +
> > +		reg =3D readl(usb_cluster_base);
> > +		if (use_usb3)
> > +			reg |=3D USB2_PHY_CONFIG_ENABLE;
> > +		else
> > +			reg &=3D ~USB2_PHY_CONFIG_ENABLE;
> > +		writel(reg, usb_cluster_base);
>=20
> Am i right in saying this in the end is about enabling the USB2 phy or
> a USB3 why? So why not just implement a phy driver?

+1 we have a generic phy layer (drivers/phy) for that.

--=20
balbi

--tgGnixv3tJWXBxdL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTWomwAAoJEIaOsuA1yqRE7GYQAJ6KW6d8vnUMjJrwRaOauPAH
JvXGYMzfxZt+AXrC+x/UL34ZFMzSCKRDd0tKoSHCLJMy9J1SWAfNh61SLmL6DoEa
KIUJCK6FZr+D3Kbia+KfZcr/UnY8Asp5wusZTRvPKpHJDKOIXRyo0qA5vNsCDQZx
NpXQdeeq6KGmct5vNe5fy8y/q6IhR51gVfZxlqYXaENS1z9Kv6A6k/aZFbs67CiO
RhX9i6aDPjdUCUpF2Wq2beS8NuKIzrX69MjZ0WC1316+fU/Q/0v/VTQ15kq3dzCK
TC+ja0eQ1wl2i52e6ByZl58pkvnWvhar8aJBmEwzs/0dOTf80t9Bd5CnIkTvNhFQ
LarXIjEYO2jzXQZN0laN1k0SceXgiku2zcynEzvxKRAFRU+EQqOClhZX+MsOPq4u
7uX29oytYyO/m1zKIIO1UhaiQouM021IZkIq+Y5TcnMAkiFjDzdDTiewc0qiRM/s
TeXc6heCZ5YOiM+VRXwd6GtkKOErx0zk0i7QOnw0bQ0sj63YegZkH7Yj1jYBD6yC
kQxIty7m2oHfVGR1EfktElPj+k3ofGIw0HZK0VYTXBW213oFLe+ol1hSyjsPpuUu
6lKb881ook43YmG1vS5XewQWOju+/ejsTrgXix8hvZrciX758sCzMdNkWjEsigcD
v9I+AjZ/uBhl2CimJW3V
=uj+8
-----END PGP SIGNATURE-----

--tgGnixv3tJWXBxdL--
