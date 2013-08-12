Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520Ab3HLGHe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 02:07:34 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:58831 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794Ab3HLGHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 02:07:31 -0400
Date: Mon, 12 Aug 2013 16:07:22 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Li Zefan <lizefan@huawei.com>
Subject: linux-next: manual merge of the akpm-current tree with the cgroup
 tree
Message-Id: <20130812160722.a63da2bca4ac14044bb0abea@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__12_Aug_2013_16_07_22_+1000_/9Tyn5AhDGFPI9.V"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__12_Aug_2013_16_07_22_+1000_/9Tyn5AhDGFPI9.V
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm-current tree got a conflict in
mm/memcontrol.c between commits from the cgroup tree and commits from the
akpm-current tree.

I fixed it up (using Michal's email as a guide - see below) and can carry
the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc mm/memcontrol.c
index 57f6d67,6f292b8..0000000
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@@ -1075,13 -966,30 +959,13 @@@ mem_cgroup_filter(struct mem_cgroup *me
   * helper function to be used by mem_cgroup_iter
   */
  static struct mem_cgroup *__mem_cgroup_iter_next(struct mem_cgroup *root,
- 		struct mem_cgroup *last_visited)
+ 		struct mem_cgroup *last_visited, mem_cgroup_iter_filter cond)
  {
 -	struct cgroup *prev_cgroup, *next_cgroup;
 -
 -	/*
 -	 * Root is not visited by cgroup iterators so it needs an
 -	 * explicit visit.
 -	 */
 -	if (!last_visited) {
 -		switch (mem_cgroup_filter(root, root, cond)) {
 -		case VISIT:
 -			return root;
 -		case SKIP:
 -			break;
 -		case SKIP_TREE:
 -			return NULL;
 -		}
 -	}
 +	struct cgroup_subsys_state *prev_css, *next_css;
 =20
 -	prev_cgroup =3D (last_visited =3D=3D root || !last_visited) ? NULL
 -		: last_visited->css.cgroup;
 +	prev_css =3D last_visited ? &last_visited->css : NULL;
  skip_node:
 -	next_cgroup =3D cgroup_next_descendant_pre(
 -			prev_cgroup, root->css.cgroup);
 +	next_css =3D css_next_descendant_pre(prev_css, &root->css);
 =20
  	/*
  	 * Even if we found a group we have to make sure it is
@@@ -1090,14 -998,33 +974,34 @@@
  	 * last_visited css is safe to use because it is
  	 * protected by css_get and the tree walk is rcu safe.
  	 */
 -	if (next_cgroup) {
 -		struct mem_cgroup *mem =3D mem_cgroup_from_cont(
 -				next_cgroup);
 +	if (next_css) {
 +		struct mem_cgroup *mem =3D mem_cgroup_from_css(next_css);
 =20
- 		if (css_tryget(&mem->css))
- 			return mem;
- 		else {
- 			prev_css =3D next_css;
+ 		switch (mem_cgroup_filter(mem, root, cond)) {
+ 		case SKIP:
+ 			prev_cgroup =3D next_cgroup;
  			goto skip_node;
+ 		case SKIP_TREE:
++			if (mem =3D=3D root)
++				return NULL;
+ 			/*
+ 			 * cgroup_rightmost_descendant is not an optimal way to
+ 			 * skip through a subtree (especially for imbalanced
+ 			 * trees leaning to right) but that's what we have right
+ 			 * now. More effective solution would be traversing
+ 			 * right-up for first non-NULL without calling
+ 			 * cgroup_next_descendant_pre afterwards.
+ 			 */
 -			prev_cgroup =3D cgroup_rightmost_descendant(next_cgroup);
++			prev_css =3D css_rightmost_descendant(next_css);
+ 			goto skip_node;
+ 		case VISIT:
+ 			if (css_tryget(&mem->css))
+ 				return mem;
+ 			else {
+ 				prev_cgroup =3D next_cgroup;
+ 				goto skip_node;
+ 			}
+ 			break;
  		}
  	}
 =20
@@@ -4983,11 -4841,9 +4815,10 @@@ static int mem_cgroup_force_empty(struc
  	return 0;
  }
 =20
 -static int mem_cgroup_force_empty_write(struct cgroup *cont, unsigned int=
 event)
 +static int mem_cgroup_force_empty_write(struct cgroup_subsys_state *css,
 +					unsigned int event)
  {
 -	struct mem_cgroup *memcg =3D mem_cgroup_from_cont(cont);
 +	struct mem_cgroup *memcg =3D mem_cgroup_from_css(css);
- 	int ret;
 =20
  	if (mem_cgroup_is_root(memcg))
  		return -EINVAL;
@@@ -5136,8 -4991,8 +4963,8 @@@ static int memcg_update_kmem_limit(stru
  	 */
  	mutex_lock(&memcg_create_mutex);
  	mutex_lock(&set_limit_mutex);
- 	if (!memcg->kmem_account_flags && val !=3D RESOURCE_MAX) {
+ 	if (!memcg->kmem_account_flags && val !=3D RES_COUNTER_MAX) {
 -		if (cgroup_task_count(cont) || memcg_has_children(memcg)) {
 +		if (cgroup_task_count(css->cgroup) || memcg_has_children(memcg)) {
  			ret =3D -EBUSY;
  			goto out;
  		}
@@@ -6174,31 -6035,8 +5998,8 @@@ struct mem_cgroup *parent_mem_cgroup(st
  }
  EXPORT_SYMBOL(parent_mem_cgroup);
 =20
- static void __init mem_cgroup_soft_limit_tree_init(void)
- {
- 	struct mem_cgroup_tree_per_node *rtpn;
- 	struct mem_cgroup_tree_per_zone *rtpz;
- 	int tmp, node, zone;
-=20
- 	for_each_node(node) {
- 		tmp =3D node;
- 		if (!node_state(node, N_NORMAL_MEMORY))
- 			tmp =3D -1;
- 		rtpn =3D kzalloc_node(sizeof(*rtpn), GFP_KERNEL, tmp);
- 		BUG_ON(!rtpn);
-=20
- 		soft_limit_tree.rb_tree_per_node[node] =3D rtpn;
-=20
- 		for (zone =3D 0; zone < MAX_NR_ZONES; zone++) {
- 			rtpz =3D &rtpn->rb_tree_per_zone[zone];
- 			rtpz->rb_root =3D RB_ROOT;
- 			spin_lock_init(&rtpz->lock);
- 		}
- 	}
- }
-=20
  static struct cgroup_subsys_state * __ref
 -mem_cgroup_css_alloc(struct cgroup *cont)
 +mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
  {
  	struct mem_cgroup *memcg;
  	long error =3D -ENOMEM;
@@@ -6295,14 -6135,21 +6097,23 @@@ static void mem_cgroup_invalidate_recla
  		mem_cgroup_iter_invalidate(root_mem_cgroup);
  }
 =20
 -static void mem_cgroup_css_offline(struct cgroup *cont)
 +static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
  {
 -	struct mem_cgroup *memcg =3D mem_cgroup_from_cont(cont);
 +	struct mem_cgroup *memcg =3D mem_cgroup_from_css(css);
 +
 +	kmem_cgroup_css_offline(memcg);
 =20
+ 	kmem_cgroup_css_offline(memcg);
+=20
  	mem_cgroup_invalidate_reclaim_iterators(memcg);
  	mem_cgroup_reparent_charges(memcg);
+ 	if (memcg->soft_contributed) {
+ 		while ((memcg =3D parent_mem_cgroup(memcg)))
+ 			atomic_dec(&memcg->children_in_excess);
+=20
+ 		if (memcg !=3D root_mem_cgroup && !root_mem_cgroup->use_hierarchy)
+ 			atomic_dec(&root_mem_cgroup->children_in_excess);
+ 	}
  	mem_cgroup_destroy_all_caches(memcg);
  	vmpressure_cleanup(&memcg->vmpressure);
  }

--Signature=_Mon__12_Aug_2013_16_07_22_+1000_/9Tyn5AhDGFPI9.V
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSCHueAAoJEECxmPOUX5FEOhUP+wfTSohWHL1BFxsi2mU2QELV
d6eGTi9VeWnv+atRnOS4/SaNk3aWjUlinwR8H4r0yHUq4hf5AcJkq0+7Aw0M5tS9
dFTXsv+y+2A2V+K0DVeqnp8dfS3RPUWj7Mef42cqBn31h7qvnWU0Fdf2ebslQuxi
vdzpxjMCpPDOtM16sRtFHvul9B/9Clj5UBOm7zGiTrasW83wDo/G7wtGscDumkG1
sMwuTH77laGZSloUvb7uEdSFzwCjbQxgTPpoLWu5hXuYXwkgOtIeMmAltxGi4G6Q
CwGvVsQHhvm1bGqcOqUi/8UVZQDB0lFuWOR0Q5vWvNLnGbfkpBDkbb/4WqnjZSQ2
Hyst/hHprOE7EDhSaBVb7HUnyYWwULX6kHupi4q7340tfKcNX/OmfWgcjqoydrOJ
Y3NtQ7OlZP9cPkWu7XpJRfbfdnixcyynCa5py57RVguaOldP5qVHaS0sMqJFRLrZ
jow3Hzh2KkTZ+O+z4Qw+AXyAtTuHdF+1V9hh/EgasD+oMEOSK/tj1uII8GMRQHrY
M5/Kb7BXB5glQH29Ifxh6GtK1h40a+xV4wtQQUjhjmmtVToNNbeq0tRUjM57IM67
4cJOlPeC4LPq39egHrj9LXBKNUqP2/iVDMjSS09463qY9P+LjGQwzK7Rb4T5Tztx
mVlWMrqGqxfutzHOrtV5
=XTdO
-----END PGP SIGNATURE-----

--Signature=_Mon__12_Aug_2013_16_07_22_+1000_/9Tyn5AhDGFPI9.V--
