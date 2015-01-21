Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750974AbbAUH0X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 02:26:23 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:27789 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbbAUH0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 02:26:19 -0500
Message-ID: <54BF5461.5070501@huawei.com>
Date: Wed, 21 Jan 2015 15:25:21 +0800
From: Zhang Zhen <zhenzhang.zhang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: <paulmck@linux.vnet.ibm.com>
CC: Don Zickus <dzickus@redhat.com>, <linux-kernel@vger.kernel.org>,
        <morgan.wang@huawei.com>, <josh@freedesktop.org>,
        <dipankar@in.ibm.com>
Subject: Re: RCU CPU stall console spews  leads to soft lockup disabled is
 reasonable ?
References: <54BCBB33.6060608@huawei.com> <20150119084200.GE9719@linux.vnet.ibm.com> <54BCC89D.9040702@huawei.com> <20150119140612.GI116159@redhat.com> <54BDC6DF.6000602@huawei.com> <20150120152531.GR116159@redhat.com> <54BF0E53.5040409@huawei.com> <54BF1957.6080606@huawei.com> <54BF4D0D.3090500@huawei.com> <20150121070246.GB9719@linux.vnet.ibm.com>
In-Reply-To: <20150121070246.GB9719@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.68.57]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015/1/21 15:02, Paul E. McKenney wrote:
> On Wed, Jan 21, 2015 at 02:54:05PM +0800, Zhang Zhen wrote:
>> On 2015/1/21 11:13, Zhang Zhen wrote:
>>> On 2015/1/21 10:26, Zhang Zhen wrote:
>>>> On 2015/1/20 23:25, Don Zickus wrote:
> 
> [ . . . ]
> 
>>> Sorry, i made a mistake, the log above is based on v3.10.63.
>>> I have tested the latest upstream kernel (based on ec6f34e5b552),
>>> but my test case can't triggered RCU stall warning.
>>>
>>
>> I used git bisect to find the bad commit, but found a irrelevant
>> commit(db5d711e2db776 zram: avoid null access when fail to alloc meta).
>> Before this commit, my test case can easily trigger RCU stall warning,
>> but after this commit, my test case can't trigger RCU stall warning.
> 
> I have lost track of exactly what kernel you are using.  If you are
> using a recent kernel (v3.18 or thereabouts), one thing to try is to
> apply my stack of RCU CPU stall-warning changes that are on their way
> in, please see v3.19-rc1..630181c4a915 in -rcu, which is at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git
> 
> These handle the problems that Dave Jones and a few others located this
> past December.  Could you please give them a spin?
> 
Ok, i will try.

Thanks!
>                                                         Thanx, Paul
> 
>> I'm totally confused.
>>
>> My test case:
>>
>> //
>> #include <linux/kernel.h>
>> #include <linux/module.h>
>> #include <linux/spinlock.h>
>> #include <linux/slab.h>
>> #include <linux/kthread.h>
>>
>> struct foo {
>>         int a;
>>         char b;
>>         long c;
>> };
>>
>> struct foo gbl_foo = {1, 'a', 2};
>> struct foo *pgbl_foo = &gbl_foo;
>>
>> static int my_kthread(void *data)
>> {
>>         DEFINE_SPINLOCK(foo_mutex);
>>         struct foo *new_fp;
>>         struct foo *old_fp;
>>
>>         new_fp = kmalloc(sizeof(*new_fp), GFP_KERNEL);
>>         spin_lock(&foo_mutex);
>>         old_fp = pgbl_foo;
>>         *new_fp = *old_fp;
>>         new_fp->a = 2;
>>         rcu_assign_pointer(pgbl_foo, new_fp);
>>         spin_unlock(&foo_mutex);
>>         synchronize_rcu();
>>         kfree(old_fp);
>>
>>         return 0;
>> }
>>
>> static int hello_start(void)
>> {
>>         struct task_struct *my_task = NULL;
>>         DEFINE_SPINLOCK(hello_lock);
>>
>>         my_task = kthread_run(my_kthread, NULL, "my_thread%d", 1);
>>
>>         spin_lock_init(&hello_lock);
>>         spin_lock(&hello_lock);
>>         spin_lock(&hello_lock);
>>         return 0;
>> }
>>
>> static int __init test_init(void)
>> {
>>         hello_start();
>>
>>         printk(KERN_INFO "Module init\n");
>>         return 0;
>> }
>>
>> static void __exit test_exit(void)
>> {
>>         printk(KERN_INFO "Module exit!\n");
>> }
>>
>> module_init(test_init)
>> module_exit(test_exit)
>> MODULE_LICENSE("GPL");
>> //
>>>>>
>>>>> Cheers,
>>>>> Don
>>>>>
>>>>> diff --git a/kernel/watchdog.c b/kernel/watchdog.c
>>>>> index 70bf118..833c015 100644
>>>>> --- a/kernel/watchdog.c
>>>>> +++ b/kernel/watchdog.c
>>>>> @@ -209,7 +209,7 @@ void touch_nmi_watchdog(void)
>>>>>  	 * going off.
>>>>>  	 */
>>>>>  	raw_cpu_write(watchdog_nmi_touch, true);
>>>>> -	touch_softlockup_watchdog();
>>>>> +	//touch_softlockup_watchdog();
>>>>>  }
>>>>>  EXPORT_SYMBOL(touch_nmi_watchdog);
>>>>>  
>>>>>
>>>>> .
>>>>>
>>>>
>>>
>>
>>
> 
> 
> .
> 


