Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932085AbaLBOIt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 09:08:49 -0500
Received: from service88.mimecast.com ([195.130.217.12]:50580 "EHLO
	service88.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888AbaLBOHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 09:07:02 -0500
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: peterz@infradead.org, mingo@redhat.com
Cc: dietmar.eggemann@arm.com, vincent.guittot@linaro.org, pjt@google.com,
        bsegall@google.com, mturquette@linaro.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Morten Rasmussen <morten.rasmussen@arm.com>
Subject: [RFC PATCH 10/10] sched: Include blocked load in weighted_cpuload
Date: Tue,  2 Dec 2014 14:06:32 +0000
Message-Id: <1417529192-11579-11-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417529192-11579-1-git-send-email-morten.rasmussen@arm.com>
References: <1417529192-11579-1-git-send-email-morten.rasmussen@arm.com>
X-OriginalArrivalTime: 02 Dec 2014 14:06:59.0947 (UTC) FILETIME=[3D6183B0:01D00E39]
X-MC-Unique: 114120214070015201
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by nfs id sB2E9UuC016997

Adds blocked_load_avg to weighted_cpuload() to take recently runnable
tasks into account in load-balancing decisions. This changes the nature
of weighted_cpuload() as it may >0 while there are currently no runnable
tasks on the cpu rq. Hence care must be taken in the load-balance code
to use cfs_rq->runnable_load_avg or nr_running when current rq status is
needed.

This patch is highly experimental and will probably have require
additional updates of the users of weighted_cpuload().

cc: Ingo Molnar <mingo@redhat.com>
cc: Peter Zijlstra <peterz@infradead.org>

Signed-off-by: Morten Rasmussen <morten.rasmussen@arm.com>
---
 kernel/sched/fair.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index bd950b2..ad0ebb7 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4349,7 +4349,8 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 /* Used instead of source_load when we know the type == 0 */
 static unsigned long weighted_cpuload(const int cpu)
 {
-	return cpu_rq(cpu)->cfs.runnable_load_avg;
+	return cpu_rq(cpu)->cfs.runnable_load_avg
+		+ cpu_rq(cpu)->cfs.blocked_load_avg;
 }
 
 /*
-- 
1.9.1


