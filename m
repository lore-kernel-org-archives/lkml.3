Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357Ab3A2VAX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 16:00:23 -0500
Received: from zmc.proxad.net ([212.27.53.206]:56062 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753040Ab3A2VAT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 16:00:19 -0500
From: Florian Fainelli <ffainelli@freebox.fr>
To: Huang Shijie <b32955@freescale.com>
Subject: Re: [PATCH v2] mtd: fix the wrong timeo for panic_nand_wait()
Date: Tue, 29 Jan 2013 22:00:14 +0100
User-Agent: KMail/1.13.7 (Linux/3.7-trunk-amd64; KDE/4.8.4; x86_64; ; )
Cc: dwmw2@infradead.org, dedekind1@gmail.com, matthieu.castet@parrot.com,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
References: <CAMiH66HWn5PtjX20=WT7GMMV=J72rg3jx64iACSBiExjoD+X7A@mail.gmail.com> <1358818230-27037-1-git-send-email-b32955@freescale.com>
In-Reply-To: <1358818230-27037-1-git-send-email-b32955@freescale.com>
Organization: Freebox
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201301292200.14622.ffainelli@freebox.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Huang,

Le mardi 22 janvier 2013 02:30:30, Huang Shijie a écrit :
> In nand_wait(), the timeo for panic_nand_wait() is assigned with
> wrong value(jiffies + some delay). The timeo should be set like the
> panic_nand_write() does.
> 
> This patch fixes it, and also uses the msecs_to_jiffies() to make the
> code more readable.

You are not exactly explaining what is the issue with the current code, and 
how you are fixing it. If someone needs to backport this patch for whatever 
reason, it must be clear as to what it fixes.

> 
> Signed-off-by: Huang Shijie <b32955@freescale.com>
> ---
> fix the compiler error in version 1, and add some commits.
> 
> ---
>  drivers/mtd/nand/nand_base.c |    8 ++------
>  1 files changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
> index 8323ac9..a8c1fb4 100644
> --- a/drivers/mtd/nand/nand_base.c
> +++ b/drivers/mtd/nand/nand_base.c
> @@ -825,13 +825,8 @@ static void panic_nand_wait(struct mtd_info *mtd,
> struct nand_chip *chip, static int nand_wait(struct mtd_info *mtd, struct
> nand_chip *chip) {
> 
> -	unsigned long timeo = jiffies;
>  	int status, state = chip->state;
> -
> -	if (state == FL_ERASING)
> -		timeo += (HZ * 400) / 1000;
> -	else
> -		timeo += (HZ * 20) / 1000;
> +	unsigned long timeo = (state == FL_ERASING ? 400 : 20);
> 
>  	led_trigger_event(nand_led_trigger, LED_FULL);
> 
> @@ -849,6 +844,7 @@ static int nand_wait(struct mtd_info *mtd, struct
> nand_chip *chip) if (in_interrupt() || oops_in_progress)
>  		panic_nand_wait(mtd, chip, timeo);
>  	else {
> +		timeo = jiffies + msecs_to_jiffies(timeo);
>  		while (time_before(jiffies, timeo)) {
>  			if (chip->dev_ready) {
>  				if (chip->dev_ready(mtd))

-- 
Florian
