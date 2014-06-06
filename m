Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752450AbaFFVxm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 17:53:42 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:44915 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901AbaFFVxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 17:53:40 -0400
MIME-Version: 1.0
In-Reply-To: <1401818318-15780-4-git-send-email-zohar@linux.vnet.ibm.com>
References: <1401818318-15780-1-git-send-email-zohar@linux.vnet.ibm.com>
	<1401818318-15780-4-git-send-email-zohar@linux.vnet.ibm.com>
Date: Sat, 7 Jun 2014 00:53:38 +0300
Message-ID: <CACE9dm_o6RLvn9vP9X9BXGB1mFjC3Y7G15dZKqGsh+iZ3cFy5Q@mail.gmail.com>
Subject: Re: [RFC PATCH v5 3/4] ima: define '.ima' as a builtin 'trusted' keyring
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
> Require all keys added to the IMA keyring be signed by an
> existing trusted key on the system trusted keyring.
>
> Changelog v5:
> - Move integrity_init_keyring() to init_ima() - Dmitry
> - reset keyring[id] on failure - Dmitry
>
> Changelog v1:
> - don't link IMA trusted keyring to user keyring
>
> Changelog:
> - define stub integrity_init_keyring() function (reported-by Fengguang Wu)
> - differentiate between regular and trusted keyring names.
> - replace printk with pr_info (D. Kasatkin)
> - only make the IMA keyring a trusted keyring (reported-by D. Kastatkin)
> - define stub integrity_init_keyring() definition based on
>   CONFIG_INTEGRITY_SIGNATURE, not CONFIG_INTEGRITY_ASYMMETRIC_KEYS.
>   (reported-by Jim Davis)
>
> Signed-off-by: Mimi Zohar<zohar@linux.vnet.ibm.com>
> ---
>  security/integrity/digsig.c       | 26 ++++++++++++++++++++++++++
>  security/integrity/ima/Kconfig    |  8 ++++++++
>  security/integrity/ima/ima_main.c | 12 ++++++++++--
>  security/integrity/integrity.h    |  5 +++++
>  4 files changed, 49 insertions(+), 2 deletions(-)
>
> diff --git a/security/integrity/digsig.c b/security/integrity/digsig.c
> index b4af4eb..fa4c2fd 100644
> --- a/security/integrity/digsig.c
> +++ b/security/integrity/digsig.c
> @@ -13,7 +13,9 @@
>  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>
>  #include <linux/err.h>
> +#include <linux/sched.h>
>  #include <linux/rbtree.h>
> +#include <linux/cred.h>
>  #include <linux/key-type.h>
>  #include <linux/digsig.h>
>
> @@ -24,7 +26,11 @@ static struct key *keyring[INTEGRITY_KEYRING_MAX];
>  static const char *keyring_name[INTEGRITY_KEYRING_MAX] = {
>         "_evm",
>         "_module",
> +#ifndef CONFIG_IMA_TRUSTED_KEYRING
>         "_ima",
> +#else
> +       ".ima",
> +#endif
>  };
>
>  int integrity_digsig_verify(const unsigned int id, const char *sig, int siglen,
> @@ -56,3 +62,23 @@ int integrity_digsig_verify(const unsigned int id, const char *sig, int siglen,
>
>         return -EOPNOTSUPP;
>  }
> +
> +int integrity_init_keyring(const unsigned int id)
> +{
> +       const struct cred *cred = current_cred();
> +
> +       keyring[id] = keyring_alloc(keyring_name[id], KUIDT_INIT(0),
> +                                   KGIDT_INIT(0), cred,
> +                                   ((KEY_POS_ALL & ~KEY_POS_SETATTR) |
> +                                     KEY_USR_VIEW | KEY_USR_READ |
> +                                     KEY_USR_WRITE | KEY_USR_SEARCH),
> +                                   KEY_ALLOC_NOT_IN_QUOTA, NULL);
> +       if (!IS_ERR(keyring[id]))
> +               set_bit(KEY_FLAG_TRUSTED_ONLY, &keyring[id]->flags);
> +       else {
> +               pr_info("Can't allocate %s keyring (%ld)\n",
> +                       keyring_name[id], PTR_ERR(keyring[id]));
> +               keyring[id] = NULL;
> +       }
> +       return 0;
> +}
> diff --git a/security/integrity/ima/Kconfig b/security/integrity/ima/Kconfig
> index 81a2797..dad8d4c 100644
> --- a/security/integrity/ima/Kconfig
> +++ b/security/integrity/ima/Kconfig
> @@ -123,3 +123,11 @@ config IMA_APPRAISE
>           For more information on integrity appraisal refer to:
>           <http://linux-ima.sourceforge.net>
>           If unsure, say N.
> +
> +config IMA_TRUSTED_KEYRING
> +       bool "Require all keys on the _ima keyring be signed"
> +       depends on IMA_APPRAISE && SYSTEM_TRUSTED_KEYRING
> +       default y
> +       help
> +          This option requires that all keys added to the _ima
> +          keyring be signed by a key on the system trusted keyring.
> diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
> index 09baa33..4c60cc5 100644
> --- a/security/integrity/ima/ima_main.c
> +++ b/security/integrity/ima/ima_main.c
> @@ -328,8 +328,16 @@ static int __init init_ima(void)
>
>         hash_setup(CONFIG_IMA_DEFAULT_HASH);
>         error = ima_init();
> -       if (!error)
> -               ima_initialized = 1;
> +       if (error)
> +               goto out;
> +
> +#ifdef CONFIG_IMA_TRUSTED_KEYRING
> +       error = integrity_init_keyring(INTEGRITY_KEYRING_IMA);
> +       if (error)
> +               goto out;
> +#endif

integrity_init_keyring() has variation in header file...
Why do you need #ifdef in .c file? You you usually do not like it...

- Dmitry

> +       ima_initialized = 1;
> +out:
>         return error;
>  }
>
> diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
> index 33c0a70..09c440d 100644
> --- a/security/integrity/integrity.h
> +++ b/security/integrity/integrity.h
> @@ -124,6 +124,7 @@ struct integrity_iint_cache *integrity_iint_find(struct inode *inode);
>  int integrity_digsig_verify(const unsigned int id, const char *sig, int siglen,
>                             const char *digest, int digestlen);
>
> +int integrity_init_keyring(const unsigned int id);
>  #else
>
>  static inline int integrity_digsig_verify(const unsigned int id,
> @@ -133,6 +134,10 @@ static inline int integrity_digsig_verify(const unsigned int id,
>         return -EOPNOTSUPP;
>  }
>
> +static inline int integrity_init_keyring(const unsigned int id)
> +{
> +       return 0;
> +}
>  #endif /* CONFIG_INTEGRITY_SIGNATURE */
>
>  #ifdef CONFIG_INTEGRITY_ASYMMETRIC_KEYS
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
