Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757343Ab3DAFh4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 01:37:56 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38121 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107Ab3DAFhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 01:37:55 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <51591D21.8090401@jp.fujitsu.com>
Date: Mon, 01 Apr 2013 14:37:37 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] mm, memcg: give exiting processes access to memory reserves
References: <alpine.DEB.2.02.1303271821120.5005@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1303271821120.5005@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/03/28 10:22), David Rientjes wrote:
> A memcg may livelock when oom if the process that grabs the hierarchy's
> oom lock is never the first process with PF_EXITING set in the memcg's
> task iteration.
>
> The oom killer, both global and memcg, will defer if it finds an eligible
> process that is in the process of exiting and it is not being ptraced.
> The idea is to allow it to exit without using memory reserves before
> needlessly killing another process.
>
> This normally works fine except in the memcg case with a large number of
> threads attached to the oom memcg.  In this case, the memcg oom killer
> only gets called for the process that grabs the hierarchy's oom lock; all
> others end up blocked on the memcg's oom waitqueue.  Thus, if the process
> that grabs the hierarchy's oom lock is never the first PF_EXITING process
> in the memcg's task iteration, the oom killer is constantly deferred
> without anything making progress.
>
> The fix is to give PF_EXITING processes access to memory reserves so that
> we've marked them as oom killed without any iteration.  This allows
> __mem_cgroup_try_charge() to succeed so that the process may exit.  This
> makes the memcg oom killer exemption for TIF_MEMDIE tasks, now
> immediately granted for processes with pending SIGKILLs and those in the
> exit path, to be equivalent to what is done for the global oom killer.
>
> Signed-off-by: David Rientjes <rientjes@google.com>


Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

> ---
>   mm/memcontrol.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1686,11 +1686,11 @@ static void mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
>   	struct task_struct *chosen = NULL;
>
>   	/*
> -	 * If current has a pending SIGKILL, then automatically select it.  The
> -	 * goal is to allow it to allocate so that it may quickly exit and free
> -	 * its memory.
> +	 * If current has a pending SIGKILL or is exiting, then automatically
> +	 * select it.  The goal is to allow it to allocate so that it may
> +	 * quickly exit and free its memory.
>   	 */
> -	if (fatal_signal_pending(current)) {
> +	if (fatal_signal_pending(current) || current->flags & PF_EXITING) {
>   		set_thread_flag(TIF_MEMDIE);
>   		return;
>   	}
>


