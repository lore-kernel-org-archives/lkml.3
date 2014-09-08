Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627AbaIHLCu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 07:02:50 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:63075 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487AbaIHLCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 07:02:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: "mm: introduce dump_vma fix 2" still broken
Date: Mon, 08 Sep 2014 13:02:33 +0200
Message-ID: <2815658.dHHBXc7oHP@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:zuka6K9IRPvXw1rMt0t9D130i1S+j2LLvPlezC5Ir4x
 gskJerYAYmG3UytxRaVaQsH3BVoJbsjFyeyctPDDliOCDbV5jc
 zT91/YSoBKxFU4QeSpI8GoO3kxes6jGMMlRYgbwKUQlfk2VgWa
 qIqFY6WiARwizXU9TV8FJVxSqQzWNv046xG/Kjp3lllJV1l92R
 N+jzihCqURz3vEdRbgEeJ43cYB4Ch/LvaATXZYBsp0g8uRk417
 EfhWG4wkSra0GC9ylidZLltZlIQXmLapKgRC4KmqeavnSa9cIY
 HUyFi2wKsZYhI1CG+zoLIPbuBMiRYyNsLhijQeV7PArN4ZD8Dm
 XlsdaFDeTzvo6QCABph4=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I saw this commit today in linux-next, which fixes a build error, but introduces
a new warning:

commit a60224c708f880dd937b352b7461cbf14e93012d
Author: Stephen Rothwell <sfr@canb.auug.org.au>
Date:   Mon Sep 8 19:41:54 2014 +1000

    mm: introduce dump_vma fix 2
    
    Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index cb510c08073b..0de60769bcf6 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6739,7 +6739,7 @@ void dump_vma(const struct vm_area_struct *vma)
                "prot %lx anon_vma %p vm_ops %p\n"
                "pgoff %lx file %p private_data %p\n",
                vma, (void *)vma->vm_start, (void *)vma->vm_end, vma->vm_next,
-               vma->vm_prev, vma->vm_mm, vma->vm_page_prot.pgprot,
+               vma->vm_prev, vma->vm_mm, pgprot_val(vma->vm_page_prot),
                vma->anon_vma, vma->vm_ops, vma->vm_pgoff,
                vma->vm_file, vma->vm_private_data);
        dump_flags(vma->vm_flags, vmaflags_names, ARRAY_SIZE(vmaflags_names));


/git/arm-soc/mm/page_alloc.c: In function 'dump_vma':
/git/arm-soc/mm/page_alloc.c:6744:3: warning: format '%lx' expects argument of type 'long unsigned int', but argument 8 has type 'pgprot_t' [-Wformat=]
   vma->vm_file, vma->vm_private_data);
   ^

This happens on machines that use ARM LPAE, where pgprot_t is in fact
a 64-bit integer. The simplest fix I see would be add a cast to u64
and always print this as a 64bit value.

	Arnd
