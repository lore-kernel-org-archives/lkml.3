Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935733AbaDJUAL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 16:00:11 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44521 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759098AbaDJUAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 16:00:08 -0400
Date: Thu, 10 Apr 2014 13:00:04 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        angus.clark@st.com, kernel@stlinux.com, linux-mtd@lists.infradead.org,
        pekon@ti.com, dwmw2@infradead.org
Subject: Re: [RFC 00/47] mtd: nand: Add new driver supporting ST's BCH h/w
Message-ID: <20140410200004.GP32070@ld-irv-0074>
References: <1395735604-26706-1-git-send-email-lee.jones@linaro.org>
 <20140325125050.GB665@arch.cereza>
 <20140325131139.GB24823@lee--X1>
 <20140325220045.GA12185@arch.cereza>
 <20140326072805.GB31517@norris-Latitude-E6410>
 <20140327102835.GA17779@lee--X1>
 <20140401112926.GB24013@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140401112926.GB24013@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 01, 2014 at 12:29:26PM +0100, Lee Jones wrote:
> > The BBT requirements are somewhere more complex. To provide you with
> > the complete picture, a little knowledge of driver history is
> > required. When it was initially created the MTD core only supported
> > OOB BBTs, but the ST BCH Controller doesn't support OOB access, so
> > Angus wrote his on In-Band (IB) implementation. Unfortunately the IB
> > support which _is_ now present in the kernel doesn't match the
> > internal implementation. Normally this wouldn't be an issue in itself,
> > but ST's boot-stack and tooling (Primary Bootloader, U-Boot, various
> > Programmers, etc) are aware of the internal IB BTT and utilise it
> > in varying ways. Shifting over to the Mainline version in
> > one-foul-swoop _will_ cause lots of pain and will probably result in
> > the disownership of driver we're trying to Mainline today. Naturally
> > I'm keen to avoid this.
> 
> Just looking into this now. Can I add support for a vendor specific
> signature extension? ST's flashers, bootloaders and tooling currently
> use the format:
> 
> /* Extend IBBT header with some stm-nand-bch niceties */
> struct nand_ibbt_bch_header {
> 	uint8_t signature[4];           /* "Bbt0" or "1tbB" signature */
> 	uint8_t version;                /* BBT version ("age") */
> 	uint8_t reserved[3];            /* padding */
> 	uint8_t baseschema[4];          /* "base" schema (x4) */
> 	uint8_t privschema[4];          /* "private" schema (x4) */

Not sure what these schema mean.

> 	uint8_t ecc_size[4];            /* ECC bytes (0, 32, 54) (x4) */
> 	char    author[64];             /* Arbitrary string for S/W to use */
> }; __attribute__((__packed__))

Nit: that would just be __packed (see compiler-gcc.h).

In principle, I'm OK with extending the BBT somewhat. Preferably, this
would provide some extensibility, so that other custom formats can use
the same base code. For instance, it looks like many of these fields
would be fixed, and specific to your platform. So (from nand_bbt's
perspective) these could just be consolidated int a field:

	u8 custom[76];

Or make it variable-length, with the length provided by the driver?
nand_bbt would just know not to check for it when scanning, and it
would know to program it to flash when updating.

> It would be great if we can support this with a descriptor option or
> suchlike, as it would a) save me a lot of aggravation and b) continue
> to support ST with their current use-case.

Yeah, I realize you can't just jump over to the current format for
production systems. And there are admittedly some rough spots in our
current nand_bbt; it's not perfect.

Some random notes (not necessarily your problem; but things to be aware
of): nand_bbt could use some additional robustness checks, I think. Like
a CRC field, and maybe a versioning system for allowing
(backwards-compatible) changes in the format. To make
backwards-compatible changes, though, the original format needs to have
reserved space, or at least an 'offset' field, which would point to
where the actual BBT starts--not just a fixed offset.

There's also still a bit of cruft that really can be removed from
nand_bbt (the handling of bad block markers, which is duplicated in
nand_base). It's a low-priority item on my plate, but I think it might
be a good first step before trying to expand nand_bbt much.

Brian
