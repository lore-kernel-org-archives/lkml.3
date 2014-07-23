Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757827AbaGWJxf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 05:53:35 -0400
Received: from mail.skyhub.de ([78.46.96.112]:38361 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757611AbaGWJxc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 05:53:32 -0400
Date: Wed, 23 Jul 2014 11:53:27 +0200
From: Borislav Petkov <bp@alien8.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-usb@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: Linux 3.16-rc6
Message-ID: <20140723095327.GA23131@pd.tnic>
References: <CA+55aFzJKxzw_as9iGgeM=MdQ6trUkQLDuoEr8nxj88sOqQnQA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+55aFzJKxzw_as9iGgeM=MdQ6trUkQLDuoEr8nxj88sOqQnQA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 20, 2014 at 09:22:52PM -0700, Linus Torvalds wrote:
> So go get the latest rc and kick the tires, to see that nothing has
> fallen through the cracks, ok?

Well, it looks like we f*cked up something after -rc5 since I'm starting
to see lockdep splats all over the place which I didn't see before. I'm
running rc6 + tip/master.

There was one in r8169 yesterday:

https://lkml.kernel.org/r/20140722081840.GA6462@pd.tnic

and now I'm seeing the following in a kvm guest. I'm adding some more
lists to CC which look like might be related, judging from the stack
traces.

---

...

[    9.456211] EXT3-fs (sda1): using internal journal
[   24.623666] 8139cp 0000:00:03.0 eth0: link up, 100Mbps, full-duplex, lpa 0x05E1
[   28.346202] mtrr: no MTRR for fc000000,100000 found
[   31.704053] 
[   31.704282] =========================================================
[   31.704282] [ INFO: possible irq lock inversion dependency detected ]
[   31.704282] 3.16.0-rc6+ #1 Not tainted
[   31.704282] ---------------------------------------------------------
[   31.704282] Xorg/3484 just changed the state of lock:
[   31.704282]  (tasklist_lock){.?.+..}, at: [<ffffffff81184b19>] send_sigio+0x59/0x1b0
[   31.704282] but this lock took another, HARDIRQ-unsafe lock in the past:
[   31.704282]  (&(&p->alloc_lock)->rlock){+.+...}

and interrupts could create inverse lock ordering between them.

[   31.704282] 
[   31.704282] other info that might help us debug this:
[   31.704282]  Possible interrupt unsafe locking scenario:
[   31.704282] 
[   31.704282]        CPU0                    CPU1
[   31.704282]        ----                    ----
[   31.704282]   lock(&(&p->alloc_lock)->rlock);
[   31.704282]                                local_irq_disable();
[   31.704282]                                lock(tasklist_lock);
[   31.704282]                                lock(&(&p->alloc_lock)->rlock);
[   31.704282]   <Interrupt>
[   31.704282]     lock(tasklist_lock);
[   31.704282] 
[   31.704282]  *** DEADLOCK ***
[   31.704282] 
[   31.704282] 7 locks held by Xorg/3484:
[   31.704282]  #0:  (&(&dev->event_lock)->rlock){-.....}, at: [<ffffffff8148c20d>] input_event+0x4d/0x90
[   31.704282]  #1:  (rcu_read_lock){......}, at: [<ffffffff8148b365>] input_pass_values.part.3+0x5/0x360
[   31.704282]  #2:  (rcu_read_lock){......}, at: [<ffffffff814915a5>] evdev_events+0x5/0x2e0
[   31.704282]  #3:  (&(&client->buffer_lock)->rlock){-.....}, at: [<ffffffff81490743>] evdev_pass_values+0x63/0x1d0
[   31.704282]  #4:  (rcu_read_lock){......}, at: [<ffffffff81184c7f>] kill_fasync+0xf/0x290
[   31.704282]  #5:  (&(&new->fa_lock)->rlock){-.....}, at: [<ffffffff81184d06>] kill_fasync+0x96/0x290
[   31.704282]  #6:  (&f->f_owner.lock){.-....}, at: [<ffffffff81184ae4>] send_sigio+0x24/0x1b0
[   31.704282] 
[   31.704282] the shortest dependencies between 2nd lock and 1st lock:
[   31.704282]  -> (&(&p->alloc_lock)->rlock){+.+...} ops: 35104 {
[   31.704282]     HARDIRQ-ON-W at:
[   31.704282]                       [<ffffffff8109a362>] __lock_acquire+0x952/0x2230
[   31.704282]                       [<ffffffff8109c449>] lock_acquire+0xb9/0x200
[   31.704282]                       [<ffffffff8161f8d1>] _raw_spin_lock+0x41/0x80
[   31.704282]                       [<ffffffff811793c9>] __set_task_comm+0x39/0x180
[   31.704282]                       [<ffffffff81073c35>] kthreadd+0x45/0x150
[   31.704282]                       [<ffffffff81620b6c>] ret_from_fork+0x7c/0xb0
[   31.704282]     SOFTIRQ-ON-W at:
[   31.704282]                       [<ffffffff8109a395>] __lock_acquire+0x985/0x2230
[   31.704282]                       [<ffffffff8109c449>] lock_acquire+0xb9/0x200
[   31.704282]                       [<ffffffff8161f8d1>] _raw_spin_lock+0x41/0x80
[   31.704282]                       [<ffffffff811793c9>] __set_task_comm+0x39/0x180
[   31.704282]                       [<ffffffff81073c35>] kthreadd+0x45/0x150
[   31.704282]                       [<ffffffff81620b6c>] ret_from_fork+0x7c/0xb0
[   31.704282]     INITIAL USE at:
[   31.704282]                      [<ffffffff81099e53>] __lock_acquire+0x443/0x2230
[   31.704282]                      [<ffffffff8109c449>] lock_acquire+0xb9/0x200
[   31.704282]                      [<ffffffff8161f8d1>] _raw_spin_lock+0x41/0x80
[   31.704282]                      [<ffffffff811793c9>] __set_task_comm+0x39/0x180
[   31.704282]                      [<ffffffff81073c35>] kthreadd+0x45/0x150
[   31.704282]                      [<ffffffff81620b6c>] ret_from_fork+0x7c/0xb0
[   31.704282]   }
[   31.704282]   ... key      at: [<ffffffff81cc4ae8>] __key.47760+0x0/0x8
[   31.704282]   ... acquired at:
[   31.704282]    [<ffffffff8109c449>] lock_acquire+0xb9/0x200
[   31.704282]    [<ffffffff8161f8d1>] _raw_spin_lock+0x41/0x80
[   31.704282]    [<ffffffff81066b45>] do_prlimit+0x205/0x250
[   31.704282]    [<ffffffff81066bba>] SyS_getrlimit+0x2a/0x70
[   31.704282]    [<ffffffff81620c16>] system_call_fastpath+0x1a/0x1f
[   31.704282] 
[   31.704282] -> (tasklist_lock){.?.+..} ops: 22947 {
[   31.704282]    IN-HARDIRQ-R at:
[   31.704282]                     [<ffffffff8109a5a3>] __lock_acquire+0xb93/0x2230
[   31.704282]                     [<ffffffff8109c449>] lock_acquire+0xb9/0x200
[   31.704282]                     [<ffffffff8161fe14>] _raw_read_lock+0x44/0x80
[   31.704282]                     [<ffffffff81184b19>] send_sigio+0x59/0x1b0
[   31.704282]                     [<ffffffff81184d34>] kill_fasync+0xc4/0x290
[   31.704282]                     [<ffffffff81490776>] evdev_pass_values+0x96/0x1d0
[   31.704282]                     [<ffffffff814917bc>] evdev_events+0x21c/0x2e0
[   31.704282]                     [<ffffffff81489691>] input_to_handler+0x91/0x100
[   31.704282]                     [<ffffffff8148b624>] input_pass_values.part.3+0x2c4/0x360
[   31.704282]                     [<ffffffff8148bd1a>] input_handle_event+0xda/0x580
[   31.704282]                     [<ffffffff8148c220>] input_event+0x60/0x90
[   31.704282]                     [<ffffffff814c546f>] hidinput_report_event+0x3f/0x50
[   31.704282]                     [<ffffffff814c3635>] hid_report_raw_event+0x285/0x420
[   31.704282]                     [<ffffffff814c38f1>] hid_input_report+0x121/0x1a0
[   31.704282]                     [<ffffffff814d1300>] hid_irq_in+0x80/0x1f0
[   31.704282]                     [<ffffffff81448c98>] __usb_hcd_giveback_urb+0x68/0x100
[   31.704282]                     [<ffffffff81448d7a>] usb_hcd_giveback_urb+0x4a/0x140
[   31.704282]                     [<ffffffff8146ba38>] uhci_giveback_urb+0xb8/0x210
[   31.704282]                     [<ffffffff8146c4a2>] uhci_scan_schedule.part.32+0x542/0xb60
[   31.704282]                     [<ffffffff8146d351>] uhci_irq+0xf1/0x190
[   31.704282]                     [<ffffffff81448285>] usb_hcd_irq+0x25/0x40
[   31.704282]                     [<ffffffff810af329>] handle_irq_event_percpu+0x39/0x350
[   31.704282]                     [<ffffffff810af688>] handle_irq_event+0x48/0x70
[   31.704282]                     [<ffffffff810b2a60>] handle_fasteoi_irq+0xa0/0x180
[   31.704282]                     [<ffffffff810055ce>] handle_irq+0x1e/0x30
[   31.704282]                     [<ffffffff81623618>] do_IRQ+0x68/0x110
[   31.704282]                     [<ffffffff8162186f>] ret_from_intr+0x0/0x13
[   31.704282]    HARDIRQ-ON-R at:
[   31.704282]                     [<ffffffff81099dac>] __lock_acquire+0x39c/0x2230
[   31.704282]                     [<ffffffff8109c449>] lock_acquire+0xb9/0x200
[   31.704282]                     [<ffffffff8161fe14>] _raw_read_lock+0x44/0x80
[   31.704282]                     [<ffffffff81053109>] do_wait+0xe9/0x370
[   31.704282]                     [<ffffffff810537a5>] SyS_wait4+0x75/0xf0
[   31.704282]                     [<ffffffff81067f0b>] wait_for_helper+0x4b/0x70
[   31.704282]                     [<ffffffff81620b6c>] ret_from_fork+0x7c/0xb0
[   31.704282]    SOFTIRQ-ON-R at:
[   31.704282]                     [<ffffffff8109a395>] __lock_acquire+0x985/0x2230
[   31.704282]                     [<ffffffff8109c449>] lock_acquire+0xb9/0x200
[   31.704282]                     [<ffffffff8161fe14>] _raw_read_lock+0x44/0x80
[   31.704282]                     [<ffffffff81053109>] do_wait+0xe9/0x370
[   31.704282]                     [<ffffffff810537a5>] SyS_wait4+0x75/0xf0
[   31.704282]                     [<ffffffff81067f0b>] wait_for_helper+0x4b/0x70
[   31.704282]                     [<ffffffff81620b6c>] ret_from_fork+0x7c/0xb0
[   31.704282]    INITIAL USE at:
[   31.704282]                    [<ffffffff81099e53>] __lock_acquire+0x443/0x2230
[   31.704282]                    [<ffffffff8109c449>] lock_acquire+0xb9/0x200
[   31.704282]                    [<ffffffff816202c7>] _raw_write_lock_irq+0x47/0x80
[   31.704282]                    [<ffffffff8104dd5a>] copy_process.part.51+0xe5a/0x19d0
[   31.704282]                    [<ffffffff8104ea97>] do_fork+0xe7/0x770
[   31.704282]                    [<ffffffff8104f146>] kernel_thread+0x26/0x30
[   31.704282]                    [<ffffffff81614922>] rest_init+0x22/0x140
[   31.704282]                    [<ffffffff81b90e3e>] start_kernel+0x408/0x415
[   31.704282]                    [<ffffffff81b90463>] x86_64_start_reservations+0x2a/0x2c
[   31.704282]                    [<ffffffff81b9055b>] x86_64_start_kernel+0xf6/0xf9
[   31.704282]  }
[   31.704282]  ... key      at: [<ffffffff818ff098>] tasklist_lock+0x18/0x80
[   31.704282]  ... acquired at:
[   31.704282]    [<ffffffff8109636b>] check_usage_forwards+0x15b/0x160
[   31.704282]    [<ffffffff81097188>] mark_lock+0x3d8/0x760
[   32.044737]    [<ffffffff8109a5a3>] __lock_acquire+0xb93/0x2230
[   32.044737]    [<ffffffff8109c449>] lock_acquire+0xb9/0x200
[   32.044737]    [<ffffffff8161fe14>] _raw_read_lock+0x44/0x80
[   32.044737]    [<ffffffff81184b19>] send_sigio+0x59/0x1b0
[   32.044737]    [<ffffffff81184d34>] kill_fasync+0xc4/0x290
[   32.044737]    [<ffffffff81490776>] evdev_pass_values+0x96/0x1d0
[   32.044737]    [<ffffffff814917bc>] evdev_events+0x21c/0x2e0
[   32.044737]    [<ffffffff81489691>] input_to_handler+0x91/0x100
[   32.044737]    [<ffffffff8148b624>] input_pass_values.part.3+0x2c4/0x360
[   32.044737]    [<ffffffff8148bd1a>] input_handle_event+0xda/0x580
[   32.044737]    [<ffffffff8148c220>] input_event+0x60/0x90
[   32.044737]    [<ffffffff814c546f>] hidinput_report_event+0x3f/0x50
[   32.044737]    [<ffffffff814c3635>] hid_report_raw_event+0x285/0x420
[   32.044737]    [<ffffffff814c38f1>] hid_input_report+0x121/0x1a0
[   32.044737]    [<ffffffff814d1300>] hid_irq_in+0x80/0x1f0
[   32.044737]    [<ffffffff81448c98>] __usb_hcd_giveback_urb+0x68/0x100
[   32.044737]    [<ffffffff81448d7a>] usb_hcd_giveback_urb+0x4a/0x140
[   32.044737]    [<ffffffff8146ba38>] uhci_giveback_urb+0xb8/0x210
[   32.044737]    [<ffffffff8146c4a2>] uhci_scan_schedule.part.32+0x542/0xb60
[   32.044737]    [<ffffffff8146d351>] uhci_irq+0xf1/0x190
[   32.044737]    [<ffffffff81448285>] usb_hcd_irq+0x25/0x40
[   32.044737]    [<ffffffff810af329>] handle_irq_event_percpu+0x39/0x350
[   32.044737]    [<ffffffff810af688>] handle_irq_event+0x48/0x70
[   32.044737]    [<ffffffff810b2a60>] handle_fasteoi_irq+0xa0/0x180
[   32.044737]    [<ffffffff810055ce>] handle_irq+0x1e/0x30
[   32.044737]    [<ffffffff81623618>] do_IRQ+0x68/0x110
[   32.044737]    [<ffffffff8162186f>] ret_from_intr+0x0/0x13
[   32.044737] 
[   32.044737] 
[   32.044737] stack backtrace:
[   32.044737] CPU: 0 PID: 3484 Comm: Xorg Not tainted 3.16.0-rc6+ #1
[   32.044737] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.7.5-0-ge51488c-20140602_164612-nilsson.home.kraxel.org 04/01/2014
[   32.044737]  ffffffff8280ddc0 ffff88007be03770 ffffffff8161874e ffffffff8280ddc0
[   32.044737]  ffff88007be037b0 ffffffff81617b6f ffffffff8183b4f6 ffff880079da4300
[   32.044737]  ffff880079da3a50 ffffffff8183b4f6 0000000000000000 ffffffff8280ddc0
[   32.044737] Call Trace:
[   32.044737]  <IRQ>  [<ffffffff8161874e>] dump_stack+0x4e/0x7a
[   32.044737]  [<ffffffff81617b6f>] print_irq_inversion_bug.part.31+0x1b8/0x1c4
[   32.044737]  [<ffffffff8109636b>] check_usage_forwards+0x15b/0x160
[   32.044737]  [<ffffffff81097188>] mark_lock+0x3d8/0x760
[   32.044737]  [<ffffffff81096210>] ? print_shortest_lock_dependencies+0x1d0/0x1d0
[   32.044737]  [<ffffffff8109a5a3>] __lock_acquire+0xb93/0x2230
[   32.044737]  [<ffffffff8109c449>] lock_acquire+0xb9/0x200
[   32.044737]  [<ffffffff81184b19>] ? send_sigio+0x59/0x1b0
[   32.044737]  [<ffffffff8161fe14>] _raw_read_lock+0x44/0x80
[   32.044737]  [<ffffffff81184b19>] ? send_sigio+0x59/0x1b0
[   32.044737]  [<ffffffff81184b19>] send_sigio+0x59/0x1b0
[   32.044737]  [<ffffffff81184d34>] kill_fasync+0xc4/0x290
[   32.044737]  [<ffffffff81184c7f>] ? kill_fasync+0xf/0x290
[   32.044737]  [<ffffffff81490776>] evdev_pass_values+0x96/0x1d0
[   32.044737]  [<ffffffff814917bc>] evdev_events+0x21c/0x2e0
[   32.044737]  [<ffffffff814915a5>] ? evdev_events+0x5/0x2e0
[   32.044737]  [<ffffffff81489691>] input_to_handler+0x91/0x100
[   32.044737]  [<ffffffff8148b624>] input_pass_values.part.3+0x2c4/0x360
[   32.044737]  [<ffffffff8148b365>] ? input_pass_values.part.3+0x5/0x360
[   32.044737]  [<ffffffff8148bd1a>] input_handle_event+0xda/0x580
[   32.044737]  [<ffffffff8148c220>] input_event+0x60/0x90
[   32.044737]  [<ffffffff814c546f>] hidinput_report_event+0x3f/0x50
[   32.044737]  [<ffffffff814c3635>] hid_report_raw_event+0x285/0x420
[   32.044737]  [<ffffffff814c38f1>] hid_input_report+0x121/0x1a0
[   32.044737]  [<ffffffff814d1300>] hid_irq_in+0x80/0x1f0
[   32.044737]  [<ffffffff81448c98>] __usb_hcd_giveback_urb+0x68/0x100
[   32.044737]  [<ffffffff81448d7a>] usb_hcd_giveback_urb+0x4a/0x140
[   32.044737]  [<ffffffff8146ba38>] uhci_giveback_urb+0xb8/0x210
[   32.044737]  [<ffffffff8146c4a2>] uhci_scan_schedule.part.32+0x542/0xb60
[   32.044737]  [<ffffffff8146d2d2>] ? uhci_irq+0x72/0x190
[   32.044737]  [<ffffffff8146d351>] uhci_irq+0xf1/0x190
[   32.044737]  [<ffffffff81448285>] usb_hcd_irq+0x25/0x40
[   32.044737]  [<ffffffff810af329>] handle_irq_event_percpu+0x39/0x350
[   32.044737]  [<ffffffff810af688>] handle_irq_event+0x48/0x70
[   32.044737]  [<ffffffff810b2a60>] handle_fasteoi_irq+0xa0/0x180
[   32.044737]  [<ffffffff810055ce>] handle_irq+0x1e/0x30
[   32.044737]  [<ffffffff81623618>] do_IRQ+0x68/0x110
[   32.044737]  [<ffffffff8162186f>] common_interrupt+0x6f/0x6f
[   32.044737]  <EOI>  [<ffffffff81621911>] ? retint_swapgs+0xe/0x13

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
