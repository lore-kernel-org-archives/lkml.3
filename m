Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063AbaFBKsv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 06:48:51 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:35270 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101AbaFBKst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 06:48:49 -0400
MIME-Version: 1.0
In-Reply-To: <1401588848.22476.33.camel@dhcp-9-2-203-236.watson.ibm.com>
References: <1401289784-31340-1-git-send-email-zohar@linux.vnet.ibm.com>
	<1401289784-31340-5-git-send-email-zohar@linux.vnet.ibm.com>
	<CACE9dm-CwB=wPffdg7UMKWw1LBaePBgxXPYd9E51dZK+kpFKBw@mail.gmail.com>
	<1401588848.22476.33.camel@dhcp-9-2-203-236.watson.ibm.com>
Date: Mon, 2 Jun 2014 13:48:47 +0300
Message-ID: <CACE9dm_9QQapE=NiPF+vL=RpuoVAFLotOyzObcRRZ=+rqeuCOw@mail.gmail.com>
Subject: Re: [RFC PATCH v4 4/4] KEYS: define an owner trusted keyring
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

On 1 June 2014 05:14, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> On Sat, 2014-05-31 at 01:37 +0300, Dmitry Kasatkin wrote:
>> On 28 May 2014 18:09, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
>> > (UEFI) secure boot provides a signature chain of trust rooted in
>> > hardware. The signature chain of trust includes the Machine Owner
>> > Keys(MOKs), which cannot be modified without physical presence.
>> >
>> > Instead of allowing public keys, with certificates signed by any
>> > key on the system trusted keyring, to be added to a trusted
>> > keyring, this patch further restricts the certificates to those
>> > signed by the machine owner's key or chosen key.
>> >
>> > This patch defines an owner trusted keyring, defines a new boot
>> > command line option 'keyring=' to designate the machine owner's
>> > chosen key, and renames the function get_system_trusted_keyring()
>> > to get_system_or_owner_trusted_keyring().
>> >
>> > This patch permits the machine owner to safely identify their own
>> > or chosen key, without requiring it to be builtin the kernel.
>> >
>> > Signed-off-by: Mimi Zohar<zohar@linux.vnet.ibm.com>
>> > ---
>> >  crypto/asymmetric_keys/x509_public_key.c |  3 +-
>> >  include/keys/system_keyring.h            | 15 ++++--
>> >  include/linux/key.h                      |  4 ++
>> >  kernel/system_keyring.c                  | 85 ++++++++++++++++++++++++++++++++
>> >  security/keys/key.c                      | 20 ++++++++
>> >  5 files changed, 121 insertions(+), 6 deletions(-)
>> >
>> > diff --git a/crypto/asymmetric_keys/x509_public_key.c b/crypto/asymmetric_keys/x509_public_key.c
>> > index 1af8a30..6d52790 100644
>> > --- a/crypto/asymmetric_keys/x509_public_key.c
>> > +++ b/crypto/asymmetric_keys/x509_public_key.c
>> > @@ -237,7 +237,8 @@ static int x509_key_preparse(struct key_preparsed_payload *prep)
>> >                 if (ret < 0)
>> >                         goto error_free_cert;
>> >         } else {
>> > -               ret = x509_validate_trust(cert, get_system_trusted_keyring());
>> > +               ret = x509_validate_trust(cert,
>> > +                                         get_system_or_owner_trusted_keyring());
>> >                 if (!ret)
>> >                         prep->trusted = 1;
>> >         }
>> > diff --git a/include/keys/system_keyring.h b/include/keys/system_keyring.h
>> > index 72665eb..f665c33 100644
>> > --- a/include/keys/system_keyring.h
>> > +++ b/include/keys/system_keyring.h
>> > @@ -17,15 +17,20 @@
>> >  #include <linux/key.h>
>> >
>> >  extern struct key *system_trusted_keyring;
>> > -static inline struct key *get_system_trusted_keyring(void)
>> > -{
>> > -       return system_trusted_keyring;
>> > -}
>> > +extern struct key *owner_trusted_keyring;
>> > +
>> > +extern struct key *get_system_or_owner_trusted_keyring(void);
>> > +extern void load_owner_identified_uefi_key(key_ref_t key);
>> > +
>> >  #else
>> > -static inline struct key *get_system_trusted_keyring(void)
>> > +static inline struct key *get_system_or_owner_trusted_keyring(void)
>> >  {
>> >         return NULL;
>> >  }
>> > +
>> > +static void load_owner_identified_uefi_key(key_ref_t key)
>> > +{
>> > +}
>> >  #endif
>> >
>> >  #endif /* _KEYS_SYSTEM_KEYRING_H */
>> > diff --git a/include/linux/key.h b/include/linux/key.h
>> > index cd0abb8..861843a 100644
>> > --- a/include/linux/key.h
>> > +++ b/include/linux/key.h
>> > @@ -267,6 +267,10 @@ extern int wait_for_key_construction(struct key *key, bool intr);
>> >
>> >  extern int key_validate(const struct key *key);
>> >
>> > +extern int key_match(key_ref_t key,
>> > +                    const char *type,
>> > +                    const char *description);
>> > +
>> >  extern key_ref_t key_create_or_update(key_ref_t keyring,
>> >                                       const char *type,
>> >                                       const char *description,
>> > diff --git a/kernel/system_keyring.c b/kernel/system_keyring.c
>> > index 52ebc70..e9b14ac 100644
>> > --- a/kernel/system_keyring.c
>> > +++ b/kernel/system_keyring.c
>> > @@ -19,11 +19,75 @@
>> >  #include "module-internal.h"
>> >
>> >  struct key *system_trusted_keyring;
>> > +struct key *owner_trusted_keyring;
>> >  EXPORT_SYMBOL_GPL(system_trusted_keyring);
>> >
>> >  extern __initconst const u8 system_certificate_list[];
>> >  extern __initconst const unsigned long system_certificate_list_size;
>> >
>> > +static int use_owner_trusted_keyring;
>> > +
>> > +static char *owner_keyid;
>> > +static int builtin_keyring;
>> > +static int __init default_keyring_set(char *str)
>> > +{
>> > +       if (!str)       /* default: builtin */
>> > +               return 1;
>> > +
>> > +       if (strcmp(str, "system") == 0)  /* use system keyring */
>> > +               ;
>> > +       else if (strcmp(str, "builtin") == 0)  /* only builtin keys */
>> > +               builtin_keyring = 1;
>> > +       else
>> > +               owner_keyid = str;   /* owner local key 'id:xxxxxx' */
>> > +       return 1;
>> > +}
>> > +__setup("keyring=", default_keyring_set);
>> > +
>> > +/*
>> > + * Load the owner identified key on the 'owner' trusted keyring.
>> > + */
>> > +void load_owner_identified_uefi_key(key_ref_t key)
>> > +{
>> > +       if (!owner_keyid || use_owner_trusted_keyring)
>> > +               return;
>> > +
>> > +       if (!key_match(key, "asymmetric", owner_keyid))
>> > +               return;
>> > +
>> > +       if (key_link(owner_trusted_keyring, key_ref_to_ptr(key)) == 0) {
>> > +               set_bit(KEY_FLAG_TRUSTED_ONLY, &owner_trusted_keyring->flags);
>> > +               use_owner_trusted_keyring = 1;
>>
>> This is a bit strange...
>> Linking any key forces to use owner trusted keyring...
>
> Wouldn't it be stranger to identify a specific key on the system keyring
> and add it to the owner keyring, but then not use it?   I don't
> understand your concern.  What is the problem?

This patch technically specifies to use all keys from the system
keyring or the one specified
by the owner_keyid. Why the owner keyring is needed then at all?
owner_keyid can identify the key to use from the system keyring....


>
>> > +               pr_notice("Loaded X.509 cert '%s' on .owner_keyring\n",
>> > +                                 key_ref_to_ptr(key)->description);
>> > +       }
>> > +}
>> > +
>> > +static void load_owner_identified_builtin_key(key_ref_t key)
>> > +{
>> > +       if (!owner_keyid && !builtin_keyring)
>> > +               return;
>> > +
>>
>> It looks like builtin_keyring is useless...
>> Is it like linking all .system keys to owners keyring???
>>
>> Why not just to return .system keyring in get_system_or_owner_trusted_keyring()
>> based on owner_keyid?
>
> Before David and Josh's proposed UEFI secure boot patches, only the
> builtin keys are on the system keyring. After those patches, the UEFI
> secure boot keys, including the MOK keys, are there as well.
>
> I think splitting this patch up into before and after adding the secure
> boot keys to the system keyring, would help clarify this patch.
>

> Mimi
>
>>
>>
>> > +       if (!builtin_keyring && !key_match(key, "asymmetric", owner_keyid))
>> > +               return;
>> > +
>> > +       if (key_link(owner_trusted_keyring, key_ref_to_ptr(key)) == 0) {
>> > +               set_bit(KEY_FLAG_TRUSTED_ONLY, &owner_trusted_keyring->flags);
>> > +               use_owner_trusted_keyring = 1;
>>
>> The same...
>> Linking any key forces to use owner trusted keyring...
>>
>>
>> > +               pr_notice("Loaded X.509 cert '%s' on .owner_keyring\n",
>> > +                                 key_ref_to_ptr(key)->description);
>> > +       }
>> > +}
>> > +
>> > +/*
>> > + * Use the owner_trusted_keyring if available
>> > + */
>> > +struct key *get_system_or_owner_trusted_keyring(void)
>> > +{
>> > +       return use_owner_trusted_keyring ? owner_trusted_keyring :
>> > +               system_trusted_keyring;
>> > +}
>> > +
>> >  /*
>> >   * Load the compiled-in keys
>> >   */
>> > @@ -50,6 +114,25 @@ static __init int system_trusted_keyring_init(void)
>> >  device_initcall(system_trusted_keyring_init);
>> >
>> >  /*
>> > + * Load the owner trusted key
>> > + */
>> > +static __init int owner_trusted_keyring_init(void)
>> > +{
>> > +       pr_notice("Initialize the owner trusted keyring\n");
>> > +
>> > +       owner_trusted_keyring =
>> > +               keyring_alloc(".owner_keyring",
>> > +                             KUIDT_INIT(0), KGIDT_INIT(0), current_cred(),
>> > +                             ((KEY_POS_ALL & ~KEY_POS_SETATTR) |
>> > +                             KEY_USR_VIEW | KEY_USR_READ | KEY_USR_SEARCH),
>> > +                             KEY_ALLOC_NOT_IN_QUOTA, NULL);
>> > +       if (IS_ERR(owner_trusted_keyring))
>> > +               panic("Can't allocate owner trusted keyring\n");
>> > +       return 0;
>> > +}
>> > +device_initcall(owner_trusted_keyring_init);
>> > +
>> > +/*
>> >   * Load the compiled-in list of X.509 certificates.
>> >   */
>> >  static __init int load_system_certificate_list(void)
>> > @@ -91,6 +174,8 @@ static __init int load_system_certificate_list(void)
>> >                 } else {
>> >                         pr_notice("Loaded X.509 cert '%s'\n",
>> >                                   key_ref_to_ptr(key)->description);
>> > +
>> > +                       load_owner_identified_builtin_key(key);
>> >                         key_ref_put(key);
>> >                 }
>> >                 p += plen;
>> > diff --git a/security/keys/key.c b/security/keys/key.c
>> > index 2048a11..b448ab1 100644
>> > --- a/security/keys/key.c
>> > +++ b/security/keys/key.c
>> > @@ -701,6 +701,26 @@ void key_type_put(struct key_type *ktype)
>> >         up_read(&key_types_sem);
>> >  }
>> >
>> > +/*
>> > + * Use the key type's match function to compare the key's id.
>> > + */
>> > +int key_match(key_ref_t key, const char *type, const char *description)
>> > +{
>> > +       struct keyring_index_key index_key;
>> > +       int ret = 0;
>> > +
>> > +       index_key.type = key_type_lookup(type);
>> > +       if (IS_ERR(index_key.type))
>> > +               goto out;
>> > +
>> > +       if (index_key.type->match &&
>> > +           index_key.type->match(key_ref_to_ptr(key), description))
>> > +               ret = 1;
>> > +       key_type_put(index_key.type);
>> > +out:
>> > +       return ret;
>> > +}
>> > +
>> >  /*
>> >   * Attempt to update an existing key.
>> >   *
>
>



-- 
Thanks,
Dmitry
