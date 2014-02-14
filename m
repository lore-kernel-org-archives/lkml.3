Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752337AbaBNEeX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 23:34:23 -0500
Received: from ozlabs.org ([203.10.76.45]:38114 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751323AbaBNEeV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 23:34:21 -0500
Date: Fri, 14 Feb 2014 15:34:14 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Hocko <mhocko@suse.cz>
Subject: linux-next: manual merge of the akpm-current tree with the cgroup
 tree
Message-Id: <20140214153414.b15e54bf5aa61d0e75bacc90@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__14_Feb_2014_15_34_14_+1100_U5A81uSflaRJ.7Of"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__14_Feb_2014_15_34_14_+1100_U5A81uSflaRJ.7Of
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm-current tree got a conflict in
mm/memcontrol.c between commit e61734c55c24 ("cgroup: remove
cgroup->name") from the cgroup tree and commit 05d3a02a1a0d ("memcg:
change oom_info_lock to mutex") from the akpm-current tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc mm/memcontrol.c
index d9c6ac1532e6,de1a2aed4954..000000000000
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
 -
 -	ret =3D cgroup_path(task_cgrp, memcg_name, PATH_MAX);
 -	if (ret < 0) {
 -		/*
 -		 * Unfortunately, we are unable to convert to a useful name
 -		 * But we'll still print out the usage information
 -		 */
 -		rcu_read_unlock();
 -		goto done;
 -	}
 -	rcu_read_unlock();
 -
 -	pr_info("Task in %s killed", memcg_name);
 +	pr_info("Task in ");
 +	pr_cont_cgroup_path(task_cgroup(p, memory_cgrp_id));
 +	pr_info(" killed as a result of limit of ");
 +	pr_cont_cgroup_path(memcg->css.cgroup);
 +	pr_info("\n");
 =20
 -	rcu_read_lock();
 -	ret =3D cgroup_path(mem_cgrp, memcg_name, PATH_MAX);
 -	if (ret < 0) {
 -		rcu_read_unlock();
 -		goto done;
 -	}
  	rcu_read_unlock();
 =20
 -	/*
 -	 * Continues from above, so we don't need an KERN_ level
 -	 */
 -	pr_cont(" as a result of limit of %s\n", memcg_name);
 -done:
 -
  	pr_info("memory: usage %llukB, limit %llukB, failcnt %llu\n",
  		res_counter_read_u64(&memcg->res, RES_USAGE) >> 10,
  		res_counter_read_u64(&memcg->res, RES_LIMIT) >> 10,

--Signature=_Fri__14_Feb_2014_15_34_14_+1100_U5A81uSflaRJ.7Of
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS/ZzLAAoJEMDTa8Ir7ZwVIzIP/iuRClF7TxQ9RhjfxEqzhq1w
VZFOavW/zMC+w0Yfq1T53Jib8eEPlpSlqtZXHXtKPLeTfiuF3iZTj+6ZmJ7+A03r
I7kW6fveSLRYchzgkkYFU++Ebz5gy825jp3aK6wDNk4LHOmbMCNlSjuKOakEHotE
bpY0L5TGgPgTbQYR6TA0kCKH0sDklfttc0b6lm3P6h71Nt7QMjhdmbTZNfDAom7Y
jaYM8Xe/een7xti0SiT3PtcbBc15EB3RHtqDJRW5CHn7Xxj63t8wiBw6NdM5HwSa
420juYyo5ZfWUlG/V6zVx4jE/cga6XgbnPOopJkG4mjI/JD2wHxTk01pR63BTQTw
cH+Gp0KHZppV3x95sf9/JvYmTXEFjkhoepTt0nEgs7YN9k47xlcV1ga1rpIJKD3T
KreSHI5f+CSZ4afBVLpp/Ul/RuF+52qKJpzpBl/IdI45g6DMQNcKXY6t2kh5BSYD
v2goyuhaa8iTEXHeHcgXWS0oQp5knmizq6ai3dKPpN1/PAgKyL+n3ELhQ6rP5koK
k+zyIalNSD1DYpzUS5P00eFjJplLrbnk/+/XH9NuUBzV4Qgw0FI1E58ouSEvv0NT
g47FDBlq5WSTBqQE+pX8rveD0P9g4mkj0heIvFpH5aF7/GcfdSS5Tnj7JsGX6BCY
+7L6xRM1Q15I+U/W/0ru
=An/1
-----END PGP SIGNATURE-----

--Signature=_Fri__14_Feb_2014_15_34_14_+1100_U5A81uSflaRJ.7Of--
