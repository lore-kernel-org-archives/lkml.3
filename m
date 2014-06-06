Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544AbaFFVuJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 17:50:09 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:48088 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108AbaFFVuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 17:50:07 -0400
MIME-Version: 1.0
In-Reply-To: <1401818318-15780-3-git-send-email-zohar@linux.vnet.ibm.com>
References: <1401818318-15780-1-git-send-email-zohar@linux.vnet.ibm.com>
	<1401818318-15780-3-git-send-email-zohar@linux.vnet.ibm.com>
Date: Sat, 7 Jun 2014 00:50:05 +0300
Message-ID: <CACE9dm_VGRiG7Sok_nONwbBTGoH3RbJCvBD=YayiWuRDoJo3-g@mail.gmail.com>
Subject: Re: [RFC PATCH v5 2/4] KEYS: verify a certificate is signed by a
 'trusted' key
From: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-security-module <linux-security-module@vger.kernel.org>,
        Dmitry Kasatkin <d.kasatkin@samsung.com>,
        David Howells <dhowells@redhat.com>, Josh Boyer <jwboyer@redhat.com>,
        keyrings <keyrings@linux-nfs.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 June 2014 20:58, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> Only public keys, with certificates signed by an existing
> 'trusted' key on the system trusted keyring, should be added
> to a trusted keyring.  This patch adds support for verifying
> a certificate's signature.
>
> This is derived from David Howells pkcs7_request_asymmetric_key() patch.
>
> Changelog:
> - define get_system_trusted_keyring() to fix kbuild issues
>
> Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
> Signed-off-by: David Howells <dhowells@redhat.com>

Acked-by: me


> ---
>  crypto/asymmetric_keys/x509_public_key.c | 84 +++++++++++++++++++++++++++++++-
>  include/keys/system_keyring.h            | 10 +++-
>  2 files changed, 92 insertions(+), 2 deletions(-)
>
> diff --git a/crypto/asymmetric_keys/x509_public_key.c b/crypto/asymmetric_keys/x509_public_key.c
> index 382ef0d..1af8a30 100644
> --- a/crypto/asymmetric_keys/x509_public_key.c
> +++ b/crypto/asymmetric_keys/x509_public_key.c
> @@ -18,12 +18,60 @@
>  #include <linux/asn1_decoder.h>
>  #include <keys/asymmetric-subtype.h>
>  #include <keys/asymmetric-parser.h>
> +#include <keys/system_keyring.h>
>  #include <crypto/hash.h>
>  #include "asymmetric_keys.h"
>  #include "public_key.h"
>  #include "x509_parser.h"
>
>  /*
> + * Find a key in the given keyring by issuer and authority.
> + */
> +static struct key *x509_request_asymmetric_key(
> +       struct key *keyring,
> +       const char *signer, size_t signer_len,
> +       const char *authority, size_t auth_len)
> +{
> +       key_ref_t key;
> +       char *id;
> +
> +       /* Construct an identifier. */
> +       id = kmalloc(signer_len + 2 + auth_len + 1, GFP_KERNEL);
> +       if (!id)
> +               return ERR_PTR(-ENOMEM);
> +
> +       memcpy(id, signer, signer_len);
> +       id[signer_len + 0] = ':';
> +       id[signer_len + 1] = ' ';
> +       memcpy(id + signer_len + 2, authority, auth_len);
> +       id[signer_len + 2 + auth_len] = 0;
> +
> +       pr_debug("Look up: \"%s\"\n", id);
> +
> +       key = keyring_search(make_key_ref(keyring, 1),
> +                            &key_type_asymmetric, id);
> +       if (IS_ERR(key))
> +               pr_debug("Request for module key '%s' err %ld\n",
> +                        id, PTR_ERR(key));
> +       kfree(id);
> +
> +       if (IS_ERR(key)) {
> +               switch (PTR_ERR(key)) {
> +                       /* Hide some search errors */
> +               case -EACCES:
> +               case -ENOTDIR:
> +               case -EAGAIN:
> +                       return ERR_PTR(-ENOKEY);
> +               default:
> +                       return ERR_CAST(key);
> +               }
> +       }
> +
> +       pr_devel("<==%s() = 0 [%x]\n", __func__, key_serial(key_ref_to_ptr(key)));
> +       return key_ref_to_ptr(key);
> +}
> +
> +/*
>   * Set up the signature parameters in an X.509 certificate.  This involves
>   * digesting the signed data and extracting the signature.
>   */
> @@ -103,6 +151,36 @@ int x509_check_signature(const struct public_key *pub,
>  EXPORT_SYMBOL_GPL(x509_check_signature);
>
>  /*
> + * Check the new certificate against the ones in the trust keyring.  If one of
> + * those is the signing key and validates the new certificate, then mark the
> + * new certificate as being trusted.
> + *
> + * Return 0 if the new certificate was successfully validated, 1 if we couldn't
> + * find a matching parent certificate in the trusted list and an error if there
> + * is a matching certificate but the signature check fails.
> + */
> +static int x509_validate_trust(struct x509_certificate *cert,
> +                              struct key *trust_keyring)
> +{
> +       const struct public_key *pk;
> +       struct key *key;
> +       int ret = 1;
> +
> +       if (!trust_keyring)
> +               return -EOPNOTSUPP;
> +
> +       key = x509_request_asymmetric_key(trust_keyring,
> +                                         cert->issuer, strlen(cert->issuer),
> +                                         cert->authority,
> +                                         strlen(cert->authority));
> +       if (!IS_ERR(key))  {
> +               pk = key->payload.data;
> +               ret = x509_check_signature(pk, cert);
> +       }
> +       return ret;
> +}
> +
> +/*
>   * Attempt to parse a data blob for a key as an X509 certificate.
>   */
>  static int x509_key_preparse(struct key_preparsed_payload *prep)
> @@ -155,9 +233,13 @@ static int x509_key_preparse(struct key_preparsed_payload *prep)
>         /* Check the signature on the key if it appears to be self-signed */
>         if (!cert->authority ||
>             strcmp(cert->fingerprint, cert->authority) == 0) {
> -               ret = x509_check_signature(cert->pub, cert);
> +               ret = x509_check_signature(cert->pub, cert); /* self-signed */
>                 if (ret < 0)
>                         goto error_free_cert;
> +       } else {
> +               ret = x509_validate_trust(cert, get_system_trusted_keyring());
> +               if (!ret)
> +                       prep->trusted = 1;
>         }
>
>         /* Propose a description */
> diff --git a/include/keys/system_keyring.h b/include/keys/system_keyring.h
> index 8dabc39..72665eb 100644
> --- a/include/keys/system_keyring.h
> +++ b/include/keys/system_keyring.h
> @@ -17,7 +17,15 @@
>  #include <linux/key.h>
>
>  extern struct key *system_trusted_keyring;
> -
> +static inline struct key *get_system_trusted_keyring(void)
> +{
> +       return system_trusted_keyring;
> +}
> +#else
> +static inline struct key *get_system_trusted_keyring(void)
> +{
> +       return NULL;
> +}
>  #endif
>
>  #endif /* _KEYS_SYSTEM_KEYRING_H */
> --
> 1.8.1.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,
Dmitry
