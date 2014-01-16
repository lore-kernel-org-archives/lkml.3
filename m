Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752388AbaAPLa5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 06:30:57 -0500
Received: from mail.mev.co.uk ([62.49.15.74]:53550 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535AbaAPLax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 06:30:53 -0500
Message-ID: <52D7C2E8.9060204@mev.co.uk>
Date: Thu, 16 Jan 2014 11:30:48 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Chase Southwood <chase.southwood@yahoo.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: Ian Abbott <ian.abbott@mev.co.uk>,
        "hsweeten@visionengravers.com" <hsweeten@visionengravers.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v7] Staging: comedi: convert while loop to timeout in
 ni_mio_common.c
References: <1389669228-15090-1-git-send-email-chase.southwood@yahoo.com> <1389813752-3009-1-git-send-email-chase.southwood@yahoo.com>
In-Reply-To: <1389813752-3009-1-git-send-email-chase.southwood@yahoo.com>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-01-15 19:22, Chase Southwood wrote:
> This patch for ni_mio_common.c changes out a while loop for a timeout,
> which is preferred.
>
> Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
> ---
>
> Hartley,
> I sincerely apologize for the obvious mistake, I thought I had built it
> but clearly I made a mistake somewhere, as your observation is exactly
> correct.  It is now fixed.
>
> Thanks,
> Chase Southwood
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
>   drivers/staging/comedi/drivers/ni_mio_common.c | 12 +++++++++++-
>   1 file changed, 11 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/staging/comedi/drivers/ni_mio_common.c b/drivers/staging/comedi/drivers/ni_mio_common.c
> index 457b884..ab7a74c 100644
> --- a/drivers/staging/comedi/drivers/ni_mio_common.c
> +++ b/drivers/staging/comedi/drivers/ni_mio_common.c
> @@ -55,6 +55,7 @@
>   #include <linux/interrupt.h>
>   #include <linux/sched.h>
>   #include <linux/delay.h>
> +#include <asm/processor.h>
>   #include "8255.h"
>   #include "mite.h"
>   #include "comedi_fc.h"
> @@ -687,12 +688,21 @@ static void ni_clear_ai_fifo(struct comedi_device *dev)
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
> +		timeout = jiffies + msecs_to_jiffies(500);
> +		while (ni_readl(AIFIFO_Status_6143) & 0x10) {
> +			if (time_after(jiffies, timeout)) {
> +				comedi_error(dev, "FIFO flush timeout.");
> +				break;
> +			}
> +			cpu_relax();
> +		}
>   	} else {
>   		devpriv->stc_writew(dev, 1, ADC_FIFO_Clear);
>   		if (board->reg_type == ni_reg_625x) {
>

Sorry this is your worst nightmare, Chase.  Your patch is great and has 
been modified in all the ways various people have suggested, but I don't 
think it is suitable.

After examining the code, it turns out ni_clear_ai_fifo() is sometimes 
called from an interrupt service routine and I don't think you can wait 
for jiffies to change in that case.  I think we need to go back to your 
PATCH v2 and fix up the checkpatch.pl warning that Greg mentioned.

Sorry about that.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
