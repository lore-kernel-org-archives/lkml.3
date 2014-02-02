Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126AbaBAX5i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 18:57:38 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:57031 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750879AbaBAX5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 18:57:36 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Aaron Lu <aaron.lu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>
Subject: Re: [Update][PATCH 4/5][RFT] ACPI / hotplug / PCI: Simplify acpi_install_hotplug_notify_handler()
Date: Sun, 02 Feb 2014 01:12 +0100
Message-ID: <2014200.ZMkXkiESpH@vostro.rjw.lan>
User-Agent: KMail/4.11.4 (Linux/3.13.0+; KDE/4.11.4; x86_64; ; )
In-Reply-To: <6782022.RtGDcVFnWK@vostro.rjw.lan>
References: <2217793.001RY6hKlo@vostro.rjw.lan> <20140131170951.GN18029@intel.com> <6782022.RtGDcVFnWK@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, January 31, 2014 06:34:22 PM Rafael J. Wysocki wrote:
> On Friday, January 31, 2014 07:09:51 PM Mika Westerberg wrote:
> > On Fri, Jan 31, 2014 at 05:16:03PM +0100, Rafael J. Wysocki wrote:

[...]

> > 
> > [   64.914639] ACPI: \_SB_.PCI0.RP05: ACPI_NOTIFY_BUS_CHECK event
> > [   64.914640] ACPI: \_SB_.PCI0.RP05: BEFORE mutex_lock()
> > 
> > Then running sysrq-w I get following task as blocked:
> > 
> > [  346.885950] SysRq : Show Blocked State
> > [  346.887733]   task                        PC stack   pid father
> > [  346.889535] kworker/0:0     D ffff880100241ae0  5280     4      2 0x00000000
> > [  346.891355] Workqueue: kacpi_notify acpi_os_execute_deferred
> > [  346.893171]  ffff8801003c7d30 0000000000000046 ffff880100241710 ffffffff81e10460
> > [  346.895011]  ffff8801003c7fd8 00000000000129c0 00000000000129c0 ffff880100241710
> > [  346.896849]  ffffffff81e5db70 ffffffff81e5db74 ffff880100241710 00000000ffffffff
> > [  346.898702] Call Trace:
> > [  346.900518]  [<ffffffff81815bc4>] schedule_preempt_disabled+0x24/0x70
> > [  346.902338]  [<ffffffff818175f2>] __mutex_lock_slowpath+0x132/0x1b0
> > [  346.904164]  [<ffffffff8181768a>] mutex_lock+0x1a/0x2a
> > [  346.905993]  [<ffffffff81324845>] acpi_hotplug_notify_cb+0x70/0x227
> > [  346.907820]  [<ffffffff813384f4>] acpi_ev_notify_dispatch+0x44/0x5c
> > [  346.909637]  [<ffffffff8131fa8d>] acpi_os_execute_deferred+0xf/0x1b
> > [  346.911455]  [<ffffffff8105e12a>] process_one_work+0x17a/0x440
> > [  346.913285]  [<ffffffff8105ed29>] worker_thread+0x119/0x390
> > [  346.915121]  [<ffffffff8105ec10>] ? manage_workers.isra.25+0x2a0/0x2a0
> > [  346.916970]  [<ffffffff81064dad>] kthread+0xcd/0xf0
> > [  346.918809]  [<ffffffff81064ce0>] ? kthread_create_on_node+0x180/0x180
> > [  346.920653]  [<ffffffff8181fefc>] ret_from_fork+0x7c/0xb0
> > [  346.922501]  [<ffffffff81064ce0>] ? kthread_create_on_node+0x180/0x180
> > [  346.924351] kworker/u8:5    D ffff88006ea55860  4696   945      2 0x00000000
> > [  346.926212] Workqueue: kacpi_hotplug acpi_hotplug_work_fn
> > [  346.928074]  ffff88006de49a40 0000000000000046 ffff88006ea55490 ffff880100245490
> > [  346.929978]  ffff88006de49fd8 00000000000129c0 00000000000129c0 ffff88006ea55490
> > [  346.931872]  ffff88006de49ba0 7fffffffffffffff ffff88006de49b98 ffff88006ea55490
> > [  346.933753] Call Trace:
> > [  346.935626]  [<ffffffff81815794>] schedule+0x24/0x70
> > [  346.937516]  [<ffffffff81814a89>] schedule_timeout+0x1a9/0x2a0
> > [  346.939415]  [<ffffffff8107dda8>] ? __wake_up_common+0x58/0x90
> > [  346.941312]  [<ffffffff81816968>] wait_for_completion+0x98/0x100
> > [  346.943222]  [<ffffffff81071b70>] ? wake_up_state+0x10/0x10
> > [  346.945133]  [<ffffffff8105ba25>] flush_workqueue+0x115/0x5a0
> > [  346.947054]  [<ffffffff81309b20>] ? acpi_pci_find_companion+0x40/0x40
> > [  346.948986]  [<ffffffff81309b20>] ? acpi_pci_find_companion+0x40/0x40
> > [  346.950904]  [<ffffffff81320340>] acpi_os_wait_events_complete+0x1c/0x1e
> > [  346.952829]  [<ffffffff8133a387>] acpi_remove_notify_handler+0x78/0x1ef
> > [  346.954748]  [<ffffffff81309b20>] ? acpi_pci_find_companion+0x40/0x40
> > [  346.956669]  [<ffffffff813226df>] acpi_remove_pm_notifier+0x39/0x5c
> > [  346.958592]  [<ffffffff81309ab5>] pci_acpi_cleanup+0x25/0x50
> > [  346.960508]  [<ffffffff8132368c>] acpi_platform_notify_remove+0x44/0x53
> > [  346.962427]  [<ffffffff814426f2>] device_del+0x142/0x1b0
> > [  346.964333]  [<ffffffff812edcfa>] pci_remove_bus_device+0x7a/0x100
> > [  346.966238]  [<ffffffff812edd95>] pci_stop_and_remove_bus_device+0x15/0x20
> > [  346.968140]  [<ffffffff8130639e>] disable_slot+0x4e/0xa0
> > [  346.970030]  [<ffffffff813067b8>] acpiphp_check_bridge.part.10+0xe8/0xf0
> > [  346.971911]  [<ffffffff81306f92>] hotplug_event+0xf2/0x1a0
> > [  346.973776]  [<ffffffff813070a1>] acpiphp_hotplug_event+0x61/0xe0
> > [  346.975630]  [<ffffffff8132634e>] acpi_device_hotplug+0x37c/0x3c2
> > [  346.977471]  [<ffffffff81320359>] acpi_hotplug_work_fn+0x17/0x22
> > [  346.979299]  [<ffffffff8105e12a>] process_one_work+0x17a/0x440
> > [  346.981122]  [<ffffffff8105ed29>] worker_thread+0x119/0x390
> > [  346.982956]  [<ffffffff8105ec10>] ? manage_workers.isra.25+0x2a0/0x2a0
> > [  346.984762]  [<ffffffff81064dad>] kthread+0xcd/0xf0
> > [  346.986581]  [<ffffffff81064ce0>] ? kthread_create_on_node+0x180/0x180
> > [  346.988419]  [<ffffffff8181fefc>] ret_from_fork+0x7c/0xb0
> > [  346.990221]  [<ffffffff81064ce0>] ? kthread_create_on_node+0x180/0x180
> > 
> > I have to leave now but I can continue debugging tomorrow if needed.
> 
> No need for now, I think I know what's happening.  I'll follow up later.

acpi_remove_notify_handler() which is called from acpi_remove_pm_notifier()
executes acpi_os_wait_events_complete() which does flush_workqueue(kacpi_notify_wq)
and all that happens under acpi_scan_lock acquired by acpi_device_hotplug().

Now, acpi_hotplug_notify_cb() runs from kacpi_notify_wq, so effectively
acpi_os_wait_events_complete() waits for it to return, so if it attempts
to acquire acpi_scan_lock, it will deadlock.  Which happens on the NUC.

The good news is that we can use a different lock to eliminate the race
I wanted to deal with using acpi_scan_lock, but that required me to rework
the whole patchset.  I'll send a new version shortly, but I need to update
the ACPIPHP updates it is on top of.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
