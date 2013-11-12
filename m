Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565Ab3KLPQL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 10:16:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52078 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753375Ab3KLPQJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 10:16:09 -0500
Date: Tue, 12 Nov 2013 10:15:41 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [seqcount] INFO: trying to register non-static key.
Message-ID: <20131112151541.GD24980@redhat.com>
References: <20131111012927.GA404@localhost>
 <20131111154551.GJ19203@twins.programming.kicks-ass.net>
 <20131112094147.GA32441@localhost>
 <20131112100140.GM5056@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131112100140.GM5056@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 11:01:40AM +0100, Peter Zijlstra wrote:
> On Tue, Nov 12, 2013 at 05:41:47PM +0800, Fengguang Wu wrote:
> > On Mon, Nov 11, 2013 at 04:45:51PM +0100, Peter Zijlstra wrote:
> > > On Mon, Nov 11, 2013 at 09:29:27AM +0800, Fengguang Wu wrote:
> > > > Greetings,
> > > > 
> > > > I got the below dmesg and the first bad commit is
> > > > 
> > > > commit 1ca7d67cf5d5a2aef26a8d9afd789006fa098347
> > > > Author: John Stultz <john.stultz@linaro.org>
> > > > Date:   Mon Oct 7 15:51:59 2013 -0700
> > > > 
> > > >     seqcount: Add lockdep functionality to seqcount/seqlock structures
> > > >
> > > 
> > > > [    4.124336] uli526x: ULi M5261/M5263 net driver, version 0.9.3 (2005-7-29)
> > > > [    4.128027] Call Trace:
> > > > [    4.128027]  [<7908e744>] ? console_unlock+0x353/0x380
> > > > [    4.128027]  [<79dc7cf2>] dump_stack+0x48/0x60
> > > > [    4.128027]  [<7908953e>] __lock_acquire.isra.26+0x7e3/0xceb
> > > > [    4.128027]  [<7908a1c5>] lock_acquire+0x71/0x9a
> > > > [    4.128027]  [<794079aa>] ? blk_throtl_bio+0x1c3/0x485
> > > > [    4.128027]  [<7940658b>] throtl_update_dispatch_stats+0x7c/0x153
> > > 
> > > The below seems to compile with i386-defconfig + CONFIG_CFQ_GROUP_IOSCHED=y
> > > 
> > > No idea if it runs properly or not; I seem to have misplaced my i386
> > > root filesystem.
> > > 
> > > ---
> > > Subject: block: Employ u64_stats_init()
> > > 
> > > Now that seqcounts are lockdep tracked thingies, we need to properly
> > > initialize them, otherwise bad stuff happens.
> > 
> > FYI the warning is still there:
> > 
> > /kernel/i386-randconfig-j7-11082318/d3516a7318f8e22f5462888fdf9edc8f0f128024
> > 
> > +-------------------------------------------------+-------+--------------+--------------+
> > |                                                 | v3.12 | 838cc7b488f8 | d3516a7318f8 |
> > +-------------------------------------------------+-------+--------------+--------------+
> > | boot_successes                                  | 129   | 0            | 0            |
> > | boot_failures                                   | 1     | 100          | 100          |
> > | BUG:kernel_early_hang_without_any_printk_output | 1     |              |              |
> > | INFO:trying_to_register_non-static_key          | 0     | 100          | 100          |
> > +-------------------------------------------------+-------+--------------+--------------+
> 
> Is that from the exact same spot as before
> (throtl_update_dispatch_stats) or did we hit another one?

[CC tejun]

Peter, 

I am wondering if you have to modify blk-throtl.c too to take care
of per cpu stats contained inside throtl_grp.

I see that we allocate per cpu stats but don't do any initializations.

static void tg_stats_alloc_fn(struct work_struct *work)
{
        static struct tg_stats_cpu *stats_cpu;  /* this fn is non-reentrant */
        struct delayed_work *dwork = to_delayed_work(work);
        bool empty = false;

alloc_stats:
        if (!stats_cpu) {
                stats_cpu = alloc_percpu(struct tg_stats_cpu);
                if (!stats_cpu) {
                        /* allocation failed, try again after some time */
                        schedule_delayed_work(dwork, msecs_to_jiffies(10));
                        return;
                }
        }

        spin_lock_irq(&tg_stats_alloc_lock);

Thanks
Vivek

