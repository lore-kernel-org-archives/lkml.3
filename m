Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980Ab3CFDHc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 22:07:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38165 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751217Ab3CFDHb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 22:07:31 -0500
Date: Tue, 5 Mar 2013 22:06:33 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Jiri Slaby <jslaby@suse.cz>, Peter Hurley <peter@hurleysoftware.com>
Subject: lockdep trace from kill_fasync (tty) vs account (random)
Message-ID: <20130306030633.GA6567@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Jiri Slaby <jslaby@suse.cz>,
	Peter Hurley <peter@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Came home to this on my box that I left fuzz-testing.

[56194.899379] ======================================================
[56194.899529] [ INFO: possible circular locking dependency detected ]
[56194.899679] 3.9.0-rc1+ #67 Not tainted
[56194.899769] -------------------------------------------------------
[56194.899920] modprobe/14420 is trying to acquire lock:
[56194.900041] blocked:  (&(&new->fa_lock)->rlock){......}, instance: ffff8800c240b4b8, at: [<ffffffff811c31d6>] kill_fasync+0x96/0x2a0
[56194.900343] 
but task is already holding lock:
[56194.900478] held:     (nonblocking_pool.lock){..-...}, instance: ffffffff81ca99a0, at: [<ffffffff81417909>] account+0x39/0x1c0
[56194.900765] 
which lock already depends on the new lock.

[56194.900949] 
the existing dependency chain (in reverse order) is:
[56194.901123] 
-> #2 (nonblocking_pool.lock){..-...}:
[56194.901249]        [<ffffffff810b7b72>] lock_acquire+0x92/0x1d0
[56194.901396]        [<ffffffff816c48f3>] _raw_spin_lock_irqsave+0x53/0x90
[56194.901555]        [<ffffffff814180c4>] mix_pool_bytes.constprop.16+0x44/0x180
[56194.901733]        [<ffffffff8141848b>] add_device_randomness+0x6b/0x90
[56194.901895]        [<ffffffff810725c2>] posix_cpu_timers_exit+0x22/0x50
[56194.902057]        [<ffffffff81048eff>] release_task+0x13f/0x670
[56194.902200]        [<ffffffff8104b16f>] do_exit+0x6af/0xce0
[56194.902335]        [<ffffffff810c406e>] __module_put_and_exit+0x1e/0x20
[56194.902495]        [<ffffffff812f9177>] cryptomgr_test+0x37/0x50
[56194.902641]        [<ffffffff8107071d>] kthread+0xed/0x100
[56194.902768]        [<ffffffff816cd5dc>] ret_from_fork+0x7c/0xb0
[56194.909181] 
-> #1 (&(&sighand->siglock)->rlock){-.-...}:
[56194.921863]        [<ffffffff810b7b72>] lock_acquire+0x92/0x1d0
[56194.928381]        [<ffffffff816c4da7>] _raw_write_lock_irq+0x47/0x80
[56194.934903]        [<ffffffff811c22ab>] __f_setown+0x6b/0x100
[56194.941244]        [<ffffffff813eed68>] __tty_fasync+0xd8/0x160
[56194.947564]        [<ffffffff813eee30>] tty_fasync+0x40/0x60
[56194.953794]        [<ffffffff811c43e2>] do_vfs_ioctl+0x3d2/0x570
[56194.959981]        [<ffffffff811c4611>] sys_ioctl+0x91/0xb0
[56194.966155]        [<ffffffff816cd682>] system_call_fastpath+0x16/0x1b
[56194.972304] 
-> #0 (&(&new->fa_lock)->rlock){......}:
[56194.984490]        [<ffffffff810b73f6>] __lock_acquire+0x1b86/0x1c80
[56194.990754]        [<ffffffff810b7b72>] lock_acquire+0x92/0x1d0
[56194.996950]        [<ffffffff816c48f3>] _raw_spin_lock_irqsave+0x53/0x90
[56195.003199]        [<ffffffff811c31d6>] kill_fasync+0x96/0x2a0
[56195.009468]        [<ffffffff814179db>] account+0x10b/0x1c0
[56195.015755]        [<ffffffff81418ad0>] extract_entropy+0x80/0x340
[56195.022035]        [<ffffffff81418f50>] get_random_bytes+0x20/0x30
[56195.028289]        [<ffffffff8120e172>] load_elf_binary+0xb82/0x1af0
[56195.034583]        [<ffffffff811b818b>] search_binary_handler+0x1ab/0x500
[56195.040856]        [<ffffffff811b8f55>] do_execve_common.isra.26+0x645/0x710
[56195.047172]        [<ffffffff811b9038>] do_execve+0x18/0x20
[56195.053373]        [<ffffffff81065a80>] ____call_usermodehelper+0xf0/0x120
[56195.059589]        [<ffffffff816cd5dc>] ret_from_fork+0x7c/0xb0
[56195.065737] 
other info that might help us debug this:

[56195.083945] Chain exists of:
  &(&new->fa_lock)->rlock --> &(&sighand->siglock)->rlock --> nonblocking_pool.lock

[56195.102332]  Possible unsafe locking scenario:

[56195.114608]        CPU0                    CPU1
[56195.120611]        ----                    ----
[56195.126579]   lock(nonblocking_pool.lock);
[56195.132476]                                lock(&(&sighand->siglock)->rlock);
[56195.138528]                                lock(nonblocking_pool.lock);
[56195.144492]   lock(&(&new->fa_lock)->rlock);
[56195.150410] 
 *** DEADLOCK ***

[56195.167408] 2 locks on stack by modprobe/14420:
[56195.172807]  #0: held:     (nonblocking_pool.lock){..-...}, instance: ffffffff81ca99a0, at: [<ffffffff81417909>] account+0x39/0x1c0
[56195.178598]  #1: blocked:  (rcu_read_lock){.+.+..}, instance: ffffffff81c39920, at: [<ffffffff811c3161>] kill_fasync+0x21/0x2a0
[56195.184418] 
stack backtrace:
[56195.195499] Pid: 14420, comm: modprobe Not tainted 3.9.0-rc1+ #67
[56195.201091] Call Trace:
[56195.206749]  [<ffffffff816b9325>] print_circular_bug+0x1fe/0x20f
[56195.212492]  [<ffffffff810b73f6>] __lock_acquire+0x1b86/0x1c80
[56195.218220]  [<ffffffff810b5b75>] ? __lock_acquire+0x305/0x1c80
[56195.223941]  [<ffffffff8100a196>] ? native_sched_clock+0x26/0x90
[56195.229611]  [<ffffffff810b7b72>] lock_acquire+0x92/0x1d0
[56195.235278]  [<ffffffff811c31d6>] ? kill_fasync+0x96/0x2a0
[56195.240916]  [<ffffffff816c48f3>] _raw_spin_lock_irqsave+0x53/0x90
[56195.246558]  [<ffffffff811c31d6>] ? kill_fasync+0x96/0x2a0
[56195.252203]  [<ffffffff811c31d6>] kill_fasync+0x96/0x2a0
[56195.257818]  [<ffffffff811c3161>] ? kill_fasync+0x21/0x2a0
[56195.263471]  [<ffffffff814179db>] account+0x10b/0x1c0
[56195.269081]  [<ffffffff810b8675>] ? trace_hardirqs_on_caller+0x115/0x1a0
[56195.274765]  [<ffffffff81418ad0>] extract_entropy+0x80/0x340
[56195.280404]  [<ffffffff81089173>] ? local_clock+0x43/0x50
[56195.286021]  [<ffffffff816c5860>] ? retint_restore_args+0xe/0xe
[56195.291684]  [<ffffffff81418f50>] get_random_bytes+0x20/0x30
[56195.297292]  [<ffffffff8120e172>] load_elf_binary+0xb82/0x1af0
[56195.302854]  [<ffffffff8120d5f0>] ? load_elf_library+0x220/0x220
[56195.308435]  [<ffffffff8120d5f0>] ? load_elf_library+0x220/0x220
[56195.313975]  [<ffffffff811b818b>] search_binary_handler+0x1ab/0x500
[56195.319495]  [<ffffffff811b805f>] ? search_binary_handler+0x7f/0x500
[56195.325056]  [<ffffffff811b8f55>] do_execve_common.isra.26+0x645/0x710
[56195.330671]  [<ffffffff811b8a32>] ? do_execve_common.isra.26+0x122/0x710
[56195.336307]  [<ffffffff811b9038>] do_execve+0x18/0x20
[56195.341907]  [<ffffffff81065a80>] ____call_usermodehelper+0xf0/0x120
[56195.347486]  [<ffffffff810832f0>] ? schedule_tail+0x30/0xb0
[56195.353073]  [<ffffffff81065990>] ? proc_cap_handler+0x1b0/0x1b0
[56195.358595]  [<ffffffff816cd5dc>] ret_from_fork+0x7c/0xb0
[56195.364105]  [<ffffffff81065990>] ? proc_cap_handler+0x1b0/0x1b0

