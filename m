Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014AbaENHWw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 03:22:52 -0400
Received: from ozlabs.org ([103.22.144.67]:60192 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751393AbaENHWs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 03:22:48 -0400
Date: Wed, 14 May 2014 17:22:40 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Hocko <mhocko@suse.cz>
Subject: linux-next: manual merge of the akpm-current tree with the cgroup
 tree
Message-ID: <20140514172240.3d3eeba5@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/aPgpNTq9Whf7_ygMZF7=E6v"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/aPgpNTq9Whf7_ygMZF7=E6v
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm-current tree got a conflict in
mm/memcontrol.c between commit 6770c64e5c8d ("cgroup: replace
cftype->trigger() with cftype->write()") from the cgroup tree and
commits 15aa061d2994 ("memcg: deprecate memory.force_empty knob") and
2423e4fd8967 ("memcg-deprecate-memoryforce_empty-knob-fix") from the
akpm-current tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc mm/memcontrol.c
index 66447745d0c0,2cb81478d30c..000000000000
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@@ -833,9 -829,9 +826,9 @@@ retry
  	 * we will to add it back at the end of reclaim to its correct
  	 * position in the tree.
  	 */
- 	__mem_cgroup_remove_exceeded(mz->memcg, mz, mctz);
+ 	__mem_cgroup_remove_exceeded(mz, mctz);
  	if (!res_counter_soft_limit_excess(&mz->memcg->res) ||
 -		!css_tryget(&mz->memcg->css))
 +	    !css_tryget_online(&mz->memcg->css))
  		goto retry;
  done:
  	return mz;
@@@ -4895,7 -4795,11 +4794,11 @@@ static ssize_t mem_cgroup_force_empty_w
 =20
  	if (mem_cgroup_is_root(memcg))
  		return -EINVAL;
+ 	pr_info_once("%s (%d): memory.force_empty is deprecated and will be "
+ 		     "removed.  Let us know if it is needed in your usecase at "
+ 		     "linux-mm@kvack.org\n",
+ 		     current->comm, task_pid_nr(current));
 -	return mem_cgroup_force_empty(memcg);
 +	return mem_cgroup_force_empty(memcg) ?: nbytes;
  }
 =20
  static u64 mem_cgroup_hierarchy_read(struct cgroup_subsys_state *css,
@@@ -5176,8 -5080,26 +5080,26 @@@ static ssize_t mem_cgroup_write(struct=20
  		else
  			return -EINVAL;
  		break;
+ 	case RES_LOW_LIMIT:
+ 		if (mem_cgroup_is_root(memcg)) { /* Can't set limit on root */
+ 			ret =3D -EINVAL;
+ 			break;
+ 		}
+ 		ret =3D res_counter_memparse_write_strategy(buffer, &val);
+ 		if (ret)
+ 			break;
+ 		if (type =3D=3D _MEM) {
+ 			ret =3D res_counter_set_low_limit(&memcg->res, val);
+ 			break;
+ 		}
+ 		/*
+ 		 * memsw low limit doesn't make any sense and kmem is not
+ 		 * implemented yet - if ever
+ 		 */
+ 		return -EINVAL;
+=20
  	case RES_SOFT_LIMIT:
 -		ret =3D res_counter_memparse_write_strategy(buffer, &val);
 +		ret =3D res_counter_memparse_write_strategy(buf, &val);
  		if (ret)
  			break;
  		/*
@@@ -6117,9 -6020,15 +6024,15 @@@ static struct cftype mem_cgroup_files[
  		.read_u64 =3D mem_cgroup_read_u64,
  	},
  	{
+ 		.name =3D "low_limit_in_bytes",
+ 		.private =3D MEMFILE_PRIVATE(_MEM, RES_LOW_LIMIT),
+ 		.write_string =3D mem_cgroup_write,
+ 		.read_u64 =3D mem_cgroup_read_u64,
+ 	},
+ 	{
  		.name =3D "soft_limit_in_bytes",
  		.private =3D MEMFILE_PRIVATE(_MEM, RES_SOFT_LIMIT),
 -		.write_string =3D mem_cgroup_write,
 +		.write =3D mem_cgroup_write,
  		.read_u64 =3D mem_cgroup_read_u64,
  	},
  	{
@@@ -6134,7 -6043,8 +6047,8 @@@
  	},
  	{
  		.name =3D "force_empty",
+ 		.flags =3D CFTYPE_INSANE,
 -		.trigger =3D mem_cgroup_force_empty_write,
 +		.write =3D mem_cgroup_force_empty_write,
  	},
  	{
  		.name =3D "use_hierarchy",

--Sig_/aPgpNTq9Whf7_ygMZF7=E6v
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTcxnFAAoJEMDTa8Ir7ZwVcFYQAJVYcu79QpjptwtX/QtBsGsY
LxSHLk9bADHSft86eO/PAcCHjLHLKqidzoZDeHs56vTu0GA+NHEOdFeS2BNDVX9u
OHJGKa/PzPNXGhW/evcjFPGz2ndBGrI5XD/WVTJBZwxJv7jVzOZJJGI/DBYmovVR
/rifhhBkvDy6InXLnanaR3kD5CbvAtBn1oEl1hTGJhSGVYl08KqJo887iyVWs7bH
WvtiXvICLWBlaxF3wn8gbh1jfIPY8t9ioXAefm5iEGhzKro3/iDjKa6TJYO5oY3I
ypDbz5vgrXOeXX6+krLJUjCj1N9/+lmDrLNb7OrV16b2CqhsYAr+dpYDw/l1b6Cf
tst58VbqUq7AhuQcsnUYU9Ua3Mk2DmklRMpv28ZbOmdi0Xtw5MAuys7pNAGpSR8e
CRnopxtWyoRjMJPQ3pHvBNQVTA7W+MyOGe303b7uHnHg5D0NrASyX+nzO+1lIWvi
YdzSbhostHhTwWiTJD7Fk54IM39Zf/HhPGd/LnBNVDHZr+75NXXx+DlGYIvlboZS
2Z55X1uD9ECQDvbzVJXTrt+5N93TSlbJG2/ZSN8rST7f2lmA+t+01YSFQbPld+nf
/m/koiTvaGjs7Ypl+FjM/EWFMY8KMpLTGlnpWZd9rSyzqCe71QDsLWJITrNKm5iy
MzWixuMgs/C2PBC+tYDo
=hE69
-----END PGP SIGNATURE-----

--Sig_/aPgpNTq9Whf7_ygMZF7=E6v--
