Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007AbaDXVEM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 17:04:12 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:47796 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945AbaDXVEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 17:04:07 -0400
Message-ID: <1398373394.3395.81.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH 01/20] KEYS: verify a certificate is signed by a
 'trusted' key
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Cc: Dmitry Kasatkin <d.kasatkin@samsung.com>,
        David Howells <dhowells@redhat.com>, James Morris <jmorris@namei.org>,
        Roberto Sassu <roberto.sassu@polito.it>,
        linux-security-module@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 24 Apr 2014 17:03:14 -0400
In-Reply-To: <CACE9dm_JhUDQHBok2HXKMgLCF6XOfVk=ZHOqpsqXhOCU=BJGqw@mail.gmail.com>
References: <cover.1398259638.git.d.kasatkin@samsung.com>
	 <0f7915604c69374f15cbaf36c499a5d88264e89d.1398259638.git.d.kasatkin@samsung.com>
	 <1398358432.2293.17.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <CACE9dm_JhUDQHBok2HXKMgLCF6XOfVk=ZHOqpsqXhOCU=BJGqw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042421-0928-0000-0000-0000017835E0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-04-24 at 23:07 +0300, Dmitry Kasatkin wrote: 
> On 24 April 2014 19:53, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> > On Wed, 2014-04-23 at 16:30 +0300, Dmitry Kasatkin wrote:
> >> From: Mimi Zohar <zohar@linux.vnet.ibm.com>
> >>
> >> Only public keys, with certificates signed by an existing
> >> 'trusted' key on the system trusted keyring, should be added
> >> to a trusted keyring.  This patch adds support for verifying
> >> a certificate's signature.
> >>
> >> This is derived from David Howells pkcs7_request_asymmetric_key() patch.
> >>
> >> Changes:
> >> - Flaged out the code to prevent build break if system keyring
> >>   is not enabled (Dmitry).
> >
> > An updated version of this patch was posted, which resolves the Kconfig
> > issues.  There are a number of other issues which need to be addressed,
> > before this patch can be upstreamed.  Please refer to the patch
> > description for more details -
> > http://marc.info/?l=linux-security-module&m=138672063109662&w=2
> >
> 
> Oh. I was using this patch from your public tree..
> Updated version is missing there and I missed it out.
> Will rebase on the top of it as soon as it is available.

Ok. The patch set was posted as an RFC, but didn't receive any review.
The issues still need to be resolved (eg. associating a specific public
keyring to verify a new key being added to the trusted keyring,
userspace being able to replace a trusted keyring) before it can be
upstreamed.

While you're rebasing this patch set, please consider breaking it up
into smaller, logical groups.

[- trusted keyring support (me)]
- Kconfig cleanup
- kernel loading x509 keys
- kernel IMA policy update

thanks,

Mimi


> > Reminder, as per Documentation/SubmittingPatches: "#ifdefs are ugly",
> > please no ifdefs in C code.
> >
> 
> Right, we know it.
> 
> Making separate C file for one function isn't ugly?
> 
> - Dmitry
> 
> > thanks,
> >
> > Mimi
> >
> >>
> >> Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
> >> Signed-off-by: David Howells <dhowells@redhat.com>
> >> Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
> >> ---
> >>  crypto/asymmetric_keys/x509_public_key.c | 85 +++++++++++++++++++++++++++++++-
> >>  1 file changed, 84 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/crypto/asymmetric_keys/x509_public_key.c b/crypto/asymmetric_keys/x509_public_key.c
> >> index 382ef0d..d279f43 100644
> >> --- a/crypto/asymmetric_keys/x509_public_key.c
> >> +++ b/crypto/asymmetric_keys/x509_public_key.c
> >> @@ -18,6 +18,7 @@
> >>  #include <linux/asn1_decoder.h>
> >>  #include <keys/asymmetric-subtype.h>
> >>  #include <keys/asymmetric-parser.h>
> >> +#include <keys/system_keyring.h>
> >>  #include <crypto/hash.h>
> >>  #include "asymmetric_keys.h"
> >>  #include "public_key.h"
> >> @@ -102,6 +103,82 @@ int x509_check_signature(const struct public_key *pub,
> >>  }
> >>  EXPORT_SYMBOL_GPL(x509_check_signature);
> >>
> >> +#ifdef CONFIG_SYSTEM_TRUSTED_KEYRING
> >> +/*
> >> + * Find a key in the given keyring by issuer and authority.
> >> + */
> >> +static struct key *x509_request_asymmetric_key(
> >> +     struct key *keyring,
> >> +     const char *signer, size_t signer_len,
> >> +     const char *authority, size_t auth_len)
> >> +{
> >> +     key_ref_t key;
> >> +     char *id;
> >> +
> >> +     /* Construct an identifier. */
> >> +     id = kmalloc(signer_len + 2 + auth_len + 1, GFP_KERNEL);
> >> +     if (!id)
> >> +             return ERR_PTR(-ENOMEM);
> >> +
> >> +     memcpy(id, signer, signer_len);
> >> +     id[signer_len + 0] = ':';
> >> +     id[signer_len + 1] = ' ';
> >> +     memcpy(id + signer_len + 2, authority, auth_len);
> >> +     id[signer_len + 2 + auth_len] = 0;
> >> +
> >> +     pr_debug("Look up: \"%s\"\n", id);
> >> +
> >> +     key = keyring_search(make_key_ref(keyring, 1),
> >> +                          &key_type_asymmetric, id);
> >> +     if (IS_ERR(key))
> >> +             pr_debug("Request for module key '%s' err %ld\n",
> >> +                      id, PTR_ERR(key));
> >> +     kfree(id);
> >> +
> >> +     if (IS_ERR(key)) {
> >> +             switch (PTR_ERR(key)) {
> >> +                     /* Hide some search errors */
> >> +             case -EACCES:
> >> +             case -ENOTDIR:
> >> +             case -EAGAIN:
> >> +                     return ERR_PTR(-ENOKEY);
> >> +             default:
> >> +                     return ERR_CAST(key);
> >> +             }
> >> +     }
> >> +
> >> +     pr_devel("<==%s() = 0 [%x]\n", __func__, key_serial(key_ref_to_ptr(key)));
> >> +     return key_ref_to_ptr(key);
> >> +}
> >> +
> >> +/*
> >> + * Check the new certificate against the ones in the trust keyring.  If one of
> >> + * those is the signing key and validates the new certificate, then mark the
> >> + * new certificate as being trusted.
> >> + *
> >> + * Return 0 if the new certificate was successfully validated, 1 if we couldn't
> >> + * find a matching parent certificate in the trusted list and an error if there
> >> + * is a matching certificate but the signature check fails.
> >> + */
> >> +static int x509_validate_trust(struct x509_certificate *cert,
> >> +                            struct key *trust_keyring)
> >> +{
> >> +     const struct public_key *pk;
> >> +     struct key *key;
> >> +     int ret = 1;
> >> +
> >> +     key = x509_request_asymmetric_key(trust_keyring,
> >> +                                       cert->issuer, strlen(cert->issuer),
> >> +                                       cert->authority,
> >> +                                       strlen(cert->authority));
> >> +     if (!IS_ERR(key))  {
> >> +             pk = key->payload.data;
> >> +             ret = x509_check_signature(pk, cert);
> >> +     }
> >> +     return ret;
> >> +}
> >> +#endif
> >> +
> >>  /*
> >>   * Attempt to parse a data blob for a key as an X509 certificate.
> >>   */
> >> @@ -155,9 +232,15 @@ static int x509_key_preparse(struct key_preparsed_payload *prep)
> >>       /* Check the signature on the key if it appears to be self-signed */
> >>       if (!cert->authority ||
> >>           strcmp(cert->fingerprint, cert->authority) == 0) {
> >> -             ret = x509_check_signature(cert->pub, cert);
> >> +             ret = x509_check_signature(cert->pub, cert); /* self-signed */
> >>               if (ret < 0)
> >>                       goto error_free_cert;
> >> +     } else {
> >> +#ifdef CONFIG_SYSTEM_TRUSTED_KEYRING
> >> +             ret = x509_validate_trust(cert, system_trusted_keyring);
> >> +             if (!ret)
> >> +                     prep->trusted = 1;
> >> +#endif
> >>       }
> >>
> >>       /* Propose a description */
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 


