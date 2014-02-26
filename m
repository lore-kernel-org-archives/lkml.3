Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751245AbaBZHnx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 02:43:53 -0500
Received: from ozlabs.org ([203.10.76.45]:37566 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750745AbaBZHnv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 02:43:51 -0500
Date: Wed, 26 Feb 2014 18:43:46 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Hocko <mhocko@suse.cz>,
        Vladimir Davydov <vdavydov@parallels.com>
Subject: linux-next: manual merge of the akpm-current tree with the cgroup
 tree
Message-Id: <20140226184346.d459564165b30a9f1f42807d@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__26_Feb_2014_18_43_46_+1100_8jEItOkr5zfVqnAW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__26_Feb_2014_18_43_46_+1100_8jEItOkr5zfVqnAW
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm-current tree got a conflict in
mm/memcontrol.c between commits e61734c55c24 ("cgroup: remove
cgroup->name") from the cgroup tree and commits a89db06ab1b4 ("memcg:
change oom_info_lock to mutex") and c78e84121972 ("memcg, slab: cleanup
memcg cache creation") from the akpm-current tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc mm/memcontrol.c
index d9c6ac1532e6,452f45087566..000000000000
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@@ -1683,25 -1683,54 +1683,25 @@@ static void move_unlock_mem_cgroup(stru
   */
  void mem_cgroup_print_oom_info(struct mem_cgroup *memcg, struct task_stru=
ct *p)
  {
 -	/*
 -	 * protects memcg_name and makes sure that parallel ooms do not
 -	 * interleave
 -	 */
 +	/* oom_info_lock ensures that parallel ooms do not interleave */
- 	static DEFINE_SPINLOCK(oom_info_lock);
+ 	static DEFINE_MUTEX(oom_info_lock);
 -	struct cgroup *task_cgrp;
 -	struct cgroup *mem_cgrp;
 -	static char memcg_name[PATH_MAX];
 -	int ret;
  	struct mem_cgroup *iter;
  	unsigned int i;
 =20
  	if (!p)
  		return;
 =20
- 	spin_lock(&oom_info_lock);
+ 	mutex_lock(&oom_info_lock);
  	rcu_read_lock();
 =20
 -	mem_cgrp =3D memcg->css.cgroup;
 -	task_cgrp =3D task_cgroup(p, mem_cgroup_subsys_id);
 +	pr_info("Task in ");
 +	pr_cont_cgroup_path(task_cgroup(p, memory_cgrp_id));
 +	pr_info(" killed as a result of limit of ");
 +	pr_cont_cgroup_path(memcg->css.cgroup);
 +	pr_info("\n");
 =20
 -	ret =3D cgroup_path(task_cgrp, memcg_name, PATH_MAX);
 -	if (ret < 0) {
 -		/*
 -		 * Unfortunately, we are unable to convert to a useful name
 -		 * But we'll still print out the usage information
 -		 */
 -		rcu_read_unlock();
 -		goto done;
 -	}
  	rcu_read_unlock();
 =20
 -	pr_info("Task in %s killed", memcg_name);
 -
 -	rcu_read_lock();
 -	ret =3D cgroup_path(mem_cgrp, memcg_name, PATH_MAX);
 -	if (ret < 0) {
 -		rcu_read_unlock();
 -		goto done;
 -	}
 -	rcu_read_unlock();
 -
 -	/*
 -	 * Continues from above, so we don't need an KERN_ level
 -	 */
 -	pr_cont(" as a result of limit of %s\n", memcg_name);
 -done:
 -
  	pr_info("memory: usage %llukB, limit %llukB, failcnt %llu\n",
  		res_counter_read_u64(&memcg->res, RES_USAGE) >> 10,
  		res_counter_read_u64(&memcg->res, RES_LIMIT) >> 10,

--Signature=_Wed__26_Feb_2014_18_43_46_+1100_8jEItOkr5zfVqnAW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTDZs2AAoJEMDTa8Ir7ZwV++UP/Az8172jyQkEQsOJ5brZWTnq
98EhHaGbGdihrn/vHiyj8azr5aZ6DL7Xr634hwLJggC+RgDS/u1bTIlTF6Q58Cix
r0oXFzKAlL4DQxRBAyOa1WGHgwEnKn5VpiIWAXQcUjvRpjoo8SA+q2Aj6H749xPY
pdNi7CotbyGhWxqHSBynthp6PgYcARJqvHJWoT39iTi2nyRmnjZ1YUsFFRc02p+y
9vg6wLD02CaIg4VCGMyRU39GCj/fqASkqaktdrJJyeUU2qz5waVuDBSEdbuTR/kq
ksUaI9HrsFMi7j4kMnvUDgm19XQSVw0v0msYpyspJHQrjrsIk8g5fCpxOPAM+hhA
BgGDrDpjy3v2IeItzUxAnIPi/10Qm6zY01rOgIa5I0/tRhjsB+Rvt7UTOtpg/qgR
jcFP3Rj4amtFP97gOcMmH3brfciOG8CQf66wArphP86pX5yHxwzKVhfIySdKLbce
UwxGiioWOuhoM5+2kRoQSgBICaBXcVzMSL6Ccr9yk9ovMthzF2e3fPKaqzWN/4r0
nUG/LXr8NulHIReJwUqctAqXDk46qTA7qnt9pVCxFmg3ONVgccQzXAKkNO7rrEbL
r4hDlJZuvknyI0M5GmRrTlpOayrIZ1j5oFcVi04CS7EOkqFUhg/ymOUf1qHVhqys
Ik5wjBddYCHxGR9ciVK9
=pd3L
-----END PGP SIGNATURE-----

--Signature=_Wed__26_Feb_2014_18_43_46_+1100_8jEItOkr5zfVqnAW--
