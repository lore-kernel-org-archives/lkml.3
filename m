Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048AbaCFHJB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 02:09:01 -0500
Received: from ozlabs.org ([203.10.76.45]:58732 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751276AbaCFHI6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 02:08:58 -0500
Date: Thu, 6 Mar 2014 18:08:52 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Davidlohr Bueso <davidlohr@hp.com>, Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>
Subject: linux-next: build failure after merge of the akpm-current tree
Message-Id: <20140306180852.b1515db3cccc1622172524c0@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__6_Mar_2014_18_08_52_+1100_VYwfYJ0ADqXT4Jg/"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__6_Mar_2014_18_08_52_+1100_VYwfYJ0ADqXT4Jg/
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm-current tree, today's linux-next build (arm
multi_v7_defconfig) failed like this:

In file included from include/linux/vmacache.h:4:0,
                 from include/linux/sched.h:28,
                 from arch/arm/include/asm/tlbflush.h:204,
                 from arch/arm/include/asm/pgtable.h:28,
                 from arch/arm/include/asm/idmap.h:5,
                 from arch/arm/mm/idmap.c:6:
include/linux/mm.h: In function 'is_vmalloc_addr':
include/linux/mm.h:359:17: error: 'VMALLOC_START' undeclared (first use in =
this function)
include/linux/mm.h:359:41: error: 'VMALLOC_END' undeclared (first use in th=
is function)
include/linux/mm.h: In function 'maybe_mkwrite':
include/linux/mm.h:589:3: error: implicit declaration of function 'pte_mkwr=
ite' [-Werror=3Dimplicit-function-declaration]
In file included from include/linux/vmacache.h:4:0,
                 from include/linux/sched.h:28,
                 from arch/arm/include/asm/tlbflush.h:204,
                 from arch/arm/include/asm/pgtable.h:28,
                 from arch/arm/include/asm/idmap.h:5,
                 from arch/arm/mm/idmap.c:6:
include/linux/mm.h: In function 'pmd_alloc':
include/linux/mm.h:1396:2: error: implicit declaration of function 'pud_non=
e' [-Werror=3Dimplicit-function-declaration]
include/linux/mm.h:1397:3: error: implicit declaration of function 'pmd_off=
set' [-Werror=3Dimplicit-function-declaration]
include/linux/mm.h:1397:7: warning: pointer/integer type mismatch in condit=
ional expression [enabled by default]
include/linux/mm.h: In function 'pte_lockptr':
include/linux/mm.h:1433:2: error: implicit declaration of function 'pmd_pag=
e' [-Werror=3Dimplicit-function-declaration]
include/linux/mm.h:1433:2: warning: passing argument 1 of 'ptlock_ptr' make=
s pointer from integer without a cast [enabled by default]
include/linux/mm.h:1425:27: note: expected 'struct page *' but argument is =
of type 'int'
include/linux/mm.h: In function 'pgtable_init':
include/linux/mm.h:1476:2: error: implicit declaration of function 'pgtable=
_cache_init' [-Werror=3Dimplicit-function-declaration]
In file included from arch/arm/include/asm/pgtable.h:33:0,
                 from arch/arm/include/asm/idmap.h:5,
                 from arch/arm/mm/idmap.c:6:
arch/arm/include/asm/pgtable-2level.h: At top level:
arch/arm/include/asm/pgtable-2level.h:159:22: error: conflicting types for =
'pmd_offset'
include/linux/mm.h:1397:9: note: previous implicit declaration of 'pmd_offs=
et' was here
In file included from arch/arm/include/asm/idmap.h:5:0,
                 from arch/arm/mm/idmap.c:6:
arch/arm/include/asm/pgtable.h:255:1: error: conflicting types for 'pte_mkw=
rite'
include/linux/mm.h:589:9: note: previous implicit declaration of 'pte_mkwri=
te' was here

and on and on ...

Caused by commit 0d9ad4220e6d ("mm: per-thread vma caching") which adds
the include of linux/vmacache.h (which includes linux/mm.h) into
linux/sched.h ... There is a reason that we did not include linux/mm.h
into sched.h.

I added the following patch:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 6 Mar 2014 17:45:30 +1100
Subject: [PATCH] mm: don't implictly include linux/mm.h in linux/sched.h

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/unicore32/include/asm/mmu_context.h | 1 +
 fs/exec.c                                | 1 +
 include/linux/sched.h                    | 2 +-
 include/linux/vmacache.h                 | 4 +---
 include/linux/vmacachedefs.h             | 9 +++++++++
 kernel/debug/debug_core.c                | 1 +
 kernel/fork.c                            | 1 +
 mm/mmap.c                                | 1 +
 mm/nommu.c                               | 1 +
 9 files changed, 17 insertions(+), 4 deletions(-)
 create mode 100644 include/linux/vmacachedefs.h

diff --git a/arch/unicore32/include/asm/mmu_context.h b/arch/unicore32/incl=
ude/asm/mmu_context.h
index 2dcd03719ace..ab474c8b8269 100644
--- a/arch/unicore32/include/asm/mmu_context.h
+++ b/arch/unicore32/include/asm/mmu_context.h
@@ -15,6 +15,7 @@
 #include <linux/compiler.h>
 #include <linux/sched.h>
 #include <linux/io.h>
+#include <linux/vmacache.h>
=20
 #include <asm/cacheflush.h>
 #include <asm/cpu-single.h>
diff --git a/fs/exec.c b/fs/exec.c
index 60e36e9b5a1b..1b75ab04c787 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -55,6 +55,7 @@
 #include <linux/pipe_fs_i.h>
 #include <linux/oom.h>
 #include <linux/compat.h>
+#include <linux/vmacache.h>
=20
 #include <asm/uaccess.h>
 #include <asm/mmu_context.h>
diff --git a/include/linux/sched.h b/include/linux/sched.h
index d718fd5048de..07fa6c2c4a9a 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -25,7 +25,7 @@ struct sched_param {
 #include <linux/errno.h>
 #include <linux/nodemask.h>
 #include <linux/mm_types.h>
-#include <linux/vmacache.h>
+#include <linux/vmacachedefs.h>
 #include <linux/preempt_mask.h>
=20
 #include <asm/page.h>
diff --git a/include/linux/vmacache.h b/include/linux/vmacache.h
index 40e4eb829d48..e22a6b6a4889 100644
--- a/include/linux/vmacache.h
+++ b/include/linux/vmacache.h
@@ -2,10 +2,8 @@
 #define __LINUX_VMACACHE_H
=20
 #include <linux/mm.h>
+#include <linux/vmacachedefs.h>
=20
-#define VMACACHE_BITS 2
-#define VMACACHE_SIZE (1U << VMACACHE_BITS)
-#define VMACACHE_MASK (VMACACHE_SIZE - 1)
 /*
  * Hash based on the page number. Provides a good hit rate for
  * workloads with good locality and those with random accesses as well.
diff --git a/include/linux/vmacachedefs.h b/include/linux/vmacachedefs.h
new file mode 100644
index 000000000000..670f33573b44
--- /dev/null
+++ b/include/linux/vmacachedefs.h
@@ -0,0 +1,9 @@
+
+#ifndef __LINUX_VMACACHEDEFS_H
+#define __LINUX_VMACACHEDEFS_H
+
+#define VMACACHE_BITS 2
+#define VMACACHE_SIZE (1U << VMACACHE_BITS)
+#define VMACACHE_MASK (VMACACHE_SIZE - 1)
+
+#endif /* __LINUX_VMACACHEDEFS_H */
diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
index 289996f4902e..6d0b47f421ca 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -50,6 +50,7 @@
 #include <linux/smp.h>
 #include <linux/mm.h>
 #include <linux/rcupdate.h>
+#include <linux/vmacache.h>
=20
 #include <asm/cacheflush.h>
 #include <asm/byteorder.h>
diff --git a/kernel/fork.c b/kernel/fork.c
index bf36e8d2de0e..24d37ebe7157 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -71,6 +71,7 @@
 #include <linux/signalfd.h>
 #include <linux/uprobes.h>
 #include <linux/aio.h>
+#include <linux/vmacache.h>
=20
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
diff --git a/mm/mmap.c b/mm/mmap.c
index 211b7c6ce809..f2fe012ca2a5 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -36,6 +36,7 @@
 #include <linux/sched/sysctl.h>
 #include <linux/notifier.h>
 #include <linux/memory.h>
+#include <linux/vmacache.h>
=20
 #include <asm/uaccess.h>
 #include <asm/cacheflush.h>
diff --git a/mm/nommu.c b/mm/nommu.c
index c58f82044fa1..fd7d7a0c3943 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -31,6 +31,7 @@
 #include <linux/syscalls.h>
 #include <linux/audit.h>
 #include <linux/sched/sysctl.h>
+#include <linux/vmacache.h>
=20
 #include <asm/uaccess.h>
 #include <asm/tlb.h>
--=20
1.9.0

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__6_Mar_2014_18_08_52_+1100_VYwfYJ0ADqXT4Jg/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTGB8IAAoJEMDTa8Ir7ZwVeJwP/0mrRAbNnYnOKE5o5ijWWgMQ
K25riTC8IjWGk2thU4j8gwCOU292RrpNH83jhme2wRBf4Rwqy01o64OX9fx1JTQp
eMScf/iVfAxx6hK77tN3bid6pTJdDEp/JryPtedBCPzaitd0pvZbyIlbgESkRqYY
fBdCNsx26cuKE5L9mOhWoq1uSj/yX9XNwk0U3o/XaNk8tivZCJWIj2dkoIhHSgR0
cIuFB/5OozLGNUEL6a01A5g42Jrpd/MQGZMRHZ8zOS/Jwe/9O4D4GnRNJQOljxgg
LrVL8vd0TyST7j6qAXpzOCr5EJ3eT541EI12VcPBIwbsO/19exQXcIpjBO+0j+ip
0sDFM3wEdeJ5TOs95jrDPtiX/obiPZWSkkrTzNqmzJOZMeiaJ8l7lIrbRluJG2Vu
7yWBd6NFYf5QofS/jkCgu67j+C+M7UF3C/H7p0gWHa4gtsGDoM/JLonULysxX1xA
pVq54zdzMsXPBPBrZs1CAk+FGnk9xK6kOjeGE8eD7BiIIz7Gb71htPyDFQaSjtU7
xxvMQw30WMSZ3hwNu2HHkjmZOBt9IRuRFFcu6/a/nsALWBA5Z8dmKWRzqEtMdkmm
rHLCLKpTyULqGYhdQ9CjuiGDnDC3TWVPqONmUdoJYy8zIgIT1eZWRkN1cJyJt8tJ
llLclhPm9D+8vAoflpRQ
=YLl8
-----END PGP SIGNATURE-----

--Signature=_Thu__6_Mar_2014_18_08_52_+1100_VYwfYJ0ADqXT4Jg/--
