Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646Ab3AWJDp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 04:03:45 -0500
Received: from mga12.intel.com ([143.182.124.36]:5713 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752626Ab3AWJDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 04:03:41 -0500
MIME-Version: 1.0
In-Reply-To: <1358895228.2408.14.camel@falcor1>
References: <cover.1358246017.git.dmitry.kasatkin@intel.com>
	<53febcf9f13e59a1ddd8f8c9826cadbe663f2295.1358246017.git.dmitry.kasatkin@intel.com>
	<1358895228.2408.14.camel@falcor1>
Date: Wed, 23 Jan 2013 11:03:39 +0200
Message-ID: <CALLzPKbNVV+iWzUcsxq0Lk-Hz2BVpCBsEbjHdnRAyjDsF5___g@mail.gmail.com>
Subject: Re: [RFC 1/1] ima: digital signature verification using asymmetric keys
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: dhowells@redhat.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2013 at 12:53 AM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> On Tue, 2013-01-15 at 12:34 +0200, Dmitry Kasatkin wrote:
>> Asymmetric keys were introduced in linux-3.7 to verify the signature on
>> signed kernel modules.  The asymmetric keys infrastructure abstracts the
>> signature verification from the crypto details.  This patch adds IMA/EVM
>> signature verification using asymmetric keys.  Support for additional
>> signature verification methods can now be delegated to the asymmetric
>> key infrastructure.
>>
>> Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
>> ---
>>  security/integrity/Kconfig  |   12 +++++
>>  security/integrity/digsig.c |  103 ++++++++++++++++++++++++++++++++++++++++++-
>>  2 files changed, 114 insertions(+), 1 deletion(-)
>>
>> diff --git a/security/integrity/Kconfig b/security/integrity/Kconfig
>> index 5bd1cc1..19c4187 100644
>> --- a/security/integrity/Kconfig
>> +++ b/security/integrity/Kconfig
>> @@ -17,5 +17,17 @@ config INTEGRITY_SIGNATURE
>>         This is useful for evm and module keyrings, when keys are
>>         usually only added from initramfs.
>>
>> +config INTEGRITY_ASYMMETRIC_KEYS
>> +     boolean "Digital signature verification using asymmetric keys"
>> +     depends on INTEGRITY_SIGNATURE
>> +     default n
>> +        select ASYMMETRIC_KEY_TYPE
>> +        select ASYMMETRIC_PUBLIC_KEY_SUBTYPE
>> +        select PUBLIC_KEY_ALGO_RSA
>> +        select X509_CERTIFICATE_PARSER
>> +     help
>> +       This option enables digital signature verification support
>> +       using asymmetric keys.
>> +
>>  source security/integrity/ima/Kconfig
>>  source security/integrity/evm/Kconfig
>> diff --git a/security/integrity/digsig.c b/security/integrity/digsig.c
>> index 2dc167d..1896537 100644
>> --- a/security/integrity/digsig.c
>> +++ b/security/integrity/digsig.c
>> @@ -15,10 +15,22 @@
>>  #include <linux/err.h>
>>  #include <linux/rbtree.h>
>>  #include <linux/key-type.h>
>> +#include <crypto/public_key.h>
>> +#include <keys/asymmetric-type.h>
>>  #include <linux/digsig.h>
>>
>>  #include "integrity.h"
>>
>> +/*
>> + * signature format v2 - for using with asymmetric keys
>> + */
>> +struct signature_v2_hdr {
>> +     uint8_t version;        /* signature format version */
>> +     uint8_t hash_algo;      /* Digest algorithm [enum pkey_hash_algo] */
>> +     uint8_t keyid[8];       /* IMA key identifier - not X509/PGP specific*/
>> +     uint8_t payload[0];     /* signature payload */
>> +} __packed;
>> +
>>  static struct key *keyring[INTEGRITY_KEYRING_MAX];
>>
>>  static const char *keyring_name[INTEGRITY_KEYRING_MAX] = {
>> @@ -27,6 +39,91 @@ static const char *keyring_name[INTEGRITY_KEYRING_MAX] = {
>>       "_ima",
>>  };
>>
>> +#ifdef CONFIG_INTEGRITY_ASYMMETRIC_KEYS
>> +
>> +/*
>> + * Request an asymmetric key.
>> + */
>> +static struct key *request_asymmetric_key(struct key *keyring, uint8_t *keyid)
>> +{
>> +     struct key *key;
>> +     char name[20];
>> +
>> +     sprintf(name, "%llX", __be64_to_cpup((uint64_t *)keyid));
>> +
>> +     pr_debug("key search: \"%s\"\n", name);
>> +
>> +     if (keyring) {
>> +             /* search in specific keyring */
>> +             key_ref_t kref;
>> +             kref = keyring_search(make_key_ref(keyring, 1),
>> +                                   &key_type_asymmetric, name);
>> +             if (IS_ERR(kref))
>> +                     key = ERR_CAST(kref);
>> +             else
>> +                     key = key_ref_to_ptr(kref);
>> +     } else {
>> +             key = request_key(&key_type_asymmetric, name, NULL);
>> +     }
>> +
>> +     if (IS_ERR(key)) {
>> +             pr_warn("Request for unknown key '%s' err %ld\n",
>> +                     name, PTR_ERR(key));
>> +             switch (PTR_ERR(key)) {
>> +                     /* Hide some search errors */
>> +             case -EACCES:
>> +             case -ENOTDIR:
>> +             case -EAGAIN:
>> +                     return ERR_PTR(-ENOKEY);
>> +             default:
>> +                     return key;
>> +             }
>> +     }
>> +
>> +     pr_debug("%s() = 0 [%x]\n", __func__, key_serial(key));
>> +
>> +     return key;
>> +}
>> +
>> +static int asymmetric_verify(struct key *keyring, const char *sig,
>> +                          size_t siglen, const char *data, int datalen)
>> +{
>> +     struct public_key_signature pks;
>> +     struct signature_v2_hdr *hdr = (struct signature_v2_hdr *)sig;
>> +     struct key *key;
>> +     int ret = -ENOMEM;
>> +
>> +     if (siglen <= sizeof(*hdr))
>> +             return -EBADMSG;
>> +
>> +     siglen -= sizeof(*hdr);
>> +
>> +     if (hdr->hash_algo >= PKEY_HASH__LAST)
>> +             return -ENOPKG;
>> +
>> +     key = request_asymmetric_key(keyring, hdr->keyid);
>> +     if (IS_ERR(key))
>> +             return PTR_ERR(key);
>> +
>> +     memset(&pks, 0, sizeof(pks));
>> +
>> +     pks.pkey_hash_algo = hdr->hash_algo;
>> +     pks.digest = (u8 *)data;
>> +     pks.digest_size = datalen;
>> +     pks.nr_mpi = 1;
>> +     pks.rsa.s = mpi_read_from_buffer(hdr->payload, &siglen);
>> +
>> +     if (pks.rsa.s)
>> +             ret = verify_signature(key, &pks);
>> +
>> +     mpi_free(pks.rsa.s);
>> +     key_put(key);
>> +     pr_debug("%s() = %d\n", __func__, ret);
>> +     return ret;
>> +}
>> +
>> +#endif /* CONFIG_INTEGRITY_ASYMMETRIC_KEYS */
>> +
>>  int integrity_digsig_verify(const unsigned int id, const char *sig, int siglen,
>>                                       const char *digest, int digestlen)
>>  {
>> @@ -43,6 +140,10 @@ int integrity_digsig_verify(const unsigned int id, const char *sig, int siglen,
>>                       return err;
>>               }
>>       }
>> -
>> +#ifdef CONFIG_INTEGRITY_ASYMMETRIC_KEYS
>> +     if (sig[0] == 2)
>> +             return asymmetric_verify(keyring[id], sig, siglen,
>> +                                      digest, digestlen);
>> +#endif
>>       return digsig_verify(keyring[id], sig, siglen, digest, digestlen);
>>  }
>
> Thanks Dmitry for the patch!  According to
> Documentation/SubmittingPatches: section 2.2, #ifdefs are ugly.  I
> realize this is a really small '.c' file, and doesn't really hurt
> readability, but could you remove the ifdefs anyway?
>

Will do it.

- Dmitry

> thanks,
>
> Mimi
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
