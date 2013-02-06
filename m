Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316Ab3BFLf1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 06:35:27 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:37903 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032Ab3BFLfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 06:35:25 -0500
MIME-Version: 1.0
In-Reply-To: <20130205164520.GA4276@mtj.dyndns.org>
References: <1359657696-2767-1-git-send-email-laijs@cn.fujitsu.com>
	<1359657696-2767-4-git-send-email-laijs@cn.fujitsu.com>
	<20130204212808.GC27963@mtj.dyndns.org>
	<51111E9A.4000504@gmail.com>
	<20130205164520.GA4276@mtj.dyndns.org>
Date: Wed, 6 Feb 2013 19:35:24 +0800
Message-ID: <CACvQF52FTPEdMTOK29EM2kbxX8KCT3xTyZe1YJG3oe4RAiUk_g@mail.gmail.com>
Subject: Re: [PATCH 03/13] workqueue: don't set work cwq until we queued it on pool
From: Lai Jiangshan <eag0628@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 6, 2013 at 12:45 AM, Tejun Heo <tj@kernel.org> wrote:
> Hey, Lai.
>
> On Tue, Feb 05, 2013 at 11:00:42PM +0800, Lai Jiangshan wrote:
>> The @cpu can be WORK_CPU_UNBOUND, and the current code will delay
>> to determine on which cpu should this work be queued until timeout,
>> I didn't want to change this behavior when I wrote the patch.
>
> Hmmm?  The current code determines the CPU on queue_delayed_work().
>
>         /*
>          * If we cannot get the last pool from @work directly,
>          * select the last CPU such that it avoids unnecessarily
>          * triggering non-reentrancy check in __queue_work().
>          */
>         lcpu = cpu;
>         if (pool)
>                 lcpu = pool->cpu;
>         if (lcpu == WORK_CPU_UNBOUND)
>                 lcpu = raw_smp_processor_id();
>
> @lcpu is never WORK_CPU_UNBOUND for bound workqueues and for unbound
> workqueues we of course have cwq for WORK_CPU_UNBOUND.


Are you sure?
@lcpu is only used when it tries to set cwq to work data without
breaking nrt logic.

void delayed_work_timer_fn(unsigned long __data)
{
	struct delayed_work *dwork = (struct delayed_work *)__data;
	struct cpu_workqueue_struct *cwq = get_work_cwq(&dwork->work);

	/* should have been called from irqsafe timer with irq already off */
	__queue_work(dwork->cpu, cwq->wq, &dwork->work);
}

>
>> PS, again, @cpu and @wq can be saved/encoded in dwork.work.entry if needed.
>
> If possible, I'd much prefer to keep it inside delayed_work() proper.
>
> Thanks.
>
> --
> tejun
