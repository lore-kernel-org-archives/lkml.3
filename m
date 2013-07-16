Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933909Ab3GPXHD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 19:07:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38446 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933500Ab3GPXG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 19:06:59 -0400
Date: Tue, 16 Jul 2013 16:06:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kamal Mostafa <kamal@canonical.com>
Cc: Michal Hocko <mhocko@suse.cz>, Li Zefan <lizefan@huawei.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, Tejun Heo <tj@kernel.org>,
        Glauber Costa <glommer@openvz.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        kernel-team@lists.ubuntu.com, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [ 3.8.y.z extended stable ] Patch
 "memcg, kmem: fix reference count handling on the error path" has been
 added to staging queue
Message-Id: <20130716160658.fc30d70b5230aab5b3b3950b@linux-foundation.org>
In-Reply-To: <1374015242-28112-1-git-send-email-kamal@canonical.com>
References: <1374015242-28112-1-git-send-email-kamal@canonical.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Jul 2013 15:54:02 -0700 Kamal Mostafa <kamal@canonical.com> wrote:

> This is a note to let you know that I have just added a patch titled
> 
>     memcg, kmem: fix reference count handling on the error path
> 
> to the linux-3.8.y-queue branch of the 3.8.y.z extended stable tree 
> which can be found at:

hm, why.

> From: Michal Hocko <mhocko@suse.cz>
> Date: Mon, 8 Jul 2013 16:00:29 -0700
> Subject: memcg, kmem: fix reference count handling on the error path
> 
> commit f37a96914d1aea10fed8d9af10251f0b9caea31b upstream.
> 
> mem_cgroup_css_online calls mem_cgroup_put if memcg_init_kmem fails.
> This is not correct because only memcg_propagate_kmem takes an
> additional reference while mem_cgroup_sockets_init is allowed to fail as
> well (although no current implementation fails) but it doesn't take any
> reference.  This all suggests that it should be memcg_propagate_kmem
> that should clean up after itself so this patch moves mem_cgroup_put
> over there.
> 
> Unfortunately this is not that easy (as pointed out by Li Zefan) because
> memcg_kmem_mark_dead marks the group dead (KMEM_ACCOUNTED_DEAD) if it is
> marked active (KMEM_ACCOUNTED_ACTIVE) which is the case even if
> memcg_propagate_kmem fails so the additional reference is dropped in
> that case in kmem_cgroup_destroy which means that the reference would be
> dropped two times.
> 
> The easiest way then would be to simply remove mem_cgrroup_put from
> mem_cgroup_css_online and rely on kmem_cgroup_destroy doing the right
> thing.

We were bad.  This changelog failed to describe the userspace-visible
effects of the bug (geeze, how often have I typed that?).  Here we see
a consequence of that failure.

> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -6143,15 +6143,8 @@ mem_cgroup_css_alloc(struct cgroup *cont)
>  	spin_lock_init(&memcg->move_lock);
> 
>  	error = memcg_init_kmem(memcg, &mem_cgroup_subsys);
> -	if (error) {
> -		/*
> -		 * We call put now because our (and parent's) refcnts
> -		 * are already in place. mem_cgroup_put() will internally
> -		 * call __mem_cgroup_free, so return directly
> -		 */
> -		mem_cgroup_put(memcg);
> -		return ERR_PTR(error);
> -	}
> +	if (error)
> +		goto free_out;
>  	return &memcg->css;
>  free_out:
>  	__mem_cgroup_free(memcg);

This fix only fixes things if memcg_init_kmem() fails.  I expect it's
very unlikely that people will see memcg_init_kmem() failures in
practice.



Note to stable tree maintainers: I carefully evaluate every patch I
handle to decide whether or not it should be backported.  Every single
one.

Hence if you decide to backport a patch which I merged, you are
overriding an earlier decision of mine.

Now, I will freely admit that I may have made a mistake.  But please be
aware that you are taking a path which I have already considered and
rejected.  So a little extra care is warranted for akpm patches, please.


