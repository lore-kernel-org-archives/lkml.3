Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896Ab3JUI6f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 04:58:35 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:43393 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398Ab3JUI6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:58:33 -0400
From: Wei Yang <weiyang@linux.vnet.ibm.com>
To: tj@kernel.org, cl@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc: weiyang@linux.vnet.ibm.com
Subject: [PATCH 2/3] percpu: merge two loops when setting up group info
Date: Mon, 21 Oct 2013 16:58:12 +0800
Message-Id: <1382345893-6644-2-git-send-email-weiyang@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1382345893-6644-1-git-send-email-weiyang@linux.vnet.ibm.com>
References: <1382345893-6644-1-git-send-email-weiyang@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102108-2674-0000-0000-00000B1FCF32
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are two loops setting up the group info of pcpu_alloc_info. They share
the same logic, so merge them could be time efficient when there are many
groups.

This patch merge these two loops into one.

Signed-off-by: Wei Yang <weiyang@linux.vnet.ibm.com>
---
 mm/percpu.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 536ca4f..4f710a4f 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1542,11 +1542,6 @@ static struct pcpu_alloc_info * __init pcpu_build_alloc_info(
 		return ERR_PTR(-ENOMEM);
 	cpu_map = ai->groups[0].cpu_map;
 
-	for (group = 0; group < nr_groups; group++) {
-		ai->groups[group].cpu_map = cpu_map;
-		cpu_map += roundup(group_cnt[group], upa);
-	}
-
 	ai->static_size = static_size;
 	ai->reserved_size = reserved_size;
 	ai->dyn_size = dyn_size;
@@ -1557,6 +1552,8 @@ static struct pcpu_alloc_info * __init pcpu_build_alloc_info(
 	for (group = 0, unit = 0; group_cnt[group]; group++) {
 		struct pcpu_group_info *gi = &ai->groups[group];
 
+		gi->cpu_map = cpu_map;
+
 		/*
 		 * Initialize base_offset as if all groups are located
 		 * back-to-back.  The caller should update this to
@@ -1568,6 +1565,7 @@ static struct pcpu_alloc_info * __init pcpu_build_alloc_info(
 			if (group_map[cpu] == group)
 				gi->cpu_map[gi->nr_units++] = cpu;
 		gi->nr_units = roundup(gi->nr_units, upa);
+		cpu_map += gi->nr_units;
 		unit += gi->nr_units;
 	}
 	BUG_ON(unit != nr_units);
-- 
1.7.5.4

