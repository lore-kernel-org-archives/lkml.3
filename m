Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511AbaJGPVv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 11:21:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52676 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753122AbaJGPVt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 11:21:49 -0400
Date: Tue, 7 Oct 2014 17:21:49 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, Vladimir Davydov <vdavydov@parallels.com>,
        Greg Thelen <gthelen@google.com>, Dave Hansen <dave@sr71.net>,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/3] mm: hugetlb_controller: convert to lockless page
 counters
Message-ID: <20141007152149.GF14243@dhcp22.suse.cz>
References: <1411573390-9601-1-git-send-email-hannes@cmpxchg.org>
 <1411573390-9601-3-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411573390-9601-3-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 24-09-14 11:43:09, Johannes Weiner wrote:
> Abandon the spinlock-protected byte counters in favor of the unlocked
> page counters in the hugetlb controller as well.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

One minor thing below:
Acked-by: Michal Hocko <mhocko@suse.cz>

[...]
>  static ssize_t hugetlb_cgroup_write(struct kernfs_open_file *of,
>  				    char *buf, size_t nbytes, loff_t off)
>  {
> -	int idx, name, ret;
> -	unsigned long long val;
> +	int ret, idx;
> +	unsigned long nr_pages;
>  	struct hugetlb_cgroup *h_cg = hugetlb_cgroup_from_css(of_css(of));
>  
> +	if (hugetlb_cgroup_is_root(h_cg)) /* Can't set limit on root */
> +		return -EINVAL;
> +
>  	buf = strstrip(buf);
> +	ret = page_counter_memparse(buf, &nr_pages);
> +	if (ret)
> +		return ret;
> +
>  	idx = MEMFILE_IDX(of_cft(of)->private);
> -	name = MEMFILE_ATTR(of_cft(of)->private);
>  
> -	switch (name) {
> +	switch (MEMFILE_ATTR(of_cft(of)->private)) {
>  	case RES_LIMIT:
> -		if (hugetlb_cgroup_is_root(h_cg)) {
> -			/* Can't set limit on root */
> -			ret = -EINVAL;
> -			break;
> -		}
> -		/* This function does all necessary parse...reuse it */
> -		ret = res_counter_memparse_write_strategy(buf, &val);
> -		if (ret)
> -			break;
> -		val = ALIGN(val, 1ULL << huge_page_shift(&hstates[idx]));
> -		ret = res_counter_set_limit(&h_cg->hugepage[idx], val);
> +		nr_pages = ALIGN(nr_pages, 1UL<<huge_page_order(&hstates[idx]));

memcg doesn't round up to the next page so I guess we do not have to do
it here as well.

> +		mutex_lock(&hugetlb_limit_mutex);
> +		ret = page_counter_limit(&h_cg->hugepage[idx], nr_pages);
> +		mutex_unlock(&hugetlb_limit_mutex);
>  		break;
>  	default:
>  		ret = -EINVAL;
[...]
-- 
Michal Hocko
SUSE Labs
