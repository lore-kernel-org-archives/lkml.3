Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130AbaKZEoR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 23:44:17 -0500
Received: from ozlabs.org ([103.22.144.67]:34640 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751795AbaKZEoP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 23:44:15 -0500
Date: Wed, 26 Nov 2014 15:44:06 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Lee Jones <lee.jones@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: linux-next: manual merge of the devicetree tree with the pm, mfd
 and regulator trees
Message-ID: <20141126154406.434ab873@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/5ddrhoO2Y3g=xvwA18WGNJj"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/5ddrhoO2Y3g=xvwA18WGNJj
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Grant,

Today's linux-next merge of the devicetree tree got a conflict in
include/linux/of.h between commits b31384fa5de3 ("Driver core: Unified
device properties interface for platform firmware") from the pm tree
and a4b4e0461ec5 ("of: Add standard property for poweroff capability")
from the mfd and regulator trees and commit 7518b5890d8a ("of/overlay:
Introduce DT overlay support") from the devicetree tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/of.h
index facd94e45462,aa01cf5852f8..000000000000
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
 + * of_system_has_poweroff_source - Tells if poweroff-source is found for =
device_node
 + * @np: Pointer to the given device_node
 + *
 + * return true if present false otherwise
 + */
 +static inline bool of_system_has_poweroff_source(const struct device_node=
 *np)
 +{
 +	return of_property_read_bool(np, "poweroff-source");
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

--Sig_/5ddrhoO2Y3g=xvwA18WGNJj
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUdVqbAAoJEMDTa8Ir7ZwV6KoP/0VLKOmqhHM1SR1QNYyk6R2i
TdkHavhTvCxX/1lyRXd/smlqfj1k3BPFVTaw7Qi8L9UVAm9vvH3RzWaTPYWqCYYo
UQAoWNejybtWIgp+RygqDDF7weaB2EsvYIwMMNluxCGmt2aC7BIcUJLgDAeUNo7Q
0XDA5lCX/ifqpQD4982QkNtp8ihJNjUFa/TH7qfwmFTpyj1ftu3TWVr/n+sEi9j0
l7MOw3cgul4BdI8xVWrw6LBO9pgXzZ8PJ44pUftUfbT1YVDKf4m5V6FBJAMICFh0
Ua/speGDi6QGvXO2fBhrdb7mbps3eeeUDIdGU+4bm09vIL0316rUOOykugJ4Fg4C
Riz4OKkX0ORa5pQDZsnsI6SgMzw3HgMVcG/TqJvCBLSWmwtwFgXZwTue36kV/cxY
iXGLDoSrNpOxMNZIIXexq/Dj70KCVb3ly73K4yloKQfbk6nVaxIWB/XWXryXVIhR
IySHJQZbxdoo56FbD1xvj1QyzlNNQoRULAVk+sADrkF/I0lsWeEOYMdyZYe0gQTm
TUh/vzG8SqWfUj8uupgFycLxUw6olZenQ0g+LvcULX+d5YMFbRT8w2PLzAFsPYOh
k3rD2jxOMs/iJyzLC5yzfrcwqb7le1tGAFcVVvcOHch1css/lXbpEzr0Pl4X4n7I
6z9EfpV3OmDuExFg8zI7
=52Jd
-----END PGP SIGNATURE-----

--Sig_/5ddrhoO2Y3g=xvwA18WGNJj--
