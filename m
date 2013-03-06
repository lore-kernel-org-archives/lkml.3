Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331Ab3CFCfL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 21:35:11 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:52645 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab3CFCfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 21:35:07 -0500
MIME-Version: 1.0
Date: Tue, 5 Mar 2013 18:35:07 -0800
X-Google-Sender-Auth: 7CaswUGBkRk0R8O0QGKdwaVuNRw
Message-ID: <CANLzEkvN1uGsS9WnN3OTntSXJw+Ut2z2Eqyn7etQwDSyOdxhKg@mail.gmail.com>
Subject: v3.9-rc1 instability on Chromebook Pixel with gmbus irq
From: Benson Leung <bleung@chromium.org>
To: daniel.vetter@ffwll.ch
Cc: Daniel Kurtz <djkurtz@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Olof Johansson <olofj@chromium.org>, dri-devel@lists.freedesktop.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel Vetter,

I'm working on touch devices Chromium OS, and I've noticed a
regression between 3.8 and 3.9-rc1, which was posted yesterday.

The hardware in question is a Chromebook Pixel. For this device, we
have i2c input devices: atmel mxt224s touchpad and atmel mxt1664s
touchscreen. The touchpad is on bus 1, "i915 gmbus vga" at 1-004b. The
touchscreen is on bus 2, "i915 gmbus panel" at 2-004a.

I was testing v3.9-rc1 on the Pixel and the touchscreen driver is
being returned -110 (-ETIMEDOUT) on an i2c_transfer after several
seconds of both touch devices working correctly. At the time of the
failure, there are no error messages from GMBUS that I can see, but
the bus never recovers. I can keep interacting with the touchscreen or
touchpad, and the interrupts trigger reads, but all subsequent reads
return -110.

I noticed that between 3.8 and 3.9-rc1, your patch series to add gmbus
irq support was merged. After bisecting, I found that this commit
seems to be causing the timeout problem. Reverting it makes the
problem go away, and the bus is stable.

commit 2c438c0273b76d6cb158f8bdd0aa3ebf66e48a28
Author: Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Sat Dec 1 13:53:46 2012 +0100

    drm/i915: use gmbus irq to wait for gmbus idle

    GMBUS_ACTIVE has inverted sense and so doesn't fit into the
    wait_hw_status helper, hence create a new gmbus_wait_idle functions.
    Also, we only care about the idle irq event and nothing else, which
    allows us to use the wait_event_timeout helper directly without
    jumping through hoops to catch NAKs.

    Since gen2/3 don't have gmbus interrupts, handle them separately with
    the old wait_for macro.

    This shaves another few ms off reading EDID from a hdmi screen on my
    testbox here. EDID reading with interrupt driven gmbus is now as fast
    as with busy-looping gmbus at 28 ms here (with negligible cpu
    overhead).

    Reviewed-by: Imre Deak <imre.deak@intel.com>
    Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>


Is there anything I can do to help debug this some more?

--
Benson Leung
Software Engineer, Chrom* OS
bleung@chromium.org
