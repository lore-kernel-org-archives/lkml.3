Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238Ab3H3AXx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 20:23:53 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:33905 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625Ab3H3AXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 20:23:49 -0400
From: Toshi Kani <toshi.kani@hp.com>
To: rjw@sisk.pl
Cc: mingo@redhat.com, hpa@linux.intel.com, tglx@linutronix.de,
        gregkh@linuxfoundation.org, benh@kernel.crashing.org,
        linux-acpi@vger.kernel.org, x86@kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        nfont@linux.vnet.ibm.com, fenghua.yu@intel.com, bp@suse.de,
        srivatsa.bhat@linux.vnet.ibm.com, isimatu.yasuaki@jp.fujitsu.com,
        Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH v2 1/4] hotplug, x86: Fix online state in cpu0 debug interface
Date: Thu, 29 Aug 2013 18:22:06 -0600
Message-Id: <1377822129-4143-2-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1377822129-4143-1-git-send-email-toshi.kani@hp.com>
References: <1377822129-4143-1-git-send-email-toshi.kani@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

_debug_hotplug_cpu() is a debug interface that puts cpu0 offline during
boot-up when CONFIG_DEBUG_HOTPLUG_CPU0 is set.  After cpu0 is put offline
in this interface, however, /sys/devices/system/cpu/cpu0/online still
shows 1 (online).

This patch fixes _debug_hotplug_cpu() to update dev->offline when CPU
online/offline operation succeeded.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 arch/x86/kernel/topology.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/topology.c b/arch/x86/kernel/topology.c
index 6e60b5f..5823bbd 100644
--- a/arch/x86/kernel/topology.c
+++ b/arch/x86/kernel/topology.c
@@ -72,16 +72,19 @@ int __ref _debug_hotplug_cpu(int cpu, int action)
 		ret = cpu_down(cpu);
 		if (!ret) {
 			pr_info("CPU %u is now offline\n", cpu);
+			dev->offline = true;
 			kobject_uevent(&dev->kobj, KOBJ_OFFLINE);
 		} else
 			pr_debug("Can't offline CPU%d.\n", cpu);
 		break;
 	case 1:
 		ret = cpu_up(cpu);
-		if (!ret)
+		if (!ret) {
+			dev->offline = false;
 			kobject_uevent(&dev->kobj, KOBJ_ONLINE);
-		else
+		} else {
 			pr_debug("Can't online CPU%d.\n", cpu);
+		}
 		break;
 	default:
 		ret = -EINVAL;
