Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932657AbaFIMOK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 08:14:10 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:47371 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094AbaFIMOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 08:14:08 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-ad-5395a50d372d
Message-id: <5395A4F9.1020205@samsung.com>
Date: Mon, 09 Jun 2014 15:13:45 +0300
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux-security-module <linux-security-module@vger.kernel.org>
Cc: David Howells <dhowells@redhat.com>, Josh Boyer <jwboyer@redhat.com>,
        keyrings <keyrings@linux-nfs.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v5 4/4] KEYS: define an owner trusted keyring
References: <1401818318-15780-1-git-send-email-zohar@linux.vnet.ibm.com>
 <1401818318-15780-5-git-send-email-zohar@linux.vnet.ibm.com>
In-reply-to: <1401818318-15780-5-git-send-email-zohar@linux.vnet.ibm.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Originating-IP: [106.122.1.121]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKLMWRmVeSWpSXmKPExsVy+t/xa7q8S6cGG3QdEbN41/SbxeLAuycs
	FrN3PWSxuLxrDpvFh55HbBafVkxidmDzmHZiGYvHg0ObWTze77vK5vF5k1wASxSXTUpqTmZZ
	apG+XQJXxq75/SwFN+0rdv7uY25gXGfcxcjBISFgIrH3okIXIyeQKSZx4d56ti5GLg4hgaWM
	Els+32AGSQgJNDJJLNuSA5GYxSjRdHobO0iCV0BLovvIVBaQQSwCqhKzTrGBhNkE9CQ2NP9g
	BwmLCkRIPL4gBFEtKPFj8j2wahGBLIndXf4gE5lBJj6+dYcZJC4s4CrRfDAEYlM7o8Tx9ntg
	mzgFPCV6T81hBbGZBXQk9rdOY4Ow5SU2r3kLdaaqRPfatWwQvyhKnJ58jnkCo/AsJKtnIWmf
	haR9ASPzKkbR1NLkguKk9FxDveLE3OLSvHS95PzcTYyQqPiyg3HxMatDjAIcjEo8vBmcU4OF
	WBPLiitzDzFKcDArifCGLQYK8aYkVlalFuXHF5XmpBYfYmTi4JRqYFTWCz7psGj+N+0Ji0Vm
	itw9Ob84nCEwVa6Nc+vcivVLPD5Y/mvLulN/MD3w7GTX0KKy1s77gkuN51+5ZHDv3aL0rX7e
	MrFfGc3e7//6Mfhiu9J7peQTE2dr57LNKK/hmy1Yulc70+xlzPIE9dWHQi6ePHI1W5bp6duT
	uTOVZybtUK7vUujIVFNiKc5INNRiLipOBABOm4kQaAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/14 20:58, Mimi Zohar wrote:
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

Hello,

The functionality of this entire patch can be replaced by only ~2 lines
of code in x509_request_asymmetric_key()

if (keys_ownerid || strcmp(keys_ownerid, id))
     return -EPERM;

Right?

- Dmitry


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

