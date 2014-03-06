Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751577AbaCFHzB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 02:55:01 -0500
Received: from ozlabs.org ([203.10.76.45]:43100 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750875AbaCFHy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 02:54:59 -0500
Date: Thu, 6 Mar 2014 18:54:48 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Lameter <cl@linux.com>
Subject: linux-next: build failure after merge of the akpm tree
Message-Id: <20140306185448.78f2422588456394d12aa50d@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__6_Mar_2014_18_54_48_+1100_k5cjhd0ujt/YIf8="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__6_Mar_2014_18_54_48_+1100_k5cjhd0ujt/YIf8=
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

arch/powerpc/mm/stab.c: In function '__ste_allocate':
arch/powerpc/mm/stab.c:138:42: error: lvalue required as left operand of as=
signment
    __this_cpu_read(stab_cache[offset++]) =3D stab_entry;
                                          ^
In file included from include/linux/kernel_stat.h:8:0,
                 from kernel/softirq.c:14:
kernel/softirq.c: In function '__do_softirq':
include/linux/interrupt.h:328:57: error: lvalue required as left operand of=
 assignment
 #define set_softirq_pending(x) (local_softirq_pending() =3D (x))
                                                         ^
kernel/softirq.c:252:2: note: in expansion of macro 'set_softirq_pending'
  set_softirq_pending(0);
  ^
kernel/softirq.c: In function '__raise_softirq_irqoff':
include/linux/interrupt.h:329:57: error: lvalue required as left operand of=
 assignment
 #define or_softirq_pending(x)  (local_softirq_pending() |=3D (x))
                                                         ^
kernel/softirq.c:427:2: note: in expansion of macro 'or_softirq_pending'
  or_softirq_pending(1UL << nr);
  ^
In file included from arch/powerpc/include/asm/time.h:18:0,
                 from arch/powerpc/include/asm/cputime.h:29,
                 from include/linux/sched.h:33,
                 from include/linux/ptrace.h:5,
                 from arch/powerpc/kernel/mce.c:26:
arch/powerpc/kernel/mce.c: In function 'save_mce_event':
include/linux/percpu.h:737:2: error: incompatible types when initializing t=
ype 'struct machine_check_event *' using type 'struct machine_check_event'
  (__this_cpu_preempt_check("read"),__pcpu_size_call_return(raw_cpu_read_, =
(pcp)))
  ^
arch/powerpc/kernel/mce.c:77:36: note: in expansion of macro '__this_cpu_re=
ad'
  struct machine_check_event *mce =3D __this_cpu_read(mce_event[index]);
                                    ^
arch/powerpc/kernel/mce.c: In function 'get_mce_event':
arch/powerpc/kernel/mce.c:156:10: error: incompatible types when assigning =
to type 'struct machine_check_event *' from type 'struct machine_check_even=
t'
   mc_evt =3D __this_cpu_read(mce_event[index]);
          ^

Caused by commits 1c55f79be84e ("powerpc: replace __get_cpu_var uses")
and 0884f89e7e08 ("powerpc: handle new __get_cpu_var calls in 3.14").
Someone should check the build results overnight ...
http://kisskb.ellerman.id.au/linux-next

I added the following patch:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 6 Mar 2014 18:36:39 +1100
Subject: [PATCH] powerpc: replace __get_cpu_var uses fix

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/powerpc/include/asm/hardirq.h | 4 ++++
 arch/powerpc/kernel/mce.c          | 4 ++--
 arch/powerpc/mm/stab.c             | 2 +-
 3 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/include/asm/hardirq.h b/arch/powerpc/include/asm/=
hardirq.h
index 2e14594ccea4..f8c2a0e71f24 100644
--- a/arch/powerpc/include/asm/hardirq.h
+++ b/arch/powerpc/include/asm/hardirq.h
@@ -21,6 +21,10 @@ DECLARE_PER_CPU_SHARED_ALIGNED(irq_cpustat_t, irq_stat);
 #define __ARCH_IRQ_STAT
=20
 #define local_softirq_pending()	__this_cpu_read(irq_stat.__softirq_pending)
+#define set_softirq_pending(x) __this_cpu_write(irq_stat.__softirq_pending=
, (x))
+#define or_softirq_pending(x)  __this_cpu_or(irq_stat.__softirq_pending, (=
x))
+
+#define __ARCH_SET_SOFTIRQ_PENDING
=20
 static inline void ack_bad_irq(unsigned int irq)
 {
diff --git a/arch/powerpc/kernel/mce.c b/arch/powerpc/kernel/mce.c
index a9bf88affe79..46da0810a03b 100644
--- a/arch/powerpc/kernel/mce.c
+++ b/arch/powerpc/kernel/mce.c
@@ -74,7 +74,7 @@ void save_mce_event(struct pt_regs *regs, long handled,
 {
 	uint64_t srr1;
 	int index =3D __this_cpu_inc_return(mce_nest_count);
-	struct machine_check_event *mce =3D __this_cpu_read(mce_event[index]);
+	struct machine_check_event *mce =3D this_cpu_ptr(&mce_event[index]);
=20
 	/*
 	 * Return if we don't have enough space to log mce event.
@@ -153,7 +153,7 @@ int get_mce_event(struct machine_check_event *mce, bool=
 release)
=20
 	/* Check if we have MCE info to process. */
 	if (index < MAX_MC_EVT) {
-		mc_evt =3D __this_cpu_read(mce_event[index]);
+		mc_evt =3D this_cpu_ptr(&mce_event[index]);
 		/* Copy the event structure and release the original */
 		if (mce)
 			*mce =3D *mc_evt;
diff --git a/arch/powerpc/mm/stab.c b/arch/powerpc/mm/stab.c
index ecbdc28554c6..db4483e95382 100644
--- a/arch/powerpc/mm/stab.c
+++ b/arch/powerpc/mm/stab.c
@@ -135,7 +135,7 @@ static int __ste_allocate(unsigned long ea, struct mm_s=
truct *mm)
 	if (!is_kernel_addr(ea)) {
 		offset =3D __this_cpu_read(stab_cache_ptr);
 		if (offset < NR_STAB_CACHE_ENTRIES)
-			__this_cpu_read(stab_cache[offset++]) =3D stab_entry;
+			__this_cpu_write(stab_cache[offset++], stab_entry);
 		else
 			offset =3D NR_STAB_CACHE_ENTRIES+1;
 		__this_cpu_write(stab_cache_ptr, offset);
--=20
1.9.0

However, I then got these errors:

arch/powerpc/kernel/built-in.o: In function `.set_breakpoint':
(.text+0x84c4): undefined reference to `.__bad_size_call_parameter'
arch/powerpc/kernel/built-in.o: In function `.machine_check_queue_event':
(.text+0x19b60): undefined reference to `.__bad_size_call_parameter'

These are in arch/powerpc/kernel/process.c and
arch/powerpc/kernel/mce.c.  They are assigning structs.  This used to
work with __get_cpu_var(x) =3D y, but does not for __this_cpu_write(x, y)
if sizeof(x) > 8.

I have dropped my fix patch and reverted those two commits for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__6_Mar_2014_18_54_48_+1100_k5cjhd0ujt/YIf8=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTGCnQAAoJEMDTa8Ir7ZwVKsgP/j2FDgyp0GqeQ8DDJH0J28+2
DFnZa9rBe1PF++YQyiNzszDsXuB8P5CKGLUrXI6dpN2FfNXKsZSow1sR4fWm6nyS
tl0bqH8i59BgJeCT9XNzz81UVZ7NqMaP2btdrGgL/2ilD0VINM3RDEj122f7vYLz
DOKZBFJbAS9KvhCulID6IJkKN7B2SA43OS+aLsIrNJJ24WqWPDujArml4swt99bR
PFRpsvWB84eW2UuRNSEqVfrf461xdphaYzJeeJJcktdbzhVapRJCahQnScSmS8rY
Mzrntf8tXYUIPrkH5qiQ8smVoBhY8xz9uomTGVOFr6ceXlClYqMOT72w5NDe0pmQ
wuqWaTBzGCr3cFKbIlKy1dPu85uiiJQc/h/DukPVMxSzNNekOAIasi/iyOUowBgm
0Xu2axhuOSA0LY2m1vqFzlQZufKdkbVf7L5M1l8HtOxX+f6tUqokGWfTt8d+KTqo
V3LwiRIuNq2gjZsBHjvRMfKwjXkEZ1QZ8HCOOUcGBnF79tyiesKcaoMHnImllTKZ
gT7DL0W7J9SGESijwfFcB6DgARulIRGMMi9/KjeGi32Z4w5L/5I8l7tadKSdbvxB
71+Daq5VzNGs5lqF9IGL4YG8c578uIkgI+AVk7nYKORwRwEpRsnUkRufRQtM3rHP
YBGvQmHzbN4PCbvBuKwc
=s7Z1
-----END PGP SIGNATURE-----

--Signature=_Thu__6_Mar_2014_18_54_48_+1100_k5cjhd0ujt/YIf8=--
