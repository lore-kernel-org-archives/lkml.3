Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504AbaE0WBD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 18:01:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54773 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716AbaE0WBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 18:01:02 -0400
Date: Tue, 27 May 2014 15:01:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hugh Dickins <hughd@google.com>
Cc: Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH mmotm/next]
 memcg-mm-introduce-lowlimit-reclaim-fix2.patch
Message-Id: <20140527150100.70f6c7cf93d27d58c8f5eb48@linux-foundation.org>
In-Reply-To: <alpine.LSU.2.11.1405271432400.4485@eggly.anvils>
References: <alpine.LSU.2.11.1405271432400.4485@eggly.anvils>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 May 2014 14:36:04 -0700 (PDT) Hugh Dickins <hughd@google.com> wrote:

> mem_cgroup_within_guarantee() oopses in _raw_spin_lock_irqsave() when
> booted with cgroup_disable=memory.  Fix that in the obvious inelegant
> way for now - though I hope we are moving towards a world in which
> almost all of the mem_cgroup_disabled() tests will vanish, with a
> root_mem_cgroup which can handle the basics even when disabled.
> 
> I bet there's a neater way of doing this, rearranging the loop (and we
> shall want to avoid spinlocking on root_mem_cgroup when we reach that
> new world), but that's the kind of thing I'd get wrong in a hurry!
> 
> ...
>
> @@ -2793,6 +2793,9 @@ static struct mem_cgroup *mem_cgroup_loo
>  bool mem_cgroup_within_guarantee(struct mem_cgroup *memcg,
>  		struct mem_cgroup *root)
>  {
> +	if (mem_cgroup_disabled())
> +		return false;
> +
>  	do {
>  		if (!res_counter_low_limit_excess(&memcg->res))
>  			return true;

This seems to be an awfully late and deep place at which to be noticing
mem_cgroup_disabled().  Should mem_cgroup_within_guarantee() even be called
in this state?
