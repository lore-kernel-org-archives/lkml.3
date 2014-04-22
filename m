Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045AbaDVSp2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 14:45:28 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:49753 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbaDVSp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 14:45:27 -0400
X-Auth-Info: ZfADiJSqMNHyyDl34RJM7zPPf1u7bIt/zMl7u6yo7bA=
Date: Tue, 22 Apr 2014 20:45:18 +0200
From: Gerhard Sittig <gsi@denx.de>
To: Graham Moore <grmoore@altera.com>
Cc: ggrahammoore@gmail.com, ZY - marex <marex@denx.de>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Jingoo Han <jg1.han@samsung.com>, linux-kernel@vger.kernel.org,
        Yves Vandervennet <rocket.yvanderv@gmail.com>,
        linux-mtd@lists.infradead.org, Insop Song <insop.song@gainspeed.com>,
        Alan Tull <atull@altera.com>, Sourav Poddar <sourav.poddar@ti.com>,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Dinh Nguyen <dinguyen@altera.com>
Subject: Re: [PATCH V3] Add support for flag status register on Micron chips.
Message-ID: <20140422184518.GC3528@book.gsilab.sittig.org>
References: <1398175396-7560-1-git-send-email-grmoore@altera.com>
 <1398175396-7560-2-git-send-email-grmoore@altera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398175396-7560-2-git-send-email-grmoore@altera.com>
Organization: DENX Software Engineering GmbH
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-04-22 at 09:03 -0500, Graham Moore wrote:
> 
> ---
> V3:
> Rebase to l2-mtd spinor branch.
> V2:
> Remove leading underscore in function names.
> Remove type cast in dev_err call and use the proper format
> specifier instead.

the patch appears to not have dev_err() references, were they
removed? see below

> [ ... ]
> + * Read the flag status register, returning its value in the location
> + * Return the status register value.
> + * Returns negative if error occurred.
> + */
> +static int read_fsr(struct spi_nor *nor)
> +{
> +	int ret;
> +	u8 val;
> +
> +	ret = nor->read_reg(nor, SPINOR_OP_RDFSR, &val, 1);
> +	if (ret < 0) {
> +		pr_err("error %d reading FSR\n", ret);
> +		return ret;
> +	}
> [ ... ]

this emits a message that an error has occured, but doesn't tell
where it occured -- can you dev_err() here to make the message
even more helpful?

> @@ -165,6 +184,32 @@ static int spi_nor_wait_till_ready(struct spi_nor *nor)
>  	return -ETIMEDOUT;
>  }
>  
> +static int spi_nor_wait_till_fsr_ready(struct spi_nor *nor)
> +{
> +	unsigned long deadline;
> +	int sr;
> +	int fsr;
> +
> +	deadline = jiffies + MAX_READY_WAIT_JIFFIES;
> +
> +	do {
> +		cond_resched();
> +
> +		sr = read_sr(nor);
> +		if (sr < 0)
> +			break;
> +		else if (!(sr & SR_WIP)) {
> +			fsr = read_fsr(nor);
> +			if (fsr < 0)
> +				break;
> +			if (fsr & FSR_READY)
> +				return 0;			
> +		}
> +	} while (!time_after_eq(jiffies, deadline));
> +
> +	return -ETIMEDOUT;
> +}

this logic always returns "timed out" when the ready flag is not
seen, even in the case of read errors -- can you "preset" the
error code with "timed out", and update it with something more
appropriate before returning when other errors are seen?

though this is an internal helper, and callers may not tell the
situations apart in the first place, so this might be a minor nit


virtually yours
Gerhard Sittig
-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr. 5, D-82194 Groebenzell, Germany
Phone: +49-8142-66989-0 Fax: +49-8142-66989-80  Email: office@denx.de
