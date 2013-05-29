Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965755Ab3E2SgN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 14:36:13 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:9269 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754206Ab3E2SgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 14:36:02 -0400
Message-ID: <1369852557.16819.54.camel@misato.fc.hp.com>
Subject: Re: possible_cpus broken in linux-next
From: Toshi Kani <toshi.kani@hp.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Date: Wed, 29 May 2013 12:35:57 -0600
In-Reply-To: <51A6367E.1060400@intel.com>
References: <51A6367E.1060400@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-05-29 at 10:10 -0700, Dave Hansen wrote:
> If I boot with: maxcpus=2 possible_cpus=4, I get
> 
> 	# grep . /sys/devices/system/cpu/cpu[0-9]*/online'
> 	/sys/devices/system/cpu/cpu1/online:1
> 	/sys/devices/system/cpu/cpu2/online:1
> 	/sys/devices/system/cpu/cpu3/online:1
> 
> on bad kernels, and this on working ones:
> 
> 	/sys/devices/system/cpu/cpu1/online:1
> 	/sys/devices/system/cpu/cpu2/online:0
> 	/sys/devices/system/cpu/cpu3/online:0
> 
> 
> I also get -EINVAL if I try to re-offline them in this state.  2 and 3
> don't show up in /proc/cpuinfo, so sysfs just looks broken here.  This
> happens in a KVM guest, so it should be dirt-simple for anyone to reproduce.
> 
> I bisected it down to:
> 
> > commit 0902a9044fa5b7a0456ea4daacec2c2b3189ba8c
> > Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > Date:   Fri May 3 00:25:49 2013 +0200
> > 
> >     Driver core: Use generic offline/online for CPU offline/online
> >     
> >     Rework the CPU hotplug code in drivers/base/cpu.c to use the
> >     generic offline/online support introduced previously instead of
> >     its own CPU-specific code.
> >     
> >     For this purpose, modify cpu_subsys to provide offline and online
> >     callbacks for CONFIG_HOTPLUG_CPU set and remove the code handling
> >     the CPU-specific 'online' sysfs attribute.
> >     
> >     This modification is not supposed to change the user-observable
> >     behavior of the kernel (i.e. the 'online' attribute will be present
> >     in exactly the same place in sysfs and should trigger exactly the
> >     same actions as before).
> >     
> >     Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >     Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >     Reviewed-by: Toshi Kani <toshi.kani@hp.com>


Thanks for the report.  The following patch fixes the problem.
-Toshi

====
From: Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH] ACPI: Fix sysfs cpu/online of offlined cpus

As reported by Dave Hansen, sysfs cpu/online shows 1 for
offlined cpus at boot.
https://lkml.org/lkml/2013/5/29/403

Fix this problem by initializing dev.offline with cpu_online()
when registering a cpu.

Reported-by: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Toshi Kani <toshi.kani@hp.com>
---
 drivers/base/cpu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index 130ba0b..b9f0eec 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -281,6 +281,7 @@ int __cpuinit register_cpu(struct cpu *cpu, int num)
 	cpu->dev.bus = &cpu_subsys;
 	cpu->dev.release = cpu_device_release;
 	cpu->dev.offline_disabled = !cpu->hotpluggable;
+	cpu->dev.offline = !cpu_online(num);
 #ifdef CONFIG_ARCH_HAS_CPU_AUTOPROBE
 	cpu->dev.bus->uevent = arch_cpu_uevent;
 #endif
-- 
1.8.1.4



