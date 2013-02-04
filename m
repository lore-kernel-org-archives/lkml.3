Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752446Ab3BDHAk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 02:00:40 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:55407 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699Ab3BDHAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 02:00:39 -0500
Date: Mon, 4 Feb 2013 18:00:26 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Subject: linux-next: manual merge of the akpm tree with the tip tree
Message-Id: <20130204180026.c878e03aae769eac187944b3@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__4_Feb_2013_18_00_26_+1100_EtH=YFol4i_aFzK."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__4_Feb_2013_18_00_26_+1100_EtH=YFol4i_aFzK.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
arch/x86/mm/numa.c between commit 07f4207a305c ("x86-32, mm: Remove
reference to alloc_remap()") from the tip tree and commit "x86: get
pg_data_t's memory from other node" from the akpm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/x86/mm/numa.c
index a8483df,245a4ba..0000000
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@@ -209,22 -213,27 +209,21 @@@ static void __init setup_node_data(int=20
  	       nid, start, end - 1);
 =20
  	/*
 -	 * Allocate node data.  Try remap allocator first, node-local
 -	 * memory and then any node.  Never allocate in DMA zone.
 +	 * Allocate node data.  Try node-local memory and then any node.
 +	 * Never allocate in DMA zone.
  	 */
- 	nd_pa =3D memblock_alloc_nid(nd_size, SMP_CACHE_BYTES, nid);
 -	nd =3D alloc_remap(nid, nd_size);
 -	if (nd) {
 -		nd_pa =3D __phys_addr_nodebug(nd);
 -		remapped =3D true;
 -	} else {
 -		nd_pa =3D memblock_alloc_try_nid(nd_size, SMP_CACHE_BYTES, nid);
 -		if (!nd_pa) {
 -			pr_err("Cannot find %zu bytes in any node\n", nd_size);
 -			return;
 -		}
 -		nd =3D __va(nd_pa);
++	nd_pa =3D memblock_alloc_try_nid(nd_size, SMP_CACHE_BYTES, nid);
 +	if (!nd_pa) {
- 		pr_err("Cannot find %zu bytes in node %d\n",
- 		       nd_size, nid);
++		pr_err("Cannot find %zu bytes in any node\n", nd_size);
 +		return;
  	}
 +	nd =3D __va(nd_pa);
 =20
  	/* report and initialize */
 -	printk(KERN_INFO "  NODE_DATA [mem %#010Lx-%#010Lx]%s\n",
 -	       nd_pa, nd_pa + nd_size - 1, remapped ? " (remapped)" : "");
 +	printk(KERN_INFO "  NODE_DATA [mem %#010Lx-%#010Lx]\n",
 +	       nd_pa, nd_pa + nd_size - 1);
  	tnid =3D early_pfn_to_nid(nd_pa >> PAGE_SHIFT);
 -	if (!remapped && tnid !=3D nid)
 +	if (tnid !=3D nid)
  		printk(KERN_INFO "    NODE_DATA(%d) on node %d\n", nid, tnid);
 =20
  	node_data[nid] =3D nd;

--Signature=_Mon__4_Feb_2013_18_00_26_+1100_EtH=YFol4i_aFzK.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRD1yKAAoJEECxmPOUX5FEgh8P/RytA+/Ru4UYvKfigxihyn8h
GBpuElGscS8JRMLYPNZ8CSh2shiGqnV0dmENrMIQfxZV5Zx9OOw9JGpyOOhGS717
Ny88q5RfDD7DfvSZu/ATRrb1ZtptGvKVPlX1OiN6lwkeWne6awEYjqnSyI9DrDjV
VUXHb9HikYJWE9I430unSxcWcuGs9AtPSKK9Ez91s5SA3WrueNUaw3+eyUyLL8U5
t/bPlmimcjQwNbtsCyf84NyD1DXoR9uSOnKh5flIJQ9T86dKQ0/cs9v55DinmSc7
hhUkq6vjJ1QCggJLIeRWG3WcYgI8+VoL0IzDE6kXqqaiFt3OERAJzizoO0ThQCOl
KdBX+yq50+uqCoRLU1ZRTlbw5gHvNp8xYXbHiykjO0jSiqRW8ghb+FUCC6FXzr4t
UQNwWfVGZMTMfmAHkNjKPl/NsqGWddSgy3Ao1nanKwIqUY53mo7dIT8qKwHwgs0a
89V2Mr4JWWQjM5KeBWuClE8fPVd87VwhfKgWlrRmdLxd5uWqYj4qf8KQClBRW572
YGBgq8GuaQMpd2YenJ4ZxQ28AA6pqRUvDWTZ2J5KgfATf+Re/vRIzCiv0gT2FVeO
7V2WWeNLD1rSihR5ds8E9cwRgZJ8VAIuu38/1lookElCnVRZcSQX3mGWscq/XUE0
a6zRrk+qey6cfyAR5723
=QpRF
-----END PGP SIGNATURE-----

--Signature=_Mon__4_Feb_2013_18_00_26_+1100_EtH=YFol4i_aFzK.--
