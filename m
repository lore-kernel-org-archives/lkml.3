Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452AbaIZN3E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 09:29:04 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:59099 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753782AbaIZN3B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 09:29:01 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: lenb@kernel.org, mika.westerberg@linux.intel.com, wsa@the-dreams.de,
        robert.moore@intel.com, lv.zheng@intel.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: Re: [RFC PATCH] ACPI: Add _DEP(Operation Region Dependencies) support to fix battery issue on the Asus T100TA
Date: Fri, 26 Sep 2014 15:48:51 +0200
Message-ID: <2646100.uUyj9r3K3o@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <5424F851.1020809@intel.com>
References: <1411456003-29541-1-git-send-email-tianyu.lan@intel.com> <2232717.X50lT6IYgQ@vostro.rjw.lan> <5424F851.1020809@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, September 26, 2014 01:23:29 PM Lan Tianyu wrote:
> On 2014年09月26日 03:27, Rafael J. Wysocki wrote:
> > I'm not sure what you mean.  "Dependent" means "depending on something", so the
> > question reads "This requires the devices with _DEP to have a list of devices
> > that depend on them" which is probably not what you meant.
> > 
> 
> Sorry, I didn't say clearly. The "dependent device" I meant is device
> pointed to by _DEP(the master you mentioned at the bottom). I thought
> master also needed a list to find its slave(device with _DEP).
> 
> > For each device with _DEP we have dep_devices, so if you pass a pointer
> > (opregion_adev) to the device that has just installed an operation region
> > handler to acpi_walk_dep_device_list() as an argument, then you can do
> > 
> > 	for (i = 0; i < adev->dep_devices.count; i++)
> > 		if (opregion_adev->handle == adev->dep_devices.handles[i]) {
> > 			adev->dep_unmet = false;
> > 			acpi_bus_attach(adev);
> > 			list_del(&dep->node);
> > 			kfree(dep);
> > 		}
> > 
> > and of course appropriate locking needs to be there in case this races with
> > enumeration during hotplug after loading a new ACPI table on demand).
> > 
> 
> Yes, we can scan all devices on the list and match the opregion_adev
> with adev->dep_devices. This is comparatively simple solution.
> 
> > I think you can even define
> >   
> > struct acpi_dep_data {
> > 	struct list_head node;
> > 	struct acpi_device *master;
> > 	struct acpi_device *slave;
> > };
> > 
> > and create that for every valid pair of master (device pointed to by _DEP)/slave
> > (device with _DEP) and create a list of these.  Then, you won't need dep_devices
> > in struct acpi_device any more and your acpi_walk_dep_device_list() will only
> > need to walk the list until it finds the matching master/slave pair.
> 
> One question is that when create struct acpi_dep_data for the dependency
> relationship between master and slave. If do this when slave's ACPI
> device is created during ACPI namespace scan, master's ACPI device maybe
> not created at that point. So acpi_handle maybe more suitable than
> struct acpi_device here.

Right.  The handle is fine too and should be sufficient.

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
