Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449Ab3GQJDb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 05:03:31 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:58608 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935Ab3GQJDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 05:03:25 -0400
X-Auth-Info: 9h8VvY9A3ZQuBDm3vwF0xhPPJ5ogyM60rVonlV7z+40=
Date: Wed, 17 Jul 2013 11:03:10 +0200
From: Gerhard Sittig <gsi@denx.de>
To: Alexander Popov <a13xp0p0v88@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Anatolij Gustschin <agust@denx.de>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Chris Ball <cjb@laptop.org>,
        Sascha Hauer <s.hauer@pengutronix.de>, Timur Tabi <timur@tabi.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [V2 2/2] powerpc/512x: add LocalPlus Bus FIFO device driver
Message-ID: <20130717090310.GI7080@book.gsilab.sittig.org>
Mail-Followup-To: Alexander Popov <a13xp0p0v88@gmail.com>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Paul Mackerras <paulus@samba.org>,
	Anatolij Gustschin <agust@denx.de>,
	Grant Likely <grant.likely@linaro.org>,
	Rob Herring <rob.herring@calxeda.com>, Chris Ball <cjb@laptop.org>,
	Sascha Hauer <s.hauer@pengutronix.de>, Timur Tabi <timur@tabi.org>,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
References: <1373451678-20065-1-git-send-email-a13xp0p0v88@gmail.com>
 <20130710134624.GC2615@book.gsilab.sittig.org>
 <CAF0T0X5MDGkBDrVBpKr2OTW4rqxg+nizFs9AdwbL0kAfoR3xcw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF0T0X5MDGkBDrVBpKr2OTW4rqxg+nizFs9AdwbL0kAfoR3xcw@mail.gmail.com>
Organization: DENX Software Engineering GmbH
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 12, 2013 at 14:42 +0400, Alexander Popov wrote:
> 
> 2013/7/10 Gerhard Sittig <gsi@denx.de>:
> > On Wed, Jul 10, 2013 at 14:21 +0400, Alexander Popov wrote:
> >> 
> >> +
> >> +struct mpc512x_lpbfifo_request {
> >> +     unsigned int cs;
> >> +     phys_addr_t bus_phys;   /* physical address of some device on lpb */
> >> +     void *ram_virt;         /* virtual address of some region in ram */
> >> +
> >> +     /* Details of transfer */
> >> +     u32 size;
> >> +     enum lpb_dev_portsize portsize;
> >> +     enum mpc512x_lpbfifo_req_dir dir;
> >> +
> >> +     /* Call when the transfer is finished */
> >> +     void (*callback)(struct mpc512x_lpbfifo_request *);
> >> +};
> >> +
> >> +extern int mpc512x_lpbfifo_submit(struct mpc512x_lpbfifo_request *req);
> >> +
> >>  #endif /* __ASM_POWERPC_MPC5121_H__ */
> 
> > Needs the mpc512x_lpbfifo_request structure be part of the
> > official API?  Could it be desirable to hide it behind a
> > "fill-in" routine?  Which BTW could auto-determine CS numbers and
> > port width associated with a chip select from the XLB and LPB
> > register set?
> 
> 1. As I wrote at the beginning of the file, the driver design
> is based on mpc52xx_lpbfifo driver written by Grant Likely.
> 
> 2. CS and port width are attributes of some device on LPBus
> which participates DMA data transfer. It is the driver of this device
> who knows them.

I don't think so (I disagree with the "driver knows physical bus
attributes" part).

Bus width, endianess, timing in access, etc are all properties of
a chip select.  And the chip select is associated with an address
range.  See the CS part of the LPB controller, and the LAW part
of the XLB.  Given a physical address, everything else can get
determined from inspecting the SoC's registers.

Just think what the SoC does:  "Someone", probably the CPU or a
bus master like DMA, accesses an address, which happens to be
within an address window, which happens to be connected to some
bus and maybe map to a chip select, which happens to use the chip
select's configuration for the activity on the associated bus --
upon memory access nobody needs to explicitly know whether SRAM
or DRAM or IMMR or LPB aka EMB is involved, it's all hidden
within the XLB logic.  I feel that the SCLPC job description is
an exception, and the need to specify a CS index is the unusual
case.

Drivers actually _need_not_ know the CS number or bus width of
what's attached to the EMB.  Those parameters usually get setup
within boot loaders and the kernel need not care.  Linux drivers
merely map an address range and "just access memory that happens
to have some arbitrary address".  Drivers need not care whether
the bus is internal or external nor whether the bus has several
chip selects nor how these might be configured.  The recent
addition to re-configure a chip select already was a special case
of differing configuration during runtime (when the firmware gets
sent, and when the firmware is used and communicated to), and is
by no means the normal case.

> It fills mpc512x_lpbfifo_request as a client side of that API.
> 
> > Who's using the submit routine?  I might have missed the "client
> > side" of that API in the series.
> 
> Please look at https://patchwork.kernel.org/patch/2511951/

This answers how the current implementation is, not necessarily
how the API should or might be.

But I wasn't requesting immediate change, just was pointing at
potential for improvement.


> >> +#define LPBFIFO_REG_PACKET_SIZE              (0x00)
> >> +#define LPBFIFO_REG_START_ADDRESS    (0x04)
> >> +#define LPBFIFO_REG_CONTROL          (0x08)
> >> +#define LPBFIFO_REG_ENABLE           (0x0C)
> >> +#define LPBFIFO_REG_STATUS           (0x14)
> >> +#define LPBFIFO_REG_BYTES_DONE               (0x18)
> >> +#define LPBFIFO_REG_EMB_SHARE_COUNTER        (0x1C)
> >> +#define LPBFIFO_REG_EMB_PAUSE_CONTROL        (0x20)
> >> +#define LPBFIFO_REG_FIFO_DATA                (0x40)
> >> +#define LPBFIFO_REG_FIFO_STATUS              (0x44)
> >> +#define LPBFIFO_REG_FIFO_CONTROL     (0x48)
> >> +#define LPBFIFO_REG_FIFO_ALARM               (0x4C)
> 
> > Should this not be a struct?  Since using member field names
> > allows for compile time checks of data types, which is highly
> > desirable with registers of arbitrarily differing size.
> 
> I've read
> https://lists.ozlabs.org/pipermail/linuxppc-dev/2010-January/079476.html
> Which way should I use?

The way Grant puts it, there are valid reasons for both
approaches and things may turn out to be a matter of preference.
As is written in the post you refer to, neither of them is in
itself right or wrong and leads to immediate rejection, it's just
that one of them appears more appropriate in a specific
situation.

Given that we are dealing with SoC internal IP peripherals, their
physical attachment is known and stable, the register layout and
data width is a given.  The phrase out_be32(&regs->field, val) is
so much more readable than fiddling with a base and offsets.
Data types and __iomem attributes are available at compile time,
and I'm always glad when tools help me spot stupid mistakes and
do so early.

Looking at arch/powerpc/include/asm/mpc5121.h and the DMA driver
you are changing, and seeing how the contra arguments do not
apply here (new driver, no churn, known properties, prior art),
the preference in this specific situations here is for structs.
Other cultures may prefer something else.  These defines just
don't feel right here.


> >> +
> >> +#define DMA_LPC_CHANNEL_NUMBER               26
> >> +#define DEFAULT_WORDS_PER_TRANSFER   1
> 
> > can you eliminate the DMA channel number in the DMA client
> > source?  this shall be intimate knowledge of the DMA engine
> > driver, or at least get specified in the device tree
> 
> > BTW did Anatolij suggest OF based DMA channel lookup back in May,
> > see commit e48fc15 and search for 'rx-tx' in the mxcmmc.c file
> 
> Ok, thanks, I've found it. I'll make OF based DMA channel lookup.

See my RFC series, it implements what Anatolij did and addresses
the feedback he received.


> >> +/*
> >> + * Before we can wrap up handling current mpc512x_lpbfifo_request
> >> + * and execute the callback registered in it we should:
> >> + *  1. recognize that everything is really done,
> >> + *  2. free memory and dmaengine channel.
> >> + *
> >> + * Writing from RAM to registers of some device on LPB (transmit)
> >> + * is not really done until the LPB FIFO completion irq triggers.
> >> + *
> >> + * For being sure that writing from registers of some device on LPB
> >> + * to RAM (receive) is really done we should wait
> >> + * for mpc512x_lpbfifo_callback() to be called by DMA driver.
> >> + * In this case LPB FIFO completion irq will not appear at all.
> >> + *
> >> + * Moreover, freeing memory and dmaengine channel is not safe until
> >> + * mpc512x_lpbfifo_callback() is called.
> >> + *
> >> + * So to make it simple:
> >> + * last one out turns off the lights.
> >> + */
> 
> > Can this "feedback order issue" handling get simplified by having
> > both the LPB controller FIFO and the DMA completion callback
> > invoke a single routine, which tracks the "LPB done" and "DMA
> > done" conditions regardless of their order, and does
> > postprocessing when both were satisfied?
> >
> > It might be desirable to always run the postprocessing only if
> > both involved components finished their activities, regardless of
> > the transfer's direction.  This reduces the potential for access
> > to invalid data if these two events are "racy".
> 
> Excuse me, I didn't understand your idea.
> I thought my code is already quite simple.
> 
> Postprocessing is short: just clean lpbfifo.req and run client's callback.
> DEV->MEM: only DMA callback appears. It should simply execute postprocessing.
> MEM->DEV: both DMA callback and LPBFIFO irq appear. Both of them
> should be done before postprocessing. I.e. the last one should
> "turn off the lights". Last one is determined using lpbfifo.im_last
> protected by spinlock.
> 
> I guess my comment describing that is not clear enough, is it?

What I had in mind was something simple and straight forward
instead of telling special cases apart when you don't have to.

You start two parts which are SCLPC and DMA, and you can only
tell that everything has completed when both are done.  It just
doesn't matter which is first, as both are required for
completion.  Just raise the "LPB done" and "DMA done" flags as
these events arrive, and do the postprocessing once.  Most
important is to only implement the logic once, since duplication
is not just tedious but introduces potential for error.

BTW have there been reports in the past about hardware with
"racy" signalling of completion.  The signals may take different
paths and might get delayed in arbitrary ways (both in hardware
and in software).  Assuming a specific order of events just
complicates matters and introduces new potential for problems.


The simplification and more importantly the unification of logic
was what I suggested after the first look (there are two
conditions which you try to handle with just one flag and
guessing the order of events).

Now upon second look I notice that you state there is no LPB
completion information for the read direction.  Is it that you
don't wait for it, or is it that you don't get one?  Is this an
implementation detail, or because of the specific configuration
used here?  I'd be worried if this could not get controlled and
simplified.  Just try to get things more robust.  Think of the
next person who has to read and maintain the code (including
yourself, after a few months have passed and you return from
whatever you did in the meantime, having dropped all those
details that may be present now but won't last).


> >> +     /* 1. Check requirements: */
> >> +     /* Packet size must be a multiple of 4 bytes since
> >> +      * FIFO Data Word Register (which provides data to DMA controller)
> >> +      * allows only "full-word" (4 bytes) access
> >> +      * according Reference Manual */
> 
> > Are you certain about that constraint?  Can't the packet size be
> > an "incomplete multiple" of the SCLPC FIFO port's width when the
> > last data item is appropriately aligned?
> 
> The Reference Manual (page 538) says about FIFO Data Word Register:
> Only full-word access is allowed. If all byte enables are not asserted
> when accessing this location, a FIFO error flag is generated.

Yes, I was confusing this with the PSC where the FIFO port is
32bits wide but can be accessed in arbitrary width.


virtually yours
Gerhard Sittig
-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr. 5, D-82194 Groebenzell, Germany
Phone: +49-8142-66989-0 Fax: +49-8142-66989-80  Email: office@denx.de
