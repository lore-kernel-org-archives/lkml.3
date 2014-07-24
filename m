Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934239AbaGXRzI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 13:55:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63901 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752666AbaGXRzE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 13:55:04 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Lenny Szubowicz <lszubowi@redhat.com>, linux-pm@vger.kernel.org
Subject: [PATCH] cpufreq, store_scaling_governor requires policy->rwsem to be held for duration of changing governors
Date: Thu, 24 Jul 2014 13:54:51 -0400
Message-Id: <1406224491-3599-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A while ago we added a test to mimic some of our users' userspace governor
programs which monitor system behaviour and will switch governors on the
fly.  The decision process for this includes looking at time of day,
expected system load, etc.  For some time now we have had reports of
system panics in the cpufreq code when using the userspace governor
utility.

The userspace utility writes
/sys/devices/system/cpu/cpuX/cpufreq/scaling_governor and sets the
governor.  In some cases this can happen rapidly, and under heavy load
there are occasions where the changes are delayed.  This can mean that
several governor changes may occur within a short period of time.

This has exposed a bug in the store_scaling_governor path.  When the sysfs
file is written to,

store()
	->down_write(&policy->rwsem);
	->store_scaling_governor()
		-> cpufreq_set_policy()
			up_write(&policy->rwsem);
			__cpufreq_governor(policy, CPUFREQ_GOV_POLICY_EXIT);
			down_write(&policy->rwsem);

The release of the policy->rwsem results in a situation where another
write to the scaling_governor file can now start and overwrite pointers
and cause corruption.

ex)

 Oops: 0000 [#1] SMP
 Modules linked in: sg e1000e igb iTCO_wdt iTCO_vendor_support coretemp kvm_intel ptp kvm pps_core i7300_edac edac_core ses lpc_ich enclosure ioatdma mfd_core shpchp dca i2c_i801 serio_raw acpi_cpufreq pcspkr mperf nfsd auth_rpcgss nfs_acl lockd sunrpc xfs libcrc32c sr_mod cdrom sd_mod ata_generic crc_t10dif crct10dif_common pata_acpi radeon i2c_algo_bit drm_kms_helper ttm drm ata_piix libata i2c_core megaraid_sas dm_mirror dm_region_hash dm_log dm_mod
 CPU: 7 PID: 565 Comm: kworker/7:2 Not tainted 3.10.0-121.el7.x86_64 #1
 Hardware name: Intel MP Server/S7000FC4UR, BIOS SFC4UR.86B.01.00.0031.021820102042 02/18/2010
 Workqueue: events od_dbs_timer
 task: ffff88046544cfa0 ti: ffff880465438000 task.ti: ffff880465438000
 RIP: 0010:[<ffffffff81489bed>]  [<ffffffff81489bed>] od_dbs_timer+0x2d/0x160
 RSP: 0018:ffff880465439de0  EFLAGS: 00010282
 RAX: ffff88007f03d500 RBX: 0000000000010de0 RCX: 0000000000000006
 RDX: 0000000000000006 RSI: 7040000000000000 RDI: ffff88046f2f0e08
 e1000e 0000:06:00.0: irq 79 for MSI/MSI-X
 IPv6: ADDRCONF(NETDEV_UP): enp6s0f0: link is not ready
 RBP: ffff880465439e18 R08: ffff88046f2f0e10 R09: dfedcb48370f0e08
 R10: dfedcb48370f0e08 R11: 0000000000000000 R12: ffff880465a69200
 R13: 0000000000000000 R14: ffff88046f2f0e08 R15: 00000000000001c0
 e1000e 0000:06:00.1: irq 80 for MSI/MSI-X
 FS:  0000000000000000(0000) GS:ffff88046f2e0000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
 CR2: 0000000000000010 CR3: 0000000466be5000 CR4: 00000000000007e0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
 Stack:
  ffff88045ef8d140 ffff880468e1ad80 ffff88046f2f0e08 ffff880465a69200
  ffff88046f2f3e00 ffff88046f2f7f00 00000000000001c0 ffff880465439e60
  ffffffff8107e02b 000000006f2f3e18 0000000000000000 ffff88046f2f3e18
 Call Trace:
  [<ffffffff8107e02b>] process_one_work+0x17b/0x460
  [<ffffffff8107edfb>] worker_thread+0x11b/0x400
  [<ffffffff8107ece0>] ? rescuer_thread+0x400/0x400
  [<ffffffff81085aef>] kthread+0xcf/0xe0
  [<ffffffff81085a20>] ? kthread_create_on_node+0x140/0x140
 e1000e 0000:06:00.1: irq 80 for MSI/MSI-X
 IPv6: ADDRCONF(NETDEV_UP): enp6s0f1: link is not ready
  [<ffffffff815fc76c>] ret_from_fork+0x7c/0xb0
  [<ffffffff81085a20>] ? kthread_create_on_node+0x140/0x140
 Code: 66 66 90 55 48 89 e5 41 57 41 56 49 89 fe 41 55 41 54 53 48 c7 c3 e0 0d 01 00 48 83 ec 10 48 8b 47 f8 8b 50 14 4c 8b 68 40 89 d1 <4d> 8b 7d 10 89 55 cc 48 03 1c cd 80 78 9e 81 48 8d 83 a8 00 00
 RIP  [<ffffffff81489bed>] od_dbs_timer+0x2d/0x160
  RSP <ffff880465439de0>
 CR2: 0000000000000010
 BUG: unable to handle kernel  ---[ end trace c9a1ca82e01a4294 ]---
 Kernel panic - not syncing: Fatal exception
NULL pointer dereference at 0000000000000014
 IP: [<ffffffff81489be4>] od_dbs_timer+0x24/0x160
 PGD 46661d067 PUD 465540067 PMD 0
 Oops: 0000 [#2] SMP
 Modules linked in: sg e1000e igb iTCO_wdt iTCO_vendor_support coretemp kvm_intel ptp kvm pps_core i7300_edac edac_core ses lpc_ich enclosure ioatdma mfd_core shpchp dca i2c_i801 serio_raw acpi_cpufreq pcspkr mperf nfsd auth_rpcgss nfs_acl lockd sunrpc xfs libcrc32c sr_mod cdrom sd_mod ata_generic crc_t10dif crct10dif_common pata_acpi radeon i2c_algo_bit drm_kms_helper ttm drm ata_piix libata i2c_core megaraid_sas dm_mirror dm_region_hash dm_log dm_mod
 CPU: 6 PID: 506 Comm: kworker/6:2 Tainted: G      D     --------------   3.10.0-121.el7.x86_64 #1
 Hardware name: Intel MP Server/S7000FC4UR, BIOS SFC4UR.86B.01.00.0031.021820102042 02/18/2010
 Workqueue: events od_dbs_timer
 task: ffff880465448b60 ti: ffff880463730000 task.ti: ffff880463730000
 RIP: 0010:[<ffffffff81489be4>]  [<ffffffff81489be4>] od_dbs_timer+0x24/0x160
 RSP: 0018:ffff880463731de0  EFLAGS: 00010282
 RAX: 0000000000000000 RBX: 0000000000010de0 RCX: dead000000200200
 RDX: 0000000000000001 RSI: 7040000000000000 RDI: ffff88046f2d0e08
 RBP: ffff880463731e18 R08: ffff88046f2d0e10 R09: dfedcb50370d0e08
 R10: dfedcb50370d0e08 R11: 0000000000000000 R12: ffff880465bd2b80
 R13: ffff88046f2d3e00 R14: ffff88046f2d0e08 R15: 0000000000000180
 FS:  0000000000000000(0000) GS:ffff88046f2c0000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
 CR2: 0000000000000014 CR3: 0000000466be5000 CR4: 00000000000007e0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
 Stack:
  ffff88045ef8d140 ffff880468dcf1c0 ffff88046f2d0e08 ffff880465bd2b80
  ffff88046f2d3e00 ffff88046f2d7f00 0000000000000180 ffff880463731e60
  ffffffff8107e02b 000000006f2d3e18 0000000000000000 ffff88046f2d3e18
 Call Trace:
  [<ffffffff8107e02b>] process_one_work+0x17b/0x460
  [<ffffffff8107edfb>] worker_thread+0x11b/0x400
  [<ffffffff8107ece0>] ? rescuer_thread+0x400/0x400
  [<ffffffff81085aef>] kthread+0xcf/0xe0
  [<ffffffff81085a20>] ? kthread_create_on_node+0x140/0x140
  [<ffffffff815fc76c>] ret_from_fork+0x7c/0xb0
  [<ffffffff81085a20>] ? kthread_create_on_node+0x140/0x140
 Code: 1f 84 00 00 00 00 00 66 66 66 66 90 55 48 89 e5 41 57 41 56 49 89 fe 41 55 41 54 53 48 c7 c3 e0 0d 01 00 48 83 ec 10 48 8b 47 f8 <8b> 50 14 4c 8b 68 40 89 d1 4d 8b 7d 10 89 55 cc 48 03 1c cd 80
 RIP  [<ffffffff81489be4>] od_dbs_timer+0x24/0x160
  RSP <ffff880463731de0>
 CR2: 0000000000000014
 drm_kms_helper: panic occurred, switching back to text console

There are other panics associated with this, including list corruption and
various flavors of panics in the od_dbs_timer & work code.

As a test I introduced a separate mutex around the cpufreq_set_policy() call.
After doing so system behaves as expected, and the panics no longer happen.
I narrowed the mutex down to the "governor switch" code in
cpufreq_set_policy() and saw that everything stabilized.

I then reverted commit 955ef4833574636819cd269cfbae12f79cbde63a, cpufreq: Drop
rwsem lock around CPUFREQ_GOV_POLICY_EXIT, which added the dropping of the
policy->rwsem and again, the panics no longer occurred.

The closer I looked at commit 955ef483, the more questions I have.  The first
thing is that it appears that the stacktrace includes function calls that
are not, and never have been, part of the linux.git tree, ie) the call trace
shows

            [<c0055a79>] lock_acquire+0x61/0xbc
            [<c00fabf1>] sysfs_addrm_finish+0xc1/0x128
            [<c00f9819>] sysfs_hash_and_remove+0x35/0x64
            [<c00fbe6f>] remove_files.isra.0+0x1b/0x24
            [<c00fbea5>] sysfs_remove_group+0x2d/0xa8
            [<c02f9a0b>] cpufreq_governor_interactive+0x13b/0x35c
            [<c02f61df>] __cpufreq_governor+0x2b/0x8c
            [<c02f6579>] __cpufreq_set_policy+0xa9/0xf8
            [<c02f6b75>] store_scaling_governor+0x61/0x100
            [<c02f6f4d>] store+0x39/0x60
            [<c00f9b81>] sysfs_write_file+0xed/0x114
            [<c00b3fd1>] vfs_write+0x65/0xd8
            [<c00b424b>] sys_write+0x2f/0x50
            [<c000cdc1>] ret_fast_syscall+0x1/0x52

and the top part of the stack from cpufreq_governor_interactive() appear to
be for a driver that is not in the linux.git tree.  Google search does show
that it exists in various android trees, however, my concern is that the "core"
scaling governors are now broken because of an out tree driver.

It seems like the patch fixed this problem incorrectly by breaking the existing
locking.  IIUC the whole point of the policy->rwsem is to single thread updates
to the policy struct; this is no longer the case after that commit as we
are breaking the locking right in the middle of a policy->governor update.
The fix should have been to the cpufreq_governor_interactive out-of-tree
driver to determine why the driver is acquiring the policy->rwsem.  In any
case, AFAICT, the latest version of the out-of-tree
cpufreq_governor_interactive does not attempt to acquire the policy->rwsem
anymore.

In case anyone is interested in reproducing, the reproducer I used was

i=0
while [ True ]; do
        i=$((i+1))
        echo "ondemand" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor &
        echo "performance" > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor &
        echo "ondemand" > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor  &
        echo "performance" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor &
        if [ $((i % 100)) = 0 ]; then
                num_ps=$(ps aux | grep doit | wc -l)
                echo "$i running, $num_ps outstanding"
        fi
done

and the system usually panics within 500 iterations.

This patch effectively reverts commit 955ef483.

Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Lenny Szubowicz <lszubowi@redhat.com>
Cc: linux-pm@vger.kernel.org
Signed-off-by: Prarit Bhargava <prarit@redhat.com>
---
 drivers/cpufreq/cpufreq.c |    8 +-------
 include/linux/cpufreq.h   |    4 ----
 2 files changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 6f02485..4869f0e 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -2198,12 +2198,8 @@ static int cpufreq_set_policy(struct cpufreq_policy *policy,
 	/* save old, working values */
 	old_gov = policy->governor;
 	/* end old governor */
-	if (old_gov) {
-		__cpufreq_governor(policy, CPUFREQ_GOV_STOP);
-		up_write(&policy->rwsem);
+	if (old_gov)
 		__cpufreq_governor(policy, CPUFREQ_GOV_POLICY_EXIT);
-		down_write(&policy->rwsem);
-	}
 
 	/* start new governor */
 	policy->governor = new_policy->governor;
@@ -2211,9 +2207,7 @@ static int cpufreq_set_policy(struct cpufreq_policy *policy,
 		if (!__cpufreq_governor(policy, CPUFREQ_GOV_START))
 			goto out;
 
-		up_write(&policy->rwsem);
 		__cpufreq_governor(policy, CPUFREQ_GOV_POLICY_EXIT);
-		down_write(&policy->rwsem);
 	}
 
 	/* new governor failed, so re-start old one */
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 8f8ae95..b450c43 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -100,10 +100,6 @@ struct cpufreq_policy {
 	 * - Any routine that will write to the policy structure and/or may take away
 	 *   the policy altogether (eg. CPU hotplug), will hold this lock in write
 	 *   mode before doing so.
-	 *
-	 * Additional rules:
-	 * - Lock should not be held across
-	 *     __cpufreq_governor(data, CPUFREQ_GOV_POLICY_EXIT);
 	 */
 	struct rw_semaphore	rwsem;
 
-- 
1.7.9.3

