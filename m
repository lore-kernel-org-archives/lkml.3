Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752094AbaKZEeF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 23:34:05 -0500
Received: from ozlabs.org ([103.22.144.67]:60690 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751712AbaKZEeD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 23:34:03 -0500
Date: Wed, 26 Nov 2014 15:33:53 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>, Wolfram Sang <wsa@the-dreams.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Subject: linux-next: manual merge of the devicetree tree with the i2c tree
Message-ID: <20141126153353.5f4fedd5@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/Cun9bu7X3YW1qBZbsBfI50="; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Cun9bu7X3YW1qBZbsBfI50=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Grant,

Today's linux-next merge of the devicetree tree got a conflict in
drivers/i2c/i2c-core.c between commit 2fd36c552649 ("i2c: core: Map OF
IRQ at probe time") from the  i2c tree and commit a430a3455f2c
("i2c/of: Factor out Devicetree registration code") from the devicetree
tree.

I fixed it up (thanks for the heads up, but please see below) and can
carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/i2c/i2c-core.c
index 19800033e75d,d8afd3f28ca4..000000000000
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@@ -1380,61 -1369,69 +1381,67 @@@ static void i2c_scan_static_board_info(
  /* OF support code */
 =20
  #if IS_ENABLED(CONFIG_OF)
- static void of_i2c_register_devices(struct i2c_adapter *adap)
+ static struct i2c_client *of_i2c_register_device(struct i2c_adapter *adap,
+ 						 struct device_node *node)
  {
- 	void *result;
- 	struct device_node *node;
+ 	struct i2c_client *result;
+ 	struct i2c_board_info info =3D {};
+ 	struct dev_archdata dev_ad =3D {};
+ 	const __be32 *addr;
+ 	int len;
 =20
- 	/* Only register child devices if the adapter has a node pointer set */
- 	if (!adap->dev.of_node)
- 		return;
+ 	dev_dbg(&adap->dev, "of_i2c: register %s\n", node->full_name);
 =20
- 	dev_dbg(&adap->dev, "of_i2c: walking child nodes\n");
+ 	if (of_modalias_node(node, info.type, sizeof(info.type)) < 0) {
+ 		dev_err(&adap->dev, "of_i2c: modalias failure on %s\n",
+ 			node->full_name);
+ 		return ERR_PTR(-EINVAL);
+ 	}
 =20
- 	for_each_available_child_of_node(adap->dev.of_node, node) {
- 		struct i2c_board_info info =3D {};
- 		struct dev_archdata dev_ad =3D {};
- 		const __be32 *addr;
- 		int len;
+ 	addr =3D of_get_property(node, "reg", &len);
+ 	if (!addr || (len < sizeof(int))) {
+ 		dev_err(&adap->dev, "of_i2c: invalid reg on %s\n",
+ 			node->full_name);
+ 		return ERR_PTR(-EINVAL);
+ 	}
 =20
- 		dev_dbg(&adap->dev, "of_i2c: register %s\n", node->full_name);
+ 	info.addr =3D be32_to_cpup(addr);
+ 	if (info.addr > (1 << 10) - 1) {
+ 		dev_err(&adap->dev, "of_i2c: invalid addr=3D%x on %s\n",
+ 			info.addr, node->full_name);
+ 		return ERR_PTR(-EINVAL);
+ 	}
 =20
- 		if (of_modalias_node(node, info.type, sizeof(info.type)) < 0) {
- 			dev_err(&adap->dev, "of_i2c: modalias failure on %s\n",
- 				node->full_name);
- 			continue;
- 		}
 -	info.irq =3D irq_of_parse_and_map(node, 0);
+ 	info.of_node =3D of_node_get(node);
+ 	info.archdata =3D &dev_ad;
 =20
- 		addr =3D of_get_property(node, "reg", &len);
- 		if (!addr || (len < sizeof(int))) {
- 			dev_err(&adap->dev, "of_i2c: invalid reg on %s\n",
- 				node->full_name);
- 			continue;
- 		}
+ 	if (of_get_property(node, "wakeup-source", NULL))
+ 		info.flags |=3D I2C_CLIENT_WAKE;
 =20
- 		info.addr =3D be32_to_cpup(addr);
- 		if (info.addr > (1 << 10) - 1) {
- 			dev_err(&adap->dev, "of_i2c: invalid addr=3D%x on %s\n",
- 				info.addr, node->full_name);
- 			continue;
- 		}
+ 	request_module("%s%s", I2C_MODULE_PREFIX, info.type);
 =20
- 		info.of_node =3D of_node_get(node);
- 		info.archdata =3D &dev_ad;
+ 	result =3D i2c_new_device(adap, &info);
+ 	if (result =3D=3D NULL) {
+ 		dev_err(&adap->dev, "of_i2c: Failure registering %s\n",
+ 			node->full_name);
+ 		of_node_put(node);
 -		irq_dispose_mapping(info.irq);
+ 		return ERR_PTR(-EINVAL);
+ 	}
+ 	return result;
+ }
 =20
- 		if (of_get_property(node, "wakeup-source", NULL))
- 			info.flags |=3D I2C_CLIENT_WAKE;
+ static void of_i2c_register_devices(struct i2c_adapter *adap)
+ {
+ 	struct device_node *node;
 =20
- 		request_module("%s%s", I2C_MODULE_PREFIX, info.type);
+ 	/* Only register child devices if the adapter has a node pointer set */
+ 	if (!adap->dev.of_node)
+ 		return;
 =20
- 		result =3D i2c_new_device(adap, &info);
- 		if (result =3D=3D NULL) {
- 			dev_err(&adap->dev, "of_i2c: Failure registering %s\n",
- 				node->full_name);
- 			of_node_put(node);
- 			continue;
- 		}
- 	}
+ 	dev_dbg(&adap->dev, "of_i2c: walking child nodes\n");
+=20
+ 	for_each_available_child_of_node(adap->dev.of_node, node)
+ 		of_i2c_register_device(adap, node);
  }
 =20
  static int of_dev_node_match(struct device *dev, void *data)

--Sig_/Cun9bu7X3YW1qBZbsBfI50=
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUdVg2AAoJEMDTa8Ir7ZwVetUP/jMa2Q8ToBqgw3FqUc3eVYXK
kh63IQY8YtwRKcLLVNpI4judeMyL8w2QjAtAg3d+93EA2SEpZLRXK4kIkZzwpUY4
Oiz6ppWQX37Dr3uQTU8lp49a3/CC+trTVSPX35rIWRWI8/MAK7ziHyU00IlJYiFF
EkOio/igymAAdvpgtpNBbKkC6n/kAUCCQy4E9i0K86vy3odnTUqWSw2mDhdP/sps
ZuB1ffrA1BYdsGoe/89OKlm42HBqOlj37jkWSInoVZpPgrhEs0U6qE64aypD/a3V
2Thy6F6uo94iTmtFSpN4+F5JNumz/7uBPD/aJH8R9fQ/OsxaQ+bFjfDLAZ0AUfCj
xBCYI7ea8TkgZgrFM1RDw0eoDmERrYKSN/DrL+b7LzHAukp36JlXbdg3dMyVb4bB
zgGUQ9oitcdVziI9/AXGarQcxEmlfJhnJgdUXOMBI4G3rmxQda1C48TDYjUt9r57
w6z00djSR9nh2f9/bm9ADc/NslXcRLKxkIJGizLvT6aIvnkGZGNCQNnNqY1GJtgM
a6BWe4ACCkzewWVMWspdTS/Geyc0jv7fqdzMB+YoPIPu3ovVyZ+3WZof9l27c6TZ
/1DEd49CvVeHfn5hU2zrjH1QMMfphYpVkWNY0+eEjbSYy5x36av/0/3wj672PwKw
JVja7bnsQDuX6jC2pY3f
=6OTU
-----END PGP SIGNATURE-----

--Sig_/Cun9bu7X3YW1qBZbsBfI50=--
