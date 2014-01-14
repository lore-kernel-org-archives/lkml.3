Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751967AbaANTuB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 14:50:01 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33171 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbaANTt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 14:49:58 -0500
Date: Tue, 14 Jan 2014 11:50:36 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Chase Southwood <chase.southwood@yahoo.com>
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Staging: comedi: convert while loop to timeout in
 ni_mio_common.c.
Message-ID: <20140114195036.GA25586@kroah.com>
References: <1389669228-15090-1-git-send-email-chase.southwood@yahoo.com>
 <1389728326-23387-1-git-send-email-chase.southwood@yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389728326-23387-1-git-send-email-chase.southwood@yahoo.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 01:38:46PM -0600, Chase Southwood wrote:
> This patch to ni_mio_common.c changes a while loop to a timeout for
> loop, which is preferred.
> 
> Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
> ---
> 
> I know Mr. Abbott mentioned that he wouldn't expect clean-up patches to have to deal with this sort of thing, but I thought I'd at least give the timeout thing a try.  Feel free to disregard this and take v1 of this patch instead if you would just like the simple clean-up.  That being said, I used 10000 iterations at the suggestion of Mr. Abbott, and a short delay as well.  Let me know if these values seem incorrect.  Also, at some (but not all) locations in this file that currently use timeouts, contain a check for i == timeout, with a call to either printk or comedi_error if the operation actually times out.  Would something like that be required here?
> 
> Sorry for all of the questions, but I'm sort of new around here and I'd like to help out with more than just clean-ups and this seemed like a good opportunity to at least try!
> 
> 2: Changed from simple clean-up to swapping a timeout in for a while loop.
> 
>  drivers/staging/comedi/drivers/ni_mio_common.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/comedi/drivers/ni_mio_common.c b/drivers/staging/comedi/drivers/ni_mio_common.c
> index 457b884..05cd5ed 100644
> --- a/drivers/staging/comedi/drivers/ni_mio_common.c
> +++ b/drivers/staging/comedi/drivers/ni_mio_common.c
> @@ -687,12 +687,19 @@ static void ni_clear_ai_fifo(struct comedi_device *dev)
>  {
>  	const struct ni_board_struct *board = comedi_board(dev);
>  	struct ni_private *devpriv = dev->private;
> +	static const int timeout = 10000;
> +	int i;
>  
>  	if (board->reg_type == ni_reg_6143) {
>  		/*  Flush the 6143 data FIFO */
>  		ni_writel(0x10, AIFIFO_Control_6143);	/*  Flush fifo */
>  		ni_writel(0x00, AIFIFO_Control_6143);	/*  Flush fifo */
> -		while (ni_readl(AIFIFO_Status_6143) & 0x10) ;	/*  Wait for complete */
> +		/*  Wait for complete */
> +		for (i = 0; i < timeout; i++) {
> +			if(!(ni_readl(AIFIFO_Status_6143) & 0x10))

Please always run your patches through scripts/checkpatch.pl so that we
don't just point out the issues that it would have told you about :)

> +				break;
> +			udelay(1);

This is good, but you don't need a counter, you could just look at the
time that has expired so far and if it exceeds a limit, then exit and
error out.

thanks,

greg k-h
