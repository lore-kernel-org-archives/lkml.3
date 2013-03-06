Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981Ab3CFEvx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 23:51:53 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:49748 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353Ab3CFEvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 23:51:49 -0500
MIME-Version: 1.0
In-Reply-To: <20130303130207.GA28281@localhost>
References: <20130303130207.GA28281@localhost>
Date: Tue, 5 Mar 2013 20:51:47 -0800
X-Google-Sender-Auth: lwfazpK3givbARtIoIogkHnM_gY
Message-ID: <CACBanvrV+De0+78Dj3ckWVnaWEXEBzJG-Oy-E1HVY=6wmVWjiQ@mail.gmail.com>
Subject: Re: [lockdep] BUG: init/1242 still has locks held!
From: Mandeep Singh Baines <msb@chromium.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-pm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 3, 2013 at 5:02 AM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> Greetings,
>
> I got the below oops and the first bad commit is
>
> commit 6aa9707099c4b25700940eb3d016f16c4434360d
> Author: Mandeep Singh Baines <msb@chromium.org>
> Date:   Wed Feb 27 17:03:18 2013 -0800
>
>     lockdep: check that no locks held at freeze time
>
>     We shouldn't try_to_freeze if locks are held.  Holding a lock can cause a
>     deadlock if the lock is later acquired in the suspend or hibernate path
>     (e.g.  by dpm).  Holding a lock can also cause a deadlock in the case of
>     cgroup_freezer if a lock is held inside a frozen cgroup that is later
>     acquired by a process outside that group.
>
>     [akpm@linux-foundation.org: export debug_check_no_locks_held]
>     Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
>     Cc: Ben Chan <benchan@chromium.org>
>     Cc: Oleg Nesterov <oleg@redhat.com>
>     Cc: Tejun Heo <tj@kernel.org>
>     Cc: Rafael J. Wysocki <rjw@sisk.pl>
>     Cc: Ingo Molnar <mingo@redhat.com>
>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
>

Hi,

Thanks for the bug report.

This issue is being discussed here:

http://lkml.org/lkml/2013/3/4/221

Regards,
Mandeep

> [   71.089828]
> [   71.090356] =====================================
> [   71.091041] [ BUG: init/1242 still has locks held! ]
> [   71.091987] 3.8.0-10734-ga7c1120 #1 Not tainted
> [   71.093135] -------------------------------------
> [   71.093884] 1 lock held by init/1242:
> [   71.094437]  #0:  (&sig->cred_guard_mutex){+.+.+.}, at: [<ffffffff81123a13>] prepare_bprm_creds+0x2d/0x6b
> [   71.097355]
> [   71.097355] stack backtrace:
> [   71.098125] Pid: 1242, comm: init Not tainted 3.8.0-10734-ga7c1120 #1
> [   71.099011] Call Trace:
> [   71.099621]  [<ffffffff8108628d>] debug_check_no_locks_held+0x8f/0x93
> [   71.101004]  [<ffffffff818bbb1d>] rpc_wait_bit_killable+0x31/0x9f
> [   71.101882]  [<ffffffff81911a18>] __wait_on_bit+0x48/0x7f
> [   71.102635]  [<ffffffff81089b9b>] ? mark_held_locks+0xbe/0xea
> [   71.103441]  [<ffffffff81911ac1>] out_of_line_wait_on_bit+0x72/0x7d
> [   71.104755]  [<ffffffff818bbaec>] ? rpc_queue_empty+0x31/0x31
> [   71.105582]  [<ffffffff818bcc67>] ? __rpc_execute+0x118/0x2b5
> [   71.106397]  [<ffffffff810585cd>] ? autoremove_wake_function+0x3d/0x3d
> [   71.107286]  [<ffffffff818bcc8b>] __rpc_execute+0x13c/0x2b5
> [   71.108492]  [<ffffffff810581eb>] ? bit_waitqueue+0x1b/0x6e
> [   71.109331]  [<ffffffff81058296>] ? wake_up_bit+0x25/0x2a
> [   71.110116]  [<ffffffff818bceb8>] rpc_execute+0x6b/0x92
> [   71.110876]  [<ffffffff818b61eb>] rpc_run_task+0x78/0x80
> [   71.111627]  [<ffffffff818b6329>] rpc_call_sync+0x88/0x9e
> [   71.112873]  [<ffffffff8124ad18>] nfs3_rpc_wrapper.constprop.9+0x36/0xc1
> [   71.113814]  [<ffffffff8124b016>] nfs3_proc_access+0xb8/0x110
> [   71.114613]  [<ffffffff8123a94f>] nfs_do_access+0x14d/0x1f9
> [   71.115412]  [<ffffffff818be3d0>] ? generic_lookup_cred+0x15/0x17
> [   71.116702]  [<ffffffff8123aabc>] nfs_permission+0xc1/0x12f
> [   71.117505]  [<ffffffff81068b80>] ? local_clock+0x41/0x5a
> [   71.118304]  [<ffffffff81127221>] __inode_permission+0x37/0x71
> [   71.119125]  [<ffffffff811272a0>] inode_permission+0x45/0x47
> [   71.119976]  [<ffffffff81129713>] may_open+0x88/0xeb
> [   71.121096]  [<ffffffff81129f79>] do_last.isra.53+0x803/0x9d6
> [   71.121990]  [<ffffffff8112a458>] path_openat.isra.54+0x30c/0x3ce
> [   71.122834]  [<ffffffff81906809>] ? __slab_alloc.constprop.64+0x37c/0x3a9
> [   71.123807]  [<ffffffff81162b18>] ? bm_status_write+0xef/0xef
> [   71.127338]  [<ffffffff8112a826>] do_filp_open+0x38/0x86
> [   71.128655]  [<ffffffff81115e3d>] ? __kmalloc_track_caller+0xa8/0x184
> [   71.129620]  [<ffffffff8112252f>] ? bprm_change_interp+0x34/0x49
> [   71.130507]  [<ffffffff8112273d>] open_exec+0x3d/0xde
> [   71.131282]  [<ffffffff81162ca3>] load_script+0x18b/0x1c0
> [   71.132520]  [<ffffffff81085206>] ? lock_release_holdtime.part.6+0x91/0x96
> [   71.133554]  [<ffffffff8112227a>] ? search_binary_handler+0xf6/0x332
> [   71.134485]  [<ffffffff81915179>] ? _raw_read_unlock+0x28/0x3b
> [   71.135362]  [<ffffffff81122289>] search_binary_handler+0x105/0x332
> [   71.136718]  [<ffffffff811221ae>] ? search_binary_handler+0x2a/0x332
> [   71.137653]  [<ffffffff81123eee>] do_execve_common.isra.27+0x43c/0x56e
> [   71.138597]  [<ffffffff81123bb6>] ? do_execve_common.isra.27+0x104/0x56e
> [   71.139563]  [<ffffffff81124038>] do_execve+0x18/0x1a
> [   71.140782]  [<ffffffff81124281>] sys_execve+0x3b/0x50
> [   71.141574]  [<ffffffff8191d2c9>] stub_execve+0x69/0xa0
>
> git bisect start a7c1120d2dcc83691bafa034d98f70285757e826 3298a3511f1e73255a8dc023efd909e569eea037 --
> git bisect good 69086a78bdc973ec0b722be790b146e84ba8a8c4  #    30  2013-03-03 15:03:33  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs
> git bisect good d895cb1af15c04c522a25c79cc429076987c089b  #    30  2013-03-03 15:32:27  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs
> git bisect  bad 7307c00f335a4e986586b12334696098d2fc2bcd  #     0  2013-03-03 15:36:44  Merge tag 'late-omap' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc
> git bisect  bad ee89f81252179dcbf6cd65bd48299f5e52292d88  #     0  2013-03-03 15:40:06  Merge branch 'for-3.9/core' of git://git.kernel.dk/linux-block
> git bisect  bad b67bfe0d42cac56c512dd5da4b1b347a23f4b70a  #     0  2013-03-03 15:43:46  hlist: drop the node parameter from iterators
> git bisect  bad 3b069c5d857a5f1b8cb6bb74c70d9446089f5077  #     0  2013-03-03 15:47:16  IB/core: convert to idr_alloc()
> git bisect  bad fe88f2ee33731f0934e8fb26f762b6715e43ff6f  #     0  2013-03-03 15:50:03  kexec: prevent double free on image allocation failure
> git bisect good 3e05ca20fb570b456bd9841b5ff489d865e8c563  #    30  2013-03-03 16:03:02  hfsplus: add functionality of manipulating by records in attributes tree
> git bisect good e579d2c259be42b6f29458327e5153b22414b031  #    32  2013-03-03 16:17:47  coredump: remove redundant defines for dumpable states
> git bisect  bad 80de7f7ae013b1e287059f39eaba2a12219681cf  #     0  2013-03-03 16:22:14  seq-file: use SEEK_ macros instead of hardcoded numbers
> git bisect good c2c1b089b44b783bd50fae4bccaa6f367f92e492  #    30  2013-03-03 16:35:16  fs/proc/vmcore.c: put if tests in the top of the while loop to reduce duplication
> git bisect  bad 80d26af89a7249aa5475467000322163c60cdd72  #     0  2013-03-03 16:38:48  coredump: use a freezable_schedule for the coredump_finish wait
> git bisect  bad 6aa9707099c4b25700940eb3d016f16c4434360d  #     0  2013-03-03 16:40:38  lockdep: check that no locks held at freeze time
> git bisect good c2c1b089b44b783bd50fae4bccaa6f367f92e492  #    90  2013-03-03 17:12:12  fs/proc/vmcore.c: put if tests in the top of the while loop to reduce duplication
> git bisect  bad a7c1120d2dcc83691bafa034d98f70285757e826  #     0  2013-03-03 17:16:24  Merge tag 'ext4_for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4
> git bisect good 49f1881cedf9d871c4a55e670b9397dd4b84faef  #    90  2013-03-03 17:47:58  Revert "lockdep: check that no locks held at freeze time"
> git bisect  bad 106edea2fe051df65a1a6231e9ffa2876cc391cc  #     0  2013-03-03 17:53:48  Add linux-next specific files for 20130301
>
> Thanks,
> Fengguang
