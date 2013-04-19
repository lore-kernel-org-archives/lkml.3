Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030476Ab3DSM1h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 08:27:37 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:58697 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030384Ab3DSM1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 08:27:34 -0400
Message-ID: <5171382F.709@huawei.com>
Date: Fri, 19 Apr 2013 20:27:27 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>,
        Glauber Costa <glommer@parallels.com>
Subject: [PATCH 06/10] cpuset: re-structure update_cpumask() a bit
References: <517137A7.4020605@huawei.com>
In-Reply-To: <517137A7.4020605@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check if cpus_allowed is to be changed before calling validate_change().

This won't change any behavior, but later it will allow us to do this:

 # mkdir /cpuset/child
 # echo $$ > /cpuset/child/tasks	/* empty cpuset */
 # echo > /cpuset/child/cpuset.cpus	/* do nothing, won't fail */

Without this patch, the last operation will fail.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cpuset.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 2e4c5af..63a5343 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -855,14 +855,15 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 		if (!cpumask_subset(trialcs->cpus_allowed, cpu_active_mask))
 			return -EINVAL;
 	}
-	retval = validate_change(cs, trialcs);
-	if (retval < 0)
-		return retval;
 
 	/* Nothing to do if the cpus didn't change */
 	if (cpumask_equal(cs->cpus_allowed, trialcs->cpus_allowed))
 		return 0;
 
+	retval = validate_change(cs, trialcs);
+	if (retval < 0)
+		return retval;
+
 	retval = heap_init(&heap, PAGE_SIZE, GFP_KERNEL, NULL);
 	if (retval)
 		return retval;
-- 
1.8.0.2
