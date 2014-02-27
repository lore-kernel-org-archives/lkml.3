Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316AbaB0Nca (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 08:32:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54958 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765AbaB0Nc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 08:32:28 -0500
Date: Thu, 27 Feb 2014 05:31:56 -0800
From: tip-bot for Juri Lelli <tipbot@zytor.com>
Message-ID: <tip-eec751ed41a0ae7e92a43c33a458d7bd1b941631@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, juri.lelli@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, juri.lelli@gmail.com
In-Reply-To: <1393238832-9100-1-git-send-email-juri.lelli@gmail.com>
References: <1393238832-9100-1-git-send-email-juri.lelli@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched/deadline: Switch CPU'
 s presence test order
Git-Commit-ID: eec751ed41a0ae7e92a43c33a458d7bd1b941631
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  eec751ed41a0ae7e92a43c33a458d7bd1b941631
Gitweb:     http://git.kernel.org/tip/eec751ed41a0ae7e92a43c33a458d7bd1b941631
Author:     Juri Lelli <juri.lelli@gmail.com>
AuthorDate: Mon, 24 Feb 2014 11:47:12 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 27 Feb 2014 12:29:40 +0100

sched/deadline: Switch CPU's presence test order

Commit 82b9580 ("sched/deadline: Test for CPU's presence explicitly")
changed how we check if a CPU returned by cpudeadline machinery is
valid. But, we don't want to call cpu_present() if best_cpu is
equal to -1. So, switch the order of tests inside WARN_ON().

Signed-off-by: Juri Lelli <juri.lelli@gmail.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: boris.ostrovsky@oracle.com
Cc: konrad.wilk@oracle.com
Cc: rostedt@goodmis.org
Link: http://lkml.kernel.org/r/1393238832-9100-1-git-send-email-juri.lelli@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/cpudeadline.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/cpudeadline.c b/kernel/sched/cpudeadline.c
index 5b8838b..5b9bb42 100644
--- a/kernel/sched/cpudeadline.c
+++ b/kernel/sched/cpudeadline.c
@@ -70,7 +70,7 @@ static void cpudl_heapify(struct cpudl *cp, int idx)
 
 static void cpudl_change_key(struct cpudl *cp, int idx, u64 new_dl)
 {
-	WARN_ON(!cpu_present(idx) || idx == IDX_INVALID);
+	WARN_ON(idx == IDX_INVALID || !cpu_present(idx));
 
 	if (dl_time_before(new_dl, cp->elements[idx].dl)) {
 		cp->elements[idx].dl = new_dl;
@@ -117,7 +117,7 @@ int cpudl_find(struct cpudl *cp, struct task_struct *p,
 	}
 
 out:
-	WARN_ON(!cpu_present(best_cpu) && best_cpu != -1);
+	WARN_ON(best_cpu != -1 && !cpu_present(best_cpu));
 
 	return best_cpu;
 }
