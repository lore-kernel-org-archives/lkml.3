Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756581Ab3ANM3a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 07:29:30 -0500
Received: from co202.xi-lite.net ([149.6.83.202]:41513 "EHLO co202.xi-lite.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756316Ab3ANM33 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 07:29:29 -0500
Message-ID: <50F3FA09.3080405@parrot.com>
Date: Mon, 14 Jan 2013 13:28:57 +0100
From: Matthieu CASTET <matthieu.castet@parrot.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100228)
MIME-Version: 1.0
To: Huang Shijie <b32955@freescale.com>
CC: "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dedekind1@gmail.com" <dedekind1@gmail.com>
Subject: Re: [PATCH] mtd: apply tPROG delay for ONFI nand's page program
References: <1358147853-31826-1-git-send-email-b32955@freescale.com>
In-Reply-To: <1358147853-31826-1-git-send-email-b32955@freescale.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang Shijie a écrit :
> With some latest Micron's onfi nand(such as MT29F64G08CBABAWP),
> I find that if we do not apply the tPROG delay as the datasheet tells us,
> the page program may fails. You will read out the all 0xff from this page
> in this case.
> 
> This patch adds the tPROG delay for page program when it is an onfi nand.
> 
> Signed-off-by: Huang Shijie <b32955@freescale.com>
> ---
>  drivers/mtd/nand/nand_base.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
> index 8323ac9..b628dd5 100644
> --- a/drivers/mtd/nand/nand_base.c
> +++ b/drivers/mtd/nand/nand_base.c
> @@ -841,6 +841,10 @@ static int nand_wait(struct mtd_info *mtd, struct nand_chip *chip)
>  	 */
>  	ndelay(100);
>  
> +	/* Apply the tPROG delay for ONFI nand program. */
> +	if (chip->onfi_version && state == FL_WRITING)
> +		udelay(le16_to_cpu(chip->onfi_params.t_prog));
> +
>  	if ((state == FL_ERASING) && (chip->options & NAND_IS_AND))
>  		chip->cmdfunc(mtd, NAND_CMD_STATUS_MULTI, -1, -1);
>  	else
It looks wrong : why should be wait tPROG before using status command to monitor
program end ?

tPROG is the Page program time (Measured from the falling edge of SR[6] to the
rising edge of SR[6]), but because we monitor SR[6] with status command, we
already wait for that time.

Are you sure that it is not a bug in your nand driver with status command ?



Matthieu
