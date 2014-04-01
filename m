Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138AbaDAL3f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 07:29:35 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:59352 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbaDAL3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:29:32 -0400
Date: Tue, 1 Apr 2014 12:29:26 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Brian Norris <computersforpeace@gmail.com>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        angus.clark@st.com, kernel@stlinux.com, linux-mtd@lists.infradead.org,
        pekon@ti.com, dwmw2@infradead.org
Subject: Re: [RFC 00/47] mtd: nand: Add new driver supporting ST's BCH h/w
Message-ID: <20140401112926.GB24013@lee--X1>
References: <1395735604-26706-1-git-send-email-lee.jones@linaro.org>
 <20140325125050.GB665@arch.cereza>
 <20140325131139.GB24823@lee--X1>
 <20140325220045.GA12185@arch.cereza>
 <20140326072805.GB31517@norris-Latitude-E6410>
 <20140327102835.GA17779@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140327102835.GA17779@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > The call to nand_scan_tail() would remove the need to export those NAND
> > > core functions, and remove the need to scan and print the bad blocks.
> > > I don't know if you have a real reason for not doing it this way, or
> > > maybe it's the way this driver was originally written.
> > > 
> > > Care to review this and re-spin the driver? You'll have a more nicer
> > > driver, and more framework-compliant.
> > 
> > A hearty +1 to this. You are avoiding much of the core of the NAND
> > framework by avoiding the nand_chip callbacks and nand_scan_tail(), and
> > by reimplementing the BBT. I will have to NAK to some of the patches
> > that EXPORT the nand_base private core (e.g., nand_get_device()), and I
> > will most likely NAK the custom BBT implementation (please improve
> > nand_bbt.c as needed).
> 
> This is a good catch. I will attempt to reimplement the driver's
> initialisation steps to utilise more of the core infrastructure in an
> attempt to mitigate the requirement for exportation of private
> routines.
> 
> The BBT requirements are somewhere more complex. To provide you with
> the complete picture, a little knowledge of driver history is
> required. When it was initially created the MTD core only supported
> OOB BBTs, but the ST BCH Controller doesn't support OOB access, so
> Angus wrote his on In-Band (IB) implementation. Unfortunately the IB
> support which _is_ now present in the kernel doesn't match the
> internal implementation. Normally this wouldn't be an issue in itself,
> but ST's boot-stack and tooling (Primary Bootloader, U-Boot, various
> Programmers, etc) are aware of the internal IB BTT and utilise it
> in varying ways. Shifting over to the Mainline version in
> one-foul-swoop _will_ cause lots of pain and will probably result in
> the disownership of driver we're trying to Mainline today. Naturally
> I'm keen to avoid this.

Just looking into this now. Can I add support for a vendor specific
signature extension? ST's flashers, bootloaders and tooling currently
use the format:

/* Extend IBBT header with some stm-nand-bch niceties */
struct nand_ibbt_bch_header {
	uint8_t signature[4];           /* "Bbt0" or "1tbB" signature */
	uint8_t version;                /* BBT version ("age") */
	uint8_t reserved[3];            /* padding */
	uint8_t baseschema[4];          /* "base" schema (x4) */
	uint8_t privschema[4];          /* "private" schema (x4) */
	uint8_t ecc_size[4];            /* ECC bytes (0, 32, 54) (x4) */
	char    author[64];             /* Arbitrary string for S/W to use */
}; __attribute__((__packed__))

It would be great if we can support this with a descriptor option or
suchlike, as it would a) save me a lot of aggravation and b) continue
to support ST with their current use-case.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
