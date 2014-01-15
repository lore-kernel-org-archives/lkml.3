Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751445AbaAOD6h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 22:58:37 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36928 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbaAOD6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 22:58:35 -0500
Date: Tue, 14 Jan 2014 19:58:49 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Chase Southwood <chase.southwood@yahoo.com>
Cc: devel@driverdev.osuosl.org, abbotti@mev.co.uk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] Staging: comedi: convert while loop to timeout in
 ni_mio_common.c
Message-ID: <20140115035849.GA13127@kroah.com>
References: <1389669228-15090-1-git-send-email-chase.southwood@yahoo.com>
 <1389745385-27146-1-git-send-email-chase.southwood@yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389745385-27146-1-git-send-email-chase.southwood@yahoo.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 06:23:05PM -0600, Chase Southwood wrote:
> This patch for ni_mio_common.c changes out a while loop for a timeout,
> which is preferred.
> 
> Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
> ---
> 
> OK, here's another go at it.  Hopefully everything looks more correct
> this time.  Greg, I've followed the pattern you gave me, and I really
> appreciate all of the tips!  As always, just let me know if there are
> still things that need adjusting (especially length of timeout, udelay,
> etc.).
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
>  drivers/staging/comedi/drivers/ni_mio_common.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/comedi/drivers/ni_mio_common.c b/drivers/staging/comedi/drivers/ni_mio_common.c
> index 457b884..882b249 100644
> --- a/drivers/staging/comedi/drivers/ni_mio_common.c
> +++ b/drivers/staging/comedi/drivers/ni_mio_common.c
> @@ -687,12 +687,21 @@ static void ni_clear_ai_fifo(struct comedi_device *dev)
>  {
>  	const struct ni_board_struct *board = comedi_board(dev);
>  	struct ni_private *devpriv = dev->private;
> +	unsigned long timeout;
>  
>  	if (board->reg_type == ni_reg_6143) {
>  		/*  Flush the 6143 data FIFO */
>  		ni_writel(0x10, AIFIFO_Control_6143);	/*  Flush fifo */
>  		ni_writel(0x00, AIFIFO_Control_6143);	/*  Flush fifo */
> -		while (ni_readl(AIFIFO_Status_6143) & 0x10) ;	/*  Wait for complete */
> +		/*  Wait for complete */
> +		timeout = jiffies + msec_to_jiffies(100);
> +		while (ni_readl(AIFIFO_Status_6143) & 0x10) {
> +			if (time_after(jiffies, timeout)) {
> +				comedi_error(dev, "FIFO flush timeout.");
> +				break;
> +			}
> +			udelay(1);

Sleep for at least 10, as I think that's the smallest time delay you can
sleep for anyway (meaning it will be that long no matter what number you
put there less than 10, depending on the hardware used of course.)

Other than that, looks much better.

thanks,

greg k-h
