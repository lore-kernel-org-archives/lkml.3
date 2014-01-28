Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755840AbaA1TZW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 14:25:22 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34368 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755349AbaA1TZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 14:25:19 -0500
Date: Tue, 28 Jan 2014 11:24:37 -0800
From: tip-bot for Rik van Riel <tipbot@zytor.com>
Message-ID: <tip-35664fd41e1c8cc4f0b89f6a51db5af39ba50640@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, riel@redhat.com, chegu_vinod@hp.com,
        mgorman@suse.de, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, riel@redhat.com, chegu_vinod@hp.com,
        mgorman@suse.de, tglx@linutronix.de
In-Reply-To: <1390860228-21539-8-git-send-email-riel@redhat.com>
References: <1390860228-21539-8-git-send-email-riel@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/numa] sched/numa:
  Do statistics calculation using local variables only
Git-Commit-ID: 35664fd41e1c8cc4f0b89f6a51db5af39ba50640
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 28 Jan 2014 11:24:43 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  35664fd41e1c8cc4f0b89f6a51db5af39ba50640
Gitweb:     http://git.kernel.org/tip/35664fd41e1c8cc4f0b89f6a51db5af39ba50640
Author:     Rik van Riel <riel@redhat.com>
AuthorDate: Mon, 27 Jan 2014 17:03:46 -0500
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 Jan 2014 15:03:17 +0100

sched/numa: Do statistics calculation using local variables only

The current code in task_numa_placement calculates the difference
between the old and the new value, but also temporarily stores half
of the old value in the per-process variables.

The NUMA balancing code looks at those per-process variables, and
having other tasks temporarily see halved statistics could lead to
unwanted numa migrations. This can be avoided by doing all the math
in local variables.

This change also simplifies the code a little.

Signed-off-by: Rik van Riel <riel@redhat.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Chegu Vinod <chegu_vinod@hp.com>
Link: http://lkml.kernel.org/r/1390860228-21539-8-git-send-email-riel@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 8fc3a82..4c44990 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1513,12 +1513,9 @@ static void task_numa_placement(struct task_struct *p)
 			long diff, f_diff, f_weight;
 
 			i = task_faults_idx(nid, priv);
-			diff = -p->numa_faults_memory[i];
-			f_diff = -p->numa_faults_cpu[i];
 
 			/* Decay existing window, copy faults since last scan */
-			p->numa_faults_memory[i] >>= 1;
-			p->numa_faults_memory[i] += p->numa_faults_buffer_memory[i];
+			diff = p->numa_faults_buffer_memory[i] - p->numa_faults_memory[i] / 2;
 			fault_types[priv] += p->numa_faults_buffer_memory[i];
 			p->numa_faults_buffer_memory[i] = 0;
 
@@ -1532,13 +1529,12 @@ static void task_numa_placement(struct task_struct *p)
 			f_weight = div64_u64(runtime << 16, period + 1);
 			f_weight = (f_weight * p->numa_faults_buffer_cpu[i]) /
 				   (total_faults + 1);
-			p->numa_faults_cpu[i] >>= 1;
-			p->numa_faults_cpu[i] += f_weight;
+			f_diff = f_weight - p->numa_faults_cpu[i] / 2;
 			p->numa_faults_buffer_cpu[i] = 0;
 
+			p->numa_faults_memory[i] += diff;
+			p->numa_faults_cpu[i] += f_diff;
 			faults += p->numa_faults_memory[i];
-			diff += p->numa_faults_memory[i];
-			f_diff += p->numa_faults_cpu[i];
 			p->total_numa_faults += diff;
 			if (p->numa_group) {
 				/* safe because we can only change our own group */
