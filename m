Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756423Ab3FSFci (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 01:32:38 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:33034 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321Ab3FSFcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 01:32:36 -0400
Date: Wed, 19 Jun 2013 15:32:25 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ming Lei <ming.lei@canonical.com>, Takashi Iwai <tiwai@suse.de>
Subject: linux-next: manual merge of the driver-core tree with the
 driver-core.current tree
Message-Id: <20130619153225.9ff68f0984bfa54333c4df10@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__19_Jun_2013_15_32_25_+1000_29GGas7a7VkwZla5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__19_Jun_2013_15_32_25_+1000_29GGas7a7VkwZla5
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the driver-core tree got a conflict in
drivers/base/firmware_class.c between commit 875979368eb4 ("firmware
loader: fix use-after-free by double abort") from the driver-core.current
tree and commit fe304143b0c3 ("firmware: Avoid deadlock of usermodehelper
lock at shutdown") from the driver-core tree.

I fixed it up (more may be required - see below) and can carry the fix as
necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/base/firmware_class.c
index 01e2103,6ede229..0000000
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@@ -446,22 -452,11 +452,18 @@@ static struct firmware_priv *to_firmwar
  	return container_of(dev, struct firmware_priv, dev);
  }
 =20
- static void fw_load_abort(struct firmware_priv *fw_priv)
+ static void fw_load_abort(struct firmware_buf *buf)
  {
- 	struct firmware_buf *buf =3D fw_priv->buf;
-=20
 +	/*
 +	 * There is a small window in which user can write to 'loading'
 +	 * between loading done and disappearance of 'loading'
 +	 */
 +	if (test_bit(FW_STATUS_DONE, &buf->status))
 +		return;
 +
+ 	list_del_init(&buf->pending_list);
  	set_bit(FW_STATUS_ABORT, &buf->status);
  	complete_all(&buf->completion);
-=20
- 	/* avoid user action after loading abort */
- 	fw_priv->buf =3D NULL;
  }
 =20
  #define is_fw_load_aborted(buf)	\

--Signature=_Wed__19_Jun_2013_15_32_25_+1000_29GGas7a7VkwZla5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRwUJuAAoJEECxmPOUX5FExmYP/RVbGlnSbRscU2sFiXJ72NMs
lIZGRTA1iqRjCADKSQp2OwPMvJe1VWVzOT22DYk0SsCz5ojjh/g1cnw3NHhYtPf5
TWZkqzS//YOV7HTHoq2rN4cDZobmsSdDC5n56U3cbJ6kP+woPO7FxsQYlAQRTVoJ
xcCMjq436b8y77H4r9BOfKVqnP9i1vnMUAcrFJF/rLLJZQYMeGgliKWM6Z6cDHmE
7DQL976R+hoP/JzyyvwXhMpEPQcF77RSsFOuajEzSNSQcMtqf1r2whaJrv7/d4aW
mgIg+6iO2aiPb6mJ7NmAEDBZn7VjH0tyNK79lmktAOL/hmDedYjNZkRVIPPo7HYl
ebCtvGTZqiZlGyczhkWk9ihvxr1DHdG4Z7p9lq/6VqLBER+QlXxRDgdZgdy62WK3
uSTUaZN3/KNp8u6o78R5fhatPT29ExedlCD2ScX9sW5r4cy5rVYsOuNyFIZRmSl0
eux7Yw4d5PsQnbQvlP1LOwuBCZhkLbY6T05hT/aKEuCq4fV9lqOFKuwAExz30QwJ
tYgOsYKx8SPXnwKs9eCe+swB5MoGPXaBtlskiQnTgW6qKhmyuQ3oHQ/EBq+cSVf+
MHvXvLqJkKI9SXcV0IuZyAOJwjyBb/OvOWmASkxwHHthYOaaJ9tg8dW53fuumOVB
WLMau464VTmzO3SVGDi5
=QahM
-----END PGP SIGNATURE-----

--Signature=_Wed__19_Jun_2013_15_32_25_+1000_29GGas7a7VkwZla5--
