Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933629AbaHHWIB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 18:08:01 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:65282 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932666AbaHHWH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 18:07:56 -0400
Date: Fri, 8 Aug 2014 15:07:53 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [patch v2] mm, hugetlb_cgroup: align hugetlb cgroup limit to hugepage
 size
In-Reply-To: <alpine.DEB.2.02.1408071333001.1762@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.02.1408081507180.15603@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1408071333001.1762@chino.kir.corp.google.com>
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

Acked-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 v2: use huge_page_order() per Aneesh
     Sorry for not cc'ing you initially, get_maintainer.pl failed me

 mm/hugetlb_cgroup.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
--- a/mm/hugetlb_cgroup.c
+++ b/mm/hugetlb_cgroup.c
@@ -275,6 +275,7 @@ static ssize_t hugetlb_cgroup_write(struct kernfs_open_file *of,
 		ret = res_counter_memparse_write_strategy(buf, &val);
 		if (ret)
 			break;
+		val = ALIGN(val, 1ULL << huge_page_shift(&hstates[idx]));
 		ret = res_counter_set_limit(&h_cg->hugepage[idx], val);
 		break;
 	default:
