Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756581Ab3AOJRY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 04:17:24 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:40312 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751611Ab3AOJRW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 04:17:22 -0500
X-IronPort-AV: E=Sophos;i="4.84,473,1355068800"; 
   d="scan'208";a="6590717"
From: liguang <lig.fnst@cn.fujitsu.com>
To: mingo@redhat.com, peterz@infradead.org, Morten.Rasmussen@arm.com,
        linux-kernel@vger.kernel.org
Cc: liguang <lig.fnst@cn.fujitsu.com>
Subject: [PATCH] sched: reduce sched_domain_topology space
Date: Tue, 15 Jan 2013 17:15:18 +0800
Message-Id: <1358241318-20168-1-git-send-email-lig.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.2.5
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/15 17:16:38,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/15 17:16:38,
	Serialize complete at 2013/01/15 17:16:38
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sched_domain_topology space was allocated by the size
ARRAY_SIZE(default_topology) + sched_domains_numa_levels,
suppose CONFIG_SCHED_SMT, CONFIG_SCHED_MC were y,
"static struct sched_domain_topology_level default_topology[] = {
         { sd_init_SIBLING, cpu_smt_mask, },
         { sd_init_MC, cpu_coregroup_mask, },
         { sd_init_CPU, cpu_cpu_mask, },
         { NULL, },
};"
then, ARRAY_SIZE(default_topology) equals to 4,
default_topology's NULL entry was accounted,
but, the following allocation for other sched_domains_numa_levels
entries was startd at 3(for default_topology[3].init is NULL),
so, 1 entry was forgot.

Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>
---
 kernel/sched/core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 257002c..6ba5ecf 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6241,7 +6241,7 @@ static void sched_init_numa(void)
 		}
 	}
 
-	tl = kzalloc((ARRAY_SIZE(default_topology) + level) *
+	tl = kzalloc((ARRAY_SIZE(default_topology) + level - 1) *
 			sizeof(struct sched_domain_topology_level), GFP_KERNEL);
 	if (!tl)
 		return;
-- 
1.7.2.5

