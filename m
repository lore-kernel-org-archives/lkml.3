Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758275AbaCTMqt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 08:46:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9656 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755574AbaCTMqr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 08:46:47 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH] mei, release device lock when registering watchdog
Date: Thu, 20 Mar 2014 08:46:40 -0400
Message-Id: <1395319600-31058-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't know if this also shows a possible latent bug with lockdep.  It
seems like I should be seeing this bug all the time with kernels 3.6.6 and
onward.  Testing indicates that the bug is present in 3.11, and 3.12 but
for some reason the reporting of the bug comes-and-goes as patches are
added and removed to the kernel...

P.

---8<---

Seen in kernels,

3.6.6: http://lkml.org/lkml/2012/11/13/184
3.10.0: where I have seen it (and what led to this patch)
3.11: seen in testing (boot & cat /dev/watchdog, OR, reboot)
3.12: seen in testing (boot & cat /dev/watchdog, OR, reboot)
3.13.0: https://lists.fedoraproject.org/pipermail/test/2013-May/115423.html
3.14.0: I can occasionally reproduce this by issuing a reboot.

The lockdep info is:

[   42.016059] ======================================================
[   42.022222] [ INFO: possible circular locking dependency detected ]
[   42.028471] 3.13.0 #1 Not tainted
[   42.031775] -------------------------------------------------------
[   42.038025] cat/2175 is trying to acquire lock:
[   42.042543]  (&dev->device_lock){+.+.+.}, at: [<ffffffff813fcd0d>] mei_wd_ops_start+0x2d/0xf0
[   42.051100]
[   42.051100] but task is already holding lock:
[   42.056917]  (&wdd->lock){+.+...}, at: [<ffffffff81494f52>] watchdog_start+0x22/0x80
[   42.064687]
[   42.064687] which lock already depends on the new lock.
[   42.064687]
[   42.072841]
[   42.072841] the existing dependency chain (in reverse order) is:
[   42.080302]
-> #2 (&wdd->lock){+.+...}:
[   42.084353]        [<ffffffff810b8297>] validate_chain.isra.41+0x4a7/0x910
[   42.091222]        [<ffffffff810b9566>] __lock_acquire+0x3c6/0xb60
[   42.097398]        [<ffffffff810ba4f2>] lock_acquire+0xa2/0x120
[   42.103312]        [<ffffffff8161855d>] mutex_lock_nested+0x5d/0x4c0
[   42.109663]        [<ffffffff81494f52>] watchdog_start+0x22/0x80
[   42.115665]        [<ffffffff814951c8>] watchdog_open+0x98/0xf0
[   42.121582]        [<ffffffff813c0e03>] misc_open+0xb3/0x170
[   42.127240]        [<ffffffff811d0baf>] chrdev_open+0x9f/0x1c0
[   42.133069]        [<ffffffff811c96a7>] do_dentry_open+0x1d7/0x2f0
[   42.139245]        [<ffffffff811c99b1>] finish_open+0x31/0x40
[   42.144986]        [<ffffffff811dc157>] do_last+0xbd7/0x13c0
[   42.150642]        [<ffffffff811dc9fe>] path_openat+0xbe/0x640
[   42.156468]        [<ffffffff811dd79a>] do_filp_open+0x3a/0x90
[   42.162298]        [<ffffffff811cb248>] do_sys_open+0x128/0x220
[   42.168214]        [<ffffffff811cb35e>] SyS_open+0x1e/0x20
[   42.173695]        [<ffffffff816256e9>] system_call_fastpath+0x16/0x1b
[   42.180217]
-> #1 (misc_mtx){+.+.+.}:
[   42.184088]        [<ffffffff810b8297>] validate_chain.isra.41+0x4a7/0x910
[   42.190957]        [<ffffffff810b9566>] __lock_acquire+0x3c6/0xb60
[   42.197134]        [<ffffffff810ba4f2>] lock_acquire+0xa2/0x120
[   42.203048]        [<ffffffff8161855d>] mutex_lock_nested+0x5d/0x4c0
[   42.209396]        [<ffffffff813c0b69>] misc_register+0x29/0x120
[   42.215399]        [<ffffffff814956c5>] watchdog_dev_register+0x35/0x120
[   42.222093]        [<ffffffff81494d0c>] watchdog_register_device+0xac/0x1f0
[   42.229046]        [<ffffffff813fd3b9>] mei_watchdog_register+0x19/0x70
[   42.235651]        [<ffffffff813f6729>] mei_hbm_dispatch+0x269/0xc80
[   42.241999]        [<ffffffff813f72e4>] mei_irq_read_handler+0xe4/0x900
[   42.248609]        [<ffffffff813ffee5>] mei_me_irq_thread_handler+0x115/0x310
[   42.255735]        [<ffffffff810cbb50>] irq_thread_fn+0x20/0x50
[   42.261653]        [<ffffffff810cbfb3>] irq_thread+0x123/0x150
[   42.267482]        [<ffffffff8108d90f>] kthread+0xff/0x120
[   42.272966]        [<ffffffff8162563c>] ret_from_fork+0x7c/0xb0
[   42.278881]
-> #0 (&dev->device_lock){+.+.+.}:
[   42.283536]        [<ffffffff810b7de7>] check_prevs_add+0x967/0x970
[   42.289801]        [<ffffffff810b8297>] validate_chain.isra.41+0x4a7/0x910
[   42.296670]        [<ffffffff810b9566>] __lock_acquire+0x3c6/0xb60
[   42.302843]        [<ffffffff810ba4f2>] lock_acquire+0xa2/0x120
[   42.308760]        [<ffffffff8161855d>] mutex_lock_nested+0x5d/0x4c0
[   42.315108]        [<ffffffff813fcd0d>] mei_wd_ops_start+0x2d/0xf0
[   42.321281]        [<ffffffff81494f8d>] watchdog_start+0x5d/0x80
[   42.327282]        [<ffffffff814951c8>] watchdog_open+0x98/0xf0
[   42.333194]        [<ffffffff813c0e03>] misc_open+0xb3/0x170
[   42.338851]        [<ffffffff811d0baf>] chrdev_open+0x9f/0x1c0
[   42.344681]        [<ffffffff811c96a7>] do_dentry_open+0x1d7/0x2f0
[   42.350855]        [<ffffffff811c99b1>] finish_open+0x31/0x40
[   42.356597]        [<ffffffff811dc157>] do_last+0xbd7/0x13c0
[   42.362255]        [<ffffffff811dc9fe>] path_openat+0xbe/0x640
[   42.368084]        [<ffffffff811dd79a>] do_filp_open+0x3a/0x90
[   42.373911]        [<ffffffff811cb248>] do_sys_open+0x128/0x220
[   42.379824]        [<ffffffff811cb35e>] SyS_open+0x1e/0x20
[   42.385305]        [<ffffffff816256e9>] system_call_fastpath+0x16/0x1b
[   42.391826]
[   42.391826] other info that might help us debug this:
[   42.391826]
[   42.399808] Chain exists of:
  &dev->device_lock --> misc_mtx --> &wdd->lock

[   42.407170]  Possible unsafe locking scenario:
[   42.407170]
[   42.413073]        CPU0                    CPU1
[   42.417588]        ----                    ----
[   42.422105]   lock(&wdd->lock);
[   42.425259]                                lock(misc_mtx);
[   42.430752]                                lock(&wdd->lock);
[   42.436420]   lock(&dev->device_lock);
[   42.440178]
[   42.440178]  *** DEADLOCK ***
[   42.440178]
[   42.446081] 2 locks held by cat/2175:
[   42.449732]  #0:  (misc_mtx){+.+.+.}, at: [<ffffffff813c0d7e>] misc_open+0x2e/0x170
[   42.457430]  #1:  (&wdd->lock){+.+...}, at: [<ffffffff81494f52>] watchdog_start+0x22/0x80
[   42.465647]
[   42.465647] stack backtrace:
[   42.469992] CPU: 7 PID: 2175 Comm: cat Not tainted 3.13.0 #1
[   42.475636] Hardware name: Intel Corporation 2012 Client Platform/Emerald Lake 2, BIOS ACRVMBY1.86C.0078.P00.1201161002 01/16/2012
[   42.487340]  ffffffff822b2a40 ffff880036475918 ffffffff81613aa0 ffffffff822ca9e0
[   42.494763]  ffff880036475958 ffffffff8160defb ffff880036475980 0000000000000001
[   42.502186]  ffff88023af4e400 ffff88023af4ef40 ffff88023af4ef40 0000000000000002
[   42.509609] Call Trace:
[   42.512048]  [<ffffffff81613aa0>] dump_stack+0x45/0x56
[   42.517172]  [<ffffffff8160defb>] print_circular_bug+0x1f9/0x207
[   42.523161]  [<ffffffff810b7de7>] check_prevs_add+0x967/0x970
[   42.528893]  [<ffffffff810b7952>] ? check_prevs_add+0x4d2/0x970
[   42.534797]  [<ffffffff810b8297>] validate_chain.isra.41+0x4a7/0x910
[   42.541132]  [<ffffffff810b9566>] __lock_acquire+0x3c6/0xb60
[   42.546776]  [<ffffffff810b9566>] ? __lock_acquire+0x3c6/0xb60
[   42.552591]  [<ffffffff810ba4f2>] lock_acquire+0xa2/0x120
[   42.557974]  [<ffffffff813fcd0d>] ? mei_wd_ops_start+0x2d/0xf0
[   42.563790]  [<ffffffff8161855d>] mutex_lock_nested+0x5d/0x4c0
[   42.569605]  [<ffffffff813fcd0d>] ? mei_wd_ops_start+0x2d/0xf0
[   42.575421]  [<ffffffff810b8dbd>] ? trace_hardirqs_on+0xd/0x10
[   42.581235]  [<ffffffff813fcd0d>] ? mei_wd_ops_start+0x2d/0xf0
[   42.587052]  [<ffffffff81494f52>] ? watchdog_start+0x22/0x80
[   42.592697]  [<ffffffff81494f52>] ? watchdog_start+0x22/0x80
[   42.598341]  [<ffffffff813fcd0d>] mei_wd_ops_start+0x2d/0xf0
[   42.603984]  [<ffffffff81494f8d>] watchdog_start+0x5d/0x80
[   42.609453]  [<ffffffff814951c8>] watchdog_open+0x98/0xf0
[   42.614836]  [<ffffffff813c0e03>] misc_open+0xb3/0x170
[   42.619961]  [<ffffffff811d0baf>] chrdev_open+0x9f/0x1c0
[   42.625257]  [<ffffffff811c96a7>] do_dentry_open+0x1d7/0x2f0
[   42.630901]  [<ffffffff811d7e62>] ? __inode_permission+0x52/0xc0
[   42.636892]  [<ffffffff811d0b10>] ? cdev_put+0x30/0x30
[   42.642016]  [<ffffffff811c99b1>] finish_open+0x31/0x40
[   42.647226]  [<ffffffff811dc157>] do_last+0xbd7/0x13c0
[   42.652349]  [<ffffffff811d7ee8>] ? inode_permission+0x18/0x50
[   42.658165]  [<ffffffff811d8631>] ? link_path_walk+0x71/0x850
[   42.663894]  [<ffffffff811dc9fe>] path_openat+0xbe/0x640
[   42.669190]  [<ffffffff810b9566>] ? __lock_acquire+0x3c6/0xb60
[   42.675005]  [<ffffffff810a0a15>] ? sched_clock_cpu+0xb5/0x100
[   42.680822]  [<ffffffff811dd79a>] do_filp_open+0x3a/0x90
[   42.686118]  [<ffffffff8161c187>] ? _raw_spin_unlock+0x27/0x30
[   42.691934]  [<ffffffff811eb20f>] ? __alloc_fd+0xaf/0x140
[   42.697318]  [<ffffffff811cb248>] do_sys_open+0x128/0x220
[   42.702700]  [<ffffffff811cb35e>] SyS_open+0x1e/0x20
[   42.707652]  [<ffffffff816256e9>] system_call_fastpath+0x16/0x1b

The mei_watchdog_register() only registers the watchdog.
mei_watchdog_unregister() is called outside of the dev->device_lock so it
looks like mei_watchdog_register() can as well.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Cc: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/hbm.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/misc/mei/hbm.c b/drivers/misc/mei/hbm.c
index 28cd74c..fdc83ff 100644
--- a/drivers/misc/mei/hbm.c
+++ b/drivers/misc/mei/hbm.c
@@ -491,7 +491,9 @@ static void mei_hbm_cl_connect_res(struct mei_device *dev,
 
 	if (is_treat_specially_client(&dev->wd_cl, rs)) {
 		dev_dbg(&dev->pdev->dev, "successfully connected to WD client.\n");
+		mutex_unlock(&dev->device_lock);
 		mei_watchdog_register(dev);
+		mutex_lock(&dev->device_lock);
 
 		return;
 	}
-- 
1.7.9.3

