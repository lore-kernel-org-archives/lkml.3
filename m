Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055AbaFJMYu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 08:24:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54018 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751248AbaFJMYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 08:24:47 -0400
Date: Tue, 10 Jun 2014 08:24:34 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Dmitry Kasatkin <d.kasatkin@samsung.com>
Cc: zohar@linux.vnet.ibm.com, dhowells@redhat.com, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmitry.kasatkin@gmail.com, mjg59@srcf.ucam.org
Subject: Re: [PATCH 1/4] KEYS: define an owner trusted keyring
Message-ID: <20140610122434.GB31944@hansolo.jdub.homelinux.org>
References: <cover.1402387862.git.d.kasatkin@samsung.com>
 <f5b4ced8a93e5d824d6bf329abda2dc9d1c8751f.1402387862.git.d.kasatkin@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f5b4ced8a93e5d824d6bf329abda2dc9d1c8751f.1402387862.git.d.kasatkin@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 11:48:15AM +0300, Dmitry Kasatkin wrote:
> From: Mimi Zohar <zohar@linux.vnet.ibm.com>
> 
> Instead of allowing public keys, with certificates signed by any
> key on the system trusted keyring, to be added to a trusted
> keyring, this patch further restricts the certificates to those
> signed by a particular key on the system keyring.
> 
> When the UEFI secure boot keys are added to the system keyring, the
> platform owner will be able to load their key in one of the UEFI DBs
> (eg. Machine Owner Key(MOK) list) and select their key, without
> having to rebuild the kernel.
> 
> This patch defines an owner trusted keyring, a new boot command
> line option 'keys_ownerid=', and defines a new function
> get_system_or_owner_trusted_keyring().
> 
> Signed-off-by: Mimi Zohar<zohar@linux.vnet.ibm.com>
> ---
>  Documentation/kernel-parameters.txt      |  5 ++
>  crypto/asymmetric_keys/x509_public_key.c |  4 +-
>  include/keys/owner_keyring.h             | 27 ++++++++++
>  init/Kconfig                             | 10 ++++
>  kernel/Makefile                          |  1 +
>  kernel/owner_keyring.c                   | 85 ++++++++++++++++++++++++++++++++
>  6 files changed, 131 insertions(+), 1 deletion(-)
>  create mode 100644 include/keys/owner_keyring.h
>  create mode 100644 kernel/owner_keyring.c
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 7116fda..f90d31d 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -1434,6 +1434,11 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>  			use the HighMem zone if it exists, and the Normal
>  			zone if it does not.
>  
> +	keys_ownerid=[KEYS] This parameter identifies a specific key on
> +			the system trusted keyring to be added to the
> +			owner trusted keyring.
> +			format: id:<keyid>
> +

I'm fairly sure this runs into the same problems I mentioned previously
in the secure boot context.  Namely that a remote attacker could modify
keys_ownerid in the bootloader config file if they gained root access.

josh

>  	kgdbdbgp=	[KGDB,HW] kgdb over EHCI usb debug port.
>  			Format: <Controller#>[,poll interval]
>  			The controller # is the number of the ehci usb debug
> diff --git a/crypto/asymmetric_keys/x509_public_key.c b/crypto/asymmetric_keys/x509_public_key.c
> index 1af8a30..6af338f 100644
> --- a/crypto/asymmetric_keys/x509_public_key.c
> +++ b/crypto/asymmetric_keys/x509_public_key.c
> @@ -19,6 +19,7 @@
>  #include <keys/asymmetric-subtype.h>
>  #include <keys/asymmetric-parser.h>
>  #include <keys/system_keyring.h>
> +#include <keys/owner_keyring.h>
>  #include <crypto/hash.h>
>  #include "asymmetric_keys.h"
>  #include "public_key.h"
> @@ -237,7 +238,8 @@ static int x509_key_preparse(struct key_preparsed_payload *prep)
>  		if (ret < 0)
>  			goto error_free_cert;
>  	} else {
> -		ret = x509_validate_trust(cert, get_system_trusted_keyring());
> +		ret = x509_validate_trust(cert,
> +					  get_system_or_owner_trusted_keyring());
>  		if (!ret)
>  			prep->trusted = 1;
>  	}
> diff --git a/include/keys/owner_keyring.h b/include/keys/owner_keyring.h
> new file mode 100644
> index 0000000..78dd09d
> --- /dev/null
> +++ b/include/keys/owner_keyring.h
> @@ -0,0 +1,27 @@
> +/* 
> + * Copyright (C) 2014 IBM Corporation
> + * Author: Mimi Zohar <zohar@us.ibm.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation, version 2 of the License.
> + */
> +
> +#ifndef _KEYS_OWNER_KEYRING_H
> +#define _KEYS_OWNER_KEYRING_H
> +
> +#ifdef CONFIG_OWNER_TRUSTED_KEYRING
> +
> +#include <linux/key.h>
> +
> +extern struct key *owner_trusted_keyring;
> +extern struct key *get_system_or_owner_trusted_keyring(void);
> +
> +#else
> +static inline struct key *get_system_or_owner_trusted_keyring(void)
> +{
> +	return get_system_trusted_keyring();
> +}
> +
> +#endif
> +#endif /* _KEYS_OWNER_KEYRING_H */
> diff --git a/init/Kconfig b/init/Kconfig
> index 009a797..7876787 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -1661,6 +1661,16 @@ config SYSTEM_TRUSTED_KEYRING
>  
>  	  Keys in this keyring are used by module signature checking.
>  
> +config OWNER_TRUSTED_KEYRING
> +	bool "Verify certificate signatures using a specific system key"
> +	depends on SYSTEM_TRUSTED_KEYRING
> +	help
> +	  Verify a certificate's signature, before adding the key to
> +	  a trusted keyring, using a specific key on the system trusted
> +	  keyring.  The specific key on the system trusted keyring is
> +	  identified using the kernel boot command line option
> +	  "keys_ownerid" and is added to the owner_trusted_keyring.
> +
>  menuconfig MODULES
>  	bool "Enable loadable module support"
>  	option modules
> diff --git a/kernel/Makefile b/kernel/Makefile
> index bc010ee..7b44efd 100644
> --- a/kernel/Makefile
> +++ b/kernel/Makefile
> @@ -44,6 +44,7 @@ obj-$(CONFIG_UID16) += uid16.o
>  obj-$(CONFIG_SYSTEM_TRUSTED_KEYRING) += system_keyring.o system_certificates.o
>  obj-$(CONFIG_MODULES) += module.o
>  obj-$(CONFIG_MODULE_SIG) += module_signing.o
> +obj-$(CONFIG_OWNER_TRUSTED_KEYRING) += owner_keyring.o
>  obj-$(CONFIG_KALLSYMS) += kallsyms.o
>  obj-$(CONFIG_BSD_PROCESS_ACCT) += acct.o
>  obj-$(CONFIG_KEXEC) += kexec.o
> diff --git a/kernel/owner_keyring.c b/kernel/owner_keyring.c
> new file mode 100644
> index 0000000..a31b865
> --- /dev/null
> +++ b/kernel/owner_keyring.c
> @@ -0,0 +1,85 @@
> +/* 
> + * Copyright (C) 2014 IBM Corporation
> + * Author: Mimi Zohar <zohar@us.ibm.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation, version 2 of the License.
> + */
> +
> +#include <linux/export.h>
> +#include <linux/kernel.h>
> +#include <linux/sched.h>
> +#include <linux/cred.h>
> +#include <linux/err.h>
> +#include <keys/asymmetric-type.h>
> +#include <keys/system_keyring.h>
> +#include "module-internal.h"
> +
> +struct key *owner_trusted_keyring;
> +static int use_owner_trusted_keyring;
> +
> +static char *owner_keyid;
> +static int __init default_owner_keyid_set(char *str)
> +{
> +	if (!str)		/* default system keyring */
> +		return 1;
> +
> +	if (strncmp(str, "id:", 3) == 0)
> +		owner_keyid = str;	/* owner local key 'id:xxxxxx' */
> +
> +	return 1;
> +}
> +
> +__setup("keys_ownerid=", default_owner_keyid_set);
> +
> +struct key *get_system_or_owner_trusted_keyring(void)
> +{
> +	return use_owner_trusted_keyring ? owner_trusted_keyring :
> +	    get_system_trusted_keyring();
> +}
> +
> +static __init int owner_trusted_keyring_init(void)
> +{
> +	pr_notice("Initialize the owner trusted keyring\n");
> +
> +	owner_trusted_keyring =
> +	    keyring_alloc(".owner_keyring",
> +			  KUIDT_INIT(0), KGIDT_INIT(0), current_cred(),
> +			  ((KEY_POS_ALL & ~KEY_POS_SETATTR) |
> +			   KEY_USR_VIEW | KEY_USR_READ | KEY_USR_SEARCH),
> +			  KEY_ALLOC_NOT_IN_QUOTA, NULL);
> +	if (IS_ERR(owner_trusted_keyring))
> +		panic("Can't allocate owner trusted keyring\n");
> +
> +	set_bit(KEY_FLAG_TRUSTED_ONLY, &owner_trusted_keyring->flags);
> +	return 0;
> +}
> +
> +device_initcall(owner_trusted_keyring_init);
> +
> +void load_owner_identified_key(void)
> +{
> +	key_ref_t key_ref;
> +	int ret;
> +
> +	if (!owner_keyid)
> +		return;
> +
> +	key_ref = keyring_search(make_key_ref(system_trusted_keyring, 1),
> +				 &key_type_asymmetric, owner_keyid);
> +	if (IS_ERR(key_ref)) {
> +		pr_warn("Request for unknown %s key\n", owner_keyid);
> +		goto out;
> +	}
> +	ret = key_link(owner_trusted_keyring, key_ref_to_ptr(key_ref));
> +	pr_info("Loaded owner key %s %s\n", owner_keyid,
> +		ret < 0 ? "failed" : "succeeded");
> +	key_ref_put(key_ref);
> +	if (!ret)
> +		use_owner_trusted_keyring = 1;
> +out:
> +	return;
> +}
> +
> +late_initcall(load_owner_identified_key);
> -- 
> 1.9.1
> 
