Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932Ab3JaKSx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 06:18:53 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:45779 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750712Ab3JaKSw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 06:18:52 -0400
X-IronPort-AV: E=Sophos;i="4.93,607,1378828800"; 
   d="scan'208";a="8910357"
Message-ID: <52722D19.7080004@cn.fujitsu.com>
Date: Thu, 31 Oct 2013 18:12:41 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] pci: fix invalid list entry warning for double pci device
 removing via sysfs
References: <5270DBFC.3050705@cn.fujitsu.com> <CAE9FiQXp+9XKbs8ccJVt08icax6SOWioDfL5s+H1SWGi9cTAiw@mail.gmail.com>
In-Reply-To: <CAE9FiQXp+9XKbs8ccJVt08icax6SOWioDfL5s+H1SWGi9cTAiw@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/31 18:16:56,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/31 18:16:57,
	Serialize complete at 2013/10/31 18:16:57
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yinghai,

On 10/31/2013 02:45 PM, Yinghai Lu wrote:

> On Wed, Oct 30, 2013 at 3:14 AM, Gu Zheng <guz.fnst@cn.fujitsu.com> wrote:
>> When concurent removing pci devices which are in the same pci subtree
>> via sysfs, such as:
>> echo -n 1 > /sys/bus/pci/devices/0000\:10\:00.0/remove ; echo -n 1 >
>> /sys/bus/pci/devices/0000\:1a\:01.0/remove
>> (1a:01.0 device is downstream from the 10:00.0 bridge)
>>
>> the following warning will show:
>> [ 1799.280918] ------------[ cut here ]------------
>> [ 1799.336199] WARNING: CPU: 7 PID: 126 at lib/list_debug.c:53 __list_del_entry+0x63/0xd0()
>> [ 1799.433093] list_del corruption, ffff8807b4a7c000->next is LIST_POISON1 (dead000000100100)
>> [ 1799.532110] Modules linked in: nf_conntrack_netbios_ns nf_conntrack_broadcast ipt_MASQUERADE ip6table_mangle ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 iptable_nat nf_nat_ipv4 nf_nat iptable_mangle ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter ip_tables sg dm_mirror dm_region_hash dm_log dm_mod vfat fat e1000e igb iTCO_wdt iTCO_vendor_support ioatdma ptp i7core_edac ipmi_si edac_core lpc_ich pps_core i2c_i801 pcspkr mfd_core dca ipmi_msghandler acpi_cpufreq xfs libcrc32c sd_mod crc_t10dif crct10dif_common i2c_algo_bit drm_kms_helper ttm drm mptsas scsi_transport_sas mptscsih i2c_core megaraid_sas mptbase
>> [ 1800.276623] CPU: 7 PID: 126 Comm: kworker/u512:1 Tainted: G        W    3.12.0-rc5+ #196
>> [ 1800.508918] Workqueue: sysfsd sysfs_schedule_callback_work
>> [ 1800.574703]  0000000000000009 ffff8807adbadbd8 ffffffff8168b26c ffff8807c27d08a8
>> [ 1800.663860]  ffff8807adbadc28 ffff8807adbadc18 ffffffff810711dc ffff8807adbadc68
>> [ 1800.753130]  ffff8807b4a7c000 ffff8807b4a7c000 ffff8807ad089c00 0000000000000000
>> [ 1800.842282] Call Trace:
>> [ 1800.871651]  [<ffffffff8168b26c>] dump_stack+0x55/0x76
>> [ 1800.933301]  [<ffffffff810711dc>] warn_slowpath_common+0x8c/0xc0
>> [ 1801.005283]  [<ffffffff810712c6>] warn_slowpath_fmt+0x46/0x50
>> [ 1801.074081]  [<ffffffff8135a343>] __list_del_entry+0x63/0xd0
>> [ 1801.141839]  [<ffffffff8135a3c1>] list_del+0x11/0x40
>> [ 1801.201320]  [<ffffffff813734da>] pci_remove_bus_device+0x6a/0xe0
>> [ 1801.274279]  [<ffffffff8137356e>] pci_stop_and_remove_bus_device+0x1e/0x30
>> [ 1801.356606]  [<ffffffff8137b20b>] remove_callback+0x2b/0x40
>> [ 1801.423412]  [<ffffffff81251848>] sysfs_schedule_callback_work+0x18/0x60
>> [ 1801.503744]  [<ffffffff8108eab5>] process_one_work+0x1f5/0x540
>> [ 1801.573640]  [<ffffffff8108ea53>] ? process_one_work+0x193/0x540
>> [ 1801.645616]  [<ffffffff8108f2ac>] worker_thread+0x11c/0x370
>> [ 1801.712337]  [<ffffffff8108f190>] ? rescuer_thread+0x350/0x350
>> [ 1801.782178]  [<ffffffff8109731d>] kthread+0xed/0x100
>> [ 1801.841661]  [<ffffffff81097230>] ? kthread_create_on_node+0x160/0x160
>> [ 1801.919919]  [<ffffffff8169cc3c>] ret_from_fork+0x7c/0xb0
>> [ 1801.984608]  [<ffffffff81097230>] ? kthread_create_on_node+0x160/0x160
>> [ 1802.062825] ---[ end trace d77f2054de000fb7 ]---
>>
>> This issue is related to the bug 54411:
>> https://bugzilla.kernel.org/show_bug.cgi?id=54411
>>
>> Since we added the pci_bus reference management, the bug becomes a
>> invalid list entry warning as descripted above. Beacuse it still
>> trys to delete an deleted pci device from device list.
>>
>> So here we make stop device actually detach driver only, and remove
>> device will do device_del instead, and move bus_list change and pci device
>> resource free into pci_release_dev, so that it'll consistent with
>> bus reference managment, and the device only can be deleted from device
>> list in pci_release_dev just for one time.
>>
>> Besides, it also makes hostbridge to use device_unregister to be pair
>> with device_register before.
>>
>> This patch is based on Yinghai's privious similar patch:
>> http://lkml.org/lkml/2013/5/13/658
> 
> I have updated version, please check if attached patches fix the problem.
> 
> virtfn_release.patch
> fix_cx3_hotplug_2.patch
> fix_racing_removing_6_1.patch
> fix_racing_removing_6_2.patch
> fix_racing_removing_6_3.patch

It works well on latest Linus' tree, thanks.

Regards,
Gu 

> 
> Thanks
> 
> Yinghai


