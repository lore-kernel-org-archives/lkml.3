Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964891Ab3FSSkw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 14:40:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40125 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964849Ab3FSSkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 14:40:46 -0400
Date: Wed, 19 Jun 2013 11:40:18 -0700
From: tip-bot for Viresh Kumar <tipbot@zytor.com>
Message-ID: <tip-22da956953f371c1ee7a578c31ed8c5702cb52b1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, viresh.kumar@linaro.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, viresh.kumar@linaro.org, tglx@linutronix.de
In-Reply-To: <fc473527cbc4dfa0b8eeef2a59db74684eb59a83.1370436120.git.viresh.kumar@linaro.org>
References: <fc473527cbc4dfa0b8eeef2a59db74684eb59a83.1370436120.git.viresh.kumar@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Optimize build_sched_domains()
  for saving first SD node for a cpu
Git-Commit-ID: 22da956953f371c1ee7a578c31ed8c5702cb52b1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 19 Jun 2013 11:40:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  22da956953f371c1ee7a578c31ed8c5702cb52b1
Gitweb:     http://git.kernel.org/tip/22da956953f371c1ee7a578c31ed8c5702cb52b1
Author:     Viresh Kumar <viresh.kumar@linaro.org>
AuthorDate: Tue, 4 Jun 2013 15:41:15 +0530
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 19 Jun 2013 12:58:43 +0200

sched: Optimize build_sched_domains() for saving first SD node for a cpu

We are saving first scheduling domain for a cpu in build_sched_domains() by
iterating over the nested sd->child list. We don't actually need to do it this
way.

tl will be equal to sched_domain_topology for the first iteration and so we can
set *per_cpu_ptr(d.sd, i) based on that.  So, save pointer to first SD while
running the iteration loop over tl's.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/fc473527cbc4dfa0b8eeef2a59db74684eb59a83.1370436120.git.viresh.kumar@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 342e744..137dcc0 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5985,16 +5985,13 @@ static int build_sched_domains(const struct cpumask *cpu_map,
 		sd = NULL;
 		for (tl = sched_domain_topology; tl->init; tl++) {
 			sd = build_sched_domain(tl, cpu_map, attr, sd, i);
+			if (tl == sched_domain_topology)
+				*per_cpu_ptr(d.sd, i) = sd;
 			if (tl->flags & SDTL_OVERLAP || sched_feat(FORCE_SD_OVERLAP))
 				sd->flags |= SD_OVERLAP;
 			if (cpumask_equal(cpu_map, sched_domain_span(sd)))
 				break;
 		}
-
-		while (sd->child)
-			sd = sd->child;
-
-		*per_cpu_ptr(d.sd, i) = sd;
 	}
 
 	/* Build the groups for the domains */
