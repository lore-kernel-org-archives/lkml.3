Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759396Ab3DCBKb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 21:10:31 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:47625 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759238Ab3DCBK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 21:10:29 -0400
Date: Wed, 3 Apr 2013 12:10:16 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>, Wolfram Sang <wsa@the-dreams.de>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: linux-next: manual merge of the v4l-dvb tree with the 2c tree
Message-Id: <20130403121016.f86c8b90472878f9918706c2@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__3_Apr_2013_12_10_16_+1100_7+ZbNlAdar6UAExF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__3_Apr_2013_12_10_16_+1100_7+ZbNlAdar6UAExF
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mauro,

Today's linux-next merge of the v4l-dvb tree got a conflict in
drivers/staging/media/go7007/go7007-driver.c between commit bf51a8c5e0b6
("i2c: Ignore return value of i2c_del_adapter()") from the i2c tree and
commit d5d3a7cc127d ("[media] go7007: fix unregister/disconnect
handling") from the v4l-dvb tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/staging/media/go7007/go7007-driver.c
index 6f83c52,a5ca99d..0000000
--- a/drivers/staging/media/go7007/go7007-driver.c
+++ b/drivers/staging/media/go7007/go7007-driver.c
@@@ -201,13 -208,50 +208,47 @@@ static int init_i2c_module(struct i2c_a
  {
  	struct go7007 *go =3D i2c_get_adapdata(adapter);
  	struct v4l2_device *v4l2_dev =3D &go->v4l2_dev;
-=20
- 	if (v4l2_i2c_new_subdev(v4l2_dev, adapter, type, addr, NULL))
+ 	struct v4l2_subdev *sd;
+ 	struct i2c_board_info info;
+=20
+ 	memset(&info, 0, sizeof(info));
+ 	strlcpy(info.type, i2c->type, sizeof(info.type));
+ 	info.addr =3D i2c->addr;
+ 	info.flags =3D i2c->flags;
+=20
+ 	sd =3D v4l2_i2c_new_subdev_board(v4l2_dev, adapter, &info, NULL);
+ 	if (sd) {
+ 		if (i2c->is_video)
+ 			go->sd_video =3D sd;
+ 		if (i2c->is_audio)
+ 			go->sd_audio =3D sd;
  		return 0;
+ 	}
+=20
+ 	printk(KERN_INFO "go7007: probing for module i2c:%s failed\n", i2c->type=
);
+ 	return -EINVAL;
+ }
+=20
+ /*
+  * Detach and unregister the encoder.  The go7007 struct won't be freed
+  * until v4l2 finishes releasing its resources and all associated fds are
+  * closed by applications.
+  */
+ static void go7007_remove(struct v4l2_device *v4l2_dev)
+ {
+ 	struct go7007 *go =3D container_of(v4l2_dev, struct go7007, v4l2_dev);
+=20
+ 	v4l2_device_unregister(v4l2_dev);
+ 	if (go->hpi_ops->release)
+ 		go->hpi_ops->release(go);
+ 	if (go->i2c_adapter_online) {
 -		if (i2c_del_adapter(&go->i2c_adapter) =3D=3D 0)
 -			go->i2c_adapter_online =3D 0;
 -		else
 -			v4l2_err(&go->v4l2_dev,
 -				"error removing I2C adapter!\n");
++		i2c_del_adapter(&go->i2c_adapter);
++		go->i2c_adapter_online =3D 0;
+ 	}
 =20
- 	dev_info(&adapter->dev,
- 		 "go7007: probing for module i2c:%s failed\n", type);
- 	return -1;
+ 	kfree(go->boot_fw);
+ 	go7007_v4l2_remove(go);
+ 	kfree(go);
  }
 =20
  /*

--Signature=_Wed__3_Apr_2013_12_10_16_+1100_7+ZbNlAdar6UAExF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRW4F4AAoJEECxmPOUX5FEAA4P/R4AZc3x9E23OHasR1FVoBwO
I4cLc5liZQlpeoPfvJN4+ysXCd6qZgs9bUTjei+vwUJWQbIFRUzKla8GwPcOAldT
j4MHRT3R+QJ1dN2wPpbB+MDtRgJu8VhmMtz1bV91kZ5QK9I3UPJkN8FreBQX2tVr
eWHgO1Fqgkdot83jlKUTRlt0bwwOaD0qmRl5WMGNM5wUHVGmTRgBpGfOjnYVs4++
0wJjVOUsWNteleVxpogTE9WcVSgqJ+YdGA42D21Y73NInUnNU+xVbJjnenG7mgKv
loganuuOWNdlmLy1whtMPziOvrE/yIji18X+9/RBOh7YbGA76VosLTh69jyqWuYn
fgw66PY12qeLHoqh52453LwsjrqRTiKnTRrgAbeLc64ZaNkRvsRJGoOCcBNTkIar
cVHDTFe5Bt5Bpq1Ywd4u8wM+d5LDUl5dkbiTgKolV91YC48Jq+pnZNF2tdaJvw5p
0aBxaZJ8CsS7Be977Zc+e8zngGsnO3CwUdYgHOEr/dUCh3SFJF9PniWg1HXqvZvp
fPc6XeahgFxz0wci2wLNyFAokMTYnSaq+ZKepXzdM43E6WoKNg12FmF6N8ARQbxT
DFUktI7GoEIHaYs6VlEfoYMkA1QKYNNXN+odIkZa9ZzbWWPSsAW/zdPMHzqTZiSe
68k/j/mz3GvBS4Tm6MHI
=wkCh
-----END PGP SIGNATURE-----

--Signature=_Wed__3_Apr_2013_12_10_16_+1100_7+ZbNlAdar6UAExF--
