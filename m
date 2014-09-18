Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756411AbaIRO5H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 10:57:07 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:47286 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755826AbaIRO5F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 10:57:05 -0400
MIME-Version: 1.0
Date: Thu, 18 Sep 2014 16:57:02 +0200
Message-ID: <CAP145pg75hFKi2S9SVywRfex_A5=yRpe0p4Dzri8+Q=7YWoXfg@mail.gmail.com>
Subject: Div-by-zero in the 8250 serial driver (3.17-rc5)
From: =?UTF-8?B?Um9iZXJ0IMWad2nEmWNraQ==?= <robert@swiecki.net>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

# setserial /dev/ttyS0 spd_hi baud_base 38400

Entering kdb (current=0xffff8805ee033200, pid 1798) on processor 9 Oops: (null)
due to oops @ 0xffffffff8149c01e
CPU: 9 PID: 1798 Comm: setserial Tainted: G        W I
3.17.0-031700rc5-generic-201409151105
task: ffff8805ee033200 ti: ffff8800e39e0000 task.ti: ffff8800e39e0000
RIP: 0010:[<ffffffff8149c01e>]  [<ffffffff8149c01e>] uart_get_divisor+0x1e/0x40
RSP: 0018:ffff8800e39e3c30  EFLAGS: 00010206
RAX: 0000000000096000 RBX: ffffffff81fab060 RCX: 0000000000000006
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff81fab060
RBP: ffff8800e39e3c78 R08: 000000000000000a R09: 00000000000003d2
R10: 0000000000000000 R11: 00000000000003d1 R12: 0000000000000013
R13: ffff8805f0748d2c R14: 0000000000000000 R15: 0000000000000010
FS:  00007f0fa653d740(0000) GS:ffff880613920000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f0fa6003330 CR3: 00000000365f8000 CR4: 00000000000007e0
Stack:
 ffffffff814a2978 ffffffff81fab060 0000000000000010 ffff8800e39e3ca8
 ffff8805eca08000 ffff8805f0748c00 ffff8800e39e3dc0 ffffffff81fab060
 0000000000000010 ffff8800e39e3c88 ffffffff814a2d55 ffff8800e39e3ca8
Call Trace:
 [<ffffffff814a2978>] ? serial8250_do_set_termios+0xd8/0x490
 [<ffffffff814a2d55>] serial8250_set_termios+0x25/0x30
 [<ffffffff8149dce2>] uart_change_speed+0x52/0xb0
 [<ffffffff8149ec9c>] uart_set_info+0x20c/0x5f0
 [<ffffffff8149c75a>] ? do_uart_get_info+0xfa/0x1a0
 [<ffffffff8149fbdf>] uart_ioctl+0x14f/0x220
 [<ffffffff814804d8>] tty_ioctl+0x298/0x8f0
 [<ffffffff811fc025>] do_vfs_ioctl+0x75/0x2c0
 [<ffffffff811fc301>] SyS_ioctl+0x91/0xb0
 [<ffffffff817a436d>] system_call_fastpath+0x1a/0x1f
Code: c0 00 00 00 c3 0f 1f 84 00 00 00 00 00 66 66 66 66 90 55 81 fe
00 96 00 00 48 89 e5 74 17 c1 e6 04 31 d2 89 f0 d1 e8 03 47 58 5d <f7>
f6 c3 0f 1f 80 00 00 00 00 8b 87 b8 00 00 00 25 30 10 00 00

>From some earlier kernel I have vmlinux for (Ubuntu's 3.13.0-35-generic)

(gdb) bt full
#0  uart_get_divisor (port=0xffffffff81fc4680 <serial8250_ports>,
baud=<optimized out>)
    at /build/buildd/linux-3.13.0/drivers/tty/serial/serial_core.c:423
        __d = 0
        quot = <optimized out>
#1  0xffffffff8146b2da in serial8250_get_divisor (baud=<optimized
out>, port=<optimized out>)
    at /build/buildd/linux-3.13.0/drivers/tty/serial/8250/8250_core.c:2263
No locals.
#2  serial8250_do_set_termios (port=0xffffffff81fc4680
<serial8250_ports>, termios=0x0 <irq_stack_union>,
    old=<optimized out>) at
/build/buildd/linux-3.13.0/drivers/tty/serial/8250/8250_core.c:2315
        cval = 19 '\023'
        fcr = <optimized out>
        baud = 0
        quot = <optimized out>
        fifo_bug = <optimized out>
#3  0xffffffff8146b665 in serial8250_set_termios (port=<optimized
out>, termios=<optimized out>, old=<optimized out>)
    at /build/buildd/linux-3.13.0/drivers/tty/serial/8250/8250_core.c:2467
No locals.
#4  0xffffffff814663f0 in uart_change_speed (tty=<optimized out>,
state=<optimized out>, old_termios=<optimized out>)
    at /build/buildd/linux-3.13.0/drivers/tty/serial/serial_core.c:460
        uport = <optimized out>
        termios = <optimized out>
#5  0xffffffff81468c8b in uart_set_info (tty=<optimized out>,
port=0xffff8805ef9f8000, state=0xffff8805ef9f8000,
    new_info=0xffff8805f1d9ddb8) at
/build/buildd/linux-3.13.0/drivers/tty/serial/serial_core.c:889
        uport = 0xffffffff81fc4680 <serial8250_ports>
        change_irq = <optimized out>
        closing_wait = 7500
        old_custom_divisor = <optimized out>
        new_flags = <optimized out>
#6  0xffffffff8146a6ef in uart_set_info_user (newinfo=<optimized out>,
state=<optimized out>, tty=<optimized out>)
    at /build/buildd/linux-3.13.0/drivers/tty/serial/serial_core.c:915
        new_serial = {type = 4, line = 0, port = 1016, irq = 4, flags
= 268435536, xmit_fifo_size = 16,
          custom_divisor = 0, baud_base = 38400, close_delay = 50,
io_type = 0 '\000', reserved_char = "", hub6 = 0,
          closing_wait = 3000, closing_wait2 = 0, iomem_base = 0x0
<irq_stack_union>, iomem_reg_shift = 0,
          port_high = 0, iomap_base = 0}
#7  uart_ioctl (tty=0xffffffff81fc4680 <serial8250_ports>, cmd=0, arg=0)
    at /build/buildd/linux-3.13.0/drivers/tty/serial/serial_core.c:1162
        state = 0xffff8805ef9f8000
        ret = <optimized out>
#8  0xffffffff8144a6dd in tty_ioctl (file=0xffff8800357c5c00,
cmd=21535, arg=140737325927280)
    at /build/buildd/linux-3.13.0/drivers/tty/tty_io.c:2850
        ld = <optimized out>
#9  0xffffffff811d0360 in vfs_ioctl (arg=<optimized out>,
cmd=<optimized out>, filp=<optimized out>)
    at /build/buildd/linux-3.13.0/fs/ioctl.c:43
No locals.
#10 do_vfs_ioctl (filp=0xffff8800357c5c00, fd=<optimized out>,
cmd=<optimized out>, arg=<optimized out>)
    at /build/buildd/linux-3.13.0/fs/ioctl.c:598
        argp = 0x7ffff6518b70
#11 0xffffffff811d05c1 in SYSC_ioctl (arg=<optimized out>,
cmd=<optimized out>, fd=<optimized out>)
    at /build/buildd/linux-3.13.0/fs/ioctl.c:613
        error = <optimized out>
#12 SyS_ioctl (fd=3, cmd=21535, arg=140737325927280) at
/build/buildd/linux-3.13.0/fs/ioctl.c:604

-- 
Robert Święcki
