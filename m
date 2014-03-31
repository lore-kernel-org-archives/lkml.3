Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751297AbaCaWbx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 18:31:53 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:60935 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbaCaWbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 18:31:52 -0400
MIME-Version: 1.0
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 31 Mar 2014 15:31:30 -0700
Message-ID: <CALCETrWuUcinbJ5v2LzaFWEg1vkBAB2H8rD9x0jccawwRwb4pQ@mail.gmail.com>
Subject: OOPS in hvc / virtconsole
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linuxppc-dev@lists.ozlabs.org, virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm running a Fedora distro kernel (3.13.7-200.fc20.x86_64) in kvm
with these options:

-chardev null,id=hvc0,signal=off
-device virtio-serial-pci
-device virtconsole,chardev=hvc0,name=virtme_console
-append console=hvc0 console=ttyS0
-nographic

(There are more, but these are the interesting ones, I think.)

Note that virtio_console is modular, which might be a problem.

It blows up like this:

[    0.443591] kernel tried to execute NX-protected page - exploit
attempt? (uid: 0)
[    0.444004] BUG: unable to handle kernel paging request at ffffffff81d69c60
[    0.444004] IP: [<ffffffff81d69c60>] hvc_console_setup+0x0/0x24
[    0.444004] PGD 1c0f067 PUD 1c10063 PMD 7bcb9063 PTE 8000000001d69163
[    0.444004] Oops: 0011 [#1] SMP
[    0.444004] Modules linked in: virtio_pci virtio_console
9pnet_virtio virtio_ring virtio 9p 9pnet fscache
[    0.444004] CPU: 0 PID: 71 Comm: kworker/0:3 Not tainted
3.13.7-200.fc20.x86_64 #1
[    0.444004] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.444004] Workqueue: events control_work_handler [virtio_console]
[    0.444004] task: ffff88007bc04500 ti: ffff88007bcca000 task.ti:
ffff88007bcca000
[    0.444004] RIP: 0010:[<ffffffff81d69c60>]  [<ffffffff81d69c60>]
hvc_console_setup+0x0/0x24
[    0.444004] RSP: 0018:ffff88007bccbd40  EFLAGS: 00010246
[    0.444004] RAX: 0000000000000000 RBX: ffffffff81ca8a60 RCX: 0000000000000010
[    0.444004] RDX: ffffffff81d69c60 RSI: 0000000000000000 RDI: ffffffff81ca8a60
[    0.444004] RBP: ffff88007bccbd68 R08: ffffffff81ca8b10 R09: ffff88007c704000
[    0.444004] R10: ffffffff813f1d24 R11: 0000000000000000 R12: ffffffff81f155a0
[    0.444004] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[    0.444004] FS:  0000000000000000(0000) GS:ffff88007fc00000(0000)
knlGS:0000000000000000
[    0.444004] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    0.444004] CR2: ffffffff81d69c60 CR3: 000000007bcc4000 CR4: 00000000000407f0
[    0.444004] Stack:
[    0.444004]  ffffffff810bfdbb ffff88007c704000 0000000000000000
0000000000000000
[    0.444004]  ffffffffa0050880 ffff88007bccbda8 ffffffff813f1e84
ffff88007c704000
[    0.444004]  ffff88007bd4a300 ffff88007c6deac4 ffff88007c6dea90
ffff88007c481000
[    0.444004] Call Trace:
[    0.444004]  [<ffffffff810bfdbb>] ? register_console+0x11b/0x370
[    0.444004]  [<ffffffff813f1e84>] hvc_alloc+0x1a4/0x330
[    0.444004]  [<ffffffffa004eb1b>] init_port_console+0x2b/0xe0
[virtio_console]
[    0.444004]  [<ffffffffa004fb2f>] control_work_handler+0x19f/0x3bc
[virtio_console]
[    0.444004]  [<ffffffff81087b76>] process_one_work+0x176/0x430
[    0.444004]  [<ffffffff810887ab>] worker_thread+0x11b/0x3a0
[    0.444004]  [<ffffffff81088690>] ? rescuer_thread+0x350/0x350
[    0.444004]  [<ffffffff8108f272>] kthread+0xd2/0xf0
[    0.444004]  [<ffffffff8108f1a0>] ? insert_kthread_work+0x40/0x40
[    0.444004]  [<ffffffff8169663c>] ret_from_fork+0x7c/0xb0
[    0.444004]  [<ffffffff8108f1a0>] ? insert_kthread_work+0x40/0x40
[    0.444004] Code: cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc
cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc
cc cc cc cc <cc> cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc
cc cc
[    0.444004] RIP  [<ffffffff81d69c60>] hvc_console_setup+0x0/0x24
[    0.444004]  RSP <ffff88007bccbd40>
[    0.444004] CR2: ffffffff81d69c60
[    0.444004] ---[ end trace c5e5a6cab58be5c6 ]---
[    0.473583] BUG: unable to handle kernel paging request at ffffffffffffffd8
[    0.474098] IP: [<ffffffff8108f810>] kthread_data+0x10/0x20
[    0.474098] PGD 1c0f067 PUD 1c11067 PMD 0
[    0.474098] Oops: 0000 [#2] SMP
[    0.474098] Modules linked in: virtio_pci virtio_console
9pnet_virtio virtio_ring virtio 9p 9pnet fscache
[    0.474098] CPU: 0 PID: 71 Comm: kworker/0:3 Tainted: G      D
3.13.7-200.fc20.x86_64 #1
[    0.474098] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.474098] task: ffff88007bc04500 ti: ffff88007bcca000 task.ti:
ffff88007bcca000
[    0.474098] RIP: 0010:[<ffffffff8108f810>]  [<ffffffff8108f810>]
kthread_data+0x10/0x20
[    0.474098] RSP: 0018:ffff88007bccb990  EFLAGS: 00010002
[    0.474098] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 000000000000000a
[    0.474098] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88007bc04500
[    0.474098] RBP: ffff88007bccb990 R08: ffff88007bc04590 R09: ffff88007fc17980
[    0.474098] R10: ffffffff8106af9c R11: ffffea0001f1f800 R12: ffff88007fc14580
[    0.474098] R13: 0000000000000000 R14: ffff88007bc044f0 R15: ffff88007bc04500
[    0.474098] FS:  0000000000000000(0000) GS:ffff88007fc00000(0000)
knlGS:0000000000000000
[    0.474098] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    0.474098] CR2: 0000000000000028 CR3: 000000007bcc4000 CR4: 00000000000407f0
[    0.474098] Stack:
[    0.474098]  ffff88007bccb9a8 ffffffff81088e01 ffff88007bc04500
ffff88007bccba08
[    0.474098]  ffffffff8168ae09 ffff88007bc04500 ffff88007bccbfd8
0000000000014580
[    0.474098]  0000000000014580 ffff88007bc04500 ffff88007bc04ab8
ffff88007bccb7b0
[    0.474098] Call Trace:
[    0.474098]  [<ffffffff81088e01>] wq_worker_sleeping+0x11/0x90
[    0.474098]  [<ffffffff8168ae09>] __schedule+0x4a9/0x740
[    0.474098]  [<ffffffff8168b0c9>] schedule+0x29/0x70
[    0.474098]  [<ffffffff8106fca7>] do_exit+0x6a7/0xa20
[    0.474098]  [<ffffffff810be9f8>] ? console_unlock+0x1e8/0x3f0
[    0.474098]  [<ffffffff81d69c60>] ? vty_init+0x174/0x174
[    0.474098]  [<ffffffff8168f4ac>] oops_end+0x9c/0xe0
[    0.474098]  [<ffffffff81683092>] no_context+0x27e/0x28b
[    0.474098]  [<ffffffff81d69c60>] ? vty_init+0x174/0x174
[    0.474098]  [<ffffffff81683112>] __bad_area_nosemaphore+0x73/0x1ca
[    0.474098]  [<ffffffff813173af>] ? add_uevent_var+0x6f/0x110
[    0.474098]  [<ffffffff81d69c60>] ? vty_init+0x174/0x174
[    0.474098]  [<ffffffff8168327c>] bad_area_nosemaphore+0x13/0x15
[    0.474098]  [<ffffffff81691cda>] __do_page_fault+0x9a/0x530
[    0.474098]  [<ffffffff81413467>] ? get_device+0x17/0x30
[    0.474098]  [<ffffffff81418a45>] ? klist_class_dev_get+0x15/0x20
[    0.474098]  [<ffffffff81678cf2>] ? klist_add_tail+0x32/0x40
[    0.474098]  [<ffffffff81414c19>] ? device_add+0x219/0x640
[    0.474098]  [<ffffffff8169217e>] do_page_fault+0xe/0x10
[    0.474098]  [<ffffffff81691878>] do_async_page_fault+0x28/0xa0
[    0.474098]  [<ffffffff8168e938>] async_page_fault+0x28/0x30
[    0.474098]  [<ffffffff813f1d24>] ? hvc_alloc+0x44/0x330
[    0.474098]  [<ffffffff81d69c60>] ? vty_init+0x174/0x174
[    0.474098]  [<ffffffff81d69c60>] ? vty_init+0x174/0x174
[    0.474098]  [<ffffffff810bfdbb>] ? register_console+0x11b/0x370
[    0.474098]  [<ffffffff813f1e84>] hvc_alloc+0x1a4/0x330
[    0.474098]  [<ffffffffa004eb1b>] init_port_console+0x2b/0xe0
[virtio_console]
[    0.474098]  [<ffffffffa004fb2f>] control_work_handler+0x19f/0x3bc
[virtio_console]
[    0.474098]  [<ffffffff81087b76>] process_one_work+0x176/0x430
[    0.474098]  [<ffffffff810887ab>] worker_thread+0x11b/0x3a0
[    0.474098]  [<ffffffff81088690>] ? rescuer_thread+0x350/0x350
[    0.474098]  [<ffffffff8108f272>] kthread+0xd2/0xf0
[    0.474098]  [<ffffffff8108f1a0>] ? insert_kthread_work+0x40/0x40
[    0.474098]  [<ffffffff8169663c>] ret_from_fork+0x7c/0xb0
[    0.474098]  [<ffffffff8108f1a0>] ? insert_kthread_work+0x40/0x40
[    0.474098] Code: 00 48 89 e5 5d 48 8b 40 c8 48 c1 e8 02 83 e0 01
c3 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 48 8b 87 48 03 00 00
55 48 89 e5 <48> 8b 40 d8 5d c3 66 2e 0f 1f 84 00 00 00 00 00 66 66 66
66 90
[    0.474098] RIP  [<ffffffff8108f810>] kthread_data+0x10/0x20
[    0.474098]  RSP <ffff88007bccb990>
[    0.474098] CR2: ffffffffffffffd8
[    0.474098] ---[ end trace c5e5a6cab58be5c7 ]---
[    0.474098] Fixing recursive fault but reboot is needed!
