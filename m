Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757008Ab3CSPiw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 11:38:52 -0400
Received: from netrider.rowland.org ([192.131.102.5]:56787 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756833Ab3CSPit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 11:38:49 -0400
Date: Tue, 19 Mar 2013 11:38:48 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Daniel Vetter <daniel.vetter@ffwll.ch>
cc: Chris Wilson <chris@chris-wilson.co.uk>, Jiri Kosina <jkosina@suse.cz>,
        Daniel Vetter <daniel@ffwll.ch>, Greg KH <greg@kroah.com>,
        Harald Arnesen <skogtun.linux@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Peter Hurley <peter@hurleysoftware.com>,
        Thomas Meyer <thomas@m3y3r.de>, Shawn Starr <shawn.starr@rogers.com>,
        USB list <linux-usb@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, <linux-pci@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, Imre Deak <imre.deak@intel.com>,
        Daniel Kurtz <djkurtz@chromium.org>, <dri-devel@lists.freedesktop.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        <x86@kernel.org>, Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Subject: Re: gm45 intel gfx can generate non-MSI irq# in MSI mode (was Re:
 [PATCH] drm/i915: stop using GMBUS IRQs on Gen4 chips (was Re: [3.9-rc1]
 irq 16: nobody cared (was [3.9-rc1] very poor interrupt responses
In-Reply-To: <CAKMK7uGnZFaLQaZtoQ0Fz0ViNNjBvmf0Ak=qPmdAcm2mRBD7rA@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1303191136020.15684-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Mar 2013, Daniel Vetter wrote:

> For reference below the updated commit message.
> 
> Cheers, Daniel
> 
> Author: Jiri Kosina <jkosina@suse.cz>
> Date:   Tue Mar 19 09:56:57 2013 +0100

> 
>     drm/i915: stop using GMBUS IRQs on Gen4 chips
> 
>     Commit 28c70f162 ("drm/i915: use the gmbus irq for waits") switched to
>     using GMBUS irqs instead of GPIO bit-banging for chipset generations 4
>     and above.
> 
>     It turns out though that on many systems this leads to spurious interrupts
>     being generated, long after the register write to disable the IRQs has been
>     issued.
> 
>     Typically this results in the spurious interrupt source getting
>     disabled:
> 
>     [    9.636345] irq 16: nobody cared (try booting with the "irqpoll" option)
>     [    9.637915] Pid: 4157, comm: ifup Tainted: GF
> 3.9.0-rc2-00341-g0863702 #422
>     [    9.639484] Call Trace:
>     [    9.640731]  <IRQ>  [<ffffffff8109b40d>] __report_bad_irq+0x1d/0xc7
>     [    9.640731]  [<ffffffff8109b7db>] note_interrupt+0x15b/0x1e8
>     [    9.640731]  [<ffffffff810999f7>] handle_irq_event_percpu+0x1bf/0x214
>     [    9.640731]  [<ffffffff81099a88>] handle_irq_event+0x3c/0x5c
>     [    9.640731]  [<ffffffff8109c139>] handle_fasteoi_irq+0x7a/0xb0
>     [    9.640731]  [<ffffffff8100400e>] handle_irq+0x1a/0x24
>     [    9.640731]  [<ffffffff81003d17>] do_IRQ+0x48/0xaf
>     [    9.640731]  [<ffffffff8142f1ea>] common_interrupt+0x6a/0x6a
>     [    9.640731]  <EOI>  [<ffffffff8142f952>] ? system_call_fastpath+0x16/0x1b
>     [    9.640731] handlers:
>     [    9.640731] [<ffffffffa000d771>] usb_hcd_irq [usbcore]
>     [    9.640731] [<ffffffffa0306189>] yenta_interrupt [yenta_socket]
>     [    9.640731] Disabling IRQ #16
> 
>     The really curious thing is now that irq 16 is _not_ the interrupt for
>     the i915 driver when using MSI, but it _is_ the interrupt when not
>     using MSI. So by all indications it seems like gmbus is able to
>     generate a legacy (shared) interrupt in MSI mode on some
>     configurations. I've tried to reproduce this and the differentiating
>     thing seems to be that on unaffected systems no other device uses irq
>     16 (which seems to be the non-MSI intel gfx interrupt on all gm45).

That might be misleading.  It's possible that the erroneous IRQs _are_
being issued but you're simply not aware of them.  If the kernel thinks
that no device is using IRQ 16 then it will leave that IRQ disabled.

Alan Stern

