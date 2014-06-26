Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757676AbaFZLdg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 07:33:36 -0400
Received: from mail.eperm.de ([89.247.134.16]:52844 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756962AbaFZLdf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 07:33:35 -0400
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: kbuild test robot <fengguang.wu@intel.com>, kbuild@01.org,
        linux-kernel@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Rafael Aquini <aquini@redhat.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH v2] DRBG: simplify ordering of linked list in drbg_ctr_df
Date: Thu, 26 Jun 2014 13:33 +0200
Message-ID: <1735536.DnufTVyFaF@tauon>
User-Agent: KMail/4.12.5 (Linux/3.14.4-200.fc20.x86_64; KDE/4.12.5; x86_64; ; )
In-Reply-To: <20140626064542.GA17761@gondor.apana.org.au>
References: <5069712.neqH4zuI9U@myon.chronox.de> <20140625090828.GD8727@gondor.apana.org.au> <20140626064542.GA17761@gondor.apana.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 26. Juni 2014, 14:45:42 schrieb Herbert Xu:

Hi Herbert,

>On Wed, Jun 25, 2014 at 05:08:28PM +0800, Herbert Xu wrote:
>> On Mon, Jun 23, 2014 at 09:11:29AM +0200, Stephan Mueller wrote:
>> > As reported by a static code analyzer, the code for the ordering of
>> > the linked list can be simplified.
>> > 
>> > Reported-by: kbuild test robot <fengguang.wu@intel.com>
>> > Signed-off-by: Stephan Mueller <smueller@chronox.de>
>> > ---
>> > 
>> >  crypto/drbg.c | 10 +++++-----
>> >  1 file changed, 5 insertions(+), 5 deletions(-)
>> > 
>> > diff --git a/crypto/drbg.c b/crypto/drbg.c
>> > index faaa2ce..99fa8f8 100644
>> > --- a/crypto/drbg.c
>> > +++ b/crypto/drbg.c
>> > @@ -516,13 +516,13 @@ static int drbg_ctr_df(struct drbg_state
>> > *drbg,
>> > 
>> >  	S2.next = addtl;
>> >  	
>> >  	/*
>> > 
>> > -	 * splice in addtl between S2 and S4 -- we place S4 at the end 
of
>> > the -	 * input data chain
>> > +	 * Splice in addtl between S2 and S4 -- we place S4 at the end
>> > +	 * of the input data chain. As this code is only triggered when
>> > +	 * addtl is not NULL, no NULL checks are necessary.
>> > 
>> >  	 */
>> >  	
>> >  	tempstr = addtl;
>> > 
>> > -	for (; NULL != tempstr; tempstr = tempstr->next)
>> > -		if (NULL == tempstr->next)
>> > -			break;
>> > +	while (tempstr->next)
>> > +		tempstr = tempstr->next;
>> > 
>> >  	tempstr->next = &S4;
>> 
>> This is still broken.
>
>OK I take that back.  As addtl is not NULL neither version will
>do a NULL derference.  But I will apply your cleanup patch anyway.

When I wrote my first patch considering the NULL pointer, I was already 
wondering why during my tests I did not observe any crasher. In case the 
NULL pointer dereference would have been real, it would need to have 
crashed when pulling random bytes via the kernel crypto API -- I have a 
test that iterates over all DRBG types, instantiates them and pulls up 
to 100,000 bytes.

If the NULL pointer dereference would have been real, the following call 
sequences triggered by normal kernel crypto API usage should have 
triggered it, because they all set addtl to NULL.

crypto_rng_get_bytes
--> drbg_kcapi_random with slen >0
--> drbg_generate_long(drbg, rdata, dlen, NULL);
--> drbg_generate(drbg, rdata, dlen, NULL);
--> drbg_ctr_generate(..., NULL)

And here, the following is only called when addtl is not NULL
--> drbg_ctr_update
--> drbg_ctr_df


Ciao
Stephan
