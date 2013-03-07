Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755654Ab3CGCBT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 21:01:19 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:50206 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754244Ab3CGCBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 21:01:18 -0500
Message-ID: <5137F4BA.2060101@huawei.com>
Date: Thu, 7 Mar 2013 10:00:26 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] sched: Fix a build warning when CONFIG_SMP=n
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All warnings:

   In file included from kernel/sched/core.c:85:0:
   kernel/sched/sched.h:1036:39: warning: 'struct sched_domain' declared inside parameter list
   kernel/sched/sched.h:1036:39: warning: its scope is only this
   definition or declaration, which is probably not what you want

It's because struct sched_domain is defined inside #if CONFIG_SMP, while
update_group_power() is declared unconditionally.

Fix this warning by declaring update_group_power() only if CONFIG_SMP=n.

Build tested with CONFIG_SMP enabled and then disabled.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/sched/sched.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 30bebb9..3bd15a4 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1026,6 +1026,8 @@ extern const struct sched_class idle_sched_class;
 
 #ifdef CONFIG_SMP
 
+extern void update_group_power(struct sched_domain *sd, int cpu);
+
 extern void trigger_load_balance(struct rq *rq, int cpu);
 extern void idle_balance(int this_cpu, struct rq *this_rq);
 
@@ -1040,7 +1042,6 @@ static inline void idle_balance(int cpu, struct rq *rq)
 extern void sysrq_sched_debug_show(void);
 extern void sched_init_granularity(void);
 extern void update_max_interval(void);
-extern void update_group_power(struct sched_domain *sd, int cpu);
 extern int update_runtime(struct notifier_block *nfb, unsigned long action, void *hcpu);
 extern void init_sched_rt_class(void);
 extern void init_sched_fair_class(void);
-- 
1.8.0.2
