Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751574AbaG1GKR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 02:10:17 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:64650 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbaG1GKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 02:10:11 -0400
Date: Sun, 27 Jul 2014 23:10:06 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: bpqw <bpqw@micron.com>
Cc: "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "b32955@freescale.com" <b32955@freescale.com>,
        "artem.bityutskiy@linux.intel.com" <artem.bityutskiy@linux.intel.com>,
        "ron@debian.org" <ron@debian.org>,
        "u.kleine-koenig@pengutronix.de" <u.kleine-koenig@pengutronix.de>,
        "ezequiel.garcia@free-electrons.com" 
	<ezequiel.garcia@free-electrons.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Subject: [PATCH 1/1] mtd:nand:fix nand_lock/unlock() function
Message-ID: <20140728061006.GC3095@norris-Latitude-E6410>
References: <CB9F11E856CFD04BB18EC1C68F2598931B1112@NTXXIAMBX01.xacn.micron.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CB9F11E856CFD04BB18EC1C68F2598931B1112@NTXXIAMBX01.xacn.micron.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi White,

You've responded to one of my messages, but your mail server is also
sending bounce replies. You might want to contact your I.T. about this.
(I'll let you know if I ever stop getting bounces.)

On Thu, Jul 24, 2014 at 01:00:01AM +0000, bpqw wrote:
> Do nand reset before write protect check
> If we want to check the WP# low or high through STATUS READ and check bit 7,
> we must reset the device, other operation (eg.erase/program a locked block) can
> also clear the bit 7 of status register.

This description doesn't really tell me why we need this patch.

First of all, where is the 'lock' sequence specified? I see the commit
that introduced nand_lock() (without any users) which says Micron parts
support it, but I don't see it documented in the datasheet:

  commit 7d70f334ad2bf1b3aaa1f0699c0f442e14bcc9e0
  Author: Vimal Singh <vimal.newwork@gmail.com>
  Date:   Mon Feb 8 15:50:49 2010 +0530

      mtd: nand: add lock/unlock routines

Now, supposing this is documented somewhere, are you seeing some kind of
out-of-spec behavior? Is this a controller quirk you're seeing? Why
should I need to reset the chip? I would presume that 

  chip->cmdfunc(mtd, NAND_CMD_STATUS, -1, -1);

would refresh the status properly. Is that not the case?

> Signed-off-by: White Ding <bpqw@micron.com>
> ---
>  drivers/mtd/nand/nand_base.c |   18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
> index 41167e9..22dd3aa 100644
> --- a/drivers/mtd/nand/nand_base.c
> +++ b/drivers/mtd/nand/nand_base.c
> @@ -965,6 +965,15 @@ int nand_unlock(struct mtd_info *mtd, loff_t ofs, uint64_t len)
>  
>  	chip->select_chip(mtd, chipnr);
>  
> +	/*
> +	 * Reset the chip.
> +	 * If we want to check the WP through READ STATUS and check the bit 7
> +	 * we must reset the chip
> +	 * some operation can also clear the bit 7 of status register
> +	 * eg. erase/program a locked block
> +	 */
> +	chip->cmdfunc(mtd, NAND_CMD_RESET, -1, -1);
> +
>  	/* Check, if it is write protected */
>  	if (nand_check_wp(mtd)) {
>  		pr_debug("%s: device is write protected!\n",
> @@ -1015,6 +1024,15 @@ int nand_lock(struct mtd_info *mtd, loff_t ofs, uint64_t len)
>  
>  	chip->select_chip(mtd, chipnr);
>  
> +	/*
> +	 * Reset the chip.
> +	 * If we want to check the WP through READ STATUS and check the bit 7
> +	 * we must reset the chip
> +	 * some operation can also clear the bit 7 of status register
> +	 * eg. erase/program a locked block
> +	 */
> +	chip->cmdfunc(mtd, NAND_CMD_RESET, -1, -1);
> +
>  	/* Check, if it is write protected */
>  	if (nand_check_wp(mtd)) {
>  		pr_debug("%s: device is write protected!\n",

Brian
