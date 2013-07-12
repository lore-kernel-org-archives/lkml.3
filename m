Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757587Ab3GLKmL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 06:42:11 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:62391 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757350Ab3GLKmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 06:42:09 -0400
MIME-Version: 1.0
In-Reply-To: <20130710134624.GC2615@book.gsilab.sittig.org>
References: <1373451678-20065-1-git-send-email-a13xp0p0v88@gmail.com>
	<20130710134624.GC2615@book.gsilab.sittig.org>
Date: Fri, 12 Jul 2013 14:42:07 +0400
Message-ID: <CAF0T0X5MDGkBDrVBpKr2OTW4rqxg+nizFs9AdwbL0kAfoR3xcw@mail.gmail.com>
Subject: Re: [V2 2/2] powerpc/512x: add LocalPlus Bus FIFO device driver
From: Alexander Popov <a13xp0p0v88@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Anatolij Gustschin <agust@denx.de>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Chris Ball <cjb@laptop.org>,
        Sascha Hauer <s.hauer@pengutronix.de>, Timur Tabi <timur@tabi.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Gerhard

Thanks for the review.
I'll do my best to answer your questions and fix my code.


2013/7/10 Gerhard Sittig <gsi@denx.de>:
> On Wed, Jul 10, 2013 at 14:21 +0400, Alexander Popov wrote:
>> +/*
>> + * SCLPC Module (LPB FIFO)
>> + */
>> +enum lpb_dev_portsize {
>> +     LPB_DEV_PORTSIZE_UNDEFINED = 0,
>> +     LPB_DEV_PORTSIZE_1_BYTE = 1,
>> +     LPB_DEV_PORTSIZE_2_BYTES = 2,
>> +     LPB_DEV_PORTSIZE_4_BYTES = 4,
>> +     LPB_DEV_PORTSIZE_8_BYTES = 8,
>> +};
>> +
>> +enum mpc512x_lpbfifo_req_dir {
>> +     MPC512X_LPBFIFO_REQ_DIR_READ,
>> +     MPC512X_LPBFIFO_REQ_DIR_WRITE,
>> +};
>> +
>> +struct mpc512x_lpbfifo_request {
>> +     unsigned int cs;
>> +     phys_addr_t bus_phys;   /* physical address of some device on lpb */
>> +     void *ram_virt;         /* virtual address of some region in ram */
>> +
>> +     /* Details of transfer */
>> +     u32 size;
>> +     enum lpb_dev_portsize portsize;
>> +     enum mpc512x_lpbfifo_req_dir dir;
>> +
>> +     /* Call when the transfer is finished */
>> +     void (*callback)(struct mpc512x_lpbfifo_request *);
>> +};
>> +
>> +extern int mpc512x_lpbfifo_submit(struct mpc512x_lpbfifo_request *req);
>> +
>>  #endif /* __ASM_POWERPC_MPC5121_H__ */

> Needs the mpc512x_lpbfifo_request structure be part of the
> official API?  Could it be desirable to hide it behind a
> "fill-in" routine?  Which BTW could auto-determine CS numbers and
> port width associated with a chip select from the XLB and LPB
> register set?

1. As I wrote at the beginning of the file, the driver design
is based on mpc52xx_lpbfifo driver written by Grant Likely.

2. CS and port width are attributes of some device on LPBus
which participates DMA data transfer. It is the driver of this device
who knows them.
It fills mpc512x_lpbfifo_request as a client side of that API.

> Who's using the submit routine?  I might have missed the "client
> side" of that API in the series.

Please look at https://patchwork.kernel.org/patch/2511951/


>> +obj-$(CONFIG_PPC_MPC512x_LPBFIFO) += mpc512x_lpbfifo.o
>>  obj-$(CONFIG_MPC5121_ADS)    += mpc5121_ads.o mpc5121_ads_cpld.o
>>  obj-$(CONFIG_MPC512x_GENERIC)        += mpc512x_generic.o

> s/PPC_// here to align with the other tunables?

I'll fix that :)


>> +MODULE_AUTHOR("Alexander Popov <a13xp0p0v88@gmail.com>");
>> +MODULE_DESCRIPTION("MPC512x LocalPlus FIFO device driver");
>> +MODULE_LICENSE("GPL");

>aren't these usually at the end of the source for quick lookup?

I'll fix that too.


>> +#define LPBFIFO_REG_PACKET_SIZE              (0x00)
>> +#define LPBFIFO_REG_START_ADDRESS    (0x04)
>> +#define LPBFIFO_REG_CONTROL          (0x08)
>> +#define LPBFIFO_REG_ENABLE           (0x0C)
>> +#define LPBFIFO_REG_STATUS           (0x14)
>> +#define LPBFIFO_REG_BYTES_DONE               (0x18)
>> +#define LPBFIFO_REG_EMB_SHARE_COUNTER        (0x1C)
>> +#define LPBFIFO_REG_EMB_PAUSE_CONTROL        (0x20)
>> +#define LPBFIFO_REG_FIFO_DATA                (0x40)
>> +#define LPBFIFO_REG_FIFO_STATUS              (0x44)
>> +#define LPBFIFO_REG_FIFO_CONTROL     (0x48)
>> +#define LPBFIFO_REG_FIFO_ALARM               (0x4C)

> Should this not be a struct?  Since using member field names
> allows for compile time checks of data types, which is highly
> desirable with registers of arbitrarily differing size.

I've read
https://lists.ozlabs.org/pipermail/linuxppc-dev/2010-January/079476.html
Which way should I use?


> You may as well want to define bit masks or shift counts here, to
> keep magic numbers out of the code.

Yes, I'll try to get rid of them.


>> +
>> +#define DMA_LPC_CHANNEL_NUMBER               26
>> +#define DEFAULT_WORDS_PER_TRANSFER   1

> can you eliminate the DMA channel number in the DMA client
> source?  this shall be intimate knowledge of the DMA engine
> driver, or at least get specified in the device tree

> BTW did Anatolij suggest OF based DMA channel lookup back in May,
> see commit e48fc15 and search for 'rx-tx' in the mxcmmc.c file

Ok, thanks, I've found it. I'll make OF based DMA channel lookup.


>> +/*
>> + * Before we can wrap up handling current mpc512x_lpbfifo_request
>> + * and execute the callback registered in it we should:
>> + *  1. recognize that everything is really done,
>> + *  2. free memory and dmaengine channel.
>> + *
>> + * Writing from RAM to registers of some device on LPB (transmit)
>> + * is not really done until the LPB FIFO completion irq triggers.
>> + *
>> + * For being sure that writing from registers of some device on LPB
>> + * to RAM (receive) is really done we should wait
>> + * for mpc512x_lpbfifo_callback() to be called by DMA driver.
>> + * In this case LPB FIFO completion irq will not appear at all.
>> + *
>> + * Moreover, freeing memory and dmaengine channel is not safe until
>> + * mpc512x_lpbfifo_callback() is called.
>> + *
>> + * So to make it simple:
>> + * last one out turns off the lights.
>> + */

> Can this "feedback order issue" handling get simplified by having
> both the LPB controller FIFO and the DMA completion callback
> invoke a single routine, which tracks the "LPB done" and "DMA
> done" conditions regardless of their order, and does
> postprocessing when both were satisfied?
>
> It might be desirable to always run the postprocessing only if
> both involved components finished their activities, regardless of
> the transfer's direction.  This reduces the potential for access
> to invalid data if these two events are "racy".

Excuse me, I didn't understand your idea.
I thought my code is already quite simple.

Postprocessing is short: just clean lpbfifo.req and run client's callback.
DEV->MEM: only DMA callback appears. It should simply execute postprocessing.
MEM->DEV: both DMA callback and LPBFIFO irq appear. Both of them
should be done before postprocessing. I.e. the last one should
"turn off the lights". Last one is determined using lpbfifo.im_last
protected by spinlock.

I guess my comment describing that is not clear enough, is it?


>> +     /* 1. Check requirements: */
>> +     /* Packet size must be a multiple of 4 bytes since
>> +      * FIFO Data Word Register (which provides data to DMA controller)
>> +      * allows only "full-word" (4 bytes) access
>> +      * according Reference Manual */

> Are you certain about that constraint?  Can't the packet size be
> an "incomplete multiple" of the SCLPC FIFO port's width when the
> last data item is appropriately aligned?

The Reference Manual (page 538) says about FIFO Data Word Register:
Only full-word access is allowed. If all byte enables are not asserted
when accessing this location, a FIFO error flag is generated.

> Since you can attach 8bit, 16bit, as well as 32bit wide
> peripherals to the LPB (the external bus), I feel that insisting
> in full 32bits getting transferred may be inappropriate.  Unless
> I'm missing something, and it's an SCLPC contraint while the
> CPU's access to the LPB isn't limited.

I think there is no contradiction between allowing only full-word
access to SCLPC FIFO port and allowing different BPT (bytes per transfer)
on LPBus at the same time.
I guess it might mean that you should fill (empty) FIFO by 32bit portions
from the processor side and empty (fill) it from the LPBus side by portions
you want. Moreover the Reference Manual says that if you have some device
with for example 8bit port on LPBus, you just should set BPT to 8 and set DAI
(disable auto increment) bit to 1 in SCLPC Control Register.


>> +     /* 4. Set packet size and kick FIFO off */
>> +     bits = req->size;
>> +     bits |= (1<<31); /* set restart bit */
>> +     out_be32(lpbfifo.regs + LPBFIFO_REG_PACKET_SIZE, bits);

> here you start the SCLPC transfer ...

>> +
>> +
>> +     /* 5. Then kick DMA off */
>> +     cookie = dma_tx->tx_submit(dma_tx);
>> +     if (dma_submit_error(cookie)) {
>> +             pr_err("DMA tx_submit failed\n");
>> +             e = -ENOSPC;
>> +             goto err_dma_submit;
>> +     }

> ... and here you setup the DMA job -- isn't this too late?
> (Please note that I haven't re-checked the "functional
> description" section in the DMA controller's chapter.)

I did it according "SCLPC Programming" chapter (21.3.3.1) in Reference Manual.


>> +
>> +     /* (128 kBytes - 4 Bytes) is a maximum packet size
>> +      * that LPB FIFO and DMA controller can handle together
>> +      * while exchanging DEFAULT_WORDS_PER_TRANSFER = 1
>> +      * per hardware request */

> Could you state what the individual limits are?
>
> I guess the SCLPC can transfer gigabytes, the FIFO depth either
> should not matter or is dramatically lower than 128KB (1K?).

Yes, that's true.

> Is the DMA controller the limiting element, and how so?  Does the
> limit not depend on the biter and citer and width specs?

DMA controller is the limiting element:
maximum_packet_size = maximum_BITER_value * NBYTES.
NBYTES of data is read from / written to SCLPC FIFO in one burst
after DMA controller receives service request from SCLPC.

But SCLPC wants NBYTES to be 4 bytes, because:
thorough testing showed that DMA works with FIFO faster than SCLPC.
During DEV->MEM transfer SCLPC FIFO high watermark (the level
of data in FIFO at which SCLPC should send service request to DMA controller)
must be equal to NBYTES. If not, DMA controller reading from FIFO
overtakes SCLPC
writing to FIFO and FIFO underflow error happens.

Of course, making DEV->MEM transfer FIFO high watermark bigger than 4 bytes
would make NBYTES and maximum_packet_size bigger.

But in that case we would have to align packet size by something bigger
than 4 bytes. I consider it more awkward for clients than 128 kBytes limit of
packet size. I guess devices on LPBus (network switches, nvram, etc.)
would not suffer from this packet size limit.

What do you think?


> Is the
> limit mentioned here (in the LPB related code) assuming knowledge
> of the DMA driver's internals?

Yes, it is. It's not good, I should put size check to mpc512x_dma.c.


>> +     rc = request_irq(lpbfifo.irq,
>> +                             mpc512x_lpbfifo_irq, 0, DRV_NAME, &lpbfifo);

> whitespace (alignment of continuation)
> (just noticed here, not explicitely checked elsewhere, unless
> it's a misdetection caused by TABs and email quotation)

There are only several tabs here, checkpatch.pl didn't complain.
Which rule could I break?


Thanks again, Gerhard.

Best regards,
Alexander
