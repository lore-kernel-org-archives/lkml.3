Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693Ab3JNJUM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 05:20:12 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:47430 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753797Ab3JNJUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 05:20:10 -0400
Message-ID: <525BB740.2010906@linux.vnet.ibm.com>
Date: Mon, 14 Oct 2013 17:20:00 +0800
From: Michael wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Mel Gorman <mgorman@suse.de>, LKML <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH] sched/numa: fix the wrong logical inside task_numa_migrate()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101409-2674-0000-0000-00000B092AAB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the comment said, we want a node benefit BOTH task and group, thus the
condition to skip the node should be:

        taskimp < 0 || groupimp < 0

CC: Mel Gorman <mgorman@suse.de>
CC: Ingo Molnar <mingo@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
---
 kernel/sched/fair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 803e343..53e3ba9 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1225,7 +1225,7 @@ static int task_numa_migrate(struct task_struct *p)
                        /* Only consider nodes where both task and groups benefit */
                        taskimp = task_weight(p, nid) - taskweight;
                        groupimp = group_weight(p, nid) - groupweight;
-                       if (taskimp < 0 && groupimp < 0)
+                       if (taskimp < 0 || groupimp < 0)
                                continue;

                        env.dst_nid = nid;
-- 
1.7.9.5

