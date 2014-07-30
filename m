Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932AbaG3MyT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:54:19 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:54370 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753286AbaG3MyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:54:17 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: rafael.j.wysocki@intel.com, Tejun Heo <tj@kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: ACPI/cpu hotplug: possible lockdep
Date: Wed, 30 Jul 2014 15:12:49 +0200
Message-ID: <1956231.f1vFNp0Nyx@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <53D88C5B.4060302@cn.fujitsu.com>
References: <53D88C5B.4060302@cn.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 30, 2014 02:10:35 PM Gu Zheng wrote:
> Hi Rafael,

Hi,

> A lockdep warning occurs when hot removing a cpu via sysfs:
> echo 1 > /sys/bus/acpi/devices/LNXCPU\:02/eject
> The kernel is latest upstream, and the test box is a kvm vm,
> detail info as following.

Well, I have a theory.

Is the splat still reproducible with the patch below applied?

Rafael

---
 kernel/smp.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-pm/kernel/smp.c
===================================================================
--- linux-pm.orig/kernel/smp.c
+++ linux-pm/kernel/smp.c
@@ -542,6 +542,7 @@ void __init smp_init(void)
 
 	idle_threads_init();
 
+	lock_device_hotplug();
 	/* FIXME: This should be done in userspace --RR */
 	for_each_present_cpu(cpu) {
 		if (num_online_cpus() >= setup_max_cpus)
@@ -549,6 +550,7 @@ void __init smp_init(void)
 		if (!cpu_online(cpu))
 			cpu_up(cpu);
 	}
+	unlock_device_hotplug();
 
 	/* Any cleanup work */
 	smp_announce();

