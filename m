Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751628Ab3L0FfT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 00:35:19 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:37356 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761Ab3L0FfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 00:35:17 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <52BD117C.2080206@jp.fujitsu.com>
Date: Fri, 27 Dec 2013 14:34:52 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Toshi Kani <toshi.kani@hp.com>,
        Yinghai Lu <yinghai@kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH 1/2][Untested] ACPI / hotplug: Add demand_offline hotplug
 profile flag
References: <1421028.Rsfpmhnym3@vostro.rjw.lan> <52BB9E0C.8020102@jp.fujitsu.com> <52BBAC36.3060705@jp.fujitsu.com> <4207104.v8BDjft7nT@vostro.rjw.lan> <52BD0DC1.2000909@jp.fujitsu.com>
In-Reply-To: <52BD0DC1.2000909@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/12/27 14:18), Yasuaki Ishimatsu wrote:
> (2013/12/27 9:58), Rafael J. Wysocki wrote:
>> On Thursday, December 26, 2013 01:10:30 PM Yasuaki Ishimatsu wrote:
>>> (2013/12/26 12:10), Yasuaki Ishimatsu wrote:
>>>> (2013/12/23 23:00), Rafael J. Wysocki wrote:
>>>>> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>>>>>
>>>>> Add a new ACPI hotplug profile flag, demand_offline, such that if
>>>>> set for the given ACPI device object's scan handler, it will cause
>>>>> acpi_scan_hot_remove() to check if that device object's physical
>>>>> companions are offline upfront and fail the hot removal if that
>>>>> is not the case.
>>>>>
>>>>> That flag will be useful to overcome a problem with containers on
>>>>> some system where they can only be hot-removed after some cleanup
>>>>> operations carried out by user space, which needs to be notified
>>>>> of the container hot-removal before the kernel attempts to offline
>>>>> devices in the container.  In those cases the current implementation
>>>>> of acpi_scan_hot_remove() is not sufficient, because it first tries
>>>>> to offline the devices in the container and only if that is
>>>>> suffcessful it tries to offline the container itself.  As a result,
>>>>> the container hot-removal notification is not delivered to user space
>>>>> at the right time.
>>>>>
>>>>> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>>>>> ---
>>>>>    drivers/acpi/scan.c     |   41 +++++++++++++++++++++++++++++++++++++----
>>>>>    include/acpi/acpi_bus.h |    3 ++-
>>>>>    2 files changed, 39 insertions(+), 5 deletions(-)
>>>>>
>>>>> Index: linux-pm/drivers/acpi/scan.c
>>>>> ===================================================================
>>>>> --- linux-pm.orig/drivers/acpi/scan.c
>>>>> +++ linux-pm/drivers/acpi/scan.c
>>>>> @@ -126,6 +126,24 @@ acpi_device_modalias_show(struct device
>>>>>    }
>>>>>    static DEVICE_ATTR(modalias, 0444, acpi_device_modalias_show, NULL);
>>>>>
>>>>> +static bool acpi_scan_is_offline(struct acpi_device *adev)
>>>>> +{
>>>>> +    struct acpi_device_physical_node *pn;
>>>>> +    bool offline = true;
>>>>> +
>>>>> +    mutex_lock(&adev->physical_node_lock);
>>>>> +
>>>>> +    list_for_each_entry(pn, &adev->physical_node_list, node)
>>>>
>>>>> +        if (!pn->dev->offline) {
>>>>
>>>
>>>> Please check pn->dev->bus and pn->dev->bus->offline too as follow:
>>>>
>>>>           if (pn->dev->bus && pn->dev->bus->offline &&
>>>>               !pn->dev->offline) {
>>>>
>>>
>>> Adding above check, I could remove container device by using eject sysfs.
>>> But following messages were shown:
>>
>> Well, it looks like I have overlooked that error during my testing.
>>
>>> [ 1017.543000] ------------[ cut here ]------------
>>> [ 1017.543000] WARNING: CPU: 0 PID: 6 at drivers/base/core.c:251 device_release+0x92/0xa0()
>>> [ 1017.543000] Device 'ACPI0004:01' does not have a release() function, it is broken and must be fixed.
>>> [ 1017.653000] Modules linked in: xt_CHECKSUM nf_conntrack_netbios_ns nf_conntrack_broadcast ipt_MASQUERADE ip6t_REJECT ipmi_devintf ipt_REJECT cfg80211 xt_conntrack rfkill ebtable_nat ebtable_broute bridge stp llc ebtable_filter ebtables ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6
>>> ip6table_mangle ip6table_security ip6table_raw ip6table_filter ip6_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw iptable_filter sg ip_tables vfat fat x86_pkg_temp_thermal coretemp iTCO_wdt iTCO_vendor_support kvm_intel
>>> kvm crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel lrw gf128mul glue_helper ablk_helper cryptd dm_mirror dm_region_hash dm_log dm_mod microcode lpc_ich igb sb_edac e1000e pcspkr i2c_i801
>>> [ 1017.653000]  edac_core mfd_core dca ptp pps_core shpchp ipmi_si ipmi_msghandler tpm_infineon nfsd auth_rpcgss nfs_acl lockd sunrpc xfs libcrc32c sd_mod mgag200 syscopyarea sysfillrect sysimgblt lpfc i2c_algo_bit drm_kms_helper ttm drm crc_t10dif crct10dif_common scsi_transport_fc megaraid_sas
>>> i2c_core scsi_tgt
>>> [ 1017.653000] CPU: 0 PID: 6 Comm: kworker/u512:0 Tainted: G        W    3.13.0-rc5+ #5
>>> [ 1017.653000] Hardware name:
>>> [ 1017.653000] Workqueue: kacpi_hotplug acpi_hotplug_work_fn
>>> [ 1017.653000]  0000000000000009 ffff880873a6dc68 ffffffff815d85ca ffff880873a6dcb0
>>> [ 1017.653000]  ffff880873a6dca0 ffffffff8106594d ffff8a07d221c010 ffff8a07d221c000
>>> [ 1017.653000]  ffff8808715472c0 ffff880871e91018 0000000000000103 ffff880873a6dd00
>>> [ 1017.653000] Call Trace:
>>> [ 1017.653000]  [<ffffffff815d85ca>] dump_stack+0x45/0x56
>>> [ 1017.653000]  [<ffffffff8106594d>] warn_slowpath_common+0x7d/0xa0
>>> [ 1017.653000]  [<ffffffff810659bc>] warn_slowpath_fmt+0x4c/0x50
>>> [ 1017.653000]  [<ffffffff813ad892>] device_release+0x92/0xa0
>>> [ 1017.653000]  [<ffffffff812b7197>] kobject_cleanup+0x77/0x1b0
>>> [ 1017.653000]  [<ffffffff812b7045>] kobject_put+0x35/0x70
>>> [ 1017.653000]  [<ffffffff813ae38c>] device_unregister+0x2c/0x60
>>> [ 1017.653000]  [<ffffffff8134c87c>] container_device_detach+0x28/0x2a
>>> [ 1017.653000]  [<ffffffff81323096>] acpi_bus_trim+0x56/0x89
>>> [ 1017.653000]  [<ffffffff813246ae>] acpi_device_hotplug+0x168/0x383
>>> [ 1017.653000]  [<ffffffff8131efba>] acpi_hotplug_work_fn+0x1c/0x27
>>> [ 1017.653000]  [<ffffffff81080f1b>] process_one_work+0x17b/0x460
>>> [ 1017.653000]  [<ffffffff81081ccb>] worker_thread+0x11b/0x400
>>> [ 1017.653000]  [<ffffffff81081bb0>] ? rescuer_thread+0x3e0/0x3e0
>>> [ 1017.653000]  [<ffffffff81088a12>] kthread+0xd2/0xf0
>>> [ 1017.653000]  [<ffffffff81088940>] ? kthread_create_on_node+0x180/0x180
>>> [ 1017.653000]  [<ffffffff815e82fc>] ret_from_fork+0x7c/0xb0
>>> [ 1017.653000]  [<ffffffff81088940>] ? kthread_create_on_node+0x180/0x180
>>> [ 1017.653000] ---[ end trace 41394323eb4b690a ]---
>>
>> Below is an updated version of patch [2/2] that should fix this problem (and
>> the other one with the PCI host bridge not supporting offline too).
>
> By updated patch, I can offline the container device and the above messages
> disappeared.
>
> BTW, when I hot remove PCI root bridge, following messages were shown:
>
> ...
> [  116.758000] ------------[ cut here ]------------
> [  116.758000] WARNING: CPU: 0 PID: 6 at fs/sysfs/group.c:214 sysfs_remove_group+0xc6/0xd0()
> [  116.758000] sysfs group ffffffff819ac5c0 not found for kobject '0001:ff:10.2'
> [  116.758000] Modules linked in: xt_CHECKSUM nf_conntrack_netbios_ns nf_conntrack_broadcast ipt_MASQUERADE ip6t_REJECT ipmi_devintf ipt_REJECT xt_conntrack cfg80211 rfkill ebtable_nat ebtable_broute bridge stp llc ebtable_filter ebtables ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6
> ip6table_mangle ip6table_security ip6table_raw ip6table_filter ip6_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw iptable_filter ip_tables sg vfat fat x86_pkg_temp_thermal coretemp kvm_intel kvm crct10dif_pclmul
> crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel lrw gf128mul glue_helper ablk_helper cryptd dm_mirror dm_region_hash e1000e dm_log dm_mod iTCO_wdt iTCO_vendor_support microcode sb_edac igb pcspkr edac_core i2c_i801
> [  116.758000]  ptp lpc_ich pps_core dca mfd_core shpchp ipmi_si tpm_infineon ipmi_msghandler nfsd auth_rpcgss nfs_acl lockd sunrpc xfs libcrc32c sd_mod mgag200 syscopyarea sysfillrect sysimgblt i2c_algo_bit drm_kms_helper lpfc ttm drm crc_t10dif crct10dif_common scsi_transport_fc megaraid_sas
> i2c_core scsi_tgt
> [  116.758000] CPU: 0 PID: 6 Comm: kworker/u512:0 Tainted: G        W    3.13.0-rc5+ #11
> [  116.758000] Hardware name:
> [  116.758000] Workqueue: kacpi_hotplug acpi_hotplug_work_fn
> [  116.758000]  0000000000000009 ffff8808738d3bd8 ffffffff815d84ea ffff8808738d3c20
> [  116.758000]  ffff8808738d3c10 ffffffff8106594d 0000000000000000 ffffffff819ac5c0
> [  116.758000]  ffff880871b9d0a8 ffff8a07d1895000 0000000000000103 ffff8808738d3c70
> [  116.758000] Call Trace:
> [  116.758000]  [<ffffffff815d84ea>] dump_stack+0x45/0x56
> [  116.758000]  [<ffffffff8106594d>] warn_slowpath_common+0x7d/0xa0
> [  116.758000]  [<ffffffff810659bc>] warn_slowpath_fmt+0x4c/0x50
> [  116.758000]  [<ffffffff8122b52e>] ? sysfs_get_dirent_ns+0x4e/0x70
> [  116.758000]  [<ffffffff8122c806>] sysfs_remove_group+0xc6/0xd0
> [  116.758000]  [<ffffffff813b83f3>] dpm_sysfs_remove+0x43/0x50
> [  116.758000]  [<ffffffff813ae105>] device_del+0x45/0x1c0
> [  116.758000]  [<ffffffff812e51f6>] pci_remove_bus_device+0x66/0xd0
> [  116.758000]  [<ffffffff812e5363>] pci_remove_root_bus+0x73/0x80
> [  116.758000]  [<ffffffff813276ab>] acpi_pci_root_remove+0x42/0x4f
> [  116.758000]  [<ffffffff81323070>] acpi_bus_trim+0x56/0x89
> [  116.758000]  [<ffffffff81323052>] acpi_bus_trim+0x38/0x89
> [  116.758000]  [<ffffffff813245df>] acpi_device_hotplug+0x137/0x33b
> [  116.758000]  [<ffffffff8131efba>] acpi_hotplug_work_fn+0x1c/0x27
> [  116.758000]  [<ffffffff81080f1b>] process_one_work+0x17b/0x460
> [  116.758000]  [<ffffffff81081ccb>] worker_thread+0x11b/0x400
> [  116.758000]  [<ffffffff81081bb0>] ? rescuer_thread+0x3e0/0x3e0
> [  116.758000]  [<ffffffff81088a12>] kthread+0xd2/0xf0
> [  116.758000]  [<ffffffff81088940>] ? kthread_create_on_node+0x180/0x180
> [  116.758000]  [<ffffffff815e823c>] ret_from_fork+0x7c/0xb0
> [  116.758000]  [<ffffffff81088940>] ? kthread_create_on_node+0x180/0x180
> [  116.758000] ---[ end trace b403db9d0ec9fc9e ]---
> ...
>
> It is a know issue? The message are shown when we use latest bleeding-edge.
>
> Thanks,
> Yasuaki Ishimatsu


I'll have new year vacation starting tomorrow. Thus I'll review and test
the updated patch from 6 Jan.

Thanks,
Yasuaki Ishimatsu

>
>
>
>
>> Thanks,
>> Rafael
>>
>>
>> ---
>> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>> Subject: ACPI / hotplug / driver core: Handle containers in a special way
>>
>> ACPI container devices require special hotplug handling, at least
>> on some systems, since generally user space needs to carry out
>> system-specific cleanup before it makes sense to offline devices in
>> the container.  However, the current ACPI hotplug code for containers
>> first attempts to offline devices in the container and only then it
>> notifies user space of the container offline.
>>
>> Moreover, after commit 202317a573b2 (ACPI / scan: Add acpi_device
>> objects for all device nodes in the namespace), ACPI device objects
>> representing containers are present as long as the ACPI namespace
>> nodes corresponding to them are present, which may be forever, even
>> if the container devices are physically detached from the system (the
>> return values of the corresponding _STA methods change in those
>> cases, but generally the namespace nodes themselves are still there).
>> Thus it is useful to introduce entities representing containers that
>> will go away during container hot-unplug.
>>
>> The goal of this change is to address both the above issues.
>>
>> The idea is to create a "companion" container system device for each
>> of the ACPI container device objects during the initial namespace
>> scan or on a hotplug event making the container present.  That system
>> device will be unregistered on container removal.  A new bus type
>> for container devices is added for this purpose, because device
>> offline and online operations need to be defined for them.  The
>> online operation is a trivial function that is always successful
>> and the offline uses a callback pointed to by the container device's
>> offline member.
>>
>> For ACPI containers that callback simply walks the list of ACPI
>> device objects right below the container object (its children) and
>> checks if all of their physical companion devices are offline.  If
>> that's not the case, it returns -EBUSY and the container system
>> devivce cannot be put offline.  Consequently, to put the container
>> system device offline, it is necessary to put all of the physical
>> devices depending on its ACPI companion object offline beforehand.
>>
>> Container system devices created for ACPI container objects are
>> initially online.  They are created by the container ACPI scan
>> handler whose hotplug.demand_offline flag is set.  That causes
>> acpi_scan_hot_remove() to check if the companion container system
>> device is offline before attempting to remove an ACPI container or
>> any devices below it.  If the check fails, a KOBJ_CHANGE uevent is
>> emitted for the container system device in question and user space
>> is expected to offline all devices below the container and the
>> container itself in response to it.  Then, user space can finalize
>> the removal of the container with the help of its ACPI device
>> object's eject attribute in sysfs.
>>
>> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>> ---
>>   drivers/acpi/container.c  |   48 ++++++++++++++++++++++++++++++++++++++++++----
>>   drivers/acpi/internal.h   |    1
>>   drivers/acpi/scan.c       |   10 +++++----
>>   drivers/base/Makefile     |    2 -
>>   drivers/base/base.h       |    1
>>   drivers/base/container.c  |   44 ++++++++++++++++++++++++++++++++++++++++++
>>   drivers/base/init.c       |    1
>>   include/linux/container.h |   25 +++++++++++++++++++++++
>>   8 files changed, 123 insertions(+), 9 deletions(-)
>>
>> Index: linux-pm/include/linux/container.h
>> ===================================================================
>> --- /dev/null
>> +++ linux-pm/include/linux/container.h
>> @@ -0,0 +1,25 @@
>> +/*
>> + * Definitions for container bus type.
>> + *
>> + * Copyright (C) 2013, Intel Corporation
>> + * Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +
>> +#include <linux/device.h>
>> +
>> +/* drivers/base/power/container.c */
>> +extern struct bus_type container_subsys;
>> +
>> +struct container_dev {
>> +    struct device dev;
>> +    int (*offline)(struct container_dev *cdev);
>> +};
>> +
>> +static inline struct container_dev *to_container_dev(struct device *dev)
>> +{
>> +    return container_of(dev, struct container_dev, dev);
>> +}
>> Index: linux-pm/drivers/base/container.c
>> ===================================================================
>> --- /dev/null
>> +++ linux-pm/drivers/base/container.c
>> @@ -0,0 +1,44 @@
>> +/*
>> + * System bus type for containers.
>> + *
>> + * Copyright (C) 2013, Intel Corporation
>> + * Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +
>> +#include <linux/container.h>
>> +
>> +#include "base.h"
>> +
>> +#define CONTAINER_BUS_NAME    "container"
>> +
>> +static int trivial_online(struct device *dev)
>> +{
>> +    return 0;
>> +}
>> +
>> +static int container_offline(struct device *dev)
>> +{
>> +    struct container_dev *cdev = to_container_dev(dev);
>> +
>> +    return cdev->offline ? cdev->offline(cdev) : 0;
>> +}
>> +
>> +struct bus_type container_subsys = {
>> +    .name = CONTAINER_BUS_NAME,
>> +    .dev_name = CONTAINER_BUS_NAME,
>> +    .online = trivial_online,
>> +    .offline = container_offline,
>> +};
>> +
>> +void __init container_dev_init(void)
>> +{
>> +    int ret;
>> +
>> +    ret = subsys_system_register(&container_subsys, NULL);
>> +    if (ret)
>> +        pr_err("%s() failed: %d\n", __func__, ret);
>> +}
>> Index: linux-pm/drivers/base/base.h
>> ===================================================================
>> --- linux-pm.orig/drivers/base/base.h
>> +++ linux-pm/drivers/base/base.h
>> @@ -100,6 +100,7 @@ static inline int hypervisor_init(void)
>>   #endif
>>   extern int platform_bus_init(void);
>>   extern void cpu_dev_init(void);
>> +extern void container_dev_init(void);
>>
>>   struct kobject *virtual_device_parent(struct device *dev);
>>
>> Index: linux-pm/drivers/base/init.c
>> ===================================================================
>> --- linux-pm.orig/drivers/base/init.c
>> +++ linux-pm/drivers/base/init.c
>> @@ -33,4 +33,5 @@ void __init driver_init(void)
>>       platform_bus_init();
>>       cpu_dev_init();
>>       memory_dev_init();
>> +    container_dev_init();
>>   }
>> Index: linux-pm/drivers/base/Makefile
>> ===================================================================
>> --- linux-pm.orig/drivers/base/Makefile
>> +++ linux-pm/drivers/base/Makefile
>> @@ -4,7 +4,7 @@ obj-y            := core.o bus.o dd.o syscore.o \
>>                  driver.o class.o platform.o \
>>                  cpu.o firmware.o init.o map.o devres.o \
>>                  attribute_container.o transport_class.o \
>> -               topology.o
>> +               topology.o container.o
>>   obj-$(CONFIG_DEVTMPFS)    += devtmpfs.o
>>   obj-$(CONFIG_DMA_CMA) += dma-contiguous.o
>>   obj-y            += power/
>> Index: linux-pm/drivers/acpi/internal.h
>> ===================================================================
>> --- linux-pm.orig/drivers/acpi/internal.h
>> +++ linux-pm/drivers/acpi/internal.h
>> @@ -73,6 +73,7 @@ static inline void acpi_lpss_init(void)
>>   #endif
>>
>>   bool acpi_queue_hotplug_work(struct work_struct *work);
>> +bool acpi_scan_is_offline(struct acpi_device *adev, bool uevent);
>>
>>   /* --------------------------------------------------------------------------
>>                        Device Node Initialization / Removal
>> Index: linux-pm/drivers/acpi/scan.c
>> ===================================================================
>> --- linux-pm.orig/drivers/acpi/scan.c
>> +++ linux-pm/drivers/acpi/scan.c
>> @@ -126,7 +126,7 @@ acpi_device_modalias_show(struct device
>>   }
>>   static DEVICE_ATTR(modalias, 0444, acpi_device_modalias_show, NULL);
>>
>> -static bool acpi_scan_is_offline(struct acpi_device *adev)
>> +bool acpi_scan_is_offline(struct acpi_device *adev, bool uevent)
>>   {
>>       struct acpi_device_physical_node *pn;
>>       bool offline = true;
>> @@ -134,8 +134,10 @@ static bool acpi_scan_is_offline(struct
>>       mutex_lock(&adev->physical_node_lock);
>>
>>       list_for_each_entry(pn, &adev->physical_node_list, node)
>> -        if (!pn->dev->offline) {
>> -            kobject_uevent(&pn->dev->kobj, KOBJ_CHANGE);
>> +        if (device_supports_offline(pn->dev) && !pn->dev->offline) {
>> +            if (uevent)
>> +                kobject_uevent(&pn->dev->kobj, KOBJ_CHANGE);
>> +
>>               offline = false;
>>               break;
>>           }
>> @@ -267,7 +269,7 @@ static int acpi_scan_hot_remove(struct a
>>       acpi_status status;
>>
>>       if (device->handler->hotplug.demand_offline && !acpi_force_hot_remove) {
>> -        if (!acpi_scan_is_offline(device))
>> +        if (!acpi_scan_is_offline(device, true))
>>               return -EBUSY;
>>       } else {
>>           int error = acpi_scan_try_to_offline(device);
>> Index: linux-pm/drivers/acpi/container.c
>> ===================================================================
>> --- linux-pm.orig/drivers/acpi/container.c
>> +++ linux-pm/drivers/acpi/container.c
>> @@ -27,8 +27,7 @@
>>    * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>    */
>>   #include <linux/acpi.h>
>> -
>> -#include "internal.h"
>> +#include <linux/container.h>
>>
>>   #include "internal.h"
>>
>> @@ -44,16 +43,56 @@ static const struct acpi_device_id conta
>>       {"", 0},
>>   };
>>
>> +static int acpi_container_offline(struct container_dev *cdev)
>> +{
>> +    struct acpi_device *adev = ACPI_COMPANION(&cdev->dev);
>> +    struct acpi_device *child;
>> +
>> +    /* Check all of the dependent devices' physical companions. */
>> +    list_for_each_entry(child, &adev->children, node)
>> +        if (!acpi_scan_is_offline(child, false))
>> +            return -EBUSY;
>> +
>> +    return 0;
>> +}
>> +
>> +static void acpi_container_release(struct device *dev)
>> +{
>> +    kfree(to_container_dev(dev));
>> +}
>> +
>>   static int container_device_attach(struct acpi_device *adev,
>>                      const struct acpi_device_id *not_used)
>>   {
>> -    kobject_uevent(&adev->dev.kobj, KOBJ_ONLINE);
>> +    struct container_dev *cdev;
>> +    struct device *dev;
>> +    int ret;
>> +
>> +    cdev = kzalloc(sizeof(*cdev), GFP_KERNEL);
>> +    if (!cdev)
>> +        return -ENOMEM;
>> +
>> +    cdev->offline = acpi_container_offline;
>> +    dev = &cdev->dev;
>> +    dev->bus = &container_subsys;
>> +    dev_set_name(dev, "%s", dev_name(&adev->dev));
>> +    ACPI_COMPANION_SET(dev, adev);
>> +    dev->release = acpi_container_release;
>> +    ret = device_register(dev);
>> +    if (ret)
>> +        return ret;
>> +
>> +    adev->driver_data = dev;
>>       return 1;
>>   }
>>
>>   static void container_device_detach(struct acpi_device *adev)
>>   {
>> -    kobject_uevent(&adev->dev.kobj, KOBJ_OFFLINE);
>> +    struct device *dev = acpi_driver_data(adev);
>> +
>> +    adev->driver_data = NULL;
>> +    if (dev)
>> +        device_unregister(dev);
>>   }
>>
>>   static struct acpi_scan_handler container_handler = {
>> @@ -62,6 +101,7 @@ static struct acpi_scan_handler containe
>>       .detach = container_device_detach,
>>       .hotplug = {
>>           .enabled = true,
>> +        .demand_offline = true,
>>       },
>>   };
>>
>>
>


