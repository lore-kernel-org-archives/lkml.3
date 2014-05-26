Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751615AbaEZHpc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 03:45:32 -0400
Received: from ozlabs.org ([103.22.144.67]:49422 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751231AbaEZHpb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 03:45:31 -0400
Date: Mon, 26 May 2014 17:45:22 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Hocko <mhocko@suse.cz>
Subject: linux-next: manual merge of the cgroup tree with Linus' tree
Message-ID: <20140526174522.391b5f31@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/jUdNaDOeRqJFmZ.Yocm71Hh"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/jUdNaDOeRqJFmZ.Yocm71Hh
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Tejun,

Today's linux-next merge of the cgroup tree got a conflict in
mm/memcontrol.c between commit 6f6acb00514c ("memcg: fix swapcache
charge from kernel thread context") from Linus' tree and commit
ec903c0c858e ("cgroup: rename css_tryget*() to css_tryget_online*()")
from the cgroup tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc mm/memcontrol.c
index 5177c6d4a2dd,b6f91d61b3af..000000000000
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@@ -1077,19 -1074,10 +1074,19 @@@ static struct mem_cgroup *get_mem_cgrou
 =20
  	rcu_read_lock();
  	do {
 -		memcg =3D mem_cgroup_from_task(rcu_dereference(mm->owner));
 -		if (unlikely(!memcg))
 +		/*
 +		 * Page cache insertions can happen withou an
 +		 * actual mm context, e.g. during disk probing
 +		 * on boot, loopback IO, acct() writes etc.
 +		 */
 +		if (unlikely(!mm))
  			memcg =3D root_mem_cgroup;
 +		else {
 +			memcg =3D mem_cgroup_from_task(rcu_dereference(mm->owner));
 +			if (unlikely(!memcg))
 +				memcg =3D root_mem_cgroup;
 +		}
- 	} while (!css_tryget(&memcg->css));
+ 	} while (!css_tryget_online(&memcg->css));
  	rcu_read_unlock();
  	return memcg;
  }

--Sig_/jUdNaDOeRqJFmZ.Yocm71Hh
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTgvEYAAoJEMDTa8Ir7ZwVc9EP/1DrxrZ9bI8SRI8IbN1VxNm8
tSc59dl1QRemdQksz8+GnjThNz8I9N8JxvEb/7wweLFwtRw5101+ToCbckzeHiJn
0llcPn8ZWPp2nbvMFM5ceO4vhsu1+ffxrZUByY+UHwLgNXwnjBIo3kDgRGn0EQ5j
dqTYFECPEVumn1Dj0FUVMHGU0IL/K0DZRH8GhDk93/3YCS8TAL23jUgYCfO3C2GD
CDjpeqVHsgnbop3Zu7/hSQYNNZb6+9orgMNX96YVwJFTeX14Cl5gneSdcQgFNE1G
F7tzsE0n6w6Mf+NQiTju123i2vQevYQwVGHEYfLVag0RDSXJy+tm11w0KUtli1gd
MM0Fn9ybCStIWgE7jmUpujfeBTeTzyAkP1hd7xfo297Jh7Oe7Ix0WDm0OCOuJKcT
4YoREfFHlSk4BdnnSFjMhGEU/BlWG6RsJB+dcep2UPfnbx8BHMY/aCEZv2sQDM7p
GKiAy90Nczv3AvBbTKpPLlxODkyTUl7tv47hhPPmNfxuTwuCDjnaGqR30CCo0Wux
bpKzIhez6OwdZV+7H7WxYIQpfQ02ADE2S8tcYyoti2NCl+/zFLdFfb0LTvOIz6eA
uU4meQERKSKccA/jCJfmM7jI/uIlyAFxVsxiE8V7pR+2LF8jSWoRGtd+yd6Sr3rN
Cm/bWHYao8+lSutW+Knc
=vkXu
-----END PGP SIGNATURE-----

--Sig_/jUdNaDOeRqJFmZ.Yocm71Hh--
