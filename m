Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717AbaIBPdH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 11:33:07 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:33783 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753880AbaIBPdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 11:33:05 -0400
Date: Tue, 2 Sep 2014 11:33:01 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
        LKML <linux-kernel@vger.kernel.org>, cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH 1/2] cgroup: Delay the clearing of cgrp->kn->priv
Message-ID: <20140902153301.GA17424@htj.dyndns.org>
References: <5405A27A.3090605@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5405A27A.3090605@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Li.

On Tue, Sep 02, 2014 at 06:56:58PM +0800, Li Zefan wrote:
>     for ((; ;))
>     {
>         echo $$ > /cgroup/sub/cgroup.procs
>         ech $$ > /cgce 6f2e0c38c2108a74 ]---
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
          copy & paste error?
...
> Reported-by: Toralf Förster <toralf.foerster@gmx.de>
> Signed-off-by: Li Zefan <lizefan@huawei.com>
> ---
> 
> Toralf, Thanks for reporting the bug. I'm not able to repy to your email,
> because I was kicked out of the cgroup mailing list so didn't receive
> emails from mailing list for a week.
> 
> ---
>  kernel/cgroup.c | 19 +++++++++----------
>  1 file changed, 9 insertions(+), 10 deletions(-)
> 
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 1c56924..e03fc62 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -4185,6 +4185,15 @@ static void css_release_work_fn(struct work_struct *work)
>  
>  	mutex_unlock(&cgroup_mutex);
>  
> +	/*
> +	 * There are two control paths which try to determine cgroup from
> +	 * dentry without going through kernfs - cgroupstats_build() and
> +	 * css_tryget_online_from_dir().  Those are supported by RCU
> +	 * protecting clearing of cgrp->kn->priv backpointer.
> +	 */
> +	if (!ss && cgroup_parent(cgrp))
> +		RCU_INIT_POINTER(*(void __rcu __force **)&cgrp->kn->priv, NULL);

Can we move the above into the preceding else block?  I don't think
holding cgroup_mutex or not makes any difference here.  Also, why do
we need the cgroup_parent() check?  Do we deref root's kn->priv in the
destruction path?  If so, can you please note that in the comment?

Thanks.

-- 
tejun
