Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767AbaEWJHY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 05:07:24 -0400
Received: from ozlabs.org ([103.22.144.67]:45754 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752741AbaEWJHU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 05:07:20 -0400
Date: Fri, 23 May 2014 19:07:13 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
Subject: linux-next: manual merge of the target-updates tree with the  tree
Message-ID: <20140523190713.198c5d68@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/E4W2tqCkZ4iaUmGS=69h4k5"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/E4W2tqCkZ4iaUmGS=69h4k5
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Nicholas,

Today's linux-next merge of the target-updates tree got a conflict in
drivers/scsi/virtio_scsi.c between commit b54197c43db8 ("virtio_scsi:
use cmd_size") from the scsi tree and commit 4baaa7d589e2
("virtio-scsi: Enable DIF/DIX modes in SCSI host LLD") from the
target-updates tree.

I fixed it up (I think - see below) and can carry the fix as necessary
(no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/scsi/virtio_scsi.c
index d4727b339474,cc634b0e8f04..000000000000
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@@ -456,9 -537,10 +497,10 @@@ static int virtscsi_queuecommand(struc
  				 struct virtio_scsi_vq *req_vq,
  				 struct scsi_cmnd *sc)
  {
 -	struct virtio_scsi_cmd *cmd;
 -	int ret, req_size;
 -
++	int req_size;
  	struct Scsi_Host *shost =3D virtio_scsi_host(vscsi->vdev);
 +	struct virtio_scsi_cmd *cmd =3D scsi_cmd_priv(sc);
 +
  	BUG_ON(scsi_sg_count(sc) > shost->sg_tablesize);
 =20
  	/* TODO: check feature bit and fail if unsupported?  */
@@@ -467,27 -549,34 +509,25 @@@
  	dev_dbg(&sc->device->sdev_gendev,
  		"cmd %p CDB: %#02x\n", sc, sc->cmnd[0]);
 =20
 -	ret =3D SCSI_MLQUEUE_HOST_BUSY;
 -	cmd =3D mempool_alloc(virtscsi_cmd_pool, GFP_ATOMIC);
 -	if (!cmd)
 -		goto out;
 -
  	memset(cmd, 0, sizeof(*cmd));
  	cmd->sc =3D sc;
- 	cmd->req.cmd =3D (struct virtio_scsi_cmd_req){
- 		.lun[0] =3D 1,
- 		.lun[1] =3D sc->device->id,
- 		.lun[2] =3D (sc->device->lun >> 8) | 0x40,
- 		.lun[3] =3D sc->device->lun & 0xff,
- 		.tag =3D (unsigned long)sc,
- 		.task_attr =3D VIRTIO_SCSI_S_SIMPLE,
- 		.prio =3D 0,
- 		.crn =3D 0,
- 	};
 =20
  	BUG_ON(sc->cmd_len > VIRTIO_SCSI_CDB_SIZE);
- 	memcpy(cmd->req.cmd.cdb, sc->cmnd, sc->cmd_len);
 =20
- 	if (virtscsi_kick_cmd(req_vq, cmd,
- 			      sizeof cmd->req.cmd, sizeof cmd->resp.cmd,
+ 	if (virtio_has_feature(vscsi->vdev, VIRTIO_SCSI_F_T10_PI)) {
+ 		virtio_scsi_init_hdr_pi(&cmd->req.cmd_pi, sc);
+ 		memcpy(cmd->req.cmd_pi.cdb, sc->cmnd, sc->cmd_len);
+ 		req_size =3D sizeof(cmd->req.cmd_pi);
+ 	} else {
+ 		virtio_scsi_init_hdr(&cmd->req.cmd, sc);
+ 		memcpy(cmd->req.cmd.cdb, sc->cmnd, sc->cmd_len);
+ 		req_size =3D sizeof(cmd->req.cmd);
+ 	}
+=20
+ 	if (virtscsi_kick_cmd(req_vq, cmd, req_size, sizeof(cmd->resp.cmd),
 -			      GFP_ATOMIC) =3D=3D 0)
 -		ret =3D 0;
 -	else
 -		mempool_free(cmd, virtscsi_cmd_pool);
 -
 -out:
 -	return ret;
 +			      GFP_ATOMIC) !=3D 0)
 +		return SCSI_MLQUEUE_HOST_BUSY;
 +	return 0;
  }
 =20
  static int virtscsi_queuecommand_single(struct Scsi_Host *sh,

--Sig_/E4W2tqCkZ4iaUmGS=69h4k5
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTfw/GAAoJEMDTa8Ir7ZwVfBUP/05EGZqhRXoKdcC7kbb8ZmkV
RaOIHoGCtUMFCyX99orF6yPK7Q9F6kh8vU0KTAKSSmebYHMzUCF6fhznOYS6Lnv5
mo69ftjgk5GtvwdZNU954X0sjH7RtrssoTcFIVLm6f9q+kkL98dMMYk/WfgJqafI
o0hzwKzNhSnbYwxnfaA0mjHzVdzF6hv7Cd84BxqUPGWNIV+HIl1rOeAr8CC4uAgD
V0RFeBBj1+gVA8jjdRJCV7P8CoCvCkg+K4BIQXFDkHeDdNjaT7sL2EjqWKgyrGbb
+omkGPmiisUiMdpg0aXZh947dNeXYk1S+FEtoDEdt7yZRWJFJq4VN63fpZeZNChN
MNCRCYEk/0feuHvH5Xzhi28dtAuHOkalcOrI3WDKQKr+0p32FliCQgctGWxSgNoR
anoqkpqNMrdHj5NIIt0pGqYudlOcQdnLnDWbpFp6ggbtC9LTph3N2xx9eIty043P
nvvMqLhsTRVcUCk6dvSmt5z1GCDA92unHuAgInOijPmXNN7qd5dR3DZqTh/aV8Jv
5VcYarhOWkXa5YFuOlwPFI0cUx5etj/CFwlV6SX/Ku5fqG4hAXuKbq7hs+wH0w6G
Z359VTBZNl6MNIK5Os7lMCYVR1GRHhD2EPFU3fl3qk+projDGio929TzTYdfadzt
VA7kPs1YJpqzv9NauSF2
=grno
-----END PGP SIGNATURE-----

--Sig_/E4W2tqCkZ4iaUmGS=69h4k5--
