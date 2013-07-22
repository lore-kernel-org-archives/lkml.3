Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933364Ab3GVVip (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 17:38:45 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:44820 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933273Ab3GVVin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 17:38:43 -0400
MIME-Version: 1.0
In-Reply-To: <51ED51A2.6050909@linux.vnet.ibm.com>
References: <51E55B7D.2040209@linux.vnet.ibm.com> <51E66CCC.9010600@cn.fujitsu.com>
 <51E84EDC.5090502@linux.vnet.ibm.com> <51E89ABB.20808@cn.fujitsu.com>
 <51E8FF76.5030706@linux.vnet.ibm.com> <51ED1D02.80205@cn.fujitsu.com> <51ED51A2.6050909@linux.vnet.ibm.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 22 Jul 2013 15:38:21 -0600
Message-ID: <CAErSpo4vbfctQwGzexEuLoGMh33oU1oJOM8bkuq4uk7EtkE0xw@mail.gmail.com>
Subject: Re: workqueue, pci: INFO: possible recursive locking detected
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Yinghai Lu <yinghai@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Alex, Yinghai, linux-pci]

On Mon, Jul 22, 2013 at 9:37 AM, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:
> On 07/22/2013 05:22 PM, Lai Jiangshan wrote:
>> On 07/19/2013 04:57 PM, Srivatsa S. Bhat wrote:
>>> On 07/19/2013 07:17 AM, Lai Jiangshan wrote:
>>>> On 07/19/2013 04:23 AM, Srivatsa S. Bhat wrote:
>>>>>
>>>>> ---
>>>>>
>>>>>  kernel/workqueue.c |    6 ++++++
>>>>>  1 file changed, 6 insertions(+)
>>>>>
>>>>>
>>>>> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
>>>>> index f02c4a4..07d9a67 100644
>>>>> --- a/kernel/workqueue.c
>>>>> +++ b/kernel/workqueue.c
>>>>> @@ -4754,7 +4754,13 @@ long work_on_cpu(int cpu, long (*fn)(void *), void *arg)
>>>>>  {
>>>>>    struct work_for_cpu wfc = { .fn = fn, .arg = arg };
>>>>>
>>>>> +#ifdef CONFIG_LOCKDEP
>>>>> +  static struct lock_class_key __key;
>>>>
>>>> Sorry, this "static" should be removed.
>>>>
>>>
>>> That didn't help either :-( Because it makes lockdep unhappy,
>>> since the key isn't persistent.
>>>
>>> This is the patch I used:
>>>
>>> ---
>>>
>>> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
>>> index f02c4a4..7967e3b 100644
>>> --- a/kernel/workqueue.c
>>> +++ b/kernel/workqueue.c
>>> @@ -4754,7 +4754,13 @@ long work_on_cpu(int cpu, long (*fn)(void *), void *arg)
>>>  {
>>>      struct work_for_cpu wfc = { .fn = fn, .arg = arg };
>>>
>>> +#ifdef CONFIG_LOCKDEP
>>> +    struct lock_class_key __key;
>>> +    INIT_WORK_ONSTACK(&wfc.work, work_for_cpu_fn);
>>> +    lockdep_init_map(&wfc.work.lockdep_map, "&wfc.work", &__key, 0);
>>> +#else
>>>      INIT_WORK_ONSTACK(&wfc.work, work_for_cpu_fn);
>>> +#endif
>>>      schedule_work_on(cpu, &wfc.work);
>>>      flush_work(&wfc.work);
>>>      return wfc.ret;
>>>
>>>
>>> And here are the new warnings:
>>>
>>>
>>> Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
>>> io scheduler noop registered
>>> io scheduler deadline registered
>>> io scheduler cfq registered (default)
>>> BUG: key ffff881039557b98 not in .data!
>>> ------------[ cut here ]------------
>>> WARNING: CPU: 8 PID: 1 at kernel/lockdep.c:2987 lockdep_init_map+0x168/0x170()
>>
>> Sorry again.
>>
>> From 0096b9dac2282ec03d59a3f665b92977381a18ad Mon Sep 17 00:00:00 2001
>> From: Lai Jiangshan <laijs@cn.fujitsu.com>
>> Date: Mon, 22 Jul 2013 19:08:51 +0800
>> Subject: [PATCH] [PATCH] workqueue: allow the function of work_on_cpu() can
>>  call work_on_cpu()
>>
>> If the @fn call work_on_cpu() again, the lockdep will complain:
>>
>>> [ INFO: possible recursive locking detected ]
>>> 3.11.0-rc1-lockdep-fix-a #6 Not tainted
>>> ---------------------------------------------
>>> kworker/0:1/142 is trying to acquire lock:
>>>  ((&wfc.work)){+.+.+.}, at: [<ffffffff81077100>] flush_work+0x0/0xb0
>>>
>>> but task is already holding lock:
>>>  ((&wfc.work)){+.+.+.}, at: [<ffffffff81075dd9>] process_one_work+0x169/0x610
>>>
>>> other info that might help us debug this:
>>>  Possible unsafe locking scenario:
>>>
>>>        CPU0
>>>        ----
>>>   lock((&wfc.work));
>>>   lock((&wfc.work));
>>>
>>>  *** DEADLOCK ***
>>
>> It is false-positive lockdep report. In this sutiation,
>> the two "wfc"s of the two work_on_cpu() are different,
>> they are both on stack. flush_work() can't be deadlock.
>>
>> To fix this, we need to avoid the lockdep checking in this case,
>> But we don't want to change the flush_work(), so we use
>> completion instead of flush_work() in the work_on_cpu().
>>
>> Reported-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
>> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
>> ---
>
> That worked, thanks a lot!
>
> Tested-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
>
> Regards,
> Srivatsa S. Bhat
>
>>  kernel/workqueue.c |    5 ++++-
>>  1 files changed, 4 insertions(+), 1 deletions(-)
>>
>> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
>> index f02c4a4..b021a45 100644
>> --- a/kernel/workqueue.c
>> +++ b/kernel/workqueue.c
>> @@ -4731,6 +4731,7 @@ struct work_for_cpu {
>>       long (*fn)(void *);
>>       void *arg;
>>       long ret;
>> +     struct completion done;
>>  };
>>
>>  static void work_for_cpu_fn(struct work_struct *work)
>> @@ -4738,6 +4739,7 @@ static void work_for_cpu_fn(struct work_struct *work)
>>       struct work_for_cpu *wfc = container_of(work, struct work_for_cpu, work);
>>
>>       wfc->ret = wfc->fn(wfc->arg);
>> +     complete(&wfc->done);
>>  }
>>
>>  /**
>> @@ -4755,8 +4757,9 @@ long work_on_cpu(int cpu, long (*fn)(void *), void *arg)
>>       struct work_for_cpu wfc = { .fn = fn, .arg = arg };
>>
>>       INIT_WORK_ONSTACK(&wfc.work, work_for_cpu_fn);
>> +     init_completion(&wfc.done);
>>       schedule_work_on(cpu, &wfc.work);
>> -     flush_work(&wfc.work);
>> +     wait_for_completion(&wfc.done);
>>       return wfc.ret;
>>  }
>>  EXPORT_SYMBOL_GPL(work_on_cpu);
>>
>

Isn't this for the same issue Alex and others have been working on?

It doesn't feel like we have consensus on how this should be fixed.
You're proposing a change to work_on_cpu(), Alex proposed a change to
pci_call_probe() [1], Yinghai proposed some changes to the PCI core
SR-IOV code and several drivers [2].

[1] https://lkml.kernel.org/r/20130624195942.40795.27292.stgit@ahduyck-cp1.jf.intel.com
[2] https://lkml.kernel.org/r/1368498506-25857-7-git-send-email-yinghai@kernel.org
