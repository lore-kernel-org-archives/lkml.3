Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755027AbaIBUTG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 16:19:06 -0400
Received: from mga02.intel.com ([134.134.136.20]:3312 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754728AbaIBUTE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 16:19:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,451,1406617200"; 
   d="scan'208";a="596959007"
Message-ID: <5406262F.4050705@intel.com>
Date: Tue, 02 Sep 2014 13:18:55 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Dave Hansen <dave@sr71.net>, Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>,
        Tejun Heo <tj@kernel.org>, Vladimir Davydov <vdavydov@parallels.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>
Subject: Re: regression caused by cgroups optimization in 3.17-rc2
References: <54061505.8020500@sr71.net>
In-Reply-To: <54061505.8020500@sr71.net>
Content-Type: multipart/mixed;
 boundary="------------020108010704030702030400"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020108010704030702030400
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 09/02/2014 12:05 PM, Dave Hansen wrote:
> It does not revert cleanly because of the hunks below.  The code in
> those hunks was removed, so I tried running without properly merging
> them and it spews warnings because counter->usage is seen going negative.
> 
> So, it doesn't appear we can quickly revert this.

I'm fairly confident that I missed some of the cases (especially in the
charge-moving code), but the attached patch does at least work around
the regression for me.  It restores the original performance, or at
least gets _close_ to it.



--------------020108010704030702030400
Content-Type: text/x-patch;
 name="try-partial-revert-of-root-charge-regression-patch.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="try-partial-revert-of-root-charge-regression-patch.patch"



---

 b/mm/memcontrol.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff -puN mm/memcontrol.c~try-partial-revert-of-root-charge-regression-patch mm/memcontrol.c
--- a/mm/memcontrol.c~try-partial-revert-of-root-charge-regression-patch	2014-09-02 12:20:11.209527453 -0700
+++ b/mm/memcontrol.c	2014-09-02 13:10:28.756736862 -0700
@@ -2534,6 +2534,8 @@ static int try_charge(struct mem_cgroup
 	unsigned long long size;
 	int ret = 0;
 
+	if (mem_cgroup_is_root(memcg))
+		goto done;
 retry:
 	if (consume_stock(memcg, nr_pages))
 		goto done;
@@ -2640,6 +2642,9 @@ static void __mem_cgroup_cancel_local_ch
 {
 	unsigned long bytes = nr_pages * PAGE_SIZE;
 
+	if (mem_cgroup_is_root(memcg))
+		return;
+
 	res_counter_uncharge_until(&memcg->res, memcg->res.parent, bytes);
 	if (do_swap_account)
 		res_counter_uncharge_until(&memcg->memsw,
@@ -6440,6 +6445,9 @@ void mem_cgroup_commit_charge(struct pag
 	VM_BUG_ON_PAGE(!page->mapping, page);
 	VM_BUG_ON_PAGE(PageLRU(page) && !lrucare, page);
 
+	if (mem_cgroup_is_root(memcg))
+		return;
+
 	if (mem_cgroup_disabled())
 		return;
 	/*
@@ -6484,6 +6492,9 @@ void mem_cgroup_cancel_charge(struct pag
 {
 	unsigned int nr_pages = 1;
 
+	if (mem_cgroup_is_root(memcg))
+		return;
+
 	if (mem_cgroup_disabled())
 		return;
 	/*
@@ -6509,6 +6520,9 @@ static void uncharge_batch(struct mem_cg
 {
 	unsigned long flags;
 
+	if (mem_cgroup_is_root(memcg))
+		return;
+
 	if (nr_mem)
 		res_counter_uncharge(&memcg->res, nr_mem * PAGE_SIZE);
 	if (nr_memsw)
_

--------------020108010704030702030400--
