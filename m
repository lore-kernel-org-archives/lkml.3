Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556Ab3LEWvF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 17:51:05 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:43572 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754158Ab3LEWvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 17:51:00 -0500
Date: Fri, 6 Dec 2013 01:50:51 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Will Tange <bh34rt@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: silicom: fix 'return is not a function,
 parentheses are not required' in bpctl_mod.c
Message-ID: <20131205225051.GC28413@mwanda>
References: <1386278633-29641-1-git-send-email-bh34rt@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386278633-29641-1-git-send-email-bh34rt@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 05, 2013 at 10:23:53PM +0100, Will Tange wrote:
> Fixes warnings regarding redundant parantheses thrown by the checkpatch tool in bpctl_mod.c
> 

Fair enough, but if you wanted to go clean the returns up further then
you could.  Remove all the "!= 0" bits.

> @@ -3125,11 +3125,11 @@ static int tx_status(struct bpctl_dev *pbpctl_dev)
>  
>  		ctrl = BPCTL_READ_REG(pbpctl_dev, CTRL);
>  		if (pbpctl_dev->bp_i80)
> -			return ((ctrl & BPCTLI_CTRL_SWDPIN1) != 0 ? 0 : 1);
> +			return (ctrl & BPCTLI_CTRL_SWDPIN1) != 0 ? 0 : 1;

The double negative just makes the code not as not confusing as it could
be.  Simpler:

			return (ctrl & BPCTLI_CTRL_SWDPIN1) ? 0 : 1;

>  
>  	if ((pbpctl_dev->bp_caps & BP_CAP)) {
>  		if (pbpctl_dev->bp_ext_ver >= PXG2BPI_VER) {
> -			return ((((read_reg(pbpctl_dev, STATUS_REG_ADDR)) &
> +			return (((read_reg(pbpctl_dev, STATUS_REG_ADDR)) &
>  				  BYPASS_FLAG_MASK) ==
> -				 BYPASS_FLAG_MASK) ? 1 : 0);
> +				 BYPASS_FLAG_MASK) ? 1 : 0;

These super long lines would be better if we introduced a temporary
variable.
			reg = read_reg(pbpctl_dev, STATUS_REG_ADDR);
			return (reg & BYPASS_FLAG_MASK) == BYPASS_FLAG_MASK;

BYPASS_FLAG_MASK is poorly named.  It's actually just a bit or a flag
and not a mask, so it could be renamed.

			reg = read_reg(pbpctl_dev, STATUS_REG_ADDR);
			return (reg & BP_BYPASS_FLAG) ? 1 : 0;

Which is way simpler than the original and only 2 lines long instead of
4.  I don't know that "BP_" is the right prefix...  BYPASS_FLAG is too
generic.

> @@ -4730,7 +4730,7 @@ int get_disc_pwup_fn(struct bpctl_dev *pbpctl_dev)
>  		return -1;
>  
>  	ret = default_pwron_disc_status(pbpctl_dev);
> -	return (ret == 0 ? 1 : (ret < 0 ? BP_NOT_CAP : 0));
> +	return ret == 0 ? 1 : (ret < 0 ? BP_NOT_CAP : 0);


	if (ret < 0)
		return BP_NOT_CAP;
	if (ret == 0)
		return 1;
	return 0;

More lines, but simpler to understand than the original.

Think of checkpatch.pl as a pointer to bad code and not that we just
have to silence checkpatch and move on.

regards,
dan carpenter
