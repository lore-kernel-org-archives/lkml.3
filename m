Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363Ab3DOBG5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 21:06:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39642 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491Ab3DOBG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 21:06:56 -0400
Date: Sun, 14 Apr 2013 20:06:47 -0500
From: Serge Hallyn <serge.hallyn@ubuntu.com>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, mhocko@suse.cz, vgoyal@redhat.com,
        cgroups@vger.kernel.org
Subject: Re: [PATCH 4/4] memcg: force use_hierarchy if sane_behavior
Message-ID: <20130415010647.GE8408@sergelap>
References: <1365808259-31073-1-git-send-email-tj@kernel.org>
 <1365808259-31073-5-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365808259-31073-5-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Tejun Heo (tj@kernel.org):
> Turn on use_hierarchy by default if sane_behavior is specified and
> don't create .use_hierarchy file.
> 
> It is debatable whether to remove .use_hierarchy file or make it ro as
> the former could make transition easier in certain cases; however, the
> behavior changes which will be gated by sane_behavior are intensive
> including changing basic meaning of certain control knobs in a few
> controllers and I don't really think keeping this piece would make
> things easier in any noticeable way, so let's remove it.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Acked-by: Serge E. Hallyn <serge.hallyn@ubuntu.com>

> Cc: Michal Hocko <mhocko@suse.cz>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
>  include/linux/cgroup.h |  3 +++
>  mm/memcontrol.c        | 13 +++++++++++++
>  2 files changed, 16 insertions(+)
> 
> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> index 9c300ad..c562e33 100644
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -269,6 +269,9 @@ enum {
>  	 *
>  	 * - Remount is disallowed.
>  	 *
> +	 * - memcg: use_hierarchy is on by default and the cgroup file for
> +	 *   the flag is not created.
> +	 *
>  	 * The followings are planned changes.
>  	 *
>  	 * - release_agent will be disallowed once replacement notification
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 9715c0c..a651131 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5814,6 +5814,7 @@ static struct cftype mem_cgroup_files[] = {
>  	},
>  	{
>  		.name = "use_hierarchy",
> +		.flags = CFTYPE_INSANE,
>  		.write_u64 = mem_cgroup_hierarchy_write,
>  		.read_u64 = mem_cgroup_hierarchy_read,
>  	},
> @@ -6784,6 +6785,17 @@ static void mem_cgroup_move_task(struct cgroup *cont,
>  }
>  #endif
>  
> +/*
> + * Cgroup retains root cgroups across [un]mount cycles making it necessary
> + * to verify sane_behavior flag on each mount attempt.
> + */
> +static void mem_cgroup_bind(struct cgroup *root)
> +{
> +	/* use_hierarchy is forced with sane_behavior */
> +	if (cgroup_sane_behavior(root))
> +		mem_cgroup_from_cont(root)->use_hierarchy = true;
> +}
> +
>  struct cgroup_subsys mem_cgroup_subsys = {
>  	.name = "memory",
>  	.subsys_id = mem_cgroup_subsys_id,
> @@ -6794,6 +6806,7 @@ struct cgroup_subsys mem_cgroup_subsys = {
>  	.can_attach = mem_cgroup_can_attach,
>  	.cancel_attach = mem_cgroup_cancel_attach,
>  	.attach = mem_cgroup_move_task,
> +	.bind = mem_cgroup_bind,
>  	.base_cftypes = mem_cgroup_files,
>  	.early_init = 0,
>  	.use_id = 1,
> -- 
> 1.8.1.4
> 
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/containers
