Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422667Ab3BOOyp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 09:54:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60427 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934192Ab3BOOyp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 09:54:45 -0500
Date: Fri, 15 Feb 2013 15:53:23 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 3/5] coredump: cleanup the waiting for coredump_finish
	code
Message-ID: <20130215145323.GA30829@redhat.com>
References: <1360885096-21207-1-git-send-email-msb@chromium.org> <1360885096-21207-3-git-send-email-msb@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360885096-21207-3-git-send-email-msb@chromium.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14, Mandeep Singh Baines wrote:
>
> Replace the for loop with a simple if.

Why?

> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -479,12 +479,9 @@ static void exit_mm(struct task_struct * tsk)
>  		if (atomic_dec_and_test(&core_state->nr_threads))
>  			complete(&core_state->startup);
>
> -		for (;;) {
> -			set_task_state(tsk, TASK_UNINTERRUPTIBLE);
> -			if (!self.task) /* see coredump_finish() */
> -				break;
> +		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
> +		if (self.task) /* see coredump_finish() */
>  			schedule();
> -		}

If you think we should not worry about spurious wakeups you can simplify
this code even more, you do not need mb() to set TASK_UNINTERRUPTIBLE
(just move it before dec_and_test), you do not need "if (self.task)",
you do not need __set_task_state(tsk, TASK_RUNNING).

But I think we should always worry, so why?

Oleg.

