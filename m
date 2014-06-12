Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751075AbaFLERm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 00:17:42 -0400
Received: from ozlabs.org ([103.22.144.67]:35853 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750787AbaFLERk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 00:17:40 -0400
Date: Thu, 12 Jun 2014 14:17:32 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the target-updates tree with the virtio
 tree
Message-ID: <20140612141732.22e5fc6d@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/ZMOOzCAbMFCi5zQVCnj_Gmd"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/ZMOOzCAbMFCi5zQVCnj_Gmd
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Nicholas,

Today's linux-next merge of the target-updates tree got a conflict in
drivers/scsi/virtio_scsi.c between commit c77fba9ab058 ("virtio_scsi:
don't call virtqueue_add_sgs(... GFP_NOIO) holding spinlock") from the
virtio tree and commit e6dc783a38ec ("virtio-scsi: Enable DIF/DIX modes
in SCSI host LLD") from the target-updates tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/scsi/virtio_scsi.c
index 99fdb9403944,1c326b63ca55..000000000000
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@@ -396,10 -438,11 +398,10 @@@ static void virtscsi_event_done(struct=20
   */
  static int virtscsi_add_cmd(struct virtqueue *vq,
  			    struct virtio_scsi_cmd *cmd,
 -			    size_t req_size, size_t resp_size, gfp_t gfp)
 +			    size_t req_size, size_t resp_size)
  {
  	struct scsi_cmnd *sc =3D cmd->sc;
- 	struct scatterlist *sgs[4], req, resp;
+ 	struct scatterlist *sgs[6], req, resp;
  	struct sg_table *out, *in;
  	unsigned out_num =3D 0, in_num =3D 0;
 =20
@@@ -425,10 -472,14 +431,14 @@@
  	sgs[out_num + in_num++] =3D &resp;
 =20
  	/* Data-in buffer */
- 	if (in)
+ 	if (in) {
+ 		/* Place READ protection SGLs before Data IN payload */
+ 		if (scsi_prot_sg_count(sc))
+ 			sgs[out_num + in_num++] =3D scsi_prot_sglist(sc);
  		sgs[out_num + in_num++] =3D in->sgl;
+ 	}
 =20
 -	return virtqueue_add_sgs(vq, sgs, out_num, in_num, cmd, gfp);
 +	return virtqueue_add_sgs(vq, sgs, out_num, in_num, cmd, GFP_ATOMIC);
  }
 =20
  static int virtscsi_kick_cmd(struct virtio_scsi_vq *vq,
@@@ -455,9 -538,10 +497,10 @@@ static int virtscsi_queuecommand(struc
  				 struct virtio_scsi_vq *req_vq,
  				 struct scsi_cmnd *sc)
  {
 -	struct virtio_scsi_cmd *cmd;
 -	int ret, req_size;
 -
  	struct Scsi_Host *shost =3D virtio_scsi_host(vscsi->vdev);
 +	struct virtio_scsi_cmd *cmd =3D scsi_cmd_priv(sc);
++	int req_size;
 +
  	BUG_ON(scsi_sg_count(sc) > shost->sg_tablesize);
 =20
  	/* TODO: check feature bit and fail if unsupported?  */
@@@ -466,26 -550,34 +509,24 @@@
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
- 			      sizeof cmd->req.cmd, sizeof cmd->resp.cmd) !=3D 0)
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
 -	if (virtscsi_kick_cmd(req_vq, cmd, req_size, sizeof(cmd->resp.cmd),
 -			      GFP_ATOMIC) =3D=3D 0)
 -		ret =3D 0;
 -	else
 -		mempool_free(cmd, virtscsi_cmd_pool);
 -
 -out:
 -	return ret;
++	if (virtscsi_kick_cmd(req_vq, cmd, req_size, sizeof cmd->resp.cmd) !=3D =
0)
 +		return SCSI_MLQUEUE_HOST_BUSY;
 +	return 0;
  }
 =20
  static int virtscsi_queuecommand_single(struct Scsi_Host *sh,

--Sig_/ZMOOzCAbMFCi5zQVCnj_Gmd
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTmSniAAoJEMDTa8Ir7ZwVppQQAIhNSxcDzr7tatuCcfXU6a2J
DCOAQnNw+tTbRcikYYgIH1bePRrqQRrfg+xOT0476v6cwW4OrLhJVPXqu0Qf18IA
8O0j+yPPRGtCdYsKDfUhOWnzZgzmI7FgE6Kq8dZcD2c9+lekcL0H+DVyJ0XLPAtE
IHYEh3tzl0Bdmjoj8ZW30bogBLP5QJpVv4y9NasTANrDUWg4uA3q+LdXCsbBKytW
Qk/BixAA5Rw7iC7AB6iGZaqriL7Djlj+1LWjbETcF10yk5tof6jxxnR5dKAVkqeD
YzKWnUusG6j9RqusAOpkLBPjvm6/hMkCg71uxTSgo/or4hRH8KitRhnewSrGAtYP
ifu6LnuKi9Iplv2gse8tkRHR6kH3zLwZnTJUFX1MqTKdDOgvLl0TALIjocT9eUqL
speJUL2j3GfBCPygMjw1IISRGJmxhq1PgKUChWtNmN0kdvvVHJejugJ9M4Xdp8tq
p8nhWh5SuKYEun+L7O/nZTSi+2McwBm77MAmp2U6kL8FTRDY4SdmcKkw3aUidoZt
hbOsovWpTPGRC08hQC1mQI/eXkI08z817VhPFXO2C4a0AORPYMkhGtElzJjck+tx
zFiZAnEWr+KsTOezjewH23At7xQG59MGfFJEkOkKEmLlzTttFuWSOUr5HJTPwS4V
FIlaCRstS34uPovXkQZt
=ecZt
-----END PGP SIGNATURE-----

--Sig_/ZMOOzCAbMFCi5zQVCnj_Gmd--
