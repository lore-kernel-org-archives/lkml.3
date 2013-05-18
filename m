Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758868Ab3ERDAi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 23:00:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23572 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758834Ab3ERDAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 23:00:33 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=cBOXrHXFIpsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=-TpmhYGJrAQA:10 a=i0EeH86SAAAA:8 a=VwQbUJbxAAAA:8 a=pO0NnPeHUwSikfYfDcYA:9 a=hPjdaMEvmhQA:10 a=LI9Vle30uBYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021651.104994352@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:16:55 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Li Zefan <lizefan@huawei.com>, Tejun Heo <tj@kernel.org>
Subject: [ 058/136 ] cgroup: fix an off-by-one bug which may trigger BUG_ON()
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0058-cgroup-fix-an-off-by-one-bug-which-may-trigger-BUG_O.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Li Zefan <lizefan@huawei.com>

[ Upstream commit 3ac1707a13a3da9cfc8f242a15b2fae6df2c5f88 ]

The 3rd parameter of flex_array_prealloc() is the number of elements,
not the index of the last element.

The effect of the bug is, when opening cgroup.procs, a flex array will
be allocated and all elements of the array is allocated with
GFP_KERNEL flag, but the last one is GFP_ATOMIC, and if we fail to
allocate memory for it, it'll trigger a BUG_ON().

Signed-off-by: Li Zefan <lizefan@huawei.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/cgroup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index ff2bce5..bfc0578 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2067,7 +2067,7 @@ static int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
 	if (!group)
 		return -ENOMEM;
 	/* pre-allocate to guarantee space while iterating in rcu read-side. */
-	retval = flex_array_prealloc(group, 0, group_size - 1, GFP_KERNEL);
+	retval = flex_array_prealloc(group, 0, group_size, GFP_KERNEL);
 	if (retval)
 		goto out_free_group_list;
 
-- 
1.7.10.4


