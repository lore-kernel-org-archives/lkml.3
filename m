Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751574AbaLZH5W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 02:57:22 -0500
Received: from mga09.intel.com ([134.134.136.24]:17825 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751193AbaLZH5T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 02:57:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,646,1413270000"; 
   d="scan'208";a="643032698"
From: Leon Ma <xindong.ma@intel.com>
To: akpm@linux-foundation.org, oleg@redhat.com, mhocko@suse.cz,
        mingo@kernel.org, peterz@infradead.org, riel@redhat.com,
        ionut.m.alexa@gmail.com, peter@hurleysoftware.com,
        linux-kernel@vger.kernel.org, di.zhang@intel.com,
        zhonghua.sun@intel.com, xindong.ma@intel.com
Subject: [PATCH] move exit_task_work() before exit_fs().
Date: Fri, 26 Dec 2014 15:45:25 +0800
Message-Id: <1419579926-28512-1-git-send-email-xindong.ma@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <y>
References: <y>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We encountered following panic. The scenario is the process is exiting and executing its
task work. When closing dev node, the driver triggers a firmware reload according to device
status. Because task->fs is set to NULL in exit_fs(), panic happens.
Task work is a common interface, we should not limite the resource the user will utilize.

[  118.521972] task: ffff880038de5cd0 ti: ffff880038e86000 task.ti: ffff880038e86000
[  118.521977] RIP: 0010:[<ffffffff8217a0a6>]  [<ffffffff8217a0a6>] path_init+0x336/0x440
[  118.521986] RSP: 0000:ffff880038e876a0  EFLAGS: 00010246
[  118.521991] RAX: 0000000000000000 RBX: ffff880038e87790 RCX: 0000000000000071
[  118.521996] RDX: ffff88003f30f5d4 RSI: ffffffff82179f75 RDI: ffffffff8209b167
[  118.522000] RBP: ffff880038e876e0 R08: ffff880038e87730 R09: ffff8800218b44c0
[  118.522005] R10: 0000000000000000 R11: 000000000000000f R12: ffff880038ebf000
[  118.522010] R13: ffff880038e87870 R14: ffff880038e87850 R15: 00000000ffffff9c
[  118.522015] FS:  0000000000000000(0000) GS:ffff88003f300000(0000) knlGS:0000000000000000
[  118.522020] CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
[  118.522025] CR2: 0000000000000020 CR3: 0000000039d4f000 CR4: 00000000001007e0
[  118.522030] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  118.522035] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  118.522039] Stack:
[  118.522043]  ffff880038dbc300 ffff880038e876b8 ffffffff822cf046 ffff88002e434f00
[  118.522056]  ffff880038e87790 ffff880038e87870 ffff880038e87850 00000000ffffff9c
[  118.522069]  ffff880038e87780 ffffffff8217d419 ffff88003b1de480 ffff88003bbf7700
[  118.522082] Call Trace:
[  118.522092]  [<ffffffff822cf046>] ? security_file_alloc+0x16/0x20
[  118.522100]  [<ffffffff8217d419>] path_openat+0x69/0x4b0
[  118.522109]  [<ffffffff826b5c7f>] ? is_connected_output_ep+0x15f/0x260
[  118.522117]  [<ffffffff8217dae9>] do_filp_open+0x39/0x90
[  118.522125]  [<ffffffff823316ca>] ? string.isra.3+0x3a/0xe0
[  118.522133]  [<ffffffff82332809>] ? vsnprintf+0x209/0x620
[  118.522141]  [<ffffffff8216ced2>] file_open_name+0xb2/0xf0
[  118.522148]  [<ffffffff8216cf46>] filp_open+0x36/0x40
[  118.522157]  [<ffffffff82404441>] _request_firmware+0x351/0x9c0
[  118.522164]  [<ffffffff82404b26>] request_firmware+0x16/0x20
[  118.522172]  [<ffffffff826dd733>] sst_request_fw+0x63/0x510
[  118.522180]  [<ffffffff8283be10>] ? __mutex_lock_slowpath+0x280/0x3b0
[  118.522188]  [<ffffffff826df047>] sst_load_fw+0x1f7/0x4a0
[  118.522195]  [<ffffffff826da81f>] sst_download_fw+0xf/0x60
[  118.522202]  [<ffffffff826db022>] intel_sst_check_device+0x92/0x1f0
[  118.522209]  [<ffffffff826db4bd>] sst_set_generic_params+0x18d/0x500
[  118.522218]  [<ffffffff826cee25>] sst_fill_and_send_cmd.constprop.7+0x95/0x130
[  118.522226]  [<ffffffff826cf1dd>] sst_send_gain_cmd+0x9d/0xe0
[  118.522233]  [<ffffffff826cf283>] sst_set_pipe_gain+0x63/0xa0
[  118.522241]  [<ffffffff826d0665>] sst_send_pipe_gains+0xd5/0x2b0
[  118.522248]  [<ffffffff826cb5d6>] sst_media_digital_mute+0x46/0x80
[  118.522257]  [<ffffffff826ab5b1>] snd_soc_dai_digital_mute+0x21/0x60
[  118.522265]  [<ffffffff826bc39d>] soc_pcm_close+0xbd/0x250
[  118.522272]  [<ffffffff826bdf2a>] dpcm_fe_dai_close+0x7a/0x150
[  118.522281]  [<ffffffff8267f138>] snd_pcm_release_substream+0x58/0xb0
[  118.522289]  [<ffffffff8267f1cf>] snd_pcm_release+0x3f/0xa0//////////
[  118.522296]  [<ffffffff8216f600>] __fput+0xf0/0x240
[  118.522304]  [<ffffffff8216f75e>] ____fput+0xe/0x10
[  118.522312]  [<ffffffff82090195>] task_work_run+0xa5/0xd0
[  118.522320]  [<ffffffff82072a08>] do_exit+0x2b8/0xad0
[  118.522327]  [<ffffffff8283d3bf>] ? __schedule+0x3df/0x820
[  118.522335]  [<ffffffff820733af>] do_group_exit+0x3f/0xa0
[  118.522343]  [<ffffffff82082b6e>] get_signal_to_deliver+0x24e/0x650
[  118.522352]  [<ffffffff8200232d>] do_signal+0x4d/0x960
[  118.522360]  [<ffffffff82097584>] ? hrtimer_start_range_ns+0x14/0x20
[  118.522368]  [<ffffffff8262a98d>] ? binder_ioctl+0x15d/0x990
[  118.522377]  [<ffffffff82002ca5>] do_notify_resume+0x65/0x80
[  118.522384]  [<ffffffff82844efa>] int_signal+0x12/0x17

Signed-off-by: Leon Ma <xindong.ma@intel.com>
Signed-off-by: Zhang Di <di.zhang@intel.com>
Signed-off-by: Sun Zhonghua <zhonghua.sun@intel.com>
---
 kernel/exit.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 1ea4369..64ba13b 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -729,6 +729,8 @@ void do_exit(long code)
 	tsk->exit_code = code;
 	taskstats_exit(tsk, group_dead);
 
+	exit_files(tsk);
+	exit_task_work(tsk);
 	exit_mm(tsk);
 
 	if (group_dead)
@@ -737,12 +739,10 @@ void do_exit(long code)
 
 	exit_sem(tsk);
 	exit_shm(tsk);
-	exit_files(tsk);
 	exit_fs(tsk);
 	if (group_dead)
 		disassociate_ctty(1);
 	exit_task_namespaces(tsk);
-	exit_task_work(tsk);
 	exit_thread();
 
 	/*
-- 
1.7.9.5

