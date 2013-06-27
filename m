Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963Ab3F0PWQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 11:22:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13556 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753902Ab3F0PWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 11:22:11 -0400
Date: Thu, 27 Jun 2013 11:21:51 -0400
From: Dave Jones <davej@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrey Vagin <avagin@openvz.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: frequent softlockups with 3.10rc6.
Message-ID: <20130627152151.GA11551@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Dave Chinner <david@fromorbit.com>, Oleg Nesterov <oleg@redhat.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andrey Vagin <avagin@openvz.org>,
	Steven Rostedt <rostedt@goodmis.org>
References: <20130623150603.GA32313@redhat.com>
 <20130623160452.GA11740@redhat.com>
 <20130624155758.GA5993@redhat.com>
 <20130624173510.GA1321@redhat.com>
 <20130625153520.GA7784@redhat.com>
 <20130626191853.GA29049@redhat.com>
 <20130627002255.GA16553@redhat.com>
 <20130627075543.GA32195@dastard>
 <20130627100612.GA29338@dastard>
 <20130627125218.GB32195@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130627125218.GB32195@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 10:52:18PM +1000, Dave Chinner wrote:
 
 
 > > Yup, that's about three of orders of magnitude faster on this
 > > workload....
 > > 
 > > Lightly smoke tested patch below - it passed the first round of
 > > XFS data integrity tests in xfstests, so it's not completely
 > > busted...
 > 
 > And now with even less smoke out that the first version. This one
 > gets though a full xfstests run...

:sadface:

[  567.680836] ======================================================
[  567.681582] [ INFO: SOFTIRQ-safe -> SOFTIRQ-unsafe lock order detected ]
[  567.682389] 3.10.0-rc7+ #9 Not tainted
[  567.682862] ------------------------------------------------------
[  567.683607] trinity-child2/8665 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
[  567.684464]  (&sb->s_type->i_lock_key#3){+.+...}, at: [<ffffffff811d74e5>] sync_inodes_sb+0x225/0x3b0
[  567.685632] 
and this task is already holding:
[  567.686334]  (&(&wb->wb_list_lock)->rlock){..-...}, at: [<ffffffff811d7451>] sync_inodes_sb+0x191/0x3b0
[  567.687506] which would create a new lock dependency:
[  567.688115]  (&(&wb->wb_list_lock)->rlock){..-...} -> (&sb->s_type->i_lock_key#3){+.+...}
[  567.689188] 
but this new dependency connects a SOFTIRQ-irq-safe lock:
[  567.690137]  (&(&wb->wb_list_lock)->rlock){..-...}
... which became SOFTIRQ-irq-safe at:
[  567.691151]   [<ffffffff810b7f05>] __lock_acquire+0x595/0x1af0
[  567.691866]   [<ffffffff810b9c11>] lock_acquire+0x91/0x1f0
[  567.692539]   [<ffffffff816e7660>] _raw_spin_lock+0x40/0x80
[  567.693798]   [<ffffffff81153fce>] test_clear_page_writeback+0x11e/0x230
[  567.695193]   [<ffffffff81146b30>] end_page_writeback+0x20/0x50
[  567.696497]   [<ffffffff811e10c3>] end_buffer_async_write+0x1a3/0x2b0
[  567.697865]   [<ffffffff811df04c>] end_bio_bh_io_sync+0x2c/0x60
[  567.699164]   [<ffffffff811e3a8d>] bio_endio+0x1d/0x30
[  567.700361]   [<ffffffff812d6172>] blk_update_request+0xc2/0x5f0
[  567.701675]   [<ffffffff812d66bc>] blk_update_bidi_request+0x1c/0x80
[  567.703009]   [<ffffffff812d673f>] blk_end_bidi_request+0x1f/0x60
[  567.704294]   [<ffffffff812d6790>] blk_end_request+0x10/0x20
[  567.705524]   [<ffffffff814978c3>] scsi_io_completion+0xf3/0x6e0
[  567.706791]   [<ffffffff8148d8f0>] scsi_finish_command+0xb0/0x110
[  567.708071]   [<ffffffff814976cf>] scsi_softirq_done+0x12f/0x160
[  567.709339]   [<ffffffff812de0b8>] blk_done_softirq+0x88/0xa0
[  567.710574]   [<ffffffff8105413f>] __do_softirq+0xff/0x440
[  567.711799]   [<ffffffff8105463d>] irq_exit+0xcd/0xe0
[  567.712965]   [<ffffffff816f1fb6>] do_IRQ+0x56/0xc0
[  567.714108]   [<ffffffff816e866f>] ret_from_intr+0x0/0x13
[  567.715305]   [<ffffffff813062f9>] __const_udelay+0x29/0x30
[  567.716514]   [<ffffffff81075fd4>] __rcu_read_unlock+0x54/0xa0
[  567.717753]   [<ffffffff811c35dd>] __d_lookup+0x14d/0x320
[  567.718939]   [<ffffffff811b598a>] lookup_fast+0x16a/0x2d0
[  567.720129]   [<ffffffff811b669b>] link_path_walk+0x1ab/0x900
[  567.721350]   [<ffffffff811b9ed4>] path_openat+0x94/0x530
[  567.722524]   [<ffffffff811ba9f8>] do_filp_open+0x38/0x80
[  567.723701]   [<ffffffff811a8e39>] do_sys_open+0xe9/0x1c0
[  567.724875]   [<ffffffff811a8f2e>] SyS_open+0x1e/0x20
[  567.726007]   [<ffffffff816f0794>] tracesys+0xdd/0xe2
[  567.727138] 
to a SOFTIRQ-irq-unsafe lock:
[  567.728823]  (&sb->s_type->i_lock_key#3){+.+...}
... which became SOFTIRQ-irq-unsafe at:
[  567.730875] ...  [<ffffffff810b7f59>] __lock_acquire+0x5e9/0x1af0
[  567.732150]   [<ffffffff810b9c11>] lock_acquire+0x91/0x1f0
[  567.733339]   [<ffffffff816e7660>] _raw_spin_lock+0x40/0x80
[  567.734533]   [<ffffffff811c6b88>] new_inode_pseudo+0x28/0x60
[  567.735736]   [<ffffffff811c6bd9>] new_inode+0x19/0x30
[  567.736853]   [<ffffffff811d27c1>] mount_pseudo+0xb1/0x180
[  567.738008]   [<ffffffff811e6a04>] bd_mount+0x24/0x30
[  567.739090]   [<ffffffff811ae089>] mount_fs+0x39/0x1b0
[  567.740172]   [<ffffffff811cb623>] vfs_kern_mount+0x63/0xf0
[  567.741314]   [<ffffffff811cb6c9>] kern_mount_data+0x19/0x30
[  567.742450]   [<ffffffff81effaab>] bdev_cache_init+0x56/0x80
[  567.743571]   [<ffffffff81efe1cf>] vfs_caches_init+0x9e/0x115
[  567.744691]   [<ffffffff81ed8dd0>] start_kernel+0x3a2/0x3fe
[  567.745790]   [<ffffffff81ed856f>] x86_64_start_reservations+0x2a/0x2c
[  567.747011]   [<ffffffff81ed863d>] x86_64_start_kernel+0xcc/0xcf
[  567.748167] 
other info that might help us debug this:

[  567.750396]  Possible interrupt unsafe locking scenario:

[  567.752062]        CPU0                    CPU1
[  567.753025]        ----                    ----
[  567.753981]   lock(&sb->s_type->i_lock_key#3);
[  567.754969]                                local_irq_disable();
[  567.756085]                                lock(&(&wb->wb_list_lock)->rlock);
[  567.757368]                                lock(&sb->s_type->i_lock_key#3);
[  567.758642]   <Interrupt>
[  567.759370]     lock(&(&wb->wb_list_lock)->rlock);
[  567.760379] 
 *** DEADLOCK ***

[  567.762337] 2 locks held by trinity-child2/8665:
[  567.763297]  #0:  (&type->s_umount_key#23){++++..}, at: [<ffffffff811ada2c>] iterate_supers+0x9c/0x110
[  567.764898]  #1:  (&(&wb->wb_list_lock)->rlock){..-...}, at: [<ffffffff811d7451>] sync_inodes_sb+0x191/0x3b0
[  567.766558] 
the dependencies between SOFTIRQ-irq-safe lock and the holding lock:
[  567.768362] -> (&(&wb->wb_list_lock)->rlock){..-...} ops: 395 {
[  567.769581]    IN-SOFTIRQ-W at:
[  567.770428]                     [<ffffffff810b7f05>] __lock_acquire+0x595/0x1af0
[  567.771803]                     [<ffffffff810b9c11>] lock_acquire+0x91/0x1f0
[  567.773128]                     [<ffffffff816e7660>] _raw_spin_lock+0x40/0x80
[  567.774457]                     [<ffffffff81153fce>] test_clear_page_writeback+0x11e/0x230
[  567.775923]                     [<ffffffff81146b30>] end_page_writeback+0x20/0x50
[  567.777303]                     [<ffffffff811e10c3>] end_buffer_async_write+0x1a3/0x2b0
[  567.778745]                     [<ffffffff811df04c>] end_bio_bh_io_sync+0x2c/0x60
[  567.780125]                     [<ffffffff811e3a8d>] bio_endio+0x1d/0x30
[  567.781428]                     [<ffffffff812d6172>] blk_update_request+0xc2/0x5f0
[  567.782820]                     [<ffffffff812d66bc>] blk_update_bidi_request+0x1c/0x80
[  567.784245]                     [<ffffffff812d673f>] blk_end_bidi_request+0x1f/0x60
[  567.785634]                     [<ffffffff812d6790>] blk_end_request+0x10/0x20
[  567.786971]                     [<ffffffff814978c3>] scsi_io_completion+0xf3/0x6e0
[  567.788349]                     [<ffffffff8148d8f0>] scsi_finish_command+0xb0/0x110
[  567.789740]                     [<ffffffff814976cf>] scsi_softirq_done+0x12f/0x160
[  567.791140]                     [<ffffffff812de0b8>] blk_done_softirq+0x88/0xa0
[  567.792502]                     [<ffffffff8105413f>] __do_softirq+0xff/0x440
[  567.793845]                     [<ffffffff8105463d>] irq_exit+0xcd/0xe0
[  567.795127]                     [<ffffffff816f1fb6>] do_IRQ+0x56/0xc0
[  567.796375]                     [<ffffffff816e866f>] ret_from_intr+0x0/0x13
[  567.797685]                     [<ffffffff813062f9>] __const_udelay+0x29/0x30
[  567.799016]                     [<ffffffff81075fd4>] __rcu_read_unlock+0x54/0xa0
[  567.800381]                     [<ffffffff811c35dd>] __d_lookup+0x14d/0x320
[  567.801692]                     [<ffffffff811b598a>] lookup_fast+0x16a/0x2d0
[  567.803013]                     [<ffffffff811b669b>] link_path_walk+0x1ab/0x900
[  567.804361]                     [<ffffffff811b9ed4>] path_openat+0x94/0x530
[  567.805668]                     [<ffffffff811ba9f8>] do_filp_open+0x38/0x80
[  567.806974]                     [<ffffffff811a8e39>] do_sys_open+0xe9/0x1c0
[  567.808275]                     [<ffffffff811a8f2e>] SyS_open+0x1e/0x20
[  567.809534]                     [<ffffffff816f0794>] tracesys+0xdd/0xe2
[  567.810809]    INITIAL USE at:
[  567.811668]                    [<ffffffff810b7c55>] __lock_acquire+0x2e5/0x1af0
[  567.813038]                    [<ffffffff810b9c11>] lock_acquire+0x91/0x1f0
[  567.814364]                    [<ffffffff816e7660>] _raw_spin_lock+0x40/0x80
[  567.815688]                    [<ffffffff81151975>] test_set_page_writeback+0x155/0x200
[  567.817128]                    [<ffffffff811e18c0>] __block_write_full_page+0x140/0x3a0
[  567.818565]                    [<ffffffff811e1d29>] block_write_full_page_endio+0xf9/0x120
[  567.820035]                    [<ffffffff811e1d65>] block_write_full_page+0x15/0x20
[  567.821436]                    [<ffffffff811e6d58>] blkdev_writepage+0x18/0x20
[  567.822782]                    [<ffffffff811515b6>] __writepage+0x16/0x50
[  567.824081]                    [<ffffffff811520fb>] write_cache_pages+0x27b/0x630
[  567.825460]                    [<ffffffff811524f3>] generic_writepages+0x43/0x60
[  567.826819]                    [<ffffffff81153e51>] do_writepages+0x21/0x50
[  567.828128]                    [<ffffffff81148739>] __filemap_fdatawrite_range+0x59/0x60
[  567.829562]                    [<ffffffff8114883d>] filemap_write_and_wait_range+0x2d/0x70
[  567.831010]                    [<ffffffff811e69ab>] blkdev_fsync+0x1b/0x50
[  567.832292]                    [<ffffffff811dd346>] do_fsync+0x56/0x80
[  567.833514]                    [<ffffffff811dd600>] SyS_fsync+0x10/0x20
[  567.834741]                    [<ffffffff816f0794>] tracesys+0xdd/0xe2
[  567.835955]  }
[  567.836583]  ... key      at: [<ffffffff82a38c89>] __key.27437+0x0/0x8
[  567.837800]  ... acquired at:
[  567.838584]    [<ffffffff810b6f3a>] check_irq_usage+0x4a/0xc0
[  567.839712]    [<ffffffff810b8783>] __lock_acquire+0xe13/0x1af0
[  567.840877]    [<ffffffff810b9c11>] lock_acquire+0x91/0x1f0
[  567.841991]    [<ffffffff816e7660>] _raw_spin_lock+0x40/0x80
[  567.843107]    [<ffffffff811d74e5>] sync_inodes_sb+0x225/0x3b0
[  567.844245]    [<ffffffff811dd209>] sync_inodes_one_sb+0x19/0x20
[  567.845399]    [<ffffffff811ada42>] iterate_supers+0xb2/0x110
[  567.846526]    [<ffffffff811dd475>] sys_sync+0x35/0x90
[  567.847580]    [<ffffffff816f0794>] tracesys+0xdd/0xe2

[  567.849239] 
the dependencies between the lock to be acquired and SOFTIRQ-irq-unsafe lock:
[  567.851102] -> (&sb->s_type->i_lock_key#3){+.+...} ops: 1230 {
[  567.852314]    HARDIRQ-ON-W at:
[  567.853160]                     [<ffffffff810b7f2c>] __lock_acquire+0x5bc/0x1af0
[  567.854498]                     [<ffffffff810b9c11>] lock_acquire+0x91/0x1f0
[  567.855796]                     [<ffffffff816e7660>] _raw_spin_lock+0x40/0x80
[  567.857105]                     [<ffffffff811c6b88>] new_inode_pseudo+0x28/0x60
[  567.858437]                     [<ffffffff811c6bd9>] new_inode+0x19/0x30
[  567.859693]                     [<ffffffff811d27c1>] mount_pseudo+0xb1/0x180
[  567.861008]                     [<ffffffff811e6a04>] bd_mount+0x24/0x30
[  567.862264]                     [<ffffffff811ae089>] mount_fs+0x39/0x1b0
[  567.863529]                     [<ffffffff811cb623>] vfs_kern_mount+0x63/0xf0
[  567.864846]                     [<ffffffff811cb6c9>] kern_mount_data+0x19/0x30
[  567.866174]                     [<ffffffff81effaab>] bdev_cache_init+0x56/0x80
[  567.867502]                     [<ffffffff81efe1cf>] vfs_caches_init+0x9e/0x115
[  567.868830]                     [<ffffffff81ed8dd0>] start_kernel+0x3a2/0x3fe
[  567.870125]                     [<ffffffff81ed856f>] x86_64_start_reservations+0x2a/0x2c
[  567.871554]                     [<ffffffff81ed863d>] x86_64_start_kernel+0xcc/0xcf
[  567.872906]    SOFTIRQ-ON-W at:
[  567.873731]                     [<ffffffff810b7f59>] __lock_acquire+0x5e9/0x1af0
[  567.875068]                     [<ffffffff810b9c11>] lock_acquire+0x91/0x1f0
[  567.876362]                     [<ffffffff816e7660>] _raw_spin_lock+0x40/0x80
[  567.877669]                     [<ffffffff811c6b88>] new_inode_pseudo+0x28/0x60
[  567.878996]                     [<ffffffff811c6bd9>] new_inode+0x19/0x30
[  567.880251]                     [<ffffffff811d27c1>] mount_pseudo+0xb1/0x180
[  567.881560]                     [<ffffffff811e6a04>] bd_mount+0x24/0x30
[  567.882802]                     [<ffffffff811ae089>] mount_fs+0x39/0x1b0
[  567.884053]                     [<ffffffff811cb623>] vfs_kern_mount+0x63/0xf0
[  567.885353]                     [<ffffffff811cb6c9>] kern_mount_data+0x19/0x30
[  567.886659]                     [<ffffffff81effaab>] bdev_cache_init+0x56/0x80
[  567.887964]                     [<ffffffff81efe1cf>] vfs_caches_init+0x9e/0x115
[  567.889276]                     [<ffffffff81ed8dd0>] start_kernel+0x3a2/0x3fe
[  567.890571]                     [<ffffffff81ed856f>] x86_64_start_reservations+0x2a/0x2c
[  567.891995]                     [<ffffffff81ed863d>] x86_64_start_kernel+0xcc/0xcf
[  567.893350]    INITIAL USE at:
[  567.894182]                    [<ffffffff810b7c55>] __lock_acquire+0x2e5/0x1af0
[  567.895503]                    [<ffffffff810b9c11>] lock_acquire+0x91/0x1f0
[  567.896782]                    [<ffffffff816e7660>] _raw_spin_lock+0x40/0x80
[  567.898068]                    [<ffffffff811c6b88>] new_inode_pseudo+0x28/0x60
[  567.899375]                    [<ffffffff811c6bd9>] new_inode+0x19/0x30
[  567.900622]                    [<ffffffff811d27c1>] mount_pseudo+0xb1/0x180
[  567.901906]                    [<ffffffff811e6a04>] bd_mount+0x24/0x30
[  567.903140]                    [<ffffffff811ae089>] mount_fs+0x39/0x1b0
[  567.904379]                    [<ffffffff811cb623>] vfs_kern_mount+0x63/0xf0
[  567.905663]                    [<ffffffff811cb6c9>] kern_mount_data+0x19/0x30
[  567.906957]                    [<ffffffff81effaab>] bdev_cache_init+0x56/0x80
[  567.908248]                    [<ffffffff81efe1cf>] vfs_caches_init+0x9e/0x115
[  567.909555]                    [<ffffffff81ed8dd0>] start_kernel+0x3a2/0x3fe
[  567.910850]                    [<ffffffff81ed856f>] x86_64_start_reservations+0x2a/0x2c
[  567.912247]                    [<ffffffff81ed863d>] x86_64_start_kernel+0xcc/0xcf
[  567.913576]  }
[  567.914201]  ... key      at: [<ffffffff81c6fd68>] bd_type+0x68/0x80
[  567.915389]  ... acquired at:
[  567.916163]    [<ffffffff810b6f3a>] check_irq_usage+0x4a/0xc0
[  567.917282]    [<ffffffff810b8783>] __lock_acquire+0xe13/0x1af0
[  567.918426]    [<ffffffff810b9c11>] lock_acquire+0x91/0x1f0
[  567.919527]    [<ffffffff816e7660>] _raw_spin_lock+0x40/0x80
[  567.920639]    [<ffffffff811d74e5>] sync_inodes_sb+0x225/0x3b0
[  567.921793]    [<ffffffff811dd209>] sync_inodes_one_sb+0x19/0x20
[  567.922959]    [<ffffffff811ada42>] iterate_supers+0xb2/0x110
[  567.924087]    [<ffffffff811dd475>] sys_sync+0x35/0x90
[  567.925140]    [<ffffffff816f0794>] tracesys+0xdd/0xe2

[  567.926805] 
stack backtrace:
[  567.928164] CPU: 2 PID: 8665 Comm: trinity-child2 Not tainted 3.10.0-rc7+ #9
[  567.931829]  ffffffff824d5e70 ffff88022fe7db30 ffffffff816df0ad ffff88022fe7dc30
[  567.933224]  ffffffff810b6ee5 0000000000000000 ffffffff00000000 0000000700000001
[  567.934620]  ffff88022fe7db80 ffff88022fe7dbc0 ffffffff81a129af ffff88022fe7db80
[  567.936023] Call Trace:
[  567.936804]  [<ffffffff816df0ad>] dump_stack+0x19/0x1b
[  567.937906]  [<ffffffff810b6ee5>] check_usage+0x4d5/0x4e0
[  567.939042]  [<ffffffff81091cff>] ? local_clock+0x3f/0x50
[  567.940176]  [<ffffffff810b6f3a>] check_irq_usage+0x4a/0xc0
[  567.941332]  [<ffffffff810b8783>] __lock_acquire+0xe13/0x1af0
[  567.942507]  [<ffffffff81091cff>] ? local_clock+0x3f/0x50
[  567.943643]  [<ffffffff816e4cdd>] ? wait_for_completion+0x4d/0x110
[  567.944875]  [<ffffffff810b741b>] ? mark_held_locks+0xbb/0x140
[  567.946065]  [<ffffffff816e7b0c>] ? _raw_spin_unlock_irq+0x2c/0x60
[  567.947296]  [<ffffffff810b9c11>] lock_acquire+0x91/0x1f0
[  567.948430]  [<ffffffff811d74e5>] ? sync_inodes_sb+0x225/0x3b0
[  567.949612]  [<ffffffff816e7660>] _raw_spin_lock+0x40/0x80
[  567.950752]  [<ffffffff811d74e5>] ? sync_inodes_sb+0x225/0x3b0
[  567.951932]  [<ffffffff811d74e5>] sync_inodes_sb+0x225/0x3b0
[  567.953091]  [<ffffffff816e4d6f>] ? wait_for_completion+0xdf/0x110
[  567.954320]  [<ffffffff811dd1f0>] ? generic_write_sync+0x70/0x70
[  567.955526]  [<ffffffff811dd209>] sync_inodes_one_sb+0x19/0x20
[  567.956714]  [<ffffffff811ada42>] iterate_supers+0xb2/0x110
[  567.957873]  [<ffffffff811dd475>] sys_sync+0x35/0x90
[  567.958960]  [<ffffffff816f0794>] tracesys+0xdd/0xe2

