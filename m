Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751232AbaEQTju (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 15:39:50 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:24960 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbaEQTjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 15:39:48 -0400
Date: Sat, 17 May 2014 22:39:27 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Masaru Nomura <massa.nomura@gmail.com>
Cc: lidza.louina@gmail.com, markh@compro.net, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, driverdev-devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] staging: dgnc: dgnc_neo: Fix conditional part of if
 statement
Message-ID: <20140517193927.GD15585@mwanda>
References: <1400344254-13007-1-git-send-email-massa.nomura@gmail.com>
 <1400344254-13007-4-git-send-email-massa.nomura@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400344254-13007-4-git-send-email-massa.nomura@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 17, 2014 at 05:30:53PM +0100, Masaru Nomura wrote:
> diff --git a/drivers/staging/dgnc/dgnc_neo.c b/drivers/staging/dgnc/dgnc_neo.c
> index 8988346..c211f9f 100644
> --- a/drivers/staging/dgnc/dgnc_neo.c
> +++ b/drivers/staging/dgnc/dgnc_neo.c
> @@ -838,9 +838,11 @@ static void neo_param(struct tty_struct *tty)
>  	 * Have the UART interrupt on modem signal changes ONLY when
>  	 * we are in hardware flow control mode, or CLOCAL/FORCEDCD is not set.
>  	 */
> -	if ((ch->ch_digi.digi_flags & CTSPACE) || (ch->ch_digi.digi_flags & RTSPACE) ||
> -		(ch->ch_c_cflag & CRTSCTS) || !(ch->ch_digi.digi_flags & DIGI_FORCEDCD) ||
> -		!(ch->ch_c_cflag & CLOCAL)) {
> +	if ((ch->ch_digi.digi_flags & CTSPACE)
> +			|| (ch->ch_digi.digi_flags & RTSPACE)
> +			|| (ch->ch_c_cflag & CRTSCTS)
> +			|| !(ch->ch_digi.digi_flags & DIGI_FORCEDCD)
> +			|| !(ch->ch_c_cflag & CLOCAL)) {

This isn't the right way.  Write it like this:

	if ((ch->ch_digi.digi_flags & CTSPACE) ||
	    (ch->ch_digi.digi_flags & RTSPACE) ||
	    (ch->ch_c_cflag & CRTSCTS) ||
	    !(ch->ch_digi.digi_flags & DIGI_FORCEDCD) ||
	    !(ch->ch_c_cflag & CLOCAL)) {
		ier |= UART_IER_MSI;
	else
		ier &= ~UART_IER_MSI;

1) The "||" operation goes at the end of the line.
2) The conditions are all in a line.  The indenting is

[tab][space][space][space][space](ch->ch_digi.digi_f...

Also just fold this patch and [patch 2/4] together into one patch.  We
don't need two patches to fix one if statement.

The one thing per patch rule is a bit tricky.  It means that you have to
say which one thing you are fixing.  Don't say "I am fixing three
things."  Say "I am fixing one if statement".

regards,
dan carpenter


