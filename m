Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119Ab3IWQuA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 12:50:00 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:28229 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545Ab3IWQt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 12:49:56 -0400
X-AuditID: cbfec7f4-b7f0a6d000007b1b-43-524071321c81
Date: Mon, 23 Sep 2013 19:49:44 +0300
From: Phil Carmody <phil.carmody@partner.samsung.com>
To: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-crypto@vger.kernel.org, opensuse-kernel@opensuse.org,
        David Howells <dhowells@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Matthew Garrett <mjg59@srcf.uc>
Subject: Re: [PATCH V4 02/15] asymmetric keys: implement EMSA_PKCS1-v1_5-ENCODE
 in rsa
Message-id: <20130923164931.GD6772@samsung.com>
References: <1379206621-18639-1-git-send-email-jlee@suse.com>
 <1379206621-18639-3-git-send-email-jlee@suse.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
In-reply-to: <1379206621-18639-3-git-send-email-jlee@suse.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [106.210.244.193]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLLMWRmVeSWpSXmKPExsVy+t/xq7pGhQ5BBk0r+C3eNf1msVjefYTd
	4v69n0wWbQ9vMVpc3jWHzeJz7xFGiw89j9gsnm9Lt+hf2MvkwOmxc9Zddo9jJ1+yerzfd5XN
	49HiFkaPz5vkAlijuGxSUnMyy1KL9O0SuDJerlnGWLDZoWL3z5uMDYw7jboYOTkkBEwkHh56
	yAxhi0lcuLeerYuRi0NIYCmjxOHuyawQTiOTxKKTd5ggnPmMEpM/fWUHaWERUJX4s/4xK4jN
	JmAqMWXFNyYQW0RAR+Lj5pVg3cwCK5kkzl65A7ZDWCBCYvrBM2wgNq+AvsTaPz/AmoUECiV+
	vtrEChEXlPgx+R4LiM0soCWxfudxJghbWuLR3xlgizkF7CTmnO5iBLFFBVQkppzcxgYxR19i
	+rRFrBD/KEus2rGbaQKj8CwkY2chGTsLydgFjMyrGEVTS5MLipPScw31ihNzi0vz0vWS83M3
	MUKi6MsOxsXHrA4xCnAwKvHwXkxwCBJiTSwrrsw9xCjBwawkwns0GijEm5JYWZValB9fVJqT
	WnyIkYmDU6qBUdM2Sbp630TH1fbhDx4U17cIRFhcFzTom7lZ4p6l1bujVzYWH+mdnf2XgyXt
	4tQ+sSbfmq12LLk/hQWVk2+t7dt+6YoY766bWet+swpo2T22PryY36zw6YpPnEznmv2kihXe
	8GkXTl28OY/bXV+2VZNB6uzlaF9Ry4Nn38j1WtX7X/XIXPlTiaU4I9FQi7moOBEA2rB724AC	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 15, 2013 at 08:56:48AM +0800, Lee, Chun-Yi wrote:
> Implement EMSA_PKCS1-v1_5-ENCODE [RFC3447 sec 9.2] in rsa.c. It's the
> first step of signature generation operation (RSASSA-PKCS1-v1_5-SIGN).
> 
> This patch is temporary set emLen to pks->k, and temporary set EM to
> pks->S for debugging. We will replace the above values to real signature
> after implement RSASP1.
> 
> The naming of EMSA_PKCS1_v1_5_ENCODE and the variables used in this function
> accord PKCS#1 spec but not follow kernel naming convention, it useful when look
> at them with spec.
> 
> Reference: ftp://ftp.rsasecurity.com/pub/pkcs/pkcs-1v2/pkcs1ietffinal.txt
> Reference: http://www.emc.com/collateral/white-papers/h11300-pkcs-1v2-2-rsa-cryptography-standard-wp.pdf
> 
> V2:

You're now at V4.

> - Clean up naming of variable: replace _EM by EM, replace EM by EM_tmp.
> - Add comment to EMSA_PKCS1-v1_5-ENCODE function.
> 
> Cc: Pavel Machek <pavel@ucw.cz>
> Reviewed-by: Jiri Kosina <jkosina@suse.cz>
> Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
> ---
>  crypto/asymmetric_keys/rsa.c |  163 +++++++++++++++++++++++++++++++++++++++++-
>  include/crypto/public_key.h  |    2 +
>  2 files changed, 164 insertions(+), 1 deletions(-)
> 
> diff --git a/crypto/asymmetric_keys/rsa.c b/crypto/asymmetric_keys/rsa.c
> index 47f3be4..352ba45 100644
> --- a/crypto/asymmetric_keys/rsa.c
> +++ b/crypto/asymmetric_keys/rsa.c
> @@ -13,6 +13,7 @@
>  #include <linux/module.h>
>  #include <linux/kernel.h>
>  #include <linux/slab.h>
> +#include <crypto/hash.h>
>  #include "public_key.h"
>  #include "private_key.h"
>  
> @@ -152,6 +153,132 @@ static int RSA_I2OSP(MPI x, size_t xLen, u8 **_X)
>  }
>  
>  /*
> + * EMSA_PKCS1-v1_5-ENCODE [RFC3447 sec 9.2]
> + * @M: message to be signed, an octet string
> + * @emLen: intended length in octets of the encoded message
> + * @hash_algo: hash function (option)
> + * @hash: true means hash M, otherwise M is already a digest
> + * @EM: encoded message, an octet string of length emLen
> + *
> + * This function is a implementation of the EMSA-PKCS1-v1_5 encoding operation
> + * in RSA PKCS#1 spec. It used by the signautre generation operation of
> + * RSASSA-PKCS1-v1_5 to encode message M to encoded message EM.
> + *
> + * The variables used in this function accord PKCS#1 spec but not follow kernel
> + * naming convention, it useful when look at them with spec.
> + */
> +static int EMSA_PKCS1_v1_5_ENCODE(const u8 *M, size_t emLen,
> +		enum pkey_hash_algo hash_algo, const bool hash,
> +		u8 **EM, struct public_key_signature *pks)
> +{
> +	u8 *digest;
> +	struct crypto_shash *tfm;
> +	struct shash_desc *desc;
> +	size_t digest_size, desc_size;
> +	size_t tLen;
> +	u8 *T, *PS, *EM_tmp;
> +	int i, ret;
> +
> +	pr_info("EMSA_PKCS1_v1_5_ENCODE start\n");
> +
> +	if (!RSA_ASN1_templates[hash_algo].data)
> +		ret = -ENOTSUPP;

...

> +	else
> +		pks->pkey_hash_algo = hash_algo;
> +
> +	/* 1) Apply the hash function to the message M to produce a hash value H */
> +	tfm = crypto_alloc_shash(pkey_hash_algo[hash_algo], 0, 0);
> +	if (IS_ERR(tfm))
> +		return (PTR_ERR(tfm) == -ENOENT) ? -ENOPKG : PTR_ERR(tfm);
> +
> +	desc_size = crypto_shash_descsize(tfm) + sizeof(*desc);
> +	digest_size = crypto_shash_digestsize(tfm);
> +
> +	ret = -ENOMEM;

The earlier "ret = -ENOTSUPP;" is either unused because you return at the IS_ERR,
or unused because you overwrite it here. I'm a little disappointed that
the compiler didn't recognise that something was assigned to a value that 
is never used.

Phil

> +
> +	digest = kzalloc(digest_size + desc_size, GFP_KERNEL);
> +	if (!digest)
> +		goto error_digest;
> +	pks->digest = digest;
> +	pks->digest_size = digest_size;
> +
> +	if (hash) {
> +		desc = (void *) digest + digest_size;
> +		desc->tfm = tfm;
> +		desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
> +
> +		ret = crypto_shash_init(desc);
> +		if (ret < 0)
> +			goto error_shash;
> +		ret = crypto_shash_finup(desc, M, sizeof(M), pks->digest);
> +		if (ret < 0)
> +			goto error_shash;
> +	} else {
> +		memcpy(pks->digest, M, pks->digest_size);
> +		pks->digest_size = digest_size;
> +	}
> +	crypto_free_shash(tfm);
> +
> +	/* 2) Encode the algorithm ID for the hash function and the hash value into
> +	 * an ASN.1 value of type DigestInfo with the DER. Let T be the DER encoding of
> +	 * the DigestInfo value and let tLen be the length in octets of T.
> +	 */
> +	tLen = RSA_ASN1_templates[hash_algo].size + pks->digest_size;
> +	T = kmalloc(tLen, GFP_KERNEL);
> +	if (!T)
> +		goto error_T;
> +
> +	memcpy(T, RSA_ASN1_templates[hash_algo].data, RSA_ASN1_templates[hash_algo].size);
> +	memcpy(T + RSA_ASN1_templates[hash_algo].size, pks->digest, pks->digest_size);
> +
> +	/* 3) check If emLen < tLen + 11, output "intended encoded message length too short" */
> +	if (emLen < tLen + 11) {
> +		ret = -EINVAL;
> +		goto error_emLen;
> +	}
> +
> +	/* 4) Generate an octet string PS consisting of emLen - tLen - 3 octets with 0xff. */
> +	PS = kmalloc(emLen - tLen - 3, GFP_KERNEL);
> +	if (!PS)
> +		goto error_P;
> +
> +	for (i = 0; i < (emLen - tLen - 3); i++)
> +		PS[i] = 0xff;
> +
> +	/* 5) Concatenate PS, the DER encoding T, and other padding to form the encoded
> +	 * message EM as EM = 0x00 || 0x01 || PS || 0x00 || T
> +	 */
> +	EM_tmp = kmalloc(3 + emLen - tLen - 3 + tLen, GFP_KERNEL);
> +	if (!EM_tmp)
> +		goto error_EM;
> +
> +	EM_tmp[0] = 0x00;
> +	EM_tmp[1] = 0x01;
> +	memcpy(EM_tmp + 2, PS, emLen - tLen - 3);
> +	EM_tmp[2 + emLen - tLen - 3] = 0x00;
> +	memcpy(EM_tmp + 2 + emLen - tLen - 3 + 1, T, tLen);
> +
> +	*EM = EM_tmp;
> +
> +	kfree(PS);
> +	kfree(T);
> +
> +	return 0;
> +
> +error_EM:
> +	kfree(PS);
> +error_P:
> +error_emLen:
> +	kfree(T);
> +error_T:
> +error_shash:
> +	kfree(digest);
> +error_digest:
> +	crypto_free_shash(tfm);
> +	return ret;
> +}
> +
> +/*
>   * Perform the RSA signature verification.
>   * @H: Value of hash of data and metadata
>   * @EM: The computed signature value
> @@ -275,9 +402,43 @@ static struct public_key_signature *RSA_generate_signature(
>  		const struct private_key *key, u8 *M,
>  		enum pkey_hash_algo hash_algo, const bool hash)
>  {
> +	struct public_key_signature *pks;
> +	u8 *EM = NULL;
> +	size_t emLen;
> +	int ret;
> +
>  	pr_info("RSA_generate_signature start\n");
>  
> -	return 0;
> +	ret = -ENOMEM;
> +	pks = kzalloc(sizeof(*pks), GFP_KERNEL);
> +	if (!pks)
> +		goto error_no_pks;
> +
> +	/* 1): EMSA-PKCS1-v1_5 encoding: */
> +	/* Use the private key modulus size to be EM length */
> +	emLen = mpi_get_nbits(key->rsa.n);
> +	emLen = (emLen + 7) / 8;
> +
> +	ret = EMSA_PKCS1_v1_5_ENCODE(M, emLen, hash_algo, hash, &EM, pks);
> +	if (ret < 0)
> +		goto error_v1_5_encode;
> +
> +	/* TODO 2): m = OS2IP (EM) */
> +
> +	/* TODO 3): s = RSASP1 (K, m) */
> +
> +	/* TODO 4): S = I2OSP (s, k) */
> +
> +	/* TODO: signature S to a u8* S or set to sig->rsa.s? */
> +	pks->S = EM;            /* TODO: temporary set S to EM */
> +
> +	return pks;
> +
> +error_v1_5_encode:
> +	kfree(pks);
> +error_no_pks:
> +	pr_info("<==%s() = %d\n", __func__, ret);
> +	return ERR_PTR(ret);
>  }
>  
>  const struct public_key_algorithm RSA_public_key_algorithm = {
> diff --git a/include/crypto/public_key.h b/include/crypto/public_key.h
> index d44b29f..1cdf457 100644
> --- a/include/crypto/public_key.h
> +++ b/include/crypto/public_key.h
> @@ -110,6 +110,8 @@ extern void public_key_destroy(void *payload);
>  struct public_key_signature {
>  	u8 *digest;
>  	u8 digest_size;			/* Number of bytes in digest */
> +	u8 *S;				/* signature S of length k octets */
> +	size_t k;			/* length k of signature S */
>  	u8 nr_mpi;			/* Occupancy of mpi[] */
>  	enum pkey_hash_algo pkey_hash_algo : 8;
>  	union {
> -- 
> 1.6.0.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
