Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751704AbbASIHy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 03:07:54 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:42118 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbbASIHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 03:07:53 -0500
Message-ID: <54BCBB33.6060608@huawei.com>
Date: Mon, 19 Jan 2015 16:07:15 +0800
From: Zhang Zhen <zhenzhang.zhang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
CC: <morgan.wang@huawei.com>, <josh@freedesktop.org>,
        <paulmck@linux.vnet.ibm.com>, <dzickus@redhat.com>,
        <dipankar@in.ibm.com>
Subject: RCU CPU stall console spews  leads to soft lockup disabled is reasonable
 ?
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.68.57]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On my x86_64 qemu virtual machine, RCU CPU stall console spews may
lead to soft lockup disabled.

If softlockup_thresh > rcu_cpu_stall_timeout (softlockup_thresh = 2 * watchdog_thresh):

/ #
/ # busybox cat /sys/module/rcupdate/parameters/rcu_cpu_stall_timeout
21
/ # echo 60 > /proc/sys/kernel/watchdog_thresh
/ # busybox insmod softlockup_test.ko
[   44.959044] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=21002 jiffies, g=85, c=84, q=4)
[   44.959044] INFO: Stall ended before state dump start
[  107.964045] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=84007 jiffies, g=85, c=84, q=4)
[  107.964045] INFO: Stall ended before state dump start
[  170.969060] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=147012 jiffies, g=85, c=84, q=4)
[  170.969060] INFO: Stall ended before state dump start
[  233.974057] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=210017 jiffies, g=85, c=84, q=4)
[  233.974057] INFO: Stall ended before state dump start
[  296.979059] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=273022 jiffies, g=85, c=84, q=4)
[  296.979059] INFO: Stall ended before state dump start
[  359.984058] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=336027 jiffies, g=85, c=84, q=4)
[  359.984058] INFO: Stall ended before state dump start
[  422.989059] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=399032 jiffies, g=85, c=84, q=4)
[  422.989059] INFO: Stall ended before state dump start
[  485.994056] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=462037 jiffies, g=85, c=84, q=4)
[  485.994056] INFO: Stall ended before state dump start
[  548.999059] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=525042 jiffies, g=85, c=84, q=4)
[  548.999059] INFO: Stall ended before state dump start
[  612.004061] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=588047 jiffies, g=85, c=84, q=4)
[  612.004061] INFO: Stall ended before state dump start
[  675.009058] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=651052 jiffies, g=85, c=84, q=4)
[  675.009058] INFO: Stall ended before state dump start

If softlockup_thresh < rcu_cpu_stall_timeout:

/ #
/ # busybox cat /sys/module/rcupdate/parameters/rcu_cpu_stall_timeout
21
/ # echo 5 > /proc/sys/kernel/watchdog_thresh
/ # busybox insmod softlockup_test.ko
[   38.450061] BUG: soft lockup - CPU#0 stuck for 11s! [busybox:53]
[   52.450061] BUG: soft lockup - CPU#0 stuck for 11s! [busybox:53]
[   66.450073] BUG: soft lockup - CPU#0 stuck for 11s! [busybox:53]
[   80.450060] BUG: soft lockup - CPU#0 stuck for 11s! [busybox:53]
[   94.450061] BUG: soft lockup - CPU#0 stuck for 11s! [busybox:53]

The softlockup_test.ko source code is:
//
#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/spinlock.h>
#include <linux/slab.h>

static int hello_start(void)
{
        DEFINE_SPINLOCK(hello_lock);
        spin_lock_init(&hello_lock);
        spin_lock(&hello_lock);
        spin_lock(&hello_lock);
        return 0;
}

static int __init test_init(void)
{
        hello_start();

        printk(KERN_INFO "Module init\n");
        return 0;
}

static void __exit test_exit(void)
{
        printk(KERN_INFO "Module exit!\n");
}

module_init(test_init)
module_exit(test_exit)
MODULE_LICENSE("GPL");
//

My kernel version is v3.10.63, and i checked the kernel source code,

update_process_times
	-> run_local_timers
		-> hrtimer_run_queues
			-> __run_hrtimer
				-> watchdog_timer_fn
					-> is_softlockup
					
	-> rcu_check_callbacks
		-> __rcu_pending
			-> check_cpu_stall
				-> print_cpu_stall

If softlockup_thresh > rcu_cpu_stall_timeout, print_cpu_stall will print log to serial port.

The 8250 serial driver will call serial8250_console_write => touch_nmi_watchdog() which reset
watchdog_touch_ts to 0. So the softlockup will not be triggered.

Is this reasonable? Why?
If it is not reasonable, we should adjust the printk loglevel from *KERN_ERR* to *KERN_INFO*
in print_cpu_stall.


