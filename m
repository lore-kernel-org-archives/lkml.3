Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752Ab3H2OLK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 10:11:10 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:56022 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231Ab3H2OLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 10:11:09 -0400
Message-ID: <521F55CD.8090207@huawei.com>
Date: Thu, 29 Aug 2013 22:08:13 +0800
From: Libin <huawei.libin@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Libin <huawei.libin@huawei.com>
CC: <akpm@linux-foundation.org>, <tj@kernel.org>, <viro@zeniv.linux.org.uk>,
        <eparis@redhat.com>, <tglx@linutronix.de>, <rusty@rustcorp.com.au>,
        <ebiederm@xmission.com>, <paulmck@linux.vnet.ibm.com>,
        <john.stultz@linaro.org>, <mingo@redhat.com>, <peterz@infradead.org>,
        <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        <lizefan@huawei.com>, <jovi.zhangwei@huawei.com>,
        <guohanjun@huawei.com>, <zhangdianfang@huawei.com>,
        <wangyijing@huawei.com>
Subject: Re: [PATCH 00/14] Fix bug about invalid wake up problem
References: <1377784669-28140-1-git-send-email-huawei.libin@huawei.com>
In-Reply-To: <1377784669-28140-1-git-send-email-huawei.libin@huawei.com>
Content-Type: multipart/mixed;
	boundary="------------090208000303060606030307"
X-Originating-IP: [10.135.74.57]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------090208000303060606030307
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit

On 2013/8/29 21:57, Libin wrote:
....
> 2)Test:
> I have written a test module to trigger the problem by adding some
> synchronization condition. I will post it in the form of an attachment soon.
> 
> Test result as follows:
> [103135.332683] wakeup_test: create two kernel threads - producer & consumer
> [103135.332686] wakeup_test: module loaded successfully
> [103135.332692] wakeup_test: kthread producer try to wake up the kthread consumer
> [103165.299865] wakeup_test: kthread consumer have waited for 30s, indicating
> trigger an invalid wakeup problem!
> 
....







--------------090208000303060606030307
Content-Type: text/plain; charset="gb18030"; name="wakeup_test.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="wakeup_test.c"

/*
 * wakeup_test.c -- Linux kernel invalid wake up problem simulation test module
 *
 * Written By: Libin <huawei.libin@huawei.com>
 *
 * History
 * -------
 */
#include <linux/init.h>
#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/kthread.h>
#include <linux/sched.h>
#include <linux/list.h>
#include <linux/slab.h>
#include <linux/completion.h>
#include <linux/timer.h>

#define NAME	"wakeup_test"
#define WAIT_TIMEOUT	HZ*30
static LIST_HEAD(product_list);
struct product_struct{
	int data;
	struct list_head list;
};
static struct task_struct *producer, *consumer;
static struct completion done;

static int producer_thread(void *unused)
{
	struct product_struct *product;
	product = (struct product_struct *)kmalloc(sizeof (struct product_struct), GFP_KERNEL);	
	product->data = 1;	

	list_add_tail(&product->list, &product_list);

	wake_up_process(consumer);
	printk(KERN_INFO "%s: kthread producer try to wake up the kthread consumer\n", NAME);
	complete(&done); /* NOTE: added for problem trigger simulation */

	while (!kthread_should_stop()){
		set_current_state(TASK_INTERRUPTIBLE);
		schedule_timeout(HZ);
	}

	printk(KERN_INFO "%s: kthread producer exit\n", NAME);
	return 0;	
}
static void simulate_preempted(void)
{
	schedule();
}

static void wakeup_wait_timeout(unsigned long unused)
{
	printk(KERN_ERR "%s: kthread consumer have waited for %ds, "
		"indicating trigger an invalid wakeup problem!\n", NAME, WAIT_TIMEOUT/HZ);
}
static int consumer_thread(void *unused)
{
	struct timer_list wakeup_wait_timer;
	setup_timer(&wakeup_wait_timer, wakeup_wait_timeout, (unsigned long)NULL);
	wait_for_completion(&done); /* NOTE: added for problem trigger simulation */

	mod_timer(&wakeup_wait_timer, jiffies + WAIT_TIMEOUT);
	set_current_state(TASK_INTERRUPTIBLE);

	simulate_preempted(); /* NOTE: added for problem trigger simulation */
	while (list_empty(&product_list)){
		schedule();
		set_current_state(TASK_INTERRUPTIBLE);
	}
	__set_current_state(TASK_RUNNING);

	del_timer_sync(&wakeup_wait_timer);
	if (kthread_should_stop()){
		goto out;
	}

	if (!list_empty(&product_list)){
		printk(KERN_INFO "%s: kthread consumer be woken up successfully, all right!\n", NAME);
	}

	while (!kthread_should_stop()){
		set_current_state(TASK_INTERRUPTIBLE);
		schedule_timeout(HZ);
	}

out:
	printk(KERN_INFO "%s: kthread consumer exit\n", NAME);
	return 0;	
}

static int __init wakeup_test_init(void)
{
	producer = kthread_create(producer_thread, NULL, "producer");
	consumer = kthread_create(consumer_thread, NULL, "consumer");
	init_completion(&done);
	
	wake_up_process(producer);
	wake_up_process(consumer);
	printk(KERN_INFO "%s: create two kernel threads - producer & consumer\n", NAME);
	printk(KERN_INFO "%s: module loaded successfully\n", NAME);
	return 0;
}
static void __exit wakeup_test_exit(void)
{
	kthread_stop(producer);
	kthread_stop(consumer);
	printk(KERN_INFO "%s: module unloaded successfully\n", NAME);
}
module_init(wakeup_test_init);
module_exit(wakeup_test_exit);
MODULE_LICENSE("GPL");


--------------090208000303060606030307--
