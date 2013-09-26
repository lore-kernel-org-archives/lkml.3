Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755679Ab3IZHI0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 03:08:26 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:39300 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755574Ab3IZHIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 03:08:24 -0400
Subject: Re: [PATCH V4 02/15] asymmetric keys: implement
 EMSA_PKCS1-v1_5-ENCODE in rsa
From: joeyli <jlee@suse.com>
To: Phil Carmody <phil.carmody@partner.samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-crypto@vger.kernel.org, opensuse-kernel@opensuse.org,
        David Howells <dhowells@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Matthew Garrett <mjg59@srcf.uc>
In-Reply-To: <20130923164931.GD6772@samsung.com>
References: <1379206621-18639-1-git-send-email-jlee@suse.com>
	 <1379206621-18639-3-git-send-email-jlee@suse.com>
	 <20130923164931.GD6772@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 Sep 2013 15:08:30 +0800
Message-ID: <1380179310.32302.58.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Phil, 

First! Thanks for your time to review my patch!

於 一，2013-09-23 於 19:49 +0300，Phil Carmody 提到：
> On Sun, Sep 15, 2013 at 08:56:48AM +0800, Lee, Chun-Yi wrote:
> > Implement EMSA_PKCS1-v1_5-ENCODE [RFC3447 sec 9.2] in rsa.c. It's the
> > first step of signature generation operation (RSASSA-PKCS1-v1_5-SIGN).
> > 
> > This patch is temporary set emLen to pks->k, and temporary set EM to
> > pks->S for debugging. We will replace the above values to real signature
> > after implement RSASP1.
> > 
> > The naming of EMSA_PKCS1_v1_5_ENCODE and the variables used in this function
> > accord PKCS#1 spec but not follow kernel naming convention, it useful when look
> > at them with spec.
> > 
> > Reference: ftp://ftp.rsasecurity.com/pub/pkcs/pkcs-1v2/pkcs1ietffinal.txt
> > Reference: http://www.emc.com/collateral/white-papers/h11300-pkcs-1v2-2-rsa-cryptography-standard-wp.pdf
> > 
> > V2:
> 
> You're now at V4.

The V4 is for whole patchset, I didn't do any modify in this patch in
this version.
The version define maybe confuse between separate and whole patchset, I
will avoid it.

> 
> > - Clean up naming of variable: replace _EM by EM, replace EM by EM_tmp.
> > - Add comment to EMSA_PKCS1-v1_5-ENCODE function.
> > 
> > Cc: Pavel Machek <pavel@ucw.cz>
> > Reviewed-by: Jiri Kosina <jkosina@suse.cz>
> > Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
> > ---
> >  crypto/asymmetric_keys/rsa.c |  163 +++++++++++++++++++++++++++++++++++++++++-
> >  include/crypto/public_key.h  |    2 +
> >  2 files changed, 164 insertions(+), 1 deletions(-)
> > 
> > diff --git a/crypto/asymmetric_keys/rsa.c b/crypto/asymmetric_keys/rsa.c
> > index 47f3be4..352ba45 100644
> > --- a/crypto/asymmetric_keys/rsa.c
> > +++ b/crypto/asymmetric_keys/rsa.c
> > @@ -13,6 +13,7 @@
> >  #include <linux/module.h>
> >  #include <linux/kernel.h>
> >  #include <linux/slab.h>
> > +#include <crypto/hash.h>
> >  #include "public_key.h"
> >  #include "private_key.h"
> >  
> > @@ -152,6 +153,132 @@ static int RSA_I2OSP(MPI x, size_t xLen, u8 **_X)
> >  }
> >  
> >  /*
> > + * EMSA_PKCS1-v1_5-ENCODE [RFC3447 sec 9.2]
> > + * @M: message to be signed, an octet string
> > + * @emLen: intended length in octets of the encoded message
> > + * @hash_algo: hash function (option)
> > + * @hash: true means hash M, otherwise M is already a digest
> > + * @EM: encoded message, an octet string of length emLen
> > + *
> > + * This function is a implementation of the EMSA-PKCS1-v1_5 encoding operation
> > + * in RSA PKCS#1 spec. It used by the signautre generation operation of
> > + * RSASSA-PKCS1-v1_5 to encode message M to encoded message EM.
> > + *
> > + * The variables used in this function accord PKCS#1 spec but not follow kernel
> > + * naming convention, it useful when look at them with spec.
> > + */
> > +static int EMSA_PKCS1_v1_5_ENCODE(const u8 *M, size_t emLen,
> > +		enum pkey_hash_algo hash_algo, const bool hash,
> > +		u8 **EM, struct public_key_signature *pks)
> > +{
> > +	u8 *digest;
> > +	struct crypto_shash *tfm;
> > +	struct shash_desc *desc;
> > +	size_t digest_size, desc_size;
> > +	size_t tLen;
> > +	u8 *T, *PS, *EM_tmp;
> > +	int i, ret;
> > +
> > +	pr_info("EMSA_PKCS1_v1_5_ENCODE start\n");
> > +
> > +	if (!RSA_ASN1_templates[hash_algo].data)
> > +		ret = -ENOTSUPP;
> 
> ...
> 
> > +	else
> > +		pks->pkey_hash_algo = hash_algo;
> > +
> > +	/* 1) Apply the hash function to the message M to produce a hash value H */
> > +	tfm = crypto_alloc_shash(pkey_hash_algo[hash_algo], 0, 0);
> > +	if (IS_ERR(tfm))
> > +		return (PTR_ERR(tfm) == -ENOENT) ? -ENOPKG : PTR_ERR(tfm);
> > +
> > +	desc_size = crypto_shash_descsize(tfm) + sizeof(*desc);
> > +	digest_size = crypto_shash_digestsize(tfm);
> > +
> > +	ret = -ENOMEM;
> 
> The earlier "ret = -ENOTSUPP;" is either unused because you return at the IS_ERR,
> or unused because you overwrite it here. I'm a little disappointed that
> the compiler didn't recognise that something was assigned to a value that 
> is never used.
> 
> Phil

Yes, Dmitry also pointed out this issue, I should not go on the hash
process if the hash algorithm didn't support.

I will change fix this problem in next version. 


Thanks a lot!
Joey Lee

