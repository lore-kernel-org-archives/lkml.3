Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792Ab3FEJQ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 05:16:58 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:62541 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753719Ab3FEJQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 05:16:56 -0400
Message-ID: <51AF01CF.1070706@huawei.com>
Date: Wed, 5 Jun 2013 17:15:59 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>
Subject: [PATCH v2 05/10] cpuset: re-structure update_cpumask() a bit
References: <51AF0183.8070602@huawei.com>
In-Reply-To: <51AF0183.8070602@huawei.com>
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
index 51f8e1d..535dce6 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -856,14 +856,15 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
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
