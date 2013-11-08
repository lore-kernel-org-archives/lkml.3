Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708Ab3KHHgN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 02:36:13 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:57669 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819Ab3KHHgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 02:36:07 -0500
Date: Fri, 8 Nov 2013 18:35:52 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sukadev Bhattiprolu <sukadev@us.ibm.com>,
        Miklos Szeredi <mszeredi@suse.cz>
Subject: linux-next: manual merge of the akpm-current tree with the vfs tree
Message-Id: <20131108183552.dbe7c66fa6dee7f84bf73b44@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__8_Nov_2013_18_35_52_+1100_ui8wPWY2hB2n2/Wp"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__8_Nov_2013_18_35_52_+1100_ui8wPWY2hB2n2/Wp
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm-current tree got a conflict in
fs/autofs4/inode.c between commit baa40671d3e3 ("autofs4: make freeing
sbi rcu-delayed") from the vfs tree and commit e4af471815fc ("autofs4:
allow autofs to work outside the initial PID namespace") from the
akpm-current tree.

I fixed it up (I think - see below) and can carry the fix as necessary
(no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/autofs4/inode.c
index 3b9cc9b973c2,1b045ecfcea2..000000000000
--- a/fs/autofs4/inode.c
+++ b/fs/autofs4/inode.c
@@@ -56,13 -56,20 +56,15 @@@ void autofs4_kill_sb(struct super_bloc
  	 * just call kill_anon_super when we are called from
  	 * deactivate_super.
  	 */
- 	if (sbi) /* Free wait queues, close pipe */
 -	if (!sbi)
 -		goto out_kill_sb;
 -
 -	/* Free wait queues, close pipe */
 -	autofs4_catatonic_mode(sbi);
 -
 -	put_pid(sbi->oz_pgrp);
 -
 -	sb->s_fs_info =3D NULL;
 -	kfree(sbi);
++	if (sbi) { /* Free wait queues, close pipe */
 +		autofs4_catatonic_mode(sbi);
++		put_pid(sbi->oz_pgrp);
++	}
 =20
 -out_kill_sb:
  	DPRINTK("shutting down");
  	kill_litter_super(sb);
 +	if (sbi)
 +		kfree_rcu(sbi, rcu);
  }
 =20
  static int autofs4_show_options(struct seq_file *m, struct dentry *root)

--Signature=_Fri__8_Nov_2013_18_35_52_+1100_ui8wPWY2hB2n2/Wp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSfJRcAAoJEMDTa8Ir7ZwVw5cP/3p39MhpV80EeU/DoGYVGpvL
lmVGMIzxnO7RsHxs/9cvccClJgtqVPYcbwkNg6TYnIgfOk6Y8OFvcYBJjg5TYo9+
AA90FuVu947yZD+qUWgPNHKzfYtQrpyCUh6z4DX/hG1DdVyzLgcd20rH4IEONGZF
jv6vI0rpKmHFn3w1CV8oggyMJ/xHIrQcl4qxc8Wa0/ydNjW9MuGK+1PiO7ELvBCt
ESM94D9dCSP9RuVyuWHV9XcXrK2Nfyv7C1jeIwGULnEICxWBM223fmxA8e0jJMNq
2aQnqT8+nsQ9Q8lg1wPl1S+vqfOUM+D1JvRdfk4AP40nKU7ndB4LZRVdLNC4RVP+
tSgjmbgwFt+Vxc670CjMxjujfX7/ZhIeG9HhUVqIDdvzAVt1Fjd4LZaUnj2EL2+m
QCF/NgCXs7aaR2zHQTXJVmbU/ln0/6KEy0ALkMge8slrUiTrP2U+pznuMQf69UKw
UBk8e7qKrYmAXoLI6Xi+5dRLzsprPHcZ+9K9tewg3S2sPR9yvLYFbIIgRbXHGi9y
I22PXPdY/CmSKoy4w4O9wx3mcp2bNz3BnUuREhuI3PcDeKRvayRDAJUT0DGEGuW5
l3V/R5zftcF7Znb+gOwvl/MM2LvaABduCH3ITTbd6xv3GPgzdt37d8IF4zwctOan
1iBJ26CR8PaNkqy3veAC
=dUG6
-----END PGP SIGNATURE-----

--Signature=_Fri__8_Nov_2013_18_35_52_+1100_ui8wPWY2hB2n2/Wp--
