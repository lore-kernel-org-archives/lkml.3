Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979AbaKCVY5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 16:24:57 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:48283 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753857AbaKCVYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 16:24:54 -0500
Message-ID: <1415049888.16140.44.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH v3 3/6] ima: load x509 certificate from the kernel
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Dmitry Kasatkin <d.kasatkin@samsung.com>
Cc: viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
        linux-security-module@vger.kernel.org,
        linux-ima-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        dmitry.kasatkin@gmail.com
Date: Mon, 03 Nov 2014 16:24:48 -0500
In-Reply-To: <23f7ccd5eb085aa1cdd6c21e10c2d1665ae92feb.1412950047.git.d.kasatkin@samsung.com>
References: <cover.1412950047.git.d.kasatkin@samsung.com>
	 <23f7ccd5eb085aa1cdd6c21e10c2d1665ae92feb.1412950047.git.d.kasatkin@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14110321-0013-0000-0000-000005FC5A35
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-10-10 at 17:09 +0300, Dmitry Kasatkin wrote: 
> Define configuration option to load X509 certificate into the
> IMA trusted kernel keyring. It implements ima_load_x509() hook
> to load X509 certificate into the .ima trusted kernel keyring
> from root filesystem.
> 
> Changes in v2:
> * added '__init'
> * use ima_policy_flag to disable appraisal to load keys
> 
> Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
> ---
>  security/integrity/ima/Kconfig    | 15 +++++++++++++++
>  security/integrity/ima/ima_init.c | 17 +++++++++++++++++
>  security/integrity/integrity.h    |  8 ++++++++
>  3 files changed, 40 insertions(+)
> 
> diff --git a/security/integrity/ima/Kconfig b/security/integrity/ima/Kconfig
> index e099875..44941c1 100644
> --- a/security/integrity/ima/Kconfig
> +++ b/security/integrity/ima/Kconfig
> @@ -131,3 +131,18 @@ config IMA_TRUSTED_KEYRING
>  	help
>  	   This option requires that all keys added to the .ima
>  	   keyring be signed by a key on the system trusted keyring.
> +
> +config IMA_LOAD_X509
> +	bool "Load X509 certificate to the '.ima' trusted keyring"
> +	depends on IMA_TRUSTED_KEYRING
> +	default n
> +	help
> +	   This option enables X509 certificate loading from the kernel
> +	   to the '.ima' trusted keyring.
> +
> +config IMA_X509_PATH
> +	string "IMA X509 certificate path"
> +	depends on IMA_LOAD_X509
> +	default "/etc/ima/x509_ima.der"

The default dracut master key (modules/97masterkey/masterkey.sh) and EVM
key (modules/98integrity/evm_enable.sh) paths are defined as /etc/keys.
Next, EVM will want something similar as this patchset.  Seems like
there should be a consistent "keys" directory.

Mimi

> +	help
> +	   This option defines IMA X509 certificate path.
> diff --git a/security/integrity/ima/ima_init.c b/security/integrity/ima/ima_init.c
> index 9164fc8..0b6c305 100644
> --- a/security/integrity/ima/ima_init.c
> +++ b/security/integrity/ima/ima_init.c
> @@ -24,6 +24,12 @@
>  #include <crypto/hash_info.h>
>  #include "ima.h"
> 
> +#ifdef CONFIG_IMA_X509_PATH
> +#define IMA_X509_PATH	CONFIG_IMA_X509_PATH
> +#else
> +#define IMA_X509_PATH	"/etc/ima/x509_ima.der"
> +#endif
> +
>  /* name for boot aggregate entry */
>  static const char *boot_aggregate_name = "boot_aggregate";
>  int ima_used_chip;
> @@ -91,6 +97,17 @@ err_out:
>  	return result;
>  }
> 
> +#ifdef CONFIG_IMA_LOAD_X509
> +void __init ima_load_x509(void)
> +{
> +	int unset_flags = ima_policy_flag & IMA_APPRAISE;
> +
> +	ima_policy_flag &= ~unset_flags;
> +	integrity_load_x509(INTEGRITY_KEYRING_IMA, IMA_X509_PATH);
> +	ima_policy_flag |= unset_flags;
> +}
> +#endif
> +
>  int __init ima_init(void)
>  {
>  	u8 pcr_i[TPM_DIGEST_SIZE];
> diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
> index 1057abb..caa1f6c 100644
> --- a/security/integrity/integrity.h
> +++ b/security/integrity/integrity.h
> @@ -162,6 +162,14 @@ static inline int asymmetric_verify(struct key *keyring, const char *sig,
>  }
>  #endif
> 
> +#ifdef CONFIG_IMA_LOAD_X509
> +void __init ima_load_x509(void);
> +#else
> +static inline void ima_load_x509(void)
> +{
> +}
> +#endif
> +
>  #ifdef CONFIG_INTEGRITY_AUDIT
>  /* declarations */
>  void integrity_audit_msg(int audit_msgno, struct inode *inode,


