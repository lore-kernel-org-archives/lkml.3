Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117Ab3BFGDM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 01:03:12 -0500
Received: from smtp.nue.novell.com ([195.135.221.5]:37623 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252Ab3BFGDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 01:03:09 -0500
Subject: Re: [PATCH] X.509: Support parse long form of length octets in
 Authority Key Identifier
From: joeyli <jlee@suse.com>
To: rusty@rustcorp.com.au
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
        Josh Boyer <jwboyer@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>
In-Reply-To: <1360127321-8053-1-git-send-email-jlee@suse.com>
References: <1360127321-8053-1-git-send-email-jlee@suse.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Feb 2013 13:59:08 +0800
Message-ID: <1360130348.15258.85.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 三，2013-02-06 於 13:08 +0800，Lee, Chun-Yi 提到：
> Per X.509 spec in 4.2.1.1 section, the structure of Authority Key
> Identifier Exception is:
            ^^^^^^^^^^ Extension

Sorry for my typo, I will send patch again.

Thanks
Joey Lee

> 
>    AuthorityKeyIdentifier ::= SEQUENCE {
>       keyIdentifier             [0] KeyIdentifier           OPTIONAL,
>       authorityCertIssuer       [1] GeneralNames            OPTIONAL,
>       authorityCertSerialNumber [2] CertificateSerialNumber OPTIONAL  }
> 
>    KeyIdentifier ::= OCTET STRING
> 
> When a certificate also provides
> authorityCertIssuer and authorityCertSerialNumber then the length of
> AuthorityKeyIdentifier SEQUENCE is likely to long form format.
> e.g.
>    The example certificate demos/tunala/A-server.pem in openssl source:
> 
> X509v3 Authority Key Identifier:
>     keyid:49:FB:45:72:12:C4:CC:E1:45:A1:D3:08:9E:95:C4:2C:6D:55:3F:17
>     DirName:/C=NZ/L=Wellington/O=Really Irresponsible Authorisation Authority (RIAA)/OU=Cert-stamping/CN=Jackov al-Trades/emailAddress=none@fake.domain
>     serial:00
> 
> Current parsing rule of OID_authorityKeyIdentifier only take care the
> short form format, it causes load certificate to modsign_keyring fail:
> 
> [   12.061147] X.509: Extension: 47
> [   12.075121] MODSIGN: Problem loading in-kernel X.509 certificate (-74)
> 
> So, this patch add the parsing rule for support long form format against
> Authority Key Identifier.
> 
> Cc: David Howells <dhowells@redhat.com>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Josh Boyer <jwboyer@redhat.com>
> Cc: Randy Dunlap <rdunlap@xenotime.net>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
> ---
>  crypto/asymmetric_keys/x509_cert_parser.c |   56 ++++++++++++++++++++++++----
>  1 files changed, 48 insertions(+), 8 deletions(-)
> 
> diff --git a/crypto/asymmetric_keys/x509_cert_parser.c b/crypto/asymmetric_keys/x509_cert_parser.c
> index 7fabc4c..7f6a152 100644
> --- a/crypto/asymmetric_keys/x509_cert_parser.c
> +++ b/crypto/asymmetric_keys/x509_cert_parser.c
> @@ -373,6 +373,9 @@ int rsa_extract_mpi(void *context, size_t hdrlen,
>  	return 0;
>  }
>  
> +/* The keyIdentifier in AuthorityKeyIdentifier SEQUENCE is tag(CONT,PRIM,0) */
> +#define SEQ_TAG_KEYID (ASN1_CONT << 6)
> +
>  /*
>   * Process certificate extensions that are used to qualify the certificate.
>   */
> @@ -407,21 +410,58 @@ int x509_process_extension(void *context, size_t hdrlen,
>  	}
>  
>  	if (ctx->last_oid == OID_authorityKeyIdentifier) {
> +		size_t key_len;
> +
>  		/* Get hold of the CA key fingerprint */
>  		if (vlen < 5)
>  			return -EBADMSG;
> -		if (v[0] != (ASN1_SEQ | (ASN1_CONS << 5)) ||
> -		    v[1] != vlen - 2 ||
> -		    v[2] != (ASN1_CONT << 6) ||
> -		    v[3] != vlen - 4)
> +
> +		/* Authority Key Identifier must be a Constructed SEQUENCE */
> +		if (v[0] != (ASN1_SEQ | (ASN1_CONS << 5)))
>  			return -EBADMSG;
> -		v += 4;
> -		vlen -= 4;
>  
> -		f = kmalloc(vlen * 2 + 1, GFP_KERNEL);
> +		/* Authority Key Identifier is not indefinite length */
> +		if (unlikely(vlen == ASN1_INDEFINITE_LENGTH))
> +			return -EBADMSG;
> +
> +		/* Short Form length */
> +		if (vlen <= 127) {
> +
> +			if (v[1] != vlen - 2 ||
> +			    v[2] != SEQ_TAG_KEYID ||
> +			    v[3] != vlen - 4)
> +				return -EBADMSG;
> +
> +			v += 4;
> +			key_len = v[3];
> +		} else {
> +			/* Long Form length */
> +			size_t seq_len = 0;
> +			int sub = v[1] - 0x80;
> +
> +			if (sub > 2)
> +				return -EBADMSG;
> +
> +			/* calculate the length from subsequent octet */
> +			for (i = 0; i < sub; i++) {
> +				seq_len <<= 8;
> +				seq_len |= v[2 + i];
> +			}
> +
> +			/* check vlen should not less then length of keyid */
> +			if (seq_len != vlen - 2 - sub ||
> +			    v[2 + sub] != SEQ_TAG_KEYID ||
> +			    v[3 + sub] > vlen - 4 - sub)
> +				return -EBADMSG;
> +
> +			v += (4 + sub);
> +			key_len = v[3 + sub];
> +		}
> +
> +		f = kmalloc(key_len * 2 + 1, GFP_KERNEL);
>  		if (!f)
>  			return -ENOMEM;
> -		for (i = 0; i < vlen; i++)
> +		for (i = 0; i < key_len; i++)
>  			sprintf(f + i * 2, "%02x", v[i]);
>  		pr_debug("authority   %s\n", f);
>  		ctx->cert->authority = f;


