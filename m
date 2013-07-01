Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519Ab3GAOtU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 10:49:20 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:56529 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754487Ab3GAOtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 10:49:17 -0400
Message-ID: <51D196EA.7010809@gmail.com>
Date: Mon, 01 Jul 2013 16:49:14 +0200
From: Andre Naujoks <nautsch2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130518 Icedove/17.0.5
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] kernel panic, pty.c: remove direct call to tty_wakup in pty_write
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

This patch removes the direct call to tty_wakeup in pty_write. I have
not noticed any drawbacks with this but I am not familiar with the pty
driver at all. I think what happens is a recursive loop,
write_wakeup->write->write_wakeup ...

The documentation for the tty interface forbids this direct call:

(from Documentation/serial/tty.txt)
write_wakeup()  - May be called at any point between open and close.
      The TTY_DO_WRITE_WAKEUP flag indicates if a call
      is needed but always races versus calls. Thus the
      ldisc must be careful about setting order and to
      handle unexpected calls. Must not sleep.

      The driver is forbidden from calling this directly
      from the ->write call from the ldisc as the ldisc
      is permitted to call the driver write method from
      this function. In such a situation defer it.



The direct call caused a reproducable kernel panic (see bottom of this
mail) for me with the following setup:

- using can-utils from git://gitorious.org/linux-can/can-utils.git
  slcan_attach and cangen are used

- create a network link between two serial CAN interfaces with:
  $ socat PTY,link=/tmp/slcan0,raw TCP4-LISTEN:50000 &
  $ socat TCP4:localhost:50000 PTY,link=/tmp/slcan1,raw &
  $ slcan_attach /tmp/slcan0
  $ slcan_attach /tmp/slcan1
  $ ip link set slcan0 up
  $ ip link set slcan1 up

- produce a kernel panic by overloading the CAN interfaces:
  $ cangen slcan0 -g0


Please keep me in CC. I am not subscribed to the list.
If I can provide any more information, I will be glad to do so.

This is the patch. It applies to the current linux master branch:


>From 9f67139bebb938026406a66c1411e0b50628a238 Mon Sep 17 00:00:00 2001
From: Andre Naujoks <nautsch2@googlemail.com>
Date: Mon, 1 Jul 2013 15:45:13 +0200
Subject: [PATCH 1/2] remove direct call to tty_wakeup in pty_write.

Signed-off-by: Andre Naujoks <nautsch2@googlemail.com>
---
 drivers/tty/pty.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index abfd990..5dcb782 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -127,7 +127,6 @@ static int pty_write(struct tty_struct *tty, const
unsigned char *buf, int c)
 		/* And shovel */
 		if (c) {
 			tty_flip_buffer_push(to->port);
-			tty_wakeup(tty);
 		}
 	}
 	return c;
-- 
1.8.3.1

Regards
  Andre Naujoks

Kernel-Panic:

[   61.764168] ------------[ cut here ]------------
[   61.765107] WARNING: at
/build/linux-9VFSO6/linux-3.9.4/kernel/softirq.c:160
_local_bh_enable_ip.isra.16+0x33/0x88()
[   61.766467] Hardware name: Bochs
[   61.766900] Modules linked in: can_raw
[   61.768420] ------------[ cut here ]------------
[   61.771474] kernel BUG at
/build/linux-9VFSO6/linux-3.9.4/kernel/sched/core.c:524!
[   61.772378] invalid opcode: 0000 [#1] SMP
[   61.772378] Modules linked in: can_raw can slcan vcan nfsv4 nfsd
auth_rpcgss nfs_acl nfs lockd dns_resolver fscache sunrpc loop snd_pcm
snd_page_alloc kvm_amd snd_timer kvm snd ttm soundcore drm_kms_helper
parport_pc parport drm i2c_piix4 psmouse i2c_core processor pcspkr
serio_raw thermal_sys evdev button ext4 crc16 jbd2 mbcache sg sr_mod
sd_mod crc_t10dif cdrom ata_generic virtio_net floppy ata_piix
virtio_pci virtio_ring virtio libata scsi_mod
[   61.772378] CPU 0
[   61.772378] Pid: 2547, comm: socat Not tainted 3.9-1-amd64 #1 Debian
3.9.4-1 Bochs Bochs
[   61.772378] RIP: 0010:[<ffffffff8106212f>]  [<ffffffff8106212f>]
resched_task+0x26/0x5d
[   61.772378] RSP: 0018:ffff88007fc03e38  EFLAGS: 00010046
[   61.772378] RAX: 0000000000000000 RBX: ffff88003739f7f0 RCX:
0000000000416036
[   61.772378] RDX: 0000000000000000 RSI: 0000000000000c00 RDI:
ffff88007a9ba000
[   61.772378] RBP: ffff88007fc13f30 R08: 0000000000000004 R09:
0000000000000001
[   61.772378] R10: 00000000000016af R11: 000000000000b768 R12:
00000000001e8480
[   61.772378] R13: ffff88007fc13ec0 R14: 0000000000000000 R15:
ffff88007fc03f50
[   61.772378] FS:  00007f2c71d11700(0000) GS:ffff88007fc00000(0000)
knlGS:0000000000000000
[   61.772378] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   61.772378] CR2: 0000000001882808 CR3: 00000000370fe000 CR4:
00000000000006f0
[   61.772378] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[   61.772378] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[   61.772378] Process socat (pid: 2547, threadinfo ffff88007a9ba000,
task ffff88003739f7f0)
[   61.772378] Stack:
[   61.772378]  ffff88003739f838 ffffffff810685f8 ffff88007fc13ec0
0000000000000000
[   61.772378]  ffff88003739f7f0 ffff88007fc0e2b0 ffffffff8107b14d
ffffffff81063a65
[   61.772378]  ffff88003739f7f0 0000000000000000 0000000000000000
ffffffff8104a51d
[   61.772378] Call Trace:
[   61.772378]  <IRQ>
[   61.772378]  [<ffffffff810685f8>] ? task_tick_fair+0x91/0xf5
[   61.772378]  [<ffffffff8107b14d>] ? tick_sched_do_timer+0x25/0x25
[   61.772378]  [<ffffffff81063a65>] ? scheduler_tick+0xb5/0xdd
[   61.772378]  [<ffffffff8104a51d>] ? update_process_times+0x50/0x5c
[   61.772378]  [<ffffffff8107aea3>] ? tick_sched_handle+0x3f/0x4c
[   61.772378]  [<ffffffff8107b17d>] ? tick_sched_timer+0x30/0x4c
[   61.772378]  [<ffffffff8105a481>] ? __run_hrtimer+0xae/0x154
[   61.772378]  [<ffffffff8105ad13>] ? hrtimer_interrupt+0xc5/0x1a7
[   61.772378]  [<ffffffff81028c8f>] ? smp_apic_timer_interrupt+0x6e/0x81
[   61.772378]  [<ffffffff813961dd>] ? apic_timer_interrupt+0x6d/0x80
[   61.772378]  <EOI>
[   61.772378]  [<ffffffff8103d61a>] ? arch_local_irq_restore+0x2/0x8
[   61.772378]  [<ffffffff8103f5a9>] ? vprintk_emit+0x3be/0x3e4
[   61.772378]  [<ffffffff8103ed4a>] ? wake_up_klogd+0x2d/0x31
[   61.772378]  [<ffffffff81043bd8>] ? _local_bh_enable_ip.isra.16+0x33/0x88
[   61.772378]  [<ffffffff8138a939>] ? printk+0x4f/0x54
[   61.772378]  [<ffffffff810850b5>] ? print_modules+0x51/0xb8
[   61.772378]  [<ffffffff8103d537>] ? warn_slowpath_common+0x71/0x8c
[   61.772378]  [<ffffffff81043bd8>] ? _local_bh_enable_ip.isra.16+0x33/0x88
[   61.772378]  [<ffffffff813028b6>] ? tcp_sendmsg+0x1f/0x7ca
[   61.772378]  [<ffffffff8105eaea>] ? __wake_up+0x35/0x46
[   61.772378]  [<ffffffff812bc3ad>] ? sock_aio_write+0xc8/0xed
[   61.772378]  [<ffffffff8105eaea>] ? __wake_up+0x35/0x46
[   61.772378]  [<ffffffff8110cf93>] ? do_sync_write+0x62/0x9b
[   61.772378]  [<ffffffff8110d541>] ? vfs_write+0x9d/0xf8
[   61.772378]  [<ffffffff81061600>] ? should_resched+0x5/0x23
[   61.772378]  [<ffffffff8110d828>] ? sys_write+0x51/0x80
[   61.772378]  [<ffffffff813955e9>] ? system_call_fastpath+0x16/0x1b
[   61.772378] Code: 00 5b 5b 5d c3 53 48 89 fb 48 8b 7f 08 48 c7 c0 c0
3e 01 00 8b 57 18 48 03 04 d5 80 eb 68 81 8b 00 89 c2 c1 ea 10 66 39 c2
75 02 <0f> 0b 48 8b 47 10 a8 08 75 2b e8 d7 ec ff ff 48 8b 43 08 8b 78
[   61.772378] RIP  [<ffffffff8106212f>] resched_task+0x26/0x5d
[   61.772378]  RSP <ffff88007fc03e38>
[   61.772378] ---[ end trace e7680e6512133308 ]---
[   61.772378] Kernel panic - not syncing: Fatal exception in interrupt





