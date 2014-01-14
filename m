Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890AbaANTqE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 14:46:04 -0500
Received: from smtprelay0056.hostedemail.com ([216.40.44.56]:53887 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751770AbaANTqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 14:46:02 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:421:541:599:800:960:966:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2196:2199:2393:2559:2562:2689:2736:2828:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3868:3870:3871:3873:3874:4031:4321:4385:5007:7652:8660:9040:10004:10400:10848:11026:11232:11657:11658:11914:12043:12213:12296:12517:12519:12555:12663:12740:13095:13141:13148:13230:13255,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: self53_6e778c74dfd26
X-Filterd-Recvd-Size: 3355
Message-ID: <1389728757.24849.52.camel@joe-AO722>
Subject: Re: [PATCH v2] Staging: comedi: convert while loop to timeout in
 ni_mio_common.c.
From: Joe Perches <joe@perches.com>
To: Chase Southwood <chase.southwood@yahoo.com>
Cc: gregkh@linuxfoundation.org, abbotti@mev.co.uk,
        hsweeten@visionengravers.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Tue, 14 Jan 2014 11:45:57 -0800
In-Reply-To: <1389728326-23387-1-git-send-email-chase.southwood@yahoo.com>
References: <1389669228-15090-1-git-send-email-chase.southwood@yahoo.com>
	 <1389728326-23387-1-git-send-email-chase.southwood@yahoo.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-01-14 at 13:38 -0600, Chase Southwood wrote:
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
> +				break;
> +			udelay(1);
> +		}

some sort of error message would be nice too

		if (i >= timeout)
			comedi_error(dev, "FIFO flush timeout");


