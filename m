Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725AbaETIVW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 04:21:22 -0400
Received: from helium.waldemar-brodkorb.de ([89.238.66.15]:53333 "EHLO
	helium.waldemar-brodkorb.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750747AbaETIVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 04:21:20 -0400
Date: Tue, 20 May 2014 10:21:16 +0200
From: Waldemar Brodkorb <wbx@openadk.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: serial console on rb532 disabled on boot (linux 3.15rc5)
Message-ID: <20140520082116.GB618@waldemar-brodkorb.de>
References: <20140516134904.GW618@waldemar-brodkorb.de>
 <CAMuHMdVPSzYkUumqMY78zxVcoQ6=W9Vfm_tyM_T3W8DFzCztVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAMuHMdVPSzYkUumqMY78zxVcoQ6=W9Vfm_tyM_T3W8DFzCztVw@mail.gmail.com>
X-Operating-System: Linux 3.2.0-4-amd64 x86_64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,
Geert Uytterhoeven wrote,

> Hi Waldemar,
> 
> On Fri, May 16, 2014 at 3:49 PM, Waldemar Brodkorb <wbx@openadk.org> wrote:
> > I am trying to bootup my Mikrotik RB532 board with the latest
> > kernel, but my serial console is disabled after boot:
> > ..
> > Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
> > serial8250: ttyS0 at MMIO 0x0 (irq = 104, base_baud = 12499875) is a
> > 16550A
> > console [ttyS0] enabled
> > console [ttyS0] disabled
> >
> > I used git bisect to find the problematic commit:
> > commit 5f5c9ae56c38942623f69c3e6dc6ec78e4da2076
> > Author: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
> > Date:   Fri Feb 28 14:21:32 2014 +0100
> >
> >     serial_core: Unregister console in uart_remove_one_port()
> >
> >     If the serial port being removed is used as a console, it must
> > also be
> >     unregistered from the console subsystem using
> > unregister_console().
> >
> >     uart_ops.release_port() will release resources (e.g. iounmap()
> > the serial
> >     port registers), causing a crash on subsequent kernel output if
> > the console
> >     is still registered.
> >
> >     Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
> >     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >
> > After reverting the change, everything is fine.
> 
> Does this patch help? https://lkml.org/lkml/2014/5/10/9

The second change in printk.c didn't help.
 
> I guess you're not using of_serial?

No, I am not.

> Your serial driver may need to set port.type too, if it doesn't already do so
> and the type is PORT_UNKNOWN on re-registration.

Tried following patch, but it didn't work:

diff -Nur linux-3.15-rc5.orig/arch/mips/rb532/serial.c
linux-3.15-rc5/arch/mips/rb532/serial.c
--- linux-3.15-rc5.orig/arch/mips/rb532/serial.c        2014-05-09
22:10:52.000000000 +0200
+++ linux-3.15-rc5/arch/mips/rb532/serial.c     2014-05-19
20:35:08.000000000 +0200
@@ -37,7 +37,7 @@
 extern unsigned int idt_cpu_freq;
 
 static struct uart_port rb532_uart = {
-       .flags = UPF_BOOT_AUTOCONF,
+       .type = PORT_16550A,
        .line = 0,
        .irq = UART0_IRQ,
        .iotype = UPIO_MEM,
diff -Nur linux-3.15-rc5.orig/kernel/printk/printk.c
linux-3.15-rc5/kernel/printk/printk.c
--- linux-3.15-rc5.orig/kernel/printk/printk.c  2014-05-09
22:10:52.000000000 +0200
+++ linux-3.15-rc5/kernel/printk/printk.c       2014-05-20
09:39:54.000000000 +0200
@@ -2413,6 +2413,7 @@
        if (console_drivers != NULL && console->flags & CON_CONSDEV)
                console_drivers->flags |= CON_CONSDEV;
 
+       console->flags &= ~CON_ENABLED;
        console_unlock();
        console_sysfs_notify();
        return res;


best regards
        Waldemar
