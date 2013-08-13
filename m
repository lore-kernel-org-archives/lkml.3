Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238Ab3HMA3J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 20:29:09 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:40247 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756059Ab3HMA3H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 20:29:07 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Toshi Kani <toshi.kani@hp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Tang Chen <tangchen@cn.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        rafael.j.wysocki@intel.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wen Congyang <wency@cn.fujitsu.com>
Subject: [PATCH] driver core / cpu: Check if NUMA node is valid before bringing CPU up
Date: Tue, 13 Aug 2013 02:39:30 +0200
Message-ID: <12747916.Y6ImPYErWR@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.11.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1376338103.10300.336.camel@misato.fc.hp.com>
References: <5200CBBF.1090904@jp.fujitsu.com> <33585791.CVfk6FmZRF@vostro.rjw.lan> <1376338103.10300.336.camel@misato.fc.hp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

There is a potential race condition between cpu_subsys_online()
and either acpi_processor_remove() or remove_memory() that execute
try_offline_node().  Namely, it is possible that cpu_subsys_online()
will run right after the CPUs NUMA node has been put offline and
cpu_to_node() executed by it will return NUMA_NO_NODE (-1).  In
that case the CPU is gone and it doesn't make sense to call cpu_up()
for it, so make cpu_subsys_online() return -ENODEV then.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Acked-by: Toshi Kani <toshi.kani@hp.com>
---

Hi Greg,

Can you please kindly queue up this one for 3.12?

I've added the Toshi's ACK as he said it looked good to him. :-)

Thanks,
Rafael

---
 drivers/base/cpu.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

Index: linux-pm/drivers/base/cpu.c
===================================================================
--- linux-pm.orig/drivers/base/cpu.c
+++ linux-pm/drivers/base/cpu.c
@@ -43,11 +43,14 @@ static int __ref cpu_subsys_online(struc
 	struct cpu *cpu = container_of(dev, struct cpu, dev);
 	int cpuid = dev->id;
 	int from_nid, to_nid;
-	int ret;
+	int ret = -ENODEV;
 
 	cpu_hotplug_driver_lock();
 
 	from_nid = cpu_to_node(cpuid);
+	if (from_nid == NUMA_NO_NODE)
+		goto out;
+
 	ret = cpu_up(cpuid);
 	/*
 	 * When hot adding memory to memoryless node and enabling a cpu
@@ -57,6 +60,7 @@ static int __ref cpu_subsys_online(struc
 	if (from_nid != to_nid)
 		change_cpu_under_node(cpu, from_nid, to_nid);
 
+ out:
 	cpu_hotplug_driver_unlock();
 	return ret;
 }

