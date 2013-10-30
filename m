Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908Ab3J3IAd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 04:00:33 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:12179 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725Ab3J3IAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 04:00:31 -0400
Message-ID: <5270BBD5.2080403@huawei.com>
Date: Wed, 30 Oct 2013 15:57:09 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>
CC: Andreas Noever <andreas.noever@gmail.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [3.11.4] Thunderbolt/PCI unplug oops in pci_pme_list_scan
References: <CAMxnaaUim-MCDpaTiLmBqN3wfxjn9V6XE_n4SMfuO=vqeT6rVA@mail.gmail.com> <CAErSpo4KU9VAC=SnKuYH3EPz8NuozixAhUQBKv+=Y=76wywdTg@mail.gmail.com> <20131015024452.GA31951@srcf.ucam.org> <20131016202123.GA17866@google.com> <CAMxnaaV1DhaxKo6h85Upa8sPQz2jSYSaW1OJ7+JtvR5F9sAYZw@mail.gmail.com> <CAErSpo4q0rcvkHX3_L2rcJrwT-Ofu4My8JXxtxH8gyULLxTDEw@mail.gmail.com> <CAE9FiQUMKSak4tWiyZ-N1_50M5ytUp-JAhb7GTG29Y1aRBPuSQ@mail.gmail.com>
In-Reply-To: <CAE9FiQUMKSak4tWiyZ-N1_50M5ytUp-JAhb7GTG29Y1aRBPuSQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Bisection points to 928bea964827d7824b548c1f8e06eccbbc4d0d7d .
>>
>> This is "PCI: Delay enabling bridges until they're needed" by Yinghai.
> 
> that double disabling should be addressed by:
> 
> https://lkml.org/lkml/2013/4/25/608
> 
> [PATCH] PCI: Remove duplicate pci_disable_device for pcie port

Hi Yinghai and Bjorn,
   I found a related issue in the latest Bjorn/pci-next branch.

Now if we remove the pcie port device in the system, there is a warning occured.
It seems introduced after commit 928bea9 "PCI: Delay enabling bridges until they're needed".

[ 2124.129478] ------------[ cut here ]------------
[ 2124.129490] WARNING: CPU: 3 PID: 7 at drivers/pci/pci.c:1424 pci_disable_device+0x90/0xa0()
[ 2124.129492] Device pcieport
[ 2124.129492] disabling already-disabled device
[ 2124.129494] Modules linked in: binfmt_misc cpufreq_conservative cpufreq_userspace cpufreq_powersave loop bnx2 igb kvm_intel kvm dca i2c_algo_bit ptp pps_core i2c_i801 i7core_edac iTCO_wdt iTCO_vendor_support lpc_ich mfd_core edac_core acpi_cpufreq serio_raw sg button pcspkr microcode autofs4 processor thermal_sys scsi_dh_rdac scsi_dh_alua scsi_dh_emc scsi_dh_hp_sw scsi_dh ata_generic ata_piix megaraid_sas
[ 2124.129530] CPU: 3 PID: 7 Comm: kworker/u49:0 Not tainted 3.12.0-rc2-2.10-desktop+ #22
[ 2124.129533] Hardware name: Huawei Technologies Co., Ltd. Tecal RH2285          /BC11BTSA              , BIOS CTSAV036 04/27/2011
[ 2124.129540] Workqueue: sysfsd sysfs_schedule_callback_work
[ 2124.129543]  0000000000000009 ffff880532cd9bb8 ffffffff8162f51c 0000000000000007
[ 2124.129547]  ffff880532cd9c08 ffff880532cd9bf8 ffffffff8105060c 0000000000000286
[ 2124.129552]  ffff8805329f2000 ffffffff81c67bc0 ffff8805329f2000 0000000000000000
[ 2124.129556] Call Trace:
[ 2124.129564]  [<ffffffff8162f51c>] dump_stack+0x55/0x86
[ 2124.129572]  [<ffffffff8105060c>] warn_slowpath_common+0x8c/0xc0
[ 2124.129576]  [<ffffffff810506f6>] warn_slowpath_fmt+0x46/0x50
[ 2124.129580]  [<ffffffff81345ef0>] pci_disable_device+0x90/0xa0
[ 2124.129587]  [<ffffffff8135524e>] pcie_portdrv_remove+0x1e/0x30
[ 2124.129592]  [<ffffffff813491d6>] pci_device_remove+0x46/0xc0
[ 2124.129598]  [<ffffffff814139cf>] __device_release_driver+0x7f/0xf0
[ 2124.129602]  [<ffffffff81413c5c>] device_release_driver+0x2c/0x40
[ 2124.129606]  [<ffffffff81413368>] bus_remove_device+0x108/0x170
[ 2124.129610]  [<ffffffff814102f0>] device_del+0x130/0x1c0
[ 2124.129614]  [<ffffffff813427dc>] pci_stop_bus_device+0x9c/0xb0
[ 2124.129618]  [<ffffffff81342986>] pci_stop_and_remove_bus_device+0x16/0x30
[ 2124.129622]  [<ffffffff8134a599>] remove_callback+0x29/0x40
[ 2124.129625]  [<ffffffff811fd7d8>] sysfs_schedule_callback_work+0x18/0x80
[ 2124.129632]  [<ffffffff8106bbbd>] process_one_work+0x17d/0x470
[ 2124.129635]  [<ffffffff8106c342>] worker_thread+0x122/0x380
[ 2124.129639]  [<ffffffff8106c220>] ? rescuer_thread+0x330/0x330
[ 2124.129643]  [<ffffffff81073330>] kthread+0xc0/0xd0
[ 2124.129647]  [<ffffffff81073270>] ? kthread_create_on_node+0x130/0x130
[ 2124.129653]  [<ffffffff8163dbec>] ret_from_fork+0x7c/0xb0
[ 2124.129657]  [<ffffffff81073270>] ? kthread_create_on_node+0x130/0x130
[ 2124.129660] ---[ end trace 5b020b35ec6adb4c ]---


> 
> Thanks
> 
> Yinghai
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> .
> 


-- 
Thanks!
Yijing

