Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872Ab3JUI6a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 04:58:30 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:43768 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398Ab3JUI62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:58:28 -0400
From: Wei Yang <weiyang@linux.vnet.ibm.com>
To: tj@kernel.org, cl@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc: weiyang@linux.vnet.ibm.com
Subject: [PATCH 1/3] percpu: stop the loop when a cpu belongs to a new group
Date: Mon, 21 Oct 2013 16:58:11 +0800
Message-Id: <1382345893-6644-1-git-send-email-weiyang@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102108-3864-0000-0000-00000AA37362
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a cpu belongs to a new group, there is no cpu has the same group id. This
means it can be assigned a new group id without checking with every others.

This patch does this optimiztion.

Signed-off-by: Wei Yang <weiyang@linux.vnet.ibm.com>
---
 mm/percpu.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 8c8e08f..536ca4f 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1488,7 +1488,10 @@ static struct pcpu_alloc_info * __init pcpu_build_alloc_info(
 			    (cpu_distance_fn(cpu, tcpu) > LOCAL_DISTANCE ||
 			     cpu_distance_fn(tcpu, cpu) > LOCAL_DISTANCE)) {
 				group++;
-				nr_groups = max(nr_groups, group + 1);
+				if (group == nr_groups) {
+					nr_groups++;
+					break;
+				}
 				goto next_group;
 			}
 		}
-- 
1.7.5.4

