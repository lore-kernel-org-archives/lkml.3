Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756999Ab3A0XxW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 18:53:22 -0500
Received: from mga03.intel.com ([143.182.124.21]:50183 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756928Ab3A0XxT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 18:53:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,547,1355126400"; 
   d="scan'208";a="249000440"
Date: Mon, 28 Jan 2013 00:53:18 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        carriere etienne <etienne.carriere@stericsson.com>
Subject: Re: [PATCH 13/26] mfd: ab8500-debugfs: Formated access AB8500
 registers from debugfs entry
Message-ID: <20130127235318.GQ1174@sortiz-mobl>
References: <1358254566-12419-1-git-send-email-lee.jones@linaro.org>
 <1358254566-12419-14-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358254566-12419-14-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On Tue, Jan 15, 2013 at 12:55:53PM +0000, Lee Jones wrote:
> +static ssize_t hwreg_common_write(char *b, struct hwreg_cfg *cfg,
> +		struct device *dev)
> +{
> +	uint write, val = 0;
> +	struct hwreg_cfg loc = {
> +		.bank = 0,          /* default: invalid phys addr */
> +		.addr = 0,          /* default: invalid phys addr */
> +		.fmt = 0,           /* default: 32bit access, hex output */
> +		.mask = 0xFFFFFFFF, /* default: no mask */
> +		.shift = 0,         /* default: no bit shift */
> +	};
> +
> +	/* read or write ? */
> +	if (!strncmp(b, "read ", 5)) {
> +		write = 0;
> +		b += 5;
> +	} else if (!strncmp(b, "write ", 6)) {
> +		write = 1;
> +		b += 6;
> +	} else
> +		return -EINVAL;
> +
> +	/* OPTIONS -l|-w|-b -s -m -o */
> +	while ((*b == ' ') || (*b == '-')) {
> +		if (*(b-1) != ' ') {
> +			b++;
> +			continue;
> +		}
> +		if ((!strncmp(b, "-d ", 3)) ||
> +				(!strncmp(b, "-dec ", 5))) {
> +			b += (*(b+2) == ' ') ? 3 : 5;
> +			loc.fmt |= (1<<0);
> +		} else if ((!strncmp(b, "-h ", 3)) ||
> +				(!strncmp(b, "-hex ", 5))) {
> +			b += (*(b+2) == ' ') ? 3 : 5;
> +			loc.fmt &= ~(1<<0);
> +		} else if ((!strncmp(b, "-m ", 3)) ||
> +				(!strncmp(b, "-mask ", 6))) {
> +			b += (*(b+2) == ' ') ? 3 : 6;
> +			if (strval_len(b) == 0)
> +				return -EINVAL;
> +			loc.mask = simple_strtoul(b, &b, 0);
> +		} else if ((!strncmp(b, "-s ", 3)) ||
> +				(!strncmp(b, "-shift ", 7))) {
> +			b += (*(b+2) == ' ') ? 3 : 7;
> +			if (strval_len(b) == 0)
> +				return -EINVAL;
> +			loc.shift = simple_strtol(b, &b, 0);
> +		} else {
> +			return -EINVAL;
> +		}
> +	}
> +	/* get arg BANK and ADDRESS */
> +	if (strval_len(b) == 0)
> +		return -EINVAL;
> +	loc.bank = simple_strtoul(b, &b, 0);
> +	while (*b == ' ')
> +		b++;
> +	if (strval_len(b) == 0)
> +		return -EINVAL;
> +	loc.addr = simple_strtoul(b, &b, 0);
> +
> +	if (write) {
> +		while (*b == ' ')
> +			b++;
> +		if (strval_len(b) == 0)
> +			return -EINVAL;
> +		val = simple_strtoul(b, &b, 0);
> +	}
> +
> +	/* args are ok, update target cfg (mainly for read) */
> +	*cfg = loc;
> +
> +#if ABB_HWREG_DEBUG
> +	pr_warn("HWREG request: %s, %s, addr=0x%08X, mask=0x%X, shift=%d
> +			value=0x%X\n", (write) ? "write" : "read",
> +			REG_FMT_DEC(cfg) ? "decimal" : "hexa",
> +			cfg->addr, cfg->mask, cfg->shift, val);
> +#endif
> +
> +	if (write) {
if (!write)
	return 0;

for a more readable code.


> +		u8  regvalue;
> +		int ret = abx500_get_register_interruptible(dev,
> +			(u8)cfg->bank, (u8)cfg->addr, &regvalue);
> +		if (ret < 0) {
> +			dev_err(dev, "abx500_get_reg fail %d, %d\n",
> +				ret, __LINE__);
> +			return -EINVAL;
> +		}
> +
> +		if (cfg->shift >= 0) {
> +			regvalue &= ~(cfg->mask << (cfg->shift));
> +			val = (val & cfg->mask) << (cfg->shift);
> +		} else {
> +			regvalue &= ~(cfg->mask >> (-cfg->shift));
> +			val = (val & cfg->mask) >> (-cfg->shift);
> +		}
> +		val = val | regvalue;
> +
> +		ret = abx500_set_register_interruptible(dev,
> +			(u8)cfg->bank, (u8)cfg->addr, (u8)val);
> +		if (ret < 0) {
> +			pr_err("abx500_set_reg failed %d, %d", ret, __LINE__);
> +			return -EINVAL;
> +		}
> +
> +	}
> +	return 0;
> +}
I think this is a pretty big routine, that could be split into a command
parsing part and the actual register write one.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
