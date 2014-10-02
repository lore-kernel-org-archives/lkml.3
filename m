Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807AbaJBIbV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 04:31:21 -0400
Received: from ozlabs.org ([103.22.144.67]:47862 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751319AbaJBIbT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 04:31:19 -0400
Date: Thu, 2 Oct 2014 18:31:11 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joern Engel <joern@logfs.org>, Quinn Tran <quinn.tran@qlogic.com>,
        Christoph Hellwig <hch@lst.de>
Subject: linux-next: manual merge of the target-updates tree with the scsi
 tree
Message-ID: <20141002183111.5eb998a7@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/pp_jn3utfzg+2+N6=EZxl_K"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/pp_jn3utfzg+2+N6=EZxl_K
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Nicholas,

Today's linux-next merge of the target-updates tree got a conflict in
drivers/scsi/qla2xxx/qla_target.c between commit 33e799775593
("qla2xxx: Add support for QFull throttling and Term Exchange retry")
from the scsi tree and commit 55a9066fffd2 ("qla_target: make some
global functions static") from the target-updates tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/scsi/qla2xxx/qla_target.c
index 829752cfd73f,68c90ad441f4..000000000000
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@@ -108,10 -101,7 +108,11 @@@ static void qlt_send_term_exchange(stru
  	*cmd, struct atio_from_isp *atio, int ha_locked);
  static void qlt_reject_free_srr_imm(struct scsi_qla_host *ha,
  	struct qla_tgt_srr_imm *imm, int ha_lock);
 +static void qlt_abort_cmd_on_host_reset(struct scsi_qla_host *vha,
 +	struct qla_tgt_cmd *cmd);
 +static void qlt_alloc_qfull_cmd(struct scsi_qla_host *vha,
 +	struct atio_from_isp *atio, uint16_t status, int qfull);
+ static void qlt_disable_vha(struct scsi_qla_host *vha);
  /*
   * Global Variables
   */
@@@ -189,28 -179,7 +190,28 @@@ struct scsi_qla_host *qlt_find_host_by_
  	return NULL;
  }
 =20
 +static inline void qlt_incr_num_pend_cmds(struct scsi_qla_host *vha)
 +{
 +	unsigned long flags;
 +
 +	spin_lock_irqsave(&vha->hw->tgt.q_full_lock, flags);
 +
 +	vha->hw->tgt.num_pend_cmds++;
 +	if (vha->hw->tgt.num_pend_cmds > vha->hw->qla_stats.stat_max_pend_cmds)
 +		vha->hw->qla_stats.stat_max_pend_cmds =3D
 +			vha->hw->tgt.num_pend_cmds;
 +	spin_unlock_irqrestore(&vha->hw->tgt.q_full_lock, flags);
 +}
 +static inline void qlt_decr_num_pend_cmds(struct scsi_qla_host *vha)
 +{
 +	unsigned long flags;
 +
 +	spin_lock_irqsave(&vha->hw->tgt.q_full_lock, flags);
 +	vha->hw->tgt.num_pend_cmds--;
 +	spin_unlock_irqrestore(&vha->hw->tgt.q_full_lock, flags);
 +}
 +
- void qlt_24xx_atio_pkt_all_vps(struct scsi_qla_host *vha,
+ static void qlt_24xx_atio_pkt_all_vps(struct scsi_qla_host *vha,
  	struct atio_from_isp *atio)
  {
  	ql_dbg(ql_dbg_tgt, vha, 0xe072,
@@@ -3085,10 -2924,8 +3084,9 @@@ static void qlt_do_ctio_completion(stru
 =20
  	se_cmd =3D &cmd->se_cmd;
  	tfo =3D se_cmd->se_tfo;
 +	cmd->cmd_sent_to_fw =3D 0;
 =20
- 	if (cmd->sg_mapped)
- 		qlt_unmap_sg(vha, cmd);
+ 	qlt_unmap_sg(vha, cmd);
 =20
  	if (unlikely(status !=3D CTIO_SUCCESS)) {
  		switch (status & 0xFFFF) {

--Sig_/pp_jn3utfzg+2+N6=EZxl_K
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJULQ1UAAoJEMDTa8Ir7ZwVIcYP/3RjVSAhn8ooUN6MeEkifq89
zQuPx1lFbHxBGjxqAuhWO+MPCE/IoVFRGY+2khlmF3VJ+X08iZPFaUZ5QSRaZFxZ
LV4HES2c2fjEr1PMs3iX4+CjrJBLyKFebR9zth2FETyCzcY0EFGSrpiBmAR9pun8
yj3dKyFXfjS91BnAXCPMxUpg3XKWBhW3U2PLPRl4zGacItrxxaR6TmrIL90wm9wr
fWgY5kUvoaW5ayZgEZMQl8RhYD8q46tqI9Hh3L06FmU7iS4AxbU3a4aUniWD3mVS
VWIDCFFE8hxyS+kw2iY1RHa29raWz5VWvt6NFb6in6q5c89vvwwuD1QD9p2EIKUs
TRO+9CukQMpvDAI533OpXu+81yQ6kh4ZaRYFDzyUzg0hS8qJYE/DYR8AT7m+HFhR
mvRnJvktBHLmaXqM9TP3YqtNZ5/yatAuRJ/WYCMbmVjSlOUg5cw9eRC5M2wDNy45
fuQdBP5COpVVl+YFjfpzotT9c4/gpqYebdj53JNgjGOVjZMJqIRnl2RxwO0JaFoO
8Q/USeQY9DGsm/NhLX4UXeFkVBaubCCr+bEHO0zzEVOFiQ2A0fkJiHmv93RgIYnY
g3qQEf970JnZKhIOKE41eEUTDPanmTbH91oVWamr095z5KWfUGuw+ydZsY8yBzes
pG1r4lsdy1JZjOiMlq+5
=1XUd
-----END PGP SIGNATURE-----

--Sig_/pp_jn3utfzg+2+N6=EZxl_K--
