Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031Ab3KIPPc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 10:15:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5378 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753275Ab3KIPPb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 10:15:31 -0500
Date: Sat, 9 Nov 2013 16:16:39 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Sameer Nanda <snanda@chromium.org>
Cc: akpm@linux-foundation.org, mhocko@suse.cz, rientjes@google.com,
        hannes@cmpxchg.org, rusty@rustcorp.com.au, semenzato@google.com,
        murzin.v@gmail.com, dserrg@gmail.com, msb@chromium.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm, oom: Fix race when selecting process to kill
Message-ID: <20131109151639.GB14249@redhat.com>
References: <20131108184515.GA11555@redhat.com> <1383940173-16480-1-git-send-email-snanda@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383940173-16480-1-git-send-email-snanda@chromium.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08, Sameer Nanda wrote:
>
> @@ -413,12 +413,20 @@ void oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
>  					      DEFAULT_RATELIMIT_BURST);
> @@ -456,10 +463,18 @@ void oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
>  			}
>  		}
>  	} while_each_thread(p, t);
> -	read_unlock(&tasklist_lock);
>  
>  	rcu_read_lock();
> +
>  	p = find_lock_task_mm(victim);
> +
> +	/*
> +	 * Since while_each_thread is currently not RCU safe, this unlock of
> +	 * tasklist_lock may need to be moved further down if any additional
> +	 * while_each_thread loops get added to this function.
> +	 */
> +	read_unlock(&tasklist_lock);

Well, ack... but with this change find_lock_task_mm() relies on tasklist,
so it makes sense to move rcu_read_lock() down before for_each_process().
Otherwise this looks confusing, but I won't insist.

Oleg.

