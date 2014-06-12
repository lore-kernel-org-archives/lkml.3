Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751771AbaFLWTM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 18:19:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35728 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750716AbaFLWTK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 18:19:10 -0400
Date: Fri, 13 Jun 2014 00:19:06 +0200
From: Jan Kara <jack@suse.cz>
To: Hannes Landeholm <hannes@jumpstarter.io>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: deadlock in fsnotify, inotify broken in 3.14.1?
Message-ID: <20140612221906.GA13667@quack.suse.cz>
References: <CABt9es9BZoy24cdULeutpi4wU_99iAbtu53nzYLnrzQ2JYCWYA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABt9es9BZoy24cdULeutpi4wU_99iAbtu53nzYLnrzQ2JYCWYA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 16-05-14 11:40:05, Hannes Landeholm wrote:
> We are heavily relying on inotify to buffer data that is transferred
> between one and more processes. Recently we've been seeing production
> servers being deadlocked under light to moderate load with the same
> problem signature. It's happened 3 times now in about 24 hours on
> different servers. Example extract from system log:
> 
  Hum, interesting. We are hanging when trying to acquire mark_mutex but
the traces you've posted don't show any process which is holding it. Can
you still recreate the problem? If yes, can you do:
  echo w >/proc/sysrq-trigger
and post output from dmesg? Thanks!

								Honza

> kernel: INFO: task fsnotify_mark:42 blocked for more than 120 seconds.
> kernel:       Not tainted 3.14.1-1-js #1
> kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
> this message.
> kernel: fsnotify_mark   D 0000000000000000     0    42      2 0x00000000
> kernel:  ffff88039d81fcc0 0000000000000246 ffff88039ee7c4b0 ffff88039d81ffd8
> kernel:  00000000000142c0 00000000000142c0 ffff88039ee7c4b0 ffff88039d81fc80
> kernel:  ffff88039ee2f800 ffff88039ee41600 ffff88039d81fd00 ffffffff810a4664
> kernel: Call Trace:
> kernel:  [<ffffffff810a4664>] ? load_balance+0x174/0x890
> kernel:  [<ffffffff8109477a>] ? update_rq_clock.part.78+0x1a/0x100
> kernel:  [<ffffffff814db4d9>] schedule+0x29/0x70
> kernel:  [<ffffffff814da649>] schedule_timeout+0x1e9/0x270
> kernel:  [<ffffffff810728ab>] ? lock_timer_base.isra.35+0x2b/0x50
> kernel:  [<ffffffff81072067>] ? internal_add_timer+0x17/0x40
> kernel:  [<ffffffff814de216>] ? _raw_spin_unlock_irqrestore+0x16/0x30
> kernel:  [<ffffffff81072d15>] ? mod_timer+0x115/0x260
> kernel:  [<ffffffff814dbe93>] wait_for_common+0xd3/0x180
> kernel:  [<ffffffff81098420>] ? wake_up_process+0x40/0x40
> kernel:  [<ffffffff814dbf5d>] wait_for_completion+0x1d/0x20
> kernel:  [<ffffffff810c672d>] __synchronize_srcu+0xdd/0x110
> kernel:  [<ffffffff810c6260>] ? call_srcu+0x70/0x70
> kernel:  [<ffffffff814de216>] ? _raw_spin_unlock_irqrestore+0x16/0x30
> kernel:  [<ffffffff810c677d>] synchronize_srcu+0x1d/0x20
> kernel:  [<ffffffff811e7e27>] fsnotify_mark_destroy+0x87/0x150
> kernel:  [<ffffffff810aa930>] ? __wake_up_sync+0x20/0x20
> kernel:  [<ffffffff811e7da0>] ? fsnotify_put_mark+0x40/0x40
> kernel:  [<ffffffff81087762>] kthread+0xd2/0xf0
> kernel:  [<ffffffff81087690>] ? kthread_create_on_node+0x180/0x180
> kernel:  [<ffffffff814e663c>] ret_from_fork+0x7c/0xb0
> kernel:  [<ffffffff81087690>] ? kthread_create_on_node+0x180/0x180
> 
> kernel: INFO: task jhost:411 blocked for more than 120 seconds.
> kernel:       Not tainted 3.14.1-1-js #1
> kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
> this message.
> kernel: jhost           D 0000000000000000     0   411    399 0x00000000
> kernel:  ffff8803985b1e90 0000000000000282 ffff8800ff93b110 ffff8803985b1fd8
> kernel:  00000000000142c0 00000000000142c0 ffff8800ff93b110 ffffffff81283ae0
> kernel:  ffff8802bf663300 ffff8802bf663300 ffff8803985b1e00 ffffffff8108a245
> kernel: Call Trace:
> kernel:  [<ffffffff81283ae0>] ? timerqueue_add+0x60/0xb0
> kernel:  [<ffffffff8108a245>] ? enqueue_hrtimer+0x25/0xb0
> kernel:  [<ffffffff814de216>] ? _raw_spin_unlock_irqrestore+0x16/0x30
> kernel:  [<ffffffff8108ac34>] ? __hrtimer_start_range_ns+0x1e4/0x3d0
> kernel:  [<ffffffff814db4d9>] schedule+0x29/0x70
> kernel:  [<ffffffff814db8e6>] schedule_preempt_disabled+0x16/0x20
> kernel:  [<ffffffff814dcf24>] __mutex_lock_slowpath+0x124/0x1f0
> kernel:  [<ffffffff814dd007>] mutex_lock+0x17/0x27
> kernel:  [<ffffffff811c2d71>] __fdget_pos+0x41/0x50
> kernel:  [<ffffffff811a789f>] SyS_writev+0x1f/0xe0
> kernel:  [<ffffffff814e66e9>] system_call_fastpath+0x16/0x1b
> 
> kernel: INFO: task jhost:412 blocked for more than 120 seconds.
> kernel:       Not tainted 3.14.1-1-js #1
> kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
> this message.
> kernel: jhost           D 0000000000000000     0   412    399 0x00000000
> kernel:  ffff8803985b3c00 0000000000000282 ffff88039d114e80 ffff8803985b3fd8
> kernel:  00000000000142c0 00000000000142c0 ffff88039d114e80 ffffffff814de216
> kernel:  ffff8803985b3b70 ffffffff810aa4d4 ffffffff81b07770 ffffffff810c9996
> kernel: Call Trace:
> kernel:  [<ffffffff814de216>] ? _raw_spin_unlock_irqrestore+0x16/0x30
> kernel:  [<ffffffff810aa4d4>] ? __wake_up+0x44/0x50
> kernel:  [<ffffffff810c9996>] ? __call_rcu.constprop.61+0x116/0x270
> kernel:  [<ffffffff811ec270>] ? ep_send_events_proc+0x1c0/0x1c0
> kernel:  [<ffffffff814e7f4e>] ? xen_hypervisor_callback+0x1e/0x30
> kernel:  [<ffffffff814def9a>] ? error_exit+0x2a/0x60
> kernel:  [<ffffffff814dea3f>] ? retint_restore_args+0x5/0x6
> kernel:  [<ffffffff811e948f>] ? inotify_handle_event+0x6f/0x180
> kernel:  [<ffffffff810ca8e2>] ? rcu_read_unlock_special+0x182/0x200
> kernel:  [<ffffffff814db4d9>] schedule+0x29/0x70
> kernel:  [<ffffffff814db8e6>] schedule_preempt_disabled+0x16/0x20
> kernel:  [<ffffffff814dcf24>] __mutex_lock_slowpath+0x124/0x1f0
> kernel:  [<ffffffff814dd007>] mutex_lock+0x17/0x27
> kernel:  [<ffffffff811e7ff2>] fsnotify_destroy_mark_locked+0x102/0x180
> kernel:  [<ffffffff811e809b>] fsnotify_destroy_mark+0x2b/0x40
> kernel:  [<ffffffff811e954c>] inotify_handle_event+0x12c/0x180
> kernel:  [<ffffffff811e6c71>] send_to_group+0xd1/0x1b0
> kernel:  [<ffffffff811e6ffc>] fsnotify+0x2ac/0x2f0
> kernel:  [<ffffffff811a7669>] do_readv_writev+0x199/0x220
> kernel:  [<ffffffff81136a50>] ? __generic_file_aio_write+0x3b0/0x3b0
> kernel:  [<ffffffff811a60b0>] ? do_sync_read+0x90/0x90
> kernel:  [<ffffffff811f36d7>] ? locks_insert_lock+0x87/0x90
> kernel:  [<ffffffff811f5583>] ? flock_lock_file_wait+0x2d3/0x310
> kernel:  [<ffffffff811c239e>] ? __fget+0x6e/0xb0
> kernel:  [<ffffffff811a7770>] vfs_writev+0x30/0x60
> kernel:  [<ffffffff811a78ca>] SyS_writev+0x4a/0xe0
> kernel:  [<ffffffff814e66e9>] system_call_fastpath+0x16/0x1b
> 
> kernel: INFO: task jhost:413 blocked for more than 120 seconds.
> kernel:       Not tainted 3.14.1-1-js #1
> kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
> this message.
> kernel: jhost           D ffff88039ebeb480     0   413    399 0x00000000
> kernel:  ffff88039d11de90 0000000000000282 ffff88039d112740 ffff88039d11dfd8
> kernel:  00000000000142c0 00000000000142c0 ffff88039d112740 00007ff9567ecd88
> kernel:  ffff88039d11df50 0000000000000070 00007ff9567ecd88 ffff88039d11de70
> kernel: Call Trace:
> kernel:  [<ffffffff813d10c0>] ? sock_aio_read.part.27+0xc0/0xd0
> kernel:  [<ffffffff814db4d9>] schedule+0x29/0x70
> kernel:  [<ffffffff814db8e6>] schedule_preempt_disabled+0x16/0x20
> kernel:  [<ffffffff814dcf24>] __mutex_lock_slowpath+0x124/0x1f0
> kernel:  [<ffffffff814dd007>] mutex_lock+0x17/0x27
> kernel:  [<ffffffff811c2d71>] __fdget_pos+0x41/0x50
> kernel:  [<ffffffff811a789f>] SyS_writev+0x1f/0xe0
> kernel:  [<ffffffff814e66e9>] system_call_fastpath+0x16/0x1b
> 
> kernel: INFO: task jhost:414 blocked for more than 120 seconds.
> kernel:       Not tainted 3.14.1-1-js #1
> kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
> this message.
> kernel: jhost           D 0000000000000000     0   414    399 0x00000000
> kernel:  ffff88039d11fe90 0000000000000282 ffff88039d1175c0 ffff88039d11ffd8
> kernel:  00000000000142c0 00000000000142c0 ffff88039d1175c0 00000000007ec4b8
> kernel:  0000000000000000 ffff88039d11fe30 ffffffff810d74c1 ffff88039d11fe70
> kernel: Call Trace:
> kernel:  [<ffffffff810d74c1>] ? futex_wake+0x71/0x140
> kernel:  [<ffffffff813d10c0>] ? sock_aio_read.part.27+0xc0/0xd0
> kernel:  [<ffffffff810d9139>] ? do_futex+0x109/0xac0
> kernel:  [<ffffffff814db4d9>] schedule+0x29/0x70
> kernel:  [<ffffffff814db8e6>] schedule_preempt_disabled+0x16/0x20
> kernel:  [<ffffffff814dcf24>] __mutex_lock_slowpath+0x124/0x1f0
> kernel:  [<ffffffff814dd007>] mutex_lock+0x17/0x27
> kernel:  [<ffffffff811c2d71>] __fdget_pos+0x41/0x50
> kernel:  [<ffffffff811a789f>] SyS_writev+0x1f/0xe0
> kernel:  [<ffffffff814e66e9>] system_call_fastpath+0x16/0x1b
> 
> All messages above happened at the exact same point in time so it's
> unknown if they are sequentially ordered in some way.
> 
> uname: Linux localhost 3.14.1-1-js #1 SMP PREEMPT Tue Apr 15 17:59:05
> CEST 2014 x86_64 GNU/Linux
> 
> config: http://pastebin.com/Z0T6eKmy
> 
> We are using a "stock" Arch kernel without any custom patches.
> 
> Any ideas? Is it an inotify issue or possibly a xen issue?
> 
> Thank you for your time,
> Hannes
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
