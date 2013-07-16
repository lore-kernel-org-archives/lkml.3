Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758602Ab3GPCg1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 22:36:27 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:43337 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754973Ab3GPCgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 22:36:25 -0400
Subject: Re: [PATCH] asymmetric keys: explicitly add the leading zero byte
 to encoded message
From: joeyli <jlee@suse.com>
To: rusty@rustcorp.com.au, dhowells@redhat.com, herbert@gondor.hengli.com.au,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        Randy Dunlap <rdunlap@xenotime.net>, Josh Boyer <jwboyer@redhat.com>
In-Reply-To: <1373598691-1504-1-git-send-email-jlee@suse.com>
References: <1373598691-1504-1-git-send-email-jlee@suse.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Jul 2013 10:36:18 +0800
Message-ID: <1373942178.6260.36.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all experts, 

Does there have any suggestions or comments for this patch to asymmetric
keys?


Thanks a lot!
Joey Lee

於 五，2013-07-12 於 11:11 +0800，Lee, Chun-Yi 提到：
> From: Chun-Yi Lee <jlee@suse.com>
> 
> Per PKCS1 spec, the EMSA-PKCS1-v1_5 encoded message is leading by 0x00 0x01 in
> its first 2 bytes. The leading zero byte is suppressed by MPI so we pass a
> pointer to the _preceding_ byte to RSA_verify() in original code, but it has
> risk for the byte is not zero because it's not in EM buffer's scope, neither
> RSA_verify() nor mpi_get_buffer() didn't take care the leading byte.
> 
> To avoid the risk, that's better we explicitly add the leading zero byte to EM
> for pass to RSA_verify(). This patch allocate a _EM buffer to capture the
> result from RSA_I2OSP(), then set the first byte to zero in EM and copy the
> remaining bytes from _EM.
> 
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Josh Boyer <jwboyer@redhat.com>
> Cc: Randy Dunlap <rdunlap@xenotime.net>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: David Howells <dhowells@redhat.com>
> Signed-off-by: Chun-Yi Lee <jlee@suse.com>
> ---
>  crypto/asymmetric_keys/rsa.c |   14 ++++++++++----
>  1 files changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/crypto/asymmetric_keys/rsa.c b/crypto/asymmetric_keys/rsa.c
> index ca1a4f3..7bc99d2 100644
> --- a/crypto/asymmetric_keys/rsa.c
> +++ b/crypto/asymmetric_keys/rsa.c
> @@ -303,6 +303,7 @@ static int RSA_verify_signature(const struct public_key *key,
>  	/* Variables as per RFC3447 sec 8.2.2 */
>  	const u8 *H = sig->digest;
>  	u8 *EM = NULL;
> +	u8 *_EM = NULL;
>  	MPI m = NULL;
>  	size_t k;
>  
> @@ -337,14 +338,19 @@ static int RSA_verify_signature(const struct public_key *key,
>  	/* (2c) Convert the message representative (m) to an encoded message
>  	 *      (EM) of length k octets.
>  	 *
> -	 *      NOTE!  The leading zero byte is suppressed by MPI, so we pass a
> -	 *      pointer to the _preceding_ byte to RSA_verify()!
> +	 *      NOTE!  The leading zero byte is suppressed by MPI, so we add it
> +	 *      back to EM before input to RSA_verify()!
>  	 */
> -	ret = RSA_I2OSP(m, k, &EM);
> +	ret = RSA_I2OSP(m, k, &_EM);
>  	if (ret < 0)
>  		goto error;
>  
> -	ret = RSA_verify(H, EM - 1, k, sig->digest_size,
> +	EM = kmalloc(k, GFP_KERNEL);
> +	memset(EM, 0, 1);
> +	memcpy(EM + 1, _EM, k-1);
> +	kfree(_EM);
> +
> +	ret = RSA_verify(H, EM, k, sig->digest_size,
>  			 RSA_ASN1_templates[sig->pkey_hash_algo].data,
>  			 RSA_ASN1_templates[sig->pkey_hash_algo].size);
>  


