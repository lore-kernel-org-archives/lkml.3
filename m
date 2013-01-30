Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624Ab3A3I3k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 03:29:40 -0500
Received: from mga06.intel.com ([134.134.136.21]:61533 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752506Ab3A3I3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 03:29:38 -0500
MIME-Version: 1.0
In-Reply-To: <20130117180407.27885.54342.stgit@warthog.procyon.org.uk>
References: <20130117180352.27885.79893.stgit@warthog.procyon.org.uk>
	<20130117180407.27885.54342.stgit@warthog.procyon.org.uk>
Date: Wed, 30 Jan 2013 10:29:35 +0200
Message-ID: <CALLzPKayx83x6KRs9NSjthR1H4VR1PzEcYhnGJU6gnrWMs7_fg@mail.gmail.com>
Subject: Re: [PATCH 3/3] KEYS: Add a 'trusted' flag and a 'trusted only' flag
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: David Howells <dhowells@redhat.com>
Cc: zohar@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        linux-crypto@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2013 at 8:04 PM, David Howells <dhowells@redhat.com> wrote:
> Add KEY_FLAG_TRUSTED to indicate that a key either comes from a trusted source
> or had a cryptographic signature chain that led back to a trusted key the
> kernel already possessed.
>
> Add KEY_FLAGS_TRUSTED_ONLY to indicate that a keyring will only accept links to
> keys marked with KEY_FLAGS_TRUSTED.
>
> Signed-off-by: David Howells <dhowells@redhat.com>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> ---
>
>  include/linux/key-type.h |    1 +
>  include/linux/key.h      |    3 +++
>  kernel/system_keyring.c  |    4 +++-
>  security/keys/key.c      |    8 ++++++++
>  security/keys/keyring.c  |    4 ++++
>  5 files changed, 19 insertions(+), 1 deletion(-)
>
>
> diff --git a/include/linux/key-type.h b/include/linux/key-type.h
> index 518a53a..f942b2d 100644
> --- a/include/linux/key-type.h
> +++ b/include/linux/key-type.h
> @@ -45,6 +45,7 @@ struct key_preparsed_payload {
>         const void      *data;          /* Raw data */
>         size_t          datalen;        /* Raw datalen */
>         size_t          quotalen;       /* Quota length for proposed payload */
> +       bool            trusted;        /* True if key is trusted */
>  };
>
>  typedef int (*request_key_actor_t)(struct key_construction *key,
> diff --git a/include/linux/key.h b/include/linux/key.h
> index 4dfde11..0b32a09 100644
> --- a/include/linux/key.h
> +++ b/include/linux/key.h
> @@ -162,6 +162,8 @@ struct key {
>  #define KEY_FLAG_NEGATIVE      5       /* set if key is negative */
>  #define KEY_FLAG_ROOT_CAN_CLEAR        6       /* set if key can be cleared by root without permission */
>  #define KEY_FLAG_INVALIDATED   7       /* set if key has been invalidated */
> +#define KEY_FLAG_TRUSTED       8       /* set if key is trusted */
> +#define KEY_FLAG_TRUSTED_ONLY  9       /* set if keyring only accepts links to trusted keys */
>
>         /* the description string
>          * - this is used to match a key against search criteria
> @@ -203,6 +205,7 @@ extern struct key *key_alloc(struct key_type *type,
>  #define KEY_ALLOC_IN_QUOTA     0x0000  /* add to quota, reject if would overrun */
>  #define KEY_ALLOC_QUOTA_OVERRUN        0x0001  /* add to quota, permit even if overrun */
>  #define KEY_ALLOC_NOT_IN_QUOTA 0x0002  /* not in quota */
> +#define KEY_ALLOC_TRUSTED      0x0004  /* Key should be flagged as trusted */
>
>  extern void key_revoke(struct key *key);
>  extern void key_invalidate(struct key *key);
> diff --git a/kernel/system_keyring.c b/kernel/system_keyring.c
> index a3ca76f..dae8778 100644
> --- a/kernel/system_keyring.c
> +++ b/kernel/system_keyring.c
> @@ -40,6 +40,7 @@ static __init int system_trusted_keyring_init(void)
>         if (IS_ERR(system_trusted_keyring))
>                 panic("Can't allocate system trusted keyring\n");
>
> +       set_bit(KEY_FLAG_TRUSTED_ONLY, &system_trusted_keyring->flags);
>         return 0;
>  }
>
> @@ -82,7 +83,8 @@ static __init int load_system_certificate_list(void)
>                                            plen,
>                                            (KEY_POS_ALL & ~KEY_POS_SETATTR) |
>                                            KEY_USR_VIEW,
> -                                          KEY_ALLOC_NOT_IN_QUOTA);
> +                                          KEY_ALLOC_NOT_IN_QUOTA |
> +                                          KEY_ALLOC_TRUSTED);
>                 if (IS_ERR(key))
>                         pr_err("Problem loading in-kernel X.509 certificate (%ld)\n",
>                                PTR_ERR(key));
> diff --git a/security/keys/key.c b/security/keys/key.c
> index 8fb7c7b..f3de9e4 100644
> --- a/security/keys/key.c
> +++ b/security/keys/key.c
> @@ -299,6 +299,8 @@ struct key *key_alloc(struct key_type *type, const char *desc,
>
>         if (!(flags & KEY_ALLOC_NOT_IN_QUOTA))
>                 key->flags |= 1 << KEY_FLAG_IN_QUOTA;
> +       if (flags & KEY_ALLOC_TRUSTED)
> +               key->flags |= 1 << KEY_FLAG_TRUSTED;
>
>         memset(&key->type_data, 0, sizeof(key->type_data));
>
> @@ -813,6 +815,7 @@ key_ref_t key_create_or_update(key_ref_t keyring_ref,
>         prep.data = payload;
>         prep.datalen = plen;
>         prep.quotalen = ktype->def_datalen;
> +       prep.trusted = flags & KEY_ALLOC_TRUSTED;
>         if (ktype->preparse) {
>                 ret = ktype->preparse(&prep);
>                 if (ret < 0) {
> @@ -826,6 +829,11 @@ key_ref_t key_create_or_update(key_ref_t keyring_ref,
>                         goto error_free_prep;
>         }
>
> +       key_ref = ERR_PTR(-EPERM);
> +       if (!prep.trusted && test_bit(KEY_FLAG_TRUSTED_ONLY, &keyring->flags))
> +               goto error_free_prep;
> +       flags |= prep.trusted ? KEY_ALLOC_TRUSTED : 0;
> +
>         ret = __key_link_begin(keyring, ktype, description, &prealloc);
>         if (ret < 0) {
>                 key_ref = ERR_PTR(ret);
> diff --git a/security/keys/keyring.c b/security/keys/keyring.c
> index 6ece7f2..f18d7ff 100644
> --- a/security/keys/keyring.c
> +++ b/security/keys/keyring.c
> @@ -1006,6 +1006,10 @@ int key_link(struct key *keyring, struct key *key)
>         key_check(keyring);
>         key_check(key);
>
> +       if (test_bit(KEY_FLAG_TRUSTED_ONLY, &keyring->flags) &&
> +           !test_bit(KEY_FLAG_TRUSTED, &key->flags))
> +               return -EPERM;
> +
>         ret = __key_link_begin(keyring, key->type, key->description, &prealloc);
>         if (ret == 0) {
>                 ret = __key_link_check_live_key(keyring, key);
>

Hello,

What about the case when running from integrity protected initramfs?
Either embedded into the signed kernel, or verified by the boot loader.
In such case it is possible to assume that all keys which are added by
user space are implicitly trusted.
Later on, before continuing booting normal rootfs, set the key
subsystem state (trust-lock),
so that trusted keyrings accept only explicitly trusted keys...

Does it make sense?

- Dmitry
