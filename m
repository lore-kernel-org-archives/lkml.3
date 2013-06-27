Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117Ab3F0SnE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 14:43:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6870 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535Ab3F0SnC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 14:43:02 -0400
Message-ID: <51CC8799.9070909@redhat.com>
Date: Thu, 27 Jun 2013 14:42:33 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Matthew Wilcox <willy@linux.intel.com>
CC: Jens Axboe <axboe@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: RFC: Allow block drivers to poll for I/O instead of sleeping
References: <20130620201713.GV8211@linux.intel.com>
In-Reply-To: <20130620201713.GV8211@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2013 04:17 PM, Matthew Wilcox wrote:

> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -4527,6 +4527,36 @@ long __sched io_schedule_timeout(long timeout)
>   	return ret;
>   }
>
> +/*
> + * Wait for an I/O to complete against this backing_dev_info.  If the
> + * task exhausts its timeslice polling for completions, call io_schedule()
> + * anyway.  If a signal comes pending, return so the task can handle it.
> + * If the io_poll returns an error, give up and call io_schedule(), but
> + * swallow the error.  We may miss an I/O completion (eg if the interrupt
> + * handler gets to it first).  Guard against this possibility by returning
> + * if we've been set back to TASK_RUNNING.
> + */
> +void io_wait(struct backing_dev_info *bdi)
> +{

I would like something a little more generic in the
scheduler code, that could also be used by other
things in the kernel (say, KVM with message passing
workloads).

Maybe something looking a little like this?

void idle_poll(struct idle_poll_info *ipi)

struct idle_poll_info {
	int (*idle_poll_func)(void *data);
	int (*idle_poll_preempt)(void *data);
	void *data;
}

That way the kernel can:

1) mark the current thread as having idle priority,
    allowing the scheduler to preempt it if something
    else wants to run

2) switch to asynchronous mode if something else wants
    to run, or if the average wait for the process is
    so long that it is better to go asynchronous and
    avoid polling

3) poll for completion if nothing else wants to run

Does that make sense?

Did I forget something you need?

Did I forget something KVM could need?

Is this insane? If so, is it too insane? :)
