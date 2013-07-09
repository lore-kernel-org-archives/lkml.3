Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080Ab3GIP5K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 11:57:10 -0400
Received: from service87.mimecast.com ([91.220.42.44]:46132 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669Ab3GIPzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 11:55:38 -0400
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: mingo@kernel.org, peterz@infradead.org
Cc: arjan@linux.intel.com, vincent.guittot@linaro.org,
        preeti@linux.vnet.ibm.com, alex.shi@intel.com, efault@gmx.de,
        pjt@google.com, len.brown@intel.com, corbet@lwn.net,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        tglx@linutronix.de, catalin.marinas@arm.com,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        morten.rasmussen@arm.com
Subject: [RFC][PATCH 5/9] sched: Make idle_balance() skip cpus with a cpu_power of 1
Date: Tue,  9 Jul 2013 16:55:34 +0100
Message-Id: <1373385338-12983-6-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1373385338-12983-1-git-send-email-morten.rasmussen@arm.com>
References: <1373385338-12983-1-git-send-email-morten.rasmussen@arm.com>
X-OriginalArrivalTime: 09 Jul 2013 15:55:34.0263 (UTC) FILETIME=[BF210070:01CE7CBC]
X-MC-Unique: 113070916553607201
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r69FvKP5011645

idle_balance() should disregard cpus disabled by the power scheduler.

This is a quick fix. idle_balance() should be revisit to implement proper
handling of cpus with cpu_power=1.

Signed-off-by: Morten Rasmussen <morten.rasmussen@arm.com>
CC: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Catalin Marinas <catalin.marinas@arm.com>
---
 kernel/sched/fair.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 4610463..a59617b 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5261,6 +5261,10 @@ void idle_balance(int this_cpu, struct rq *this_rq)
 	if (this_rq->avg_idle < sysctl_sched_migration_cost)
 		return;
 
+	/* Don't pull tasks if disable by power scheduler */
+	if (!power_cpu_balance(this_cpu))
+		return;
+
 	/*
 	 * Drop the rq->lock, but keep IRQ/preempt disabled.
 	 */
-- 
1.7.9.5


