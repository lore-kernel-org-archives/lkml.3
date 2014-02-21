Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740AbaBUKDK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 05:03:10 -0500
Received: from mail-qc0-f175.google.com ([209.85.216.175]:54230 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754411AbaBUKDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 05:03:06 -0500
Date: Fri, 21 Feb 2014 05:03:01 -0500
From: Tejun Heo <tj@kernel.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: laijs@cn.fujitsu.com, linux-kernel@vger.kernel.org,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux1394-devel@lists.sourceforge.net, Chris Boot <bootc@bootc.net>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: Re: [PATCH 4/9] firewire: don't use PREPARE_DELAYED_WORK
Message-ID: <20140221100301.GA14653@mtj.dyndns.org>
References: <1392929071-16555-1-git-send-email-tj@kernel.org>
 <1392929071-16555-5-git-send-email-tj@kernel.org>
 <5306AF8E.3080006@hurleysoftware.com>
 <20140221015935.GF6897@htj.dyndns.org>
 <5306B4DF.4000901@hurleysoftware.com>
 <20140221021341.GG6897@htj.dyndns.org>
 <5306E06C.5020805@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5306E06C.5020805@hurleysoftware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 21, 2014 at 12:13:16AM -0500, Peter Hurley wrote:
> CPU 0                            | CPU 1
>                                  |
>  INIT_WORK(fw_device_workfn)     |
>                                  |
>  workfn = funcA                  |
>  queue_work_on()                 |
>  .                               | process_one_work()
>  .                               |   ..
>  .                               |   worker->current_func = work->func
>  .                               |
>  .                               |   speculative load of workfn = funcA
>  .                               |   .
>  workfn = funcB                  |   .
>  queue_work_on()                 |   .
>    local_irq_save()              |   .
>    test_and_set_bit() == 1       |   .
>                                  |   set_work_pool_and_clear_pending()
>    work is not queued            |     smp_wmb
>     funcB never runs             |     set_work_data()
>                                  |       atomic_set()
>                                  |   spin_unlock_irq()
>                                  |
>                                  |   worker->current_func(work)  @ fw_device_workfn
>                                  |      workfn()  @ funcA
> 
> 
> The speculative load of workfn on CPU 1 is valid because no rmb will occur
> between the load and the execution of workfn() on CPU 1.
> 
> Thus funcB will never execute because, in this circumstance, a second
> worker is not queued (because PENDING had not yet been cleared).

There's no right or wrong execution.  Executions of either funcA or
funcB are correct results.  The only memory ordering guarantee
workqueue gives is that anything written before the work item is
queued will be visible when that instance starts executing.  When a
work item is not queued, no ordering is guaranteed between the
queueing attempt and the execution of the existing instance.  We can
add such guarantee, not sure how much it'd matter but it's not like
it's gonna cost a lot either.

This doesn't have much to do with the current series tho.  In fact,
PREPARE_WORK can't ever be made to give such guarantee.  The function
pointer has to fetched before clearing of PENDING.

-- 
tejun
