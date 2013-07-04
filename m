Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756472Ab3GDJCy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 05:02:54 -0400
Received: from www.linutronix.de ([62.245.132.108]:39978 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381Ab3GDJCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 05:02:50 -0400
Message-ID: <51D53A31.3080704@linutronix.de>
Date: Thu, 04 Jul 2013 11:02:41 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130518 Icedove/17.0.5
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        =?windows-1252?Q?Beno=EEt_Cousson?= <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jonathan Cameron <jic23@cam.ac.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: [PATCH 01/22] mfd/ti_am335x_tscadc: remove regmap
References: <1370950268-7224-1-git-send-email-bigeasy@linutronix.de> <1370950268-7224-2-git-send-email-bigeasy@linutronix.de> <20130611142336.GE29135@zurbaran> <51B7358D.7000605@linutronix.de> <20130614135358.GR1403@sirena.org.uk> <51BEF5F4.4090600@linutronix.de> <20130617160326.GE1403@sirena.org.uk>
In-Reply-To: <20130617160326.GE1403@sirena.org.uk>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the long pause…

On 06/17/2013 06:03 PM, Mark Brown wrote:
>> This is a lot of for a simple mmio access. In terms of
>> performance: If I add a trace point to my read and write I have
>> still less code which is called and it can be disabled. This
>> regmap overhead is always there chasing pointers.
> 
> Equally well what you're implementing here is support for
> something that's typically implemented with an I2C or SPI control
> interface so you're already going to be quite a way ahead of the
> norm.  This is part of what's confusing me, usually for this
> application things aren't that bad performance wise even on a
> massively slower bus.
> 
> If all you're saying here is that there's some overhead that's fine
> if a bit surprising, but the way you're talking made it sound like
> there was some issue that made the API actually unusable.

No, sorry for that confusion. I had a problem with the locking in irq
context, changed the driver & pointed out the problem, been told that
there is a fix, applied it, never complained again.

This is simply about I am forced to use regmap and I don't agree with
it.

>> As I said before: I doubt that you get this regmap access in an
>> one GiB network driver and in turn remove their trace points to
>> register access.
> 
> Well, of course for that sort of thing the general trick is not to
> talk to the hardware at all and do as much as possible with memory
> that the hardware can DMA - there's actually still non-trivial
> costs in talking over the buses.

That is true but even while doing DMA you have enough handshake with
the HW to trigger the transfer and if you are lucky your DMA
descriptors are in cached memory.

>> Please don't get me wrong: It is still nice for slow buses and
>> this ADC driver isn't anything close to high performance like a
>> 1GiB network driver but it adds a lot of unwanted overhead which
>> I prefer not to have.
> 
> OK, but equally well remember that from a subsystem maintainer
> point of view having things factored out is a win in itself; for
> example with the MFDs locking on the register I/O has been a
> persistent issue in the past.

I agree with that. But:

The driver here does not use atomic updates but read followed by write
so your locking here is futile. So the API/regmap alone does not make
it right. And look: the MFD part uses regmap. Its children (IIO &
input) do not use it. After I told this Samuel he said that it is okay.
So here I am. Using regmap in MFD which is only used once on init and
never again. It has regmap.

The register access in both child driver is split making sure they do
not use the same ones. I added one function which writes a common
register. That one is reset after an operation and needs to be written
by the currently active child so the HW continues to work. Haven't seen
anything close to it in regmap.

I ask, politely I hope, to get this patch in and remove regmap since
none of its features are used in this driver.

Sebastian
