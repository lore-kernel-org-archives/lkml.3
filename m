Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751577AbaI3L5U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 07:57:20 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:60906 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbaI3L5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 07:57:19 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        umgwanakikbuti@gmail.com, fweisbec@gmail.com,
        akpm@linux-foundation.org, srao@redhat.com, lwoodman@redhat.com,
        atheurer@redhat.com, oleg@redhat.com, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH] sched, time: cmpxchg does not work on 64-bit variable
Date: Tue, 30 Sep 2014 13:56:37 +0200
Message-ID: <2547036.UshV4pXvhf@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:NOLP1Zr+rMNb9u81+yHIZ52GOcSY0GS6/lo/KxKVxDk
 ezd2oQM6/i0rcISapR1u90L0FqjCYBIw+6Q9P1i3EYOGadbwGj
 T5IJL0vxk+Zhu3Xd5ezoKuvgvcH+K72cvv1eekihIaIoU3UDOp
 Ssqz4J1rtrkqygMuiTu+t9traHAMUHNvKZ2s7NuUpWDRcqihOq
 adKSh/bfHhZxlMlb918Qlksc7wgI8idCf/pLs/Fb4qYQMfQnu2
 4wswR5stEusmNZnb78vzGc+TqfXx210T4O1Vb9WILzx3B7Bxm2
 jgOnKNQa2pH7kyTXL2U9FcT1Tq4S8Z9w9rVhQJZQqKow+ds0xd
 tXnKYR/kCYAPRlPSrEMM=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A recent change to update the stime/utime members of task_struct
using atomic cmpxchg broke configurations on 32-bit machines with
CONFIG_VIRT_CPU_ACCOUNTING_GEN set, because that uses 64-bit
nanoseconds, leading to a link-time error:

kernel/built-in.o: In function `cputime_adjust':
:(.text+0x25234): undefined reference to `__bad_cmpxchg'

This reverts the change that caused the problem, I suspect the real fix
is to conditionally use cmpxchg64 instead, but I have not checked if
that will work on all architectures.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: eb1b4af0a64a ("sched, time: Atomically increment stime & utime")
---
found in ARM randconfig builds on linux-next

diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 64492dff8a81..e99e7e54131c 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -603,12 +603,9 @@ static void cputime_adjust(struct task_cputime *curr,
 	 * If the tick based count grows faster than the scheduler one,
 	 * the result of the scaling may go backward.
 	 * Let's enforce monotonicity.
-	 * Atomic exchange protects against concurrent cputime_adjust().
 	 */
-	while (stime > (rtime = ACCESS_ONCE(prev->stime)))
-		cmpxchg(&prev->stime, rtime, stime);
-	while (utime > (rtime = ACCESS_ONCE(prev->utime)))
-		cmpxchg(&prev->utime, rtime, utime);
+	prev->stime = max(prev->stime, stime);
+	prev->utime = max(prev->utime, utime);
 
 out:
 	*ut = prev->utime;

