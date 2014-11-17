Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752356AbaKQKdJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 05:33:09 -0500
Received: from mga11.intel.com ([192.55.52.93]:46483 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751834AbaKQKdF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 05:33:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,402,1413270000"; 
   d="scan'208";a="633107468"
Date: Mon, 17 Nov 2014 12:33:01 +0200
From: Laurentiu Palcu <laurentiu.palcu@intel.com>
To: Johan Havold <johan@kernel.org>
Cc: Mark Brown <broonie@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        Octavian Purdila <octavian.purdila@intel.com>,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] spi: add support for DLN-2 USB-SPI adapter
Message-ID: <20141117103300.GA2583@lpalcu-linux>
References: <1415799490-27989-1-git-send-email-laurentiu.palcu@intel.com>
 <1415799490-27989-2-git-send-email-laurentiu.palcu@intel.com>
 <20141113122728.GA18285@localhost>
 <20141113151721.GQ5826@lpalcu-linux>
 <20141114105645.GB18285@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141114105645.GB18285@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Johan,

On Fri, Nov 14, 2014 at 11:56:45AM +0100, Johan Havold wrote:
> On Thu, Nov 13, 2014 at 05:17:21PM +0200, Laurentiu Palcu wrote:
> > Hi Johan,
> > 
> > On Thu, Nov 13, 2014 at 01:27:28PM +0100, Johan Havold wrote:
> > > On Wed, Nov 12, 2014 at 03:38:09PM +0200, Laurentiu Palcu wrote:
> 
> > > > +struct dln2_spi {
> > > > +	struct platform_device *pdev;
> > > > +	struct spi_master *master;
> > > > +	u8 port;
> > > > +
> > > > +	void *buf;
> > > 
> > > Add comment on what is protecting this buffer.
> >
> > No need to protect this buffer. First off, AFAICS, once we register the
> > master, a message queue is initialized by the spi core and the entire
> > communication with the SPI module goes through this queue. Secondly,
> > every TX/RX SPI operation with the Diolan is split in 2 parts: command
> > and response. Once we send the command out, the buffer can be safely
> > reused for the response.
> 
> I didn't as for a lock, but for you to put a comment there explaining
> why there's no need for one (e.g. buffer used in what functions that are
> serialised by spi core).
ok, I'll add a comment.

> 
> > Also, I guess this answers a couple of your comments below too.
> 
> Not really. I still think you should use stack allocated buffer for
> short control transfer.
> 
> > > > +
> > > > +	u8 bpw;
> > > > +	u32 speed;
> > > > +	u16 mode;
> > > > +	u8 cs;
> >> > +};
> 
> > > > +/*
> > > > + * Select/unselect multiple CS lines. The selected lines will be automatically
> > > > + * toggled LOW/HIGH by the board firmware during transfers, provided they're
> > > > + * enabled first.
> > > > + *
> > > > + * Ex: cs_mask = 0x03 -> CS0 & CS1 will be selected and the next WR/RD operation
> > > 
> > > Seems you have several comments that wrap at >80 columns (81 above).
> >
> > According to the kernel coding style, 80 columns is the limit, unless
> > readability is affected. The line above does not exceed this limit. Also,
> > checkpatch does not complain.
> 
> I noticed that checkpatch didn't complain, but 81 chars is still >80,
> right? The newline counts as well (at least in vim).
Isn't it all about visible characters? vim, which I use, does not count
the newline. I even have a special plugin for linux kernel development
that highlights the extra characters in red. Also, after looking at
other files in the kernel, it seems this file is compliant.

> 
> > > > + *                       will toggle the lines LOW/HIGH automatically.
> > > > + */
> > > > +static int dln2_spi_cs_set(struct dln2_spi *dln2, u8 cs_mask)
> 
> [...]
> 
> > > > +static int dln2_spi_get_cs_num(struct dln2_spi *dln2, u16 *cs_num)
> > > > +{
> > > > +	int ret;
> > > > +	struct {
> > > > +		u8 port;
> > > > +	} tx;
> > > > +	struct {
> > > > +		__le16 cs_count;
> > > > +	} *rx = dln2->buf;
> > > 
> > > I don't think you want to use dln2->buf for all these small transfers.
> > > And what would be protecting it from concurrent use?
> > > 
> > > Check this throughout.
> >
> > I answered this above.
> 
> So did I. Even though the transfer functions are serialised by spi-core
> it's not obvious that all your helpers will be.
I really looked this through and I couldn't find an example when one or
more helpers can be called in parallel. Most of the helpers are called
from the probe function and the rest are called from
dln2_spi_transfer_setup(), via dln2_spi_transfer_one_message(). The
dln2_spi_prepare_message() is called from SPI core's
spi_pump_messages(), just before calling transfer_one_message()... So,
it's still serial.

If there is a flaw in my logic, feel free to correct me.

> 
> And since there's no gain from using the global buffer why not simply
> use stack allocated ones here as well (e.g. for both tx and rx above)?
However, I will give this a shot though... Sounds reasonable and I could
probably lose the struct constructs too if the struct contains just
one field.

> > > > +
> > > > +	return 0;
> > > > +}
> 
> > > > +/*
> > > > + * Copy the data to DLN2 buffer and change the alignment to LE, requested by
> > > > + * DLN2 module. SPI core makes sure that the data length is a multiple of word
> > > > + * size.
> > > 
> > > What about buffer alignment?
> >
> > Buffer alignment? Why should the buffer be aligned? Now that you
> > mentioned it, I realized I should've used "byte order" instead of
> > alignment in the comment above...
> 
> You can't just simply cast an unaligned buffer to a type that has a
> minimum alignment requirement > 1. That's what the get/put_unaligned
> helpers are for (see Documentation/unaligned-memory-access.txt).
> 
> Perhaps the buffer is properly aligned, just making sure you verified
> this (e.g. what's the size of the header?).
> 
> And yes, fixing the wording would be nice as well.
>
You've got a good point here. I must've relied on the fact that x86 is
capable of dealing with unaligned access and didn't give it much thought
for other architectures... :/ Well, now that you raised the flag (thank
you for that), I checked the alignment for dln2 tx/rx buffer and appear
to be 4 byte aligned: for tx, the header is 4 bytes; for rx, it's 12
bytes (I'm counting also the response header that is stripped by
_dln2_transfer()).

The SPI transfer rx_buf and tx_buf, on the other hand, might not be
aligned so, thanks again for reminding me about this. :/

I'll send a v3 soon to address these.

laurentiu



