Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859Ab3GQKDa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 06:03:30 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:33956 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753638Ab3GQKD2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 06:03:28 -0400
X-IronPort-AV: E=Sophos;i="4.89,678,1367942400"; 
   d="scan'208";a="7923161"
Message-ID: <51E66CCC.9010600@cn.fujitsu.com>
Date: Wed, 17 Jul 2013 18:07:08 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        bhelgaas@google.com
Subject: Re: workqueue, pci: INFO: possible recursive locking detected
References: <51E55B7D.2040209@linux.vnet.ibm.com>
In-Reply-To: <51E55B7D.2040209@linux.vnet.ibm.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/17 18:01:33,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/17 18:01:35,
	Serialize complete at 2013/07/17 18:01:35
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2013 10:41 PM, Srivatsa S. Bhat wrote:
> Hi,
> 
> I have been seeing this warning every time during boot. I haven't
> spent time digging through it though... Please let me know if
> any machine-specific info is needed.
> 
> Regards,
> Srivatsa S. Bhat
> 
> 
> ----------------------------------------------------
> 
> =============================================
> [ INFO: possible recursive locking detected ]
> 3.11.0-rc1-lockdep-fix-a #6 Not tainted
> ---------------------------------------------
> kworker/0:1/142 is trying to acquire lock:
>  ((&wfc.work)){+.+.+.}, at: [<ffffffff81077100>] flush_work+0x0/0xb0
> 
> but task is already holding lock:
>  ((&wfc.work)){+.+.+.}, at: [<ffffffff81075dd9>] process_one_work+0x169/0x610
> 
> other info that might help us debug this:
>  Possible unsafe locking scenario:
> 
>        CPU0
>        ----
>   lock((&wfc.work));
>   lock((&wfc.work));


Hi, Srivatsa

This is false negative, the two "wfc"s are different, they are
both on stack. flush_work() can't be deadlock in such case:

void foo(void *)
{
	...
	if (xxx)
		work_on_cpu(..., foo, ...);
	...
}

bar()
{
	work_on_cpu(..., foo, ...);
}

The complaint is caused by "work_on_cpu() uses a static lock_class_key".
we should fix work_on_cpu().
(but the caller should also be careful, the foo()/local_pci_probe() is re-entering)

But I can't find an elegant fix.

long work_on_cpu(int cpu, long (*fn)(void *), void *arg)
{
	struct work_for_cpu wfc = { .fn = fn, .arg = arg };

+#ifdef CONFIG_LOCKDEP
+	static struct lock_class_key __key;
+	INIT_WORK_ONSTACK(&wfc.work, work_for_cpu_fn);
+	lockdep_init_map(&wfc.work.lockdep_map, &wfc.work, &__key, 0);
+#else
	INIT_WORK_ONSTACK(&wfc.work, work_for_cpu_fn);
+#endif
	schedule_work_on(cpu, &wfc.work);
	flush_work(&wfc.work);
	return wfc.ret;
}


Any think? Tejun?

thanks,
Lai

> 
>  *** DEADLOCK ***
> 
>  May be due to missing lock nesting notation
> 
> 3 locks held by kworker/0:1/142:
>  #0:  (events){.+.+.+}, at: [<ffffffff81075dd9>] process_one_work+0x169/0x610
>  #1:  ((&wfc.work)){+.+.+.}, at: [<ffffffff81075dd9>] process_one_work+0x169/0x610
>  #2:  (&__lockdep_no_validate__){......}, at: [<ffffffff8139a3ba>] device_attach+0x2a/0xc0
> 
> stack backtrace:
> CPU: 0 PID: 142 Comm: kworker/0:1 Not tainted 3.11.0-rc1-lockdep-fix-a #6
> Hardware name: IBM  -[8737R2A]-/00Y2738, BIOS -[B2E120RUS-1.20]- 11/30/2012
> Workqueue: events work_for_cpu_fn
>  ffff881036fecd88 ffff881036fef678 ffffffff8161a919 0000000000000003
>  ffff881036fec400 ffff881036fef6a8 ffffffff810c2234 ffff881036fec400
>  ffff881036fecd88 ffff881036fec400 0000000000000000 ffff881036fef708
> Call Trace:
>  [<ffffffff8161a919>] dump_stack+0x59/0x80
>  [<ffffffff810c2234>] print_deadlock_bug+0xf4/0x100
>  [<ffffffff810c3d14>] validate_chain+0x504/0x750
>  [<ffffffff810c426d>] __lock_acquire+0x30d/0x580
>  [<ffffffff810c4577>] lock_acquire+0x97/0x170
>  [<ffffffff81077100>] ? start_flush_work+0x220/0x220
>  [<ffffffff81077148>] flush_work+0x48/0xb0
>  [<ffffffff81077100>] ? start_flush_work+0x220/0x220
>  [<ffffffff810c2c10>] ? mark_held_locks+0x80/0x130
>  [<ffffffff81074cfb>] ? queue_work_on+0x4b/0xa0
>  [<ffffffff810c2f85>] ? trace_hardirqs_on_caller+0x105/0x1d0
>  [<ffffffff810c305d>] ? trace_hardirqs_on+0xd/0x10
>  [<ffffffff81077320>] work_on_cpu+0x80/0x90
>  [<ffffffff8106f950>] ? wqattrs_hash+0x190/0x190
>  [<ffffffff812d37b0>] ? pci_pm_prepare+0x60/0x60
>  [<ffffffff812a0059>] ? cpumask_next_and+0x29/0x50
>  [<ffffffff812d38da>] __pci_device_probe+0x9a/0xe0
>  [<ffffffff81620850>] ? _raw_spin_unlock_irq+0x30/0x50
>  [<ffffffff812d4be2>] ? pci_dev_get+0x22/0x30
>  [<ffffffff812d4c2a>] pci_device_probe+0x3a/0x60
>  [<ffffffff81620850>] ? _raw_spin_unlock_irq+0x30/0x50
>  [<ffffffff8139a4bc>] really_probe+0x6c/0x320
>  [<ffffffff8139a7b7>] driver_probe_device+0x47/0xa0
>  [<ffffffff8139a8c0>] ? __driver_attach+0xb0/0xb0
>  [<ffffffff8139a913>] __device_attach+0x53/0x60
>  [<ffffffff81398404>] bus_for_each_drv+0x74/0xa0
>  [<ffffffff8139a430>] device_attach+0xa0/0xc0
>  [<ffffffff812cb2d9>] pci_bus_add_device+0x39/0x60
>  [<ffffffff812eec21>] virtfn_add+0x251/0x3e0
>  [<ffffffff810c305d>] ? trace_hardirqs_on+0xd/0x10
>  [<ffffffff812ef29f>] sriov_enable+0x22f/0x3d0
>  [<ffffffff812ef48d>] pci_enable_sriov+0x4d/0x60
>  [<ffffffffa0143045>] be_vf_setup+0x175/0x410 [be2net]
>  [<ffffffffa01493ca>] be_setup+0x37a/0x4b0 [be2net]
>  [<ffffffffa0149ac0>] be_probe+0x5c0/0x820 [be2net]
>  [<ffffffff812d37fe>] local_pci_probe+0x4e/0x90
>  [<ffffffff8106f968>] work_for_cpu_fn+0x18/0x30
>  [<ffffffff81075e4a>] process_one_work+0x1da/0x610
>  [<ffffffff81075dd9>] ? process_one_work+0x169/0x610
>  [<ffffffff8107650c>] worker_thread+0x28c/0x3a0
>  [<ffffffff81076280>] ? process_one_work+0x610/0x610
>  [<ffffffff8107da3e>] kthread+0xee/0x100
>  [<ffffffff8107d950>] ? __init_kthread_worker+0x70/0x70
>  [<ffffffff8162a71c>] ret_from_fork+0x7c/0xb0
>  [<ffffffff8107d950>] ? __init_kthread_worker+0x70/0x70
> 
> 

