Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016AbaH3UcT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 16:32:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53742 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbaH3UcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 16:32:17 -0400
Date: Sat, 30 Aug 2014 13:32:16 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Mark Einon <mark.einon@gmail.com>
Cc: devel@driverdev.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/8] staging: et131x: Use for loop to initialise
 contiguous registers to zero
Message-ID: <20140830203216.GA11525@kroah.com>
References: <1408573078-9320-1-git-send-email-mark.einon@gmail.com>
 <1408573078-9320-4-git-send-email-mark.einon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408573078-9320-4-git-send-email-mark.einon@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2014 at 11:17:53PM +0100, Mark Einon wrote:
> Replace a long list of contiguous writel() calls with a for loop iterating
> over the same values.
> 
> Signed-off-by: Mark Einon <mark.einon@gmail.com>
> ---
>  drivers/staging/et131x/et131x.c | 27 +++------------------------
>  1 file changed, 3 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
> index fffe763..44cc684 100644
> --- a/drivers/staging/et131x/et131x.c
> +++ b/drivers/staging/et131x/et131x.c
> @@ -1138,6 +1138,7 @@ static void et1310_config_rxmac_regs(struct et131x_adapter *adapter)
>  	u32 sa_lo;
>  	u32 sa_hi = 0;
>  	u32 pf_ctrl = 0;
> +	u32 *wolw;
>  
>  	/* Disable the MAC while it is being configured (also disable WOL) */
>  	writel(0x8, &rxmac->ctrl);
> @@ -1151,30 +1152,8 @@ static void et1310_config_rxmac_regs(struct et131x_adapter *adapter)
>  	 * its default Values of 0x00000000 because there are not WOL masks
>  	 * as of this time.
>  	 */
> -	writel(0, &rxmac->mask0_word0);
> -	writel(0, &rxmac->mask0_word1);
> -	writel(0, &rxmac->mask0_word2);
> -	writel(0, &rxmac->mask0_word3);
> -
> -	writel(0, &rxmac->mask1_word0);
> -	writel(0, &rxmac->mask1_word1);
> -	writel(0, &rxmac->mask1_word2);
> -	writel(0, &rxmac->mask1_word3);
> -
> -	writel(0, &rxmac->mask2_word0);
> -	writel(0, &rxmac->mask2_word1);
> -	writel(0, &rxmac->mask2_word2);
> -	writel(0, &rxmac->mask2_word3);
> -
> -	writel(0, &rxmac->mask3_word0);
> -	writel(0, &rxmac->mask3_word1);
> -	writel(0, &rxmac->mask3_word2);
> -	writel(0, &rxmac->mask3_word3);
> -
> -	writel(0, &rxmac->mask4_word0);
> -	writel(0, &rxmac->mask4_word1);
> -	writel(0, &rxmac->mask4_word2);
> -	writel(0, &rxmac->mask4_word3);
> +	for (wolw = &rxmac->mask0_word0; wolw <= &rxmac->mask4_word3; wolw++)
> +		writel(0, wolw);

You are now only writing to all locations 1 time, instead of 4 times,
like before, are you sure that is ok?  Hardware is flaky, sometimes it
wants to be written to multiple times...

greg k-h
