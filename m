Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679Ab3K2LyB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 06:54:01 -0500
Received: from mail-yh0-f49.google.com ([209.85.213.49]:35291 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754479Ab3K2Lx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 06:53:56 -0500
Date: Fri, 29 Nov 2013 11:53:49 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Huang Shijie <b32955@freescale.com>
Cc: Brian Norris <computersforpeace@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dwmw2@infradead.org, linux-mtd@lists.infradead.org, angus.clark@st.com,
        linus.walleij@linaro.org, Mark Brown <broonie@kernel.org>,
        linux-spi@vger.kernel.org
Subject: Re: [PATCH 00/23] mtd: st_spi_fsm: Add new device
Message-ID: <20131129115349.GB26982@lee--X1>
References: <1385137380-28968-1-git-send-email-lee.jones@linaro.org>
 <20131127040723.GZ9468@ld-irv-0074.broadcom.com>
 <20131127115226.GC3296@lee--X1>
 <5296B9C5.3060704@freescale.com>
 <20131128092904.GZ3296@lee--X1>
 <529874EE.402@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <529874EE.402@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> thanks for your explanations.
> >Most controllers just take an OPCODE and pass it on to the controller
> >and have done with it. The issue that you're attempting to rectify is
> >that the m25p80 expects every controller to be an SPI controller
> >registered to the SPI framework, but as we both know that's not always
> >practical as the SPI framework doesn't allow all configuration
> >information to be passed back to the controller driver. Our issue is
> >not the same. We are required to send entire 'message sequences', to
> >the controller rather than just opcodes. The JEDEC message sequence
> >can be seen below. Bear in mind that this is also one of the more
> >simple message sequences. Some of them even vary depending on which
> >chip is present.
> Frankly speaking, my quadspi driver's code is just like Jones's code.
> Yes, a big "switch".

That sounds awful.

It begs the question, what are you saving/improving by using this
framework then?

> The opcode is just like an index to trigger the proper operation.
> That's why i add this hook @->read_reg(). (the hook acts as the ioctl)

As I've said before, the framework you're suggesting is likely to aid
a Controller which shares a great deal of functionality with the
m25p80 where the back-end controller driver doesn't use the SPI
Subsystem. That won't apply to some Serial Flash Controller drivers,
ours included.

The idea of providing a framework like this is to reduce unnecessary
duplication of code by consolidating shared routines into a central
point. mp25p80 is a good place for that, as a great many Controllers
share the majority of its code. As the only commonality we have with
the m25p80 is a small piece of the JEDEC extraction and a sub-section
of the supported device table (which A. our Controller doesn't support
all of the devices and C. we've extended the table to make it more
useful for our use-case); what you're suggesting would not only
create a larger code-base, but execution would also take more cycles,
which to me sounds completely counter-intuitive. It's lose-lose!

Using the m25p80 as a pass-through, then creating an OPCODE based
switch statement to then go and do the _real_ work sound absurd.

> If we do not use this hooks, we should add more hooks such as
> @->read_id, @->read_sr, @->read_cr...
> 
> That's make the interface not graceful enough.

I agree.

> I read the your patch implementing the read_id:
> 
> http://lists.infradead.org/pipermail/linux-mtd/2013-November/050221.html
> 
> it's more readable. But i think Jones's stfsm_read_reg() is workable too.

It's 'workable', but not efficient. I wrote that example to show you
how bad it would look and to show that is was not a good idea, not
as a good example to be followed.

> If you do not like the read_reg() hook, do you have any better idea?

I don't have a better idea. I think your framework will work just fine
for some controllers. I just don't think bending ours to use it (by
basically adding _extra_ code, and subsequently extra cycles) is the
best way to go.

Kind regards,
Lee

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
