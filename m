Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751728AbaEZICQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 04:02:16 -0400
Received: from ozlabs.org ([103.22.144.67]:38171 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751509AbaEZICO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 04:02:14 -0400
Date: Mon, 26 May 2014 18:02:03 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Quinn Tran <quinn.tran@qlogic.com>, Christoph Hellwig <hch@lst.de>
Subject: linux-next: manual merge of the target-updates tree with the scsi
 tree
Message-ID: <20140526180203.1a0f22d8@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/1ZKIAmJKGqeaRbEsSx.iQ+p"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/1ZKIAmJKGqeaRbEsSx.iQ+p
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Nicholas,

Today's linux-next merge of the target-updates tree got a conflict in
drivers/scsi/qla2xxx/qla_target.c between commit f83adb617f55
("qla2xxx: T10-Dif: add T10-PI support") from the scsi tree and commit
ed6849ff4921 ("qla2xxx: Convert to percpu_ida session tag
pre-allocation") from the target-updates tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/scsi/qla2xxx/qla_target.c
index b1d10f9935c7,bd9c725c08e1..000000000000
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@@ -2705,15 -2164,18 +2704,22 @@@ done
 =20
  void qlt_free_cmd(struct qla_tgt_cmd *cmd)
  {
+ 	struct qla_tgt_sess *sess =3D cmd->sess;
+=20
 -	BUG_ON(cmd->sg_mapped);
 +	ql_dbg(ql_dbg_tgt, cmd->vha, 0xe074,
 +	    "%s: se_cmd[%p] ox_id %04x\n",
 +	    __func__, &cmd->se_cmd,
 +	    be16_to_cpu(cmd->atio.u.isp24.fcp_hdr.ox_id));
 =20
 +	BUG_ON(cmd->sg_mapped);
  	if (unlikely(cmd->free_sg))
  		kfree(cmd->sg);
- 	kmem_cache_free(qla_tgt_cmd_cachep, cmd);
+=20
+ 	if (!sess || !sess->se_sess) {
+ 		WARN_ON(1);
+ 		return;
+ 	}
+ 	percpu_ida_free(&sess->se_sess->sess_tag_pool, cmd->se_cmd.map_tag);
  }
  EXPORT_SYMBOL(qlt_free_cmd);
 =20
@@@ -3149,12 -2533,11 +3119,12 @@@ static void __qlt_do_work(struct qla_tg
  	    atio->u.isp24.fcp_cmnd.add_cdb_len]));
 =20
  	ql_dbg(ql_dbg_tgt, vha, 0xe022,
 -	    "qla_target: START qla command: %p lun: 0x%04x (tag %d)\n",
 -	    cmd, cmd->unpacked_lun, cmd->tag);
 +		"qla_target: START qla cmd: %p se_cmd %p lun: 0x%04x (tag %d) len(%d) o=
x_id %x\n",
 +		cmd, &cmd->se_cmd, cmd->unpacked_lun, cmd->tag, data_length,
 +		cmd->atio.u.isp24.fcp_hdr.ox_id);
 =20
- 	ret =3D vha->hw->tgt.tgt_ops->handle_cmd(vha, cmd, cdb, data_length,
- 	    fcp_task_attr, data_dir, bidi);
+ 	ret =3D ha->tgt.tgt_ops->handle_cmd(vha, cmd, cdb, data_length,
+ 				          fcp_task_attr, data_dir, bidi);
  	if (ret !=3D 0)
  		goto out_term;
  	/*

--Sig_/1ZKIAmJKGqeaRbEsSx.iQ+p
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTgvUBAAoJEMDTa8Ir7ZwVMHsQAJNEFaRnNubHIseJmFe4nNTL
bcCwjGj3+oEitaKzFwWRSxWg8KzfbYFCbKbf1PZvIL2AkaPk7DzgV1Ws7aHeUzd8
uZxyRKZGzRDjWjXTmy0W+Ui65kjaH3uB2HCN60xqOUTTZ1sxKXpiM+XWPU6KCtp7
kNljrxzSmIE0evpmB+JepHJDCe19KSmrfL8Q7/qB4JVEEpNEWNahwdg6+EGdCejU
OT5tD7/vbeXaL6iaZXpWhM9EOEhS9sAUZ7AUYSzddSIK9ms69Swa3MS82IzgxWiJ
Y+BYZQaz7lEUYr4027FNljU6SzmfMQdHJiLthtzUbviYW/z0D87a6AX9i/lZuVer
F1ZyHgrjuBcckNZwQiq2jrp7UyMk2H+P5MOUD6ZQQrscCjN6D0VMIWGeuhO+TGAL
Ru/uQt+xqAs3LJew7lFKTlLxq83juVSwwh4z2p8K2OkWH6Tr6qWoSKTu+gelB4RH
XFZRzHlH7eCiilJ4fgy0Ij7uhz3tFH8K9KYyHIquldAmrpNCs2joTMrV5i2wizSY
rZdeu+9snMlXUZmhn6LY+n0jd8Gf3w9Iox9ZLZTmBdBTXUpSs9rGmHc0eLxH2JDB
yMQ6gpXUs4wwFyhBJ66IO8WqAlun57aj695mZK+St+zAYhDEYv6nbUodhw1mqEtF
49lE46NVn6DIx0fYPgWE
=l8v4
-----END PGP SIGNATURE-----

--Sig_/1ZKIAmJKGqeaRbEsSx.iQ+p--
