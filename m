Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552Ab3JaIb1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 04:31:27 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:63915 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408Ab3JaIbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 04:31:23 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f4-b7f0a6d000007b1b-1f-52721558ff71
Message-id: <5272153D.4080801@samsung.com>
Date: Thu, 31 Oct 2013 10:30:53 +0200
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.0
To: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ima: define '_ima' as a builtin 'trusted' keyring
References: <1383159291.5434.18.camel@dhcp-9-2-203-236.watson.ibm.com>
In-reply-to: <1383159291.5434.18.camel@dhcp-9-2-203-236.watson.ibm.com>
Content-transfer-encoding: 8bit
X-Originating-IP: [106.122.1.121]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFLMWRmVeSWpSXmKPExsVy+t/xq7oRokVBBu2HZSzeNf1msbi8aw6b
	xYeeR2wWn1ZMYnZg8XhwaDOLx/t9V9k8Pm+SC2CO4rJJSc3JLEst0rdL4MqYeXINU8FkvYp3
	ixYyNTDOUe1i5OSQEDCR+Ld2HyuELSZx4d56ti5GLg4hgaWMEmseLGAGSfAKCEr8mHyPBcRm
	FlCXmDRvEVhcSKCRSWLFYk2IhrmMEvfOH2OCaNCS2Hm3H6yBRUBV4smR6WA2m4CexIbmH+wg
	tqhAmMTRpp+sIM0iAhMZJbYdbWSD2KAvsWX1BkYQW1jATeLK4x1Q29wkPndfBKvhFHCXeLP3
	NzNEvbzEwSvPWSBqVCW6165lg3hHUeL05HPMExiFZyF5YhaSJ2YhaV/AyLyKUTS1NLmgOCk9
	11CvODG3uDQvXS85P3cTIyT8v+xgXHzM6hCjAAejEg8vg25hkBBrYllxZe4hRgkOZiUR3uPc
	RUFCvCmJlVWpRfnxRaU5qcWHGJk4OKUaGIuPhEzs31HEL1YWx/dx+5/jQdvSm9hi9oodVNJ6
	6cn1dW+7lSd/zvF/GhMdtq1an1HW9cJykyfr6wBLoV0nU9/dUuCe9mAJU+kKOe251mWmkxo4
	Nq3YXpazY9f/M2tfbH/EKxz54NXBWt/C82XtOtP/3wlP7Fs28xp/t2CNmffB4IX+JZmCu5RY
	ijMSDbWYi4oTAdrGQXJdAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/10/13 20:54, Mimi Zohar wrote:
> Require all keys added to the IMA keyring be signed by an
> existing trusted key on the system trusted keyring.
>
> Changelog:
> - define stub integrity_init_keyring() function (reported-by Fengguang Wu)
> - differentiate between regular and trusted keyring names.
> - replace printk with pr_info (D. Kasatkin)
>
> Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
> ---
>  security/integrity/digsig.c           | 30 +++++++++++++++++++++++++++++-
>  security/integrity/ima/Kconfig        |  8 ++++++++
>  security/integrity/ima/ima_appraise.c | 11 +++++++++++
>  security/integrity/integrity.h        |  7 +++++++
>  4 files changed, 55 insertions(+), 1 deletion(-)
>
> diff --git a/security/integrity/digsig.c b/security/integrity/digsig.c
> index b4af4eb..77ca965 100644
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
> @@ -21,11 +23,19 @@
>  
>  static struct key *keyring[INTEGRITY_KEYRING_MAX];
>  
> +#ifdef CONFIG_IMA_TRUSTED_KEYRING
> +static const char *keyring_name[INTEGRITY_KEYRING_MAX] = {
> +	".evm",
> +	".module",
> +	".ima",
> +};
> +#else
>  static const char *keyring_name[INTEGRITY_KEYRING_MAX] = {
>  	"_evm",
>  	"_module",
>  	"_ima",
>  };
> +#endif

Hello,

I am not sure if having 2 different names "_" and "." makes sense.

Setting trusted-only makes sense until we will get support of setting
trusted only from user-space using keyctl...

David, do you remember our discussion in Edinburgh?
Can you provide a way to set keyring as trusted-only from user space..

Motivation...

In many embedded systems, initramfs is built into the ker​​nel image.
Kernel image is signed and obviously initramfs as well..
Or initramfs may be signed separately like in my prototype implementation...

Note that non-x86 systems - embedded, mobile, etc has no UEFI, MOK.
Initial keys cannot be verified. (we should not rely on using kernel
modules key)
Thus keys on the protected initramfs may not be required to be signed..

It must be a way to add "initial keys" from user-space...
This is like "setting initial trust"..
This kind of functionality also useful for ".system" keyring itself.


- Dmitry

>  
>  int integrity_digsig_verify(const unsigned int id, const char *sig, int siglen,
>  			    const char *digest, int digestlen)
> @@ -35,7 +45,7 @@ int integrity_digsig_verify(const unsigned int id, const char *sig, int siglen,
>  
>  	if (!keyring[id]) {
>  		keyring[id] =
> -			request_key(&key_type_keyring, keyring_name[id], NULL);
> +		    request_key(&key_type_keyring, keyring_name[id], NULL);
>  		if (IS_ERR(keyring[id])) {
>  			int err = PTR_ERR(keyring[id]);
>  			pr_err("no %s keyring: %d\n", keyring_name[id], err);
> @@ -56,3 +66,21 @@ int integrity_digsig_verify(const unsigned int id, const char *sig, int siglen,
>  
>  	return -EOPNOTSUPP;
>  }
> +
> +int integrity_init_keyring(const unsigned int id)
> +{
> +	const struct cred *cred = current_cred();
> +	const struct user_struct *user = cred->user;
> +
> +	keyring[id] = keyring_alloc(keyring_name[id], KUIDT_INIT(0),
> +				    KGIDT_INIT(0), cred,
> +				    ((KEY_POS_ALL & ~KEY_POS_SETATTR) |
> +				     KEY_USR_VIEW | KEY_USR_READ),
> +				    KEY_ALLOC_NOT_IN_QUOTA, user->uid_keyring);
> +	if (!IS_ERR(keyring[id]))
> +		set_bit(KEY_FLAG_TRUSTED_ONLY, &keyring[id]->flags);
> +	else
> +		pr_info("Can't allocate %s keyring (%ld)\n",
> +			keyring_name[id], PTR_ERR(keyring[id]));
> +	return 0;
> +}
> diff --git a/security/integrity/ima/Kconfig b/security/integrity/ima/Kconfig
> index 81a2797..dad8d4c 100644
> --- a/security/integrity/ima/Kconfig
> +++ b/security/integrity/ima/Kconfig
> @@ -123,3 +123,11 @@ config IMA_APPRAISE
>  	  For more information on integrity appraisal refer to:
>  	  <http://linux-ima.sourceforge.net>
>  	  If unsure, say N.
> +
> +config IMA_TRUSTED_KEYRING
> +	bool "Require all keys on the _ima keyring be signed"
> +	depends on IMA_APPRAISE && SYSTEM_TRUSTED_KEYRING
> +	default y
> +	help
> +	   This option requires that all keys added to the _ima
> +	   keyring be signed by a key on the system trusted keyring.
> diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
> index 734e946..46353ee 100644
> --- a/security/integrity/ima/ima_appraise.c
> +++ b/security/integrity/ima/ima_appraise.c
> @@ -381,3 +381,14 @@ int ima_inode_removexattr(struct dentry *dentry, const char *xattr_name)
>  	}
>  	return result;
>  }
> +
> +#ifdef CONFIG_IMA_TRUSTED_KEYRING
> +static int __init init_ima_keyring(void)
> +{
> +	int ret;
> +
> +	ret = integrity_init_keyring(INTEGRITY_KEYRING_IMA);
> +	return 0;
> +}
> +late_initcall(init_ima_keyring);
> +#endif
> diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
> index 2fb5e53..b9e7c13 100644
> --- a/security/integrity/integrity.h
> +++ b/security/integrity/integrity.h
> @@ -137,12 +137,19 @@ static inline int integrity_digsig_verify(const unsigned int id,
>  #ifdef CONFIG_INTEGRITY_ASYMMETRIC_KEYS
>  int asymmetric_verify(struct key *keyring, const char *sig,
>  		      int siglen, const char *data, int datalen);
> +
> +int integrity_init_keyring(const unsigned int id);
>  #else
>  static inline int asymmetric_verify(struct key *keyring, const char *sig,
>  				    int siglen, const char *data, int datalen)
>  {
>  	return -EOPNOTSUPP;
>  }
> +
> +static int integrity_init_keyring(const unsigned int id)
> +{
> +	return 0;
> +}
>  #endif
>  
>  #ifdef CONFIG_INTEGRITY_AUDIT

