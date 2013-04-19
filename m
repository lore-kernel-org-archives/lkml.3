Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450Ab3DSU61 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 16:58:27 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:37350 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071Ab3DSU6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 16:58:25 -0400
Date: Fri, 19 Apr 2013 13:58:21 -0700
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>,
        Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH 09/10] cpuset: allow to keep tasks in empty cpusets
Message-ID: <20130419205821.GA15543@mtj.dyndns.org>
References: <517137A7.4020605@huawei.com>
 <517138A4.3070209@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <517138A4.3070209@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Apr 19, 2013 at 08:29:24PM +0800, Li Zefan wrote:
> +static void update_tasks_cpumask_hier(struct cpuset *root_cs,
> +				      bool update_root, struct ptr_heap *heap)
> +{
> +	struct cpuset *cp;
> +	struct cgroup *pos_cgrp;
> +
> +	if (update_root)
> +		update_tasks_cpumask(root_cs, heap);
> +
> +	rcu_read_lock();
> +	cpuset_for_each_descendant_pre(cp, pos_cgrp, root_cs) {
> +		/* skip the whole subtree if @cp have some CPU */
> +		if (!cpumask_empty(cp->cpus_allowed)) {
> +			pos_cgrp = cgroup_rightmost_descendant(pos_cgrp);
> +			continue;
> +		}
> +
> +		update_tasks_cpumask(cp, heap);
> +	}
> +	rcu_read_unlock();

I don't think we can call update_tasks_cpumask() under
rcu_read_lock().  It calls into set_cpus_allowed_ptr() which may
block, so you'll probably have to punt it to a work item like how
migration is being done.  Another approach would be converting cgroup
to use SRCU instead, which would lessen pain on other places too.  The
only problem there would be that srcu_read_lock() is a bit more
expensive than rcu_read_lock().  I'm not sure whether that'd show up
in some hot path or not.  Ideas?

Thanks.

-- 
tejun
