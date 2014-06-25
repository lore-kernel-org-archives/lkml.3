Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210AbaFYJHA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 05:07:00 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:43665 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753893AbaFYJG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 05:06:58 -0400
Date: Wed, 25 Jun 2014 17:06:46 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stephan Mueller <smueller@chronox.de>
Cc: kbuild test robot <fengguang.wu@intel.com>, kbuild@01.org,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH] Potential NULL pointer deference in drbg_ctr_df
Message-ID: <20140625090646.GB8727@gondor.apana.org.au>
References: <20140620202418.GZ5015@mwanda>
 <4892293.kf6KiPx6BS@myon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4892293.kf6KiPx6BS@myon.chronox.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 21, 2014 at 02:26:29PM +0200, Stephan Mueller wrote:
> The handling of additional input data / personalization string data may
> be subject to a NULL pointer deference for the CTR DRBG. The
> caller-provided data may be NULL which must be caught by the DRBG.
> 
> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> Signed-off-by: Stephan Mueller <smueller@chronox.de>
> ---
>  crypto/drbg.c | 23 +++++++++++++----------
>  1 file changed, 13 insertions(+), 10 deletions(-)
> 
> diff --git a/crypto/drbg.c b/crypto/drbg.c
> index faaa2ce..8e7c302 100644
> --- a/crypto/drbg.c
> +++ b/crypto/drbg.c
> @@ -513,17 +513,20 @@ static int drbg_ctr_df(struct drbg_state *drbg,
>  	drbg_string_fill(&S2, L_N, sizeof(L_N));
>  	drbg_string_fill(&S4, pad, padlen);
>  	S1.next = &S2;
> -	S2.next = addtl;
>  
> -	/*
> -	 * splice in addtl between S2 and S4 -- we place S4 at the end of the
> -	 * input data chain
> -	 */
> -	tempstr = addtl;
> -	for (; NULL != tempstr; tempstr = tempstr->next)
> -		if (NULL == tempstr->next)
> -			break;
> -	tempstr->next = &S4;
> +	if (NULL == addtl) {
> +		S2.next = &S4;
> +	} else {
> +		/*
> +		 * splice in addtl between S2 and S4 -- we place S4 at the end
> +		 * of the input data chain
> +		 */
> +		S2.next = addtl;
> +		tempstr = addtl;
> +		while (tempstr->next)
> +			tempstr = tempstr->next;
> +		tempstr->next = &S4;

You've still got exactly the same NULL dereference.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
