Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681AbaAHDom (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 22:44:42 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33669 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753994AbaAHDof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 22:44:35 -0500
Date: Tue, 7 Jan 2014 19:44:53 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Mark Roszko <mark.roszko@gmail.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Leilei Zhao <leilei.zhao@atmel.com>, mdeneen@gmail.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 3/4] tty/serial: at91: prevent null dereference in
 tasklet function
Message-ID: <20140108034453.GA8664@kroah.com>
References: <cover.1389090437.git.nicolas.ferre@atmel.com>
 <69b33ebdc9427b5c036b4ba09151ae88c14a30f4.1389090437.git.nicolas.ferre@atmel.com>
 <20140108011137.GA13590@kroah.com>
 <CAJjB1qLDd6JFb4LwD5iokg5=O8Bwp5MkKsrr45QDodZkZrx75g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJjB1qLDd6JFb4LwD5iokg5=O8Bwp5MkKsrr45QDodZkZrx75g@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A: No.
Q: Should I include quotations after my reply?

http://daringfireball.net/2007/07/on_top

On Tue, Jan 07, 2014 at 08:52:34PM -0500, Mark Roszko wrote:
> This patch I was somewhat hesitant to pushing to Atmel when I did the other two
> patches.

Then why did you?  :)

> The main issue is the use of systemd causes the serial driver to somehow get
> out of sync on startups randomly. i.e. on one bootup it's fine, and on other
> it'll kernel panic. 
> It occurs because systemd causes the startup and shutdown driver ops to be
> fired in rapid succession. 

How does systemd cause this?  Is this when the serial port is being used
as a console or something else?

> Every single service start message causes the _startup callback first, then the
> message prints and _shutdown callbacks fires. 

So something is opening and closing the port quickly?  That should be
easy to test without systemd.

Any console involved?

> And a kernel panic always occurs somewhere during the service status output,
> never before when it's just the kernel startup and never after once systemd
> finishes and getty for example takes over. 
> 
> The stacktrace looked like this:
> Unable to handle kernel NULL pointer dereference at virtual address 00000088
> pgd = c0004000
> [00000088] *pgd=00000000
> Internal error: Oops: 17 [#1] ARM
> Modules linked in: autofs4
> CPU: 0    Not tainted  (3.6.9-yocto-standard #1)

3.6.9 is _very_ old, loads of things have happened in the tty layer
since then, can you duplicate this on 3.12 or 3.13-rc?


> PC is at tty_wakeup+0x8/0x58
> LR is at atmel_tasklet_func+0x238/0x80c
> pc : [<c01efd84>]    lr : [<c0208fc0>]    psr: a00f0013
> sp : df84ff28  ip : 00000000  fp : 00000100
> r10: c05d1ec0  r9 : 04208040  r8 : c05d1e80
> r7 : 0000000a  r6 : 00000000  r5 : dedf7c00  r4 : 00000000
> r3 : dedf7c00  r2 : 00000000  r1 : 600f0013  r0 : 00000000
> Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
> Control: 10c53c7d  Table: 3fb0c059  DAC: 00000015
> Process ksoftirqd/0 (pid: 3, stack limit = 0xdf84e2f0)
> Stack: (0xdf84ff28 to 0xdf850000)
> ff20:                   c05e4378 dedf7c00 00000000 c0208fc0 c05aa458 df8496b0
> ff40: df849680 c05aa458 df8496b0 c00394a8 c0039420 c05a8d04 00000000 00000000
> ff60: 0000000a c05d1e80 04208040 c05d1ec0 00000100 c001fd34 00000009 00000018
> ff80: df84e000 c001f60c df84ffbc c03f8e60 00000013 00000006 00000000 c05d1e80
> ffa0: df84e000 00000000 00000013 00000000 00000000 00000000 00000000 c001f728
> ffc0: df84bf3c 00000000 c001f6c0 c0030870 00000000 00000000 00000000 00000000
> ffe0: df84ffe0 df84ffe0 df84bf3c c00307f0 c000e348 c000e348 fff73fbf 3fbeffff
> [<c01efd84>] (tty_wakeup+0x8/0x58) from [<c0208fc0>] (atmel_tasklet_func+0x238/
> 0x80c)
> [<c0208fc0>] (atmel_tasklet_func+0x238/0x80c) from [<c001fd34>]
> (tasklet_action+0x70/0xa8)
> [<c001fd34>] (tasklet_action+0x70/0xa8) from [<c001f60c>] (__do_softirq+0x90/
> 0x144)
> [<c001f60c>] (__do_softirq+0x90/0x144) from [<c001f728>] (run_ksoftirqd+0x68/
> 0x104)
> [<c001f728>] (run_ksoftirqd+0x68/0x104) from [<c0030870>] (kthread+0x80/0x90)
> [<c0030870>] (kthread+0x80/0x90) from [<c000e348>] (kernel_thread_exit+0x0/0x8)
> Code: e8bd8070 c05ac0b8 e92d4070 e1a04000 (e5903088)
> ---[ end trace 15b8a9aeaf7b457f ]---
> 
> 
> Testing wise I originally used a BUG_ON statement in atmel_tasklet_func to
> panic before the null deference hit. BUG_ON confirmed that tty was NULL at the
> very start of the tasklet being called. 

And did you test that this patch actually fixed it?

> The atmel_shutdown function should be killing the tasklet (after patch "Handle
> shutdown more safely") and does disable interrupts so I've been at a loss at
> where the race condition was occurring that a tasklet could escape beyond
> shutdown.

Are you sure you aren't just racing with shutdown?  Need a lock
somewhere?

greg k-h
