Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550Ab3GHDrb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 23:47:31 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:46554 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821Ab3GHDra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 23:47:30 -0400
Date: Mon, 8 Jul 2013 13:47:21 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nicholas Bellinger <nab@linux-iscsi.org>, Asias He <asias@redhat.com>
Subject: linux-next: manual merge of the vhost tree with the target-updates
 tree
Message-Id: <20130708134721.8ac2d67125b60c745d46006f@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.19; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__8_Jul_2013_13_47_21_+1000_2Nxow5K5Ub/j1T_p"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__8_Jul_2013_13_47_21_+1000_2Nxow5K5Ub/j1T_p
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Michael,

Today's linux-next merge of the vhost tree got a conflict in
drivers/vhost/scsi.c between commit 084ed45b3846 ("vhost/scsi: Convert to
se_cmd->cmd_kref TARGET_SCF_ACK_KREF usage") from the target-updates tree
and commit 3c63f66a0dcd ("vhost-scsi: Rename struct tcm_vhost_cmd *tv_cmd
to *cmd") from the vhost tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/vhost/scsi.c
index b351938,4264840..0000000
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@@ -446,19 -448,7 +448,19 @@@ static u32 tcm_vhost_tpg_get_inst_index
 =20
  static void tcm_vhost_release_cmd(struct se_cmd *se_cmd)
  {
- 	struct tcm_vhost_cmd *tv_cmd =3D container_of(se_cmd,
 -	return;
++	struct tcm_vhost_cmd *cmd =3D container_of(se_cmd,
 +				struct tcm_vhost_cmd, tvc_se_cmd);
 +
- 	if (tv_cmd->tvc_sgl_count) {
++	if (cmd->tvc_sgl_count) {
 +		u32 i;
- 		for (i =3D 0; i < tv_cmd->tvc_sgl_count; i++)
- 			put_page(sg_page(&tv_cmd->tvc_sgl[i]));
++		for (i =3D 0; i < cmd->tvc_sgl_count; i++)
++			put_page(sg_page(&cmd->tvc_sgl[i]));
 +
- 		kfree(tv_cmd->tvc_sgl);
++		kfree(cmd->tvc_sgl);
 +        }
 +
- 	tcm_vhost_put_inflight(tv_cmd->inflight);
- 	kfree(tv_cmd);
++	tcm_vhost_put_inflight(cmd->inflight);
++	kfree(cmd);
  }
 =20
  static int tcm_vhost_shutdown_session(struct se_session *se_sess)
@@@ -564,22 -555,28 +567,22 @@@ tcm_vhost_allocate_evt(struct vhost_scs
  	return evt;
  }
 =20
- static void vhost_scsi_free_cmd(struct tcm_vhost_cmd *tv_cmd)
+ static void vhost_scsi_free_cmd(struct tcm_vhost_cmd *cmd)
  {
- 	struct se_cmd *se_cmd =3D &tv_cmd->tvc_se_cmd;
+ 	struct se_cmd *se_cmd =3D &cmd->tvc_se_cmd;
 =20
  	/* TODO locking against target/backend threads? */
 -	transport_generic_free_cmd(se_cmd, 1);
 +	transport_generic_free_cmd(se_cmd, 0);
 =20
 -	if (cmd->tvc_sgl_count) {
 -		u32 i;
 -		for (i =3D 0; i < cmd->tvc_sgl_count; i++)
 -			put_page(sg_page(&cmd->tvc_sgl[i]));
 -
 -		kfree(cmd->tvc_sgl);
 -	}
 -
 -	tcm_vhost_put_inflight(cmd->inflight);
 +}
 =20
 -	kfree(cmd);
 +static int vhost_scsi_check_stop_free(struct se_cmd *se_cmd)
 +{
 +	return target_put_sess_cmd(se_cmd->se_sess, se_cmd);
  }
 =20
- static void tcm_vhost_do_evt_work(struct vhost_scsi *vs,
- 	struct tcm_vhost_evt *evt)
+ static void
+ tcm_vhost_do_evt_work(struct vhost_scsi *vs, struct tcm_vhost_evt *evt)
  {
  	struct vhost_virtqueue *vq =3D &vs->vqs[VHOST_SCSI_VQ_EVT].vq;
  	struct virtio_scsi_event *event =3D &evt->event;
@@@ -847,13 -850,13 +856,13 @@@ static void tcm_vhost_submission_work(s
  	} else {
  		sg_ptr =3D NULL;
  	}
- 	tv_nexus =3D tv_cmd->tvc_nexus;
+ 	tv_nexus =3D cmd->tvc_nexus;
 =20
  	rc =3D target_submit_cmd_map_sgls(se_cmd, tv_nexus->tvn_se_sess,
- 			tv_cmd->tvc_cdb, &tv_cmd->tvc_sense_buf[0],
- 			tv_cmd->tvc_lun, tv_cmd->tvc_exp_data_len,
- 			tv_cmd->tvc_task_attr, tv_cmd->tvc_data_direction,
- 			TARGET_SCF_ACK_KREF, sg_ptr, tv_cmd->tvc_sgl_count,
+ 			cmd->tvc_cdb, &cmd->tvc_sense_buf[0],
+ 			cmd->tvc_lun, cmd->tvc_exp_data_len,
+ 			cmd->tvc_task_attr, cmd->tvc_data_direction,
 -			0, sg_ptr, cmd->tvc_sgl_count,
++			TARGET_SCF_ACK_KREF, sg_ptr, cmd->tvc_sgl_count,
  			sg_bidi_ptr, sg_no_bidi);
  	if (rc < 0) {
  		transport_send_check_condition_and_sense(se_cmd,

--Signature=_Mon__8_Jul_2013_13_47_21_+1000_2Nxow5K5Ub/j1T_p
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR2jZMAAoJEECxmPOUX5FElSUP/1xN/4upNJck3dAj+/jwwGcZ
Ha/UwwQjE5mbihI8K1UQezDp4RFuJsqv/Gqq0w59LSsOgUSwYxK54OtLGYGuLZZk
OTrT1wM0MQLRxkmtlxDg3UUnUC1KV5+RdiwMOkk6flWDV0ANNa2wvHvPkWK7+J7m
SgPbhx53mQxZJ5h4iL7FAIXTb3mPEFioS99590Qswy2yNU9k/eewDdYAWnkTGVtD
nQfl+ceCktYkI35YFvKA0LYmNWCOj+MRowy+U+6XixyE3Wz8C/PZBFXEpvCWDcTd
S7mk/rSNdz0sByEorBczrq0MkYI2oxpMgajuV0tHL1Hf2cmDN6FMqDsevO3B5dXT
viO5SoRv99+ka9cC2Usj4Ny5wVsX43NSbP4QNe4dqdVtZdmJCyHFLyhXudziOFQt
05y94esFM80LDZ8Pb7mCpdmflnFqW9LhPkgK9sxkbS9dQVTuxmJ0JlSYlIafSqAv
W862pktq3rhUVvqh3RJUR4nc5g+/xNwfpUCBRHpFOOPHXda5k8aMJcInk0zWT0ma
YjpNWGJ2ZhDv5RPZzYGpkD8fj/pG92+SDPI/qI8NpvgdSgpiiRV/SwAAQulE8ZJo
RSo/mmn0r3xxhzPtMCVe2CQO0wtJ5g3GNufCW1b7zaYTto+BZiWjy5iQ9nDCNoSO
beK8QQrwp+8jbuftg9CY
=TTeU
-----END PGP SIGNATURE-----

--Signature=_Mon__8_Jul_2013_13_47_21_+1000_2Nxow5K5Ub/j1T_p--
