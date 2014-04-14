Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751681AbaDNHrk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 03:47:40 -0400
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:55891 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbaDNHri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 03:47:38 -0400
Message-ID: <1397461649.12943.1.camel@ThinkPad-T5421.cn.ibm.com>
Subject: [RFC PATCH v3] Use kernfs_break_active_protection() for device
 online store callbacks
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, gregkh@linuxfoundation.org,
        rafael.j.wysocki@intel.com, toshi.kani@hp.com
Date: Mon, 14 Apr 2014 15:47:29 +0800
In-Reply-To: <20140411102649.GB26252@mtj.dyndns.org>
References: <1397121514.25199.91.camel@ThinkPad-T5421.cn.ibm.com>
	 <20140410133116.GB25308@htj.dyndns.org>
	 <1397189445.3649.14.camel@ThinkPad-T5421>
	 <20140411102649.GB26252@mtj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14041407-1948-0000-0000-0000087572B0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed following lockdep warning when trying acpi hot-remove cpus:

[84154.204080] ======================================================
[84154.204080] [ INFO: possible circular locking dependency detected ]
[84154.204080] 3.14.0-next-20140408+ #24 Tainted: G        W    
[84154.204080] -------------------------------------------------------
[84154.204080] bash/777 is trying to acquire lock:
[84154.204080]  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff810664a7>]
cpu_maps_update_begin+0x17/0x20
[84154.213203] 
[84154.213203] but task is already holding lock:
[84154.213203]  (s_active#79){++++.+}, at: [<ffffffff81256e14>]
kernfs_fop_write+0xe4/0x190
[84154.213203] 
[84154.213203] which lock already depends on the new lock.
[84154.213203] 
[84154.213203] 
[84154.213203] the existing dependency chain (in reverse order) is:
[84154.213203] 
-> #3 (s_active#79){++++.+}:
[84154.213203]        [<ffffffff810c408b>] lock_acquire+0x9b/0x1d0
[84154.213203]        [<ffffffff812552e0>] __kernfs_remove+0x250/0x310
[84154.213203]        [<ffffffff81256470>] kernfs_remove_by_name_ns
+0x50/0xc0
[84154.213203]        [<ffffffff81257af5>] sysfs_remove_file_ns
+0x15/0x20
[84154.213203]        [<ffffffff813df339>] device_remove_file+0x19/0x20
[84154.213203]        [<ffffffff813dff33>] device_remove_attrs+0x33/0x80
[84154.213203]        [<ffffffff813e00a7>] device_del+0x127/0x1c0
[84154.213203]        [<ffffffff813e0162>] device_unregister+0x22/0x60
[84154.213203]        [<ffffffff813e66de>] unregister_cpu+0x1e/0x40
[84154.213203]        [<ffffffff81009a33>] arch_unregister_cpu+0x23/0x30
[84154.213203]        [<ffffffff8136f619>] acpi_processor_remove
+0x8d/0xb2
[84154.213203]        [<ffffffff8136cfff>] acpi_bus_trim+0x5a/0x8d
[84154.213203]        [<ffffffff8136ec3b>] acpi_device_hotplug
+0x1a8/0x3ec
[84154.213203]        [<ffffffff81369002>] acpi_hotplug_work_fn
+0x1f/0x2b
[84154.213203]        [<ffffffff8108754b>] process_one_work+0x1eb/0x6b0
[84154.213203]        [<ffffffff81087e9b>] worker_thread+0x11b/0x370
[84154.213203]        [<ffffffff81090324>] kthread+0xe4/0x100
[84154.213203]        [<ffffffff815d2f2c>] ret_from_fork+0x7c/0xb0
[84154.213203] 
-> #2 (cpu_hotplug.lock#2){+.+.+.}:
[84154.213203]        [<ffffffff810c408b>] lock_acquire+0x9b/0x1d0
[84154.213203]        [<ffffffff815c7700>] mutex_lock_nested+0x50/0x3c0
[84154.213203]        [<ffffffff810665bf>] cpu_hotplug_begin+0x4f/0x80
[84154.213203]        [<ffffffff8106666f>] _cpu_up+0x3f/0x160
[84154.213203]        [<ffffffff810667f9>] cpu_up+0x69/0x80
[84154.213203]        [<ffffffff81b18f14>] smp_init+0x60/0x8c
[84154.213203]        [<ffffffff81b00fd8>] kernel_init_freeable
+0x126/0x23b
[84154.213203]        [<ffffffff815b4a3e>] kernel_init+0xe/0xf0
[84154.213203]        [<ffffffff815d2f2c>] ret_from_fork+0x7c/0xb0
[84154.213203] 
-> #1 (cpu_hotplug.lock){++++++}:
[84154.213203]        [<ffffffff810c408b>] lock_acquire+0x9b/0x1d0
[84154.213203]        [<ffffffff810665b1>] cpu_hotplug_begin+0x41/0x80
[84154.213203]        [<ffffffff8106666f>] _cpu_up+0x3f/0x160
[84154.213203]        [<ffffffff810667f9>] cpu_up+0x69/0x80
[84154.213203]        [<ffffffff81b18f14>] smp_init+0x60/0x8c
[84154.213203]        [<ffffffff81b00fd8>] kernel_init_freeable
+0x126/0x23b
[84154.213203]        [<ffffffff815b4a3e>] kernel_init+0xe/0xf0
[84154.213203]        [<ffffffff815d2f2c>] ret_from_fork+0x7c/0xb0
[84154.213203] 
-> #0 (cpu_add_remove_lock){+.+.+.}:
[84154.213203]        [<ffffffff810c397a>] __lock_acquire+0x1f2a/0x1f60
[84154.213203]        [<ffffffff810c408b>] lock_acquire+0x9b/0x1d0
[84154.213203]        [<ffffffff815c7700>] mutex_lock_nested+0x50/0x3c0
[84154.213203]        [<ffffffff810664a7>] cpu_maps_update_begin
+0x17/0x20
[84154.213203]        [<ffffffff815b582d>] cpu_down+0x1d/0x50
[84154.213203]        [<ffffffff813e63b4>] cpu_subsys_offline+0x14/0x20
[84154.213203]        [<ffffffff813e145d>] device_offline+0xad/0xd0
[84154.213203]        [<ffffffff813e1562>] online_store+0x42/0x80
[84154.213203]        [<ffffffff813deab8>] dev_attr_store+0x18/0x30
[84154.213203]        [<ffffffff81257bb9>] sysfs_kf_write+0x49/0x60
[84154.213203]        [<ffffffff81256e39>] kernfs_fop_write+0x109/0x190
[84154.213203]        [<ffffffff811d15be>] vfs_write+0xbe/0x1c0
[84154.213203]        [<ffffffff811d1a52>] SyS_write+0x52/0xb0
[84154.213203]        [<ffffffff815d3162>] tracesys+0xd0/0xd5
[84154.213203] 
[84154.213203] other info that might help us debug this:
[84154.213203] 
[84154.213203] Chain exists of:
  cpu_add_remove_lock --> cpu_hotplug.lock#2 --> s_active#79

[84154.213203]  Possible unsafe locking scenario:
[84154.213203] 
[84154.213203]        CPU0                    CPU1
[84154.213203]        ----                    ----
[84154.213203]   lock(s_active#79);
[84154.213203]                                lock(cpu_hotplug.lock#2);
[84154.213203]                                lock(s_active#79);
[84154.213203]   lock(cpu_add_remove_lock);
[84154.213203] 
[84154.213203]  *** DEADLOCK ***
.............

The deadlock itself seems already fixed in commit 5e33bc41. 

As Tejun suggested, to avoid this lockdep warning,
kernfs_break_active_protection() is used before online/offline callbacks
to take the s_active lock out of the dependency chain during
online/offline operations. 

Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
---
 drivers/base/core.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 0dd6528..b313ad7 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -439,6 +439,7 @@ static ssize_t online_store(struct device *dev, struct device_attribute *attr,
 {
 	bool val;
 	int ret;
+	struct kernfs_node *kn;
 
 	ret = strtobool(buf, &val);
 	if (ret < 0)
@@ -448,7 +449,19 @@ static ssize_t online_store(struct device *dev, struct device_attribute *attr,
 	if (ret)
 		return ret;
 
+	kn = kernfs_find_and_get(dev->kobj.sd, attr->attr.name);
+	if (WARN_ON_ONCE(!kn))
+		goto out;
+
+	get_device(dev);
+	kernfs_break_active_protection(kn);
 	ret = val ? device_online(dev) : device_offline(dev);
+	kernfs_unbreak_active_protection(kn);
+	put_device(dev);
+
+	kernfs_put(kn);
+
+out:
 	unlock_device_hotplug();
 	return ret < 0 ? ret : count;
 }



