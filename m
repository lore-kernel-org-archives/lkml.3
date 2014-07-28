Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682AbaG1Iab (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 04:30:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42843 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889AbaG1Ia2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 04:30:28 -0400
Date: Mon, 28 Jul 2014 01:28:38 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-6ae72dff37596f736b795426306404f0793e4b1b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, dietmar.eggemann@arm.com,
        peterz@infradead.org, jwboyer@redhat.com, bruno@wolff.to,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        dietmar.eggemann@arm.com, jwboyer@redhat.com, bruno@wolff.to,
        tglx@linutronix.de
In-Reply-To: <20140722094740.GJ12054@laptop.lan>
References: <20140722094740.GJ12054@laptop.lan>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Robustify topology setup
Git-Commit-ID: 6ae72dff37596f736b795426306404f0793e4b1b
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

Commit-ID:  6ae72dff37596f736b795426306404f0793e4b1b
Gitweb:     http://git.kernel.org/tip/6ae72dff37596f736b795426306404f0793e4b1b
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Tue, 22 Jul 2014 11:47:40 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 28 Jul 2014 10:04:13 +0200

sched: Robustify topology setup

We hard assume that higher topology levels are supersets of lower
levels.

Detect, warn and try to fixup when we encounter this violated.

Tested-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Josh Boyer <jwboyer@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Bruno Wolff III <bruno@wolff.to>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/20140722094740.GJ12054@laptop.lan
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 415ab02..2a36a74 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6481,6 +6481,20 @@ struct sched_domain *build_sched_domain(struct sched_domain_topology_level *tl,
 		sched_domain_level_max = max(sched_domain_level_max, sd->level);
 		child->parent = sd;
 		sd->child = child;
+
+		if (!cpumask_subset(sched_domain_span(child),
+				    sched_domain_span(sd))) {
+			pr_err("BUG: arch topology borken\n");
+#ifdef CONFIG_SCHED_DEBUG
+			pr_err("     the %s domain not a subset of the %s domain\n",
+					child->name, sd->name);
+#endif
+			/* Fixup, ensure @sd has at least @child cpus. */
+			cpumask_or(sched_domain_span(sd),
+				   sched_domain_span(sd),
+				   sched_domain_span(child));
+		}
+
 	}
 	set_domain_attribute(sd, attr);
 
