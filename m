Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755861Ab3HFKHK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 06:07:10 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:39255 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755808Ab3HFKHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 06:07:06 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <5200CAAD.5080102@jp.fujitsu.com>
Date: Tue, 6 Aug 2013 19:06:37 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: <rafael.j.wysocki@intel.com>, <yinghai@kernel.org>, <toshi.kani@hp.com>
CC: <linux-acpi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: acpi_bus_trim does not detach devices in post order
References: <52006888.5030203@jp.fujitsu.com>
In-Reply-To: <52006888.5030203@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/08/06 12:07), Yasuaki Ishimatsu wrote:
> 
> I acked the following commit but I hit a problem by the commit.
> So I report it.
> 
> commit cecdb193c8d91a42d9489d00618cc3dfff92e55a
> Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Date:   Tue Jan 15 13:24:02 2013 +0100
> 
>      ACPI / scan: Change the implementation of acpi_bus_trim()
> 
> Before applying the commit, acpi_bus_trim() detachs devices in post order.
> 
> When I hot add memory devices and processor devices by container device
> in my x86 box, memory devices are added first and processor devices are added
> second. So I expect that processor devices are removed first and memory
> devices are removed second when I remove them. And before applying the
> commit, acpi_bus_trim() did so.
> 
> But after appling the commit, acpi_bus_trim() does not detach devices in
> post order. So when I remove them, memory devices are removed first and
> processor devices are removed second.
> 
> By this, I hit a problem.
> 
> In Linux on x86 arch, NUMA node is depend on memory devices. So new NUMA
> node is created at memory hot adding. Thus when I hot add memory devices and
> processor devices, we must hot add memory device first. Otherwise, processor
> devices are not set to correct NUMA node number.
> 
> And Linux expects that when removing them, processor devices are removed
> first before removing memory devices. But acpi_bus_trim() does not do so.
> By this, NUMA node is not cleared in my x86 box when hot removing memory device
> and processor devices. When removing memory devices, NUMA node is cleared.
> But if there are processor devices related with the NUMA node, NUMA node is
> not be cleared at memory hot removing.
> 
> So when I remove them, NUMA node's sysfs file remained as follows:

I had little mistake. CPU also tries to clear NUMA node.
But current implementation has bug. So I'll fix it.

Thanks,
Yasuaki Ishimatsu

> 
> # ls /sys/devices/system/node/node1/
> compact  cpumap    meminfo   power                   subsystem  vmstat
> cpulist  distance  numastat  scan_unevictable_pages  uevent
> 
> CPU and memory sysfs files are removed correctly. But node1 sysfs file
> remained.
> 
> Thanks,
> Yasuaki Ishimatsu
> 
> 
> 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


