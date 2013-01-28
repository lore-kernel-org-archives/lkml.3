Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751856Ab3A1SZK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 13:25:10 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:34254 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710Ab3A1SZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 13:25:06 -0500
Date: Mon, 28 Jan 2013 19:24:51 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: Mugunthan V N <mugunthanvnm@ti.com>, Matt Porter <mporter@ti.com>,
        Chase Maupin <chase.maupin@ti.com>, Jason Kridner <jdk@ti.com>,
        Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpsw: Fix interrupt storm among other things
Message-ID: <20130128182451.GC2445@netboy.at.omicron.at>
References: <1359378668-26536-1-git-send-email-panto@antoniou-consulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359378668-26536-1-git-send-email-panto@antoniou-consulting.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 03:11:08PM +0200, Pantelis Antoniou wrote:
> Fix interrupt storm on bone A4 cause by non-by-the-book interrupt handling.
> While at it, added a non-NAPI mode (which is easier to debug), plus
> some general fixes.

I have a few issues with this patch:

1. This is a networking patch. It should be addressed to netdev, it it
   needs to have davem on CC.

2. The description is poor. You need to tell us more about this
   "storm". How can one trigger it? What is the effect? Does the
   system lock up, or is the throughput poor? Tell us exactly what the
   problem is. Tell us what is wrong in the interrupt handling, and
   how the patch improves the situation.

3. Don't just say "general fixes", but do say exactly what you fixed.

4. Adding non-NAPI code is going backwards. Don't do that (and see the
   recent discussion on netdev on just this very topic: Frank Li and
   the fec driver).

> diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
> index 40aff68..b6ca4af 100644
> --- a/drivers/net/ethernet/ti/cpsw.c
> +++ b/drivers/net/ethernet/ti/cpsw.c
> @@ -148,10 +148,37 @@ struct cpsw_wr_regs {
>  	u32	soft_reset;
>  	u32	control;
>  	u32	int_control;
> -	u32	rx_thresh_en;
> -	u32	rx_en;
> -	u32	tx_en;
> -	u32	misc_en;
> +	u32	c0_rx_thresh_en;
> +	u32	c0_rx_en;
> +	u32	c0_tx_en;
> +	u32	c0_misc_en;

How does renaming these help?

(If you really think that new names are needed, then put the cosmetic
renaming changes into its a separate patch.)

> +	u32	c1_rx_thresh_en;
> +	u32	c1_rx_en;
> +	u32	c1_tx_en;
> +	u32	c1_misc_en;

You added a bunch of new fields, but you don't use any of them.

Thanks,
Richard
