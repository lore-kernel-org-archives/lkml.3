Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759736Ab3E2RKg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 13:10:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:64546 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964845Ab3E2RKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 13:10:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,765,1363158000"; 
   d="scan'208";a="345088670"
Message-ID: <51A6367E.1060400@intel.com>
Date: Wed, 29 May 2013 10:10:22 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Toshi Kani <toshi.kani@hp.com>, LKML <linux-kernel@vger.kernel.org>
Subject: possible_cpus broken in linux-next
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If I boot with: maxcpus=2 possible_cpus=4, I get

	# grep . /sys/devices/system/cpu/cpu[0-9]*/online'
	/sys/devices/system/cpu/cpu1/online:1
	/sys/devices/system/cpu/cpu2/online:1
	/sys/devices/system/cpu/cpu3/online:1

on bad kernels, and this on working ones:

	/sys/devices/system/cpu/cpu1/online:1
	/sys/devices/system/cpu/cpu2/online:0
	/sys/devices/system/cpu/cpu3/online:0


I also get -EINVAL if I try to re-offline them in this state.  2 and 3
don't show up in /proc/cpuinfo, so sysfs just looks broken here.  This
happens in a KVM guest, so it should be dirt-simple for anyone to reproduce.

I bisected it down to:

> commit 0902a9044fa5b7a0456ea4daacec2c2b3189ba8c
> Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Date:   Fri May 3 00:25:49 2013 +0200
> 
>     Driver core: Use generic offline/online for CPU offline/online
>     
>     Rework the CPU hotplug code in drivers/base/cpu.c to use the
>     generic offline/online support introduced previously instead of
>     its own CPU-specific code.
>     
>     For this purpose, modify cpu_subsys to provide offline and online
>     callbacks for CONFIG_HOTPLUG_CPU set and remove the code handling
>     the CPU-specific 'online' sysfs attribute.
>     
>     This modification is not supposed to change the user-observable
>     behavior of the kernel (i.e. the 'online' attribute will be present
>     in exactly the same place in sysfs and should trigger exactly the
>     same actions as before).
>     
>     Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>     Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     Reviewed-by: Toshi Kani <toshi.kani@hp.com>
