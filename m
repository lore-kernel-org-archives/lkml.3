Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932717AbaBUMv4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 07:51:56 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:34654 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932581AbaBUMvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:51:54 -0500
Message-ID: <53074BE4.1020307@hurleysoftware.com>
Date: Fri, 21 Feb 2014 07:51:48 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: laijs@cn.fujitsu.com, linux-kernel@vger.kernel.org,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux1394-devel@lists.sourceforge.net, Chris Boot <bootc@bootc.net>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: Re: [PATCH 4/9] firewire: don't use PREPARE_DELAYED_WORK
References: <1392929071-16555-1-git-send-email-tj@kernel.org> <1392929071-16555-5-git-send-email-tj@kernel.org> <5306AF8E.3080006@hurleysoftware.com> <20140221015935.GF6897@htj.dyndns.org> <5306B4DF.4000901@hurleysoftware.com> <20140221021341.GG6897@htj.dyndns.org> <5306E06C.5020805@hurleysoftware.com> <20140221100301.GA14653@mtj.dyndns.org>
In-Reply-To: <20140221100301.GA14653@mtj.dyndns.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2014 05:03 AM, Tejun Heo wrote:
> On Fri, Feb 21, 2014 at 12:13:16AM -0500, Peter Hurley wrote:
>> CPU 0                            | CPU 1
>>                                   |
>>   INIT_WORK(fw_device_workfn)     |
>>                                   |
>>   workfn = funcA                  |
>>   queue_work_on()                 |
>>   .                               | process_one_work()
>>   .                               |   ..
>>   .                               |   worker->current_func = work->func
>>   .                               |
>>   .                               |   speculative load of workfn = funcA
>>   .                               |   .
>>   workfn = funcB                  |   .
>>   queue_work_on()                 |   .
>>     local_irq_save()              |   .
>>     test_and_set_bit() == 1       |   .
>>                                   |   set_work_pool_and_clear_pending()
>>     work is not queued            |     smp_wmb
>>      funcB never runs             |     set_work_data()
>>                                   |       atomic_set()
>>                                   |   spin_unlock_irq()
>>                                   |
>>                                   |   worker->current_func(work)  @ fw_device_workfn
>>                                   |      workfn()  @ funcA
>>
>>
>> The speculative load of workfn on CPU 1 is valid because no rmb will occur
>> between the load and the execution of workfn() on CPU 1.
>>
>> Thus funcB will never execute because, in this circumstance, a second
>> worker is not queued (because PENDING had not yet been cleared).
>
> There's no right or wrong execution.  Executions of either funcA or
> funcB are correct results.  The only memory ordering guarantee
> workqueue gives is that anything written before the work item is
> queued will be visible when that instance starts executing.  When a
> work item is not queued, no ordering is guaranteed between the
> queueing attempt and the execution of the existing instance.

I think the vast majority of kernel code which uses the workqueue
assumes there is a memory ordering guarantee.

Meaning that if a work item is not queue-able then the previously
queued instance _has not yet started_ and so, by deduction, must be
able to see the newly written values.

Consider:

    add something important to list to work on
    queue work

or

    update index in buffer indicating more data
    queue work

Neither of these uses expect that the workqueue does not guarantee
that this latest data is acted upon.

Another way to look at this problem is that process_one_work()
doesn't become the existing instance _until_ PENDING is cleared.

> We can
> add such guarantee, not sure how much it'd matter but it's not like
> it's gonna cost a lot either.
>
> This doesn't have much to do with the current series tho.  In fact,
> PREPARE_WORK can't ever be made to give such guarantee.

Yes, I agree that PREPARE_DELAYED_WORK was also broken usage with the
same problem. [And there are other bugs in that firewire device work
code which I'm working on.]

> The function pointer has to fetched before clearing of PENDING.

Why?

As long as the load takes place within the pool->lock, I don't think
it matters (especially now PREPARE_WORK is removed).

Regards,
Peter Hurley

