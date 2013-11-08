Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932090Ab3KHSn7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 13:43:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4322 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757039Ab3KHSn6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 13:43:58 -0500
Date: Fri, 8 Nov 2013 19:45:15 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Sameer Nanda <snanda@chromium.org>
Cc: akpm@linux-foundation.org, mhocko@suse.cz, rientjes@google.com,
        hannes@cmpxchg.org, rusty@rustcorp.com.au, semenzato@google.com,
        murzin.v@gmail.com, dserrg@gmail.com, msb@chromium.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm, oom: Fix race when selecting process to kill
Message-ID: <20131108184515.GA11555@redhat.com>
References: <alpine.DEB.2.02.1311061631280.22318@chino.kir.corp.google.com> <1383934035-933-1-git-send-email-snanda@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383934035-933-1-git-send-email-snanda@chromium.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry.

I didn't have time to answer other emails, will try to do later.

And yes, yes, while_each_thread() should be fixed, still on my
TODO list... But just in case, whatever we do with while_each_thread()
we should also fix some users.

Until then,

On 11/08, Sameer Nanda wrote:
>
> @@ -412,13 +412,16 @@ void oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
>  	static DEFINE_RATELIMIT_STATE(oom_rs, DEFAULT_RATELIMIT_INTERVAL,
>  					      DEFAULT_RATELIMIT_BURST);
>
> +	read_lock(&tasklist_lock);
> +
>  	/*
>  	 * If the task is already exiting, don't alarm the sysadmin or kill
>  	 * its children or threads, just set TIF_MEMDIE so it can die quickly
>  	 */
> -	if (p->flags & PF_EXITING) {
> +	if (p->flags & PF_EXITING || !pid_alive(p)) {

OK.

> -	read_lock(&tasklist_lock);

But you should also move read_unlock_down(), at least after
find_lock_task_mm().

And of course, this doesn't fix other users in oom_kill.c.

Oleg.

