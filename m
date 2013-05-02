Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015Ab3EBGBp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 02:01:45 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:48951 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139Ab3EBGBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 02:01:41 -0400
Date: Thu, 2 May 2013 16:01:29 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: linux-next: manual merge of the akpm tree with Linus' tree
Message-Id: <20130502160129.26eab084d5094c8aa416a9ae@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__2_May_2013_16_01_29_+1000_T2nMo7M22knAHL0v"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__2_May_2013_16_01_29_+1000_T2nMo7M22knAHL0v
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in ipc/msg.c
between commit 8ac6ed5857c8 ("ipc: implement MSG_COPY as a new receive
mode") from Linus' tree and commit "revert "ipc: don't allocate a copy
larger than max"" from the akpm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

[  The whole patch looks like this, now:

diff --git a/ipc/msg.c b/ipc/msg.c
index d0c6d96..2978721 100644
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -827,16 +827,15 @@ long do_msgrcv(int msqid, void __user *buf, size_t bu=
fsz, long msgtyp,
 	struct ipc_namespace *ns;
 	struct msg_msg *copy =3D NULL;
=20
-	ns =3D current->nsproxy->ipc_ns;
-
 	if (msqid < 0 || (long) bufsz < 0)
 		return -EINVAL;
 	if (msgflg & MSG_COPY) {
-		copy =3D prepare_copy(buf, min_t(size_t, bufsz, ns->msg_ctlmax));
+		copy =3D prepare_copy(buf, bufsz);
 		if (IS_ERR(copy))
 			return PTR_ERR(copy);
 	}
 	mode =3D convert_mode(&msgtyp, msgflg);
+	ns =3D current->nsproxy->ipc_ns;
=20
 	msq =3D msg_lock_check(ns, msqid);
 	if (IS_ERR(msq)) {

]
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc ipc/msg.c
index d0c6d96,4eaf3fd..0000000
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@@ -826,13 -818,12 +826,11 @@@ long do_msgrcv(int msqid, void __user *
  	int mode;
  	struct ipc_namespace *ns;
  	struct msg_msg *copy =3D NULL;
 -	unsigned long copy_number =3D 0;
 =20
  	if (msqid < 0 || (long) bufsz < 0)
  		return -EINVAL;
  	if (msgflg & MSG_COPY) {
- 		copy =3D prepare_copy(buf, min_t(size_t, bufsz, ns->msg_ctlmax));
 -		copy =3D prepare_copy(buf, bufsz, msgflg, &msgtyp, &copy_number);
++		copy =3D prepare_copy(buf, bufsz);
  		if (IS_ERR(copy))
  			return PTR_ERR(copy);
  	}

--Signature=_Thu__2_May_2013_16_01_29_+1000_T2nMo7M22knAHL0v
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRggE5AAoJEECxmPOUX5FESDkQAJ9Opr3kCDRfwwnAtwCcanFe
AqSpXTo9x2rhMT0hGPqQvf0Jt3wSjN1g96Rjm8irgBvmQmi00+BRcr0sSIuSKPTu
cTv6VZSaAgV9RpEI6dNiJL4MMMraJXMO9lWyhfjy72Ks5RiS2rEIAP1/VLbfYx+8
llj5vctZ9QC3Br7t51To0mbkpvRdVpDLJn3LTDdO/giWXSJmPzlXvTHnv9P+RxsR
Jf23EqeWxSfDRMsGxjO+yMP8NhDojv4gaEIhLqfq2ihTIb9wobKxFicr074skjnr
nrBzrtdug2FEqkDlo5JCt956mci4abs/fT8hd2JHP/yIcE5Wei12RY9sAUZljFZd
D84i8nYS8bjkgBCQMDQEtNHESggqsIolHnKYxjyd5jhYtpC0KYGyrLUGh51bhpMT
iUgcPkSmJ7m7HLI1uB+C8mR6IdQKJms6FXReiq937gHrNOYxvrdGsoPvk4cfEAJ5
Zdkt34f1WMMUlLiQBuIm/s2PQH5w8rGrCbUqCLxDUOCrn47Fc9Nm/TOCiQKeh5bG
3fxirMWMPug8b1fDckC2MaIpYqnZhMkM9C4oGBPxx5Cumpsibpm9sT3T3hRyczRv
cAdCdyifziFdGLdaULVrmw4uwsonPX9ILFP2Rl2H9yBjLs2NGTD7Nd+4K5DcpZLa
6+w3gMHjZ03sWuiMui1S
=XIEL
-----END PGP SIGNATURE-----

--Signature=_Thu__2_May_2013_16_01_29_+1000_T2nMo7M22knAHL0v--
