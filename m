Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965852Ab3FUM4m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 08:56:42 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:45428 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965819Ab3FUM4j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 08:56:39 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Alexander E. Patrakov" <patrakov@gmail.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, alexdeucher@gmail.com,
        Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yijing Wang <wangyijing@huawei.com>, linux-acpi@vger.kernel.org,
        Jiang Liu <liuj97@gmail.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [BUGFIX v2 0/4] fix bug 56531, 59501 and 59581
Date: Fri, 21 Jun 2013 15:06:01 +0200
Message-ID: <4575839.Y4p5zUkCOQ@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAN_LGv1fHwGJ1TJNgNxN3r+rPbDiLum0hhRe4dVMaQPB-J-B-A@mail.gmail.com>
References: <1371238081-32260-1-git-send-email-jiang.liu@huawei.com> <CAN_LGv2kZy_8SrKae5YUwHoUM+mf1OgH2HkAEtiC+ojKCFYSeg@mail.gmail.com> <CAN_LGv1fHwGJ1TJNgNxN3r+rPbDiLum0hhRe4dVMaQPB-J-B-A@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, June 21, 2013 10:37:47 AM Alexander E. Patrakov wrote:
> 2013/6/21 Alexander E. Patrakov <patrakov@gmail.com>:
> > The initial dock went OK. The subsequent undock resulted in the blue
> > led on the dock cable turning off quickly, but in PCI devices slowly,
> > one-by-one, disappearing from the bus. Also, there were "acpi_handle
> > corrupt" messages in dmesg. The subsequent dock resulted in no devices
> > added to the bus. So - your patch is not a good replacement for
> > patches 2 and 3 in the original series.
> 
> In this state, echo 1 > /sys/bus/pci/rescan resulted in a kernel BUG,
> see the attached dmesg.

This one is much more interesting than the previous one.

So first of all we have a deadlock related to the
flush_workqueue(kacpi_notify_wq) in acpi_os_wait_events_complete().  I beleve
it is related to the removal of a notify handler in cleanup_bridge().

[  242.063120] INFO: task kworker/0:0:4 blocked for more than 120 seconds.
[  242.063124] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  242.063126] kworker/0:0     D ffff8802540adf40     0     4      2 0x00000000
[  242.063134] Workqueue: kacpi_hotplug _handle_hotplug_event_func
[  242.063136]  ffff8802540d3828 0000000000000046 ffff8802540ae6d8 4ba25e032c97a1cb
[  242.063139]  ffff8802540d3738 ffff8802540d3fd8 ffff8802540d3fd8 0000000000004000
[  242.063142]  ffffffff81c11440 ffff8802540adf40 ffff8802540d3758 ffffffff8109cadb
[  242.063145] Call Trace:
[  242.063150]  [<ffffffff8109cadb>] ? add_lock_to_list.isra.20.constprop.37+0x7b/0xc0
[  242.063152]  [<ffffffff8109fcc5>] ? __lock_acquire+0x1265/0x1ee0
[  242.063156]  [<ffffffff8101020a>] ? save_stack_trace+0x2a/0x50
[  242.063159]  [<ffffffff8165f764>] schedule+0x24/0x70
[  242.063163]  [<ffffffff8165cab5>] schedule_timeout+0x205/0x260
[  242.063165]  [<ffffffff810a1841>] ? mark_held_locks+0x61/0x150
[  242.063169]  [<ffffffff81059deb>] ? flush_workqueue_prep_pwqs+0x6b/0x1b0
[  242.063171]  [<ffffffff816611ab>] ? _raw_spin_unlock_irq+0x2b/0x60
[  242.063174]  [<ffffffff810a1a35>] ? trace_hardirqs_on_caller+0x105/0x1d0
[  242.063176]  [<ffffffff8165ea74>] wait_for_common+0x114/0x170
[  242.063179]  [<ffffffff8165e195>] ? __mutex_unlock_slowpath+0xf5/0x1a0
[  242.063182]  [<ffffffff810742a0>] ? try_to_wake_up+0x310/0x310
[  242.063185]  [<ffffffff8165eae8>] wait_for_completion+0x18/0x20
[  242.063187]  [<ffffffff8105abca>] flush_workqueue+0x1ca/0x6c0
[  242.063190]  [<ffffffff8105aa00>] ? wq_cpumask_show+0x80/0x80
[  242.063193]  [<ffffffff814380a5>] ? dev_vprintk_emit+0x55/0x70
[  242.063196]  [<ffffffff813a0260>] ? handle_hotplug_event_func+0x80/0x80
[  242.063199]  [<ffffffff813bfd67>] acpi_os_wait_events_complete+0x1c/0x1e
[  242.063202]  [<ffffffff813d31e2>] acpi_remove_notify_handler+0x40/0x178
[  242.063204]  [<ffffffff813a0ef8>] acpiphp_remove_slots+0x88/0x200
[  242.063207]  [<ffffffff813a5c15>] acpi_pci_remove_bus+0x15/0x20
[  242.063210]  [<ffffffff815335d9>] pcibios_remove_bus+0x9/0x10
[  242.063215]  [<ffffffff81380881>] pci_remove_bus+0x41/0x60
[  242.063217]  [<ffffffff813808eb>] pci_remove_bus_device+0x4b/0xe0
[  242.063219]  [<ffffffff813808db>] pci_remove_bus_device+0x3b/0xe0
[  242.063222]  [<ffffffff813808db>] pci_remove_bus_device+0x3b/0xe0
[  242.063224]  [<ffffffff813808db>] pci_remove_bus_device+0x3b/0xe0
[  242.063226]  [<ffffffff81380999>] pci_stop_and_remove_bus_device+0x19/0x20
[  242.063229]  [<ffffffff813a1236>] acpiphp_disable_slot+0x86/0x140
[  242.063231]  [<ffffffff813a1622>] _handle_hotplug_event_func+0x102/0x1e0
[  242.063234]  [<ffffffff8105c2c2>] process_one_work+0x1c2/0x560
[  242.063236]  [<ffffffff8105c257>] ? process_one_work+0x157/0x560
[  242.063238]  [<ffffffff8105d1d6>] worker_thread+0x116/0x370
[  242.063241]  [<ffffffff8105d0c0>] ? manage_workers.isra.20+0x2d0/0x2d0
[  242.063243]  [<ffffffff81063a36>] kthread+0xd6/0xe0
[  242.063245]  [<ffffffff816611ab>] ? _raw_spin_unlock_irq+0x2b/0x60
[  242.063248]  [<ffffffff81063960>] ? __init_kthread_worker+0x70/0x70
[  242.063251]  [<ffffffff8166856c>] ret_from_fork+0x7c/0xb0
[  242.063253]  [<ffffffff81063960>] ? __init_kthread_worker+0x70/0x70
[  242.063255] 4 locks held by kworker/0:0/4:
[  242.063256]  #0:  (kacpi_hotplug){.+.+.+}, at: [<ffffffff8105c257>] process_one_work+0x157/0x560
[  242.063262]  #1:  ((&hp_work->work)){+.+.+.}, at: [<ffffffff8105c257>] process_one_work+0x157/0x560
[  242.063266]  #2:  (acpi_scan_lock){+.+.+.}, at: [<ffffffff813c3ac6>] acpi_scan_lock_acquire+0x12/0x14
[  242.063272]  #3:  (&slot->crit_sect){+.+.+.}, at: [<ffffffff813a11d0>] acpiphp_disable_slot+0x20/0x140

And that is the source of the subsequent re-dock failure (the event cannot be
processed due to the workqueue being stuck).  I don't know why this happens at
the moment, but I'm going to figure out.

And the BUG is because we pass a NULL pointer to sysfs_create_bin_file()
somewhere in pci_create_sysfs_dev_files(), but again I don't know why exactly
at the moment.

Let's communicate further in bug #59501.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
