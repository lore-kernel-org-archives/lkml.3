Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271AbbAVI3F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 03:29:05 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:42628 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbbAVI2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 03:28:55 -0500
Date: Thu, 22 Jan 2015 00:28:51 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Viet Nga Dao <vndao@altera.com>
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        nga_chi86 <ngachi86@gmail.com>
Subject: Re: [PATCH mtd] mtd:devices: Add Altera EPCQ Driver
Message-ID: <20150122082851.GB3268@brian-ubuntu>
References: <CAN1oZWxB5N=YMQcsJppZgp7TXodcR4tKZM+LNFXS7PSx3F-Yag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN1oZWxB5N=YMQcsJppZgp7TXodcR4tKZM+LNFXS7PSx3F-Yag@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viet,

On Thu, Jan 15, 2015 at 05:27:10PM +0800, Viet Nga Dao wrote:
> On Tue, Jan 13, 2015 at 11:33 AM, Brian Norris
> <computersforpeace@gmail.com> wrote:
> > On Thu, Dec 18, 2014 at 12:23:16AM -0800, vndao@altera.com wrote:
> >> From: Viet Nga Dao <vndao@altera.com>
> >>
> >> Altera EPCQ Controller is a soft IP which enables access to Altera EPCQ and
> >> EPCS flash chips. This patch adds driver for these devices.
> >>
> >> Signed-off-by: Viet Nga Dao <vndao@altera.com>
> >
> > This drivers seems awfully similar to (and so I infer it is likely
> > copy-and-pasted from) m25p80.c / spi-nor.c. Do you think it can be
> > rewritten as a SPI NOR driver, under drivers/mtd/spi-nor/ ? It looks
> > like these flash share most (all?) the same basic opcodes.
> >
> For Altera EPCQ flashes, almost operations are performed underline
> hardware.

Right, that's understandable. But that's what spi-nor.c was designed
for: implementing hardware-specific functionality that is targeted
directly at SPI flash. Did you take a look at the callbacks available in
'struct spi_nor'?

> Software only able to perform the following through
> registers:
>  -  read status register
>  -  read id
>  -  write status registers bit SR_BP0,SR_BP1, SR_BP2,SR_BP3, SR_TB
> (http://www.altera.com.my/literature/hb/cfg/cfg_cf52012.pdf)

OK.

> For read/write data: all the operations like QUAD_READ/WRITE,
> FAST_READ/WRITE are handled by hardware as well. From software point
> of view, there is no difference between these 2 modes.

OK, so you don't have to hook up the dual/quad mode infrastructure. And
you'd just implement dead-simple spi_nor.{read,write,erase}() callbacks.

> That is why if rewrite the drivers to follow spi-nor structure, it
> will require extra decoding works for the only few used opcodes.

I think you'd only have some very trivial work here.

There would be some small work to reintroduce a properly-replaceable ID
table, and callbacks like ->lock() and ->unlock(), but those should be
implemented in spi-nor.c sooner or later anyway.

Anyway, if you take another look at spi-nor.{c,h} and determine that
it's too difficult, then I suppose I don't mind accepting your driver
under its current design. Your hardware is pretty esoteric anyway, the
driver is still pretty simple, and it'll never be supporting any common
SPI NOR vendors (right?), so it's not too big of a maintenance problem,
I expect. But I do want to make sure that we don't copy/paste to repeat
the mistakes of old drivers. As I noted already, your driver inherited
some of the quirks of the old m25p80.c code.

So please, give drivers/mtd/spi-nor/ another look, and then we can
resume this discussion.

[Snip the rest; please don't forget to address these comments in your
next patch revision. BTW, I recall you sent me some other replies to my
code review comments in personal email. Please reply to the mailing list
for all code review.]

Brian
