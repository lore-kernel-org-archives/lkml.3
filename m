Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757140Ab3EJOxh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:53:37 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56844 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753656Ab3EJOTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:19:37 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Tejun Heo" <tj@kernel.org>,
        "Li Zefan" <lizefan@huawei.com>
Date: Fri, 10 May 2013 14:39:41 +0100
Message-ID: <lsq.1368193181.351454482@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [009/118] cgroup: fix an off-by-one bug which may trigger BUG_ON()
In-Reply-To: <lsq.1368193179.973009354@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d51a:8785:aa0a:cebe
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.45-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Li Zefan <lizefan@huawei.com>

commit 3ac1707a13a3da9cfc8f242a15b2fae6df2c5f88 upstream.

The 3rd parameter of flex_array_prealloc() is the number of elements,
not the index of the last element.

The effect of the bug is, when opening cgroup.procs, a flex array will
be allocated and all elements of the array is allocated with
GFP_KERNEL flag, but the last one is GFP_ATOMIC, and if we fail to
allocate memory for it, it'll trigger a BUG_ON().

Signed-off-by: Li Zefan <lizefan@huawei.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/cgroup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2029,7 +2029,7 @@ int cgroup_attach_proc(struct cgroup *cg
 	if (!group)
 		return -ENOMEM;
 	/* pre-allocate to guarantee space while iterating in rcu read-side. */
-	retval = flex_array_prealloc(group, 0, group_size - 1, GFP_KERNEL);
+	retval = flex_array_prealloc(group, 0, group_size, GFP_KERNEL);
 	if (retval)
 		goto out_free_group_list;
 

