Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933596AbaD3J51 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 05:57:27 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:61575 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932198AbaD3J5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 05:57:25 -0400
Date: Wed, 30 Apr 2014 10:57:18 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Brian Norris <computersforpeace@gmail.com>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        angus.clark@st.com, kernel@stlinux.com, linux-mtd@lists.infradead.org,
        pekon@ti.com, dwmw2@infradead.org
Subject: Re: [RFC 00/47] mtd: nand: Add new driver supporting ST's BCH h/w
Message-ID: <20140430095718.GJ29462@lee--X1>
References: <1395735604-26706-1-git-send-email-lee.jones@linaro.org>
 <20140325125050.GB665@arch.cereza>
 <20140325131139.GB24823@lee--X1>
 <20140325220045.GA12185@arch.cereza>
 <20140326072805.GB31517@norris-Latitude-E6410>
 <20140327102835.GA17779@lee--X1>
 <20140401112926.GB24013@lee--X1>
 <20140410200004.GP32070@ld-irv-0074>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140410200004.GP32070@ld-irv-0074>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > The BBT requirements are somewhere more complex. To provide you with
> > > the complete picture, a little knowledge of driver history is
> > > required. When it was initially created the MTD core only supported
> > > OOB BBTs, but the ST BCH Controller doesn't support OOB access, so
> > > Angus wrote his on In-Band (IB) implementation. Unfortunately the IB
> > > support which _is_ now present in the kernel doesn't match the
> > > internal implementation. Normally this wouldn't be an issue in itself,
> > > but ST's boot-stack and tooling (Primary Bootloader, U-Boot, various
> > > Programmers, etc) are aware of the internal IB BTT and utilise it
> > > in varying ways. Shifting over to the Mainline version in
> > > one-foul-swoop _will_ cause lots of pain and will probably result in
> > > the disownership of driver we're trying to Mainline today. Naturally
> > > I'm keen to avoid this.
> > 
> > Just looking into this now. Can I add support for a vendor specific
> > signature extension? ST's flashers, bootloaders and tooling currently
> > use the format:
> > 
> > /* Extend IBBT header with some stm-nand-bch niceties */
> > struct nand_ibbt_bch_header {
> > 	uint8_t signature[4];           /* "Bbt0" or "1tbB" signature */
> > 	uint8_t version;                /* BBT version ("age") */
> > 	uint8_t reserved[3];            /* padding */
> > 	uint8_t baseschema[4];          /* "base" schema (x4) */
> > 	uint8_t privschema[4];          /* "private" schema (x4) */
> 
> Not sure what these schema mean.

To be honest, me either, but I know that they are used by ST's
tooling; flashers, bootloaders and debuggers.

> > 	uint8_t ecc_size[4];            /* ECC bytes (0, 32, 54) (x4) */
> > 	char    author[64];             /* Arbitrary string for S/W to use */
> > }; __attribute__((__packed__))
> 
> Nit: that would just be __packed (see compiler-gcc.h).

Okay.

> In principle, I'm OK with extending the BBT somewhat. Preferably, this
> would provide some extensibility, so that other custom formats can use
> the same base code. For instance, it looks like many of these fields
> would be fixed, and specific to your platform. So (from nand_bbt's
> perspective) these could just be consolidated int a field:
> 
> 	u8 custom[76];
> 
> Or make it variable-length, with the length provided by the driver?
> nand_bbt would just know not to check for it when scanning, and it
> would know to program it to flash when updating.
> 
> > It would be great if we can support this with a descriptor option or
> > suchlike, as it would a) save me a lot of aggravation and b) continue
> > to support ST with their current use-case.
> 
> Yeah, I realize you can't just jump over to the current format for
> production systems. And there are admittedly some rough spots in our
> current nand_bbt; it's not perfect.
> 
> Some random notes (not necessarily your problem; but things to be aware
> of): nand_bbt could use some additional robustness checks, I think. Like
> a CRC field, and maybe a versioning system for allowing
> (backwards-compatible) changes in the format. To make
> backwards-compatible changes, though, the original format needs to have
> reserved space, or at least an 'offset' field, which would point to
> where the actual BBT starts--not just a fixed offset.
> 
> There's also still a bit of cruft that really can be removed from
> nand_bbt (the handling of bad block markers, which is duplicated in
> nand_base). It's a low-priority item on my plate, but I think it might
> be a good first step before trying to expand nand_bbt much.

So I've been looking into the differences between the Mainline and
ST's implementation.  I've concluded that the transition over to
Mainline's version is best dealt with in the device driver.

I have depicted the differences between the two versions at [1].
You'll see that the BBT header and BBT data have been separated into
different pages the ST version.  This hardens the process against
power failures whilst creating the BBT by only writing the pattern
once the BBT data has been successfully applied to flash.  A small
corner-case perhaps, but these things do happen.

What I'd like to do is supply our own scan_bbt() call.  This is
supported by the framework already, so no extra modifications are
required.  Converting nand_bbt to add support for our (and other)
formats would be fairly intrusive.  The framework already allows us to
search from the last block backwards, which is great, but that same
functionality is missing for searching from the last page in the
block.  The ability to separate header from data is also vacant,
which we require for the aforementioned reasons.

In our scan_bbt() I would like to start off by only supporting solely
the ST schema, then over time search in both locations but preferring
ST's.  Subsequently the choice should be version number based, with a
view to phasing out ST's implementation completely once we've had a
change to adapt the tooling which currently use only ST's
implementation.

I'm hoping to submit the next version either today or tomorrow, which
will conform to the proposal above.  I hope that you find this
adequate.

[1] goo.gl/WnGLVQ

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
