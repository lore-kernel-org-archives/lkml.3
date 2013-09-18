Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752427Ab3IRJHi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 05:07:38 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:53521 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386Ab3IRJHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 05:07:35 -0400
Subject: Re: [PATCH V4 02/15] asymmetric keys: implement
 EMSA_PKCS1-v1_5-ENCODE in rsa
From: joeyli <jlee@suse.com>
To: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-crypto@vger.kernel.org,
        opensuse-kernel@opensuse.org, David Howells <dhowells@redhat.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Josh Boyer <jwboyer@redhat.com>,
        Vojtech Pavlik <vojtech@suse.cz>,
        Matt Fleming <matt.fleming@intel.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Greg KH <gregkh@linuxfoundation.org>, JKosina@suse.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        Gary Lin <GLin@suse.com>, Vivek Goyal <vgoyal@redhat.com>
In-Reply-To: <CACE9dm-7HKz4VFR1bNTTFd-YpYhnkNVwiW81iXSJZbqjUTBR_Q@mail.gmail.com>
References: <1379206621-18639-1-git-send-email-jlee@suse.com>
	 <1379206621-18639-3-git-send-email-jlee@suse.com>
	 <CACE9dm-7HKz4VFR1bNTTFd-YpYhnkNVwiW81iXSJZbqjUTBR_Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Sep 2013 04:08:00 -0500
Message-ID: <1379495280.21947.311.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry, 

First, thanks for your time to review my patches!

於 二，2013-09-17 於 16:51 -0500，Dmitry Kasatkin 提到：
> Hello,
> 
> 
> On Sat, Sep 14, 2013 at 7:56 PM, Lee, Chun-Yi <joeyli.kernel@gmail.com> wrote:
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
> > +               enum pkey_hash_algo hash_algo, const bool hash,
> > +               u8 **EM, struct public_key_signature *pks)
> > +{
> > +       u8 *digest;
> > +       struct crypto_shash *tfm;
> > +       struct shash_desc *desc;
> > +       size_t digest_size, desc_size;
> > +       size_t tLen;
> > +       u8 *T, *PS, *EM_tmp;
> > +       int i, ret;
> > +
> > +       pr_info("EMSA_PKCS1_v1_5_ENCODE start\n");
> > +
> > +       if (!RSA_ASN1_templates[hash_algo].data)
> 
> What about checking hash_algo against PKEY_HASH__LAST, or it relies on
> the caller?
> 

Yes, check PKEY_HASH__LAST is more easy and clear, I will change it.
Thanks!

> 
> > +               ret = -ENOTSUPP;
> > +       else
> > +               pks->pkey_hash_algo = hash_algo;
> > +
> > +       /* 1) Apply the hash function to the message M to produce a hash value H */
> > +       tfm = crypto_alloc_shash(pkey_hash_algo[hash_algo], 0, 0);
> > +       if (IS_ERR(tfm))
> > +               return (PTR_ERR(tfm) == -ENOENT) ? -ENOPKG : PTR_ERR(tfm);
> > +
> > +       desc_size = crypto_shash_descsize(tfm) + sizeof(*desc);
> > +       digest_size = crypto_shash_digestsize(tfm);
> > +
> > +       ret = -ENOMEM;
> > +
> > +       digest = kzalloc(digest_size + desc_size, GFP_KERNEL);
> > +       if (!digest)
> > +               goto error_digest;
> > +       pks->digest = digest;
> > +       pks->digest_size = digest_size;
> > +
> 
> Ok. You allocated tfm to get hash size, right?
> 
> But why do you allocate descriptor even it might not be needed?
> 

You are right, I should skip the code of allocate descriptor when the
hash is supported. I will modified it.
Thanks!

> > +       if (hash) {
> > +               desc = (void *) digest + digest_size;
> > +               desc->tfm = tfm;
> > +               desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
> > +
> > +               ret = crypto_shash_init(desc);
> > +               if (ret < 0)
> > +                       goto error_shash;
> > +               ret = crypto_shash_finup(desc, M, sizeof(M), pks->digest);
> 
> This is I completely fail to understand... You expect sizeof(M) to be
> the message length?????
> Have you ever tested it?
> 

Sigh!
I just checked my test program for this code path, this stupid problem
causes by my test program doesn't feed the right hash result that should
used to verify signature. So, I didn't capture this bug.

And, the hibernate signature check mechanism doesn't run into this code
path because the hash generation is done by hibernate code but not in
here. So, I also didn't find this problem when running hibernate check.

Appreciate for your point out! I just fix it in next patch version.

> > +               if (ret < 0)
> > +                       goto error_shash;
> > +       } else {
> > +               memcpy(pks->digest, M, pks->digest_size);
> > +               pks->digest_size = digest_size;
> > +       }
> 
> Does caller use pks->digest and pks->digest_size after return?
> I think it needs encoded value, not the hash...
> So why do you pass pks?
> 

I put the signature MPI to pks->rsa.s, and put the encoded signature to
pks->S. So caller can grab encoded signature.

I also pass the pks->digest and pks->digest_size to caller for
reference. Then caller can simply feed this pks to
RSA_verify_signature() for verify the signature result, don't need
generate hash again.

> 
> 
> > +       crypto_free_shash(tfm);
> > +
> > +       /* 2) Encode the algorithm ID for the hash function and the hash value into
> > +        * an ASN.1 value of type DigestInfo with the DER. Let T be the DER encoding of
> > +        * the DigestInfo value and let tLen be the length in octets of T.
> > +        */
> > +       tLen = RSA_ASN1_templates[hash_algo].size + pks->digest_size;
> > +       T = kmalloc(tLen, GFP_KERNEL);
> > +       if (!T)
> > +               goto error_T;
> > +
> 
> Why do you need T and PS memory allocations at all?
> You need only EM_tmp allocation and copy directly to the destination...
> 

OK, I will change the code to allocate T and PS size in EM_tmp.

> 
> > +       memcpy(T, RSA_ASN1_templates[hash_algo].data, RSA_ASN1_templates[hash_algo].size);
> > +       memcpy(T + RSA_ASN1_templates[hash_algo].size, pks->digest, pks->digest_size);
> > +
> > +       /* 3) check If emLen < tLen + 11, output "intended encoded message length too short" */
> > +       if (emLen < tLen + 11) {
> > +               ret = -EINVAL;
> > +               goto error_emLen;
> > +       }
> > +
> > +       /* 4) Generate an octet string PS consisting of emLen - tLen - 3 octets with 0xff. */
> > +       PS = kmalloc(emLen - tLen - 3, GFP_KERNEL);
> > +       if (!PS)
> > +               goto error_P;
> > +
> 
> ditto

OK, I will allocate PS with EM_tmp.
Thanks!

> 
> > +       for (i = 0; i < (emLen - tLen - 3); i++)
> > +               PS[i] = 0xff;
> > +
> > +       /* 5) Concatenate PS, the DER encoding T, and other padding to form the encoded
> > +        * message EM as EM = 0x00 || 0x01 || PS || 0x00 || T
> > +        */
> > +       EM_tmp = kmalloc(3 + emLen - tLen - 3 + tLen, GFP_KERNEL);
> > +       if (!EM_tmp)
> > +               goto error_EM;
> > +
> > +       EM_tmp[0] = 0x00;
> > +       EM_tmp[1] = 0x01;
> > +       memcpy(EM_tmp + 2, PS, emLen - tLen - 3);
> > +       EM_tmp[2 + emLen - tLen - 3] = 0x00;
> > +       memcpy(EM_tmp + 2 + emLen - tLen - 3 + 1, T, tLen);
> > +
> > +       *EM = EM_tmp;
> > +
> > +       kfree(PS);
> > +       kfree(T);
> 
> get rid of it...
> 

OK!

> 
> - Dmitry
> 
> > +
> > +       return 0;
> > +
> > +error_EM:
> > +       kfree(PS);
> > +error_P:
> > +error_emLen:
> > +       kfree(T);
> > +error_T:
> > +error_shash:
> > +       kfree(digest);
> > +error_digest:
> > +       crypto_free_shash(tfm);
> > +       return ret;
> > +}
> > +
> > +/*
> >   * Perform the RSA signature verification.
> >   * @H: Value of hash of data and metadata
> >   * @EM: The computed signature value
> > @@ -275,9 +402,43 @@ static struct public_key_signature *RSA_generate_signature(
> >                 const struct private_key *key, u8 *M,
> >                 enum pkey_hash_algo hash_algo, const bool hash)
> >  {
> > +       struct public_key_signature *pks;
> > +       u8 *EM = NULL;
> > +       size_t emLen;
> > +       int ret;
> > +
> >         pr_info("RSA_generate_signature start\n");
> >
> > -       return 0;
> > +       ret = -ENOMEM;
> > +       pks = kzalloc(sizeof(*pks), GFP_KERNEL);
> > +       if (!pks)
> > +               goto error_no_pks;
> > +
> > +       /* 1): EMSA-PKCS1-v1_5 encoding: */
> > +       /* Use the private key modulus size to be EM length */
> > +       emLen = mpi_get_nbits(key->rsa.n);
> > +       emLen = (emLen + 7) / 8;
> > +
> > +       ret = EMSA_PKCS1_v1_5_ENCODE(M, emLen, hash_algo, hash, &EM, pks);
> > +       if (ret < 0)
> > +               goto error_v1_5_encode;
> > +
> > +       /* TODO 2): m = OS2IP (EM) */
> > +
> > +       /* TODO 3): s = RSASP1 (K, m) */
> > +
> > +       /* TODO 4): S = I2OSP (s, k) */
> > +
> > +       /* TODO: signature S to a u8* S or set to sig->rsa.s? */
> > +       pks->S = EM;            /* TODO: temporary set S to EM */
> > +
> > +       return pks;
> > +
> > +error_v1_5_encode:
> > +       kfree(pks);
> > +error_no_pks:
> > +       pr_info("<==%s() = %d\n", __func__, ret);
> > +       return ERR_PTR(ret);
> >  }
> >
> >  const struct public_key_algorithm RSA_public_key_algorithm = {
> > diff --git a/include/crypto/public_key.h b/include/crypto/public_key.h
> > index d44b29f..1cdf457 100644
> > --- a/include/crypto/public_key.h
> > +++ b/include/crypto/public_key.h
> > @@ -110,6 +110,8 @@ extern void public_key_destroy(void *payload);
> >  struct public_key_signature {
> >         u8 *digest;
> >         u8 digest_size;                 /* Number of bytes in digest */
> > +       u8 *S;                          /* signature S of length k octets */
> > +       size_t k;                       /* length k of signature S */
> >         u8 nr_mpi;                      /* Occupancy of mpi[] */
> >         enum pkey_hash_algo pkey_hash_algo : 8;
> >         union {
> > --
> > 1.6.0.2
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 

Thanks a lot!
Joey Lee

