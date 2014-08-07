Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110AbaHGUeP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 16:34:15 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:48326 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399AbaHGUeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 16:34:14 -0400
Date: Thu, 7 Aug 2014 13:34:12 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [patch] mm, hugetlb_cgroup: align hugetlb cgroup limit to hugepage
 size
Message-ID: <alpine.DEB.2.02.1408071333001.1762@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Memcg aligns memory.limit_in_bytes to PAGE_SIZE as part of the resource counter
since it makes no sense to allow a partial page to be charged.

As a result of the hugetlb cgroup using the resource counter, it is also aligned
to PAGE_SIZE but makes no sense unless aligned to the size of the hugepage being
limited.

Align hugetlb cgroup limit to hugepage size.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/hugetlb_cgroup.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
--- a/mm/hugetlb_cgroup.c
+++ b/mm/hugetlb_cgroup.c
@@ -275,6 +275,8 @@ static ssize_t hugetlb_cgroup_write(struct kernfs_open_file *of,
 		ret = res_counter_memparse_write_strategy(buf, &val);
 		if (ret)
 			break;
+		val = ALIGN(val, 1 << (huge_page_order(&hstates[idx]) +
+				       PAGE_SHIFT));
 		ret = res_counter_set_limit(&h_cg->hugepage[idx], val);
 		break;
 	default:
