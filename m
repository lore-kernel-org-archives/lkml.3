Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933129AbaCSDIi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 23:08:38 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:50067 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756792AbaCSDIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 23:08:36 -0400
Message-ID: <53290A18.704@marvell.com>
Date: Wed, 19 Mar 2014 11:08:08 +0800
From: Jane Li <jiel@marvell.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "joe@perches.com" <joe@perches.com>, "tj@kernel.org" <tj@kernel.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] printk: fix one circular lockdep warning about console_lock
References: <1392101400-14550-1-git-send-email-jiel@marvell.com> <20140211131927.f180ac29dede51b2733b92a6@linux-foundation.org>
In-Reply-To: <20140211131927.f180ac29dede51b2733b92a6@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-03-19_01:2014-03-19,2014-03-19,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1403180171
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2014 05:19 AM, Andrew Morton wrote:

> On Tue, 11 Feb 2014 14:50:00 +0800<jiel@marvell.com>  wrote:
>
>> From: Jane Li<jiel@marvell.com>
>>
>> This patch tries to fix a warning about possible circular locking
>> dependency.
>>
>> If do in following sequence:
>>      enter suspend ->  resume ->  plug-out CPUx (echo 0 > cpux/online)
>> lockdep will show warning as following:
>>
>> ======================================================
>> [ INFO: possible circular locking dependency detected ]
>> 3.10.0 #2 Tainted: G           O
>> -------------------------------------------------------
>> sh/1271 is trying to acquire lock:
>> (console_lock){+.+.+.}, at: [<c06ebf7c>] console_cpu_notify+0x20/0x2c
>> but task is already holding lock:
>> (cpu_hotplug.lock){+.+.+.}, at: [<c012b4e8>] cpu_hotplug_begin+0x2c/0x58
>> which lock already depends on the new lock.
>>
>> the existing dependency chain (in reverse order) is:
>> -> #2 (cpu_hotplug.lock){+.+.+.}:
>> [<c017bb7c>] lock_acquire+0x98/0x12c
>> [<c06f5014>] mutex_lock_nested+0x50/0x3d8
>> [<c012b4e8>] cpu_hotplug_begin+0x2c/0x58
>> [<c06ebfac>] _cpu_up+0x24/0x154
>> [<c06ec140>] cpu_up+0x64/0x84
>> [<c0981834>] smp_init+0x9c/0xd4
>> [<c0973880>] kernel_init_freeable+0x78/0x1c8
>> [<c06e7f40>] kernel_init+0x8/0xe4
>> [<c010eec8>] ret_from_fork+0x14/0x2c
>>
>> -> #1 (cpu_add_remove_lock){+.+.+.}:
>> [<c017bb7c>] lock_acquire+0x98/0x12c
>> [<c06f5014>] mutex_lock_nested+0x50/0x3d8
>> [<c012b758>] disable_nonboot_cpus+0x8/0xe8
>> [<c016b83c>] suspend_devices_and_enter+0x214/0x448
>> [<c016bc54>] pm_suspend+0x1e4/0x284
>> [<c016bdcc>] try_to_suspend+0xa4/0xbc
>> [<c0143848>] process_one_work+0x1c4/0x4fc
>> [<c0143f80>] worker_thread+0x138/0x37c
>> [<c014aaf8>] kthread+0xa4/0xb0
>> [<c010eec8>] ret_from_fork+0x14/0x2c
>>
>> -> #0 (console_lock){+.+.+.}:
>> [<c017b5d0>] __lock_acquire+0x1b38/0x1b80
>> [<c017bb7c>] lock_acquire+0x98/0x12c
>> [<c01288c4>] console_lock+0x54/0x68
>> [<c06ebf7c>] console_cpu_notify+0x20/0x2c
>> [<c01501d4>] notifier_call_chain+0x44/0x84
>> [<c012b448>] __cpu_notify+0x2c/0x48
>> [<c012b5b0>] cpu_notify_nofail+0x8/0x14
>> [<c06e81bc>] _cpu_down+0xf4/0x258
>> [<c06e8344>] cpu_down+0x24/0x40
>> [<c06e921c>] store_online+0x30/0x74
>> [<c03b7298>] dev_attr_store+0x18/0x24
>> [<c025fc5c>] sysfs_write_file+0x16c/0x19c
>> [<c0207a98>] vfs_write+0xb4/0x190
>> [<c0207e58>] SyS_write+0x3c/0x70
>> [<c010ee00>] ret_fast_syscall+0x0/0x48
>>
>> Chain exists of:
>>     console_lock --> cpu_add_remove_lock --> cpu_hotplug.lock
>>
>> Possible unsafe locking scenario:
>>         CPU0                    CPU1
>>         ----                    ----
>> lock(cpu_hotplug.lock);
>>                                 lock(cpu_add_remove_lock);
>>                                 lock(cpu_hotplug.lock);
>> lock(console_lock);
>>    *** DEADLOCK ***
> These traces hurt my brain.
>
>> There are three locks involved in two sequence:
>> a) pm suspend:
>> 	console_lock (@suspend_console())
>> 	cpu_add_remove_lock (@disable_nonboot_cpus())
>> 	cpu_hotplug.lock (@_cpu_down())
> But but but.  suspend_console() releases console_sem again.  So the
> sequence is actually
>
>   	down(&console_sem) (@suspend_console())
>   	up(&console_sem) (@suspend_console())
>   	cpu_add_remove_lock (@disable_nonboot_cpus())
>   	cpu_hotplug.lock (@_cpu_down())
>
> So console_sem *doesn't* nest outside cpu_add_remove_lock and
> cpu_hotplug.lock.

  Jan Kara and Jane have answered this question in other emails.

>> b) Plug-out CPUx:
>> 	cpu_add_remove_lock (@(cpu_down())
>> 	cpu_hotplug.lock (@_cpu_down())
>> 	console_lock (@console_cpu_notify()) => Lockdeps prints warning log.
>>
>> There should be not real deadlock, as flag of console_suspended can
>> protect this.
> console_lock() does down(&console_sem) *before* testing
> console_suspended, so I don't understand this sentence - a more
> detailed description would help.

Jane has answered this question in another email.

>> Printk registers cpu hotplug notify function. When CPUx is plug-out/in,
>> always execute console_lock() and console_unlock(). This patch
>> modifies that with console_trylock() and console_unlock(). Then use
>> that instead of the unconditional console_lock/unlock pair to avoid the
>> warning.
>>
>> ...
>>
>> --- a/kernel/printk/printk.c
>> +++ b/kernel/printk/printk.c
>> @@ -1893,6 +1893,20 @@ void resume_console(void)
>>   }
>>   
>>   /**
>> + * console_flush - flush dmesg if console isn't suspended
>> + *
>> + * console_unlock always flushes the dmesg buffer, so just try to
>> + * grab&drop the console lock. If that fails we know that the current
>> + * holder will eventually drop the console lock and so flush the dmesg
>> + * buffers at the earliest possible time.
>> + */
> The comment should describe why we added this code, please: talk about
> cpu_hotplug.lock and console_lock.

Daniel has answered this question in another email.

>> +void console_flush(void)
>> +{
>> +	if (console_trylock())
>> +		console_unlock();
>> +}
>> +
>> +/**
>>    * console_cpu_notify - print deferred console messages after CPU hotplug
>>    * @self: notifier struct
>>    * @action: CPU hotplug event
>> @@ -1911,8 +1925,7 @@ static int console_cpu_notify(struct notifier_block *self,
>>   	case CPU_DEAD:
>>   	case CPU_DOWN_FAILED:
>>   	case CPU_UP_CANCELED:
>> -		console_lock();
>> -		console_unlock();
>> +		console_flush();
>>   	}
>>   	return NOTIFY_OK;
> Well, this is a bit hacky and makes the already-far-too-complex code
> even more complex.  If it is indeed the case that the deadlock cannot
> really occur then let's try to find a way of suppressing the lockdep
> warning without making runtime changes.
>
> What I'm struggling with is what *should* the ranking of these locks be?
>  From a conceptual high-level design standpoint, which is the
> "innermost" lock?  I tend to think that it is console_lock, because
> blocking CPU hotplug is a quite high-level operation.
>
> But console_lock is such a kooky special-case in the way it is used to
> control the printk corking that it is hard to take general rules and
> apply them here.

Daniel and Jan Kara have answered this question in other emails.

Do you agree with this solution or have other comments?

Thanks!

Best Regards,
Jane

   

