Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834Ab3GIPzl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 11:55:41 -0400
Received: from service87.mimecast.com ([91.220.42.44]:45927 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339Ab3GIPzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 11:55:35 -0400
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: mingo@kernel.org, peterz@infradead.org
Cc: arjan@linux.intel.com, vincent.guittot@linaro.org,
        preeti@linux.vnet.ibm.com, alex.shi@intel.com, efault@gmx.de,
        pjt@google.com, len.brown@intel.com, corbet@lwn.net,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        tglx@linutronix.de, catalin.marinas@arm.com,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        morten.rasmussen@arm.com
Subject: [RFC][PATCH 3/9] sched: Make select_idle_sibling() skip cpu with a cpu_power of 1
Date: Tue,  9 Jul 2013 16:55:32 +0100
Message-Id: <1373385338-12983-4-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1373385338-12983-1-git-send-email-morten.rasmussen@arm.com>
References: <1373385338-12983-1-git-send-email-morten.rasmussen@arm.com>
X-OriginalArrivalTime: 09 Jul 2013 15:55:32.0591 (UTC) FILETIME=[BE21DFF0:01CE7CBC]
X-MC-Unique: 113070916553308101
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r69FuRD4011629

select_idle_sibling() must disregard cpus with cpu_power=1 to avoid using
cpus disabled by the power scheduler.

This is a quick fix. The algorithm should be updated to handle cpu_power=1
properly.

Signed-off-by: Morten Rasmussen <morten.rasmussen@arm.com>
CC: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Catalin Marinas <catalin.marinas@arm.com>
---
 kernel/sched/fair.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 01f1f26..f637ea5 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3287,13 +3287,14 @@ static int select_idle_sibling(struct task_struct *p, int target)
 	struct sched_group *sg;
 	int i = task_cpu(p);
 
-	if (idle_cpu(target))
+	if (idle_cpu(target) && power_cpu_balance(target))
 		return target;
 
 	/*
 	 * If the prevous cpu is cache affine and idle, don't be stupid.
 	 */
-	if (i != target && cpus_share_cache(i, target) && idle_cpu(i))
+	if (i != target && cpus_share_cache(i, target) && idle_cpu(i) &&
+		power_cpu_balance(i))
 		return i;
 
 	/*
@@ -3308,7 +3309,8 @@ static int select_idle_sibling(struct task_struct *p, int target)
 				goto next;
 
 			for_each_cpu(i, sched_group_cpus(sg)) {
-				if (i == target || !idle_cpu(i))
+				if (i == target || !idle_cpu(i) ||
+					!power_cpu_balance(i))
 					goto next;
 			}
 
-- 
1.7.9.5


