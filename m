Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124Ab3HBNKg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 09:10:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46599 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751336Ab3HBNKe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 09:10:34 -0400
Date: Fri, 2 Aug 2013 15:10:29 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 04/23] hugetlb_cgroup: pass around @hugetlb_cgroup
 instead of @cgroup
Message-ID: <20130802131029.GA25432@dhcp22.suse.cz>
References: <1375393801-4817-1-git-send-email-tj@kernel.org>
 <1375393801-4817-5-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375393801-4817-5-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 01-08-13 17:49:42, Tejun Heo wrote:
> cgroup controller API will be converted to primarily use struct
> cgroup_subsys_state instead of struct cgroup.  In preparation, make
> hugetlb_cgroup functions pass around struct hugetlb_cgroup instead of
> struct cgroup.
> 
> This patch shouldn't cause any behavior differences.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Michal Hocko <mhocko@suse.cz>
> Cc: Johannes Weiner <hannes@cmpxchg.org>

Reviewed-by: Michal Hocko <mhocko@suse.cz>

> ---
>  mm/hugetlb_cgroup.c | 22 ++++++++++++----------
>  1 file changed, 12 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
> index 50f213f..d2f9fc0 100644
> --- a/mm/hugetlb_cgroup.c
> +++ b/mm/hugetlb_cgroup.c
> @@ -56,17 +56,19 @@ static inline bool hugetlb_cgroup_is_root(struct hugetlb_cgroup *h_cg)
>  	return (h_cg == root_h_cgroup);
>  }
>  
> -static inline struct hugetlb_cgroup *parent_hugetlb_cgroup(struct cgroup *cg)
> +static inline struct hugetlb_cgroup *
> +parent_hugetlb_cgroup(struct hugetlb_cgroup *h_cg)
>  {
> -	if (!cg->parent)
> +	struct cgroup *parent = h_cg->css.cgroup->parent;
> +
> +	if (!parent)
>  		return NULL;
> -	return hugetlb_cgroup_from_cgroup(cg->parent);
> +	return hugetlb_cgroup_from_cgroup(parent);
>  }
>  
> -static inline bool hugetlb_cgroup_have_usage(struct cgroup *cg)
> +static inline bool hugetlb_cgroup_have_usage(struct hugetlb_cgroup *h_cg)
>  {
>  	int idx;
> -	struct hugetlb_cgroup *h_cg = hugetlb_cgroup_from_cgroup(cg);
>  
>  	for (idx = 0; idx < hugetlb_max_hstate; idx++) {
>  		if ((res_counter_read_u64(&h_cg->hugepage[idx], RES_USAGE)) > 0)
> @@ -115,15 +117,14 @@ static void hugetlb_cgroup_css_free(struct cgroup *cgroup)
>   * page reference and test for page active here. This function
>   * cannot fail.
>   */
> -static void hugetlb_cgroup_move_parent(int idx, struct cgroup *cgroup,
> +static void hugetlb_cgroup_move_parent(int idx, struct hugetlb_cgroup *h_cg,
>  				       struct page *page)
>  {
>  	int csize;
>  	struct res_counter *counter;
>  	struct res_counter *fail_res;
>  	struct hugetlb_cgroup *page_hcg;
> -	struct hugetlb_cgroup *h_cg   = hugetlb_cgroup_from_cgroup(cgroup);
> -	struct hugetlb_cgroup *parent = parent_hugetlb_cgroup(cgroup);
> +	struct hugetlb_cgroup *parent = parent_hugetlb_cgroup(h_cg);
>  
>  	page_hcg = hugetlb_cgroup_from_page(page);
>  	/*
> @@ -155,6 +156,7 @@ out:
>   */
>  static void hugetlb_cgroup_css_offline(struct cgroup *cgroup)
>  {
> +	struct hugetlb_cgroup *h_cg = hugetlb_cgroup_from_cgroup(cgroup);
>  	struct hstate *h;
>  	struct page *page;
>  	int idx = 0;
> @@ -163,13 +165,13 @@ static void hugetlb_cgroup_css_offline(struct cgroup *cgroup)
>  		for_each_hstate(h) {
>  			spin_lock(&hugetlb_lock);
>  			list_for_each_entry(page, &h->hugepage_activelist, lru)
> -				hugetlb_cgroup_move_parent(idx, cgroup, page);
> +				hugetlb_cgroup_move_parent(idx, h_cg, page);
>  
>  			spin_unlock(&hugetlb_lock);
>  			idx++;
>  		}
>  		cond_resched();
> -	} while (hugetlb_cgroup_have_usage(cgroup));
> +	} while (hugetlb_cgroup_have_usage(h_cg));
>  }
>  
>  int hugetlb_cgroup_charge_cgroup(int idx, unsigned long nr_pages,
> -- 
> 1.8.3.1
> 

-- 
Michal Hocko
SUSE Labs
