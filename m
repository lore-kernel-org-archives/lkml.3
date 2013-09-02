Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143Ab3IBHmE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 03:42:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52437 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757313Ab3IBHmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 03:42:00 -0400
Date: Mon, 2 Sep 2013 00:41:27 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-ys201g4jwukj0h8xcamakxq1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        pjt@google.com, peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, pjt@google.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/fair: Fix the sd_parent_degenerate() code
Git-Commit-ID: 10866e62e8a6907d9072f10f9a0561db0c0cf50b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 02 Sep 2013 00:41:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  10866e62e8a6907d9072f10f9a0561db0c0cf50b
Gitweb:     http://git.kernel.org/tip/10866e62e8a6907d9072f10f9a0561db0c0cf50b
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Mon, 19 Aug 2013 16:57:04 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 2 Sep 2013 08:27:40 +0200

sched/fair: Fix the sd_parent_degenerate() code

I found that on my WSM box I had a redundant domain:

[    0.949769] CPU0 attaching sched-domain:
[    0.953765]  domain 0: span 0,12 level SIBLING
[    0.958335]   groups: 0 (cpu_power = 587) 12 (cpu_power = 588)
[    0.964548]   domain 1: span 0-5,12-17 level MC
[    0.969206]    groups: 0,12 (cpu_power = 1175) 1,13 (cpu_power = 1176) 2,14 (cpu_power = 1176) 3,15 (cpu_power = 1176) 4,16 (cpu_power = 1176) 5,17 (cpu_power = 1176)
[    0.984993]    domain 2: span 0-5,12-17 level CPU
[    0.989822]     groups: 0-5,12-17 (cpu_power = 7055)
[    0.995049]     domain 3: span 0-23 level NUMA
[    0.999620]      groups: 0-5,12-17 (cpu_power = 7055) 6-11,18-23 (cpu_power = 7056)

Note how domain 2 has only a single group and spans the same CPUs as
domain 1. We should not keep such domains and do in fact have code to
prune these.

It turns out that the 'new' SD_PREFER_SIBLING flag causes this, it
makes sd_parent_degenerate() fail on the CPU domain. We can easily
fix this by 'ignoring' the SD_PREFER_SIBLING bit and transfering it
to whatever domain ends up covering the span.

With this patch the domains now look like this:

[    0.950419] CPU0 attaching sched-domain:
[    0.954454]  domain 0: span 0,12 level SIBLING
[    0.959039]   groups: 0 (cpu_power = 587) 12 (cpu_power = 588)
[    0.965271]   domain 1: span 0-5,12-17 level MC
[    0.969936]    groups: 0,12 (cpu_power = 1175) 1,13 (cpu_power = 1176) 2,14 (cpu_power = 1176) 3,15 (cpu_power = 1176) 4,16 (cpu_power = 1176) 5,17 (cpu_power = 1176)
[    0.985737]    domain 2: span 0-23 level NUMA
[    0.990231]     groups: 0-5,12-17 (cpu_power = 7055) 6-11,18-23 (cpu_power = 7056)

Reviewed-by: Paul Turner <pjt@google.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-ys201g4jwukj0h8xcamakxq1@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index cf8f100..4da0f4b 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4914,7 +4914,8 @@ sd_parent_degenerate(struct sched_domain *sd, struct sched_domain *parent)
 				SD_BALANCE_FORK |
 				SD_BALANCE_EXEC |
 				SD_SHARE_CPUPOWER |
-				SD_SHARE_PKG_RESOURCES);
+				SD_SHARE_PKG_RESOURCES |
+				SD_PREFER_SIBLING);
 		if (nr_node_ids == 1)
 			pflags &= ~SD_SERIALIZE;
 	}
@@ -5118,6 +5119,13 @@ cpu_attach_domain(struct sched_domain *sd, struct root_domain *rd, int cpu)
 			tmp->parent = parent->parent;
 			if (parent->parent)
 				parent->parent->child = tmp;
+			/*
+			 * Transfer SD_PREFER_SIBLING down in case of a
+			 * degenerate parent; the spans match for this
+			 * so the property transfers.
+			 */
+			if (parent->flags & SD_PREFER_SIBLING)
+				tmp->flags |= SD_PREFER_SIBLING;
 			destroy_sched_domain(parent, cpu);
 		} else
 			tmp = tmp->parent;
