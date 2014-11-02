Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898AbaKBHbK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 02:31:10 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:39718 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbaKBHbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 02:31:05 -0500
Message-ID: <1414913460.5380.112.camel@marge.simpson.net>
Subject: 3.14.23-rt20 - wwmutex: fix __ww_mutex_lock_interruptible lockdep
 annotation
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <williams@redhat.com>
Date: Sun, 02 Nov 2014 08:31:00 +0100
In-Reply-To: <1414910967.5380.81.camel@marge.simpson.net>
References: <20141031170326.1491a63f@gandalf.local.home>
	 <1414910967.5380.81.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding mutex_acquire_nest() as used in __ww_mutex_lock() fixes the 
lockdep splat below.  Remove superflous linebreak in __ww_mutex_lock()
as well.

[   56.999063] =============================================
[   56.999063] [ INFO: possible recursive locking detected ]
[   56.999065] 3.14.4-rt5 #26 Not tainted
[   56.999065] ---------------------------------------------
[   56.999067] Xorg/4298 is trying to acquire lock:
[   56.999107]  (reservation_ww_class_mutex){+.+.+.}, at: [<ffffffffa02b4270>] nouveau_gem_ioctl_pushbuf+0x870/0x19f0 [nouveau]
[   56.999107] 
               but task is already holding lock:
[   56.999130]  (reservation_ww_class_mutex){+.+.+.}, at: [<ffffffffa02b4270>] nouveau_gem_ioctl_pushbuf+0x870/0x19f0 [nouveau]
[   56.999131] 
               other info that might help us debug this:
[   56.999131]  Possible unsafe locking scenario:
               
[   56.999132]        CPU0
[   56.999132]        ----
[   56.999133]   lock(reservation_ww_class_mutex);
[   56.999134]   lock(reservation_ww_class_mutex);
[   56.999134] 
                *** DEADLOCK ***
               
[   56.999135]  May be due to missing lock nesting notation
               
[   56.999136] 3 locks held by Xorg/4298:
[   56.999160]  #0:  (&cli->mutex){+.+.+.}, at: [<ffffffffa02b597b>] nouveau_abi16_get+0x2b/0x100 [nouveau]
[   56.999174]  #1:  (reservation_ww_class_acquire){+.+...}, at: [<ffffffffa0160cd2>] drm_ioctl+0x4d2/0x610 [drm]
[   56.999197]  #2:  (reservation_ww_class_mutex){+.+.+.}, at: [<ffffffffa02b4270>] nouveau_gem_ioctl_pushbuf+0x870/0x19f0 [nouveau]
[   56.999198] 
               stack backtrace:
[   56.999200] CPU: 1 PID: 4298 Comm: Xorg Not tainted 3.14.4-rt5 #26
[   56.999200] Hardware name: MEDIONPC MS-7502/MS-7502, BIOS 6.00 PG 12/26/2007
[   56.999203]  ffffffff820309b0 ffff8802217a9ac8 ffffffff8157e53e ffffffff820309b0
[   56.999205]  ffff8802217a9b90 ffffffff810964ce ffff8802217a9b40 0000000000000246
[   56.999207]  0000000000000003 ffffffff8204f130 0001e09300000000 0001e093347523a9
[   56.999207] Call Trace:
[   56.999212]  [<ffffffff8157e53e>] dump_stack+0x4f/0x9d
[   56.999215]  [<ffffffff810964ce>] __lock_acquire+0x169e/0x1a50
[   56.999218]  [<ffffffff81588da9>] ? preempt_count_sub+0x49/0x50
[   56.999219]  [<ffffffff81584541>] ? _raw_spin_unlock+0x31/0x60
[   56.999221]  [<ffffffff8109701d>] lock_acquire+0x8d/0x140
[   56.999243]  [<ffffffffa02b4270>] ? nouveau_gem_ioctl_pushbuf+0x870/0x19f0 [nouveau]
[   56.999246]  [<ffffffff8158313d>] __ww_mutex_lock_interruptible+0x3d/0xf0
[   56.999268]  [<ffffffffa02b4270>] ? nouveau_gem_ioctl_pushbuf+0x870/0x19f0 [nouveau]
[   56.999290]  [<ffffffffa02b4270>] nouveau_gem_ioctl_pushbuf+0x870/0x19f0 [nouveau]
[   56.999298]  [<ffffffffa0160cd2>] ? drm_ioctl+0x4d2/0x610 [drm]
[   56.999308]  [<ffffffffa0160cd2>] drm_ioctl+0x4d2/0x610 [drm]
[   56.999311]  [<ffffffff81588da9>] ? preempt_count_sub+0x49/0x50
[   56.999313]  [<ffffffff8107cd60>] ? migrate_enable+0xe0/0x1e0
[   56.999335]  [<ffffffffa02aaece>] nouveau_drm_ioctl+0x4e/0x90 [nouveau]
[   56.999338]  [<ffffffff81185ff0>] do_vfs_ioctl+0x300/0x530
[   56.999340]  [<ffffffff8158d33b>] ? sysret_check+0x1b/0x56
[   56.999342]  [<ffffffff81094a8d>] ? trace_hardirqs_on_caller+0x10d/0x1d0
[   56.999344]  [<ffffffff81186261>] SyS_ioctl+0x41/0x80
[   56.999345]  [<ffffffff8158d316>] system_call_fastpath+0x1a/0x1f

Signed-off-by: Mike Galbraith <umgwanakikbuti@gmail.com>
---
 kernel/locking/rtmutex.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/kernel/locking/rtmutex.c
+++ b/kernel/locking/rtmutex.c
@@ -1964,7 +1964,7 @@ __ww_mutex_lock_interruptible(struct ww_
 
 	might_sleep();
 
-	mutex_acquire(&lock->base.dep_map, 0, 0, _RET_IP_);
+	mutex_acquire_nest(&lock->base.dep_map, 0, 0, &ww_ctx->dep_map, _RET_IP_);
 	ret = rt_mutex_slowlock(&lock->base.lock, TASK_INTERRUPTIBLE, NULL, 0, ww_ctx);
 	if (ret)
 		mutex_release(&lock->base.dep_map, 1, _RET_IP_);
@@ -1982,8 +1982,7 @@ __ww_mutex_lock(struct ww_mutex *lock, s
 
 	might_sleep();
 
-	mutex_acquire_nest(&lock->base.dep_map, 0, 0, &ww_ctx->dep_map,
-			_RET_IP_);
+	mutex_acquire_nest(&lock->base.dep_map, 0, 0, &ww_ctx->dep_map, _RET_IP_);
 	ret = rt_mutex_slowlock(&lock->base.lock, TASK_UNINTERRUPTIBLE, NULL, 0, ww_ctx);
 	if (ret)
 		mutex_release(&lock->base.dep_map, 1, _RET_IP_);





