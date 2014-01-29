Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859AbaA2TC7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 14:02:59 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:53174 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298AbaA2TC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 14:02:57 -0500
Message-ID: <52E9505C.8080001@gmail.com>
Date: Wed, 29 Jan 2014 20:02:52 +0100
From: Boris BREZILLON <b.brezillon.dev@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
CC: Maxime Ripard <maxime.ripard@free-electrons.com>,
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
References: <1391006064-28890-1-git-send-email-b.brezillon.dev@gmail.com> <1391006064-28890-9-git-send-email-b.brezillon.dev@gmail.com> <20140129175641.GF1427@obsidianresearch.com>
In-Reply-To: <20140129175641.GF1427@obsidianresearch.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 29/01/2014 18:56, Jason Gunthorpe a écrit :
> On Wed, Jan 29, 2014 at 03:34:18PM +0100, Boris BREZILLON wrote:
>
>> +static int sunxi_nand_chip_init_timings(struct sunxi_nand_chip *chip,
>> +					struct device_node *np)
>> +{
>> +	const struct nand_sdr_timings *timings;
>> +	u32 min_clk_period = 0;
>> +	int ret;
>> +
>> +	ret = onfi_get_async_timing_mode(&chip->nand);
>> +	if (ret == ONFI_TIMING_MODE_UNKNOWN) {
>> +		ret = of_get_nand_onfi_timing_mode(np);
>> +		if (ret < 0)
>> +			return ret;
>> +	}
> [..]
>
>> +static int sunxi_nand_chip_init(struct device *dev, struct sunxi_nfc *nfc,
> [..]
>> +       ret = sunxi_nand_chip_init_timings(chip, np);
>> +       if (ret)
>> +               return ret;
> [..]
>> +       ret = nand_scan_ident(mtd, nsels, NULL);
> This ordering looks a bit problematic, will onfi_get_async_timing_mode
> ever return anything other than ONFI_TIMING_MODE_UNKNOWN if it is
> called before nand_scan_ident ?
Indeed. I haven't tested this part as I don't own any board with an ONFI 
compatible chip.
> What sets clk_rate to non-zero if there
> is no DT property?
It is set to 20 MHz by default, but it should definitely be set to the 
rate fulfilling mode 0.
I'll fix this.

>
> For a flow that uses onfi_get_async_timing_mode rather than DT the
> driver should set the interface to timing mode 0 (slowest) and then
> call nand_scan_ident, and then reset the interface to the detected
> timing mode.

Absolutely.

>
> Maybe this should be implemented in the core code through a new
> callback (nand->set_timing_mode ?)
>
> Regards,
> Jason

