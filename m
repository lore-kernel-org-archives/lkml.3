Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891AbaFZGqG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 02:46:06 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:57306 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790AbaFZGqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 02:46:04 -0400
Date: Thu, 26 Jun 2014 14:45:42 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stephan Mueller <smueller@chronox.de>
Cc: kbuild test robot <fengguang.wu@intel.com>, kbuild@01.org,
        linux-kernel@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Rafael Aquini <aquini@redhat.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH v2] DRBG: simplify ordering of linked list in drbg_ctr_df
Message-ID: <20140626064542.GA17761@gondor.apana.org.au>
References: <5069712.neqH4zuI9U@myon.chronox.de>
 <280704396.67z02n3FAf@myon.chronox.de>
 <20140625090828.GD8727@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140625090828.GD8727@gondor.apana.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 05:08:28PM +0800, Herbert Xu wrote:
> On Mon, Jun 23, 2014 at 09:11:29AM +0200, Stephan Mueller wrote:
> > As reported by a static code analyzer, the code for the ordering of
> > the linked list can be simplified.
> > 
> > Reported-by: kbuild test robot <fengguang.wu@intel.com>
> > Signed-off-by: Stephan Mueller <smueller@chronox.de>
> > ---
> >  crypto/drbg.c | 10 +++++-----
> >  1 file changed, 5 insertions(+), 5 deletions(-)
> > 
> > diff --git a/crypto/drbg.c b/crypto/drbg.c
> > index faaa2ce..99fa8f8 100644
> > --- a/crypto/drbg.c
> > +++ b/crypto/drbg.c
> > @@ -516,13 +516,13 @@ static int drbg_ctr_df(struct drbg_state *drbg,
> >  	S2.next = addtl;
> >  
> >  	/*
> > -	 * splice in addtl between S2 and S4 -- we place S4 at the end of the
> > -	 * input data chain
> > +	 * Splice in addtl between S2 and S4 -- we place S4 at the end
> > +	 * of the input data chain. As this code is only triggered when
> > +	 * addtl is not NULL, no NULL checks are necessary.
> >  	 */
> >  	tempstr = addtl;
> > -	for (; NULL != tempstr; tempstr = tempstr->next)
> > -		if (NULL == tempstr->next)
> > -			break;
> > +	while (tempstr->next)
> > +		tempstr = tempstr->next;
> >  	tempstr->next = &S4;
> 
> This is still broken.

OK I take that back.  As addtl is not NULL neither version will
do a NULL derference.  But I will apply your cleanup patch anyway.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
