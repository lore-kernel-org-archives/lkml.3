Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119Ab3CSPMW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 11:12:22 -0400
Received: from mail-ia0-f177.google.com ([209.85.210.177]:34479 "EHLO
	mail-ia0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755762Ab3CSPMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 11:12:19 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
Date: Tue, 19 Mar 2013 16:12:18 +0100
Message-ID: <CAKMK7uGnZFaLQaZtoQ0Fz0ViNNjBvmf0Ak=qPmdAcm2mRBD7rA@mail.gmail.com>
Subject: gm45 intel gfx can generate non-MSI irq# in MSI mode (was Re: [PATCH]
 drm/i915: stop using GMBUS IRQs on Gen4 chips (was Re: [3.9-rc1] irq 16:
 nobody cared (was [3.9-rc1] very poor interrupt responses)))
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Chris Wilson <chris@chris-wilson.co.uk>, Jiri Kosina <jkosina@suse.cz>,
        Daniel Vetter <daniel@ffwll.ch>, Greg KH <greg@kroah.com>,
        Harald Arnesen <skogtun.linux@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Peter Hurley <peter@hurleysoftware.com>,
        Alan Stern <stern@rowland.harvard.edu>, Thomas Meyer <thomas@m3y3r.de>,
        Shawn Starr <shawn.starr@rogers.com>,
        USB list <linux-usb@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Imre Deak <imre.deak@intel.com>, Daniel Kurtz <djkurtz@chromium.org>,
        dri-devel@lists.freedesktop.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 19, 2013 at 10:03 AM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
>> > How about just using:
>> >   if (!HAS_GMBUS_IRQ(dev_priv->dev)) gmbus4_irq_en = 0;
>> > and the existing wait loop?
>>
>> I explicitly wanted to avoid touching GMBUS4 register, as the real cause
>> of the failure is not clear.
>>
>> But, as Yinghai Lu points out, the problem is most likely caused by
>> interrupt disabling not working properly (see his very good point
>> regarding DisINTx+ and INTx+ discrepancy), so zeroing the register out
>> should work .... and it indeed does in my case, hence the (tested) patch
>> below.
>>
>> I think it's a 3.9-rc material, and I am all open to debug this further
>> for 3.10 so that the race is closed and gmbus irqs can be used on Gen4
>> platform properly.
>
> Agreed. Using the IRQ for GMBUS is just a performance feature that can
> be deferred until after we determine the root cause - and hope that the
> failure is somehow peculiar to GMBUS.

Ok, I've merged this patch. But some further investigation points at a
much more severe dragon hiding here: The MSI interrupt for the intel
gfx is commonly in the 40+ range, but the interrupt vector with the
spurious interrupts is 16. Which is the irq of the intel gfx when MSI
is disabled!

So it looks like gmbus on the intel gfx is capable of generating
non-MSI interrupts in parallel to the MSI interrupts (since apparently
gmbus still works, so we get the interrupts we expect). I have no idea
how that could happen. Hence adding a bunch of people with more clue
than me.

For reference below the updated commit message.

Cheers, Daniel

Author: Jiri Kosina <jkosina@suse.cz>
Date:   Tue Mar 19 09:56:57 2013 +0100

    drm/i915: stop using GMBUS IRQs on Gen4 chips

    Commit 28c70f162 ("drm/i915: use the gmbus irq for waits") switched to
    using GMBUS irqs instead of GPIO bit-banging for chipset generations 4
    and above.

    It turns out though that on many systems this leads to spurious interrupts
    being generated, long after the register write to disable the IRQs has been
    issued.

    Typically this results in the spurious interrupt source getting
    disabled:

    [    9.636345] irq 16: nobody cared (try booting with the "irqpoll" option)
    [    9.637915] Pid: 4157, comm: ifup Tainted: GF
3.9.0-rc2-00341-g0863702 #422
    [    9.639484] Call Trace:
    [    9.640731]  <IRQ>  [<ffffffff8109b40d>] __report_bad_irq+0x1d/0xc7
    [    9.640731]  [<ffffffff8109b7db>] note_interrupt+0x15b/0x1e8
    [    9.640731]  [<ffffffff810999f7>] handle_irq_event_percpu+0x1bf/0x214
    [    9.640731]  [<ffffffff81099a88>] handle_irq_event+0x3c/0x5c
    [    9.640731]  [<ffffffff8109c139>] handle_fasteoi_irq+0x7a/0xb0
    [    9.640731]  [<ffffffff8100400e>] handle_irq+0x1a/0x24
    [    9.640731]  [<ffffffff81003d17>] do_IRQ+0x48/0xaf
    [    9.640731]  [<ffffffff8142f1ea>] common_interrupt+0x6a/0x6a
    [    9.640731]  <EOI>  [<ffffffff8142f952>] ? system_call_fastpath+0x16/0x1b
    [    9.640731] handlers:
    [    9.640731] [<ffffffffa000d771>] usb_hcd_irq [usbcore]
    [    9.640731] [<ffffffffa0306189>] yenta_interrupt [yenta_socket]
    [    9.640731] Disabling IRQ #16

    The really curious thing is now that irq 16 is _not_ the interrupt for
    the i915 driver when using MSI, but it _is_ the interrupt when not
    using MSI. So by all indications it seems like gmbus is able to
    generate a legacy (shared) interrupt in MSI mode on some
    configurations. I've tried to reproduce this and the differentiating
    thing seems to be that on unaffected systems no other device uses irq
    16 (which seems to be the non-MSI intel gfx interrupt on all gm45).

    I have no idea how that even can happen.

    To avoid tempting this elephant into a rage, just disable gmbus
    interrupt support on gen 4.

    v2: Improve the commit message with exact details of what's going on.
    Also add a comment in the code to warn against this particular
    elephant in the room.

    Signed-off-by: Jiri Kosina <jkosina@suse.cz> (v1)
    Acked-by: Chris Wilson <chris@chris-wilson.co.uk> (v1)
    References: https://lkml.org/lkml/2013/3/8/325
    Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
