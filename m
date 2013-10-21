Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751803Ab3JUS4I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 14:56:08 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:33573 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab3JUS4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 14:56:06 -0400
Date: Mon, 21 Oct 2013 21:54:09 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Toshi Kani <toshi.kani@hp.com>, Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [LOCKDEP] cpu_add_remove_lock/console_lock possible circular locking
 dependency detected
Message-ID: <20131021185409.GA2408@swordfish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

during systemctl suspend:

[ 3261.011172] ======================================================
[ 3261.011173] [ INFO: possible circular locking dependency detected ]
[ 3261.011176] 3.12.0-rc6-dbg-00003-g0df651a-dirty #1981 Not tainted
[ 3261.011177] -------------------------------------------------------
[ 3261.011179] systemd-sleep/9549 is trying to acquire lock:
[ 3261.011194]  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff8104ddd4>] disable_nonboot_cpus+0x24/0x130
[ 3261.011195] 
but task is already holding lock:
[ 3261.011202]  (console_lock){+.+.+.}, at: [<ffffffff810a5006>] suspend_console+0x26/0x40
[ 3261.011203] 
which lock already depends on the new lock.

[ 3261.011204] 
the existing dependency chain (in reverse order) is:
[ 3261.011208] 
-> #2 (console_lock){+.+.+.}:
[ 3261.011213]        [<ffffffff810bd264>] lock_acquire+0xa4/0x200
[ 3261.011216]        [<ffffffff810a3857>] console_lock+0x77/0x80
[ 3261.011219]        [<ffffffff810a5681>] console_cpu_notify+0x31/0x40
[ 3261.011225]        [<ffffffff8107ddfd>] notifier_call_chain+0x5d/0x110
[ 3261.011228]        [<ffffffff8107debe>] __raw_notifier_call_chain+0xe/0x10
[ 3261.011231]        [<ffffffff8104d823>] cpu_notify+0x23/0x50
[ 3261.011235]        [<ffffffff8104d85e>] cpu_notify_nofail+0xe/0x20
[ 3261.011241]        [<ffffffff8161cd5d>] _cpu_down+0x1ad/0x330
[ 3261.011244]        [<ffffffff8161cf16>] cpu_down+0x36/0x50
[ 3261.011252]        [<ffffffff814ce38d>] cpu_subsys_offline+0x1d/0x30
[ 3261.011255]        [<ffffffff814c97c5>] device_offline+0x95/0xc0
[ 3261.011258]        [<ffffffff814c98c0>] online_store+0x40/0x90
[ 3261.011264]        [<ffffffff814c6e48>] dev_attr_store+0x18/0x30
[ 3261.011270]        [<ffffffff811f0bcb>] sysfs_write_file+0xdb/0x150
[ 3261.011274]        [<ffffffff81173d6d>] vfs_write+0xbd/0x1e0
[ 3261.011277]        [<ffffffff811747cc>] SyS_write+0x4c/0xa0
[ 3261.011284]        [<ffffffff81630156>] tracesys+0xd4/0xd9
[ 3261.011287] 
-> #1 (cpu_hotplug.lock){+.+.+.}:
[ 3261.011290]        [<ffffffff810bd264>] lock_acquire+0xa4/0x200
[ 3261.011293]        [<ffffffff81628887>] mutex_lock_nested+0x67/0x570
[ 3261.011297]        [<ffffffff8104d8db>] cpu_hotplug_begin+0x2b/0x60
[ 3261.011300]        [<ffffffff8104d93e>] _cpu_up+0x2e/0x180
[ 3261.011303]        [<ffffffff8104dae9>] cpu_up+0x59/0x80
[ 3261.011309]        [<ffffffff81cf6e97>] smp_init+0x66/0x97
[ 3261.011314]        [<ffffffff81cdbf1e>] kernel_init_freeable+0x84/0x196
[ 3261.011317]        [<ffffffff8161c0ee>] kernel_init+0xe/0x180
[ 3261.011321]        [<ffffffff8162fefc>] ret_from_fork+0x7c/0xb0
[ 3261.011325] 
-> #0 (cpu_add_remove_lock){+.+.+.}:
[ 3261.011328]        [<ffffffff810bc370>] __lock_acquire+0x19d0/0x1f40
[ 3261.011331]        [<ffffffff810bd264>] lock_acquire+0xa4/0x200
[ 3261.011334]        [<ffffffff81628887>] mutex_lock_nested+0x67/0x570
[ 3261.011337]        [<ffffffff8104ddd4>] disable_nonboot_cpus+0x24/0x130
[ 3261.011342]        [<ffffffff8109b575>] suspend_devices_and_enter+0x1d5/0x660
[ 3261.011346]        [<ffffffff8109bbd2>] pm_suspend+0x1d2/0x240
[ 3261.011349]        [<ffffffff8109a5b9>] state_store+0x79/0xf0
[ 3261.011356]        [<ffffffff8131c44f>] kobj_attr_store+0xf/0x20
[ 3261.011360]        [<ffffffff811f0bcb>] sysfs_write_file+0xdb/0x150
[ 3261.011362]        [<ffffffff81173d6d>] vfs_write+0xbd/0x1e0
[ 3261.011365]        [<ffffffff811747cc>] SyS_write+0x4c/0xa0
[ 3261.011368]        [<ffffffff81630156>] tracesys+0xd4/0xd9
[ 3261.011369] 
other info that might help us debug this:

[ 3261.011374] Chain exists of:
  cpu_add_remove_lock --> cpu_hotplug.lock --> console_lock

[ 3261.011375]  Possible unsafe locking scenario:

[ 3261.011376]        CPU0                    CPU1
[ 3261.011377]        ----                    ----
[ 3261.011379]   lock(console_lock);
[ 3261.011381]                                lock(cpu_hotplug.lock);
[ 3261.011384]                                lock(console_lock);
[ 3261.011386]   lock(cpu_add_remove_lock);
[ 3261.011387] 
 *** DEADLOCK ***

[ 3261.011388] 6 locks held by systemd-sleep/9549:
[ 3261.011395]  #0:  (sb_writers#6){.+.+.+}, at: [<ffffffff81173e6b>] vfs_write+0x1bb/0x1e0
[ 3261.011402]  #1:  (&buffer->mutex){+.+.+.}, at: [<ffffffff811f0b2c>] sysfs_write_file+0x3c/0x150
[ 3261.011409]  #2:  (s_active#111){.+.+.+}, at: [<ffffffff811f0bb3>] sysfs_write_file+0xc3/0x150
[ 3261.011415]  #3:  (pm_mutex){+.+.+.}, at: [<ffffffff8109ba32>] pm_suspend+0x32/0x240
[ 3261.011423]  #4:  (acpi_scan_lock){+.+.+.}, at: [<ffffffff8136bd19>] acpi_scan_lock_acquire+0x17/0x19
[ 3261.011429]  #5:  (console_lock){+.+.+.}, at: [<ffffffff810a5006>] suspend_console+0x26/0x40
[ 3261.011430] 
stack backtrace:
[ 3261.011433] CPU: 0 PID: 9549 Comm: systemd-sleep Not tainted 3.12.0-rc6-dbg-00003-g0df651a-dirty #1981
[ 3261.011435] Hardware name: Acer             Aspire 5741G    /Aspire 5741G    , BIOS V1.20 02/08/2011
[ 3261.011440]  ffffffff821f3c60 ffff880148cd7bc8 ffffffff816250a0 ffffffff821f29d0
[ 3261.011444]  ffff880148cd7c08 ffffffff81621c06 ffff880093c18ff0 ffff880093c19748
[ 3261.011448]  42606a03548d23a1 ffff880093c19720 ffff880093c18ff0 ffff880093c19748
[ 3261.011450] Call Trace:
[ 3261.011454]  [<ffffffff816250a0>] dump_stack+0x4e/0x82
[ 3261.011459]  [<ffffffff81621c06>] print_circular_bug+0x2b4/0x31d
[ 3261.011462]  [<ffffffff810bc370>] __lock_acquire+0x19d0/0x1f40
[ 3261.011467]  [<ffffffff81054e8c>] ? walk_system_ram_range+0x5c/0x140
[ 3261.011471]  [<ffffffff810bd264>] lock_acquire+0xa4/0x200
[ 3261.011475]  [<ffffffff8104ddd4>] ? disable_nonboot_cpus+0x24/0x130
[ 3261.011478]  [<ffffffff8104ddd4>] ? disable_nonboot_cpus+0x24/0x130
[ 3261.011481]  [<ffffffff81628887>] mutex_lock_nested+0x67/0x570
[ 3261.011485]  [<ffffffff8104ddd4>] ? disable_nonboot_cpus+0x24/0x130
[ 3261.011488]  [<ffffffff8162b67e>] ? mutex_unlock+0xe/0x10
[ 3261.011493]  [<ffffffff81367dff>] ? acpi_os_get_iomem+0x4c/0x54
[ 3261.011497]  [<ffffffff8104ddd4>] disable_nonboot_cpus+0x24/0x130
[ 3261.011501]  [<ffffffff8109b575>] suspend_devices_and_enter+0x1d5/0x660
[ 3261.011505]  [<ffffffff81621463>] ? printk+0x54/0x56
[ 3261.011508]  [<ffffffff8109bbd2>] pm_suspend+0x1d2/0x240
[ 3261.011512]  [<ffffffff8109a5b9>] state_store+0x79/0xf0
[ 3261.011516]  [<ffffffff8131c44f>] kobj_attr_store+0xf/0x20
[ 3261.011520]  [<ffffffff811f0bcb>] sysfs_write_file+0xdb/0x150
[ 3261.011523]  [<ffffffff81173d6d>] vfs_write+0xbd/0x1e0
[ 3261.011528]  [<ffffffff81193130>] ? fget_light+0x320/0x4b0
[ 3261.011531]  [<ffffffff811747cc>] SyS_write+0x4c/0xa0
[ 3261.011535]  [<ffffffff81630156>] tracesys+0xd4/0xd9
[ 3261.011537] Disabling non-boot CPUs ...
[ 3261.013327] smpboot: CPU 1 is now offline
[ 3261.116887] smpboot: CPU 2 is now offline
[ 3261.220932] smpboot: CPU 3 is now offline


	-ss

