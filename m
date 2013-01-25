Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757451Ab3AYOTD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 09:19:03 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:63256 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757394Ab3AYOO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 09:14:58 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@list.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Paul Turner <pjt@google.com>
Subject: [PATCH 06/19] sched/debug: fix format string for 32 bit platforms
Date: Fri, 25 Jan 2013 14:14:23 +0000
Message-Id: <1359123276-15833-7-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1359123276-15833-1-git-send-email-arnd@arndb.de>
References: <1359123276-15833-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:EWcAdoUsiFJAaaE5NxXMTf028gtePBLh7whGppBv6GB
 8GMZuXie3mxcPiR6EHCdMCqgdoOrp11PwABC4a3lQLzAGHQwUV
 mQ6/6jOiKBmMHq0dezAR4nMjzgLVf80OACNuh9JmgtHVmzR3Ab
 ciY09dbzHkLLT0eKX4f/7r5YfCej4x871WwNrwfgNRyRmyI8CS
 Pd4CdAU38Il5Afu0R3/sWg5zT/jntVo8ODg3ZHccBnF2Va1KQf
 kkMpcEvRGB3bQiADZvLaoU7Wxt//Ny/USgYdShB+QJl8f1Wnbj
 I8Lo1gKO+sZsVOsoS8fb78QEVMEd/nupLKetAA3TM6nJH4FEgg
 ZwSlxzj9+Jzd126/oYf2EWulGdOJ2rUn2M6i/Gmqk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The type returned from atomic64_t can be either unsigned
long or unsigned long long, depending on the architecture.
Using a cast to unsigned long long lets us use the same
format string for all architectures.

Without this patch, building with scheduler debugging
enabled results in:

kernel/sched/debug.c: In function 'print_cfs_rq':
kernel/sched/debug.c:225:2: warning: format '%ld' expects argument of type 'long int', but argument 4 has type 'long long int' [-Wformat]
kernel/sched/debug.c:225:2: warning: format '%ld' expects argument of type 'long int', but argument 3 has type 'long long int' [-Wformat]

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Turner <pjt@google.com>
---
 kernel/sched/debug.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 2cd3c1b..7ae4c4c 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -222,8 +222,8 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 			cfs_rq->runnable_load_avg);
 	SEQ_printf(m, "  .%-30s: %lld\n", "blocked_load_avg",
 			cfs_rq->blocked_load_avg);
-	SEQ_printf(m, "  .%-30s: %ld\n", "tg_load_avg",
-			atomic64_read(&cfs_rq->tg->load_avg));
+	SEQ_printf(m, "  .%-30s: %lld\n", "tg_load_avg",
+			(unsigned long long)atomic64_read(&cfs_rq->tg->load_avg));
 	SEQ_printf(m, "  .%-30s: %lld\n", "tg_load_contrib",
 			cfs_rq->tg_load_contrib);
 	SEQ_printf(m, "  .%-30s: %d\n", "tg_runnable_contrib",
-- 
1.8.0

