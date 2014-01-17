Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286AbaAQNM4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 08:12:56 -0500
Received: from mail.mev.co.uk ([62.49.15.74]:56058 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751004AbaAQNMz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 08:12:55 -0500
Message-ID: <52D92C4D.9030702@mev.co.uk>
Date: Fri, 17 Jan 2014 13:12:45 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Chase Southwood <chase.southwood@yahoo.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: Ian Abbott <ian.abbott@mev.co.uk>,
        "hsweeten@visionengravers.com" <hsweeten@visionengravers.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8] Staging: comedi: convert while loop to timeout in
 ni_mio_common.c
References: <1389669228-15090-1-git-send-email-chase.southwood@yahoo.com> <1389896849-3186-1-git-send-email-chase.southwood@yahoo.com>
In-Reply-To: <1389896849-3186-1-git-send-email-chase.southwood@yahoo.com>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-01-16 18:27, Chase Southwood wrote:
> This patch for ni_mio_common.c changes out a while loop for a timeout,
> which is preferred.
>
> Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
> ---
>
> Okay, back to v2, basically.  I fixed the checkpatch warning from v2,
> and added the error checking that was from v3, but otherwise it is the
> same.  Of note, I have used a udelay of 1 here (Greg had suggested to
> use 10, but Ian prefers 1 so I have gone with that, and I assume that
> cpu_relax is no longer an option.).
>
> 2: Changed from simple clean-up to swapping a timeout in for a while loop.
>
> 3: Removed extra counter variable, and added error checking.
>
> 4: No longer using counter variable, using jiffies instead.
>
> 5: udelay for 10u, instead of 1u.
>
> 6: Scrap udelay entirely, in favor of cpu_relax. Include asm/processor.h
> in order to use cpu_relax.
>
> 7: Fix typo (msec vs msecs).
>
> 8: Revert back to v2, with some small changes (see above).
>
>   drivers/staging/comedi/drivers/ni_mio_common.c | 12 +++++++++++-
>   1 file changed, 11 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/staging/comedi/drivers/ni_mio_common.c b/drivers/staging/comedi/drivers/ni_mio_common.c
> index 457b884..10c27cb 100644
> --- a/drivers/staging/comedi/drivers/ni_mio_common.c
> +++ b/drivers/staging/comedi/drivers/ni_mio_common.c
> @@ -687,12 +687,22 @@ static void ni_clear_ai_fifo(struct comedi_device *dev)
>   {
>   	const struct ni_board_struct *board = comedi_board(dev);
>   	struct ni_private *devpriv = dev->private;
> +	static const int timeout = 10000;
> +	int i;
>
>   	if (board->reg_type == ni_reg_6143) {
>   		/*  Flush the 6143 data FIFO */
>   		ni_writel(0x10, AIFIFO_Control_6143);	/*  Flush fifo */
>   		ni_writel(0x00, AIFIFO_Control_6143);	/*  Flush fifo */
> -		while (ni_readl(AIFIFO_Status_6143) & 0x10) ;	/*  Wait for complete */
> +		/*  Wait for complete */
> +		for (i = 0; i < timeout; i++) {
> +			if (!(ni_readl(AIFIFO_Status_6143) & 0x10))
> +				break;
> +			udelay(1);
> +		}
> +		if (i == timeout) {
> +			comedi_error(dev, "FIFO flush timeout.");
> +		}
>   	} else {
>   		devpriv->stc_writew(dev, 1, ADC_FIFO_Clear);
>   		if (board->reg_type == ni_reg_625x) {
>

Personally, I'm happy with it.  The upper bound on the iterations is 
quite high for something that could be called on an interrupt, but it's 
better than an infinite loop, and it only reach the upper bound if the 
hardware is broken or there's some other bug.

Reviewed-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
