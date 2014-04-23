Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633AbaDWRUy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 13:20:54 -0400
Received: from mga09.intel.com ([134.134.136.24]:28922 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752092AbaDWRUv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 13:20:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,912,1389772800"; 
   d="scan'208";a="526376112"
Subject: Re: [PATCH 1/3] crypto: Fix potential leak in test_aead_speed() if
 aad_size is too big
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Christian Engelmayer <cengelma@gmx.at>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20140421204559.75b8aa71@spike>
References: <20140421204439.7999f1c6@spike>  <20140421204559.75b8aa71@spike>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Apr 2014 10:20:28 -0700
Message-ID: <1398273628.2970.53.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-04-21 at 20:45 +0200, Christian Engelmayer wrote:
> Fix a potential memory leak in the error handling of test_aead_speed(). In case
> the size check on the associate data length parameter fails, the function goes
> through the wrong exit label. Reported by Coverity - CID 1163870.
> 
> Signed-off-by: Christian Engelmayer <cengelma@gmx.at>

Acked.

Tim

> ---
>  crypto/tcrypt.c | 14 ++++++--------
>  1 file changed, 6 insertions(+), 8 deletions(-)
> 
> diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
> index 870be7b..1856d7f 100644
> --- a/crypto/tcrypt.c
> +++ b/crypto/tcrypt.c
> @@ -282,6 +282,11 @@ static void test_aead_speed(const char *algo, int enc, unsigned int sec,
>  	unsigned int *b_size;
>  	unsigned int iv_len;
>  
> +	if (aad_size >= PAGE_SIZE) {
> +		pr_err("associate data length (%u) too big\n", aad_size);
> +		return;
> +	}
> +
>  	if (enc == ENCRYPT)
>  		e = "encryption";
>  	else
> @@ -323,14 +328,7 @@ static void test_aead_speed(const char *algo, int enc, unsigned int sec,
>  		b_size = aead_sizes;
>  		do {
>  			assoc = axbuf[0];
> -
> -			if (aad_size < PAGE_SIZE)
> -				memset(assoc, 0xff, aad_size);
> -			else {
> -				pr_err("associate data length (%u) too big\n",
> -					aad_size);
> -				goto out_nosg;
> -			}
> +			memset(assoc, 0xff, aad_size);
>  			sg_init_one(&asg[0], assoc, aad_size);
>  
>  			if ((*keysize + *b_size) > TVMEMSIZE * PAGE_SIZE) {


