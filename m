Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751176AbaDOVlQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 17:41:16 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:36030 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829AbaDOVlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 17:41:14 -0400
MIME-Version: 1.0
In-Reply-To: <CAPDyKFp=DikkmXnyHsTJF6W_FpTDJZYiSk9n7Nh+RwY=r=P4-Q@mail.gmail.com>
References: <534C7D36.9090008@linaro.org> <CAPDyKFp=DikkmXnyHsTJF6W_FpTDJZYiSk9n7Nh+RwY=r=P4-Q@mail.gmail.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Tue, 15 Apr 2014 22:40:52 +0100
Message-ID: <CAFEAcA_qr5O-Zf8OxMU7JmeonSsJFE9soVArPay4GDkL8TK1uQ@mail.gmail.com>
Subject: Re: [Regression?] qemu-system-arm flooding "sd_write_data: not in
 Receiving-Data state"
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: John Stultz <john.stultz@linaro.org>, Chris Ball <chris@printf.net>,
        Johan Rudholm <jrudholm@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 April 2014 08:26, Ulf Hansson <ulf.hansson@linaro.org> wrote:
> Though, maybe you can provide me with some information about the qemu
> environment you are using?
>
> 1. Especially, what variant of the ARM primcell pl180 is being
> modelled/used here? The mmci driver handles a handful of different
> variants.

QEMU's device modelling is not generally sufficiently accurate
to make this a very meaningful question :-) We model a PL181,
but we will inevitably behave differently from h/w one way or another.
(Most notably, data read/write operations will complete instantaneously,
whereas on real h/w there's always some delay. There's also a hack
in the pl181 model working around a Linux 2.6.x driver bug:
    /* The linux 2.6.21 driver is buggy, and misbehaves if new data arrives
       while it is reading the FIFO.  We hack around this be defering
       subsequent transfers until after the driver polls the status word.
       http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=4446/1
     */
I hate those, because once they get into QEMU it's very hard
to get them back out again...)

> 2. What type of mmc/sd card is being modelled/used here?

The comment at the top of the source file says "as defined in the
"SD Memory Card Physical layer specification, Version 1.10."
It might even still be accurate...

The message from QEMU indicates that the SD card model's
state machine thinks that it should not be receiving data but
it has just got a pile of data from the pl181. The obvious guess
is that what you did in the CMD irq handling has moved it from
"ok for data" to something else.

Beyond that, somebody would need to reproduce with a newer
QEMU than 1.5.0 and enable debugging printfs in the kernel
and the model to figure out what the interaction is here.
Chances are quite high that this is a QEMU model bug, but it's
not 100% :-)

thanks
-- PMM
