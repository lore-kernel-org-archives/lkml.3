Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550Ab3JCATA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 20:19:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5438 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752928Ab3JCAS6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 20:18:58 -0400
Date: Wed, 2 Oct 2013 20:15:20 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Akira Hayakawa <ruby.wktk@gmail.com>
cc: Joe Thornber <thornber@redhat.com>, Dave Chinner <david@fromorbit.com>,
        devel@driverdev.osuosl.org, snitzer@redhat.com,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, agk@redhat.com, joe@perches.com,
        akpm@linux-foundation.org, dan.carpenter@oracle.com, ejt@redhat.com,
        cesarb@cesarb.net, m.chehab@samsung.com
Subject: dm-writeboost testing
Message-ID: <alpine.LRH.2.02.1310021125150.19199@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I tested dm-writeboost and I found these problems:


Performance problems:

I tested dm-writeboost with disk as backing device and ramdisk as cache 
device. When I run mkfs.ext4 on the dm-writeboost device, it writes data 
to the cache on the first time. However, on next mkfs.ext4 invocations, 
dm-writeboost writes data to the disk, not to the cache.

mkfs.ext4 on raw disk:	1.5s
mkfs.ext4 on dm-cache using raw disk and ramdisk:
1st time - 0.15s
next time - 0.12s
mkfs.ext4 on dm-writeboost using raw disk and ramdisk:
1st time - 0.11s
next time - 1.71s, 1.31s, 0.91s, 0.86s, 0.82s

- there seems to be some error in logic in dm-writeboost that makes it not 
cache writes if these writes are already placed in the cache. In 
real-world scenarios where the same piece of disk is overwritten over and 
over again (for example journal), this could cause performance problems.

dm-cache doesn't have this problem, if you overwrite the same piece of 
data again and again, it goes to the cache device.


Reliability problems (these problems are reproducible, they happen every 
time). Tests were done on 3.10.13 on Opteron and 3.11.3 on PA-RISC.

On 3.10.13 on Opteron on preemptible kernel, I get "BUG: workqueue leaked 
lock or atomic" when unloading the device with dmsetup remove. Also, on 
this machine, I see a bug, if I load dm-writeboost and terminate X server 
- Xorg hangs flusing workqueue.

On 3.11.3 on PA-RISC without preemption, the device unloads (although it 
takes many seconds and vmstat shows that the machine is idle during this 
time), but I get deadlock when I load the device the second time. The 
deadlock happens either on load on when writing to the newly loaded 
device.

----

deadlock when the device is loaded the second time:
[ 8336.212499] SysRq : Show Blocked State
[ 8336.212499]   task                        PC stack   pid father
[ 8336.212499] dmsetup         D 00000000401040c0     0  1594   1572 
0x00000010 [ 8336.212499] Backtrace:
[ 8336.212499]  [<0000000040111608>] __schedule+0x280/0x678
[ 8336.212499]  [<0000000040111e88>] schedule+0x38/0x90
[ 8336.212499]  [<000000004010ed1c>] schedule_timeout+0x1b4/0x208
[ 8336.212499]  [<0000000040111c1c>] wait_for_common+0x124/0x1e8
[ 8336.212499]  [<0000000040111d04>] wait_for_completion+0x24/0x38
[ 8336.212499]  [<00000000107d9778>] wait_for_migration+0x38/0xb0 
[dm_writeboost]
[ 8336.212499]  [<00000000107d7cf8>] resume_cache+0x1100/0x16f8 
[dm_writeboost] 

Another deadlock when loaded the second time and running mkfs.ex3 on the 
writeboost device (it got cut off in the scrollback buffer):
[  782.579921]  [<0000000040112280>] schedule_preempt_disabled+0x20/0x38
[  782.579921]  [<0000000040110764>] __mutex_lock_slowpath+0x15c/0x290
[  782.579921]  [<0000000040110928>] mutex_lock+0x90/0x98
[  782.579921]  [<00000000107f8b74>] flush_current_buffer+0x2c/0xb0 
[dm_writeboost]
[  782.579921]  [<00000000107fecbc>] sync_proc+0x7c/0xc8 [dm_writeboost]
[  782.579921]  [<00000000401591d0>] process_one_work+0x160/0x460
[  782.579921]  [<0000000040159bb8>] worker_thread+0x300/0x478
[  782.579921]  [<0000000040161a68>] kthread+0x118/0x128
[  782.579921]  [<0000000040104020>] end_fault_vector+0x20/0x28
[  782.579921] timer_interrupt(CPU 0): delayed! cycles A099A8C1 rem 22345C  
next/now CDFE401953/CDFE1DE4F7
[  785.403254]
[  785.403254] mkfs.ext3       D 00000000401040c0     0  2309   2237 
0x00000010 [  785.403254] Backtrace:
[  785.403254]  [<0000000040111608>] __schedule+0x280/0x678
[  785.403254]  [<0000000040111e88>] schedule+0x38/0x90
[  785.403254]  [<000000004010ed1c>] schedule_timeout+0x1b4/0x208
[  785.403254]  [<0000000040111c1c>] wait_for_common+0x124/0x1e8
[  785.403254]  [<0000000040111d04>] wait_for_completion+0x24/0x38
[  785.403254]  [<00000000107fe778>] wait_for_migration+0x38/0xb0 
[dm_writeboost]
[  785.403254]  [<00000000107f7fe8>] queue_current_buffer+0x78/0x3c8 
[dm_writeboost]
[  785.403254]  [<00000000107f96b8>] writeboost_map+0x660/0x970 
[dm_writeboost] [  785.403254]  [<000000001079477c>] __map_bio+0x9c/0x148 
[dm_mod]
[  785.403254]  [<0000000010794cf0>] __clone_and_map_data_bio+0x188/0x288 
[dm_mod]
[  785.403254]  [<0000000010795594>] __split_and_process_bio+0x474/0x6c8 
[dm_mod]
[  785.403254]  [<0000000010796180>] dm_request+0x118/0x278 [dm_mod]
[  785.403254]  [<00000000402d8360>] generic_make_request+0x128/0x1a0
[  785.403254]  [<00000000402d8448>] submit_bio+0x70/0x140
[  785.403254]  [<0000000040231c68>] _submit_bh+0x200/0x3b8
[  785.403254]  [<0000000040231e34>] submit_bh+0x14/0x20

A leaked prermpt count on unload (with preemptible kernel):
BUG: workqueue leaked lock or atomic: kworker/u26:1/0x00000001/1031
     last function: flush_proc [dm_writeboost]
CPU: 10 PID: 1031 Comm: kworker/u26:1 Tainted: P           O 3.10.13 #9
Hardware name: empty empty/S3992-E, BIOS 'V1.06   ' 06/09/2009
Workqueue: flushwq flush_proc [dm_writeboost]
 ffffffff8134e746 ffffffff81052c1d 000000003e5428c0 ffff88023f578c00
 ffff88023f578c18 ffff880446870a70 ffff88043ee8b5e0 ffff88043ee8b5e0
 ffff880446870a40 ffffffff8105368b ffff88043ee8b5e0 ffff88043ee8b5e0
Call Trace:
 [<ffffffff8134e746>] ? dump_stack+0xc/0x15
 [<ffffffff81052c1d>] ? process_one_work+0x33d/0x470
 [<ffffffff8105368b>] ? worker_thread+0x10b/0x390
 [<ffffffff81053580>] ? manage_workers.isra.26+0x290/0x290
 [<ffffffff81058d4f>] ? kthread+0xaf/0xc0
 [<ffffffff81058ca0>] ? kthread_create_on_node+0x120/0x120
 [<ffffffff8135356c>] ? ret_from_fork+0x7c/0xb0
 [<ffffffff81058ca0>] ? kthread_create_on_node+0x120/0x120
BUG: scheduling while atomic: kworker/u26:1/1031/0x00000002
Modules linked in: brd dm_mirror dm_region_hash dm_log dm_loop 
dm_writeboost(O)r unix
CPU: 10 PID: 1031 Comm: kworker/u26:1 Tainted: P           O 3.10.13 #9
Hardware name: empty empty/S3992-E, BIOS 'V1.06   ' 06/09/2009
 ffffffff8134e746 ffffffff8134c9ef ffffffff8135186b 0000000000012700
 ffff88043ef05fd8 ffff88043ef05fd8 0000000000012700 ffff88023f578c00
 ffff88023f578c18 ffff880446870a70 ffff88043ee8b5e0 ffff88043ee8b5e0
Call Trace:
 [<ffffffff8134e746>] ? dump_stack+0xc/0x15
 [<ffffffff8134c9ef>] ? __schedule_bug+0x3f/0x4c
 [<ffffffff8135186b>] ? __schedule+0x70b/0x720
 [<ffffffff81053730>] ? worker_thread+0x1b0/0x390
 [<ffffffff81053580>] ? manage_workers.isra.26+0x290/0x290
 [<ffffffff81058d4f>] ? kthread+0xaf/0xc0
 [<ffffffff81058ca0>] ? kthread_create_on_node+0x120/0x120
 [<ffffffff8135356c>] ? ret_from_fork+0x7c/0xb0
 [<ffffffff81058ca0>] ? kthread_create_on_node+0x120/0x120

When I load dm-writeboost and terminate X-window, the Xorg process hangs 
in this state (it is reproducible - happens each time) - it seems that 
dm-writeboost corrupts something connected with workqueues in the kernel:
SysRq : Show Blocked State
  task                        PC stack   pid father
Xorg            D 0000000000000001     0  4023      1 0x00400004
 ffff88043e3124c0 0000000000000086 0000000000012700 ffff8804468bbfd8
 ffff8804468bbfd8 0000000000012700 7fffffffffffffff ffff8804468bbcb8
 ffff8804468bbd58 ffff88043e3124c0 0000000000000001 ffff8804468bbd40
Call Trace:
 [<ffffffff8134f519>] ? schedule_timeout+0x1d9/0x2b0
 [<ffffffffa0b1d233>] ? _nv015437rm+0x3f/0x78 [nvidia]
 [<ffffffff81350735>] ? wait_for_completion+0x95/0x100
 [<ffffffff81066970>] ? wake_up_state+0x10/0x10
 [<ffffffff810501d5>] ? flush_workqueue+0x115/0x5a0
 [<ffffffffa0ffc474>] ? os_flush_work_queue+0x44/0x50 [nvidia]
 [<ffffffffa0fd54cf>] ? rm_disable_adapter+0x81/0x107 [nvidia]
 [<ffffffffa0ff4927>] ? nv_kern_close+0x137/0x420 [nvidia]
 [<ffffffff81119249>] ? __fput+0xd9/0x230
 [<ffffffff81055df7>] ? task_work_run+0x87/0xc0
 [<ffffffff810023e1>] ? do_notify_resume+0x61/0x90
 [<ffffffff811197e1>] ? fput+0x71/0xe0
 [<ffffffff81353820>] ? int_signal+0x12/0x17

Mikulas
