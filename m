Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206AbaDDOKE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 10:10:04 -0400
Received: from top.free-electrons.com ([176.31.233.9]:38559 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752925AbaDDOJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 10:09:59 -0400
Date: Fri, 4 Apr 2014 11:09:34 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
Cc: linux-mtd@lists.infradead.org, Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Brian Norris <computersforpeace@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Francois Bedard <Francois.Bedard@synopsys.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v2] axs_nand - add driver for NAND controller used on
 Synopsys AXS dev boards
Message-ID: <20140404140933.GA25772@arch.cereza>
References: <1396597089-1081-1-git-send-email-abrodkin@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1396597089-1081-1-git-send-email-abrodkin@synopsys.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr 04, Alexey Brodkin wrote:
> Signed-off-by: Alexey Brodkin <abrodkin@synopsys.com>
> 

Maybe it would be nice adding some driver description here, so the commit
log actually says something useful about the commit.

[..]
> Reviewed-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
> 
> +/**
> + * axs_flag_wait_and_reset - Waits until requested flag in INT_STATUS register
> + *              is set by HW and resets it by writing "1" in INT_CLR_STATUS.
> + * @host:	Pointer to private data structure.
> + * @flag:	Bit/flag offset in INT_STATUS register
> + */
> +static void axs_flag_wait_and_reset(struct axs_nand_host *host, int flag)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < AXS_FLAG_WAIT_DELAY * 100; i++) {
> +		unsigned int status = reg_get(host, INT_STATUS);
> +
> +		if (status & (1 << flag)) {
> +			reg_set(host, INT_CLR_STATUS, 1 << flag);
> +			return;
> +		}
> +
> +		udelay(10);
> +	}
> +
> +	/*
> +	 * Since we cannot report this problem any further than
> +	 * axs_nand_{write|read}_buf() letting user know there's a problem.
> +	 */
> +	dev_err(host->dev, "Waited too long (%d s.) for flag/bit %d\n",
> +		AXS_FLAG_WAIT_DELAY, flag);
> +}

Hm... I'm not sure the above is really true.

The NAND core uses the replaceable chip->waitfunc callback to check the
status of issued commands. See for instance:

static int nand_write_oob_std(struct mtd_info *mtd, struct nand_chip *chip,
                              int page)
{
        int status = 0;
        const uint8_t *buf = chip->oob_poi;
        int length = mtd->oobsize;

        chip->cmdfunc(mtd, NAND_CMD_SEQIN, mtd->writesize, page);
        chip->write_buf(mtd, buf, length);
        /* Send command to program the OOB data */
        chip->cmdfunc(mtd, NAND_CMD_PAGEPROG, -1, -1);

        status = chip->waitfunc(mtd, chip);

        return status & NAND_STATUS_FAIL ? -EIO : 0;
}

On the other side, if you are clearing the flags in axs_flag_wait_and_reset()
it might be a bit hard for you to get this right.

IOW, I'm not saying you *must* do this, but instead suggesting that you take
a look at waitfunc() and see if it helps report a proper error in the
read/write path.
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
