Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753005AbaAIKqY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 05:46:24 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:53702 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643AbaAIKqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 05:46:11 -0500
X-Auth-Info: IZhMQdR0LJVspQW61qUwLYXlGUgc0hHctULZEZQb07o=
Date: Thu, 9 Jan 2014 11:46:04 +0100
From: Gerhard Sittig <gsi@denx.de>
To: Neil Zhang <zhangwm@marvell.com>
Cc: linus.walleij@linaro.org, gnurou@gmail.com, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpio: pxa: fix bug when get gpio value
Message-ID: <20140109104604.GT20094@book.gsilab.sittig.org>
References: <1389259557-1731-1-git-send-email-zhangwm@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389259557-1731-1-git-send-email-zhangwm@marvell.com>
Organization: DENX Software Engineering GmbH
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 09, 2014 at 17:25 +0800, Neil Zhang wrote:
> 
> gpio_get_value should return 0 or 1.
> 
> I have checked mach-mmp / mach-pxa / plat-pxa / plat-orion / mach-orion5x.
> It's OK for all of them to change this function to return 0 and 1.
> 
> [ ... ]
>  
>  static int pxa_gpio_get(struct gpio_chip *chip, unsigned offset)
>  {
> -	return readl_relaxed(gpio_chip_base(chip) + GPLR_OFFSET) & (1 << offset);
> +	u32 gplr = readl_relaxed(gpio_chip_base(chip) + GPLR_OFFSET);
> +	return !!(gplr & (1 << offset));
>  }

This may be a stupid question, but isn't the "!!value" syntax
just replacing one kind of "zero or non-zero" with another kind
of "zero or non-zero"?  This phrase is used to normalize
booleans, but ISTR there is no guarantee that true needs to equal
the value of 1.

Here is why I'm asking:  Is there a need from GPIO get_value()
routines to return normalized values, and if so should not more
drivers receive an update?  Or need get_value() routines just
return the usual integer zero/non-zero values (as is the
convention in the C programming language) and GPIO using callers
should know that they are not exactly 0 and 1?

The latter would make this change for PXA unneeded (nice to have
but not essential), and both the commit message as well as the
subject line at least need to get re-phrased, as the "bug" is in
the caller's expectation and not in the GPIO chip driver.

Please note that I'm not questioning the patches' being
applicable, but am trying to find out what else needs to be done
which previously may have gone unnoticed.  A doc update maybe, to
make GPIO users aware that the return value may not be exactly 1,
and to clear up where such an assumption is wrongly made.

If the GPIO subsystem's API wants to guarantee values of 0 and 1
(which I think it doesn't), then I feel the adjustment should be
done in the gpio_get_value() routines (in all its public
variants, or a common routine which all of them pass through),
and certainly not in individual chip drivers.


virtually yours
Gerhard Sittig
-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr. 5, D-82194 Groebenzell, Germany
Phone: +49-8142-66989-0 Fax: +49-8142-66989-80  Email: office@denx.de
