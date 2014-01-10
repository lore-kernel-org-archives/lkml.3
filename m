Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600AbaAJEgN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 23:36:13 -0500
Received: from ozlabs.org ([203.10.76.45]:60288 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793AbaAJEgM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 23:36:12 -0500
Date: Fri, 10 Jan 2014 15:36:05 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ian Munsie <imunsie@au1.ibm.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Alexander Usyskin <alexander.usyskin@intel.com>
Subject: linux-next: manual merge of the akpm-current tree with the
 char-misc tree
Message-Id: <20140110153605.16c1552914f952f7489d54b3@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__10_Jan_2014_15_36_05_+1100_F18SuVfPKR+A3hG="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__10_Jan_2014_15_36_05_+1100_F18SuVfPKR+A3hG=
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm-current tree got a conflict in
drivers/misc/mei/hbm.c between commit 544f94601409 ("mei: do not run
reset flow from the interrupt thread") from the char-misc tree and commit
dd045dab2999 ("drivers/misc/mei: ratelimit several error messages") from
the akpm-current tree.

I am not sure if the akpm-current tree fix is still needed, but I fixed
it up anyway (see below) and can carry the fix as necessary (no action is
required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/misc/mei/hbm.c
index 8520cdfa2f05,2ab8b1dab39c..000000000000
--- a/drivers/misc/mei/hbm.c
+++ b/drivers/misc/mei/hbm.c
@@@ -626,31 -597,25 +626,31 @@@ int mei_hbm_dispatch(struct mei_device=20
  		}
 =20
  		if (!mei_hbm_version_is_supported(dev)) {
 -			dev_warn(&dev->pdev->dev, "hbm version mismatch: stopping the driver.\=
n");
 +			dev_warn(&dev->pdev->dev, "hbm: start: version mismatch - stopping the=
 driver.\n");
 =20
 -			dev->hbm_state =3D MEI_HBM_STOP;
 +			dev->hbm_state =3D MEI_HBM_STOPPED;
  			mei_hbm_stop_req_prepare(dev, &dev->wr_msg.hdr,
  						dev->wr_msg.data);
 -			mei_write_message(dev, &dev->wr_msg.hdr,
 -					dev->wr_msg.data);
 +			if (mei_write_message(dev, &dev->wr_msg.hdr,
 +					dev->wr_msg.data)) {
 +				dev_err(&dev->pdev->dev, "hbm: start: failed to send stop request\n");
 +				return -EIO;
 +			}
 +			break;
 +		}
 =20
 -			return;
 +		if (dev->dev_state !=3D MEI_DEV_INIT_CLIENTS ||
 +		    dev->hbm_state !=3D MEI_HBM_START) {
- 			dev_err(&dev->pdev->dev, "hbm: start: state mismatch, [%d, %d]\n",
++			dev_err_ratelimited(&dev->pdev->dev, "hbm: start: state mismatch, [%d,=
 %d]\n",
 +				dev->dev_state, dev->hbm_state);
 +			return -EPROTO;
  		}
 =20
 -		if (dev->dev_state =3D=3D MEI_DEV_INIT_CLIENTS &&
 -		    dev->hbm_state =3D=3D MEI_HBM_START) {
 -			dev->init_clients_timer =3D 0;
 -			mei_hbm_enum_clients_req(dev);
 -		} else {
 -			dev_err_ratelimited(&dev->pdev->dev, "reset: wrong host start response=
\n");
 -			mei_reset(dev, 1);
 -			return;
 +		dev->hbm_state =3D MEI_HBM_STARTED;
 +
 +		if (mei_hbm_enum_clients_req(dev)) {
 +			dev_err(&dev->pdev->dev, "hbm: start: failed to send enumeration reque=
st\n");
 +			return -EIO;
  		}
 =20
  		wake_up_interruptible(&dev->wait_recvd_msg);
@@@ -731,25 -681,19 +731,25 @@@
  				< sizeof(enum_res->valid_addresses));
  		memcpy(dev->me_clients_map, enum_res->valid_addresses,
  			sizeof(enum_res->valid_addresses));
 -		if (dev->dev_state =3D=3D MEI_DEV_INIT_CLIENTS &&
 -		    dev->hbm_state =3D=3D MEI_HBM_ENUM_CLIENTS) {
 -				dev->init_clients_timer =3D 0;
 -				mei_hbm_me_cl_allocate(dev);
 -				dev->hbm_state =3D MEI_HBM_CLIENT_PROPERTIES;
 -
 -				/* first property reqeust */
 -				mei_hbm_prop_req(dev);
 -		} else {
 -			dev_err_ratelimited(&dev->pdev->dev, "reset: unexpected enumeration re=
sponse hbm.\n");
 -			mei_reset(dev, 1);
 -			return;
 +
 +		if (dev->dev_state !=3D MEI_DEV_INIT_CLIENTS ||
 +		    dev->hbm_state !=3D MEI_HBM_ENUM_CLIENTS) {
- 			dev_err(&dev->pdev->dev, "hbm: enumeration response: state mismatch, [=
%d, %d]\n",
++			dev_err_ratelimited(&dev->pdev->dev, "hbm: enumeration response: state=
 mismatch, [%d, %d]\n",
 +				dev->dev_state, dev->hbm_state);
 +			return -EPROTO;
 +		}
 +
 +		if (mei_hbm_me_cl_allocate(dev)) {
 +			dev_err(&dev->pdev->dev, "hbm: enumeration response: cannot allocate c=
lients array\n");
 +			return -ENOMEM;
  		}
 +
 +		dev->hbm_state =3D MEI_HBM_CLIENT_PROPERTIES;
 +
 +		/* first property request */
 +		if (mei_hbm_prop_req(dev))
 +			return -EIO;
 +
  		break;
 =20
  	case HOST_STOP_RES_CMD:

--Signature=_Fri__10_Jan_2014_15_36_05_+1100_F18SuVfPKR+A3hG=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSz3i5AAoJEMDTa8Ir7ZwVkOMP/3wEyPjZK0DpE85fILHVHkO3
pWZX8q1lWDAsXNnJtJN5Pt21ff1lVed52v33LdVZn316v6NDuv34m2ePH78DsDCj
j/7o/AkZb+1i7gWztmtP49JLTEqn5W6hUECmpgvzI2REexxzmnmFd1k1NirCXcln
7y2/ek3Qqhf0xPIieEVTWkjjDodPdhgP/GCLWXRTkwALpqWJ8rkpXm4xHGCu7hwH
sJ5CkroMhGKIDW/3UXWBY+dBYwy7AkCfbAHXjxdY2DUw7T/l1Xmkl8ouluCVKCR9
pW6GwDAcP1vwzjx8drj48TATij5B7/pdqZkpn60nHBYuxJDPusGUO9UsdB8+GKq/
3d+kgSAV5sOlp1xI0LcMGHGOE8ZJwxEqgULbREd/EMi0fHQUDzJsiuHuDdn7VEHG
bkhlgOKIwhd1lHq+ojUKaje5qMArtN/MX+/Mf7jIZ4Bri3l6UgB5m4I2r8PYzmSh
JTJgwUX8L0cAtQ5yhcUJkvSJO7CD7kwJQjG3/5awMteI6p6f3XpqegYBO3QOnzL8
ygg5kWNffhGs4NUrvA4o6fDf4nJU+SnrPeWZShS8tXwPS0uwg0tmIQ/z0fvjtHQO
GR4WLcWnrrNbwTwLqdHCXgtZReur2h5zhQWW9Ypggg3B2hDBMc6s1GUzRQ9PH8O4
LdttoSK8k7/CnRL5S9/a
=YnMy
-----END PGP SIGNATURE-----

--Signature=_Fri__10_Jan_2014_15_36_05_+1100_F18SuVfPKR+A3hG=--
