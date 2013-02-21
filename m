Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066Ab3BUAbY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 19:31:24 -0500
Received: from mail-lb0-f178.google.com ([209.85.217.178]:42503 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644Ab3BUAbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 19:31:22 -0500
MIME-Version: 1.0
In-Reply-To: <20130220022712.0E8586607A4@gitolite.kernel.org>
References: <20130220022712.0E8586607A4@gitolite.kernel.org>
Date: Wed, 20 Feb 2013 17:31:21 -0700
Message-ID: <CAKocOOMo-5Hiv_dBCpZNYMP_wXWiWugBYq4qsRcMBwm=TPM=dA@mail.gmail.com>
Subject: Re: sched: Fix signedness bug in yield_to()
From: Shuah Khan <shuahkhan@gmail.com>
To: dan.carpenter@oracle.com, peterz@infradead.org, mingo@kernel.org
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        torvalds@linux-foundation.org, Shuah Khan <shuahkhan@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2013 at 7:27 PM, Linux Kernel Mailing List
<linux-kernel@vger.kernel.org> wrote:
> Gitweb:     http://git.kernel.org/linus/;a=commit;h=c3c186403c6abd32e719f005f0af950155a9e54d
> Commit:     c3c186403c6abd32e719f005f0af950155a9e54d
> Parent:     e0a79f529d5ba2507486d498b25da40911d95cf6
> Author:     Dan Carpenter <dan.carpenter@oracle.com>
> AuthorDate: Tue Feb 5 14:37:51 2013 +0300
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Tue Feb 5 12:59:29 2013 +0100
>
>     sched: Fix signedness bug in yield_to()
>
>     In 7b270f6099 "sched: Bail out of yield_to when source and
>     target runqueue has one task" we changed this to store -ESRCH so
>     it needs to be signed.

Dan, Ingo,

I can't find the 7b270f6099 "sched: Bail out of yield_to when source
and  target runqueue has one task" in the latest Linus's git. Am I
missing something.

The current kenel/sched/core.c doesn't have the code from the
associated patch https://patchwork.kernel.org/patch/2016651/

>  bool __sched yield_to(struct task_struct *p, bool preempt)
>  {
> @@ -4303,6 +4306,15 @@ bool __sched yield_to(struct task_struct *p, bool preempt)
>
>  again:
>  	p_rq = task_rq(p);
> +	/*
> +	 * If we're the only runnable task on the rq and target rq also
> +	 * has only one task, there's absolutely no point in yielding.
> +	 */
> +	if (rq->nr_running == 1 && p_rq->nr_running == 1) {
> +		yielded = -ESRCH;
> +		goto out_irq;
> +	}

Without the 7b270f6099 "sched: Bail out of yield_to when source and
target runqueue has one task", do you need this change?

Am I missing something?

-- Shuah
