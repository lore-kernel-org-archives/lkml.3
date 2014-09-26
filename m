Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585AbaIZF1q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 01:27:46 -0400
Received: from mga01.intel.com ([192.55.52.88]:12982 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752718AbaIZF1p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 01:27:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,603,1406617200"; 
   d="scan'208";a="480122296"
Message-ID: <5424F851.1020809@intel.com>
Date: Fri, 26 Sep 2014 13:23:29 +0800
From: Lan Tianyu <tianyu.lan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: lenb@kernel.org, mika.westerberg@linux.intel.com, wsa@the-dreams.de,
        robert.moore@intel.com, lv.zheng@intel.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: Re: [RFC PATCH] ACPI: Add _DEP(Operation Region Dependencies) support
 to fix battery issue on the Asus T100TA
References: <1411456003-29541-1-git-send-email-tianyu.lan@intel.com> <5595235.8OhLbSk3cf@vostro.rjw.lan> <5423E40B.8010302@intel.com> <2232717.X50lT6IYgQ@vostro.rjw.lan>
In-Reply-To: <2232717.X50lT6IYgQ@vostro.rjw.lan>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014年09月26日 03:27, Rafael J. Wysocki wrote:
> I'm not sure what you mean.  "Dependent" means "depending on something", so the
> question reads "This requires the devices with _DEP to have a list of devices
> that depend on them" which is probably not what you meant.
> 

Sorry, I didn't say clearly. The "dependent device" I meant is device
pointed to by _DEP(the master you mentioned at the bottom). I thought
master also needed a list to find its slave(device with _DEP).

> For each device with _DEP we have dep_devices, so if you pass a pointer
> (opregion_adev) to the device that has just installed an operation region
> handler to acpi_walk_dep_device_list() as an argument, then you can do
> 
> 	for (i = 0; i < adev->dep_devices.count; i++)
> 		if (opregion_adev->handle == adev->dep_devices.handles[i]) {
> 			adev->dep_unmet = false;
> 			acpi_bus_attach(adev);
> 			list_del(&dep->node);
> 			kfree(dep);
> 		}
> 
> and of course appropriate locking needs to be there in case this races with
> enumeration during hotplug after loading a new ACPI table on demand).
> 

Yes, we can scan all devices on the list and match the opregion_adev
with adev->dep_devices. This is comparatively simple solution.

> I think you can even define
>   
> struct acpi_dep_data {
> 	struct list_head node;
> 	struct acpi_device *master;
> 	struct acpi_device *slave;
> };
> 
> and create that for every valid pair of master (device pointed to by _DEP)/slave
> (device with _DEP) and create a list of these.  Then, you won't need dep_devices
> in struct acpi_device any more and your acpi_walk_dep_device_list() will only
> need to walk the list until it finds the matching master/slave pair.

One question is that when create struct acpi_dep_data for the dependency
relationship between master and slave. If do this when slave's ACPI
device is created during ACPI namespace scan, master's ACPI device maybe
not created at that point. So acpi_handle maybe more suitable than
struct acpi_device here.

> 
> That will handle the case when one device depends on multiple other devices too
> I think.
> 
>>>> > >> +		dep_adev = acpi_bus_get_acpi_device(
>>>> > >> +				adev->dep_devices.handles[i]);
>> > 


-- 
Best regards
Tianyu Lan
