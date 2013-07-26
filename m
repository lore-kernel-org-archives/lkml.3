Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756949Ab3GZDsh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 23:48:37 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:46296 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924Ab3GZDsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 23:48:35 -0400
Date: Fri, 26 Jul 2013 13:48:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Eric Paris <eparis@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Quigley <dpquigl@davequigley.com>,
        "Matthew N. Dodd" <Matthew.Dodd@sparta.com>,
        Miguel Rodel Felipe <Rodel_FM@dsi.a-star.edu.sg>,
        Phua Eu Gene <PHUA_Eu_Gene@dsi.a-star.edu.sg>,
        Khin Mi Mi Aung <Mi_Mi_AUNG@dsi.a-star.edu.sg>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: linux-next: manual merge of the selinux tree with Linus' tree
Message-Id: <20130726134823.e4c0a1b7bad087c12b3ce782@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__26_Jul_2013_13_48_23_+1000_VItqWXMydGOGgI+6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__26_Jul_2013_13_48_23_+1000_VItqWXMydGOGgI+6
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Eric,

Today's linux-next merge of the selinux tree got a conflict in
security/selinux/hooks.c between commit eb9ae686507b ("SELinux: Add new
labeling type native labels") from Linus' tree and commits 40d3d0b85fa2
("SELinux: remove crazy contortions around proc") and a64c54cf0811
("SELinux: pass a superblock to security_fs_use") from the selinux tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

P.S. Unusually, that commit from Linus' tree has no Signed-off-by from
its purported author (David Quigley).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
diff --cc security/selinux/hooks.c
index a5091ec,4fbf2c5..0000000
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@@ -680,21 -702,14 +712,19 @@@ static int selinux_set_mnt_opts(struct=20
  	if (strcmp(sb->s_type->name, "proc") =3D=3D 0)
  		sbsec->flags |=3D SE_SBPROC;
 =20
 -	/* Determine the labeling behavior to use for this filesystem type. */
 -	rc =3D security_fs_use(sb);
 -	if (rc) {
 -		printk(KERN_WARNING "%s: security_fs_use(%s) returned %d\n",
 -		       __func__, sb->s_type->name, rc);
 -		goto out;
 +	if (!sbsec->behavior) {
 +		/*
 +		 * Determine the labeling behavior to use for this
 +		 * filesystem type.
 +		 */
- 		rc =3D security_fs_use((sbsec->flags & SE_SBPROC) ?
- 					"proc" : sb->s_type->name,
- 					&sbsec->behavior, &sbsec->sid);
++		rc =3D security_fs_use(sb);
 +		if (rc) {
 +			printk(KERN_WARNING
 +				"%s: security_fs_use(%s) returned %d\n",
 +					__func__, sb->s_type->name, rc);
 +			goto out;
 +		}
  	}
 -
  	/* sets the context of the superblock for the fs being mounted. */
  	if (fscontext_sid) {
  		rc =3D may_context_mount_sb_relabel(fscontext_sid, sbsec, cred);
@@@ -2629,11 -2589,15 +2659,11 @@@ static int selinux_inode_init_security(
  		isec->initialized =3D 1;
  	}
 =20
- 	if (!ss_initialized || !(sbsec->flags & SE_SBLABELSUPP))
+ 	if (!ss_initialized || !(sbsec->flags & SBLABEL_MNT))
  		return -EOPNOTSUPP;
 =20
 -	if (name) {
 -		namep =3D kstrdup(XATTR_SELINUX_SUFFIX, GFP_NOFS);
 -		if (!namep)
 -			return -ENOMEM;
 -		*name =3D namep;
 -	}
 +	if (name)
 +		*name =3D XATTR_SELINUX_SUFFIX;
 =20
  	if (value && len) {
  		rc =3D security_sid_to_context_force(newsid, &context, &clen);

--Signature=_Fri__26_Jul_2013_13_48_23_+1000_VItqWXMydGOGgI+6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR8fGKAAoJEECxmPOUX5FEIFkP+wfb+ZrrOvvhwfh1zpYnoBYZ
Uoh+lK2BmZuarDUpRPvTO68OACXbh0wlG/p7ThYWvYV51BDMDbKF2QD0oHA75w2M
JhMs3aE7yufBTpQqdroAtafiG9jtLWrWidTflqJjCmRDoQGe4mgVW+OZowGC7Tao
+VU/Ufbl8PwmyplZQStdFvTeI1nlfW1lbQhaWOvPpJYgCr2W6G6jkrBCcblmRaku
tB+rKhpgO8rX2QvKySghDceJWWvDwqzJEN9V7KD9BOqsJiDoiv/cgVwE8aovwtLx
oFX6EwfF8bjRpsLG9yXyM8mgUxjccWFm5mFghX++m1+SgxkDrnEC82Kkp57LxTQG
2etNfHeC/w9aCZQnNbUnr7taS7dziGIoQ+kLuRFg5kDhsJKV5/HBIQroWit0y5H3
TKZ0kRJ8P98CKPQWjB0DhAqLZBq7kptcUv9LeyxQAP8Ndignrd/3w2Ta+2jUnsbJ
Ya9rfkIjh265E8CsAIJtMOMa4iPg6pEs4zSrzSS8JpqK7MeqGONS9hBaZZebWRkL
XqO28TupNmXTzHKbPG44Ps/1oTh96faS85OcKxstS3Ccc9IIDpkaan2/SrkRTTzM
nu4Y9l4puG9/eluBS6X31AcgsHpyxSAD/BatCZ+gXX13v9p267sb2E6V8FcQ7ZLu
lKgbpE4Mrl5F1KAFQGjN
=sFMN
-----END PGP SIGNATURE-----

--Signature=_Fri__26_Jul_2013_13_48_23_+1000_VItqWXMydGOGgI+6--
