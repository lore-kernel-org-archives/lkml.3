Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760247AbaGRHmH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 03:42:07 -0400
Received: from mga03.intel.com ([143.182.124.21]:7154 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759924AbaGRHmD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 03:42:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,683,1400050800"; 
   d="scan'208";a="458512934"
Message-ID: <53C8CFC7.7080106@intel.com>
Date: Fri, 18 Jul 2014 15:41:59 +0800
From: Aaron Lu <aaron.lu@intel.com>
MIME-Version: 1.0
To: Jiang Liu <jiang.liu@linux.intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        lkp@01.org
Subject: Re: [x86, irq, ACPI] WARNING: CPU: 13 PID: 11079 at fs/proc/generic.c:521
 remove_proc_entry+0x19f/0x1b0()
References: <53c5f18d.gIBZ3dUDwRsg/ulf%fengguang.wu@intel.com> <53C5FD6F.6040907@intel.com> <53C61C2C.2050808@linux.intel.com>
In-Reply-To: <53C61C2C.2050808@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2014 02:31 PM, Jiang Liu wrote:
> Hi Aaron,
> 	Thanks for reporting this issue. Yinghai has already posted
> a patch to fix the issue by disabling freeing of irq in case of system
> shutdown. Please refer to:
> https://lkml.org/lkml/2014/6/26/619
> 
> Or could you please help to try following patch, which USB free irq
> when shutting down USB controller.

Yes, the patch makes the warning gone.

Regards,
Aaron

> --------------------------------------------------------
> diff --git a/drivers/usb/core/hcd-pci.c b/drivers/usb/core/hcd-pci.c
> index 82044b5d6113..efc953119ce2 100644
> --- a/drivers/usb/core/hcd-pci.c
> +++ b/drivers/usb/core/hcd-pci.c
> @@ -380,6 +380,8 @@ void usb_hcd_pci_shutdown(struct pci_dev *dev)
>         if (test_bit(HCD_FLAG_HW_ACCESSIBLE, &hcd->flags) &&
>                         hcd->driver->shutdown) {
>                 hcd->driver->shutdown(hcd);
> +               if (usb_hcd_is_primary_hcd(hcd) && hcd->irq > 0)
> +                       free_irq(hcd->irq, hcd);
>                 pci_disable_device(dev);
>         }
>  }
> ------------------------------------------------------
> Regards!
> Gerry
> 
> On 2014/7/16 12:19, Aaron Lu wrote:
>> FYI, we noticed the below changes on
>>
>> git://internal_merge_and_test_tree devel-athens-arm-201406220544
>> commit 6a38fa0e3c94dfd1394a71a2d47c9c4d47367374 ("x86, irq, ACPI: Release IOAPIC pin when PCI device is disabled")
>>
>> +----------------------------------------------------------+------------+------------+
>> |                                                          | df334bead7 | 6a38fa0e3c |
>> +----------------------------------------------------------+------------+------------+
>> | boot_successes                                           | 25         | 10         |
>> | early-boot-hang                                          | 1          |            |
>> | boot_failures                                            | 0          | 8          |
>> | WARNING:CPU:PID:at_fs/proc/generic.c:remove_proc_entry() | 0          | 8          |
>> | backtrace:SYSC_reboot                                    | 0          | 8          |
>> | backtrace:SyS_reboot                                     | 0          | 8          |
>> +----------------------------------------------------------+------------+------------+
>>
>>
>> kexecing...
>> kexec -l /tmp//kernel/x86_64-rhel/aab037e6194df2251b558935d1ed497678a28a98/vmlinuz-3.16.0-rc5-01780-gaab037e --initrd=/tmp/initrd-10749 --append="user=lkp job=/lkp/scheduled/ivb43/cyclic_netperf-300s-25%-SCTP_STREAM-HEAD-aab037e6194df2251b558935d1ed497678a28a98.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-rhel/aab037e6194df2251b558935d1ed497678a28a98/vmlinuz-3.16.0-rc5-01780-gaab037e kconfig=x86_64-rhel commit=aab037e6194df2251b558935d1ed497678a28a98 initrd=/kernel-tests/initrd/lkp-rootfs.cgz root=/dev/ram0 bm_initrd=/lkp/benchmarks/netperf.cgz modules_initrd=/kernel/x86_64-rhel/aab037e6194df2251b558935d1ed497678a28a98/modules.cgz max_uptime=1500 RESULT_ROOT=/result/ivb43/netperf/300s-25%-SCTP_STREAM/x86_64-rhel/aab037e6194df2251b558935d1ed497678a28a98/0 ip=::::ivb43::dhcp oops=panic earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=10 softlockup_panic=1 nmi_watchdog=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 cons

> ole=
>> tty0 vga=normal"
>> [  337.887999] remove_proc_entry: removing non-empty directory 'irq/20', leaking at least 'ehci_hcd:usb2'
>> [  337.898418] Modules linked in: sctp ipmi_watchdog dm_mod fuse mgag200 syscopyarea sysfillrect snd_pcm sysimgblt ttm snd_timer ahci drm_kms_helper libahci snd sb_edac soundcore libata drm edac_core i2c_i801 pcspkr wmi ipmi_si ipmi_msghandler
>> [  337.922594] CPU: 37 PID: 11079 Comm: kexec Not tainted 3.16.0-rc5-01780-gaab037e #1
>> [  337.931164] Hardware name: Intel Corporation S2600WP/S2600WP, BIOS SE5C600.86B.02.02.0002.122320131210 12/23/2013
>> [  337.942650]  0000000000000009 ffff880ffd1e3b30 ffffffff8182cb42 ffff880ffd1e3b78
>> [  337.950976]  ffff880ffd1e3b68 ffffffff8106d0cd ffff8808108e3a00 0000000000000002
>> [  337.959316]  ffff880ffd1e3c3e ffff880801a60ab0 ffff8808108e3a75 ffff880ffd1e3bc8
>> [  337.967653] Call Trace:
>> [  337.970396]  [<ffffffff8182cb42>] dump_stack+0x4d/0x66
>> [  337.976153]  [<ffffffff8106d0cd>] warn_slowpath_common+0x7d/0xa0
>> [  337.982867]  [<ffffffff8106d13c>] warn_slowpath_fmt+0x4c/0x50
>> [  337.989303]  [<ffffffff81233ccf>] remove_proc_entry+0x19f/0x1b0
>> [  337.995931]  [<ffffffff810d111f>] unregister_irq_proc+0xbf/0xd0
>> [  338.002558]  [<ffffffff810cb031>] free_desc+0x31/0x90
>> [  338.008212]  [<ffffffff810cb0cc>] irq_free_descs+0x3c/0x80
>> [  338.014354]  [<ffffffff810d08b6>] irq_dispose_mapping+0x36/0x50
>> [  338.020983]  [<ffffffff8104b741>] mp_unmap_irq+0x81/0xb0
>> [  338.026932]  [<ffffffff81041ed1>] acpi_unregister_gsi_ioapic+0x31/0x40
>> [  338.034239]  [<ffffffff81041dd7>] acpi_unregister_gsi+0x17/0x20
>> [  338.040869]  [<ffffffff814546a5>] acpi_pci_irq_disable+0x8f/0x98
>> [  338.047594]  [<ffffffff816dbaa0>] pcibios_disable_device+0x20/0x30
>> [  338.054517]  [<ffffffff81411e72>] do_pci_disable_device+0x52/0x60
>> [  338.061338]  [<ffffffff81411ec8>] pci_disable_device+0x48/0xb0
>> [  338.067870]  [<ffffffff8162004f>] usb_hcd_pci_shutdown+0x3f/0x50
>> [  338.074593]  [<ffffffff81413f96>] pci_device_shutdown+0x36/0x70
>> [  338.081222]  [<ffffffff814e2a38>] device_shutdown+0xc8/0x180
>> [  338.087558]  [<ffffffff810966f6>] kernel_restart_prepare+0x36/0x40
>> [  338.094479]  [<ffffffff810f150f>] kernel_kexec+0x15f/0x180
>> [  338.100620]  [<ffffffff81096ae5>] SYSC_reboot+0x215/0x240
>> [  338.106667]  [<ffffffff811de9a4>] ? dentry_free+0x34/0x40
>> [  338.112710]  [<ffffffff811dfa23>] ? __dentry_kill+0x153/0x1e0
>> [  338.119146]  [<ffffffff811dfb55>] ? dput+0xa5/0x180
>> [  338.124608]  [<ffffffff811e8874>] ? mntput+0x24/0x40
>> [  338.130168]  [<ffffffff811cae53>] ? __fput+0x1a3/0x230
>> [  338.135922]  [<ffffffff8108d62c>] ? task_work_run+0xcc/0xe0
>> [  338.142164]  [<ffffffff81013c27>] ? do_notify_resume+0x97/0xb0
>> [  338.148696]  [<ffffffff81096bae>] SyS_reboot+0xe/0x10
>> [  338.154353]  [<ffffffff81835969>] system_call_fastpath+0x16/0x1b
>> [  338.161078] ---[ end trace 658129a0d50846f5 ]---
>> [  338.166362] ------------[ cut here ]------------
>>
>>
>>
>> Disclaimer:
>> Results have been estimated based on internal Intel analysis and are provided
>> for informational purposes only. Any difference in system hardware or software
>> design or configuration may affect actual performance.
>>
>> Thanks,
>> Aaron
>>

