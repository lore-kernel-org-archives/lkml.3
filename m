Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476AbaABRK2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 12:10:28 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40584 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaABRKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 12:10:23 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 89/91] cpuidle: Check for dev before deregistering it.
Date: Thu,  2 Jan 2014 09:05:04 -0800
Message-Id: <1388682306-30859-90-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1388682306-30859-1-git-send-email-kamal@canonical.com>
References: <1388682306-30859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

commit 813e8e3d6aaa0b511126cce15c16a931afffe768 upstream.

If not, we could end up in the unfortunate situation where
we dereference a NULL pointer b/c we have cpuidle disabled.

This is the case when booting under Xen (which uses the
ACPI P/C states but disables the CPU idle driver) - and can
be easily reproduced when booting with cpuidle.off=1.

BUG: unable to handle kernel NULL pointer dereference at           (null)
IP: [<ffffffff8156db4a>] cpuidle_unregister_device+0x2a/0x90
.. snip..
Call Trace:
 [<ffffffff813b15b4>] acpi_processor_power_exit+0x3c/0x5c
 [<ffffffff813af0a9>] acpi_processor_stop+0x61/0xb6
 [<ffffffff814215bf>] __device_release_driver+0fffff81421653>] device_release_driver+0x23/0x30
 [<ffffffff81420ed8>] bus_remove_device+0x108/0x180
 [<ffffffff8141d9d9>] device_del+0x129/0x1c0
 [<ffffffff813cb4b0>] ? unregister_xenbus_watch+0x1f0/0x1f0
 [<ffffffff8141da8e>] device_unregister+0x1e/0x60
 [<ffffffff814243e9>] unregister_cpu+0x39/0x60
 [<ffffffff81019e03>] arch_unregister_cpu+0x23/0x30
 [<ffffffff813c3c51>] handle_vcpu_hotplug_event+0xc1/0xe0
 [<ffffffff813cb4f5>] xenwatch_thread+0x45/0x120
 [<ffffffff810af010>] ? abort_exclusive_wait+0xb0/0xb0
 [<ffffffff8108ec42>] kthread+0xd2/0xf0
 [<ffffffff8108eb70>] ? kthread_create_on_node+0x180/0x180
 [<ffffffff816ce17c>] ret_from_fork+0x7c/0xb0
 [<ffffffff8108eb70>] ? kthread_create_on_node+0x180/0x180

This problem also appears in 3.12 and could be a candidate for backport.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
[ kamal: backport to 3.8 ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/cpuidle/cpuidle.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index e1f6860..7decd90 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -460,11 +460,13 @@ EXPORT_SYMBOL_GPL(cpuidle_register_device);
  */
 void cpuidle_unregister_device(struct cpuidle_device *dev)
 {
-	struct cpuidle_driver *drv = cpuidle_get_cpu_driver(dev);
+	struct cpuidle_driver *drv;
 
-	if (dev->registered == 0)
+	if (!dev || dev->registered == 0)
 		return;
 
+	drv = cpuidle_get_cpu_driver(dev);
+
 	cpuidle_pause_and_lock();
 
 	cpuidle_disable_device(dev);
-- 
1.8.3.2

