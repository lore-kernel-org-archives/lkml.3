Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933635AbaCSKAL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 06:00:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55271 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933254AbaCSKAI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 06:00:08 -0400
Date: Wed, 19 Mar 2014 11:00:05 +0100
From: Jan Kara <jack@suse.cz>
To: Jane Li <jiel@marvell.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "joe@perches.com" <joe@perches.com>, "tj@kernel.org" <tj@kernel.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] printk: fix one circular lockdep warning about
 console_lock
Message-ID: <20140319100005.GD26358@quack.suse.cz>
References: <1392101400-14550-1-git-send-email-jiel@marvell.com>
 <20140211131927.f180ac29dede51b2733b92a6@linux-foundation.org>
 <53290A18.704@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53290A18.704@marvell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 19-03-14 11:08:08, Jane Li wrote:
> On 02/12/2014 05:19 AM, Andrew Morton wrote:
> 
> >On Tue, 11 Feb 2014 14:50:00 +0800<jiel@marvell.com>  wrote:
> >
> >>From: Jane Li<jiel@marvell.com>
> >>
> >>This patch tries to fix a warning about possible circular locking
> >>dependency.
> >>
> >>If do in following sequence:
> >>     enter suspend ->  resume ->  plug-out CPUx (echo 0 > cpux/online)
> >>lockdep will show warning as following:
> >>
> >>======================================================
> >>[ INFO: possible circular locking dependency detected ]
> >>3.10.0 #2 Tainted: G           O
> >>-------------------------------------------------------
> >>sh/1271 is trying to acquire lock:
> >>(console_lock){+.+.+.}, at: [<c06ebf7c>] console_cpu_notify+0x20/0x2c
> >>but task is already holding lock:
> >>(cpu_hotplug.lock){+.+.+.}, at: [<c012b4e8>] cpu_hotplug_begin+0x2c/0x58
> >>which lock already depends on the new lock.
> >>
> >>the existing dependency chain (in reverse order) is:
> >>-> #2 (cpu_hotplug.lock){+.+.+.}:
> >>[<c017bb7c>] lock_acquire+0x98/0x12c
> >>[<c06f5014>] mutex_lock_nested+0x50/0x3d8
> >>[<c012b4e8>] cpu_hotplug_begin+0x2c/0x58
> >>[<c06ebfac>] _cpu_up+0x24/0x154
> >>[<c06ec140>] cpu_up+0x64/0x84
> >>[<c0981834>] smp_init+0x9c/0xd4
> >>[<c0973880>] kernel_init_freeable+0x78/0x1c8
> >>[<c06e7f40>] kernel_init+0x8/0xe4
> >>[<c010eec8>] ret_from_fork+0x14/0x2c
> >>
> >>-> #1 (cpu_add_remove_lock){+.+.+.}:
> >>[<c017bb7c>] lock_acquire+0x98/0x12c
> >>[<c06f5014>] mutex_lock_nested+0x50/0x3d8
> >>[<c012b758>] disable_nonboot_cpus+0x8/0xe8
> >>[<c016b83c>] suspend_devices_and_enter+0x214/0x448
> >>[<c016bc54>] pm_suspend+0x1e4/0x284
> >>[<c016bdcc>] try_to_suspend+0xa4/0xbc
> >>[<c0143848>] process_one_work+0x1c4/0x4fc
> >>[<c0143f80>] worker_thread+0x138/0x37c
> >>[<c014aaf8>] kthread+0xa4/0xb0
> >>[<c010eec8>] ret_from_fork+0x14/0x2c
> >>
> >>-> #0 (console_lock){+.+.+.}:
> >>[<c017b5d0>] __lock_acquire+0x1b38/0x1b80
> >>[<c017bb7c>] lock_acquire+0x98/0x12c
> >>[<c01288c4>] console_lock+0x54/0x68
> >>[<c06ebf7c>] console_cpu_notify+0x20/0x2c
> >>[<c01501d4>] notifier_call_chain+0x44/0x84
> >>[<c012b448>] __cpu_notify+0x2c/0x48
> >>[<c012b5b0>] cpu_notify_nofail+0x8/0x14
> >>[<c06e81bc>] _cpu_down+0xf4/0x258
> >>[<c06e8344>] cpu_down+0x24/0x40
> >>[<c06e921c>] store_online+0x30/0x74
> >>[<c03b7298>] dev_attr_store+0x18/0x24
> >>[<c025fc5c>] sysfs_write_file+0x16c/0x19c
> >>[<c0207a98>] vfs_write+0xb4/0x190
> >>[<c0207e58>] SyS_write+0x3c/0x70
> >>[<c010ee00>] ret_fast_syscall+0x0/0x48
> >>
> >>Chain exists of:
> >>    console_lock --> cpu_add_remove_lock --> cpu_hotplug.lock
> >>
> >>Possible unsafe locking scenario:
> >>        CPU0                    CPU1
> >>        ----                    ----
> >>lock(cpu_hotplug.lock);
> >>                                lock(cpu_add_remove_lock);
> >>                                lock(cpu_hotplug.lock);
> >>lock(console_lock);
> >>   *** DEADLOCK ***
> >These traces hurt my brain.
> >
> >>There are three locks involved in two sequence:
> >>a) pm suspend:
> >>	console_lock (@suspend_console())
> >>	cpu_add_remove_lock (@disable_nonboot_cpus())
> >>	cpu_hotplug.lock (@_cpu_down())
> >But but but.  suspend_console() releases console_sem again.  So the
> >sequence is actually
> >
> >  	down(&console_sem) (@suspend_console())
> >  	up(&console_sem) (@suspend_console())
> >  	cpu_add_remove_lock (@disable_nonboot_cpus())
> >  	cpu_hotplug.lock (@_cpu_down())
> >
> >So console_sem *doesn't* nest outside cpu_add_remove_lock and
> >cpu_hotplug.lock.
> 
>  Jan Kara and Jane have answered this question in other emails.
> 
> >>b) Plug-out CPUx:
> >>	cpu_add_remove_lock (@(cpu_down())
> >>	cpu_hotplug.lock (@_cpu_down())
> >>	console_lock (@console_cpu_notify()) => Lockdeps prints warning log.
> >>
> >>There should be not real deadlock, as flag of console_suspended can
> >>protect this.
> >console_lock() does down(&console_sem) *before* testing
> >console_suspended, so I don't understand this sentence - a more
> >detailed description would help.
> 
> Jane has answered this question in another email.
> 
> >>Printk registers cpu hotplug notify function. When CPUx is plug-out/in,
> >>always execute console_lock() and console_unlock(). This patch
> >>modifies that with console_trylock() and console_unlock(). Then use
> >>that instead of the unconditional console_lock/unlock pair to avoid the
> >>warning.
> >>
> >>...
> >>
> >>--- a/kernel/printk/printk.c
> >>+++ b/kernel/printk/printk.c
> >>@@ -1893,6 +1893,20 @@ void resume_console(void)
> >>  }
> >>  /**
> >>+ * console_flush - flush dmesg if console isn't suspended
> >>+ *
> >>+ * console_unlock always flushes the dmesg buffer, so just try to
> >>+ * grab&drop the console lock. If that fails we know that the current
> >>+ * holder will eventually drop the console lock and so flush the dmesg
> >>+ * buffers at the earliest possible time.
> >>+ */
> >The comment should describe why we added this code, please: talk about
> >cpu_hotplug.lock and console_lock.
> 
> Daniel has answered this question in another email.
> 
> >>+void console_flush(void)
> >>+{
> >>+	if (console_trylock())
> >>+		console_unlock();
> >>+}
> >>+
> >>+/**
> >>   * console_cpu_notify - print deferred console messages after CPU hotplug
> >>   * @self: notifier struct
> >>   * @action: CPU hotplug event
> >>@@ -1911,8 +1925,7 @@ static int console_cpu_notify(struct notifier_block *self,
> >>  	case CPU_DEAD:
> >>  	case CPU_DOWN_FAILED:
> >>  	case CPU_UP_CANCELED:
> >>-		console_lock();
> >>-		console_unlock();
> >>+		console_flush();
> >>  	}
> >>  	return NOTIFY_OK;
> >Well, this is a bit hacky and makes the already-far-too-complex code
> >even more complex.  If it is indeed the case that the deadlock cannot
> >really occur then let's try to find a way of suppressing the lockdep
> >warning without making runtime changes.
> >
> >What I'm struggling with is what *should* the ranking of these locks be?
> > From a conceptual high-level design standpoint, which is the
> >"innermost" lock?  I tend to think that it is console_lock, because
> >blocking CPU hotplug is a quite high-level operation.
> >
> >But console_lock is such a kooky special-case in the way it is used to
> >control the printk corking that it is hard to take general rules and
> >apply them here.
> 
> Daniel and Jan Kara have answered this question in other emails.
> 
> Do you agree with this solution or have other comments?
  Umm, I disagree with the patch. What I proposed in my answer to your
patch is something like the patch below. Does it fix your problem?

								Honza

>From 91497a88c403a7f22e78fee2f69d7413c6e8209f Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Wed, 19 Mar 2014 10:56:12 +0100
Subject: [PATCH] printk: Fixup lockdep annotation in console_suspend()

Although console_suspend() releases console_sem, it doesn't tell lockdep
about it. That results in the lockdep warning about circular locking
when doing the following:
  enter suspend ->  resume ->  plug-out CPUx (echo 0 > cpux/online)

Fix the problem by telling lockdep we actually released the semaphore in
console_suspend() and acquired it again in console_resume().

Signed-off-by: Jan Kara <jack@suse.cz>
---
 kernel/printk/printk.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 4dae9cbe9259..e6ada322782b 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -1880,6 +1880,7 @@ void suspend_console(void)
 	console_lock();
 	console_suspended = 1;
 	up(&console_sem);
+	mutex_release(&console_lock_dep_map, 1, _RET_IP_);
 }
 
 void resume_console(void)
@@ -1887,6 +1888,7 @@ void resume_console(void)
 	if (!console_suspend_enabled)
 		return;
 	down(&console_sem);
+	mutex_acquire(&console_lock_dep_map, 0, 0, _RET_IP_);
 	console_suspended = 0;
 	console_unlock();
 }
-- 
1.8.1.4

