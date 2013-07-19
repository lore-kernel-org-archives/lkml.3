Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934221Ab3GSCBC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 22:01:02 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:24214 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759441Ab3GSCBA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 22:01:00 -0400
X-IronPort-AV: E=Sophos;i="4.89,697,1367942400"; 
   d="scan'208";a="7943073"
Message-ID: <51E89ABB.20808@cn.fujitsu.com>
Date: Fri, 19 Jul 2013 09:47:39 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        bhelgaas@google.com
Subject: Re: workqueue, pci: INFO: possible recursive locking detected
References: <51E55B7D.2040209@linux.vnet.ibm.com> <51E66CCC.9010600@cn.fujitsu.com> <51E84EDC.5090502@linux.vnet.ibm.com>
In-Reply-To: <51E84EDC.5090502@linux.vnet.ibm.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/19 09:42:00,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/19 09:42:05,
	Serialize complete at 2013/07/19 09:42:05
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19/2013 04:23 AM, Srivatsa S. Bhat wrote:
> 
> On 07/17/2013 03:37 PM, Lai Jiangshan wrote:
>> On 07/16/2013 10:41 PM, Srivatsa S. Bhat wrote:
>>> Hi,
>>>
>>> I have been seeing this warning every time during boot. I haven't
>>> spent time digging through it though... Please let me know if
>>> any machine-specific info is needed.
>>>
>>> Regards,
>>> Srivatsa S. Bhat
>>>
>>>
>>> ----------------------------------------------------
>>>
>>> =============================================
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
>>
>>
> 
> 
> Hi Lai,
> 
> Thanks for taking a look into this!
> 
>>
>> This is false negative,
> 
> I believe you meant false-positive...
> 
>> the two "wfc"s are different, they are
>> both on stack. flush_work() can't be deadlock in such case:
>>
>> void foo(void *)
>> {
>> 	...
>> 	if (xxx)
>> 		work_on_cpu(..., foo, ...);
>> 	...
>> }
>>
>> bar()
>> {
>> 	work_on_cpu(..., foo, ...);
>> }
>>
>> The complaint is caused by "work_on_cpu() uses a static lock_class_key".
>> we should fix work_on_cpu().
>> (but the caller should also be careful, the foo()/local_pci_probe() is re-entering)
>>
>> But I can't find an elegant fix.
>>
>> long work_on_cpu(int cpu, long (*fn)(void *), void *arg)
>> {
>> 	struct work_for_cpu wfc = { .fn = fn, .arg = arg };
>>
>> +#ifdef CONFIG_LOCKDEP
>> +	static struct lock_class_key __key;
>> +	INIT_WORK_ONSTACK(&wfc.work, work_for_cpu_fn);
>> +	lockdep_init_map(&wfc.work.lockdep_map, &wfc.work, &__key, 0);
>> +#else
>> 	INIT_WORK_ONSTACK(&wfc.work, work_for_cpu_fn);
>> +#endif
>> 	schedule_work_on(cpu, &wfc.work);
>> 	flush_work(&wfc.work);
>> 	return wfc.ret;
>> }
>>
> 
> Unfortunately that didn't seem to fix it.. I applied the patch
> shown below, and I got the same old warning.
> 
> ---
> 
>  kernel/workqueue.c |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> 
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index f02c4a4..07d9a67 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -4754,7 +4754,13 @@ long work_on_cpu(int cpu, long (*fn)(void *), void *arg)
>  {
>  	struct work_for_cpu wfc = { .fn = fn, .arg = arg };
>  
> +#ifdef CONFIG_LOCKDEP
> +	static struct lock_class_key __key;

Sorry, this "static" should be removed.

Thanks,
Lai


> +	INIT_WORK_ONSTACK(&wfc.work, work_for_cpu_fn);
> +	lockdep_init_map(&wfc.work.lockdep_map, "&wfc.work", &__key, 0);
> +#else
>  	INIT_WORK_ONSTACK(&wfc.work, work_for_cpu_fn);
> +#endif
>  	schedule_work_on(cpu, &wfc.work);
>  	flush_work(&wfc.work);
>  	return wfc.ret;
> 
> 
> 
> Warning:
> --------
> 
> wmi: Mapper loaded
> be2net 0000:11:00.0: irq 102 for MSI/MSI-X
> be2net 0000:11:00.0: enabled 1 MSI-x vector(s)
> be2net 0000:11:00.0: created 0 RSS queue(s) and 1 default RX queue
> be2net 0000:11:00.0: created 1 TX queue(s)
> pci 0000:11:04.0: [19a2:0710] type 00 class 0x020000
> 
> =============================================
> [ INFO: possible recursive locking detected ]
> 3.11.0-rc1-wq-fix #10 Not tainted
> ---------------------------------------------
> kworker/0:1/126 is trying to acquire lock:
>  (&wfc.work){+.+.+.}, at: [<ffffffff810770f0>] flush_work+0x0/0xb0
> 
> but task is already holding lock:
>  (&wfc.work){+.+.+.}, at: [<ffffffff81075dc9>] process_one_work+0x169/0x610
> 
> other info that might help us debug this:
>  Possible unsafe locking scenario:
> 
>        CPU0
>        ----
>   lock(&wfc.work);
>   lock(&wfc.work);
> 
>  *** DEADLOCK ***
> 
>  May be due to missing lock nesting notation
> 
> 3 locks held by kworker/0:1/126:
>  #0:  (events){.+.+.+}, at: [<ffffffff81075dc9>] process_one_work+0x169/0x610
>  #1:  (&wfc.work){+.+.+.}, at: [<ffffffff81075dc9>] process_one_work+0x169/0x610
>  #2:  (&__lockdep_no_validate__){......}, at: [<ffffffff81398ada>] device_attach+0x2a/0xc0
> 
> stack backtrace:
> CPU: 0 PID: 126 Comm: kworker/0:1 Not tainted 3.11.0-rc1-wq-fix #10
> Hardware name: IBM  -[8737R2A]-/00Y2738, BIOS -[B2E120RUS-1.20]- 11/30/2012
> Workqueue: events work_for_cpu_fn
>  ffff881036887408 ffff881036889668 ffffffff81619059 0000000000000003
>  ffff881036886a80 ffff881036889698 ffffffff810c1624 ffff881036886a80
>  ffff881036887408 ffff881036886a80 0000000000000000 ffff8810368896f8
> Call Trace:
>  [<ffffffff81619059>] dump_stack+0x59/0x80
>  [<ffffffff810c1624>] print_deadlock_bug+0xf4/0x100
>  [<ffffffff810c3104>] validate_chain+0x504/0x750
>  [<ffffffff810c365d>] __lock_acquire+0x30d/0x580
>  [<ffffffff810c3967>] lock_acquire+0x97/0x170
>  [<ffffffff810770f0>] ? start_flush_work+0x220/0x220
>  [<ffffffff81077138>] flush_work+0x48/0xb0
>  [<ffffffff810770f0>] ? start_flush_work+0x220/0x220
>  [<ffffffff810c2000>] ? mark_held_locks+0x80/0x130
>  [<ffffffff81074ceb>] ? queue_work_on+0x4b/0xa0
>  [<ffffffff810c2375>] ? trace_hardirqs_on_caller+0x105/0x1d0
>  [<ffffffff810c244d>] ? trace_hardirqs_on+0xd/0x10
>  [<ffffffff81077334>] work_on_cpu+0xa4/0xc0
>  [<ffffffff8106f940>] ? wqattrs_hash+0x190/0x190
>  [<ffffffff812d1ed0>] ? pci_pm_prepare+0x60/0x60
>  [<ffffffff812d1ffa>] __pci_device_probe+0x9a/0xe0
>  [<ffffffff8161ef90>] ? _raw_spin_unlock_irq+0x30/0x50
>  [<ffffffff812d3302>] ? pci_dev_get+0x22/0x30
>  [<ffffffff812d334a>] pci_device_probe+0x3a/0x60
>  [<ffffffff8161ef90>] ? _raw_spin_unlock_irq+0x30/0x50
>  [<ffffffff81398bdc>] really_probe+0x6c/0x320
>  [<ffffffff81398ed7>] driver_probe_device+0x47/0xa0
>  [<ffffffff81398fe0>] ? __driver_attach+0xb0/0xb0
>  [<ffffffff81399033>] __device_attach+0x53/0x60
>  [<ffffffff81396b24>] bus_for_each_drv+0x74/0xa0
>  [<ffffffff81398b50>] device_attach+0xa0/0xc0
>  [<ffffffff812c99f9>] pci_bus_add_device+0x39/0x60
>  [<ffffffff812ed341>] virtfn_add+0x251/0x3e0
>  [<ffffffff810c244d>] ? trace_hardirqs_on+0xd/0x10
>  [<ffffffff812ed9bf>] sriov_enable+0x22f/0x3d0
>  [<ffffffff812edbad>] pci_enable_sriov+0x4d/0x60
>  [<ffffffffa0127045>] be_vf_setup+0x175/0x410 [be2net]
>  [<ffffffffa012d3ca>] be_setup+0x37a/0x4b0 [be2net]
>  [<ffffffffa012dac0>] be_probe+0x5c0/0x820 [be2net]
>  [<ffffffff812d1f1e>] local_pci_probe+0x4e/0x90
>  [<ffffffff8106f958>] work_for_cpu_fn+0x18/0x30
>  [<ffffffff81075e3a>] process_one_work+0x1da/0x610
>  [<ffffffff81075dc9>] ? process_one_work+0x169/0x610
>  [<ffffffff810764fc>] worker_thread+0x28c/0x3a0
>  [<ffffffff81076270>] ? process_one_work+0x610/0x610
>  [<ffffffff8107da5e>] kthread+0xee/0x100
>  [<ffffffff8107d970>] ? __init_kthread_worker+0x70/0x70
>  [<ffffffff81628e5c>] ret_from_fork+0x7c/0xb0
>  [<ffffffff8107d970>] ? __init_kthread_worker+0x70/0x70
> be2net 0000:11:04.0: enabling device (0040 -> 0042)
> be2net 0000:11:04.0: Could not use PCIe error reporting
> be2net 0000:11:04.0: VF is not privileged to issue opcode 89-1
> be2net 0000:11:04.0: VF is not privileged to issue opcode 125-1
> 
> 
> Regards,
> Srivatsa S. Bhat
> 
> 

