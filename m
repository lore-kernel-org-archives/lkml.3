Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751389AbaLCE1n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 23:27:43 -0500
Received: from ozlabs.org ([103.22.144.67]:49383 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750884AbaLCE1l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 23:27:41 -0500
Date: Wed, 3 Dec 2014 15:27:33 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>,
        Romain Perier <romain.perier@gmail.com>,
        Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Subject: linux-next: manual merge of the devicetree tree with the regulator
 tree
Message-ID: <20141203152733.20ab945f@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_//AZPBT12kdSE7yj+SvXVb_6"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_//AZPBT12kdSE7yj+SvXVb_6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Grant,

Today's linux-next merge of the devicetree tree got a conflict in
include/linux/of.h between commit 8f73110f6bac ("of: Rename
"poweroff-source" property to "system-power-controller"") from the pm
tree and commit 7518b5890d8a ("of/overlay: Introduce DT overlay
support") from the devicetree tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/of.h
index b47096730dc5,aa01cf5852f8..000000000000
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@@ -23,7 -23,7 +23,8 @@@
  #include <linux/spinlock.h>
  #include <linux/topology.h>
  #include <linux/notifier.h>
 +#include <linux/property.h>
+ #include <linux/list.h>
 =20
  #include <asm/byteorder.h>
  #include <asm/errno.h>
@@@ -108,27 -111,18 +114,27 @@@ static inline struct device_node *of_no
  static inline void of_node_put(struct device_node *node) { }
  #endif /* !CONFIG_OF_DYNAMIC */
 =20
 -#ifdef CONFIG_OF
 -
  /* Pointer for first entry in chain of all nodes. */
- extern struct device_node *of_allnodes;
+ extern struct device_node *of_root;
  extern struct device_node *of_chosen;
  extern struct device_node *of_aliases;
  extern struct device_node *of_stdout;
  extern raw_spinlock_t devtree_lock;
 =20
 +#ifdef CONFIG_OF
 +static inline bool is_of_node(struct fwnode_handle *fwnode)
 +{
 +	return fwnode && fwnode->type =3D=3D FWNODE_OF;
 +}
 +
 +static inline struct device_node *of_node(struct fwnode_handle *fwnode)
 +{
 +	return fwnode ? container_of(fwnode, struct device_node, fwnode) : NULL;
 +}
 +
  static inline bool of_have_populated_dt(void)
  {
- 	return of_allnodes !=3D NULL;
+ 	return of_root !=3D NULL;
  }
 =20
  static inline bool of_node_is_root(const struct device_node *node)
@@@ -956,14 -959,33 +992,44 @@@ static inline int of_reconfig_get_state
  extern int of_resolve_phandles(struct device_node *tree);
 =20
  /**
 + * of_device_is_system_power_controller - Tells if system-power-controlle=
r is found for device_node
 + * @np: Pointer to the given device_node
 + *
 + * return true if present false otherwise
 + */
 +static inline bool of_device_is_system_power_controller(const struct devi=
ce_node *np)
 +{
 +	return of_property_read_bool(np, "system-power-controller");
 +}
 +
++/**
+  * Overlay support
+  */
+=20
+ #ifdef CONFIG_OF_OVERLAY
+=20
+ /* ID based overlays; the API for external users */
+ int of_overlay_create(struct device_node *tree);
+ int of_overlay_destroy(int id);
+ int of_overlay_destroy_all(void);
+=20
+ #else
+=20
+ static inline int of_overlay_create(struct device_node *tree)
+ {
+ 	return -ENOTSUPP;
+ }
+=20
+ static inline int of_overlay_destroy(int id)
+ {
+ 	return -ENOTSUPP;
+ }
+=20
+ static inline int of_overlay_destroy_all(void)
+ {
+ 	return -ENOTSUPP;
+ }
+=20
+ #endif
+=20
  #endif /* _LINUX_OF_H */

--Sig_//AZPBT12kdSE7yj+SvXVb_6
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUfpE7AAoJEMDTa8Ir7ZwVsfsP/3Q4CJurdKu41A2fcAgYnmDW
GkKZ+H4jMZ87PDT/fL1nveHC9wCNP5dZTycmPb548V/YYAeSOMAZ+V+v6BiDJi5t
E4I1Q88kf1Ez3D1I2272fAO+Yy4muiZ0VoQcj5RB+dpKW74GQ/3uEu+9XFuPALlZ
Pd1O39CWsebHytHax6D5kGxDpcoHbrHa1IennBiVZUke1YR6cLozNZeYxirGP/wm
1erMOMUdC38EMB3dwWp1L4swgX11nbUqxoQaMynsxhME/Y9LpabZvwtd+uAzDHrj
87dwwIBqb4hIM1hTs5NromrMiE/NSFCs0w6akchvNrS66RlWV9cIwG/7isBfWg1f
uK+6qEGD6+JxwLBBGwwO5zkqraEOUUHcSFnpksEdKJvdzhcdOVoyokyFsmrDvr9d
VB22mJb50RXX+/wezfuGXl1oKUb2NvR4Gp1EOjvXtwKDtZ7r1K4kk4m/jkUUohOL
M+mYQk8h1QP90/jl0VIe7/BtqH5zPTSTgZesPcLJJ+q6NPFwnjUajhuakOvs5ttz
D9Ji8aZ2lvmo648iBjOSIIYfd3pA+QEEthcpQnwGxeZHEWKHkAjZ1AEHW12ffkXw
BMArMWTaKbTEXZtmjW3e233g22hW1+4CYpx7yZTXVU40Zv/WafKmg7+rywXmZuX/
Pg7ZzPcAM1W5rDAj0QMm
=VNH7
-----END PGP SIGNATURE-----

--Sig_//AZPBT12kdSE7yj+SvXVb_6--
