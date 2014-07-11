Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751517AbaGKGwT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 02:52:19 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:16827 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750857AbaGKGwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 02:52:18 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19maM6FftdFB/hL3Qz49Ois
Date: Thu, 10 Jul 2014 23:52:12 -0700
From: Tony Lindgren <tony@atomide.com>
To: Roger Quadros <rogerq@ti.com>
Cc: computersforpeace@gmail.com, javier@dowhile0.org, pekon@ti.com,
        ezequiel.garcia@free-electrons.com, dwmw2@infradead.org,
        jg1.han@samsung.com, nsekhar@ti.com, linux-mtd@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 00/10] OMAP: GPMC: NAND: Introduce GPMC APIs for OMAP
 NAND
Message-ID: <20140711065211.GK28884@atomide.com>
References: <1404909450-11970-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404909450-11970-1-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Roger Quadros <rogerq@ti.com> [140709 05:39]:
> Hi,
> 
> The following hardware modules/registers are meant for NAND controller driver
> usage:
> - NAND I/O control (NAND address, data, command registers)
> - Prefetch/Write-post engine
> - ECC/BCH engine
> 
> However, these registers sit in the GPMC controller's register space and there
> need to be some sane way to access them from the OMAP NAND controller driver.
> 
> Till now the GPMC driver was populating a data structure (struct gpmc_nand_regs)
> with the register addresses and passing it to the OMAP NAND driver via platform
> data. This mechanism cannot be used for true Device tree support as custom
> platform data passing mechanism doesn't seem to work. Moreover, direct
> access to these registers must be limited to the GPMC driver. This calls for
> a few custom OMAP GPMC specific APIs that the OMAP NAND driver can use
> to access these GPMC space registers.
> 
> This series attempts to add the following new APIs and gets rid of
> 'struct gpmc_nand_regs' and 'gpmc_update_nand_regs()'.
> 
> -For NAND I/O control registers
> u32 omap_gpmc_read_reg(int cs, enum omap_gpmc_reg reg);
> void omap_gpmc_write_reg(int cs, enum omap_gpmc_reg reg, u32 val);
> 
> -For Prefetch engine
> int omap_gpmc_prefetch_start(int cs, int fifo_th, bool dma,
> 			     u32 count, int is_write);
> int omap_gpmc_prefetch_stop(int cs);
> u32 omap_gpmc_get_prefetch_count(void);
> u32 omap_gpmc_get_prefetch_fifo_count(void);
> 
> -For ECC/BCH engine
> void omap_gpmc_ecc_disable(void);
> void omap_gpmc_ecc_configure_enable(int cs, bool ecc16, u8 ecc_size0,
> 				    u8 ecc_size1, bool use_bch,
> 				    enum omap_gpmc_bch_type bch_type,
> 				    u8 bch_sectors, u8 bch_wrap_mode);
> void omap_gpmc_ecc_get_result(int length, u32 *result);
> void omap_gpmc_ecc_get_bch_result(int length, u8 sector, u32 *result);

These seem fine to me. At least I don't have any better ideas to
expose these GPMC registers to the NAND driver(s).
 
> These APIs don't implement any logic to serialize access to the
> NAND/Prefetch/ECC registers. It is upto the NAND controller driver
> to ensure that. As these modules can only handle one NAND controller context
> at a time, we set the nand_chip->hwcontrol to point to a single
> controller instance even if there are multiple NAND chips on different
> Chip select spaces. The NAND base driver then takes care of serializing
> access to the NAND controller (and ECC) through nandchip->hwcontrol->lock.
> 
> NOTE: Patches are still untested and only meant for review.

Regards,

Tony
