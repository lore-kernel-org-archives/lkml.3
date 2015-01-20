Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752978AbbATDKA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 22:10:00 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:2652 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075AbbATDJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 22:09:58 -0500
Message-ID: <54BDC6DF.6000602@huawei.com>
Date: Tue, 20 Jan 2015 11:09:19 +0800
From: Zhang Zhen <zhenzhang.zhang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Don Zickus <dzickus@redhat.com>
CC: <paulmck@linux.vnet.ibm.com>, <linux-kernel@vger.kernel.org>,
        <morgan.wang@huawei.com>, <josh@freedesktop.org>,
        <dipankar@in.ibm.com>
Subject: Re: RCU CPU stall console spews  leads to soft lockup disabled is
 reasonable ?
References: <54BCBB33.6060608@huawei.com> <20150119084200.GE9719@linux.vnet.ibm.com> <54BCC89D.9040702@huawei.com> <20150119140612.GI116159@redhat.com>
In-Reply-To: <20150119140612.GI116159@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.68.57]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020203.54BDC6F2.0138,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 7361b06e8afe42c1ac4b936e9833438f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015/1/19 22:06, Don Zickus wrote:
> On Mon, Jan 19, 2015 at 05:04:29PM +0800, Zhang Zhen wrote:
>>>
>>> Did you really intend to acquire the same spinlock twice in a row,
>>> forcing a self-deadlock?  If not, I of course suggest changing the second
>>> "spin_lock()" to "spin_unlock()".
>>>
>>
>> Yes, i acquire the same spinlock twice in order to reproduce the problem.
>>
>>> If your .config has CONFIG_TREE_RCU=y, the above is quite likely to
>>> give you an RCU CPU stall warning.
>>>
>>
>> In my .config CONFIG_TREE_RCU=y.
>>
>> If softlockup_thresh < rcu_cpu_stall_timeout, it will give soft lockup warning.
>> If softlockup_thresh > rcu_cpu_stall_timeout, it will likely to give RCU CPU stall warning
>> just like above and no give soft lockup warning.
>>
>> It means that RCU CPU stall console spews leads to soft lockup disabled.
>> Is this reasonable ?
> 
> I believe so.  In kernel v3.10.., all activity to the console executed
> touch_nmi_watchdog() which calls touch_softlockup_watchdog, which delayed
> the softlockup for another round of 'softlockup_thresh'.
> 
Yeah, you are right. It's the real reason.

> Of course back then, touch_nmi_watchdog touched all cpus.  So a problem
> like this was masked.  I believe this upstream commit 62572e29bc53, solved
> the problem.

Thanks for your suggestion.

Commit 62572e29bc53 changed the semantics of touch_nmi_watchdog and make it
only touch local cpu not every one.
But watchdog_nmi_touch = true only guarantee no hard lockup check on this cpu.

Commit 62572e29bc53 didn't changed the semantics of touch_softlockup_watchdog.
> 
> You can apply that commit and see if you if you get both RCU stall
> messages _and_ softlockup messages.  I believe that is what you were
> expecting, correct?
> 
Correct, i expect i can get  both RCU stall messages _and_ softlockup messages.
I applied that commit, and i only got RCU stall messages.

/ #
/ #  echo 60 > /proc/sys/kernel/watchdog_thresh
/ # busybox insmod softlockup_test.ko
[   35.344060] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=21002 jiffies, g=85, c=84, q=4)
[   35.344060] INFO: Stall ended before state dump start
[   98.349079] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=84007 jiffies, g=85, c=84, q=4)
[   98.349079] INFO: Stall ended before state dump start
[  161.354100] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=147012 jiffies, g=85, c=84, q=4)
[  161.354100] INFO: Stall ended before state dump start
> 
> Of course, on a non-virt guest, your test case would normally trigger a
> hardlockup warning first.  And a later kernel version for the guest may
> actually do that (not quite sure if the emulated PMU stuff is upstream or
> not yet).  Just to set your expectations correctly.
> 
Yes, on a non-virt guest, my test case tiggered hardlockup warning firt.

Best regards!
> Cheers,
> Don
> 
>>
>> Thanks!
>>
>>>>         return 0;
>>>> }
>>>>
>>>> static int __init test_init(void)
>>>> {
>>>>         hello_start();
>>>>
>>>>         printk(KERN_INFO "Module init\n");
>>>>         return 0;
>>>> }
>>>>
>>>> static void __exit test_exit(void)
>>>> {
>>>>         printk(KERN_INFO "Module exit!\n");
>>>> }
>>>>
>>>> module_init(test_init)
>>>> module_exit(test_exit)
>>>> MODULE_LICENSE("GPL");
>>>> //
>>>>
>>>> My kernel version is v3.10.63, and i checked the kernel source code,
>>>>
>>>> update_process_times
>>>> 	-> run_local_timers
>>>> 		-> hrtimer_run_queues
>>>> 			-> __run_hrtimer
>>>> 				-> watchdog_timer_fn
>>>> 					-> is_softlockup
>>>> 					
>>>> 	-> rcu_check_callbacks
>>>> 		-> __rcu_pending
>>>> 			-> check_cpu_stall
>>>> 				-> print_cpu_stall
>>>>
>>>> If softlockup_thresh > rcu_cpu_stall_timeout, print_cpu_stall will print log to serial port.
>>>>
>>>> The 8250 serial driver will call serial8250_console_write => touch_nmi_watchdog() which reset
>>>> watchdog_touch_ts to 0. So the softlockup will not be triggered.
>>>>
>>>> Is this reasonable? Why?
>>>
>>> Is exactly what reasonable?  ;-)
>>>
>>> Yes, it is reasonable that your code triggers an RCU CPU stall warning.
>>>
>>> No, it is not reasonable that the RCU CPU stall warning does not include
>>> a stack trace, and the fix for that bug will be going into the next merge
>>> window.
>>>
>>> Yes, is is reasonable that varying the softlockup and RCU CPU stall
>>> timeouts might change the behavior.
>>>
>>> No, your code is not reasonable, except perhaps as a test of the
>>> generation of softlockup and RCU CPU stall warnings.  If you are not
>>> trying to test softlockup and RCU CPU stall warnings, you should of course
>>> not try to acquire any non-recursive exclusive lock that you already hold.
>>>
>>>> If it is not reasonable, we should adjust the printk loglevel from *KERN_ERR* to *KERN_INFO*
>>>> in print_cpu_stall.
>>>
>>> Given that RCU CPU stall warnings are supposed to be pointing out errors
>>> elsewhere in the kernel, and in this case are pointing out errors elsewhere
>>> in the kernel, namely in your hello_start() function, it is reasonable
>>> that the RCU CPU stall warnings use the KERN_ERR loglevel.
>>>
>>> Or am I missing something here?
>>>
>>> 							Thanx, Paul
>>>
>>>
>>> .
>>>
>>
>>
> 
> .
> 


