Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751562Ab3LKWX2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 17:23:28 -0500
Received: from mail-yh0-f42.google.com ([209.85.213.42]:38840 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230Ab3LKWXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 17:23:22 -0500
Date: Wed, 11 Dec 2013 14:23:18 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Michal Hocko <mhocko@suse.cz>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] memcg, oom: lock mem_cgroup_print_oom_info
In-Reply-To: <1386776545-24916-1-git-send-email-mhocko@suse.cz>
Message-ID: <alpine.DEB.2.02.1312111421320.7354@chino.kir.corp.google.com>
References: <1386776545-24916-1-git-send-email-mhocko@suse.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Dec 2013, Michal Hocko wrote:

> mem_cgroup_print_oom_info uses a static buffer (memcg_name) to store the
> name of the cgroup. This is not safe as pointed out by David Rientjes
> because memcg oom is locked only for its hierarchy and nothing prevents
> another parallel hierarchy to trigger oom as well and overwrite the
> already in-use buffer.
> 
> This patch introduces oom_info_lock hidden inside mem_cgroup_print_oom_info
> which is held throughout the function. It make access to memcg_name safe
> and as a bonus it also prevents parallel memcg ooms to interleave their
> statistics which would make the printed data hard to analyze otherwise.
> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>

Acked-by: David Rientjes <rientjes@google.com>

> ---
>  mm/memcontrol.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 28c9221b74ea..c72b03bf9679 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1647,13 +1647,13 @@ static void move_unlock_mem_cgroup(struct mem_cgroup *memcg,
>   */
>  void mem_cgroup_print_oom_info(struct mem_cgroup *memcg, struct task_struct *p)
>  {
> -	struct cgroup *task_cgrp;
> -	struct cgroup *mem_cgrp;
>  	/*
> -	 * Need a buffer in BSS, can't rely on allocations. The code relies
> -	 * on the assumption that OOM is serialized for memory controller.
> -	 * If this assumption is broken, revisit this code.
> +	 * protects memcg_name and makes sure that parallel ooms do not
> +	 * interleave

Parallel memcg oom kills can happen in disjoint memcg hierarchies, this 
just prevents the printing of the statistics from interleaving.  I'm not 
sure if that's clear from this comment.
