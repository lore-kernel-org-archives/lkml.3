Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657Ab3FKPBJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 11:01:09 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:35921 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753803Ab3FKPBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 11:01:07 -0400
Message-ID: <51B73BAB.3030406@gmail.com>
Date: Tue, 11 Jun 2013 23:00:59 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: "Alexander E. Patrakov" <patrakov@gmail.com>
CC: Jiang Liu <jiang.liu@huawei.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Yinghai Lu <yinghai@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-pci@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ACPIPHP: fix device destroying order issue in handling
 dock notification
References: <1370951543-15841-1-git-send-email-jiang.liu@huawei.com> <CAN_LGv1hrLnYkPHycyyd35ZipWWznXM_0cdj8Rnh1WxiTZL=4A@mail.gmail.com> <51B7170E.2060608@gmail.com> <CAN_LGv26adLa5RBhwhCfvALFx78j4HdvzVH1PaAuhvWXSeqyMw@mail.gmail.com>
In-Reply-To: <CAN_LGv26adLa5RBhwhCfvALFx78j4HdvzVH1PaAuhvWXSeqyMw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexander,
    This is much more harder issue to resolve.  Let's first work around 
this
issue and check whether other things are OK. The patch below is just a
prove of concept, could you please help to try it?
Regards!
Gerry

---
diff --git a/drivers/acpi/dock.c b/drivers/acpi/dock.c
index a7ba608..dde1cec 100644
--- a/drivers/acpi/dock.c
+++ b/drivers/acpi/dock.c
@@ -121,9 +121,7 @@ static void
 dock_add_hotplug_device(struct dock_station *ds,
                        struct dock_dependent_device *dd)
 {
-       mutex_lock(&ds->hp_lock);
        list_add_tail(&dd->hotplug_list, &ds->hotplug_devices);
-       mutex_unlock(&ds->hp_lock);
 }

 /**
@@ -137,9 +135,7 @@ static void
 dock_del_hotplug_device(struct dock_station *ds,
                        struct dock_dependent_device *dd)
 {
-       mutex_lock(&ds->hp_lock);
        list_del_init(&dd->hotplug_list);
-       mutex_unlock(&ds->hp_lock);
 }

 /**
---
On Tue 11 Jun 2013 09:38:59 PM CST, Alexander E. Patrakov wrote:
> 2013/6/11 Jiang Liu <liuj97@gmail.com>:
>> Hi Alexander,
>>      Sorry for the deadlock, I have no machine for testing:(
>> Below patch should fix the deadlock issue.
>
> There is another deadlock:
>
> [   34.316382] acpiphp_glue: found ACPI PCI Hotplug slot 1 at PCI 0000:0a:00
> [   34.316557] acpiphp: Slot [1-1] registered
>
> [   34.316569] =============================================
> [   34.316570] [ INFO: possible recursive locking detected ]
> [   34.316573] 3.10.0-rc4 #6 Tainted: G         C
> [   34.316575] ---------------------------------------------
> [   34.316577] kworker/0:0/4 is trying to acquire lock:
> [   34.316579]  (&dock_station->hp_lock){+.+.+.}, at:
> [<ffffffff813c766b>] register_hotplug_dock_device+0x6a/0xbf
> [   34.316588]
> but task is already holding lock:
> [   34.316590]  (&dock_station->hp_lock){+.+.+.}, at:
> [<ffffffff813c7270>] hotplug_dock_devices+0x2c/0xda
> [   34.316595]
> other info that might help us debug this:
> [   34.316597]  Possible unsafe locking scenario:
>
> [   34.316599]        CPU0
> [   34.316601]        ----
> [   34.316602]   lock(&dock_station->hp_lock);
> [   34.316605]   lock(&dock_station->hp_lock);
> [   34.316608]
>  *** DEADLOCK ***
>
> [   34.316611]  May be due to missing lock nesting notation
>
> [   34.316613] 5 locks held by kworker/0:0/4:
> [   34.316615]  #0:  (kacpi_hotplug){.+.+.+}, at: [<ffffffff8105c1a7>]
> process_one_work+0x157/0x560
> [   34.316624]  #1:  ((&dpc->work)#3){+.+.+.}, at:
> [<ffffffff8105c1a7>] process_one_work+0x157/0x560
> [   34.316631]  #2:  (acpi_scan_lock){+.+.+.}, at:
> [<ffffffff813c38fb>] acpi_scan_lock_acquire+0x12/0x14
> [   34.316639]  #3:  (&dock_station->hp_lock){+.+.+.}, at:
> [<ffffffff813c7270>] hotplug_dock_devices+0x2c/0xda
> [   34.316646]  #4:  (&slot->crit_sect){+.+.+.}, at:
> [<ffffffff813a0e8e>] acpiphp_enable_slot+0x1e/0x140
> [   34.316653]
> stack backtrace:
> [   34.316657] CPU: 0 PID: 4 Comm: kworker/0:0 Tainted: G         C
> 3.10.0-rc4 #6
> [   34.316659] Hardware name: Sony Corporation VPCZ23A4R/VAIO, BIOS
> R1013H5 05/21/2012
> [   34.316663] Workqueue: kacpi_hotplug acpi_os_execute_deferred
> [   34.316665]  ffff8802540adf40 ffff8802540d3628 ffffffff8165aaf8
> ffff8802540d3718
> [   34.316670]  ffffffff8109fe92 ffff8802540adf40 ffffffff8261c8a0
> ffff8802540ae700
> [   34.316675]  0000000000000000 ffff8802540d3748 000000000001f180
> ffff8802000000dc
> [   34.316680] Call Trace:
> [   34.316685]  [<ffffffff8165aaf8>] dump_stack+0x19/0x1b
> [   34.316689]  [<ffffffff8109fe92>] __lock_acquire+0x1522/0x1ee0
> [   34.316693]  [<ffffffff810a1751>] ? mark_held_locks+0x61/0x150
> [   34.316697]  [<ffffffff81660cc5>] ? _raw_spin_unlock_irqrestore+0x65/0x80
> [   34.316702]  [<ffffffff813ddfbc>] ? acpi_ns_get_node+0xb2/0xc2
> [   34.316705]  [<ffffffff813c766b>] ? register_hotplug_dock_device+0x6a/0xbf
> [   34.316709]  [<ffffffff810a0e77>] lock_acquire+0x87/0x150
> [   34.316712]  [<ffffffff813c766b>] ? register_hotplug_dock_device+0x6a/0xbf
> [   34.316715]  [<ffffffff813c766b>] ? register_hotplug_dock_device+0x6a/0xbf
> [   34.316720]  [<ffffffff8165d87e>] mutex_lock_nested+0x5e/0x3e0
> [   34.316723]  [<ffffffff813c766b>] ? register_hotplug_dock_device+0x6a/0xbf
> [   34.316726]  [<ffffffff81660c30>] ? _raw_spin_unlock+0x30/0x60
> [   34.316729]  [<ffffffff813c766b>] register_hotplug_dock_device+0x6a/0xbf
> [   34.316733]  [<ffffffff813a0637>] register_slot+0x467/0x5b0
> [   34.316738]  [<ffffffff813de0c8>] acpi_ns_walk_namespace+0xbb/0x17b
> [   34.316741]  [<ffffffff813c06e3>] ? acpi_os_wait_semaphore+0x3f/0x55
> [   34.316744]  [<ffffffff813a01d0>] ? free_bridge+0x100/0x100
> [   34.316748]  [<ffffffff813a01d0>] ? free_bridge+0x100/0x100
> [   34.316752]  [<ffffffff813de846>] acpi_walk_namespace+0x8e/0xc8
> [   34.316755]  [<ffffffff813a0b0d>] acpiphp_enumerate_slots+0x1bd/0x320
> [   34.316760]  [<ffffffff81448836>] ? pm_runtime_init+0x106/0x110
> [   34.316764]  [<ffffffff813a5a0f>] acpi_pci_add_bus+0x2f/0x40
> [   34.316768]  [<ffffffff815332f9>] pcibios_add_bus+0x9/0x10
> [   34.316772]  [<ffffffff81643168>] pci_add_new_bus+0x1c8/0x390
> [   34.316777]  [<ffffffff81380075>] pci_scan_bridge+0x5e5/0x620
> [   34.316781]  [<ffffffff816444e9>] enable_device+0x169/0x450
> [   34.316785]  [<ffffffff813a0f3a>] acpiphp_enable_slot+0xca/0x140
> [   34.316789]  [<ffffffff813a13b6>] __handle_hotplug_event_func+0x96/0x1a0
> [   34.316792]  [<ffffffff813c729b>] hotplug_dock_devices+0x57/0xda
> [   34.316796]  [<ffffffff813c7b06>] acpi_dock_deferred_cb+0xd4/0x1c8
> [   34.316799]  [<ffffffff813bfba9>] acpi_os_execute_deferred+0x20/0x2d
> [   34.316803]  [<ffffffff8105c212>] process_one_work+0x1c2/0x560
> [   34.316807]  [<ffffffff8105c1a7>] ? process_one_work+0x157/0x560
> [   34.316810]  [<ffffffff8105d126>] worker_thread+0x116/0x370
> [   34.316813]  [<ffffffff8105d010>] ? manage_workers.isra.20+0x2d0/0x2d0
> [   34.316818]  [<ffffffff81063986>] kthread+0xd6/0xe0
> [   34.316821]  [<ffffffff81660d0b>] ? _raw_spin_unlock_irq+0x2b/0x60
> [   34.316826]  [<ffffffff810638b0>] ? __init_kthread_worker+0x70/0x70
> [   34.316830]  [<ffffffff816680ac>] ret_from_fork+0x7c/0xb0
> [   34.316834]  [<ffffffff810638b0>] ? __init_kthread_worker+0x70/0x70
>
>> Regards!
>>
>> ----
>> diff --git a/drivers/pci/hotplug/acpiphp_glue.c
>> b/drivers/pci/hotplug/acpiphp_glue.c
>> index 0302645..699b8ca 100644
>> --- a/drivers/pci/hotplug/acpiphp_glue.c
>> +++ b/drivers/pci/hotplug/acpiphp_glue.c
>> @@ -1075,8 +1075,6 @@ static void
>> _handle_hotplug_event_func(acpi_handle handle, u32 type,
>>         struct acpi_buffer buffer = { .length = sizeof(objname),
>>                                       .pointer = objname };
>>
>> -       acpi_scan_lock_acquire();
>> -
>>         acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer);
>>
>>         switch (type) {
>> @@ -1108,8 +1106,6 @@ static void
>> _handle_hotplug_event_func(acpi_handle handle, u32 type,
>>                 warn("notify_handler: unknown event type 0x%x for
>> %s\n", type, objname);
>>                 break;
>>         }
>> -
>> -       acpi_scan_lock_release();
>>  }
>>
>>  static void _handle_hotplug_event_cb(struct work_struct *work)
>> @@ -1119,8 +1115,10 @@ static void _handle_hotplug_event_cb(struct
>> work_struct *work)
>>
>>         hp_work = container_of(work, struct acpi_hp_work, work);
>>         func = (struct acpiphp_func *)hp_work->context;
>> +       acpi_scan_lock_acquire();
>>         _handle_hotplug_event_func(hp_work->handle, hp_work->type,
>>                                     hp_work->context);
>> +       acpi_scan_lock_release();
>>         kfree(hp_work); /* allocated in handle_hotplug_event_func */
>>         put_bridge(func->slot->bridge);
>>  }
>>
>
>
>
> --
> Alexander E. Patrakov


