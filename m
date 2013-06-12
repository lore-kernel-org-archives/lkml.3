Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970Ab3FLDo7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 23:44:59 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:37394 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994Ab3FLDo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 23:44:57 -0400
MIME-Version: 1.0
In-Reply-To: <51B7E1C7.9030004@gmail.com>
References: <1370951543-15841-1-git-send-email-jiang.liu@huawei.com>
	<CAN_LGv1hrLnYkPHycyyd35ZipWWznXM_0cdj8Rnh1WxiTZL=4A@mail.gmail.com>
	<51B7170E.2060608@gmail.com>
	<CAN_LGv26adLa5RBhwhCfvALFx78j4HdvzVH1PaAuhvWXSeqyMw@mail.gmail.com>
	<51B73BAB.3030406@gmail.com>
	<CAN_LGv3iwgp_8dkt1ouCD-FFGau3h7L25ORUW2J-rz30_4ZYTA@mail.gmail.com>
	<51B7E1C7.9030004@gmail.com>
Date: Wed, 12 Jun 2013 09:44:56 +0600
Message-ID: <CAN_LGv0-gGMhJr8U8=sc-93e_MKVpy9TxG1MRAugtBVJP+CTrg@mail.gmail.com>
Subject: Re: [PATCH] ACPIPHP: fix device destroying order issue in handling
 dock notification
From: "Alexander E. Patrakov" <patrakov@gmail.com>
To: Jiang Liu <liuj97@gmail.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Yinghai Lu <yinghai@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-pci@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/6/12 Jiang Liu <liuj97@gmail.com>:
> On Wed 12 Jun 2013 12:51:59 AM CST, Alexander E. Patrakov wrote:
>> 2013/6/11 Jiang Liu <liuj97@gmail.com>:
>>> Hi Alexander,
>>>     This is much more harder issue to resolve.  Let's first work around
>>> this
>>> issue and check whether other things are OK. The patch below is just a
>>> prove of concept, could you please help to try it?
>>
>> In the initially-undocked case it passes the "dock and undock three
>> times, verify lspci output at each step" test.
>>
>> In the initially-docked case, it exhibits the following problem: when
>> I press the undock button, only one PCI device disappears, and the
>> "docked" LED does not turn off. Additionally, there is a hung task.
> Hi Alexander,
>      In the initially-docked case, the failure is caused by an issue in
> the intel sound card driver. Seems something is wrong with reference
> count management and it never returns to zero on driver detach.
> Could you please help to disable the Intel sound card driver and try
> again?
>
> I'm not familiar with Intel HDA driver,  so please help to fire another
> bug for it.

Thanks for pointing the finger to snd-hda-intel. With that driver
blacklisted, the lspci output matches the expectations even after
undocking the initially-docked laptop. Redocking re-adds the devices,
too. So the situation is almost as good as in the initially-undocked
case, you only have to deal with this:

[   64.312253] ata8.00: disabled
[   64.318462] cdrom: issuing MRW background format suspend
[   64.320288] INFO: trying to register non-static key.
[   64.320292] the code is fine but needs lockdep annotation.
[   64.320294] turning off the locking correctness validator.
[   64.320298] CPU: 0 PID: 40 Comm: kworker/0:1 Tainted: G         C
3.10.0-rc4 #7
[   64.320301] Hardware name: Sony Corporation VPCZ23A4R/VAIO, BIOS
R1013H5 05/21/2012
[   64.320306] Workqueue: kacpi_hotplug acpi_os_execute_deferred
[   64.320309]  ffff880253db0000 ffff880253db9688 ffffffff8165aab8
ffff880253db9778
[   64.320314]  ffffffff810a018e ffff880253db07c0 0000000000000000
ffff880200000000
[   64.320319]  0000000000000000 ffff880200000000 ffff880253db07e0
000000000000005a
[   64.320324] Call Trace:
[   64.320330]  [<ffffffff8165aab8>] dump_stack+0x19/0x1b
[   64.320335]  [<ffffffff810a018e>] __lock_acquire+0x181e/0x1ee0
[   64.320338]  [<ffffffff810a1751>] ? mark_held_locks+0x61/0x150
[   64.320341]  [<ffffffff810a1aae>] ? debug_check_no_locks_freed+0x8e/0x160
[   64.320347]  [<ffffffff8105b940>] ? queue_delayed_work_on+0xa0/0xa0
[   64.320350]  [<ffffffff810a0e77>] lock_acquire+0x87/0x150
[   64.320354]  [<ffffffff8105b940>] ? queue_delayed_work_on+0xa0/0xa0
[   64.320357]  [<ffffffff8109c430>] ? lockdep_init_map+0xb0/0x530
[   64.320361]  [<ffffffff8105b978>] flush_work+0x38/0x270
[   64.320365]  [<ffffffff8105b940>] ? queue_delayed_work_on+0xa0/0xa0
[   64.320368]  [<ffffffff810a1751>] ? mark_held_locks+0x61/0x150
[   64.320371]  [<ffffffff8105d645>] ? __cancel_work_timer+0xa5/0x110
[   64.320375]  [<ffffffff810a1945>] ? trace_hardirqs_on_caller+0x105/0x1d0
[   64.320378]  [<ffffffff8105d61a>] __cancel_work_timer+0x7a/0x110
[   64.320381]  [<ffffffff8105d6cb>] cancel_work_sync+0xb/0x10
[   64.320389]  [<ffffffffa00773ae>] rtl_remove_one+0x5e/0x140 [r8169]
[   64.320394]  [<ffffffff81385631>] pci_device_remove+0x41/0xc0
[   64.320399]  [<ffffffff8143bd47>] __device_release_driver+0x77/0xe0
[   64.320403]  [<ffffffff8143bdd9>] device_release_driver+0x29/0x40
[   64.320407]  [<ffffffff8143b7e1>] bus_remove_device+0xf1/0x140
[   64.320411]  [<ffffffff81438ecd>] device_del+0x11d/0x1b0
[   64.320416]  [<ffffffff8138062c>] pci_stop_bus_device+0x9c/0xb0
[   64.320420]  [<ffffffff813805cb>] pci_stop_bus_device+0x3b/0xb0
[   64.320423]  [<ffffffff813805cb>] pci_stop_bus_device+0x3b/0xb0
[   64.320427]  [<ffffffff813805cb>] pci_stop_bus_device+0x3b/0xb0
[   64.320431]  [<ffffffff813a0fe5>] ? acpiphp_disable_slot+0x35/0x140
[   64.320435]  [<ffffffff813805cb>] pci_stop_bus_device+0x3b/0xb0
[   64.320437]  [<ffffffff813805cb>] pci_stop_bus_device+0x3b/0xb0
[   64.320440]  [<ffffffff813805cb>] pci_stop_bus_device+0x3b/0xb0
[   64.320443]  [<ffffffff81380791>] pci_stop_and_remove_bus_device+0x11/0x20
[   64.320446]  [<ffffffff813a1036>] acpiphp_disable_slot+0x86/0x140
[   64.320450]  [<ffffffff813a13da>] __handle_hotplug_event_func+0xba/0x1a0
[   64.320454]  [<ffffffff813c729b>] hotplug_dock_devices+0x57/0xda
[   64.320458]  [<ffffffff813c79a1>] handle_eject_request+0xaf/0xdf
[   64.320461]  [<ffffffff813c7b6f>] acpi_dock_deferred_cb+0x163/0x1c8
[   64.320465]  [<ffffffff813bfba9>] acpi_os_execute_deferred+0x20/0x2d
[   64.320468]  [<ffffffff8105c212>] process_one_work+0x1c2/0x560
[   64.320472]  [<ffffffff8105c1a7>] ? process_one_work+0x157/0x560
[   64.320475]  [<ffffffff8105d126>] worker_thread+0x116/0x370
[   64.320479]  [<ffffffff8105d010>] ? manage_workers.isra.20+0x2d0/0x2d0
[   64.320483]  [<ffffffff81063986>] kthread+0xd6/0xe0
[   64.320487]  [<ffffffff810638b0>] ? __init_kthread_worker+0x70/0x70
[   64.320492]  [<ffffffff8166806c>] ret_from_fork+0x7c/0xb0
[   64.320496]  [<ffffffff810638b0>] ? __init_kthread_worker+0x70/0x70
[   64.334782] vgaarb: device changed decodes:
PCI:0000:00:02.0,olddecodes=none,decodes=io+mem:owns=none
[   64.337187] pci_bus 0000:0b: busn_res: [bus 0b] is released
[   64.337410] pci_bus 0000:0c: busn_res: [bus 0c] is released
[   64.337472] pci_bus 0000:16: busn_res: [bus 16] is released

As for snd-hda-intel bug, I will file it later today and let you know.

-- 
Alexander E. Patrakov
