Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308AbaJTORq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 10:17:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38839 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751467AbaJTORp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 10:17:45 -0400
Date: Mon, 20 Oct 2014 17:21:13 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: Virtio_config BUG with 3.18-rc1
Message-ID: <20141020142113.GC11062@redhat.com>
References: <CA+5PVA60zVwO=3ENHVgML4y_eP614XvZp98pN9rT03eLvzG1Fg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+5PVA60zVwO=3ENHVgML4y_eP614XvZp98pN9rT03eLvzG1Fg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2014 at 10:11:22AM -0400, Josh Boyer wrote:
> Hi All,
> 
> Booting my local KVM guest with a build of 3.18-rc1 this morning, it
> hangs during the normal dracut splash screen  When I configured the
> guest to use a serial console, I got the output below.  The guest is a
> typical KVM guest created with virt-manager, using QXL as the display
> driver.  Nothing fancy about it.
> 
> I'll try and do a bisect or some other experimentation today, but I
> thought I would send this out now in case someone had an idea or was
> already aware of it.

Thanks for the report.

Yes, multiqueue serial causes this.  Unfortunately I didn't test with MQ :(

Here's the fix:

mid.gmane.org/1413813529-11044-1-git-send-email-cornelia.huck@de.ibm.com



> josh
> 
> [    2.048706] piix4_smbus 0000:00:01.3: SMBus Host Controller at
> 0xb100, revision 0
> [    2.069574] parport_pc 00:04: reported by Plug and Play ACPI
> [    2.200079] ------------[ cut here ]------------
> [    2.200661] kernel BUG at include/linux/virtio_config.h:125!
> [    2.201004] invalid opcode: 0000 [#1] SMP
> [    2.201004] Modules linked in: snd_timer snd virtio_balloon
> virtio_console serio_raw parport_pc parport i2c_piix4 soundcore
> pvpanic btrfs qxl xor raid6_pq drm_kms_helper ttm drm 8139too
> virtio_pci virtio_rini
> [    2.201004] CPU: 0 PID: 71 Comm: kworker/0:2 Not tainted
> 3.18.0-0.rc1.git0.1.fc22.x86_64 #1
> [    2.201004] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [    2.201004] Workqueue: events control_work_handler [virtio_console]
> [    2.201004] task: ffff88003a83f5c0 ti: ffff88003a98c000 task.ti:
> ffff88003a98c000
> [    2.201004] RIP: 0010:[<ffffffffa0210032>]  [<ffffffffa0210032>]
> virtio_device_ready.part.12+0x4/0x6 [virtio_console]
> [    2.201004] RSP: 0018:ffff88003a98fd18  EFLAGS: 00010202
> [    2.201004] RAX: 0000000000000007 RBX: ffff88003c9b3200 RCX: 0000000000000000
> [    2.201004] RDX: 000000000000c192 RSI: ffffffffa02111b7 RDI: 000000000001c192
> [    2.201004] RBP: ffff88003a98fd18 R08: ffff88003c9f82b0 R09: 00007f78ee144e90
> [    2.201004] R10: 00000000ffffffff R11: 0000000000000246 R12: ffff880036cdd540
> [    2.201004] R13: 0000000000000001 R14: ffff880036d1a800 R15: 0000000000000000
> [    2.201004] FS:  0000000000000000(0000) GS:ffff88003fc00000(0000)
> knlGS:0000000000000000
> [    2.201004] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    2.201004] CR2: 00007f78ee204a50 CR3: 000000003d6f9000 CR4: 00000000000406f0
> [    2.201004] Stack:
> [    2.201004]  ffff88003a98fd88 ffffffffa020f757 ffff880000000001
> ffff8800367ae600
> [    2.201004]  ffff88003fc14900 ffff88003a83f628 ffff88003a98fdc8
> 000000003a0d7984
> [    2.201004]  ffff88003a98fd88 ffff88003c831b40 ffff880036cdd584
> ffff880036cdd550
> [    2.201004] Call Trace:
> [    2.201004]  [<ffffffffa020f757>] add_port+0x3b7/0x3e0 [virtio_console]
> [    2.201004]  [<ffffffffa020ffdc>] control_work_handler+0x39c/0x3e8
> [virtio_console]
> [    2.201004]  [<ffffffff810af9e9>] process_one_work+0x149/0x3d0
> [    2.201004]  [<ffffffff810b006b>] worker_thread+0x11b/0x490
> [    2.201004]  [<ffffffff810aff50>] ? rescuer_thread+0x2e0/0x2e0
> [    2.201004]  [<ffffffff810b5218>] kthread+0xd8/0xf0
> [    2.201004]  [<ffffffff810b5140>] ? kthread_create_on_node+0x1b0/0x1b0
> [    2.201004]  [<ffffffff8174b53c>] ret_from_fork+0x7c/0xb0
> [    2.201004]  [<ffffffff810b5140>] ? kthread_create_on_node+0x1b0/0x1b0
> [    2.201004] Code: 00 00 48 c7 c2 fc 11 21 a0 48 c7 c7 48 22 21 a0
> 48 8d 70 10 31 c0 e8 ee 83 19 e1 e9 3e fe ff ff 90 55 48 89 e5 0f 0b
> 55 48 89 e5 <0f> 0b 55 48 89 e5 0f 0b 55 48 89 e5 e8 5d e1 ff ff 48 c7
> c
> [    2.201004] RIP  [<ffffffffa0210032>]
> virtio_device_ready.part.12+0x4/0x6 [virtio_console]
> [    2.201004]  RSP <ffff88003a98fd18>
> [    2.232148] ---[ end trace a926e61ef6020bee ]---
> [    2.233075] BUG: unable to handle kernel paging request at ffffffffffffffd8
> [    2.233944] IP: [<ffffffff810b5850>] kthread_data+0x10/0x20
> [    2.234004] PGD 1c17067 PUD 1c19067 PMD 0
> [    2.234004] Oops: 0000 [#2] SMP
> [    2.234004] Modules linked in: snd_timer snd virtio_balloon
> virtio_console serio_raw parport_pc parport i2c_piix4 soundcore
> pvpanic btrfs qxl xor raid6_pq drm_kms_helper ttm drm 8139too
> virtio_pci virtio_rini
> [    2.234004] CPU: 0 PID: 71 Comm: kworker/0:2 Tainted: G      D
>   3.18.0-0.rc1.git0.1.fc22.x86_64 #1
> [    2.234004] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [    2.234004] task: ffff88003a83f5c0 ti: ffff88003a98c000 task.ti:
> ffff88003a98c000
> [    2.234004] RIP: 0010:[<ffffffff810b5850>]  [<ffffffff810b5850>]
> kthread_data+0x10/0x20
> [    2.234004] RSP: 0000:ffff88003a98f968  EFLAGS: 00010096
> [    2.234004] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 000000000000000f
> [    2.234004] RDX: 000000000000000b RSI: 0000000000000000 RDI: ffff88003a83f5c0
> [    2.234004] RBP: ffff88003a98f968 R08: ffff88003a83f650 R09: 000000018011000a
> [    2.234004] R10: ffffffff813786bb R11: ffffea0000ea6a40 R12: ffff88003fc14880
> [    2.234004] R13: 0000000000000000 R14: 0000000000000000 R15: ffff88003a83f5c0
> [    2.234004] FS:  0000000000000000(0000) GS:ffff88003fc00000(0000)
> knlGS:0000000000000000
> [    2.234004] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    2.234004] CR2: 0000000000000028 CR3: 000000003cb85000 CR4: 00000000000406f0
> [    2.234004] Stack:
> [    2.234004]  ffff88003a98f988 ffffffff810b0465 ffff88003a98f988
> ffff88003a83f5c0
> [    2.234004]  ffff88003a98f9f8 ffffffff81747299 ffff88003a83f5c0
> 0000000000014880
> [    2.234004]  ffff88003a98ffd8 0000000000014880 ffff88003a98f9e8
> ffff88003a83f5c0
> [    2.234004] Call Trace:
> [    2.234004]  [<ffffffff810b0465>] wq_worker_sleeping+0x15/0xa0
> [    2.234004]  [<ffffffff81747299>] __schedule+0x509/0x7d0
> [    2.234004]  [<ffffffff81747589>] schedule+0x29/0x70
> [    2.234004]  [<ffffffff81099ab7>] do_exit+0x6e7/0xa60
> [    2.234004]  [<ffffffff81740516>] ? printk+0x70/0x86
> [    2.234004]  [<ffffffff81017710>] oops_end+0xa0/0xe0
> [    2.234004]  [<ffffffff81017bcb>] die+0x4b/0x70
> [    2.234004]  [<ffffffff81013f90>] do_trap+0xb0/0x150
> [    2.234004]  [<ffffffff810143f6>] do_error_trap+0xa6/0x180
> [    2.234004]  [<ffffffffa0210032>] ?
> virtio_device_ready.part.12+0x4/0x6 [virtio_console]
> [    2.234004]  [<ffffffff81736032>] ? klist_add_tail+0x32/0x40
> [    2.234004]  [<ffffffff81495149>] ? device_add+0x219/0x630
> [    2.234004]  [<ffffffff81014d10>] do_invalid_op+0x20/0x30
> [    2.234004]  [<ffffffff8174cf9e>] invalid_op+0x1e/0x30
> [    2.234004]  [<ffffffffa0210032>] ?
> virtio_device_ready.part.12+0x4/0x6 [virtio_console]
> [    2.234004]  [<ffffffffa0031109>] ? vp_get_status+0x19/0x20 [virtio_pci]
> [    2.234004]  [<ffffffffa020f757>] add_port+0x3b7/0x3e0 [virtio_console]
> [    2.234004]  [<ffffffffa020ffdc>] control_work_handler+0x39c/0x3e8
> [virtio_console]
> [    2.234004]  [<ffffffff810af9e9>] process_one_work+0x149/0x3d0
> [    2.234004]  [<ffffffff810b006b>] worker_thread+0x11b/0x490
> [    2.234004]  [<ffffffff810aff50>] ? rescuer_thread+0x2e0/0x2e0
> [    2.234004]  [<ffffffff810b5218>] kthread+0xd8/0xf0
> [    2.234004]  [<ffffffff810b5140>] ? kthread_create_on_node+0x1b0/0x1b0
> [    2.234004]  [<ffffffff8174b53c>] ret_from_fork+0x7c/0xb0
> [    2.234004]  [<ffffffff810b5140>] ? kthread_create_on_node+0x1b0/0x1b0
> [    2.234004] Code: 00 48 89 e5 5d 48 8b 40 c8 48 c1 e8 02 83 e0 01
> c3 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 48 8b 87 68 04 00 00
> 55 48 89 e5 <48> 8b 40 d8 5d c3 66 2e 0f 1f 84 00 00 00 00 00 66 66 66
> 6
> [    2.234004] RIP  [<ffffffff810b5850>] kthread_data+0x10/0x20
> [    2.234004]  RSP <ffff88003a98f968>
> [    2.234004] CR2: ffffffffffffffd8
> [    2.234004] ---[ end trace a926e61ef6020bef ]---
> [    2.234004] Fixing recursive fault but reboot is needed!
