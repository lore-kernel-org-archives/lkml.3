Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759927AbaEMLrj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 07:47:39 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:53521 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752985AbaEMLri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 07:47:38 -0400
Date: Tue, 13 May 2014 19:47:31 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Himangi Saraogi <himangi774@gmail.com>
Cc: Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
        julia.lawall@lip6.fr
Subject: Re: [PATCH] char: Introduce the use of the managed version of kzalloc
Message-ID: <20140513114731.GC22078@gondor.apana.org.au>
References: <20140510184859.GA6818@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140510184859.GA6818@himangi-Dell>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 11, 2014 at 12:19:00AM +0530, Himangi Saraogi wrote:
> This patch moves data allocated using kzalloc to managed data allocated
> using devm_kzalloc and cleans now unnecessary kfrees in probe and remove
> functions. The NULL assignment to np->units is removed as there is no
> interaction between this field and sun4v_hvapi_unregister. Also, the
> labels out_free_units and out_free are removed as they are no longer
> required.
> 
> The following Coccinelle semantic patch was used for making the change:
> 
> @platform@
> identifier p, probefn, removefn;
> @@
> struct platform_driver p = {
>   .probe = probefn,
>   .remove = removefn,
> };
> 
> @prb@
> identifier platform.probefn, pdev;
> expression e, e1, e2;
> @@
> probefn(struct platform_device *pdev, ...) {
>   <+...
> - e = kzalloc(e1, e2)
> + e = devm_kzalloc(&pdev->dev, e1, e2)
>   ...
> ?-kfree(e);
>   ...+>
> }
> 
> @rem depends on prb@
> identifier platform.removefn;
> expression e;
> @@
> removefn(...) {
>   <...
> - kfree(e);
>   ...>
> }
> 
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> ---
> I would like to know if removing the NULL assignment is OK as it may be
> used for security to prevent it from being read before reinitialization.

Looks good to me.  Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
