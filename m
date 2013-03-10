Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751365Ab3CJAGy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 19:06:54 -0500
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:26505 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751161Ab3CJAGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 19:06:53 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18NzyepWfBfBRZkB6sasaa8bf6mdxOMExk=
Date: Sat, 9 Mar 2013 19:06:47 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: David Woodhouse <dwmw2@infradead.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-kernel@vger.kernel.org,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: memory leak and other oddness in pinctrl-mvebu.c
Message-ID: <20130310000647.GZ23237@titan.lakedaemon.net>
References: <1362758331.32099.121.camel@i7.infradead.org>
 <513AF783.6050906@gmail.com>
 <1362855725.3690.92.camel@shinybook.infradead.org>
 <20130309225333.GY23237@titan.lakedaemon.net>
 <1362872371.3690.106.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362872371.3690.106.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added LinusW, Gregory and Ezequiel to the email.  Guys, can you give
this a Tested-by before I apply (or Ack for LinusW)?

thx,

Jason.

On Sat, Mar 09, 2013 at 11:39:31PM +0000, David Woodhouse wrote:
> On Sat, 2013-03-09 at 17:53 -0500, Jason Cooper wrote:
> > > +     if (!nr_funcs)
> > 
> > shouldn't this be:
> > 
> >         if (nr_funcs <= 0)
> 
> Hm, no. But the loop should terminate if nr_funcs ever reaches zero,
> otherwise funcs->num_groups will be off the end of the original array:
> 
> diff --git a/drivers/pinctrl/mvebu/pinctrl-mvebu.c b/drivers/pinctrl/mvebu/pinctrl-mvebu.c
> index c689c04..8bbc607 100644
> --- a/drivers/pinctrl/mvebu/pinctrl-mvebu.c
> +++ b/drivers/pinctrl/mvebu/pinctrl-mvebu.c
> @@ -478,16 +478,21 @@ static struct pinctrl_ops mvebu_pinctrl_ops = {
>  	.dt_free_map = mvebu_pinctrl_dt_free_map,
>  };
>  
> -static int _add_function(struct mvebu_pinctrl_function *funcs, const char *name)
> +static int _add_function(struct mvebu_pinctrl_function *funcs, int nr_funcs,
> +			 const char *name)
>  {
> -	while (funcs->num_groups) {
> +	while (nr_funcs && funcs->num_groups) {
>  		/* function already there */
>  		if (strcmp(funcs->name, name) == 0) {
>  			funcs->num_groups++;
>  			return -EEXIST;
>  		}
>  		funcs++;
> +		nr_funcs--;
>  	}
> +	if (!nr_funcs)
> +		return -EOVERFLOW;
> +
>  	funcs->name = name;
>  	funcs->num_groups = 1;
>  	return 0;
> @@ -501,7 +506,7 @@ static int mvebu_pinctrl_build_functions(struct platform_device *pdev,
>  	int n, s;
>  
>  	/* we allocate functions for number of pins and hope
> -	 * there are less unique functions than pins available */
> +	 * there are fewer unique functions than pins available */
>  	funcs = devm_kzalloc(&pdev->dev, pctl->desc.npins *
>  			     sizeof(struct mvebu_pinctrl_function), GFP_KERNEL);
>  	if (!funcs)
> @@ -510,26 +515,27 @@ static int mvebu_pinctrl_build_functions(struct platform_device *pdev,
>  	for (n = 0; n < pctl->num_groups; n++) {
>  		struct mvebu_pinctrl_group *grp = &pctl->groups[n];
>  		for (s = 0; s < grp->num_settings; s++) {
> +			int ret;
> +
>  			/* skip unsupported settings on this variant */
>  			if (pctl->variant &&
>  			    !(pctl->variant & grp->settings[s].variant))
>  				continue;
>  
>  			/* check for unique functions and count groups */
> -			if (_add_function(funcs, grp->settings[s].name))
> +			ret = _add_function(funcs, pctl->desc.npins,
> +					    grp->settings[s].name);
> +			if (ret == -EOVERFLOW)
> +				dev_err(&pdev->dev,
> +					"More functions than pins(%d)\n",
> +					pctl->desc.npins);
> +			if (ret)
>  				continue;
>  
>  			num++;
>  		}
>  	}
>  
> -	/* with the number of unique functions and it's groups known,
> -	   reallocate functions and assign group names */
> -	funcs = krealloc(funcs, num * sizeof(struct mvebu_pinctrl_function),
> -			 GFP_KERNEL);
> -	if (!funcs)
> -		return -ENOMEM;
> -
>  	pctl->num_functions = num;
>  	pctl->functions = funcs;
>  
> 
> -- 
> dwmw2
> 


