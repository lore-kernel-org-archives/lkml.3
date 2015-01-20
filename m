Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204AbbATDRg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 22:17:36 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:13541 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093AbbATDRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 22:17:34 -0500
Message-ID: <54BDC8AD.7040600@huawei.com>
Date: Tue, 20 Jan 2015 11:17:01 +0800
From: Zhang Zhen <zhenzhang.zhang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: <paulmck@linux.vnet.ibm.com>
CC: <linux-kernel@vger.kernel.org>, <morgan.wang@huawei.com>,
        <josh@freedesktop.org>, <dzickus@redhat.com>, <dipankar@in.ibm.com>
Subject: Re: RCU CPU stall console spews  leads to soft lockup disabled is
 reasonable ?
References: <54BCBB33.6060608@huawei.com> <20150119084200.GE9719@linux.vnet.ibm.com> <54BCC89D.9040702@huawei.com> <20150119110935.GH9719@linux.vnet.ibm.com>
In-Reply-To: <20150119110935.GH9719@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.68.57]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015/1/19 19:09, Paul E. McKenney wrote:
> On Mon, Jan 19, 2015 at 05:04:29PM +0800, Zhang Zhen wrote:
>> On 2015/1/19 16:42, Paul E. McKenney wrote:
>>> On Mon, Jan 19, 2015 at 04:07:15PM +0800, Zhang Zhen wrote:
>>>> Hi,
>>>>
>>>> On my x86_64 qemu virtual machine, RCU CPU stall console spews may
>>>> lead to soft lockup disabled.
>>>>
>>>> If softlockup_thresh > rcu_cpu_stall_timeout (softlockup_thresh = 2 * watchdog_thresh):
>>>>
>>>> / #
>>>> / # busybox cat /sys/module/rcupdate/parameters/rcu_cpu_stall_timeout
>>>> 21
>>>> / # echo 60 > /proc/sys/kernel/watchdog_thresh
>>>> / # busybox insmod softlockup_test.ko
>>>> [   44.959044] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=21002 jiffies, g=85, c=84, q=4)
>>>> [   44.959044] INFO: Stall ended before state dump start
>>>> [  107.964045] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=84007 jiffies, g=85, c=84, q=4)
>>>> [  107.964045] INFO: Stall ended before state dump start
>>>> [  170.969060] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=147012 jiffies, g=85, c=84, q=4)
>>>> [  170.969060] INFO: Stall ended before state dump start
>>>> [  233.974057] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=210017 jiffies, g=85, c=84, q=4)
>>>> [  233.974057] INFO: Stall ended before state dump start
>>>> [  296.979059] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=273022 jiffies, g=85, c=84, q=4)
>>>> [  296.979059] INFO: Stall ended before state dump start
>>>> [  359.984058] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=336027 jiffies, g=85, c=84, q=4)
>>>> [  359.984058] INFO: Stall ended before state dump start
>>>> [  422.989059] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=399032 jiffies, g=85, c=84, q=4)
>>>> [  422.989059] INFO: Stall ended before state dump start
>>>> [  485.994056] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=462037 jiffies, g=85, c=84, q=4)
>>>> [  485.994056] INFO: Stall ended before state dump start
>>>> [  548.999059] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=525042 jiffies, g=85, c=84, q=4)
>>>> [  548.999059] INFO: Stall ended before state dump start
>>>> [  612.004061] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=588047 jiffies, g=85, c=84, q=4)
>>>> [  612.004061] INFO: Stall ended before state dump start
>>>> [  675.009058] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=651052 jiffies, g=85, c=84, q=4)
>>>> [  675.009058] INFO: Stall ended before state dump start
>>>>
>>>> If softlockup_thresh < rcu_cpu_stall_timeout:
>>>>
>>>> / #
>>>> / # busybox cat /sys/module/rcupdate/parameters/rcu_cpu_stall_timeout
>>>> 21
>>>> / # echo 5 > /proc/sys/kernel/watchdog_thresh
>>>> / # busybox insmod softlockup_test.ko
>>>> [   38.450061] BUG: soft lockup - CPU#0 stuck for 11s! [busybox:53]
>>>> [   52.450061] BUG: soft lockup - CPU#0 stuck for 11s! [busybox:53]
>>>> [   66.450073] BUG: soft lockup - CPU#0 stuck for 11s! [busybox:53]
>>>> [   80.450060] BUG: soft lockup - CPU#0 stuck for 11s! [busybox:53]
>>>> [   94.450061] BUG: soft lockup - CPU#0 stuck for 11s! [busybox:53]
>>>>
>>>> The softlockup_test.ko source code is:
>>>> //
>>>> #include <linux/kernel.h>
>>>> #include <linux/module.h>
>>>> #include <linux/spinlock.h>
>>>> #include <linux/slab.h>
>>>>
>>>> static int hello_start(void)
>>>> {
>>>>         DEFINE_SPINLOCK(hello_lock);
>>>>         spin_lock_init(&hello_lock);
>>>>         spin_lock(&hello_lock);
>>>>         spin_lock(&hello_lock);
>>>
>>> Did you really intend to acquire the same spinlock twice in a row,
>>> forcing a self-deadlock?  If not, I of course suggest changing the second
>>> "spin_lock()" to "spin_unlock()".
>>
>> Yes, i acquire the same spinlock twice in order to reproduce the problem.
> 
> Good, I was wondering about that.  ;-)
> 
>>> If your .config has CONFIG_TREE_RCU=y, the above is quite likely to
>>> give you an RCU CPU stall warning.
>>
>> In my .config CONFIG_TREE_RCU=y.
> 
> Which is consistent.
> 
>> If softlockup_thresh < rcu_cpu_stall_timeout, it will give soft lockup warning.
>> If softlockup_thresh > rcu_cpu_stall_timeout, it will likely to give RCU CPU stall warning
>> just like above and no give soft lockup warning.
>>
>> It means that RCU CPU stall console spews leads to soft lockup disabled.
>> Is this reasonable ?
> 
> It depends.  You will often see both of them, but they can interfere
> with each other, especially if all these messages are going across a
> serial line.  And sometimes the activity of the one will suppress the
> other, though I would not expect that in your spinlock deadlock case.
> 
Ok, my expect is to get both RCU stall messages _and_ softlockup messages
even though all these messages are going across a serial line.
But in my test case the RCU stall messages suppress the other.

The simplest way is to change the RCU CPU stall warnings use the KERN_INFO
loglevel.
Is there any better way to get both RCU stall messages _and_ softlockup messages
in any case ?

Thanks!
> 							Thanx, Paul
> 
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
> 
> .
> 


