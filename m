Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751637AbaAOKiL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 05:38:11 -0500
Received: from mail.mev.co.uk ([62.49.15.74]:50373 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751004AbaAOKiJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 05:38:09 -0500
Message-ID: <52D6650C.5090707@mev.co.uk>
Date: Wed, 15 Jan 2014 10:38:04 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Chase Southwood <chase.southwood@yahoo.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: Ian Abbott <ian.abbott@mev.co.uk>,
        "hsweeten@visionengravers.com" <hsweeten@visionengravers.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5] Staging: comedi: convert while loop to timeout in
 ni_mio_common.c
References: <1389669228-15090-1-git-send-email-chase.southwood@yahoo.com> <1389762917-3134-1-git-send-email-chase.southwood@yahoo.com>
In-Reply-To: <1389762917-3134-1-git-send-email-chase.southwood@yahoo.com>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-01-15 05:15, Chase Southwood wrote:
> This patch for ni_mio_common.c changes out a while loop for a timeout,
> which is preferred.
>
> Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
> ---
>
> All right, I think this guy's ready to go now!  Thanks for all the help!
> Chase
>
> 2: Changed from simple clean-up to swapping a timeout in for a while loop.
>
> 3: Removed extra counter variable, and added error checking.
>
> 4: No longer using counter variable, using jiffies instead.
>
> 5: udelay for 10u, instead of 1u.
>
>   drivers/staging/comedi/drivers/ni_mio_common.c | 11 ++++++++++-
>   1 file changed, 10 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/staging/comedi/drivers/ni_mio_common.c b/drivers/staging/comedi/drivers/ni_mio_common.c
> index 457b884..07e9777 100644
> --- a/drivers/staging/comedi/drivers/ni_mio_common.c
> +++ b/drivers/staging/comedi/drivers/ni_mio_common.c
> @@ -687,12 +687,21 @@ static void ni_clear_ai_fifo(struct comedi_device *dev)
>   {
>   	const struct ni_board_struct *board = comedi_board(dev);
>   	struct ni_private *devpriv = dev->private;
> +	unsigned long timeout;
>
>   	if (board->reg_type == ni_reg_6143) {
>   		/*  Flush the 6143 data FIFO */
>   		ni_writel(0x10, AIFIFO_Control_6143);	/*  Flush fifo */
>   		ni_writel(0x00, AIFIFO_Control_6143);	/*  Flush fifo */
> -		while (ni_readl(AIFIFO_Status_6143) & 0x10) ;	/*  Wait for complete */
> +		/*  Wait for complete */
> +		timeout = jiffies + msec_to_jiffies(500);
> +		while (ni_readl(AIFIFO_Status_6143) & 0x10) {
> +			if (time_after(jiffies, timeout)) {
> +				comedi_error(dev, "FIFO flush timeout.");
> +				break;
> +			}
> +			udelay(10);

I preferred the earlier udelay(1) from your PATCH v4, but I think it's 
even better to replace it with:

			cpu_relax();

You might also need:

#include <asm/processor.h>

to define cpu_relax().

> +		}
>   	} else {
>   		devpriv->stc_writew(dev, 1, ADC_FIFO_Clear);
>   		if (board->reg_type == ni_reg_625x) {
>


-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
