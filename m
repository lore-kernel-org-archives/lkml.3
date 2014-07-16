Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755812AbaGPJoz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 05:44:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49017 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751272AbaGPJow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 05:44:52 -0400
Date: Wed, 16 Jul 2014 11:44:49 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>, Vivek Goyal <vgoyal@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Aristeu Rozanski <aris@redhat.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/6] cgroup: rename cgroup_subsys->base_cftypes to
 ->legacy_cftypes
Message-ID: <20140716094449.GF7121@dhcp22.suse.cz>
References: <1405352648-4279-1-git-send-email-tj@kernel.org>
 <1405352648-4279-3-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405352648-4279-3-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 14-07-14 11:44:04, Tejun Heo wrote:
> Currently, cgroup_subsys->base_cftypes is used for both the unified
> default hierarchy and legacy ones and subsystems can mark each file
> with either CFTYPE_ONLY_ON_DFL or CFTYPE_INSANE if it has to appear
> only on one of them.  This is quite hairy and error-prone.  Also, we
> may end up exposing interface files to the default hierarchy without
> thinking it through.
> 
> cgroup_subsys will grow two separate cftype arrays and apply each only
> on the hierarchies of the matching type.  This will allow organizing
> cftypes in a lot clearer way and encourage subsystems to scrutinize
> the interface which is being exposed in the new default hierarchy.
> 
> In preparation, this patch renames cgroup_subsys->base_cftypes to
> cgroup_subsys->legacy_cftypes.  This patch is pure rename.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Acked-by: Neil Horman <nhorman@tuxdriver.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@suse.cz>
> Cc: Li Zefan <lizefan@huawei.com>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
> Cc: Aristeu Rozanski <aris@redhat.com>
> Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

OK so the transition to the default hierarchy will be opt-in rather than
opt-out which I originally expected. Will have a look and prepare the
core files which should stay and post the patch soon hopefully.

Acked-by: Michal Hocko <mhocko@suse.cz>

> ---
>  block/blk-cgroup.c           | 2 +-
>  include/linux/cgroup.h       | 2 +-
>  kernel/cgroup.c              | 4 ++--
>  kernel/cgroup_freezer.c      | 2 +-
>  kernel/cpuset.c              | 2 +-
>  kernel/sched/core.c          | 2 +-
>  kernel/sched/cpuacct.c       | 2 +-
>  mm/memcontrol.c              | 2 +-
>  net/core/netclassid_cgroup.c | 2 +-
>  net/core/netprio_cgroup.c    | 2 +-
>  security/device_cgroup.c     | 2 +-
>  11 files changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> index 63c3cd4..5cfbc72 100644
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -924,7 +924,7 @@ struct cgroup_subsys blkio_cgrp_subsys = {
>  	.css_offline = blkcg_css_offline,
>  	.css_free = blkcg_css_free,
>  	.can_attach = blkcg_can_attach,
> -	.base_cftypes = blkcg_files,
> +	.legacy_cftypes = blkcg_files,
>  #ifdef CONFIG_MEMCG
>  	/*
>  	 * This ensures that, if available, memcg is automatically enabled
> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> index 7bb2744..a6e9c2e 100644
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -672,7 +672,7 @@ struct cgroup_subsys {
>  	struct list_head cfts;
>  
>  	/* base cftypes, automatically registered with subsys itself */
> -	struct cftype *base_cftypes;
> +	struct cftype *legacy_cftypes;	/* used on the legacy hierarchies */
>  
>  	/*
>  	 * A subsystem may depend on other subsystems.  When such subsystem
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 7e5fee5..6496a83 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -4890,7 +4890,7 @@ int __init cgroup_init(void)
>  		 */
>  		if (!ss->disabled) {
>  			cgrp_dfl_root.subsys_mask |= 1 << ss->id;
> -			WARN_ON(cgroup_add_cftypes(ss, ss->base_cftypes));
> +			WARN_ON(cgroup_add_cftypes(ss, ss->legacy_cftypes));
>  		}
>  	}
>  
> @@ -5480,6 +5480,6 @@ static struct cftype debug_files[] =  {
>  struct cgroup_subsys debug_cgrp_subsys = {
>  	.css_alloc = debug_css_alloc,
>  	.css_free = debug_css_free,
> -	.base_cftypes = debug_files,
> +	.legacy_cftypes = debug_files,
>  };
>  #endif /* CONFIG_CGROUP_DEBUG */
> diff --git a/kernel/cgroup_freezer.c b/kernel/cgroup_freezer.c
> index a79e40f..92b98cc 100644
> --- a/kernel/cgroup_freezer.c
> +++ b/kernel/cgroup_freezer.c
> @@ -480,5 +480,5 @@ struct cgroup_subsys freezer_cgrp_subsys = {
>  	.css_free	= freezer_css_free,
>  	.attach		= freezer_attach,
>  	.fork		= freezer_fork,
> -	.base_cftypes	= files,
> +	.legacy_cftypes	= files,
>  };
> diff --git a/kernel/cpuset.c b/kernel/cpuset.c
> index 53a9bbf..f337f42 100644
> --- a/kernel/cpuset.c
> +++ b/kernel/cpuset.c
> @@ -2036,7 +2036,7 @@ struct cgroup_subsys cpuset_cgrp_subsys = {
>  	.cancel_attach	= cpuset_cancel_attach,
>  	.attach		= cpuset_attach,
>  	.bind		= cpuset_bind,
> -	.base_cftypes	= files,
> +	.legacy_cftypes	= files,
>  	.early_init	= 1,
>  };
>  
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 3bdf01b..6628e80 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -8088,7 +8088,7 @@ struct cgroup_subsys cpu_cgrp_subsys = {
>  	.can_attach	= cpu_cgroup_can_attach,
>  	.attach		= cpu_cgroup_attach,
>  	.exit		= cpu_cgroup_exit,
> -	.base_cftypes	= cpu_files,
> +	.legacy_cftypes	= cpu_files,
>  	.early_init	= 1,
>  };
>  
> diff --git a/kernel/sched/cpuacct.c b/kernel/sched/cpuacct.c
> index 9cf350c..dd7cbb5 100644
> --- a/kernel/sched/cpuacct.c
> +++ b/kernel/sched/cpuacct.c
> @@ -278,6 +278,6 @@ void cpuacct_account_field(struct task_struct *p, int index, u64 val)
>  struct cgroup_subsys cpuacct_cgrp_subsys = {
>  	.css_alloc	= cpuacct_css_alloc,
>  	.css_free	= cpuacct_css_free,
> -	.base_cftypes	= files,
> +	.legacy_cftypes	= files,
>  	.early_init	= 1,
>  };
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index a2a4bd6..8331f27 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -7048,7 +7048,7 @@ struct cgroup_subsys memory_cgrp_subsys = {
>  	.cancel_attach = mem_cgroup_cancel_attach,
>  	.attach = mem_cgroup_move_task,
>  	.bind = mem_cgroup_bind,
> -	.base_cftypes = mem_cgroup_files,
> +	.legacy_cftypes = mem_cgroup_files,
>  	.early_init = 0,
>  };
>  
> diff --git a/net/core/netclassid_cgroup.c b/net/core/netclassid_cgroup.c
> index 30d903b..1f2a126 100644
> --- a/net/core/netclassid_cgroup.c
> +++ b/net/core/netclassid_cgroup.c
> @@ -107,5 +107,5 @@ struct cgroup_subsys net_cls_cgrp_subsys = {
>  	.css_online		= cgrp_css_online,
>  	.css_free		= cgrp_css_free,
>  	.attach			= cgrp_attach,
> -	.base_cftypes		= ss_files,
> +	.legacy_cftypes		= ss_files,
>  };
> diff --git a/net/core/netprio_cgroup.c b/net/core/netprio_cgroup.c
> index 2f385b9..cbd0a19 100644
> --- a/net/core/netprio_cgroup.c
> +++ b/net/core/netprio_cgroup.c
> @@ -249,7 +249,7 @@ struct cgroup_subsys net_prio_cgrp_subsys = {
>  	.css_online	= cgrp_css_online,
>  	.css_free	= cgrp_css_free,
>  	.attach		= net_prio_attach,
> -	.base_cftypes	= ss_files,
> +	.legacy_cftypes	= ss_files,
>  };
>  
>  static int netprio_device_event(struct notifier_block *unused,
> diff --git a/security/device_cgroup.c b/security/device_cgroup.c
> index d9d69e6..188c1d2 100644
> --- a/security/device_cgroup.c
> +++ b/security/device_cgroup.c
> @@ -796,7 +796,7 @@ struct cgroup_subsys devices_cgrp_subsys = {
>  	.css_free = devcgroup_css_free,
>  	.css_online = devcgroup_online,
>  	.css_offline = devcgroup_offline,
> -	.base_cftypes = dev_cgroup_files,
> +	.legacy_cftypes = dev_cgroup_files,
>  };
>  
>  /**
> -- 
> 1.9.3
> 

-- 
Michal Hocko
SUSE Labs
