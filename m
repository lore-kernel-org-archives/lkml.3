Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757620Ab3ENSbS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 14:31:18 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:40615 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754656Ab3ENSbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 14:31:16 -0400
Date: Tue, 14 May 2013 20:31:08 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT] HID
Message-ID: <20130514183108.GA4904@gmail.com>
References: <alpine.LNX.2.00.1304301023040.20139@pobox.suse.cz>
 <20130510114759.GA19857@gmail.com>
 <alpine.LNX.2.00.1305101349000.23038@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1305101349000.23038@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Kosina <jkosina@suse.cz> wrote:

> > FYI, there's a new HID related lockdep and RCU splat upstream, probably 
> > relatd to the debugfs locking fixes:
> > 
> > [   79.088631] ======================================================
> > [   79.088631] [ INFO: HARDIRQ-safe -> HARDIRQ-unsafe lock order detected ]
> > [   79.088631] 3.9.0-13694-g7cf229a-dirty #224212 Tainted: G        W   
> > [   79.088631] ------------------------------------------------------
> > [   79.088631] swapper/0/1 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
> > [   79.088631]  (&hdev->debug_list_lock){+.+...}, at: [<ffffffff82e510d9>] hid_debug_event+0x2e/0xd0
> > [   79.088631] 
> > 
> > See the full bootlog below. It's from an allyesconfig x86-64 bootup log.
> 
> Hi Ingo,
> 
> thanks for the report. I have a fix for this in my tree already and am 
> going to send pull request to Linus shortly.

FYI, the fixes in your tree apparently did not fix the bug - I'm still 
getting the same lockdep splat below.

Thanks,

	Ingo

initcall sensor_hub_driver_init+0x0/0x16 returned 0 after 7779 usecs
calling  hid_init+0x0/0x45 @ 1
bus: 'usb': add driver usbhid
bus: 'usb': driver_probe_device: matched device 2-2:1.0 with driver usbhid
bus: 'usb': really_probe: probing driver usbhid with device 2-2:1.0
usbhid 2-2:1.0: usb_probe_interface
usbhid 2-2:1.0: usb_probe_interface - got id
device: '0003:1241:1503.0001': device_add
bus: 'hid': add device 0003:1241:1503.0001
PM: Adding info for hid:0003:1241:1503.0001
bus: 'hid': driver_probe_device: matched device 0003:1241:1503.0001 with driver hid-generic
bus: 'hid': really_probe: probing driver hid-generic with device 0003:1241:1503.0001
device: 'input2': device_add
PM: Adding info for No Bus:input2
input:   USB Keyboard as /devices/pci0000:00/0000:00:02.0/usb2/2-2/2-2:1.0/input/input2

======================================================
[ INFO: HARDIRQ-safe -> HARDIRQ-unsafe lock order detected ]
3.9.0+ #224324 Not tainted
------------------------------------------------------
swapper/0/1 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
 (&hdev->debug_list_lock){+.+...}, at: [<c1ba316b>] hid_debug_event+0x1e/0xa8

and this task is already holding:
 (&(&usbhid->lock)->rlock){-.....}, at: [<c1bc08e4>] usb_hidinput_input_event+0x7c/0xaf
which would create a new lock dependency:
 (&(&usbhid->lock)->rlock){-.....} -> (&hdev->debug_list_lock){+.+...}

but this new dependency connects a HARDIRQ-irq-safe lock:
 (&(&usbhid->lock)->rlock){-.....}
... which became HARDIRQ-irq-safe at:
  [<c106974e>] __lock_acquire+0x241/0xd54
  [<c106a662>] lock_acquire+0x76/0x8a
  [<c1dbe21a>] _raw_spin_lock+0x3d/0x4a
  [<c1bc0764>] hid_ctrl+0x28/0x12c
  [<c19bfcec>] usb_hcd_giveback_urb+0x40/0x84
  [<c19e15cc>] finish_urb+0xbe/0xf4
  [<c19e163b>] takeback_td+0x39/0x99
  [<c19e1850>] dl_done_list+0x1b5/0x1e4
  [<c19e28a1>] ohci_irq+0x16c/0x27a
  [<c19bf46d>] usb_hcd_irq+0x26/0x4f
  [<c1088cc2>] handle_irq_event_percpu+0x24/0x11f
  [<c1088de9>] handle_irq_event+0x2c/0x43
  [<c108ad05>] handle_fasteoi_irq+0x6a/0x97

to a HARDIRQ-irq-unsafe lock:
 (&hdev->debug_list_lock){+.+...}
... which became HARDIRQ-irq-unsafe at:
...  [<c10697b1>] __lock_acquire+0x2a4/0xd54
  [<c106a662>] lock_acquire+0x76/0x8a
  [<c1dbc602>] __mutex_lock_common+0x4f/0x36f
  [<c1dbc960>] mutex_lock_nested+0x3e/0x44
  [<c1ba316b>] hid_debug_event+0x1e/0xa8
  [<c1ba3300>] hid_dump_input+0x4d/0x78
  [<c1ba47dc>] hid_set_field+0x29/0xab
  [<c1bc16dc>] usbhid_set_leds+0x77/0x8b
  [<c1bc1a8e>] usbhid_start+0x39e/0x3fd
  [<c1ba5047>] hid_device_probe+0xa0/0x109
  [<c161a4a3>] driver_probe_device+0xe2/0x24e
  [<c161a68a>] __device_attach+0x1c/0x2e
  [<c16191eb>] bus_for_each_drv+0x3a/0x6b
  [<c161a22a>] device_attach+0x58/0x69
  [<c1619368>] bus_probe_device+0x22/0x77
  [<c1617d02>] device_add+0x3bc/0x542
  [<c1ba550f>] hid_add_device+0x1f0/0x224
  [<c1bc0583>] usbhid_probe+0x37f/0x3c0
  [<c19c4a99>] usb_probe_interface+0x129/0x17a
  [<c161a4a3>] driver_probe_device+0xe2/0x24e
  [<c161a652>] __driver_attach+0x43/0x5f
  [<c1618f1a>] bus_for_each_dev+0x3e/0x68
  [<c161a252>] driver_attach+0x17/0x19
  [<c161956f>] bus_add_driver+0xd6/0x1e5
  [<c161ab25>] driver_register+0x7c/0xf7
  [<c19c4c14>] usb_register_driver+0x6c/0x111
  [<c2498841>] hid_init+0x26/0x45
  [<c2447a50>] do_one_initcall+0x4b/0x10e
  [<c2447c27>] kernel_init_freeable+0x114/0x1b3
  [<c1d9d9ec>] kernel_init+0xb/0xbe
  [<c1dbf337>] ret_from_kernel_thread+0x1b/0x28

other info that might help us debug this:

 Possible interrupt unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&hdev->debug_list_lock);
                               local_irq_disable();
                               lock(&(&usbhid->lock)->rlock);
                               lock(&hdev->debug_list_lock);
  <Interrupt>
    lock(&(&usbhid->lock)->rlock);

 *** DEADLOCK ***

7 locks held by swapper/0/1:
 #0:  (&__lockdep_no_validate__){......}, at: [<c1619df1>] device_lock+0xd/0xf
 #1:  (&__lockdep_no_validate__){......}, at: [<c1619df1>] device_lock+0xd/0xf
 #2:  (&__lockdep_no_validate__){......}, at: [<c1619df1>] device_lock+0xd/0xf
 #3:  (input_mutex){+.+.+.}, at: [<c1a3a76b>] input_register_device+0x2e3/0x38f
 #4:  (&(&dev->event_lock)->rlock){......}, at: [<c1a39d92>] input_inject_event+0x35/0x75
 #5:  (rcu_read_lock){.+.+..}, at: [<c1a39000>] rcu_lock_acquire.constprop.16+0x0/0x35
 #6:  (&(&usbhid->lock)->rlock){-.....}, at: [<c1bc08e4>] usb_hidinput_input_event+0x7c/0xaf

the dependencies between HARDIRQ-irq-safe lock and the holding lock:
-> (&(&usbhid->lock)->rlock){-.....} ops: 4 {
   IN-HARDIRQ-W at:
                    [<c106974e>] __lock_acquire+0x241/0xd54
                    [<c106a662>] lock_acquire+0x76/0x8a
                    [<c1dbe21a>] _raw_spin_lock+0x3d/0x4a
                    [<c1bc0764>] hid_ctrl+0x28/0x12c
                    [<c19bfcec>] usb_hcd_giveback_urb+0x40/0x84
                    [<c19e15cc>] finish_urb+0xbe/0xf4
                    [<c19e163b>] takeback_td+0x39/0x99
                    [<c19e1850>] dl_done_list+0x1b5/0x1e4
                    [<c19e28a1>] ohci_irq+0x16c/0x27a
                    [<c19bf46d>] usb_hcd_irq+0x26/0x4f
                    [<c1088cc2>] handle_irq_event_percpu+0x24/0x11f
                    [<c1088de9>] handle_irq_event+0x2c/0x43
                    [<c108ad05>] handle_fasteoi_irq+0x6a/0x97
   INITIAL USE at:
                   [<c1069811>] __lock_acquire+0x304/0xd54
                   [<c106a662>] lock_acquire+0x76/0x8a
                   [<c1dbe272>] _raw_spin_lock_irqsave+0x4b/0x5b
                   [<c1bc0d81>] usbhid_submit_report+0x23/0x45
                   [<c1bc15d7>] usbhid_init_reports+0x2a/0xb8
                   [<c1bc1a72>] usbhid_start+0x382/0x3fd
                   [<c1ba5047>] hid_device_probe+0xa0/0x109
                   [<c161a4a3>] driver_probe_device+0xe2/0x24e
                   [<c161a68a>] __device_attach+0x1c/0x2e
                   [<c16191eb>] bus_for_each_drv+0x3a/0x6b
                   [<c161a22a>] device_attach+0x58/0x69
                   [<c1619368>] bus_probe_device+0x22/0x77
                   [<c1617d02>] device_add+0x3bc/0x542
                   [<c1ba550f>] hid_add_device+0x1f0/0x224
                   [<c1bc0583>] usbhid_probe+0x37f/0x3c0
                   [<c19c4a99>] usb_probe_interface+0x129/0x17a
                   [<c161a4a3>] driver_probe_device+0xe2/0x24e
                   [<c161a652>] __driver_attach+0x43/0x5f
                   [<c1618f1a>] bus_for_each_dev+0x3e/0x68
                   [<c161a252>] driver_attach+0x17/0x19
                   [<c161956f>] bus_add_driver+0xd6/0x1e5
                   [<c161ab25>] driver_register+0x7c/0xf7
                   [<c19c4c14>] usb_register_driver+0x6c/0x111
                   [<c2498841>] hid_init+0x26/0x45
                   [<c2447a50>] do_one_initcall+0x4b/0x10e
                   [<c2447c27>] kernel_init_freeable+0x114/0x1b3
                   [<c1d9d9ec>] kernel_init+0xb/0xbe
                   [<c1dbf337>] ret_from_kernel_thread+0x1b/0x28
 }
 ... key      at: [<c2bb56bc>] __key.27543+0x0/0x8
 ... acquired at:
   [<c1067d3d>] check_irq_usage+0x40/0x86
   [<c1069f3f>] __lock_acquire+0xa32/0xd54
   [<c106a662>] lock_acquire+0x76/0x8a
   [<c1dbc602>] __mutex_lock_common+0x4f/0x36f
   [<c1dbc960>] mutex_lock_nested+0x3e/0x44
   [<c1ba316b>] hid_debug_event+0x1e/0xa8
   [<c1ba3300>] hid_dump_input+0x4d/0x78
   [<c1ba47dc>] hid_set_field+0x29/0xab
   [<c1bc08f4>] usb_hidinput_input_event+0x8c/0xaf
   [<c1a39c8f>] input_handle_event+0x376/0x444
   [<c1a39dbb>] input_inject_event+0x5e/0x75
   [<c14ffe22>] kbd_update_leds_helper+0x4e/0x7b
   [<c1500844>] kbd_start+0x2d/0x36
   [<c1a3aa41>] input_register_handle+0x89/0x93
   [<c150023c>] kbd_connect+0x31/0x60
   [<c1a3919d>] input_attach_handler+0x168/0x19e
   [<c1a3a7a5>] input_register_device+0x31d/0x38f
   [<c1ba8fde>] hidinput_connect+0x3a2/0x3e0
   [<c1ba4d91>] hid_connect+0x64/0x27a
   [<c1ba5059>] hid_device_probe+0xb2/0x109
   [<c161a4a3>] driver_probe_device+0xe2/0x24e
   [<c161a68a>] __device_attach+0x1c/0x2e
   [<c16191eb>] bus_for_each_drv+0x3a/0x6b
   [<c161a22a>] device_attach+0x58/0x69
   [<c1619368>] bus_probe_device+0x22/0x77
   [<c1617d02>] device_add+0x3bc/0x542
   [<c1ba550f>] hid_add_device+0x1f0/0x224
   [<c1bc0583>] usbhid_probe+0x37f/0x3c0
   [<c19c4a99>] usb_probe_interface+0x129/0x17a
   [<c161a4a3>] driver_probe_device+0xe2/0x24e
   [<c161a652>] __driver_attach+0x43/0x5f
   [<c1618f1a>] bus_for_each_dev+0x3e/0x68
   [<c161a252>] driver_attach+0x17/0x19
   [<c161956f>] bus_add_driver+0xd6/0x1e5
   [<c161ab25>] driver_register+0x7c/0xf7
   [<c19c4c14>] usb_register_driver+0x6c/0x111
   [<c2498841>] hid_init+0x26/0x45
   [<c2447a50>] do_one_initcall+0x4b/0x10e
   [<c2447c27>] kernel_init_freeable+0x114/0x1b3
   [<c1d9d9ec>] kernel_init+0xb/0xbe
   [<c1dbf337>] ret_from_kernel_thread+0x1b/0x28


the dependencies between the lock to be acquired and HARDIRQ-irq-unsafe lock:
-> (&hdev->debug_list_lock){+.+...} ops: 2 {
   HARDIRQ-ON-W at:
                    [<c10697b1>] __lock_acquire+0x2a4/0xd54
                    [<c106a662>] lock_acquire+0x76/0x8a
                    [<c1dbc602>] __mutex_lock_common+0x4f/0x36f
                    [<c1dbc960>] mutex_lock_nested+0x3e/0x44
                    [<c1ba316b>] hid_debug_event+0x1e/0xa8
                    [<c1ba3300>] hid_dump_input+0x4d/0x78
                    [<c1ba47dc>] hid_set_field+0x29/0xab
                    [<c1bc16dc>] usbhid_set_leds+0x77/0x8b
                    [<c1bc1a8e>] usbhid_start+0x39e/0x3fd
                    [<c1ba5047>] hid_device_probe+0xa0/0x109
                    [<c161a4a3>] driver_probe_device+0xe2/0x24e
                    [<c161a68a>] __device_attach+0x1c/0x2e
                    [<c16191eb>] bus_for_each_drv+0x3a/0x6b
                    [<c161a22a>] device_attach+0x58/0x69
                    [<c1619368>] bus_probe_device+0x22/0x77
                    [<c1617d02>] device_add+0x3bc/0x542
                    [<c1ba550f>] hid_add_device+0x1f0/0x224
                    [<c1bc0583>] usbhid_probe+0x37f/0x3c0
                    [<c19c4a99>] usb_probe_interface+0x129/0x17a
                    [<c161a4a3>] driver_probe_device+0xe2/0x24e
                    [<c161a652>] __driver_attach+0x43/0x5f
                    [<c1618f1a>] bus_for_each_dev+0x3e/0x68
                    [<c161a252>] driver_attach+0x17/0x19
                    [<c161956f>] bus_add_driver+0xd6/0x1e5
                    [<c161ab25>] driver_register+0x7c/0xf7
                    [<c19c4c14>] usb_register_driver+0x6c/0x111
                    [<c2498841>] hid_init+0x26/0x45
                    [<c2447a50>] do_one_initcall+0x4b/0x10e
                    [<c2447c27>] kernel_init_freeable+0x114/0x1b3
                    [<c1d9d9ec>] kernel_init+0xb/0xbe
                    [<c1dbf337>] ret_from_kernel_thread+0x1b/0x28
   SOFTIRQ-ON-W at:
                    [<c10697d0>] __lock_acquire+0x2c3/0xd54
                    [<c106a662>] lock_acquire+0x76/0x8a
                    [<c1dbc602>] __mutex_lock_common+0x4f/0x36f
                    [<c1dbc960>] mutex_lock_nested+0x3e/0x44
                    [<c1ba316b>] hid_debug_event+0x1e/0xa8
                    [<c1ba3300>] hid_dump_input+0x4d/0x78
                    [<c1ba47dc>] hid_set_field+0x29/0xab
                    [<c1bc16dc>] usbhid_set_leds+0x77/0x8b
                    [<c1bc1a8e>] usbhid_start+0x39e/0x3fd
                    [<c1ba5047>] hid_device_probe+0xa0/0x109
                    [<c161a4a3>] driver_probe_device+0xe2/0x24e
                    [<c161a68a>] __device_attach+0x1c/0x2e
                    [<c16191eb>] bus_for_each_drv+0x3a/0x6b
                    [<c161a22a>] device_attach+0x58/0x69
                    [<c1619368>] bus_probe_device+0x22/0x77
                    [<c1617d02>] device_add+0x3bc/0x542
                    [<c1ba550f>] hid_add_device+0x1f0/0x224
                    [<c1bc0583>] usbhid_probe+0x37f/0x3c0
                    [<c19c4a99>] usb_probe_interface+0x129/0x17a
                    [<c161a4a3>] driver_probe_device+0xe2/0x24e
                    [<c161a652>] __driver_attach+0x43/0x5f
                    [<c1618f1a>] bus_for_each_dev+0x3e/0x68
                    [<c161a252>] driver_attach+0x17/0x19
                    [<c161956f>] bus_add_driver+0xd6/0x1e5
                    [<c161ab25>] driver_register+0x7c/0xf7
                    [<c19c4c14>] usb_register_driver+0x6c/0x111
                    [<c2498841>] hid_init+0x26/0x45
                    [<c2447a50>] do_one_initcall+0x4b/0x10e
                    [<c2447c27>] kernel_init_freeable+0x114/0x1b3
                    [<c1d9d9ec>] kernel_init+0xb/0xbe
                    [<c1dbf337>] ret_from_kernel_thread+0x1b/0x28
   INITIAL USE at:
                   [<c1069811>] __lock_acquire+0x304/0xd54
                   [<c106a662>] lock_acquire+0x76/0x8a
                   [<c1dbc602>] __mutex_lock_common+0x4f/0x36f
                   [<c1dbc960>] mutex_lock_nested+0x3e/0x44
                   [<c1ba316b>] hid_debug_event+0x1e/0xa8
                   [<c1ba3300>] hid_dump_input+0x4d/0x78
                   [<c1ba47dc>] hid_set_field+0x29/0xab
                   [<c1bc16dc>] usbhid_set_leds+0x77/0x8b
                   [<c1bc1a8e>] usbhid_start+0x39e/0x3fd
                   [<c1ba5047>] hid_device_probe+0xa0/0x109
                   [<c161a4a3>] driver_probe_device+0xe2/0x24e
                   [<c161a68a>] __device_attach+0x1c/0x2e
                   [<c16191eb>] bus_for_each_drv+0x3a/0x6b
                   [<c161a22a>] device_attach+0x58/0x69
                   [<c1619368>] bus_probe_device+0x22/0x77
                   [<c1617d02>] device_add+0x3bc/0x542
                   [<c1ba550f>] hid_add_device+0x1f0/0x224
                   [<c1bc0583>] usbhid_probe+0x37f/0x3c0
                   [<c19c4a99>] usb_probe_interface+0x129/0x17a
                   [<c161a4a3>] driver_probe_device+0xe2/0x24e
                   [<c161a652>] __driver_attach+0x43/0x5f
                   [<c1618f1a>] bus_for_each_dev+0x3e/0x68
                   [<c161a252>] driver_attach+0x17/0x19
                   [<c161956f>] bus_add_driver+0xd6/0x1e5
                   [<c161ab25>] driver_register+0x7c/0xf7
                   [<c19c4c14>] usb_register_driver+0x6c/0x111
                   [<c2498841>] hid_init+0x26/0x45
                   [<c2447a50>] do_one_initcall+0x4b/0x10e
                   [<c2447c27>] kernel_init_freeable+0x114/0x1b3
                   [<c1d9d9ec>] kernel_init+0xb/0xbe
                   [<c1dbf337>] ret_from_kernel_thread+0x1b/0x28
 }
 ... key      at: [<c2bb5340>] __key.24951+0x0/0x8
 ... acquired at:
   [<c1067d3d>] check_irq_usage+0x40/0x86
   [<c1069f3f>] __lock_acquire+0xa32/0xd54
   [<c106a662>] lock_acquire+0x76/0x8a
   [<c1dbc602>] __mutex_lock_common+0x4f/0x36f
   [<c1dbc960>] mutex_lock_nested+0x3e/0x44
   [<c1ba316b>] hid_debug_event+0x1e/0xa8
   [<c1ba3300>] hid_dump_input+0x4d/0x78
   [<c1ba47dc>] hid_set_field+0x29/0xab
   [<c1bc08f4>] usb_hidinput_input_event+0x8c/0xaf
   [<c1a39c8f>] input_handle_event+0x376/0x444
   [<c1a39dbb>] input_inject_event+0x5e/0x75
   [<c14ffe22>] kbd_update_leds_helper+0x4e/0x7b
   [<c1500844>] kbd_start+0x2d/0x36
   [<c1a3aa41>] input_register_handle+0x89/0x93
   [<c150023c>] kbd_connect+0x31/0x60
   [<c1a3919d>] input_attach_handler+0x168/0x19e
   [<c1a3a7a5>] input_register_device+0x31d/0x38f
   [<c1ba8fde>] hidinput_connect+0x3a2/0x3e0
   [<c1ba4d91>] hid_connect+0x64/0x27a
   [<c1ba5059>] hid_device_probe+0xb2/0x109
   [<c161a4a3>] driver_probe_device+0xe2/0x24e
   [<c161a68a>] __device_attach+0x1c/0x2e
   [<c16191eb>] bus_for_each_drv+0x3a/0x6b
   [<c161a22a>] device_attach+0x58/0x69
   [<c1619368>] bus_probe_device+0x22/0x77
   [<c1617d02>] device_add+0x3bc/0x542
   [<c1ba550f>] hid_add_device+0x1f0/0x224
   [<c1bc0583>] usbhid_probe+0x37f/0x3c0
   [<c19c4a99>] usb_probe_interface+0x129/0x17a
   [<c161a4a3>] driver_probe_device+0xe2/0x24e
   [<c161a652>] __driver_attach+0x43/0x5f
   [<c1618f1a>] bus_for_each_dev+0x3e/0x68
   [<c161a252>] driver_attach+0x17/0x19
   [<c161956f>] bus_add_driver+0xd6/0x1e5
   [<c161ab25>] driver_register+0x7c/0xf7
   [<c19c4c14>] usb_register_driver+0x6c/0x111
   [<c2498841>] hid_init+0x26/0x45
   [<c2447a50>] do_one_initcall+0x4b/0x10e
   [<c2447c27>] kernel_init_freeable+0x114/0x1b3
   [<c1d9d9ec>] kernel_init+0xb/0xbe
   [<c1dbf337>] ret_from_kernel_thread+0x1b/0x28


stack backtrace:
CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.9.0+ #224324
Hardware name: System manufacturer System Product Name/A8N-E, BIOS ASUS A8N-E ACPI BIOS Revision 1008 08/22/2005
 c21546c7 c21546c7 f647b884 c1daff0d f647b918 c1067cf3 c2153749 c21546c7
 00000001 00000000 00000000 00000000 00000000 00000000 00000001 f647b8c4
 c27d5bf8 c27d5ae8 f647b8c4 f647b8e8 c21546b7 f6480000 c27d5ae8 00000029
Call Trace:
 [<c1daff0d>] dump_stack+0x16/0x18
 [<c1067cf3>] check_usage+0x2df/0x2e9
 [<c106702f>] ? __bfs+0x13/0x17e
 [<c1067d3d>] check_irq_usage+0x40/0x86
 [<c1069f3f>] __lock_acquire+0xa32/0xd54
 [<c1067a47>] ? check_usage+0x33/0x2e9
 [<c10672b0>] ? find_usage_backwards+0x58/0x5f
 [<c1067a47>] ? check_usage+0x33/0x2e9
 [<c106a662>] lock_acquire+0x76/0x8a
 [<c1ba316b>] ? hid_debug_event+0x1e/0xa8
 [<c1dbc602>] __mutex_lock_common+0x4f/0x36f
 [<c1ba316b>] ? hid_debug_event+0x1e/0xa8
 [<c13c70b1>] ? vsnprintf+0x149/0x2a2
 [<c10bfd9f>] ? kmem_cache_alloc+0xbb/0xe9
 [<c1dbc960>] mutex_lock_nested+0x3e/0x44
 [<c1ba316b>] ? hid_debug_event+0x1e/0xa8
 [<c1ba316b>] hid_debug_event+0x1e/0xa8
 [<c1ba3300>] hid_dump_input+0x4d/0x78
 [<c1ba47dc>] hid_set_field+0x29/0xab
 [<c1dbe279>] ? _raw_spin_lock_irqsave+0x52/0x5b
 [<c1bc08f4>] usb_hidinput_input_event+0x8c/0xaf
 [<c1bc0868>] ? hid_ctrl+0x12c/0x12c
 [<c1a39c8f>] input_handle_event+0x376/0x444
 [<c1bc0868>] ? hid_ctrl+0x12c/0x12c
 [<c1a39dbb>] input_inject_event+0x5e/0x75
 [<c14ffe22>] kbd_update_leds_helper+0x4e/0x7b
 [<c1500844>] kbd_start+0x2d/0x36
 [<c1a3aa41>] input_register_handle+0x89/0x93
 [<c150023c>] kbd_connect+0x31/0x60
 [<c1a3919d>] input_attach_handler+0x168/0x19e
 [<c1a3a7a5>] input_register_device+0x31d/0x38f
 [<c1ba8fde>] hidinput_connect+0x3a2/0x3e0
 [<c1ba4d91>] hid_connect+0x64/0x27a
 [<c1068472>] ? trace_hardirqs_on+0xb/0xd
 [<c1dbe3b0>] ? _raw_spin_unlock_irq+0x22/0x30
 [<c161feb0>] ? device_wakeup_enable+0x62/0x77
 [<c161fede>] ? device_set_wakeup_enable+0x19/0x2a
 [<c1bc1a9b>] ? usbhid_start+0x3ab/0x3fd
 [<c1ba466e>] ? hid_open_report+0x178/0x1fd
 [<c1ba4c96>] ? hid_match_id+0x14/0x29
 [<c1ba5059>] hid_device_probe+0xb2/0x109
 [<c161a4a3>] driver_probe_device+0xe2/0x24e
 [<c161a68a>] __device_attach+0x1c/0x2e
 [<c16191eb>] bus_for_each_drv+0x3a/0x6b
 [<c161a22a>] device_attach+0x58/0x69
 [<c161a66e>] ? __driver_attach+0x5f/0x5f
 [<c1619368>] bus_probe_device+0x22/0x77
 [<c1617d02>] device_add+0x3bc/0x542
 [<c1ba550f>] hid_add_device+0x1f0/0x224
 [<c10c0000>] ? kmem_cache_open+0xf6/0x254
 [<c1bc0583>] usbhid_probe+0x37f/0x3c0
 [<c19c4a99>] usb_probe_interface+0x129/0x17a
 [<c161a4a3>] driver_probe_device+0xe2/0x24e
 [<c161a652>] __driver_attach+0x43/0x5f
 [<c1618f1a>] bus_for_each_dev+0x3e/0x68
 [<c161a252>] driver_attach+0x17/0x19
 [<c161a60f>] ? driver_probe_device+0x24e/0x24e
 [<c161956f>] bus_add_driver+0xd6/0x1e5
 [<c161ab25>] driver_register+0x7c/0xf7
 [<c13d6b9d>] ? __raw_spin_lock_init+0x2d/0x4d
 [<c19c4c14>] usb_register_driver+0x6c/0x111
 [<c105f325>] ? timekeeping_get_ns.constprop.9+0xf/0x54
 [<c2498841>] hid_init+0x26/0x45
 [<c249881b>] ? sensor_hub_driver_init+0x16/0x16
 [<c2447a50>] do_one_initcall+0x4b/0x10e
 [<c249881b>] ? sensor_hub_driver_init+0x16/0x16
 [<c2447c27>] kernel_init_freeable+0x114/0x1b3
 [<c24473c1>] ? loglevel+0x2b/0x2b
 [<c1d9d9ec>] kernel_init+0xb/0xbe
 [<c1dbf337>] ret_from_kernel_thread+0x1b/0x28
 [<c1d9d9e1>] ? rest_init+0xc1/0xc1
device: 'event2': device_add
PM: Adding info for No Bus:event2
evbug: Connected device: input2 (  USB Keyboard at usb-0000:00:02.0-2/input0)
device: 'hidraw0': device_add
PM: Adding info for No Bus:hidraw0
hid-generic 0003:1241:1503.0001: input,hidraw0: USB HID v1.10 Keyboard [  USB Keyboard] on usb-0000:00:02.0-2/input0
driver: '0003:1241:1503.0001': driver_bound: bound to device 'hid-generic'
bus: 'hid': really_probe: bound device 0003:1241:1503.0001 to driver hid-generic
driver: '2-2:1.0': driver_bound: bound to device 'usbhid'
bus: 'usb': really_probe: bound device 2-2:1.0 to driver usbhid
bus: 'usb': driver_probe_device: matched device 2-2:1.1 with driver usbhid
bus: 'usb': really_probe: probing driver usbhid with device 2-2:1.1
usbhid 2-2:1.1: usb_probe_interface
usbhid 2-2:1.1: usb_probe_interface - got id
device: '0003:1241:1503.0002': device_add
bus: 'hid': add device 0003:1241:1503.0002
PM: Adding info for hid:0003:1241:1503.0002
bus: 'hid': driver_probe_device: matched device 0003:1241:1503.0002 with driver hid-generic
bus: 'hid': really_probe: probing driver hid-generic with device 0003:1241:1503.0002
device: 'input3': device_add
PM: Adding info for No Bus:input3
input:   USB Keyboard as /devices/pci0000:00/0000:00:02.0/usb2/2-2/2-2:1.1/input/input3
device: 'event3': device_add
PM: Adding info for No Bus:event3
evbug: Connected device: input3 (  USB Keyboard at usb-0000:00:02.0-2/input1)
device: 'hidraw1': device_add
PM: Adding info for No Bus:hidraw1
hid-generic 0003:1241:1503.0002: input,hidraw1: USB HID v1.10 Device [  USB Keyboard] on usb-0000:00:02.0-2/input1
driver: '0003:1241:1503.0002': driver_bound: bound to device 'hid-generic'
bus: 'hid': really_probe: bound device 0003:1241:1503.0002 to driver hid-generic
driver: '2-2:1.1': driver_bound: bound to device 'usbhid'
bus: 'usb': really_probe: bound device 2-2:1.1 to driver usbhid
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
