Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455Ab3FQRYM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 13:24:12 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:24976 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753348Ab3FQRYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 13:24:07 -0400
Date: Mon, 17 Jun 2013 20:22:46 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Lorenz Haspel <lorenz@badgers.com>
Cc: devel@linuxdriverproject.org, gregkh@linuxfoundation.org,
        puff65537@bansheeslibrary.com, viro@zeniv.linux.org.uk,
        michael.banken@mathe.stud.uni-erlangen.de, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        linux-kernel@i4.informatik.uni-erlangen.de
Subject: Re: [PATCH 1/4] silicom: checkpatch: assignments in if conditions
Message-ID: <20130617172246.GI5008@mwanda>
References: <1371486386-8043-1-git-send-email-lorenz@badgers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371486386-8043-1-git-send-email-lorenz@badgers.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will need to be redone because there were some buggy extra
lines added toward the end of the patch.

On Mon, Jun 17, 2013 at 06:26:23PM +0200, Lorenz Haspel wrote:
> @@ -1743,8 +1750,8 @@ static void write_data_port_int(bpctl_dev_t *pbpctl_dev,
>  static int write_data_int(bpctl_dev_t *pbpctl_dev, unsigned char value)
>  {
>  	bpctl_dev_t *pbpctl_dev_b = NULL;
> -

This blank line is needed.  (Put a blank line between declarations
and code).

> -	if (!(pbpctl_dev_b = get_status_port_fn(pbpctl_dev)))
> +	pbpctl_dev_b = get_status_port_fn(pbpctl_dev);
> +	if (!pbpctl_dev_b)
>  		return -1;
>  	atomic_set(&pbpctl_dev->wdt_busy, 1);
>  	write_data_port_int(pbpctl_dev, value & 0x3);
> @@ -1965,7 +1972,8 @@ int tpl_hw_on(bpctl_dev_t *pbpctl_dev)
>  	int ret = 0, ctrl = 0;
>  	bpctl_dev_t *pbpctl_dev_b = NULL;
>  
> -	if (!(pbpctl_dev_b = get_status_port_fn(pbpctl_dev)))
> +	pbpctl_dev_b = get_status_port_fn(pbpctl_dev);
> +	if (!pbpctl_dev_b)
>  		return BP_NOT_CAP;
>  
>  	if (pbpctl_dev->bp_caps_ex & TPL2_CAP_EX) {

> @@ -1991,8 +1999,8 @@ int tpl_hw_off(bpctl_dev_t *pbpctl_dev)
>  {
>  	int ret = 0, ctrl = 0;
>  	bpctl_dev_t *pbpctl_dev_b = NULL;
> -

Same for this blank line and all the following instances.

> -	if (!(pbpctl_dev_b = get_status_port_fn(pbpctl_dev)))
> +	pbpctl_dev_b = get_status_port_fn(pbpctl_dev);
> +	if (!pbpctl_dev_b)
>  		return BP_NOT_CAP;
>  	if (pbpctl_dev->bp_caps_ex & TPL2_CAP_EX) {
>  		cmnd_on(pbpctl_dev);

> @@ -4461,11 +4472,13 @@ int set_bypass_pwoff_fn(bpctl_dev_t *pbpctl_dev, int bypass_mode)
>  
>  	if (!(pbpctl_dev->bp_caps & BP_PWOFF_CTL_CAP))
>  		return BP_NOT_CAP;
> -	if ((ret = cmnd_on(pbpctl_dev)) < 0)
> +	ret = cmnd_on(pbpctl_dev);
> +	if (ret < 0)
>  		return ret;
>  	if (bypass_mode)
>  		ret = bypass_state_pwroff(pbpctl_dev);
> -	else
> +	ret = cmnd_on(pbpctl_dev);
> +	if (ret < 0)
>  		ret = normal_state_pwroff(pbpctl_dev);

These added lines do not belong.  The patch will need to be redone
to fix this bug.

>  	cmnd_off(pbpctl_dev);
>  	return ret;

> @@ -4867,10 +4884,12 @@ int set_tx_fn(bpctl_dev_t *pbpctl_dev, int tx_state)
>  	    (pbpctl_dev->bp_caps & SW_CTL_CAP)) {
>  		if ((pbpctl_dev->bp_tpl_flag))
>  			return BP_NOT_CAP;
> -	} else if ((pbpctl_dev_b = get_master_port_fn(pbpctl_dev))) {
> -		if ((pbpctl_dev_b->bp_caps & TPL_CAP) &&
> -		    (pbpctl_dev_b->bp_tpl_flag))
> -			return BP_NOT_CAP;
> +	} else {
> +		pbpctl_dev_b = get_status_port_fn(pbpctl_dev);
> +		if (pbpctl_dev_b)
> +			if ((pbpctl_dev_b->bp_caps & TPL_CAP) &&
> +			    (pbpctl_dev_b->bp_tpl_flag))
> +				return BP_NOT_CAP;

Please put curly brace {} around multi-line indents.  Even though
they are not needed for semantic reasons they make the code more
readable.

>  	}
>  	return set_tx(pbpctl_dev, tx_state);
>  }

regards,
dan carpenter
