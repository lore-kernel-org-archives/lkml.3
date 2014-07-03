Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684AbaGCMtu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 08:49:50 -0400
Received: from mx2.parallels.com ([199.115.105.18]:53626 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756492AbaGCMtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 08:49:47 -0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-mm@kvack.org>, <cgroups@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Hugh Dickins <hughd@google.com>, David Rientjes <rientjes@google.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Balbir Singh <bsingharora@gmail.com>
Subject: [PATCH RFC 5/5] vm_cgroup: do not charge tasks in root cgroup
Date: Thu, 3 Jul 2014 16:48:21 +0400
Message-ID: <e97d260eecc1a5f01a900996ae12cc265b6023c7.1404383187.git.vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1404383187.git.vdavydov@parallels.com>
References: <cover.1404383187.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the root cgroup (the whole system), we already have overcommit
accounting and control, so we can skip charging tasks in the root cgroup
to avoid overhead.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
---
 mm/vm_cgroup.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/mm/vm_cgroup.c b/mm/vm_cgroup.c
index 6642f934540a..c871fecaab4c 100644
--- a/mm/vm_cgroup.c
+++ b/mm/vm_cgroup.c
@@ -1,6 +1,7 @@
 #include <linux/cgroup.h>
 #include <linux/res_counter.h>
 #include <linux/mm.h>
+#include <linux/mman.h>
 #include <linux/slab.h>
 #include <linux/rcupdate.h>
 #include <linux/shmem_fs.h>
@@ -65,6 +66,9 @@ static int vm_cgroup_do_charge(struct vm_cgroup *vmcg,
 	unsigned long val = nr_pages << PAGE_SHIFT;
 	struct res_counter *fail_res;
 
+	if (vm_cgroup_is_root(vmcg))
+		return 0;
+
 	return res_counter_charge(&vmcg->res, val, &fail_res);
 }
 
@@ -73,6 +77,9 @@ static void vm_cgroup_do_uncharge(struct vm_cgroup *vmcg,
 {
 	unsigned long val = nr_pages << PAGE_SHIFT;
 
+	if (vm_cgroup_is_root(vmcg))
+		return;
+
 	res_counter_uncharge(&vmcg->res, val);
 }
 
@@ -159,6 +166,9 @@ static u64 vm_cgroup_read_u64(struct cgroup_subsys_state *css,
 	struct vm_cgroup *vmcg = vm_cgroup_from_css(css);
 	int memb = cft->private;
 
+	if (vm_cgroup_is_root(vmcg))
+		return vm_memory_committed() << PAGE_SHIFT;
+
 	return res_counter_read_u64(&vmcg->res, memb);
 }
 
-- 
1.7.10.4

