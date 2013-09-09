Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956Ab3IIQh1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 12:37:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14696 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751792Ab3IIQh0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 12:37:26 -0400
Date: Mon, 9 Sep 2013 18:31:09 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Sergey Dyasly <dserrg@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Michal Hocko <mhocko@suse.cz>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Sha Zhengju <handai.szj@taobao.com>
Subject: Re: [PATCH] OOM killer: wait for tasks with pending SIGKILL to exit
Message-ID: <20130909163109.GA9334@redhat.com>
References: <1378740624-2456-1-git-send-email-dserrg@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378740624-2456-1-git-send-email-dserrg@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can't really comment this patch, just one off-topic note...

On 09/09, Sergey Dyasly wrote:
>
> @@ -275,13 +275,16 @@ enum oom_scan_t oom_scan_process_thread(struct task_struct *task,
>  	if (oom_task_origin(task))
>  		return OOM_SCAN_SELECT;
>  
> -	if (task->flags & PF_EXITING && !force_kill) {
> +	if ((task->flags & PF_EXITING || fatal_signal_pending(task)) &&
> +	    !force_kill) {
>  		/*
>  		 * If this task is not being ptraced on exit, then wait for it
>  		 * to finish before killing some other task unnecessarily.
>  		 */
> -		if (!(task->group_leader->ptrace & PT_TRACE_EXIT))
> +		if (!(task->group_leader->ptrace & PT_TRACE_EXIT)) {

can't we finally kill (or fix?) this PT_TRACE_EXIT check?

It was added to fix the exploit I sent. But the patch was wrong,
that exploit could be easily modified to trigger the same problem.

However, now that the coredumping is killable that exploit won't
work, so the original reason has gone away.

So why do we need this check today?

And note that we check ->group_leader, this looks completely wrong.
(again, ->group_leader was used just because the original exploit
 traced the group leader).

David?

Oleg.

