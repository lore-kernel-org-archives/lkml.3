Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275Ab3H3Hl7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 03:41:59 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:48813 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625Ab3H3Hl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 03:41:57 -0400
Date: Fri, 30 Aug 2013 09:41:52 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Jianguo Wu <wujianguo@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Li Zefan <lizefan@huawei.com>,
        Johannes Weiner <hannes@cmpxchg.org>, tj@kernel.org,
        laijs@cn.fujitsu.com, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Wen Congyang <wency@cn.fujitsu.com>
Subject: Re: [PATCH 5/5] mm/cgroup: use N_MEMORY instead of N_HIGH_MEMORY
Message-ID: <20130830074152.GA28658@dhcp22.suse.cz>
References: <52201539.8050003@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52201539.8050003@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 30-08-13 11:44:57, Jianguo Wu wrote:
> Since commit 8219fc48a(mm: node_states: introduce N_MEMORY),

But this very same commit also says:
"
    A.example 2) mm/page_cgroup.c use N_HIGH_MEMORY twice:
    
        One is in page_cgroup_init(void):
                for_each_node_state(nid, N_HIGH_MEMORY) {
    
        It means if the node have memory, we will allocate page_cgroup map for
        the node. We should use N_MEMORY instead here to gaim more clearly.
    
        The second using is in alloc_page_cgroup():
                if (node_state(nid, N_HIGH_MEMORY))
                        addr = vzalloc_node(size, nid);
    
        It means if the node has high or normal memory that can be allocated
        from kernel. We should keep N_HIGH_MEMORY here, and it will be better
        if the "any memory" semantic of N_HIGH_MEMORY is removed.
"

Which to me sounds like N_HIGH_MEMORY should be kept here. To be honest,
the distinction is not entirely clear to me. It was supposed to make
code cleaner but it apparently causes confusion.

It would also help if you CCed Lai Jiangshan who has introduced this
distinction. CCed now.

I wasn't CCed on the rest of the series but if you do the same
conversion, please make sure that this is not the case for others as
well.

> we introduced N_MEMORY, now N_MEMORY stands for the nodes that has any memory,
> and N_HIGH_MEMORY stands for the nodes that has normal or high memory.
> 
> The code here need to handle with the nodes which have memory,
> we should use N_MEMORY instead.
> 
> Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
> ---
>  mm/page_cgroup.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/page_cgroup.c b/mm/page_cgroup.c
> index 6d757e3..f6f7603 100644
> --- a/mm/page_cgroup.c
> +++ b/mm/page_cgroup.c
> @@ -116,7 +116,7 @@ static void *__meminit alloc_page_cgroup(size_t size, int nid)
>  		return addr;
>  	}
>  
> -	if (node_state(nid, N_HIGH_MEMORY))
> +	if (node_state(nid, N_MEMORY))
>  		addr = vzalloc_node(size, nid);
>  	else
>  		addr = vzalloc(size);
> -- 
> 1.7.1
> 
> 

-- 
Michal Hocko
SUSE Labs
