Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751451Ab3LKKnp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 05:43:45 -0500
Received: from jacques.telenet-ops.be ([195.130.132.50]:40721 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab3LKKnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 05:43:42 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Rusty Russell <rusty@rustcorp.com.au>,
        Thomas Gleixner <tglx@linutronix.de>,
        Darren Hart <dvhart@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>, stable@vger.kernel.org
Subject: [PATCH] futex: Switch to USER_DS for futex test
Date: Wed, 11 Dec 2013 11:43:21 +0100
Message-Id: <1386758601-8520-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit e4f2dfbb5e92be4e46c0625f4f8eb101110f756f ("m68k: implement
futex.h to support userspace robust futexes and PI mutexes"), the kernel
crashes during boot up on MC68030:

Data read fault at 0x00000000 in Super Data (pc=0x3afec)
BAD KERNEL BUSERR
Oops: 00000000
Modules linked in:
PC: [<0003afec>] cmpxchg_futex_value_locked+0x14/0x4a
SR: 2004  SP: 0082fed4  a2: 0082c000
d0: 00000000    d1: 00000001    d2: 00000018    d3: 00000000
d4: 00000061    d5: 00001000    a0: 00000000    a1: 0082e000
Process swapper (pid: 1, task=0082c000)
Frame format=B ssw=074d isc=4a80 isb=661c daddr=00000000 dobuf=00000001
baddr=0003aff2 dibuf=00000000 ver=f
Stack from 0082ff5c:
        002b8cb8 0082ff70 00000000 00000000 00000000 00000000 00000000 000020ac
        00000018 00000007 00000061 00001000 00000000 00000000 002cab50 00002008
        002b3a56 002b8ca4 0082c3f0 00000000 0082c53c 001e316a 00000000 00000000
        001e3172 001e316a 000025d4 00000000 00000000 00000000 00000000 00000000
        00000000 00000000 00000000 00000000 00000000 00000000 00000000 20000000
        00000000
Call Trace: [<002b8cb8>] futex_init+0x14/0x54
 [<000020ac>] do_one_initcall+0xa4/0x144
 [<00001000>] kernel_pg_dir+0x0/0x1000
 [<00002008>] do_one_initcall+0x0/0x144
 [<002b3a56>] kernel_init_freeable+0xca/0x152
 [<002b8ca4>] futex_init+0x0/0x54
 [<001e316a>] kernel_init+0x0/0xc8
 [<001e3172>] kernel_init+0x8/0xc8
 [<001e316a>] kernel_init+0x0/0xc8
 [<000025d4>] ret_from_kernel_thread+0xc/0x14

This happens because the futex test in futex_init() lacks a switch to the
USER_DS address space, while cmpxchg_futex_value_locked() and
futex_atomic_cmpxchg_inatomic() operate on userspace pointers (albeit NULL
for this particular test).

Fix this by switching to USER_DS before running the test, and restoring the
old address space afterwards.

Reported-by: Tuxist <tuxist@tuxist.de>
Reported-by: Patrick McCarthy <patrickjmc@gmail.com>
Bisected-by: Finn Thain <fthain@telegraphics.com.au>
Suggested-by: Andreas Schwab <schwab@linux-m68k.org>
Tested-by: Finn Thain <fthain@telegraphics.com.au>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: stable@vger.kernel.org
---
 kernel/futex.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/futex.c b/kernel/futex.c
index 80ba086f021d..ffe0c7706b9c 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -63,6 +63,7 @@
 #include <linux/sched/rt.h>
 #include <linux/hugetlb.h>
 #include <linux/freezer.h>
+#include <linux/uaccess.h>
 
 #include <asm/futex.h>
 
@@ -2732,6 +2733,7 @@ SYSCALL_DEFINE6(futex, u32 __user *, uaddr, int, op, u32, val,
 
 static int __init futex_init(void)
 {
+	mm_segment_t fs;
 	u32 curval;
 	int i;
 
@@ -2745,8 +2747,11 @@ static int __init futex_init(void)
 	 * implementation, the non-functional ones will return
 	 * -ENOSYS.
 	 */
+	fs = get_fs();
+	set_fs(USER_DS);
 	if (cmpxchg_futex_value_locked(&curval, NULL, 0, 0) == -EFAULT)
 		futex_cmpxchg_enabled = 1;
+	set_fs(fs);
 
 	for (i = 0; i < ARRAY_SIZE(futex_queues); i++) {
 		plist_head_init(&futex_queues[i].chain);
-- 
1.7.9.5

