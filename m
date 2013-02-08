Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760398Ab3BHVo6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 16:44:58 -0500
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:34840 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758008Ab3BHVo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 16:44:57 -0500
Date: Fri, 8 Feb 2013 23:44:47 +0200
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: macintosh/windfarm: possible circular locking dependency detected
Message-ID: <20130208214447.GD3178@blackmetal.musicnaut.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On iMac G5 (the first model, windfarm_pm81 reports "model 3"), enabling
LOCKDEP results in the following warnings when overtemp condition is
encountered.

The kernel is 3.8-rc6+ / 6bacaa9.

[ 7060.058340] windfarm: Clamping CPU frequency to minimum !
[ 7060.229688] 
[ 7060.229756] ======================================================
[ 7060.229799] [ INFO: possible circular locking dependency detected ]
[ 7060.229847] 3.8.0-rc6-imac-00113-g6bacaa9 #2 Not tainted
[ 7060.229882] -------------------------------------------------------
[ 7060.229923] kwindfarm/475 is trying to acquire lock:
[ 7060.229958]  (wf_lock){+.+.+.}, at: [<c000000000447b54>] .wf_set_overtemp+0x34/0xb0
[ 7060.230070] 
[ 7060.230070] but task is already holding lock:
[ 7060.230111]  ((wf_client_list).rwsem){.+.+.+}, at: [<c0000000000851a8>] .__blocking_notifier_call_chain+0x78/0x110
[ 7060.230219] 
[ 7060.230219] which lock already depends on the new lock.
[ 7060.230219] 
[ 7060.230275] 
[ 7060.230275] the existing dependency chain (in reverse order) is:
[ 7060.230326] 
[ 7060.230326] -> #1 ((wf_client_list).rwsem){.+.+.+}:
[ 7060.230407]        [<c0000000006cbf98>] .down_read+0x58/0xa0
[ 7060.230463]        [<c0000000000851a8>] .__blocking_notifier_call_chain+0x78/0x110
[ 7060.230521]        [<c000000000447d70>] .wf_register_client+0xb0/0x1b0
[ 7060.230573]        [<c000000000449f0c>] .wf_smu_probe+0x1c/0x40
[ 7060.230621]        [<c00000000042e7d0>] .platform_drv_probe+0x30/0x50
[ 7060.230681]        [<c00000000042c868>] .driver_probe_device+0xa8/0x290
[ 7060.230735]        [<c00000000042cb5c>] .__driver_attach+0x10c/0x110
[ 7060.230787]        [<c00000000042a10c>] .bus_for_each_dev+0x7c/0xe0
[ 7060.230837]        [<c00000000042c1c8>] .driver_attach+0x28/0x40
[ 7060.230888]        [<c00000000042bba8>] .bus_add_driver+0x1f8/0x330
[ 7060.230937]        [<c00000000042d4f4>] .driver_register+0xa4/0x230
[ 7060.230989]        [<c00000000042eb10>] .platform_driver_register+0x60/0x80
[ 7060.231044]        [<c000000000949924>] .wf_smu_init+0x8c/0xa8
[ 7060.231098]        [<c000000000009aa8>] .do_one_initcall+0x168/0x1e0
[ 7060.231151]        [<c000000000927b70>] .kernel_init_freeable+0x134/0x204
[ 7060.231209]        [<c00000000000a1bc>] .kernel_init+0x1c/0x120
[ 7060.231256]        [<c000000000008aa0>] .ret_from_kernel_thread+0x64/0xc4
[ 7060.231311] 
[ 7060.231311] -> #0 (wf_lock){+.+.+.}:
[ 7060.231381]        [<c0000000000a3efc>] .lock_acquire+0x5c/0x90
[ 7060.231434]        [<c0000000006cb5b0>] .mutex_lock_nested+0x90/0x3b0
[ 7060.231488]        [<c000000000447b54>] .wf_set_overtemp+0x34/0xb0
[ 7060.231539]        [<c00000000044a844>] .wf_smu_notify+0x914/0xf90
[ 7060.231590]        [<c000000000084e2c>] .notifier_call_chain+0xcc/0x1f0
[ 7060.231643]        [<c0000000000851c4>] .__blocking_notifier_call_chain+0x94/0x110
[ 7060.231699]        [<c000000000448a18>] .wf_thread_func+0x88/0x150
[ 7060.231747]        [<c00000000007c22c>] .kthread+0xec/0x100
[ 7060.231794]        [<c000000000008aa0>] .ret_from_kernel_thread+0x64/0xc4
[ 7060.231850] 
[ 7060.231850] other info that might help us debug this:
[ 7060.231850] 
[ 7060.231905]  Possible unsafe locking scenario:
[ 7060.231905] 
[ 7060.231945]        CPU0                    CPU1
[ 7060.231976]        ----                    ----
[ 7060.232007]   lock((wf_client_list).rwsem);
[ 7060.232054]                                lock(wf_lock);
[ 7060.232104]                                lock((wf_client_list).rwsem);
[ 7060.232160]   lock(wf_lock);
[ 7060.233707] 
[ 7060.233707]  *** DEADLOCK ***
[ 7060.233707] 
[ 7060.238238] 1 lock held by kwindfarm/475:
[ 7060.239756]  #0:  ((wf_client_list).rwsem){.+.+.+}, at: [<c0000000000851a8>] .__blocking_notifier_call_chain+0x78/0x110
[ 7060.241354] 
[ 7060.241354] stack backtrace:
[ 7060.244453] Call Trace:
[ 7060.246001] [c0000000564534f0] [c000000000012978] .show_stack+0x78/0x1b0 (unreliable)
[ 7060.247582] [c0000000564535a0] [c0000000006d09c8] .print_circular_bug+0x2e8/0x320
[ 7060.249157] [c000000056453650] [c0000000000a36c0] .__lock_acquire+0x17b0/0x1a70
[ 7060.250734] [c0000000564537d0] [c0000000000a3efc] .lock_acquire+0x5c/0x90
[ 7060.252305] [c000000056453870] [c0000000006cb5b0] .mutex_lock_nested+0x90/0x3b0
[ 7060.253879] [c000000056453960] [c000000000447b54] .wf_set_overtemp+0x34/0xb0
[ 7060.255460] [c0000000564539f0] [c00000000044a844] .wf_smu_notify+0x914/0xf90
[ 7060.257019] [c000000056453ad0] [c000000000084e2c] .notifier_call_chain+0xcc/0x1f0
[ 7060.258598] [c000000056453b80] [c0000000000851c4] .__blocking_notifier_call_chain+0x94/0x110
[ 7060.260169] [c000000056453c30] [c000000000448a18] .wf_thread_func+0x88/0x150
[ 7060.261725] [c000000056453cc0] [c00000000007c22c] .kthread+0xec/0x100
[ 7060.263267] [c000000056453e30] [c000000000008aa0] .ret_from_kernel_thread+0x64/0xc4
[ 7060.270273] windfarm: Overtemp condition detected !
[ 7062.033879] windfarm: CPU frequency unclamped !
[ 7062.035508] windfarm: Overtemp condition cleared !
[ 7221.058391] windfarm: Clamping CPU frequency to minimum !
[ 7221.196337] windfarm: Overtemp condition detected !
[ 7223.030000] windfarm: CPU frequency unclamped !
[ 7223.067554] windfarm: Overtemp condition cleared !

A.
