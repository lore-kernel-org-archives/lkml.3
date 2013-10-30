Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751633Ab3J3Gkm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 02:40:42 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:54288 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710Ab3J3Gkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 02:40:40 -0400
Date: Wed, 30 Oct 2013 17:40:25 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: linux-next: manual merge of the akpm-current tree with the tip tree
Message-Id: <20131030174025.0cd5d6ad218a1bea872646c2@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__30_Oct_2013_17_40_25_+1100_0cQK_o3CWLf28l_4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__30_Oct_2013_17_40_25_+1100_0cQK_o3CWLf28l_4
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm-current tree got a conflict in
arch/x86/mm/init.c between commit 6979287a7df6 ("x86/mm: Add 'step_size'
comments to init_mem_mapping()") from the tip tree and commits
6452c268c6d6 ("x86/mm: factor out of top-down direct mapping setup") and
f790250c098a ("x86/mem-hotplug: support initialize page tables in
bottom-up") from the akpm-current tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/x86/mm/init.c
index ce32017c5e38,b6892a71cbfc..000000000000
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@@ -399,28 -399,23 +399,39 @@@ static unsigned long __init init_range_
  	return mapped_ram_size;
  }
 =20
 -/* (PUD_SHIFT-PMD_SHIFT)/2 */
 -#define STEP_SIZE_SHIFT 5
 +static unsigned long __init get_new_step_size(unsigned long step_size)
 +{
 +	/*
 +	 * Explain why we shift by 5 and why we don't have to worry about
 +	 * 'step_size << 5' overflowing:
 +	 *
 +	 * initial mapped size is PMD_SIZE (2M).
 +	 * We can not set step_size to be PUD_SIZE (1G) yet.
 +	 * In worse case, when we cross the 1G boundary, and
 +	 * PG_LEVEL_2M is not set, we will need 1+1+512 pages (2M + 8k)
 +	 * to map 1G range with PTE. Use 5 as shift for now.
 +	 *
 +	 * Don't need to worry about overflow, on 32bit, when step_size
 +	 * is 0, round_down() returns 0 for start, and that turns it
 +	 * into 0x100000000ULL.
 +	 */
 +	return step_size << 5;
 +}
 =20
- void __init init_mem_mapping(void)
+ /**
+  * memory_map_top_down - Map [map_start, map_end) top down
+  * @map_start: start address of the target memory range
+  * @map_end: end address of the target memory range
+  *
+  * This function will setup direct mapping for memory range
+  * [map_start, map_end) in top-down. That said, the page tables
+  * will be allocated at the end of the memory, and we map the
+  * memory in top-down.
+  */
+ static void __init memory_map_top_down(unsigned long map_start,
+ 				       unsigned long map_end)
  {
- 	unsigned long end, real_end, start, last_start;
+ 	unsigned long real_end, start, last_start;
  	unsigned long step_size;
  	unsigned long addr;
  	unsigned long mapped_ram_size =3D 0;
@@@ -470,8 -454,89 +470,89 @@@
  		mapped_ram_size +=3D new_mapped_ram_size;
  	}
 =20
- 	if (real_end < end)
- 		init_range_memory_mapping(real_end, end);
+ 	if (real_end < map_end)
+ 		init_range_memory_mapping(real_end, map_end);
+ }
+=20
+ /**
+  * memory_map_bottom_up - Map [map_start, map_end) bottom up
+  * @map_start: start address of the target memory range
+  * @map_end: end address of the target memory range
+  *
+  * This function will setup direct mapping for memory range
+  * [map_start, map_end) in bottom-up. Since we have limited the
+  * bottom-up allocation above the kernel, the page tables will
+  * be allocated just above the kernel and we map the memory
+  * in [map_start, map_end) in bottom-up.
+  */
+ static void __init memory_map_bottom_up(unsigned long map_start,
+ 					unsigned long map_end)
+ {
+ 	unsigned long next, new_mapped_ram_size, start;
+ 	unsigned long mapped_ram_size =3D 0;
+ 	/* step_size need to be small so pgt_buf from BRK could cover it */
+ 	unsigned long step_size =3D PMD_SIZE;
+=20
+ 	start =3D map_start;
+ 	min_pfn_mapped =3D start >> PAGE_SHIFT;
+=20
+ 	/*
+ 	 * We start from the bottom (@map_start) and go to the top (@map_end).
+ 	 * The memblock_find_in_range() gets us a block of RAM from the
+ 	 * end of RAM in [min_pfn_mapped, max_pfn_mapped) used as new pages
+ 	 * for page table.
+ 	 */
+ 	while (start < map_end) {
+ 		if (map_end - start > step_size) {
+ 			next =3D round_up(start + 1, step_size);
+ 			if (next > map_end)
+ 				next =3D map_end;
+ 		} else
+ 			next =3D map_end;
+=20
+ 		new_mapped_ram_size =3D init_range_memory_mapping(start, next);
+ 		start =3D next;
+=20
+ 		if (new_mapped_ram_size > mapped_ram_size)
 -			step_size <<=3D STEP_SIZE_SHIFT;
++			step_size =3D get_new_step_size(step_size);
+ 		mapped_ram_size +=3D new_mapped_ram_size;
+ 	}
+ }
+=20
+ void __init init_mem_mapping(void)
+ {
+ 	unsigned long end;
+=20
+ 	probe_page_size_mask();
+=20
+ #ifdef CONFIG_X86_64
+ 	end =3D max_pfn << PAGE_SHIFT;
+ #else
+ 	end =3D max_low_pfn << PAGE_SHIFT;
+ #endif
+=20
+ 	/* the ISA range is always mapped regardless of memory holes */
+ 	init_memory_mapping(0, ISA_END_ADDRESS);
+=20
+ 	/*
+ 	 * If the allocation is in bottom-up direction, we setup direct mapping
+ 	 * in bottom-up, otherwise we setup direct mapping in top-down.
+ 	 */
+ 	if (memblock_bottom_up()) {
+ 		unsigned long kernel_end =3D __pa_symbol(_end);
+=20
+ 		/*
+ 		 * we need two separate calls here. This is because we want to
+ 		 * allocate page tables above the kernel. So we first map
+ 		 * [kernel_end, end) to make memory above the kernel be mapped
+ 		 * as soon as possible. And then use page tables allocated above
+ 		 * the kernel to map [ISA_END_ADDRESS, kernel_end).
+ 		 */
+ 		memory_map_bottom_up(kernel_end, end);
+ 		memory_map_bottom_up(ISA_END_ADDRESS, kernel_end);
+ 	} else {
+ 		memory_map_top_down(ISA_END_ADDRESS, end);
+ 	}
 =20
  #ifdef CONFIG_X86_64
  	if (max_pfn > max_low_pfn) {

--Signature=_Wed__30_Oct_2013_17_40_25_+1100_0cQK_o3CWLf28l_4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJScKneAAoJEMDTa8Ir7ZwVfoMP/iFAa0jEGOyQhFA6K9LxicNj
kq2pppm0JPWNitzPufa8VOM2TWKypY37gJDsgajcFqldumwsTBU0pXjxYpZQzeR+
6SN6vwCtYp8YYgAhAeXybzlmN7MfVm484AT4pQsukkAKadOUYc5oDPNEXTQ1sxJm
FjOZaINTwAEinwykbd3lTfJwo5tFhqucLK+uBPPvCQK6v+mqTbJRg+I6huChkJMR
mq/4uZr7cdSljRs3ao+KsV4iqpct9X5dNGDzCy87DzIARX+AtKSSmPilfKGKvLNK
wYGo+Qos9NvbHmRgG63dO51F5B0/2/rrOp+MK3RoXQMY9HA167lriU/u1tcDnOtD
sE40oSjqnLH/pJ3jv5YNkAczaYJqiOhWNl05/KgSZeXV7Xa1R8LKAr2rbNlfiO82
ZOeZi5TIapb+HfBtzXQom34owdV6TL3q9HcBgnO++HWg/YR2TZ0BOqiLnO+Ociza
C2gQPutkGLaQ7ojFI7smk5ITn68W4q/fFPd6PLQsl0MjQ4UAFdiNpf0PKQVr6JJc
0aI6g8UGmAJF76oRfUmrr+QiBLqKgr/aR02tUNfugnDtUZ7qZuNcuq6YSb3q8n8f
obi+VhyghXkVsZKgrcLScSi1/I97yh9zn6TNFA6wun/DAREr5yzaejllaUQj8HKs
NqYL5iJerqrvPdn/veq5
=8Wgh
-----END PGP SIGNATURE-----

--Signature=_Wed__30_Oct_2013_17_40_25_+1100_0cQK_o3CWLf28l_4--
