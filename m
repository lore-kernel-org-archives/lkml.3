Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912AbaCYCzp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 22:55:45 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45215 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751280AbaCYCzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 22:55:38 -0400
Message-ID: <1395716117.2832.86.camel@deadeye.wl.decadent.org.uk>
Subject: Re: Re: [PATCH 3.4 93/99] iwlwifi: always copy first 16 bytes of
 commands
From: Ben Hutchings <ben@decadent.org.uk>
To: Andreas Sturmlechner <andreas.sturmlechner@gmail.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Jianguo Wu <wujianguo@huawei.com>,
        Andres Bertens <abertensu@yahoo.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Tue, 25 Mar 2014 02:55:17 +0000
In-Reply-To: <1553572.xqrhDm938v@tux200s>
References: <20140308010611.468206150@linuxfoundation.org>
	 <20140322165145.GA12870@kroah.com>
	 <1395509887.2770.72.camel@deadeye.wl.decadent.org.uk>
	 <1553572.xqrhDm938v@tux200s>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-fy4bChmwIj6AjOrjh3Q0"
X-Mailer: Evolution 3.8.5-2+b3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-fy4bChmwIj6AjOrjh3Q0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2014-03-22 at 22:01 +0100, Andreas Sturmlechner wrote:
> Original Message from: Ben Hutchings <ben@decadent.org.uk>
> >=20
> > Andreas, could you test whether this regression is also present in
> > 3.2.55?  This patch is based on my backport for 3.2.y.
> >=20
>=20
> 3.2.55 is OK here.

One piece of my backport to 3.2.y went missing in the forward-port to
3.4.y.  Can you test 3.4.83 with this patch on top?

Ben.

---
From: Ben Hutchings <ben@decadent.org.uk>
Date: Tue, 25 Mar 2014 02:49:14 +0000
Subject: iwlwifi: Complete backport of "iwlwifi: always copy first 16 bytes=
 of commands"

Linux 3.4.83 included an incomplete backport of commit
8a964f44e01ad3bbc208c3e80d931ba91b9ea786 ('iwlwifi: always copy first
16 bytes of commands') which causes a regression for this driver.
This is the missing piece.

Reported-by: Andreas Sturmlechner <andreas.sturmlechner@gmail.com>
Cc: Johannes Berg <johannes.berg@intel.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: Jianguo Wu <wujianguo@huawei.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
@@ -825,14 +825,15 @@ static int iwl_enqueue_hcmd(struct iwl_trans *trans, =
struct iwl_host_cmd *cmd)
 	trace_idx =3D 1;
 #endif
=20
+	/* map the remaining (adjusted) nocopy/dup fragments */
 	for (i =3D 0; i < IWL_MAX_CMD_TFDS; i++) {
-		if (!cmd->len[i])
+		if (!cmdlen[i])
 			continue;
 		if (!(cmd->dataflags[i] & IWL_HCMD_DFL_NOCOPY))
 			continue;
 		phys_addr =3D dma_map_single(trans->dev,
-					   (void *)cmd->data[i],
-					   cmd->len[i], DMA_BIDIRECTIONAL);
+					   (void *)cmddata[i],
+					   cmdlen[i], DMA_BIDIRECTIONAL);
 		if (dma_mapping_error(trans->dev, phys_addr)) {
 			iwlagn_unmap_tfd(trans, out_meta,
 					 &txq->tfds[q->write_ptr],


--=20
Ben Hutchings
Make three consecutive correct guesses and you will be considered an expert=
.

--=-fy4bChmwIj6AjOrjh3Q0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUAUzDwFee/yOyVhhEJAQqnxw/8DVunA8H9j34mGKNVfDOYPJlbVew+Xb5W
E9btqAU/vkF0na9A2g/Efvj1PneoBdiYMxs/i+8Ie8Bs4wH82YxrtdJQWtL7ZQeS
SlROLzmf67NSdABMUS03KGaXEdFkB0emW7OxI1kgkJ2ZCv3urZJcTx3nXNuVvbXS
RL1SBR8yWm7HSKUu0wEkqou25wCueYBUi963gKyyyYY/qcy0eD9VvB3bcVMc5cgD
1jZrP6bhSrcHEqaJm/sfHsRjgBc/mdya88DeAs4YfJjSBBNJ8eWupF7SiDOpmvkI
UUCUfl04lweurcIvP5GdeVFjlA0/tgP85dHisHVMwT2Ijftl15xqx7fQGnu09bKy
9dV0sQpEwGcAk+Cn3x1ZGI9wY8oM/k2HMoCvU+vfHu/Yn2YAJvbdBs42c/nrab5i
kW9M/xCUNPm/xMOQ95MMPwndkLKr+t4FxPjNM1tfxFVo2SqZGdgxlKh7xLD2c9h+
/eQGxqk9U9QECD1CC8SXv88JHLGjTTim5LJ8swoefEPgySa8OK58qeg83gFfx9Yd
kL1xCw/l01IipDQWm9w4JVKGwKRqXnWGLs8qfYxcwdNY+QEY2si8Wxc1jpU9YORm
86UXxPlj5OGKQghU7cDHM2NekMJowxc7nM4GhybWM2hWJfphl2GaB6UsW8uyXCxp
ciUvyI7+2ZE=
=Jm+f
-----END PGP SIGNATURE-----

--=-fy4bChmwIj6AjOrjh3Q0--
