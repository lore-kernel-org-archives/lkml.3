Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932494Ab3BITId (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 14:08:33 -0500
Received: from mail-da0-f43.google.com ([209.85.210.43]:34789 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758526Ab3BITIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 14:08:31 -0500
Date: Sat, 9 Feb 2013 11:08:26 -0800
From: Tejun Heo <tj@kernel.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] stop_machine: check work->done while handling
 enqueued works
Message-ID: <20130209190826.GC2875@htj.dyndns.org>
References: <CAJd=RBD4ZJN7uXQ5xY1GF14j_DydDQEpuZNct-UiNXTBARpQSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJd=RBD4ZJN7uXQ5xY1GF14j_DydDQEpuZNct-UiNXTBARpQSQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Hillf.

On Fri, Feb 08, 2013 at 11:39:56AM +0800, Hillf Danton wrote:
> The comment just above cpu_stop_signal_done() says it is uncertain that
> the input @done is valid, and the works enqueued through the function
> stop_one_cpu_nowait() do carry no done, thus we have to check if it is
> valid when updating work result.

How about something like the following?

In cpu_stopper_thread(), @work->done may be NULL if the cpu stop work
is queued from stop_one_cpu_nowait(); however, cpu_stopper_thread()
updates @done->ret without checking whether @done exists or not when
the work function fails.

While this can lead to oops, the only current user of
stop_one_cpu_nowait() - active_load_balance_cpu_stop() - always
returns 0 and thus there's no in-kernel user which triggers this bug.

Fix it by checking whether @done exists before updating @done->ret.

> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> ---
> 
> --- a/kernel/stop_machine.c	Thu Feb  7 20:03:10 2013
> +++ b/kernel/stop_machine.c	Fri Feb  8 11:07:40 2013
> @@ -279,7 +279,7 @@ repeat:
>  		preempt_disable();
> 
>  		ret = fn(arg);
> -		if (ret)
> +		if (ret && done != NULL)

It's a nitpick and probalby is just a preference but I've never liked
!= NULL or != 0.  Can we just do if (ret && done)?

Thanks.

-- 
tejun
