Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696Ab3LZELZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Dec 2013 23:11:25 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50289 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477Ab3LZELV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Dec 2013 23:11:21 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <52BBAC36.3060705@jp.fujitsu.com>
Date: Thu, 26 Dec 2013 13:10:30 +0900
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
References: <1421028.Rsfpmhnym3@vostro.rjw.lan> <3111545.W6MaeKuZVj@vostro.rjw.lan> <2519855.bi7YQLIAPv@vostro.rjw.lan> <2003756.4bDvk8cJ93@vostro.rjw.lan> <52BB9E0C.8020102@jp.fujitsu.com>
In-Reply-To: <52BB9E0C.8020102@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/12/26 12:10), Yasuaki Ishimatsu wrote:
> (2013/12/23 23:00), Rafael J. Wysocki wrote:
>> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>>
>> Add a new ACPI hotplug profile flag, demand_offline, such that if
>> set for the given ACPI device object's scan handler, it will cause
>> acpi_scan_hot_remove() to check if that device object's physical
>> companions are offline upfront and fail the hot removal if that
>> is not the case.
>>
>> That flag will be useful to overcome a problem with containers on
>> some system where they can only be hot-removed after some cleanup
>> operations carried out by user space, which needs to be notified
>> of the container hot-removal before the kernel attempts to offline
>> devices in the container.  In those cases the current implementation
>> of acpi_scan_hot_remove() is not sufficient, because it first tries
>> to offline the devices in the container and only if that is
>> suffcessful it tries to offline the container itself.  As a result,
>> the container hot-removal notification is not delivered to user space
>> at the right time.
>>
>> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>> ---
>>   drivers/acpi/scan.c     |   41 +++++++++++++++++++++++++++++++++++++----
>>   include/acpi/acpi_bus.h |    3 ++-
>>   2 files changed, 39 insertions(+), 5 deletions(-)
>>
>> Index: linux-pm/drivers/acpi/scan.c
>> ===================================================================
>> --- linux-pm.orig/drivers/acpi/scan.c
>> +++ linux-pm/drivers/acpi/scan.c
>> @@ -126,6 +126,24 @@ acpi_device_modalias_show(struct device
>>   }
>>   static DEVICE_ATTR(modalias, 0444, acpi_device_modalias_show, NULL);
>>
>> +static bool acpi_scan_is_offline(struct acpi_device *adev)
>> +{
>> +    struct acpi_device_physical_node *pn;
>> +    bool offline = true;
>> +
>> +    mutex_lock(&adev->physical_node_lock);
>> +
>> +    list_for_each_entry(pn, &adev->physical_node_list, node)
>
>> +        if (!pn->dev->offline) {
>

> Please check pn->dev->bus and pn->dev->bus->offline too as follow:
>
>          if (pn->dev->bus && pn->dev->bus->offline &&
>              !pn->dev->offline) {
>

Adding above check, I could remove container device by using eject sysfs.
But following messages were shown:

[ 1017.543000] ------------[ cut here ]------------
[ 1017.543000] WARNING: CPU: 0 PID: 6 at drivers/base/core.c:251 device_release+0x92/0xa0()
[ 1017.543000] Device 'ACPI0004:01' does not have a release() function, it is broken and must be fixed.
[ 1017.653000] Modules linked in: xt_CHECKSUM nf_conntrack_netbios_ns nf_conntrack_broadcast ipt_MASQUERADE ip6t_REJECT ipmi_devintf ipt_REJECT cfg80211 xt_conntrack rfkill ebtable_nat ebtable_broute bridge stp llc ebtable_filter ebtables ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 
ip6table_mangle ip6table_security ip6table_raw ip6table_filter ip6_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw iptable_filter sg ip_tables vfat fat x86_pkg_temp_thermal coretemp iTCO_wdt iTCO_vendor_support kvm_intel 
kvm crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel lrw gf128mul glue_helper ablk_helper cryptd dm_mirror dm_region_hash dm_log dm_mod microcode lpc_ich igb sb_edac e1000e pcspkr i2c_i801
[ 1017.653000]  edac_core mfd_core dca ptp pps_core shpchp ipmi_si ipmi_msghandler tpm_infineon nfsd auth_rpcgss nfs_acl lockd sunrpc xfs libcrc32c sd_mod mgag200 syscopyarea sysfillrect sysimgblt lpfc i2c_algo_bit drm_kms_helper ttm drm crc_t10dif crct10dif_common scsi_transport_fc megaraid_sas 
i2c_core scsi_tgt
[ 1017.653000] CPU: 0 PID: 6 Comm: kworker/u512:0 Tainted: G        W    3.13.0-rc5+ #5
[ 1017.653000] Hardware name:
[ 1017.653000] Workqueue: kacpi_hotplug acpi_hotplug_work_fn
[ 1017.653000]  0000000000000009 ffff880873a6dc68 ffffffff815d85ca ffff880873a6dcb0
[ 1017.653000]  ffff880873a6dca0 ffffffff8106594d ffff8a07d221c010 ffff8a07d221c000
[ 1017.653000]  ffff8808715472c0 ffff880871e91018 0000000000000103 ffff880873a6dd00
[ 1017.653000] Call Trace:
[ 1017.653000]  [<ffffffff815d85ca>] dump_stack+0x45/0x56
[ 1017.653000]  [<ffffffff8106594d>] warn_slowpath_common+0x7d/0xa0
[ 1017.653000]  [<ffffffff810659bc>] warn_slowpath_fmt+0x4c/0x50
[ 1017.653000]  [<ffffffff813ad892>] device_release+0x92/0xa0
[ 1017.653000]  [<ffffffff812b7197>] kobject_cleanup+0x77/0x1b0
[ 1017.653000]  [<ffffffff812b7045>] kobject_put+0x35/0x70
[ 1017.653000]  [<ffffffff813ae38c>] device_unregister+0x2c/0x60
[ 1017.653000]  [<ffffffff8134c87c>] container_device_detach+0x28/0x2a
[ 1017.653000]  [<ffffffff81323096>] acpi_bus_trim+0x56/0x89
[ 1017.653000]  [<ffffffff813246ae>] acpi_device_hotplug+0x168/0x383
[ 1017.653000]  [<ffffffff8131efba>] acpi_hotplug_work_fn+0x1c/0x27
[ 1017.653000]  [<ffffffff81080f1b>] process_one_work+0x17b/0x460
[ 1017.653000]  [<ffffffff81081ccb>] worker_thread+0x11b/0x400
[ 1017.653000]  [<ffffffff81081bb0>] ? rescuer_thread+0x3e0/0x3e0
[ 1017.653000]  [<ffffffff81088a12>] kthread+0xd2/0xf0
[ 1017.653000]  [<ffffffff81088940>] ? kthread_create_on_node+0x180/0x180
[ 1017.653000]  [<ffffffff815e82fc>] ret_from_fork+0x7c/0xb0
[ 1017.653000]  [<ffffffff81088940>] ? kthread_create_on_node+0x180/0x180
[ 1017.653000] ---[ end trace 41394323eb4b690a ]---

Thanks,
Yasuaki Ishimatsu

> My container has CPU and Memory and PCI root bridge. PCI root bridge
> does not has offline function (pn->dev->bus->offline). So I cannot offline
> the device and pn->dev->offline of the device is always 0. Therefore,
> following operation always returns -EBUSY even if I offline CPUs and
> all memory sections on a container device.
>
> echo 0 > /sys/bus/container/devices/ACPI0004:01/online
>
> Thanks,
> Yasuaki Ishimatsu
>
>> +            kobject_uevent(&pn->dev->kobj, KOBJ_CHANGE);
>> +            offline = false;
>> +            break;
>> +        }
>> +
>> +    mutex_unlock(&adev->physical_node_lock);
>> +    return offline;
>> +}
>> +
>>   static acpi_status acpi_bus_offline(acpi_handle handle, u32 lvl, void *data,
>>                       void **ret_p)
>>   {
>> @@ -196,12 +214,11 @@ static acpi_status acpi_bus_online(acpi_
>>       return AE_OK;
>>   }
>>
>> -static int acpi_scan_hot_remove(struct acpi_device *device)
>> +static int acpi_scan_try_to_offline(struct acpi_device *device)
>>   {
>>       acpi_handle handle = device->handle;
>> -    struct device *errdev;
>> +    struct device *errdev = NULL;
>>       acpi_status status;
>> -    unsigned long long sta;
>>
>>       /*
>>        * Carry out two passes here and ignore errors in the first pass,
>> @@ -212,7 +229,6 @@ static int acpi_scan_hot_remove(struct a
>>        *
>>        * If the first pass is successful, the second one isn't needed, though.
>>        */
>> -    errdev = NULL;
>>       status = acpi_walk_namespace(ACPI_TYPE_ANY, handle, ACPI_UINT32_MAX,
>>                        NULL, acpi_bus_offline, (void *)false,
>>                        (void **)&errdev);
>> @@ -241,6 +257,23 @@ static int acpi_scan_hot_remove(struct a
>>               return -EBUSY;
>>           }
>>       }
>> +    return 0;
>> +}
>> +
>> +static int acpi_scan_hot_remove(struct acpi_device *device)
>> +{
>> +    acpi_handle handle = device->handle;
>> +    unsigned long long sta;
>> +    acpi_status status;
>> +
>> +    if (device->handler->hotplug.demand_offline && !acpi_force_hot_remove) {
>> +        if (!acpi_scan_is_offline(device))
>> +            return -EBUSY;
>> +    } else {
>> +        int error = acpi_scan_try_to_offline(device);
>> +        if (error)
>> +            return error;
>> +    }
>>
>>       ACPI_DEBUG_PRINT((ACPI_DB_INFO,
>>           "Hot-removing device %s...\n", dev_name(&device->dev)));
>> Index: linux-pm/include/acpi/acpi_bus.h
>> ===================================================================
>> --- linux-pm.orig/include/acpi/acpi_bus.h
>> +++ linux-pm/include/acpi/acpi_bus.h
>> @@ -91,8 +91,9 @@ struct acpi_device;
>>
>>   struct acpi_hotplug_profile {
>>       struct kobject kobj;
>> -    bool enabled:1;
>>       int (*scan_dependent)(struct acpi_device *adev);
>> +    bool enabled:1;
>> +    bool demand_offline:1;
>>   };
>>
>>   static inline struct acpi_hotplug_profile *to_acpi_hotplug_profile(
>>
>


