Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304Ab3EJLsH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 07:48:07 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:42949 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511Ab3EJLsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 07:48:04 -0400
Date: Fri, 10 May 2013 13:47:59 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT] HID
Message-ID: <20130510114759.GA19857@gmail.com>
References: <alpine.LNX.2.00.1304301023040.20139@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1304301023040.20139@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


hi Jiri,

* Jiri Kosina <jkosina@suse.cz> wrote:

> Linus,
> 
> please pull from
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus
> 
> to receive HID subsystem updates for 3.10. Highlights:
> 
> 
> - hid driver transport cleanup, finalizing the long-desired decoupling of 
>   core from transport layers, by Benjamin Tissoires and Henrik Rydberg
> - support for hybrid finger/pen multitouch HID devices, by Benjamin 
>   Tissoires
> - fix for long-standing issue in Logitech unifying driver sometimes not
>   inializing properly due to device specifics, by Andrew de los Reyes
> - Wii remote driver updates to support 2nd generation of devices, by David 
>   Herrmann
> - support for Apple IR remote
> - roccat driver now supports new devices (Roccat Kone Pure, IskuFX), by 
>   Stefan Achatz
> - debugfs locking fixes in hid debug interface, by Jiri Kosina

FYI, there's a new HID related lockdep and RCU splat upstream, probably 
relatd to the debugfs locking fixes:

[   79.088631] ======================================================
[   79.088631] [ INFO: HARDIRQ-safe -> HARDIRQ-unsafe lock order detected ]
[   79.088631] 3.9.0-13694-g7cf229a-dirty #224212 Tainted: G        W   
[   79.088631] ------------------------------------------------------
[   79.088631] swapper/0/1 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
[   79.088631]  (&hdev->debug_list_lock){+.+...}, at: [<ffffffff82e510d9>] hid_debug_event+0x2e/0xd0
[   79.088631] 

See the full bootlog below. It's from an allyesconfig x86-64 bootup log.

Kernel based on upstream commit 70eba4226d97.

Thanks,

	Ingo

---------->
[   78.966735] calling  sensor_hub_driver_init+0x0/0x1b @ 1
[   78.972020] bus: 'hid': add driver hid-sensor-hub
[   78.976931] initcall sensor_hub_driver_init+0x0/0x1b returned 0 after 4811 usecs
[   78.984372] calling  hid_init+0x0/0x4e @ 1
[   78.988492] bus: 'usb': add driver usbhid
[   78.992512] bus: 'usb': driver_probe_device: matched device 2-2:1.0 with driver usbhid
[   79.000469] bus: 'usb': really_probe: probing driver usbhid with device 2-2:1.0
[   79.007866] usbhid 2-2:1.0: usb_probe_interface
[   79.012359] usbhid 2-2:1.0: usb_probe_interface - got id
[   79.030530] device: '0003:1241:1503.0001': device_add
[   79.035598] bus: 'hid': add device 0003:1241:1503.0001
[   79.040959] PM: Adding info for hid:0003:1241:1503.0001
[   79.046354] bus: 'hid': driver_probe_device: matched device 0003:1241:1503.0001 with driver hid-generic
[   79.055798] bus: 'hid': really_probe: probing driver hid-generic with device 0003:1241:1503.0001
[   79.066267] device: 'input5': device_add
[   79.071093] PM: Adding info for No Bus:input5
[   79.075561] input:   USB Keyboard as /devices/pci0000:00/0000:00:02.0/usb2/2-2/2-2:1.0/input/input5
[   79.084842] 
[   79.086268] ===============================
[   79.088631] [ INFO: suspicious RCU usage. ]
[   79.088631] 3.9.0-13694-g7cf229a-dirty #224212 Tainted: G        W   
[   79.088631] -------------------------------
[   79.088631] include/linux/rcupdate.h:476 Illegal context switch in RCU read-side critical section!
[   79.088631] 
[   79.088631] other info that might help us debug this:
[   79.088631] 
[   79.088631] 
[   79.088631] rcu_scheduler_active = 1, debug_locks = 1
[   79.088631] 7 locks held by swapper/0/1:
[   79.088631]  #0:  (&__lockdep_no_validate__){......}, at: [<ffffffff81b73d97>] device_lock+0xf/0x11
[   79.088631]  #1:  (&__lockdep_no_validate__){......}, at: [<ffffffff81b73d97>] device_lock+0xf/0x11
[   79.088631]  #2:  (&__lockdep_no_validate__){......}, at: [<ffffffff81b73d97>] device_lock+0xf/0x11
[   79.088631]  #3:  (input_mutex){+.+.+.}, at: [<ffffffff82840846>] input_register_device+0x30b/0x409
[   79.088631]  #4:  (&(&dev->event_lock)->rlock){......}, at: [<ffffffff8283fec6>] input_inject_event+0x4e/0xd3
[   79.088631]  #5:  (rcu_read_lock){.+.+..}, at: [<ffffffff8283f35e>] rcu_read_lock+0x0/0x79
[   79.088631]  #6:  (&(&usbhid->lock)->rlock){-.....}, at: [<ffffffff82e78520>] usb_hidinput_input_event+0x99/0xd6
[   79.088631] 
[   79.088631] stack backtrace:
[   79.088631] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W    3.9.0-13694-g7cf229a-dirty #224212
[   79.088631] Hardware name: System manufacturer System Product Name/A8N-E, BIOS ASUS A8N-E ACPI BIOS Revision 1008 08/22/2005
[   79.088631]  0000000000000001 ffff88003df575a8 ffffffff8354c571 ffff88003df575d8
[   79.088631]  ffffffff8114be19 ffffffff8476add5 000000000000019d 0000000000000000
[   79.088631]  0000000000000000 ffff88003df575e8 ffffffff8112305c ffff88003df57618
[   79.088631] Call Trace:
[   79.088631]  [<ffffffff8354c571>] dump_stack+0x19/0x1b
[   79.088631]  [<ffffffff8114be19>] lockdep_rcu_suspicious+0xfc/0x105
[   79.088631]  [<ffffffff8112305c>] rcu_preempt_sleep_check+0x45/0x47
[   79.088631]  [<ffffffff81125024>] __might_sleep+0x1d/0x1a2
[   79.088631]  [<ffffffff8357f4a6>] mutex_lock_nested+0x25/0x40
[   79.088631]  [<ffffffff82e510d9>] hid_debug_event+0x2e/0xd0
[   79.088631]  [<ffffffff82e514d6>] hid_dump_input+0x64/0x8d
[   79.088631]  [<ffffffff82e52ac3>] hid_set_field+0x3c/0xc7
[   79.088631]  [<ffffffff82e78532>] usb_hidinput_input_event+0xab/0xd6
[   79.088631]  [<ffffffff8283fd9b>] input_handle_event+0x37a/0x457
[   79.088631]  [<ffffffff8283ff2b>] input_inject_event+0xb3/0xd3
[   79.088631]  [<ffffffff8199afc1>] kbd_update_leds_helper+0x51/0x7e
[   79.088631]  [<ffffffff8199bb4e>] kbd_start+0x33/0x3c
[   79.088631]  [<ffffffff82840a47>] input_register_handle+0x8f/0x9e
[   79.088631]  [<ffffffff8199b3d3>] kbd_connect+0x4e/0x8c
[   79.088631]  [<ffffffff8283f910>] input_attach_handler+0x1af/0x1e1
[   79.088631]  [<ffffffff8284087f>] input_register_device+0x344/0x409
[   79.088631]  [<ffffffff82e57c45>] hidinput_connect+0x40f/0x446
[   79.088631]  [<ffffffff82e5445d>] hid_connect+0x82/0x2b0
[   79.088631]  [<ffffffff81b7d156>] ? device_set_wakeup_enable+0x21/0x32
[   79.088631]  [<ffffffff82e79a33>] ? usbhid_start+0x424/0x486
[   79.088631]  [<ffffffff82e54765>] hid_device_probe+0xda/0x14d
[   79.088631]  [<ffffffff81b747c8>] ? __driver_attach+0x74/0x74
[   79.088631]  [<ffffffff81b74589>] driver_probe_device+0x11c/0x2e7
[   79.088631]  [<ffffffff81b747c8>] ? __driver_attach+0x74/0x74
[   79.088631]  [<ffffffff81b747f2>] __device_attach+0x2a/0x3d
[   79.088631]  [<ffffffff81b7287d>] bus_for_each_drv+0x54/0x90
[   79.088631]  [<ffffffff81b743f5>] device_attach+0x6e/0x8f
[   79.088631]  [<ffffffff81b73856>] bus_probe_device+0x35/0xae
[   79.088631]  [<ffffffff81b71db3>] device_add+0x449/0x624
[   79.088631]  [<ffffffff82e5439c>] hid_add_device+0x20d/0x24c
[   79.088631]  [<ffffffff82e78238>] usbhid_probe+0x418/0x461
[   79.088631]  [<ffffffff82718e74>] usb_probe_interface+0x195/0x22b
[   79.088631]  [<ffffffff81b74754>] ? driver_probe_device+0x2e7/0x2e7
[   79.088631]  [<ffffffff81b74589>] driver_probe_device+0x11c/0x2e7
[   79.088631]  [<ffffffff8357f4bc>] ? mutex_lock_nested+0x3b/0x40
[   79.088631]  [<ffffffff81b747a7>] __driver_attach+0x53/0x74
[   79.088631]  [<ffffffff81b72915>] bus_for_each_dev+0x5c/0x8e
[   79.088631]  [<ffffffff81b73f06>] driver_attach+0x1e/0x20
[   79.088631]  [<ffffffff81b73b20>] bus_add_driver+0x114/0x238
[   79.088631]  [<ffffffff8112bd06>] ? local_clock+0x19/0x52
[   79.088631]  [<ffffffff81b74d94>] driver_register+0x93/0x119
[   79.088631]  [<ffffffff82717bf2>] usb_register_driver+0xa4/0x150
[   79.088631]  [<ffffffff85ac0582>] hid_init+0x2d/0x4e
[   79.088631]  [<ffffffff85ac0555>] ? sensor_hub_driver_init+0x1b/0x1b
[   79.088631]  [<ffffffff810020bd>] do_one_initcall+0x66/0x13d
[   79.088631]  [<ffffffff85a14f3e>] kernel_init_freeable+0x160/0x1f2
[   79.088631]  [<ffffffff85a146d2>] ? loglevel+0x31/0x31
[   79.088631]  [<ffffffff8114cf68>] ? trace_hardirqs_on_caller+0x150/0x1eb
[   79.088631]  [<ffffffff83528ac1>] ? rest_init+0x155/0x155
[   79.088631]  [<ffffffff83528acf>] kernel_init+0xe/0xdb
[   79.088631]  [<ffffffff835897ec>] ret_from_fork+0x7c/0xb0
[   79.088631]  [<ffffffff83528ac1>] ? rest_init+0x155/0x155
[   79.088631] 
[   79.088631] ======================================================
[   79.088631] [ INFO: HARDIRQ-safe -> HARDIRQ-unsafe lock order detected ]
[   79.088631] 3.9.0-13694-g7cf229a-dirty #224212 Tainted: G        W   
[   79.088631] ------------------------------------------------------
[   79.088631] swapper/0/1 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
[   79.088631]  (&hdev->debug_list_lock){+.+...}, at: [<ffffffff82e510d9>] hid_debug_event+0x2e/0xd0
[   79.088631] 
[   79.088631] and this task is already holding:
[   79.088631]  (&(&usbhid->lock)->rlock){-.....}, at: [<ffffffff82e78520>] usb_hidinput_input_event+0x99/0xd6
[   79.088631] which would create a new lock dependency:
[   79.088631]  (&(&usbhid->lock)->rlock){-.....} -> (&hdev->debug_list_lock){+.+...}
[   79.088631] 
[   79.088631] but this new dependency connects a HARDIRQ-irq-safe lock:
[   79.088631]  (&(&usbhid->lock)->rlock){-.....}
[   79.088631] ... which became HARDIRQ-irq-safe at:
[   79.088631]   [<ffffffff8114e838>] __lock_acquire+0x2d0/0xec8
[   79.088631]   [<ffffffff8114f9a0>] lock_acquire+0xfe/0x148
[   79.088631]   [<ffffffff835814d4>] _raw_spin_lock+0x45/0x79
[   79.088631]   [<ffffffff82e78750>] hid_ctrl+0x37/0x150
[   79.088631]   [<ffffffff82712b7b>] usb_hcd_giveback_urb+0x7a/0xc2
[   79.088631]   [<ffffffff8274bc1d>] finish_urb+0xda/0x116
[   79.088631]   [<ffffffff8274bca0>] takeback_td+0x47/0xb3
[   79.088631]   [<ffffffff8274beea>] dl_done_list+0x1de/0x20b
[   79.088631]   [<ffffffff8274d209>] ohci_irq+0x1a5/0x2cf
[   79.088631]   [<ffffffff82711e29>] usb_hcd_irq+0x5e/0x92
[   79.088631]   [<ffffffff811805e1>] handle_irq_event_percpu+0xab/0x26d
[   79.088631]   [<ffffffff811807e4>] handle_irq_event+0x41/0x61
[   79.088631]   [<ffffffff81183238>] handle_fasteoi_irq+0x7f/0xb5
[   79.088631]   [<ffffffff8104d2fe>] handle_irq+0x125/0x132
[   79.088631]   [<ffffffff8358b78d>] do_IRQ+0x4d/0xa5
[   79.088631]   [<ffffffff835822b2>] ret_from_intr+0x0/0x1a
[   79.088631]   [<ffffffff83581dae>] _raw_spin_unlock_irq+0x32/0x45
[   79.088631]   [<ffffffff81125797>] finish_task_switch+0x7d/0xe2
[   79.088631]   [<ffffffff835806dc>] __schedule+0x67f/0x733
[   79.088631]   [<ffffffff8358085a>] schedule+0x65/0x67
[   79.088631]   [<ffffffff81188f70>] rcu_torture_reader+0x280/0x32b
[   79.088631]   [<ffffffff8111aa4c>] kthread+0xb1/0xb9
[   79.088631]   [<ffffffff835897ec>] ret_from_fork+0x7c/0xb0
[   79.088631] 
[   79.088631] to a HARDIRQ-irq-unsafe lock:
[   79.088631]  (&hdev->debug_list_lock){+.+...}
[   79.088631] ... which became HARDIRQ-irq-unsafe at:
[   79.088631] ...  [<ffffffff8114e8a7>] __lock_acquire+0x33f/0xec8
[   79.088631]   [<ffffffff8114f9a0>] lock_acquire+0xfe/0x148
[   79.088631]   [<ffffffff8357f014>] __mutex_lock_common+0x53/0x400
[   79.088631]   [<ffffffff8357f4bc>] mutex_lock_nested+0x3b/0x40
[   79.088631]   [<ffffffff82e510d9>] hid_debug_event+0x2e/0xd0
[   79.088631]   [<ffffffff82e514d6>] hid_dump_input+0x64/0x8d
[   79.088631]   [<ffffffff82e52ac3>] hid_set_field+0x3c/0xc7
[   79.088631]   [<ffffffff82e78c42>] usbhid_set_leds+0x7f/0x92
[   79.088631]   [<ffffffff82e79a26>] usbhid_start+0x417/0x486
[   79.088631]   [<ffffffff82e54754>] hid_device_probe+0xc9/0x14d
[   79.088631]   [<ffffffff81b74589>] driver_probe_device+0x11c/0x2e7
[   79.088631]   [<ffffffff81b747f2>] __device_attach+0x2a/0x3d
[   79.088631]   [<ffffffff81b7287d>] bus_for_each_drv+0x54/0x90
[   79.088631]   [<ffffffff81b743f5>] device_attach+0x6e/0x8f
[   79.088631]   [<ffffffff81b73856>] bus_probe_device+0x35/0xae
[   79.088631]   [<ffffffff81b71db3>] device_add+0x449/0x624
[   79.088631]   [<ffffffff82e5439c>] hid_add_device+0x20d/0x24c
[   79.088631]   [<ffffffff82e78238>] usbhid_probe+0x418/0x461
[   79.088631]   [<ffffffff82718e74>] usb_probe_interface+0x195/0x22b
[   79.088631]   [<ffffffff81b74589>] driver_probe_device+0x11c/0x2e7
[   79.088631]   [<ffffffff81b747a7>] __driver_attach+0x53/0x74
[   79.088631]   [<ffffffff81b72915>] bus_for_each_dev+0x5c/0x8e
[   79.088631]   [<ffffffff81b73f06>] driver_attach+0x1e/0x20
[   79.088631]   [<ffffffff81b73b20>] bus_add_driver+0x114/0x238
[   79.088631]   [<ffffffff81b74d94>] driver_register+0x93/0x119
[   79.088631]   [<ffffffff82717bf2>] usb_register_driver+0xa4/0x150
[   79.088631]   [<ffffffff85ac0582>] hid_init+0x2d/0x4e
[   79.088631]   [<ffffffff810020bd>] do_one_initcall+0x66/0x13d
[   79.088631]   [<ffffffff85a14f3e>] kernel_init_freeable+0x160/0x1f2
[   79.088631]   [<ffffffff83528acf>] kernel_init+0xe/0xdb
[   79.088631]   [<ffffffff835897ec>] ret_from_fork+0x7c/0xb0
[   79.088631] 
[   79.088631] other info that might help us debug this:
[   79.088631] 
[   79.088631]  Possible interrupt unsafe locking scenario:
[   79.088631] 
[   79.088631]        CPU0                    CPU1
[   79.088631]        ----                    ----
[   79.088631]   lock(&hdev->debug_list_lock);
[   79.088631]                                local_irq_disable();
[   79.088631]                                lock(&(&usbhid->lock)->rlock);
[   79.088631]                                lock(&hdev->debug_list_lock);
[   79.088631]   <Interrupt>
[   79.088631]     lock(&(&usbhid->lock)->rlock);
[   79.088631] 
[   79.088631]  *** DEADLOCK ***
[   79.088631] 
[   79.088631] 7 locks held by swapper/0/1:
[   79.088631]  #0:  (&__lockdep_no_validate__){......}, at: [<ffffffff81b73d97>] device_lock+0xf/0x11
[   79.088631]  #1:  (&__lockdep_no_validate__){......}, at: [<ffffffff81b73d97>] device_lock+0xf/0x11
[   79.088631]  #2:  (&__lockdep_no_validate__){......}, at: [<ffffffff81b73d97>] device_lock+0xf/0x11
[   79.088631]  #3:  (input_mutex){+.+.+.}, at: [<ffffffff82840846>] input_register_device+0x30b/0x409
[   79.088631]  #4:  (&(&dev->event_lock)->rlock){......}, at: [<ffffffff8283fec6>] input_inject_event+0x4e/0xd3
[   79.088631]  #5:  (rcu_read_lock){.+.+..}, at: [<ffffffff8283f35e>] rcu_read_lock+0x0/0x79
[   79.088631]  #6:  (&(&usbhid->lock)->rlock){-.....}, at: [<ffffffff82e78520>] usb_hidinput_input_event+0x99/0xd6
[   79.088631] 
[   79.088631] the dependencies between HARDIRQ-irq-safe lock and the holding lock:
[   79.088631] -> (&(&usbhid->lock)->rlock){-.....} ops: 4 {
[   79.088631]    IN-HARDIRQ-W at:
[   79.088631]                     [<ffffffff8114e838>] __lock_acquire+0x2d0/0xec8
[   79.088631]                     [<ffffffff8114f9a0>] lock_acquire+0xfe/0x148
[   79.088631]                     [<ffffffff835814d4>] _raw_spin_lock+0x45/0x79
[   79.088631]                     [<ffffffff82e78750>] hid_ctrl+0x37/0x150
[   79.088631]                     [<ffffffff82712b7b>] usb_hcd_giveback_urb+0x7a/0xc2
[   79.088631]                     [<ffffffff8274bc1d>] finish_urb+0xda/0x116
[   79.088631]                     [<ffffffff8274bca0>] takeback_td+0x47/0xb3
[   79.088631]                     [<ffffffff8274beea>] dl_done_list+0x1de/0x20b
[   79.088631]                     [<ffffffff8274d209>] ohci_irq+0x1a5/0x2cf
[   79.088631]                     [<ffffffff82711e29>] usb_hcd_irq+0x5e/0x92
[   79.088631]                     [<ffffffff811805e1>] handle_irq_event_percpu+0xab/0x26d
[   79.088631]                     [<ffffffff811807e4>] handle_irq_event+0x41/0x61
[   79.088631]                     [<ffffffff81183238>] handle_fasteoi_irq+0x7f/0xb5
[   79.088631]                     [<ffffffff8104d2fe>] handle_irq+0x125/0x132
[   79.088631]                     [<ffffffff8358b78d>] do_IRQ+0x4d/0xa5
[   79.088631]                     [<ffffffff835822b2>] ret_from_intr+0x0/0x1a
[   79.088631]                     [<ffffffff83581dae>] _raw_spin_unlock_irq+0x32/0x45
[   79.088631]                     [<ffffffff81125797>] finish_task_switch+0x7d/0xe2
[   79.088631]                     [<ffffffff835806dc>] __schedule+0x67f/0x733
[   79.088631]                     [<ffffffff8358085a>] schedule+0x65/0x67
[   79.088631]                     [<ffffffff81188f70>] rcu_torture_reader+0x280/0x32b
[   79.088631]                     [<ffffffff8111aa4c>] kthread+0xb1/0xb9
[   79.088631]                     [<ffffffff835897ec>] ret_from_fork+0x7c/0xb0
[   79.088631]    INITIAL USE at:
[   79.088631]                    [<ffffffff8114e910>] __lock_acquire+0x3a8/0xec8
[   79.088631]                    [<ffffffff8114f9a0>] lock_acquire+0xfe/0x148
[   79.088631]                    [<ffffffff83581fe6>] _raw_spin_lock_irqsave+0x5a/0x94
[   79.088631]                    [<ffffffff82e78b75>] usbhid_submit_report+0x34/0x5d
[   79.088631]                    [<ffffffff82e79571>] usbhid_init_reports+0x34/0xd2
[   79.088631]                    [<ffffffff82e79a06>] usbhid_start+0x3f7/0x486
[   79.088631]                    [<ffffffff82e54754>] hid_device_probe+0xc9/0x14d
[   79.088631]                    [<ffffffff81b74589>] driver_probe_device+0x11c/0x2e7
[   79.088631]                    [<ffffffff81b747f2>] __device_attach+0x2a/0x3d
[   79.088631]                    [<ffffffff81b7287d>] bus_for_each_drv+0x54/0x90
[   79.088631]                    [<ffffffff81b743f5>] device_attach+0x6e/0x8f
[   79.088631]                    [<ffffffff81b73856>] bus_probe_device+0x35/0xae
[   79.088631]                    [<ffffffff81b71db3>] device_add+0x449/0x624
[   79.088631]                    [<ffffffff82e5439c>] hid_add_device+0x20d/0x24c
[   79.088631]                    [<ffffffff82e78238>] usbhid_probe+0x418/0x461
[   79.088631]                    [<ffffffff82718e74>] usb_probe_interface+0x195/0x22b
[   79.088631]                    [<ffffffff81b74589>] driver_probe_device+0x11c/0x2e7
[   79.088631]                    [<ffffffff81b747a7>] __driver_attach+0x53/0x74
[   79.088631]                    [<ffffffff81b72915>] bus_for_each_dev+0x5c/0x8e
[   79.088631]                    [<ffffffff81b73f06>] driver_attach+0x1e/0x20
[   79.088631]                    [<ffffffff81b73b20>] bus_add_driver+0x114/0x238
[   79.088631]                    [<ffffffff81b74d94>] driver_register+0x93/0x119
[   79.088631]                    [<ffffffff82717bf2>] usb_register_driver+0xa4/0x150
[   79.088631]                    [<ffffffff85ac0582>] hid_init+0x2d/0x4e
[   79.088631]                    [<ffffffff810020bd>] do_one_initcall+0x66/0x13d
[   79.088631]                    [<ffffffff85a14f3e>] kernel_init_freeable+0x160/0x1f2
[   79.088631]                    [<ffffffff83528acf>] kernel_init+0xe/0xdb
[   79.088631]                    [<ffffffff835897ec>] ret_from_fork+0x7c/0xb0
[   79.088631]  }
[   79.088631]  ... key      at: [<ffffffff86bd32f8>] __key.29909+0x0/0x8
[   79.088631]  ... acquired at:
[   79.088631]    [<ffffffff8114c86c>] check_irq_usage+0x42/0x88
[   79.088631]    [<ffffffff8114f0bb>] __lock_acquire+0xb53/0xec8
[   79.088631]    [<ffffffff8114f9a0>] lock_acquire+0xfe/0x148
[   79.088631]    [<ffffffff8357f014>] __mutex_lock_common+0x53/0x400
[   79.088631]    [<ffffffff8357f4bc>] mutex_lock_nested+0x3b/0x40
[   79.088631]    [<ffffffff82e510d9>] hid_debug_event+0x2e/0xd0
[   79.088631]    [<ffffffff82e514d6>] hid_dump_input+0x64/0x8d
[   79.088631]    [<ffffffff82e52ac3>] hid_set_field+0x3c/0xc7
[   79.088631]    [<ffffffff82e78532>] usb_hidinput_input_event+0xab/0xd6
[   79.088631]    [<ffffffff8283fd9b>] input_handle_event+0x37a/0x457
[   79.088631]    [<ffffffff8283ff2b>] input_inject_event+0xb3/0xd3
[   79.088631]    [<ffffffff8199afc1>] kbd_update_leds_helper+0x51/0x7e
[   79.088631]    [<ffffffff8199bb4e>] kbd_start+0x33/0x3c
[   79.088631]    [<ffffffff82840a47>] input_register_handle+0x8f/0x9e
[   79.088631]    [<ffffffff8199b3d3>] kbd_connect+0x4e/0x8c
[   79.088631]    [<ffffffff8283f910>] input_attach_handler+0x1af/0x1e1
[   79.088631]    [<ffffffff8284087f>] input_register_device+0x344/0x409
[   79.088631]    [<ffffffff82e57c45>] hidinput_connect+0x40f/0x446
[   79.088631]    [<ffffffff82e5445d>] hid_connect+0x82/0x2b0
[   79.088631]    [<ffffffff82e54765>] hid_device_probe+0xda/0x14d
[   79.088631]    [<ffffffff81b74589>] driver_probe_device+0x11c/0x2e7
[   79.088631]    [<ffffffff81b747f2>] __device_attach+0x2a/0x3d
[   79.088631]    [<ffffffff81b7287d>] bus_for_each_drv+0x54/0x90
[   79.088631]    [<ffffffff81b743f5>] device_attach+0x6e/0x8f
[   79.088631]    [<ffffffff81b73856>] bus_probe_device+0x35/0xae
[   79.088631]    [<ffffffff81b71db3>] device_add+0x449/0x624
[   79.088631]    [<ffffffff82e5439c>] hid_add_device+0x20d/0x24c
[   79.088631]    [<ffffffff82e78238>] usbhid_probe+0x418/0x461
[   79.088631]    [<ffffffff82718e74>] usb_probe_interface+0x195/0x22b
[   79.088631]    [<ffffffff81b74589>] driver_probe_device+0x11c/0x2e7
[   79.088631]    [<ffffffff81b747a7>] __driver_attach+0x53/0x74
[   79.088631]    [<ffffffff81b72915>] bus_for_each_dev+0x5c/0x8e
[   79.088631]    [<ffffffff81b73f06>] driver_attach+0x1e/0x20
[   79.088631]    [<ffffffff81b73b20>] bus_add_driver+0x114/0x238
[   79.088631]    [<ffffffff81b74d94>] driver_register+0x93/0x119
[   79.088631]    [<ffffffff82717bf2>] usb_register_driver+0xa4/0x150
[   79.088631]    [<ffffffff85ac0582>] hid_init+0x2d/0x4e
[   79.088631]    [<ffffffff810020bd>] do_one_initcall+0x66/0x13d
[   79.088631]    [<ffffffff85a14f3e>] kernel_init_freeable+0x160/0x1f2
[   79.088631]    [<ffffffff83528acf>] kernel_init+0xe/0xdb
[   79.088631]    [<ffffffff835897ec>] ret_from_fork+0x7c/0xb0
[   79.088631] 
[   79.088631] 
[   79.088631] the dependencies between the lock to be acquired and HARDIRQ-irq-unsafe lock:
[   79.088631] -> (&hdev->debug_list_lock){+.+...} ops: 2 {
[   79.088631]    HARDIRQ-ON-W at:
[   79.088631]                     [<ffffffff8114e8a7>] __lock_acquire+0x33f/0xec8
[   79.088631]                     [<ffffffff8114f9a0>] lock_acquire+0xfe/0x148
[   79.088631]                     [<ffffffff8357f014>] __mutex_lock_common+0x53/0x400
[   79.088631]                     [<ffffffff8357f4bc>] mutex_lock_nested+0x3b/0x40
[   79.088631]                     [<ffffffff82e510d9>] hid_debug_event+0x2e/0xd0
[   79.088631]                     [<ffffffff82e514d6>] hid_dump_input+0x64/0x8d
[   79.088631]                     [<ffffffff82e52ac3>] hid_set_field+0x3c/0xc7
[   79.088631]                     [<ffffffff82e78c42>] usbhid_set_leds+0x7f/0x92
[   79.088631]                     [<ffffffff82e79a26>] usbhid_start+0x417/0x486
[   79.088631]                     [<ffffffff82e54754>] hid_device_probe+0xc9/0x14d
[   79.088631]                     [<ffffffff81b74589>] driver_probe_device+0x11c/0x2e7
[   79.088631]                     [<ffffffff81b747f2>] __device_attach+0x2a/0x3d
[   79.088631]                     [<ffffffff81b7287d>] bus_for_each_drv+0x54/0x90
[   79.088631]                     [<ffffffff81b743f5>] device_attach+0x6e/0x8f
[   79.088631]                     [<ffffffff81b73856>] bus_probe_device+0x35/0xae
[   79.088631]                     [<ffffffff81b71db3>] device_add+0x449/0x624
[   79.088631]                     [<ffffffff82e5439c>] hid_add_device+0x20d/0x24c
[   79.088631]                     [<ffffffff82e78238>] usbhid_probe+0x418/0x461
[   79.088631]                     [<ffffffff82718e74>] usb_probe_interface+0x195/0x22b
[   79.088631]                     [<ffffffff81b74589>] driver_probe_device+0x11c/0x2e7
[   79.088631]                     [<ffffffff81b747a7>] __driver_attach+0x53/0x74
[   79.088631]                     [<ffffffff81b72915>] bus_for_each_dev+0x5c/0x8e
[   79.088631]                     [<ffffffff81b73f06>] driver_attach+0x1e/0x20
[   79.088631]                     [<ffffffff81b73b20>] bus_add_driver+0x114/0x238
[   79.088631]                     [<ffffffff81b74d94>] driver_register+0x93/0x119
[   79.088631]                     [<ffffffff82717bf2>] usb_register_driver+0xa4/0x150
[   79.088631]                     [<ffffffff85ac0582>] hid_init+0x2d/0x4e
[   79.088631]                     [<ffffffff810020bd>] do_one_initcall+0x66/0x13d
[   79.088631]                     [<ffffffff85a14f3e>] kernel_init_freeable+0x160/0x1f2
[   79.088631]                     [<ffffffff83528acf>] kernel_init+0xe/0xdb
[   79.088631]                     [<ffffffff835897ec>] ret_from_fork+0x7c/0xb0
[   79.088631]    SOFTIRQ-ON-W at:
[   79.088631]                     [<ffffffff8114e8c9>] __lock_acquire+0x361/0xec8
[   79.088631]                     [<ffffffff8114f9a0>] lock_acquire+0xfe/0x148
[   79.088631]                     [<ffffffff8357f014>] __mutex_lock_common+0x53/0x400
[   79.088631]                     [<ffffffff8357f4bc>] mutex_lock_nested+0x3b/0x40
[   79.088631]                     [<ffffffff82e510d9>] hid_debug_event+0x2e/0xd0
[   79.088631]                     [<ffffffff82e514d6>] hid_dump_input+0x64/0x8d
[   79.088631]                     [<ffffffff82e52ac3>] hid_set_field+0x3c/0xc7
[   79.088631]                     [<ffffffff82e78c42>] usbhid_set_leds+0x7f/0x92
[   79.088631]                     [<ffffffff82e79a26>] usbhid_start+0x417/0x486
[   79.088631]                     [<ffffffff82e54754>] hid_device_probe+0xc9/0x14d
[   79.088631]                     [<ffffffff81b74589>] driver_probe_device+0x11c/0x2e7
[   79.088631]                     [<ffffffff81b747f2>] __device_attach+0x2a/0x3d
[   79.088631]                     [<ffffffff81b7287d>] bus_for_each_drv+0x54/0x90
[   79.088631]                     [<ffffffff81b743f5>] device_attach+0x6e/0x8f
[   79.088631]                     [<ffffffff81b73856>] bus_probe_device+0x35/0xae
[   79.088631]                     [<ffffffff81b71db3>] device_add+0x449/0x624
[   79.088631]                     [<ffffffff82e5439c>] hid_add_device+0x20d/0x24c
[   79.088631]                     [<ffffffff82e78238>] usbhid_probe+0x418/0x461
[   79.088631]                     [<ffffffff82718e74>] usb_probe_interface+0x195/0x22b
[   79.088631]                     [<ffffffff81b74589>] driver_probe_device+0x11c/0x2e7
[   79.088631]                     [<ffffffff81b747a7>] __driver_attach+0x53/0x74
[   79.088631]                     [<ffffffff81b72915>] bus_for_each_dev+0x5c/0x8e
[   79.088631]                     [<ffffffff81b73f06>] driver_attach+0x1e/0x20
[   79.088631]                     [<ffffffff81b73b20>] bus_add_driver+0x114/0x238
[   79.088631]                     [<ffffffff81b74d94>] driver_register+0x93/0x119
[   79.088631]                     [<ffffffff82717bf2>] usb_register_driver+0xa4/0x150
[   79.088631]                     [<ffffffff85ac0582>] hid_init+0x2d/0x4e
[   79.088631]                     [<ffffffff810020bd>] do_one_initcall+0x66/0x13d
[   79.088631]                     [<ffffffff85a14f3e>] kernel_init_freeable+0x160/0x1f2
[   79.088631]                     [<ffffffff83528acf>] kernel_init+0xe/0xdb
[   79.088631]                     [<ffffffff835897ec>] ret_from_fork+0x7c/0xb0
[   79.088631]    INITIAL USE at:
[   79.088631]                    [<ffffffff8114e910>] __lock_acquire+0x3a8/0xec8
[   79.088631]                    [<ffffffff8114f9a0>] lock_acquire+0xfe/0x148
[   79.088631]                    [<ffffffff8357f014>] __mutex_lock_common+0x53/0x400
[   79.088631]                    [<ffffffff8357f4bc>] mutex_lock_nested+0x3b/0x40
[   79.088631]                    [<ffffffff82e510d9>] hid_debug_event+0x2e/0xd0
[   79.088631]                    [<ffffffff82e514d6>] hid_dump_input+0x64/0x8d
[   79.088631]                    [<ffffffff82e52ac3>] hid_set_field+0x3c/0xc7
[   79.088631]                    [<ffffffff82e78c42>] usbhid_set_leds+0x7f/0x92
[   79.088631]                    [<ffffffff82e79a26>] usbhid_start+0x417/0x486
[   79.088631]                    [<ffffffff82e54754>] hid_device_probe+0xc9/0x14d
[   79.088631]                    [<ffffffff81b74589>] driver_probe_device+0x11c/0x2e7
[   79.088631]                    [<ffffffff81b747f2>] __device_attach+0x2a/0x3d
[   79.088631]                    [<ffffffff81b7287d>] bus_for_each_drv+0x54/0x90
[   79.088631]                    [<ffffffff81b743f5>] device_attach+0x6e/0x8f
[   79.088631]                    [<ffffffff81b73856>] bus_probe_device+0x35/0xae
[   79.088631]                    [<ffffffff81b71db3>] device_add+0x449/0x624
[   79.088631]                    [<ffffffff82e5439c>] hid_add_device+0x20d/0x24c
[   79.088631]                    [<ffffffff82e78238>] usbhid_probe+0x418/0x461
[   79.088631]                    [<ffffffff82718e74>] usb_probe_interface+0x195/0x22b
[   79.088631]                    [<ffffffff81b74589>] driver_probe_device+0x11c/0x2e7
[   79.088631]                    [<ffffffff81b747a7>] __driver_attach+0x53/0x74
[   79.088631]                    [<ffffffff81b72915>] bus_for_each_dev+0x5c/0x8e
[   79.088631]                    [<ffffffff81b73f06>] driver_attach+0x1e/0x20
[   79.088631]                    [<ffffffff81b73b20>] bus_add_driver+0x114/0x238
[   79.088631]                    [<ffffffff81b74d94>] driver_register+0x93/0x119
[   79.088631]                    [<ffffffff82717bf2>] usb_register_driver+0xa4/0x150
[   79.088631]                    [<ffffffff85ac0582>] hid_init+0x2d/0x4e
[   79.088631]                    [<ffffffff810020bd>] do_one_initcall+0x66/0x13d
[   79.088631]                    [<ffffffff85a14f3e>] kernel_init_freeable+0x160/0x1f2
[   79.088631]                    [<ffffffff83528acf>] kernel_init+0xe/0xdb
[   79.088631]                    [<ffffffff835897ec>] ret_from_fork+0x7c/0xb0
[   79.088631]  }
[   79.088631]  ... key      at: [<ffffffff86bd2c88>] __key.27451+0x0/0x8
[   79.088631]  ... acquired at:
[   79.088631]    [<ffffffff8114c86c>] check_irq_usage+0x42/0x88
[   79.088631]    [<ffffffff8114f0bb>] __lock_acquire+0xb53/0xec8
[   79.088631]    [<ffffffff8114f9a0>] lock_acquire+0xfe/0x148
[   79.088631]    [<ffffffff8357f014>] __mutex_lock_common+0x53/0x400
[   79.088631]    [<ffffffff8357f4bc>] mutex_lock_nested+0x3b/0x40
[   79.088631]    [<ffffffff82e510d9>] hid_debug_event+0x2e/0xd0
[   79.088631]    [<ffffffff82e514d6>] hid_dump_input+0x64/0x8d
[   79.088631]    [<ffffffff82e52ac3>] hid_set_field+0x3c/0xc7
[   79.088631]    [<ffffffff82e78532>] usb_hidinput_input_event+0xab/0xd6
[   79.088631]    [<ffffffff8283fd9b>] input_handle_event+0x37a/0x457
[   79.088631]    [<ffffffff8283ff2b>] input_inject_event+0xb3/0xd3
[   79.088631]    [<ffffffff8199afc1>] kbd_update_leds_helper+0x51/0x7e
[   79.088631]    [<ffffffff8199bb4e>] kbd_start+0x33/0x3c
[   79.088631]    [<ffffffff82840a47>] input_register_handle+0x8f/0x9e
[   79.088631]    [<ffffffff8199b3d3>] kbd_connect+0x4e/0x8c
[   79.088631]    [<ffffffff8283f910>] input_attach_handler+0x1af/0x1e1
[   79.088631]    [<ffffffff8284087f>] input_register_device+0x344/0x409
[   79.088631]    [<ffffffff82e57c45>] hidinput_connect+0x40f/0x446
[   79.088631]    [<ffffffff82e5445d>] hid_connect+0x82/0x2b0
[   79.088631]    [<ffffffff82e54765>] hid_device_probe+0xda/0x14d
[   79.088631]    [<ffffffff81b74589>] driver_probe_device+0x11c/0x2e7
[   79.088631]    [<ffffffff81b747f2>] __device_attach+0x2a/0x3d
[   79.088631]    [<ffffffff81b7287d>] bus_for_each_drv+0x54/0x90
[   79.088631]    [<ffffffff81b743f5>] device_attach+0x6e/0x8f
[   79.088631]    [<ffffffff81b73856>] bus_probe_device+0x35/0xae
[   79.088631]    [<ffffffff81b71db3>] device_add+0x449/0x624
[   79.088631]    [<ffffffff82e5439c>] hid_add_device+0x20d/0x24c
[   79.088631]    [<ffffffff82e78238>] usbhid_probe+0x418/0x461
[   79.088631]    [<ffffffff82718e74>] usb_probe_interface+0x195/0x22b
[   79.088631]    [<ffffffff81b74589>] driver_probe_device+0x11c/0x2e7
[   79.088631]    [<ffffffff81b747a7>] __driver_attach+0x53/0x74
[   79.088631]    [<ffffffff81b72915>] bus_for_each_dev+0x5c/0x8e
[   79.088631]    [<ffffffff81b73f06>] driver_attach+0x1e/0x20
[   79.088631]    [<ffffffff81b73b20>] bus_add_driver+0x114/0x238
[   79.088631]    [<ffffffff81b74d94>] driver_register+0x93/0x119
[   79.088631]    [<ffffffff82717bf2>] usb_register_driver+0xa4/0x150
[   79.088631]    [<ffffffff85ac0582>] hid_init+0x2d/0x4e
[   79.088631]    [<ffffffff810020bd>] do_one_initcall+0x66/0x13d
[   79.088631]    [<ffffffff85a14f3e>] kernel_init_freeable+0x160/0x1f2
[   79.088631]    [<ffffffff83528acf>] kernel_init+0xe/0xdb
[   79.088631]    [<ffffffff835897ec>] ret_from_fork+0x7c/0xb0
[   79.088631] 
[   79.088631] 
[   79.088631] stack backtrace:
[   79.088631] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W    3.9.0-13694-g7cf229a-dirty #224212
[   79.088631] Hardware name: System manufacturer System Product Name/A8N-E, BIOS ASUS A8N-E ACPI BIOS Revision 1008 08/22/2005
[   79.088631]  ffff88003df57398 ffff88003df572f8 ffffffff8354c571 ffff88003df57408
[   79.088631]  ffffffff8114c816 0000000000000000 0000000000000000 0000000000000001
[   79.088631]  ffffffff83528ac1 0000000000000000 0000000000000000 ffff88003df58a78
[   79.088631] Call Trace:
[   79.088631]  [<ffffffff8354c571>] dump_stack+0x19/0x1b
[   79.088631]  [<ffffffff8114c816>] check_usage+0x370/0x384
[   79.088631]  [<ffffffff83528ac1>] ? rest_init+0x155/0x155
[   79.088631]  [<ffffffff81051f0d>] ? native_sched_clock+0x33/0x35
[   79.088631]  [<ffffffff8114a87d>] ? lockdep_on+0x15/0x15
[   79.088631]  [<ffffffff8112bd28>] ? local_clock+0x3b/0x52
[   79.088631]  [<ffffffff8114c86c>] check_irq_usage+0x42/0x88
[   79.088631]  [<ffffffff8114f0bb>] __lock_acquire+0xb53/0xec8
[   79.088631]  [<ffffffff8114f9a0>] lock_acquire+0xfe/0x148
[   79.088631]  [<ffffffff82e510d9>] ? hid_debug_event+0x2e/0xd0
[   79.088631]  [<ffffffff82e510d9>] ? hid_debug_event+0x2e/0xd0
[   79.088631]  [<ffffffff8357f014>] __mutex_lock_common+0x53/0x400
[   79.088631]  [<ffffffff82e510d9>] ? hid_debug_event+0x2e/0xd0
[   79.088631]  [<ffffffff8114db01>] ? lock_is_held+0x59/0x6e
[   79.088631]  [<ffffffff8357f4bc>] mutex_lock_nested+0x3b/0x40
[   79.088631]  [<ffffffff82e510d9>] hid_debug_event+0x2e/0xd0
[   79.088631]  [<ffffffff82e514d6>] hid_dump_input+0x64/0x8d
[   79.088631]  [<ffffffff82e52ac3>] hid_set_field+0x3c/0xc7
[   79.088631]  [<ffffffff82e78532>] usb_hidinput_input_event+0xab/0xd6
[   79.088631]  [<ffffffff8283fd9b>] input_handle_event+0x37a/0x457
[   79.088631]  [<ffffffff8283ff2b>] input_inject_event+0xb3/0xd3
[   79.088631]  [<ffffffff8199afc1>] kbd_update_leds_helper+0x51/0x7e
[   79.088631]  [<ffffffff8199bb4e>] kbd_start+0x33/0x3c
[   79.088631]  [<ffffffff82840a47>] input_register_handle+0x8f/0x9e
[   79.088631]  [<ffffffff8199b3d3>] kbd_connect+0x4e/0x8c
[   79.088631]  [<ffffffff8283f910>] input_attach_handler+0x1af/0x1e1
[   79.088631]  [<ffffffff8284087f>] input_register_device+0x344/0x409
[   79.088631]  [<ffffffff82e57c45>] hidinput_connect+0x40f/0x446
[   79.088631]  [<ffffffff82e5445d>] hid_connect+0x82/0x2b0
[   79.088631]  [<ffffffff81b7d156>] ? device_set_wakeup_enable+0x21/0x32
[   79.088631]  [<ffffffff82e79a33>] ? usbhid_start+0x424/0x486
[   79.088631]  [<ffffffff82e54765>] hid_device_probe+0xda/0x14d
[   79.088631]  [<ffffffff81b747c8>] ? __driver_attach+0x74/0x74
[   79.088631]  [<ffffffff81b74589>] driver_probe_device+0x11c/0x2e7
[   79.088631]  [<ffffffff81b747c8>] ? __driver_attach+0x74/0x74
[   79.088631]  [<ffffffff81b747f2>] __device_attach+0x2a/0x3d
[   79.088631]  [<ffffffff81b7287d>] bus_for_each_drv+0x54/0x90
[   79.088631]  [<ffffffff81b743f5>] device_attach+0x6e/0x8f
[   79.088631]  [<ffffffff81b73856>] bus_probe_device+0x35/0xae
[   79.088631]  [<ffffffff81b71db3>] device_add+0x449/0x624
[   79.088631]  [<ffffffff82e5439c>] hid_add_device+0x20d/0x24c
[   79.088631]  [<ffffffff82e78238>] usbhid_probe+0x418/0x461
[   79.088631]  [<ffffffff82718e74>] usb_probe_interface+0x195/0x22b
[   79.088631]  [<ffffffff81b74754>] ? driver_probe_device+0x2e7/0x2e7
[   79.088631]  [<ffffffff81b74589>] driver_probe_device+0x11c/0x2e7
[   79.088631]  [<ffffffff8357f4bc>] ? mutex_lock_nested+0x3b/0x40
[   79.088631]  [<ffffffff81b747a7>] __driver_attach+0x53/0x74
[   79.088631]  [<ffffffff81b72915>] bus_for_each_dev+0x5c/0x8e
[   79.088631]  [<ffffffff81b73f06>] driver_attach+0x1e/0x20
[   79.088631]  [<ffffffff81b73b20>] bus_add_driver+0x114/0x238
[   79.088631]  [<ffffffff8112bd06>] ? local_clock+0x19/0x52
[   79.088631]  [<ffffffff81b74d94>] driver_register+0x93/0x119
[   79.088631]  [<ffffffff82717bf2>] usb_register_driver+0xa4/0x150
[   79.088631]  [<ffffffff85ac0582>] hid_init+0x2d/0x4e
[   79.088631]  [<ffffffff85ac0555>] ? sensor_hub_driver_init+0x1b/0x1b
[   79.088631]  [<ffffffff810020bd>] do_one_initcall+0x66/0x13d
[   79.088631]  [<ffffffff85a14f3e>] kernel_init_freeable+0x160/0x1f2
[   79.088631]  [<ffffffff85a146d2>] ? loglevel+0x31/0x31
[   79.088631]  [<ffffffff8114cf68>] ? trace_hardirqs_on_caller+0x150/0x1eb
[   79.088631]  [<ffffffff83528ac1>] ? rest_init+0x155/0x155
[   79.088631]  [<ffffffff83528acf>] kernel_init+0xe/0xdb
[   79.088631]  [<ffffffff835897ec>] ret_from_fork+0x7c/0xb0
[   79.088631]  [<ffffffff83528ac1>] ? rest_init+0x155/0x155
[   82.080053] device: 'event5': device_add
[   82.084442] PM: Adding info for No Bus:event5
[   82.088955] evbug: Connected device: input5 (  USB Keyboard at usb-0000:00:02.0-2/input0)
[   82.097328] device: 'hidraw0': device_add
[   82.101869] PM: Adding info for No Bus:hidraw0
[   82.106419] hid-generic 0003:1241:1503.0001: input,hidraw0: USB HID v1.10 Keyboard [  USB Keyboard] on usb-0000:00:02.0-2/input0

