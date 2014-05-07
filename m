Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928AbaEGGzw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 02:55:52 -0400
Received: from mga03.intel.com ([143.182.124.21]:26402 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753468AbaEGGzv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 02:55:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1001,1389772800"; 
   d="scan'208";a="428711213"
Message-ID: <1399445747.2677.4.camel@smile.fi.intel.com>
Subject: Re: [PATCH] staging: rtl8712: fix potential leak in
 r871x_wx_set_enc_ext()
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Christian Engelmayer <cengelma@gmx.at>
Cc: devel@driverdev.osuosl.org, Larry.Finger@lwfinger.net,
        florian.c.schilhabel@googlemail.com, gregkh@linuxfoundation.org,
        linuxgeek@gmail.com, paul.gortmaker@windriver.com,
        linux-kernel@vger.kernel.org
Date: Wed, 07 May 2014 09:55:47 +0300
In-Reply-To: <20140501114500.756b95d0@spike>
References: <20140501114500.756b95d0@spike>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-05-01 at 11:45 +0200, Christian Engelmayer wrote:
> Fix a potential leak in the error path of r871x_wx_set_enc_ext(). In case the
> requested algorithm is not supported by the driver, the function returns
> without freeing the already allocated 'param' struct. Move the input
> verification to the beginning of the function so that the direct return is
> safe. Detected by Coverity - CID 144373.
> 


One comment below.


> Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
> ---
> Compile tested and applies against branch staging-next of tree
> git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
> ---
>  drivers/staging/rtl8712/rtl871x_ioctl_linux.c | 16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
> index 23d539d..1eca992 100644
> --- a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
> +++ b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
> @@ -1801,13 +1801,6 @@ static int r871x_wx_set_enc_ext(struct net_device *dev,
>  	u32 param_len;
>  	int ret = 0;
>  
> -	param_len = sizeof(struct ieee_param) + pext->key_len;
> -	param = (struct ieee_param *)_malloc(param_len);
> -	if (param == NULL)
> -		return -ENOMEM;
> -	memset(param, 0, param_len);
> -	param->cmd = IEEE_CMD_SET_ENCRYPTION;
> -	memset(param->sta_addr, 0xff, ETH_ALEN);
>  	switch (pext->alg) {
>  	case IW_ENCODE_ALG_NONE:
>  		alg_name = "none";
> @@ -1824,6 +1817,15 @@ static int r871x_wx_set_enc_ext(struct net_device *dev,
>  	default:
>  		return -EINVAL;
>  	}
> +
> +	param_len = sizeof(struct ieee_param) + pext->key_len;
> +	param = (struct ieee_param *)_malloc(param_len);

While you are here could you substitute _malloc by kzalloc and remove
explicit casting and memset?

> +	if (param == NULL)
> +		return -ENOMEM;
> +	memset(param, 0, param_len);
> +	param->cmd = IEEE_CMD_SET_ENCRYPTION;
> +	memset(param->sta_addr, 0xff, ETH_ALEN);
> +
>  	strncpy((char *)param->u.crypt.alg, alg_name, IEEE_CRYPT_ALG_NAME_LEN);
>  	if (pext->ext_flags & IW_ENCODE_EXT_GROUP_KEY)
>  		param->u.crypt.set_tx = 0;


-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy

