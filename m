Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310Ab3BJLrh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 06:47:37 -0500
Received: from sauhun.de ([89.238.76.85]:40660 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751116Ab3BJLrf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 06:47:35 -0500
Date: Sun, 10 Feb 2013 12:47:30 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Tejun Heo <tj@kernel.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Jean Delvare <khali@linux-fr.org>, linux-i2c@vger.kernel.org
Subject: Re: [PATCH v2] i2c: convert to idr_alloc()
Message-ID: <20130210114729.GB5472@nekote.pengutronix.de>
References: <1360179649-22465-1-git-send-email-tj@kernel.org>
 <1360179649-22465-38-git-send-email-tj@kernel.org>
 <20130207152831.GA14797@sirena.org.uk>
 <20130207163247.GL2875@htj.dyndns.org>
 <20130207163958.GY4720@opensource.wolfsonmicro.com>
 <20130207165547.GO2875@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130207165547.GO2875@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

thanks for doing this cleanup series. Looks very worthwhile!

> --- a/drivers/i2c/i2c-core.c
> +++ b/drivers/i2c/i2c-core.c
> @@ -935,25 +935,16 @@ out_list:
>   */
>  int i2c_add_adapter(struct i2c_adapter *adapter)
>  {
> -	int	id, res = 0;
> -
> -retry:
> -	if (idr_pre_get(&i2c_adapter_idr, GFP_KERNEL) == 0)
> -		return -ENOMEM;
> +	int res;

I'd vote for using 'id' as the variable name here. Feels more logical to
me and you are using 'id' in the other block, too.

> @@ -984,33 +975,19 @@ EXPORT_SYMBOL(i2c_add_adapter);
>  int i2c_add_numbered_adapter(struct i2c_adapter *adap)
>  {
>  	int	id;
> -	int	status;
>  
>  	if (adap->nr == -1) /* -1 means dynamically assign bus id */
>  		return i2c_add_adapter(adap);
>  	if (adap->nr & ~MAX_IDR_MASK)
>  		return -EINVAL;
>  
> -retry:
> -	if (idr_pre_get(&i2c_adapter_idr, GFP_KERNEL) == 0)
> -		return -ENOMEM;
> -
>  	mutex_lock(&core_lock);
> -	/* "above" here means "above or equal to", sigh;
> -	 * we need the "equal to" result to force the result
> -	 */
> -	status = idr_get_new_above(&i2c_adapter_idr, adap, adap->nr, &id);
> -	if (status == 0 && id != adap->nr) {
> -		status = -EBUSY;
> -		idr_remove(&i2c_adapter_idr, id);
> -	}
> +	id = idr_alloc(&i2c_adapter_idr, adap, adap->nr, adap->nr + 1,
> +		       GFP_KERNEL);
>  	mutex_unlock(&core_lock);
> -	if (status == -EAGAIN)
> -		goto retry;
> -
> -	if (status == 0)
> -		status = i2c_register_adapter(adap);
> -	return status;
> +	if (id < 0)
> +		return id == -ENOSPC ? -EBUSY : id;
> +	return i2c_register_adapter(adap);

Add an empty line before the return statement?

Thanks,

   Wolfram

