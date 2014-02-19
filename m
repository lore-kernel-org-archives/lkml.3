Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751795AbaBSB5T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 20:57:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35051 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750871AbaBSB5S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 20:57:18 -0500
Date: Tue, 18 Feb 2014 20:57:11 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Tejun Heo <tj@kernel.org>
cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Lisa Du <chunlingdu1@gmail.com>,
        Mandeep Singh Baines <msb@chromium.org>
Subject: work item migration bug when a CPU is disabled
Message-ID: <alpine.LRH.2.02.1402182040100.28214@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun

Two years ago, I reported a bug in workqueues - a work item that is 
supposed to be bound to a specific CPU can be migrated to a different CPU 
when the origianl CPU is disabled by writing zero to 
/sys/devices/system/cpu/cpu*/online

This causes crashes in dm-crypt, because it assumes that a work item stays 
on the same CPU.

There was some discussion (see here 
http://www.redhat.com/archives/dm-devel/2012-March/msg00034.html ), but 
the bug is still unfixed and I've just got another bug report about 
dm-crypt crashing because of it.

I'd like to ask - are you going to fix the workqueue code so that work 
item migrations can't happen? - or are you going to specify that work item 
migration can happen and do you require that all code that relies on the 
fact that a work item executes on a single CPU be fixed?

Here I'm sending a simple kernel module that shows the bug.

Mikulas



/*
 * A proof of concept that a work item executed on a workqueue may change CPU
 * when CPU hot-unplugging is used.
 * Compile this as a module and run:
 * insmod test.ko; sleep 1; echo 0 >/sys/devices/system/cpu/cpu1/online
 * You see that the work item starts executing on CPU 1 and ends up executing
 * on different CPU, usually 0.
 */

#include <linux/module.h>
#include <linux/delay.h>

static struct workqueue_struct *wq;
static struct work_struct work;

static void do_work(struct work_struct *w)
{
        printk("starting work on cpu %d\n", smp_processor_id());
        msleep(10000);
        printk("finishing work on cpu %d\n", smp_processor_id());
}

static int __init test_init(void)
{
        printk("module init\n");
        wq = alloc_workqueue("testd", WQ_MEM_RECLAIM | WQ_CPU_INTENSIVE, 
1);
        if (!wq) {
                printk("alloc_workqueue failed\n");
                return -ENOMEM;
        }
        INIT_WORK(&work, do_work);
        queue_work_on(1, wq, &work);
        return 0;
}

static void __exit test_exit(void)
{
        destroy_workqueue(wq);
        printk("module exit\n");
}

module_init(test_init)
module_exit(test_exit)
MODULE_LICENSE("GPL");

