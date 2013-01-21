Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429Ab3AUO2H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 09:28:07 -0500
Received: from co202.xi-lite.net ([149.6.83.202]:56628 "EHLO co202.xi-lite.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753497Ab3AUO2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 09:28:06 -0500
Message-ID: <50FD5052.6030704@parrot.com>
Date: Mon, 21 Jan 2013 15:27:30 +0100
From: Matthieu CASTET <matthieu.castet@parrot.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100228)
MIME-Version: 1.0
To: Huang Shijie <shijie8@gmail.com>
CC: "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dedekind1@gmail.com" <dedekind1@gmail.com>
Subject: Re: [PATCH] mtd: fix the wrong timeo for panic_nand_wait()
References: <1358824265-3425-1-git-send-email-shijie8@gmail.com>
In-Reply-To: <1358824265-3425-1-git-send-email-shijie8@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Could you explain why the old code was wrong ?

With HZ=100

timeo = jiffies + 2 and it should be working.


Huang Shijie a écrit :
> In nand_wait(), the timeo for panic_nand_wait() is assigned with
> wrong value(jiffies + some delay).
> 
> This patch fixes it, and also uses the msecs_to_jiffies() to make the
> code more readable.
> 
> Signed-off-by: Huang Shijie <shijie8@gmail.com>
> ---
>  drivers/mtd/nand/nand_base.c |    8 ++------
>  1 files changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
> index 8323ac9..acdd508 100644
> --- a/drivers/mtd/nand/nand_base.c
> +++ b/drivers/mtd/nand/nand_base.c
> @@ -825,14 +825,9 @@ static void panic_nand_wait(struct mtd_info *mtd, struct nand_chip *chip,
>  static int nand_wait(struct mtd_info *mtd, struct nand_chip *chip)
>  {
>  
> -	unsigned long timeo = jiffies;
> +	unsigned long timeo = (state == FL_ERASING) ? 400 : 20;
>  	int status, state = chip->state;
>  
> -	if (state == FL_ERASING)
> -		timeo += (HZ * 400) / 1000;
> -	else
> -		timeo += (HZ * 20) / 1000;
> -
>  	led_trigger_event(nand_led_trigger, LED_FULL);
>  
>  	/*
> @@ -849,6 +844,7 @@ static int nand_wait(struct mtd_info *mtd, struct nand_chip *chip)
>  	if (in_interrupt() || oops_in_progress)
>  		panic_nand_wait(mtd, chip, timeo);
>  	else {
> +		timeo = jiffies + msecs_to_jiffies(timeo);
>  		while (time_before(jiffies, timeo)) {
>  			if (chip->dev_ready) {
>  				if (chip->dev_ready(mtd))
