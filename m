Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875AbaA2R5E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 12:57:04 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:52210 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751635AbaA2R5B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 12:57:01 -0500
Date: Wed, 29 Jan 2014 10:56:42 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Boris BREZILLON <b.brezillon.dev@gmail.com>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org,
        dev@linux-sunxi.org
Subject: Re: [RFC PATCH v2 08/14] mtd: nand: add sunxi NAND flash controller
 support
Message-ID: <20140129175641.GF1427@obsidianresearch.com>
References: <1391006064-28890-1-git-send-email-b.brezillon.dev@gmail.com>
 <1391006064-28890-9-git-send-email-b.brezillon.dev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391006064-28890-9-git-send-email-b.brezillon.dev@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 29, 2014 at 03:34:18PM +0100, Boris BREZILLON wrote:

> +static int sunxi_nand_chip_init_timings(struct sunxi_nand_chip *chip,
> +					struct device_node *np)
> +{
> +	const struct nand_sdr_timings *timings;
> +	u32 min_clk_period = 0;
> +	int ret;
> +
> +	ret = onfi_get_async_timing_mode(&chip->nand);
> +	if (ret == ONFI_TIMING_MODE_UNKNOWN) {
> +		ret = of_get_nand_onfi_timing_mode(np);
> +		if (ret < 0)
> +			return ret;
> +	}

[..]

> +static int sunxi_nand_chip_init(struct device *dev, struct sunxi_nfc *nfc,
[..]
> +       ret = sunxi_nand_chip_init_timings(chip, np);
> +       if (ret)
> +               return ret;
[..]
> +       ret = nand_scan_ident(mtd, nsels, NULL);

This ordering looks a bit problematic, will onfi_get_async_timing_mode
ever return anything other than ONFI_TIMING_MODE_UNKNOWN if it is
called before nand_scan_ident ? What sets clk_rate to non-zero if there
is no DT property?

For a flow that uses onfi_get_async_timing_mode rather than DT the
driver should set the interface to timing mode 0 (slowest) and then
call nand_scan_ident, and then reset the interface to the detected
timing mode.

Maybe this should be implemented in the core code through a new
callback (nand->set_timing_mode ?)

Regards,
Jason
