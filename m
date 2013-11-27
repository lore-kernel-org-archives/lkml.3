Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616Ab3K0Lwg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 06:52:36 -0500
Received: from mail-yh0-f47.google.com ([209.85.213.47]:47388 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845Ab3K0Lwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 06:52:34 -0500
Date: Wed, 27 Nov 2013 11:52:26 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Brian Norris <computersforpeace@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dwmw2@infradead.org, linux-mtd@lists.infradead.org, angus.clark@st.com,
        linus.walleij@linaro.org, Mark Brown <broonie@kernel.org>,
        Huang Shijie <b32955@freescale.com>, linux-spi@vger.kernel.org
Subject: Re: [PATCH 00/23] mtd: st_spi_fsm: Add new device
Message-ID: <20131127115226.GC3296@lee--X1>
References: <1385137380-28968-1-git-send-email-lee.jones@linaro.org>
 <20131127040723.GZ9468@ld-irv-0074.broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131127040723.GZ9468@ld-irv-0074.broadcom.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> There seem to be multiple efforts going on that are vaguely related. I'd
> like to see more of the same people appearing on the CC list, to keep
> better coordinated.
> 
> On that topic, is the SPI dev list relevant, or would anybody working on
> the intersection of SPI and MTD be on the MTD list?

I think Mark is the prominent figure that this would interest.

> On Fri, Nov 22, 2013 at 04:22:37PM +0000, Lee Jones wrote:
> > The first bunch of these patches have been on the MLs before, but 
> > didn't receive a great deal of attention for the most part. We are
> > a little more featureful this time however. We can now successfully
> > setup and configure the N25Q256. We still can't read/write/erase
> > it though. I'll start work on that next week and will provide it in
> > the next instalment.
> 
> What happened to integrating a SPI NOR framework? I see you copied some
> of the m25p80 commands, but you don't share them with m25p80. I also
> understand your argument (from the first version of this patch series)
> that much of the actual controller operation is not shared with m25p80,
> but you'd be surprised how this might evolve. There are several others
> with QSPI hardware that are trying to get patches merged, some of whom
> (Huang, at least) are actively submitting patches to help with this
> abstraction.
> 
> Now, I haven't had a lot of time yet to look at both yours and Huang's
> work and see what, if anything, can be shared (will do soon). But I
> think you need to be aware.

I've taken a look at Huang's framework and it doesn't provide us with
anything extra to what the m25p80 would provide. We did have the idea
of splitting our driver into two distinct areas; the MTD part, which
we planned on using the m25p80 for and an SPI Controller portion.

However, as we send entire 'message sequences' to the FSM Controller
as opposed to merely OPCODEs we would have to extract the OPCODE from
flash->command[0] and call our own functions to craft the correct
'message sequence' for the task. For this reason we rejected the idea
and went with a stand-alone driver.

The framework which Huang is proposing suffers from the same issues.
Only providing read(), write(), read_reg() and write_reg() doesn't
work for our use-case, as we'd have to decode the flash->command[0] and
invoke our own internal routines as before.

The only framework with would work for us would consist almost all
of the important functions such as; read(), write(), erase(),
wait_busy(), read_jedec(), read_status_reg(), write_status_reg(),
read_control_reg(), write_control_reg(), etc. However, this approach
is mostly pointless. We'd be better of just using the MTD Framework's
_read, _write and _erase call-backs as we do now.

For these reasons and a bunch of others I think the best solution for
our particular use-case would be to stick with our stand-alone driver
implementation.

> BTW, can you include version markers (i.e., [PATCH v2 X/Y]) in the
> subject from now on?

Yes of course, no problem.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
