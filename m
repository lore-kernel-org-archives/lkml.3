Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135Ab3J2UEd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 16:04:33 -0400
Received: from mga09.intel.com ([134.134.136.24]:40083 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751380Ab3J2UEc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 16:04:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="400600165"
Message-ID: <527015CF.6000807@linux.intel.com>
Date: Tue, 29 Oct 2013 13:08:47 -0700
From: David Cohen <david.a.cohen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131005 Icedove/17.0.9
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: ning.li@intel.com, linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org,
        Fei Yang <fei.yang@intel.com>
Subject: Re: [PATCH 1/2] spi: add Intel Mid SSP driver
References: <1383069950-27754-1-git-send-email-david.a.cohen@linux.intel.com> <20131029185616.GE20251@sirena.org.uk>
In-Reply-To: <20131029185616.GE20251@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On 10/29/2013 11:56 AM, Mark Brown wrote:
> On Tue, Oct 29, 2013 at 11:05:49AM -0700, David Cohen wrote:
>> From: Fei Yang <fei.yang@intel.com>
>>
>> This patch adds driver for ssp spi interface on Intel Mid platform.
>
> Is there not any possibility of code sharing with the PXA SSP IP?  It
> seems odd that Intel would make a second IP of the same name that's
> totally incompatible...  not looked at the register interfaces in detail
> but the register names certainly look familiar.

I need to bring this question to IO team (who wrote this driver)

>
>> +	tristate "SSP SPI controller driver for Intel MID platforms (EXPERIMENTAL)"
>> +	depends on X86_INTEL_MID && SPI_MASTER && INTEL_MID_DMAC
>> +	help
>
> Are these all build time dependencies?  There's certainly no need to
> depend on SPI_MASTER, all drivers are inside an if SPI_MASTER block.
>
>> +static int ssp_timing_wr;
>
> Why is this a static global?

My only answer would be: because a lazy developer decided so :)

>
>> +#ifdef DUMP_RX
>> +static void dump_trailer(const struct device *dev, char *buf, int len, int sz)
>> +{
>
> Please add this support as a standard feature of the SPI core if it's
> useful, there's nothing specific to this driver in it.  Using trace
> would probably be better than dumping to the console.

Agreed.

>
>> +	static char msg[MAX_SPI_TRANSFER_SIZE];
>
> Where did that limit come from?

Again, I'd need to bring to IO team. I'll make sure a possible new
version comes with proper comment.

>
>> +static inline u32 is_tx_fifo_empty(struct ssp_drv_context *sspc)
>> +{
>> +	u32 sssr;
>> +	sssr = read_SSSR(sspc->ioaddr);
>> +	if ((sssr & SSSR_TFL_MASK) || (sssr & SSSR_TNF) == 0)
>
> This looks odd, why not sssr & (SSSR_TFL_MASK | SSSR_TNF)?

Agreed.

>
>> +static void flush(struct ssp_drv_context *sspc)
>> +{
>> +	void *reg = sspc->ioaddr;
>> +	u32 i = 0;
>> +
>> +	/* If the transmit fifo is not empty, reset the interface. */
>> +	if (!is_tx_fifo_empty(sspc)) {
>> +		dev_err(&sspc->pdev->dev, "TX FIFO not empty. Reset of SPI IF");
>> +		disable_interface(sspc);
>> +		return;
>> +	}
>
> This isn't a flush then?

Analyzing the code I'd say this flush() function is actually a reset
for tx fifo and flush for rx fifo.
Maybe we need a better name for it.

>
>> +	dev_dbg(&sspc->pdev->dev, " SSSR=%x\r\n", read_SSSR(reg));
>
> No extra space at the start of the message and why is there a \r in
> there?  Throughout the driver your log messages have a range of odd
> formatting quirks that aren't consistent and don't look like normal
> Linux log messages either.
>
> Please also check the severity of your messages, many of them seem too
> loud.

I'll handle that.

>
>> +	while (!is_rx_fifo_empty(sspc) && (i < SPI_FIFO_SIZE + 1)) {
>> +		read_SSDR(reg);
>> +		i++;
>> +	}
>
> What happens if the FIFO doesn't drain?

I'll let Ning answer this question.

>
>> +	WARN(i > 0, "%d words flush occured\n", i);
>
> This seems *very* loud for a flush operation...

Agreed.

>
>> +	if (sspc->quirks & QUIRKS_SRAM_ADDITIONAL_CPY) {
>> +		sspc->virt_addr_sram_rx = ioremap_nocache(SRAM_BASE_ADDR,
>> +				2 * MAX_SPI_TRANSFER_SIZE);
>
> This doesn't look terribly clever, it's remapping a hard coded address
> rather than getting the address enumerated from a device enumeration
> interface.

I'll check if I can recover this value from somewhere without changing
fw. Otherwise we could mark it as FIXME and change later in a different
patch.

>
>> +	/* get Data Read/Write address */
>> +	ssdr_addr = (dma_addr_t)(sspc->paddr + 0x10);
>
> I'm not entirely sure what this does but it looks dodgy...  what's the
> cast doing for a start?

The answer to your question is: the cast is pointless and can be
removed :)
0x10 is an offset to paddr. We need to replace it by a macro with
proper name to make this clear.

>
>> +		/* In Rx direction, TRAIL Bytes are handled by memcpy */
>
> Please don't randomly CAPITALISE words.

Sorry ABOUT that :)
I'll fix it.

>
>> +	rxdesc = rxchan->device->device_prep_dma_memcpy
>> +		(rxchan,			/* DMA Channel */
>> +		sspc->rx_dma,			/* DAR */
>> +		ssdr_addr,			/* SAR */
>> +		sspc->len_dma_rx,		/* Data Length */
>> +		flag);					/* Flag */
>
> What's going on here?  Why is there a DMAed memcpy()?  This doesn't
> reflect normal DMA usage in SPI drivers at all, I'd expect to see
> dmaengine_prep_ being used.

I'll let this question again to Ning.

>
>> +static void int_transfer_complete(struct ssp_drv_context *sspc)
>> +{
>> +	void *reg = sspc->ioaddr;
>> +	struct spi_message *msg;
>> +	struct device *dev = &sspc->pdev->dev;
>> +
>> +	if (unlikely(sspc->quirks & QUIRKS_USE_PM_QOS))
>> +		pm_qos_update_request(&sspc->pm_qos_req,
>> +					PM_QOS_DEFAULT_VALUE);
>
> Why is this a quirk and not abstracted away by the PM QoS API on
> platforms that don't need it?  I'd also expect these updates to be done
> in runtime PM callbacks so that if two transfers follow one another we
> don't bounce the Qos up and down.

Got it. I'll change this code.

>
>> +	dev_dbg(dev, "End of transfer. SSSR:%08X\n", read_SSSR(reg));
>> +	msg = sspc->cur_msg;
>> +	if (likely(msg->complete))
>> +		msg->complete(msg->context);
>> +	complete(&sspc->msg_done);
>
> Remove all these likely()s, they're making the code less clear and seem
> vanishingly unlikely to have any practical impact on performance.

Agreed.

>
>> +static void int_transfer_complete_work(struct work_struct *work)
>> +{
>> +	struct ssp_drv_context *sspc = container_of(work,
>> +				struct ssp_drv_context, complete_work);
>> +
>> +	int_transfer_complete(sspc);
>> +}
>
> This wrapper function doesn't seem terribly useful...  why not just
> inline it into the internal function?

That seems reasonable. I'll change it.

>
>> +	if (status & SSSR_ROR || status & SSSR_TUR) {
>> +		dev_err(dev, "--- SPI ROR or TUR occurred : SSSR=%x\n",	status);
>> +		WARN_ON(1);
>> +		if (status & SSSR_ROR)
>> +			dev_err(dev, "we have Overrun\n");
>> +		if (status & SSSR_TUR)
>> +			dev_err(dev, "we have Underrun\n");
>> +	}
>> +
>> +	/* We can fall here when not using DMA mode */
>> +	if (!sspc->cur_msg) {
>> +		disable_interface(sspc);
>> +		disable_triggers(sspc);
>> +	}
>> +	/* clear status register */
>> +	write_SSSR(sspc->clear_sr, reg);
>
> More comments explaining what's going on here would be good...

We'll provide.

>
>> +static void poll_transfer(unsigned long data)
>> +{
>> +	struct ssp_drv_context *sspc = (void *)data;
>> +
>> +	if (sspc->tx) {
>> +		while (sspc->tx != sspc->tx_end) {
>> +			if (ssp_timing_wr) {
>> +				int timeout = 100;
>> +				/* It is used as debug UART on Tangier. Since
>> +				   baud rate = 115200, it needs at least 312us
>> +				   for one word transferring. Becuase of silicon
>> +				   issue, it MUST check SFIFOL here instead of
>> +				   TNF. It is the workaround for A0 stepping*/
>> +				while (--timeout &&
>> +					((read_SFIFOL(sspc->ioaddr)) & 0xFFFF))
>> +					udelay(10);
>> +			}
>
> This doesn't look like it shouldn't be here at all or should be made
> more generic but I can't really tell what it's supposed to do...

Ning?

>
>> +static void start_bitbanging(struct ssp_drv_context *sspc)
>> +{
>
> The SPI core has bitbanging helpers which you don't seem to be using.
> However...
>
>> +	/* Bit bang the clock until CSS clears */
>> +	while ((sssr & 0x400000) && (count < MAX_BITBANGING_LOOP)) {
>> +		write_I2CDATA(0x2, i2c_reg);
>> +		udelay(I2C_ACCESS_USDELAY);
>
> ...this code is talking about I2C?
>
>> +		udelay(I2C_ACCESS_USDELAY);
>> +		write_I2CCTRL(0x01070034, i2c_reg);
>
> This appears to be randomly bashing on an absolute register address.

Ouch. I'll fix it.

>
>> +/**
>> + * transfer() - Start a SPI transfer
>> + * @spi:	Pointer to the spi_device struct
>> + * @msg:	Pointer to the spi_message struct
>> + */
>> +static int transfer(struct spi_device *spi, struct spi_message *msg)
>
> Use of plain transfer() has been deprecated since v3.4, you should at
> least be using transfer_one_message().  I've stopped reviewing at this
> point since a lot of the rest of the code is replicating stuff that's in
> the SPI core and will go away when you update to use the current APIs.

Thanks. This driver needs to be rewritten.
I'll make sure to address your feedback in next version.

Br, David

