Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640AbaGNCOb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 22:14:31 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:30346 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194AbaGNCOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 22:14:23 -0400
Message-ID: <53C33CC7.3020707@huawei.com>
Date: Mon, 14 Jul 2014 10:13:27 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Vivek Goyal <vgoyal@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Aristeu Rozanski <aris@redhat.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 4/5] cgroup: distinguish the default and legacy hierarchies
 when handling cftypes
References: <1404345055-8196-1-git-send-email-tj@kernel.org> <1404345055-8196-5-git-send-email-tj@kernel.org>
In-Reply-To: <1404345055-8196-5-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -3085,8 +3091,37 @@ static int cgroup_add_cftypes(struct cgroup_subsys *ss, struct cftype *cfts)
>  	return ret;
>  }
>  
> +/**
> + * cgroup_add_dfl_cftypes - add an array of cftypes for default hierarchy
> + * @ss: target cgroup subsystem
> + * @cfts: zero-length name terminated array of cftypes
> + *
> + * Similar to cgroup_add_cftypes() but the added files are only used for
> + * the default hierarchy.
> + */
> +int cgroup_add_dfl_cftypes(struct cgroup_subsys *ss, struct cftype *cfts)
> +{
> +	struct cftype *cft;
> +
> +	for (cft = cfts; cft && cft->name[0] != '\0'; cft++)
> +		cft->flags |= CFTYPE_ONLY_ON_DFL;

I think we should remove this flag in cgroup_rm_cftypes_locked(). Otherwise
if we call cgroup_add_dlf_cftypes() and then cgroup_rm_cftypes() and then
cgroup_add_legacy_cftypes() for the same @cfts, both CFTYPE_ONLY_ON_DFL and
CFTYPE_INSANE are set.

> +	return cgroup_add_cftypes(ss, cfts);
> +}
> +
> +/**
> + * cgroup_add_legacy_cftypes - add an array of cftypes for legacy hierarchies
> + * @ss: target cgroup subsystem
> + * @cfts: zero-length name terminated array of cftypes
> + *
> + * Similar to cgroup_add_cftypes() but the added files are only used for
> + * the legacy hierarchies.
> + */
>  int cgroup_add_legacy_cftypes(struct cgroup_subsys *ss, struct cftype *cfts)
>  {
> +	struct cftype *cft;
> +
> +	for (cft = cfts; cft && cft->name[0] != '\0'; cft++)
> +		cft->flags |= CFTYPE_INSANE;
>  	return cgroup_add_cftypes(ss, cfts);
>  }

