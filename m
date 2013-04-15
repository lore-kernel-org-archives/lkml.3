Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993Ab3DOOm7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 10:42:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45134 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751335Ab3DOOm5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 10:42:57 -0400
Date: Mon, 15 Apr 2013 07:42:51 -0700
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com,
        linux-kernel@vger.kernel.org, glommer@parallels.com, vgoyal@redhat.com
Subject: Re: [PATCH 4/4] memcg: force use_hierarchy if sane_behavior
Message-ID: <20130415144251.GC13662@dhcp22.suse.cz>
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

On Fri 12-04-13 16:10:59, Tejun Heo wrote:
> Turn on use_hierarchy by default if sane_behavior is specified and
> don't create .use_hierarchy file.
> 
> It is debatable whether to remove .use_hierarchy file or make it ro as
> the former could make transition easier in certain cases; however, the
> behavior changes which will be gated by sane_behavior are intensive
> including changing basic meaning of certain control knobs in a few
> controllers and I don't really think keeping this piece would make
> things easier in any noticeable way, so let's remove it.

OK, as the feature has to be enabled explicitly I do not mind not
exporting the file.
I have one nit though. Can we extend the comment for mem_cgroup_bind
that it doesn't have to care about children because there are none
because rebind_subsystems wouldn't allow remounting otherwise?
It wasn't obvious, at least from me.

Other than that.
Acked-by: Michal Hocko <mhocko@suse.cz>

Thanks!

> Signed-off-by: Tejun Heo <tj@kernel.org>
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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Michal Hocko
SUSE Labs
