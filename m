Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758730Ab3DYOF7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 10:05:59 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:62766 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758208Ab3DYOF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 10:05:57 -0400
MIME-Version: 1.0
In-Reply-To: <20130425134402.GN4623@gmail.com>
References: <1366280825-31136-1-git-send-email-lee.jones@linaro.org>
	<1366280825-31136-7-git-send-email-lee.jones@linaro.org>
	<CACRpkdbFgW6bGYt59WtN4r2izuN09AJw4J1cqir82uzFsuMmWQ@mail.gmail.com>
	<20130425134402.GN4623@gmail.com>
Date: Thu, 25 Apr 2013 16:05:57 +0200
Message-ID: <CACRpkdaugQO5aMBnfvD8fmYkKbiWsHwvqg3=eARovqFe9MDExw@mail.gmail.com>
Subject: Re: [PATCH 6/9] crypto: ux500/cryp - Set DMA configuration though dma_slave_config()
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Andreas Westin <andreas.westin@stericsson.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        magnus.p.persson@stericsson.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 25, 2013 at 3:44 PM, Lee Jones <lee.jones@linaro.org> wrote:
> On Thu, 25 Apr 2013, Linus Walleij wrote:
>> On Thu, Apr 18, 2013 at 12:27 PM, Lee Jones <lee.jones@linaro.org> wrote:
>>
>> > The DMA controller currently takes configuration information from
>> > information passed though dma_channel_request(), but it shouldn't.
>> > Using the API, the DMA channel should only be configured during
>> > a dma_slave_config() call.
>> >
>> > Cc: Herbert Xu <herbert@gondor.apana.org.au>
>> > Cc: David S. Miller <davem@davemloft.net>
>> > Cc: Andreas Westin <andreas.westin@stericsson.com>
>> > Cc: linux-crypto@vger.kernel.org
>> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
>>
>> (...)
>> >  /* Cryp DMA interface */
>> > +#define HASH_DMA_TX_FIFO       0x08
>> > +#define HASH_DMA_RX_FIFO       0x10
>>
>> Yes, this is nice address notation :-)
>>
>> >  /**
>> >   * struct cryp_device_data - structure for a cryp device.
>> > - * @base: Pointer to the hardware base address.
>> > + * @base: Pointer to virtual base address of the cryp device.
>> > + * @phybase: Pointer to physical memory location of the cryp device.
>> >   * @dev: Pointer to the devices dev structure.
>> >   * @clk: Pointer to the device's clock control.
>> >   * @pwr_regulator: Pointer to the device's power control.
>> > @@ -232,6 +236,7 @@ struct cryp_dma {
>> >   */
>> >  struct cryp_device_data {
>> >         struct cryp_register __iomem *base;
>> > +       phys_addr_t phybase;
>>
>> Use dma_addr_t. Maybe "phybase" is misleading,
>> "dmabase" is probably better. (Also applies to the
>> cryp patch).
>
> Accept it's not the dmabase.
>
> It's the phybase (U8500_CRYP1_BASE) i.e. the physical base address of
> the device's regs.

So when you assign the src_addr or dst_addr in struct
dmaengine_slave_config in this code,
you notice that this looks like so:

struct dma_slave_config {
        enum dma_transfer_direction direction;
        dma_addr_t src_addr;
        dma_addr_t dst_addr;
        enum dma_slave_buswidth src_addr_width;
        enum dma_slave_buswidth dst_addr_width;
        u32 src_maxburst;
        u32 dst_maxburst;
        bool device_fc;
};

So when you do this:

+       struct dma_slave_config mem2cryp = {
+               .direction = DMA_MEM_TO_DEV,
+               .dst_addr = device_data->phybase + HASH_DMA_TX_FIFO,
+               .dst_addr_width = DMA_SLAVE_BUSWIDTH_2_BYTES,
+               .dst_maxburst = 4,
+        };

on .dst_addr you are effectively casting a phys_addr_t
into a dma_addr_t.

But  we must do this at some point, and now I think
that doing it here may be just as good (because we might
just add a physical-to-dma memory translation if need
be).

So allright.

Yours,
Linus Walleij
