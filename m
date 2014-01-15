Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751843AbaAOCDO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 21:03:14 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:39109 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbaAOCDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 21:03:12 -0500
Message-ID: <52D5EC44.30101@huawei.com>
Date: Wed, 15 Jan 2014 10:02:44 +0800
From: Weng Meiling <wengmeiling.weng@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Robert Richter <rric@kernel.org>
CC: <oprofile-list@lists.sf.net>, <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>, <wangnan0@huawei.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Huang Qiang <h.huangqiang@huawei.com>
Subject: Re: [PATCH] oprofile: check whether oprofile perf enabled in op_overflow_handler()
References: <52B3F66D.6060707@huawei.com> <20140113084555.GU20315@rric.localhost> <52D4984B.9090600@huawei.com> <20140114150553.GC20315@rric.localhost>
In-Reply-To: <20140114150553.GC20315@rric.localhost>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.24.66]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/1/14 23:05, Robert Richter wrote:
> On 14.01.14 09:52:11, Weng Meiling wrote:
>> On 2014/1/13 16:45, Robert Richter wrote:
>>> On 20.12.13 15:49:01, Weng Meiling wrote:
> 
>>>> The problem was once triggered on kernel 2.6.34, the main information:
>>>> <3>BUG: soft lockup - CPU#0 stuck for 60005ms! [opcontrol:8673]
>>>>
>>>> Pid: 8673, comm:            opcontrol
>>>> =====================SOFTLOCKUP INFO BEGIN=======================
>>>> [CPU#0] the task [opcontrol] is not waiting for a lock,maybe a delay or deadcricle!
>>>> <6>opcontrol     R<c> running  <c>    0  8673   7603 0x00000002
>>>> locked:
>>>> bf0e1928   mutex            0  [<bf0de0d8>] oprofile_start+0x10/0x68 [oprofile]
>>>> bf0e1a24   mutex            0  [<bf0e07f0>] op_arm_start+0x10/0x48 [oprofile]
>>>> c0628020   &ctx->mutex      0  [<c00af85c>] perf_event_create_kernel_counter+0xa4/0x14c
>>>
>>> I rather suspect the code of perf_install_in_context() of 2.6.34 to
>>> cause the locking issue. There was a lot of rework in between there.
>>> Can you further explain the locking and why your fix should solve it?
>>>
>> Thanks for your answer!
>> The locking happens when the event's sample_period is small which leads to cpu
>> keeping printing the warning for the triggered unregistered event. So the thread
>> context can't be executed and trigger softlockup.
>> As you said below, the patch is not appropriate, and the patch just
>> prevents printing the warning and thus stays shorter in the interrupt handler,
>> it can't solve the problem. The problem was once triggered on kernel 2.6.34, I'll
>> try to trigger it in current kernel and resend a correct patch.
> 
> Weng,
> 
> so an interrupt storm due to warning messages causes the lock.
> 
> I was looking further at it and wrote a patch that enables the event
> after it was added to the perf_events list. This should fix spurious
> overflows and its warning messages. Could you reproduce the issue with
> a mainline kernel and then test with the patch below applied?
> 
> Thanks,
> 
> -Robert
> 
> 

It's my pleasure. But one more question, please see below.

> From: Robert Richter <rric@kernel.org>
> Date: Tue, 14 Jan 2014 15:19:54 +0100
> Subject: [PATCH] oprofile_perf
> 
> Signed-off-by: Robert Richter <rric@kernel.org>
> ---
>  drivers/oprofile/oprofile_perf.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/oprofile/oprofile_perf.c b/drivers/oprofile/oprofile_perf.c
> index d5b2732..2b07c95 100644
> --- a/drivers/oprofile/oprofile_perf.c
> +++ b/drivers/oprofile/oprofile_perf.c
> @@ -38,6 +38,9 @@ static void op_overflow_handler(struct perf_event *event,
>  	int id;
>  	u32 cpu = smp_processor_id();
>  
> +	/* sync perf_events with op_create_counter(): */
> +	smp_rmb();
> +
>  	for (id = 0; id < num_counters; ++id)
>  		if (per_cpu(perf_events, cpu)[id] == event)
>  			break;
> @@ -68,6 +71,7 @@ static void op_perf_setup(void)
>  		attr->config		= counter_config[i].event;
>  		attr->sample_period	= counter_config[i].count;
>  		attr->pinned		= 1;
> +		attr->disabled		= 1;
>  	}
>  }
>  
> @@ -94,6 +98,11 @@ static int op_create_counter(int cpu, int event)
>  
>  	per_cpu(perf_events, cpu)[event] = pevent;
>  
> +	/* sync perf_events with overflow handler: */
> +	smp_wmb();
> +
> +	perf_event_enable(pevent);
> +

Should this step go before the if check:pevent->state != PERF_EVENT_STATE_ACTIVE ?
Because the attr->disabled is true, So after the perf_event_create_kernel_counter
the pevent->state is not PERF_EVENT_STATE_ACTIVE.
>  	return 0;
>  }
>  
> 


