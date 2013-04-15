Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193Ab3DONrd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 09:47:33 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:53972 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282Ab3DONrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 09:47:31 -0400
MIME-Version: 1.0
In-Reply-To: <20130415115906.GF6512@gmail.com>
References: <1365532783-27425-1-git-send-email-lee.jones@linaro.org>
	<1365532783-27425-3-git-send-email-lee.jones@linaro.org>
	<CAH+eYFB_fYmCjvh5PXKRhd-FnaWfeu+LtH+q3VywhCk-PYhHVQ@mail.gmail.com>
	<20130415110601.GE6512@gmail.com>
	<CAH+eYFB2+oMPXsnzQVVrEK8CjKGVYFa_n4Wxr=CpdtJwFfOGYw@mail.gmail.com>
	<20130415115906.GF6512@gmail.com>
Date: Mon, 15 Apr 2013 15:47:30 +0200
Message-ID: <CACRpkdawUPPzh-EgVdmvOVP2SOjgKXYrfus=yMee7n+PtAQPHg@mail.gmail.com>
Subject: Re: [PATCH 3/8] dmaengine: ste_dma40: Actually write the runtime
 configuration to registers
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Rabin Vincent <rabin@rab.in>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 15, 2013 at 1:59 PM, Lee Jones <lee.jones@linaro.org> wrote:
> On Mon, 15 Apr 2013, Rabin Vincent wrote:
>> 2013/4/15 Lee Jones <lee.jones@linaro.org>:
>> > On Fri, 12 Apr 2013, Rabin Vincent wrote:
>> >> 2013/4/9 Lee Jones <lee.jones@linaro.org>:
>> >> > Someone has spent a fair amount of effort writing a runtime configuration
>> >> > changing algorithm for DMA clients. However, the config appears to never
>> >> > actually make it to hardware. In order for the configuration to take hold
>> >> > we need to issue a d40_config_write(), as this is the routine which writes
>> >> > it into the hardware's registers.
>> >>
>> >> No, it's not.  This function is only for initial configuration which
>> >> should only be written when the channel is allocated.  In fact, by
>> >> calling it here in runtime_config, you are introducing a serious bug:
>> >> other logical channels on the same physical channel will stop because of
>> >> the SSLNK/SDLNK of the physical channel being zeroed.
>> >>
>> >> The runtime config already makes it the hardware in the existing code,
>> >> via d40_*_cfg().
>> >
>> > Sorry Rabin, but the only place I can see the config being written is
>> > in d40_config_write().
>> >
>> > Can you paste the line of code in d40_*_cfg() which actually writes
>> > the config to hardware please? I don't see it.
>>
>> It's not that simple.  There are some pointers passed to d40_*_cfg() and
>> that function writes the configuration to the variables those pointers
>> point to (d40c->log_def.lcsp1, d40c->src_def_cfg, etc.).  Please read
>> the code to see how those variables end up being used later when the
>> LLIs are prepared for the HW.
>
> I have read the code, which is why I know that the config only gets
> written in d40_config_write(). :)
>
> So the configuration which gets set in the runtime_config routine
> doesn't ever make it to hardware - hence this patch.
>
> Unless I'm missing something?

The runtime config sets up the config for all *subsequent* jobs.
struct d40_chan contains e.g. runtime_addr, runtime_direction
etc to store up the stuff being configured. This is done for
all the other config as well using d40_log_cfg() or
d40_phy_cfg(), and the result is cached in the channel
struct, here called d40c.

Next, when preparing jobs, the DMA40 LLI engine will fill in
job descriptors using e.g. d40_get_dev_addr()
and pick settings from this cached runtime config.

When the subsequent jobs trigger, it allocates channel resources
by calling d40_alloc_chan_resources(). The config is written to the
hardware by calling d40_config_write().

So the basic misunderstanding here is that you think
the config shall take effect immediately, that is not the
idea. The configuration will be cached in the channel
struct, then it will take effect when the next job that is
queued up allocates its resources to commence.

Maybe you haven't grasped the asynchronous nature
of the DMAengine? It's a bit like multithreading. You
queue up things, then they commence at a later time.
Not immediately.

Example: the SPI driver for PL022 may talk to a
8, 16 or 32bit capable device. Depending on which device
it wants to queue a job for, it need to be configured differently,
like for another width.

At the time you are queueing a new job, another job may
already be in flight. If you issue d40_config_write() at this
point, you will cause undesired effects to the job that may
already be running. Such as reconfiguring the width
of the channel.

You may not observe that bug because there is no
job in flight, or because the actual configuration is identical
for two consecutive jobs, but if you're really stressing something,
queuing jobs while others are already in flight, you will
see it immediately.

Therefore, this patch should be dropped.

Yours,
Linus Walleij
