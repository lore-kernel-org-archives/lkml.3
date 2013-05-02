Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758769Ab3EBCAw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 22:00:52 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:32897 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757673Ab3EBCAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 22:00:48 -0400
Date: Thu, 2 May 2013 12:00:44 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next: manual merge of the vfs tree with Linus' tree
Message-Id: <20130502120044.5235b60d09708a3b8e64f3e9@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__2_May_2013_12_00_44_+1000_ON1m9zqfzJGhTrUq"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__2_May_2013_12_00_44_+1000_ON1m9zqfzJGhTrUq
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

Today's linux-next merge of the vfs tree got a conflict in fs/coredump.c
between commit acdedd99b0f3 ("coredump: sanitize the setting of
signal->group_exit_code") from Linus' tree and commit 03d95eb2f257 ("lift
sb_start_write() out of ->write()") from the vfs tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/coredump.c
index ec306cc,a987f3d..0000000
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@@ -419,22 -407,9 +419,20 @@@ static void coredump_finish(struct mm_s
  	mm->core_state =3D NULL;
  }
 =20
 +static bool dump_interrupted(void)
 +{
 +	/*
 +	 * SIGKILL or freezing() interrupt the coredumping. Perhaps we
 +	 * can do try_to_freeze() and check __fatal_signal_pending(),
 +	 * but then we need to teach dump_write() to restart and clear
 +	 * TIF_SIGPENDING.
 +	 */
 +	return signal_pending(current);
 +}
 +
  static void wait_for_dump_helpers(struct file *file)
  {
- 	struct pipe_inode_info *pipe;
-=20
- 	pipe =3D file_inode(file)->i_pipe;
+ 	struct pipe_inode_info *pipe =3D file->private_data;
 =20
  	pipe_lock(pipe);
  	pipe->readers++;
@@@ -656,7 -627,11 +654,9 @@@ void do_coredump(siginfo_t *siginfo
  		goto close_fail;
  	if (displaced)
  		put_files_struct(displaced);
+ 	file_start_write(cprm.file);
 -	retval =3D binfmt->core_dump(&cprm);
 -	if (retval)
 -		current->signal->group_exit_code |=3D 0x80;
 +	core_dumped =3D !dump_interrupted() && binfmt->core_dump(&cprm);
+ 	file_end_write(cprm.file);
 =20
  	if (ispipe && core_pipe_limit)
  		wait_for_dump_helpers(cprm.file);

--Signature=_Thu__2_May_2013_12_00_44_+1000_ON1m9zqfzJGhTrUq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRgcjMAAoJEECxmPOUX5FE1xUP/2bzjrPSd8wRkwReBcB9LN2G
xdpLQtQGqYIH/I7K3NDP8Ga0Fp2Iuf1N66jdZVegqKUc2t92DtSTyNhIiEXQSGaH
kKGLwhECkbVAaexFzJGE6U4FBBInl/bO2KviXC5R7aKgG58GWEsof020AEDFydU3
hHqhw++CgYEuMdOTclxQojf9EzP6U6fP87M19otR+XnmWzoIX0wRJmDqHAnEOA7j
fq8HONc0fTPcNbEib+3Bj/6XFz6+P4MWpgQRNTofqqXBy9tD+1gILM9Urj2nXN3u
ZQqR5dXIItq/9/MTTrlTCRzR0awCIbFSFPaiUzB0JgF+6v/HukgK+bb3Q5Ho+Szo
ZJI4v/VjTq7Xk0v3eeGzCA/FB3GD18XV4jSb/dMo28bgEds0/zIzk6XUTYozjlA6
M2VDMfjOQHCX2BHqEuRq6YSRyBe6QuTMKH6yjdWbCw1TJcnV+/4nKbC1yOj+ue9L
pq6feU6R8RmXeztoN5OoB13GwG26yjr+nUfZrFdtwzDGwlM7GUnEaE2UUeSLQnOt
s9Q86l8mOfagF75/dTatAC4L/i8BMBV/OtS4aY2pOm53XOwmEDpI3JjWRxwEL5kd
9MY3dZzGvXEHoVi3d27SjOnclJeQ+Fy4L0Cnqb178nOgBKaUFUi5S1kX4kIX8lTP
KxyjAyrCFkCkvYEYRXHT
=zOG7
-----END PGP SIGNATURE-----

--Signature=_Thu__2_May_2013_12_00_44_+1000_ON1m9zqfzJGhTrUq--
