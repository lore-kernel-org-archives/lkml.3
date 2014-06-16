Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464AbaFPLnm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 07:43:42 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:44271 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbaFPLnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 07:43:39 -0400
Message-ID: <1402919013.2527.12.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH v1a 2/2] KEYS: validate certificate trust only with
 builtin keys
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Cc: dhowells@redhat.com, jwboyer@redhat.com, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dmitry Kasatkin <d.kasatkin@samsung.com>
Date: Mon, 16 Jun 2014 07:43:33 -0400
In-Reply-To: <4cf4c2546fd7c279338da9751286a034b1863cfd.1402604096.git.d.kasatkin@samsung.com>
References: <cover.1402604096.git.d.kasatkin@samsung.com>
	 <4cf4c2546fd7c279338da9751286a034b1863cfd.1402604096.git.d.kasatkin@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061611-1344-0000-0000-0000023A8991
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2014-06-12 at 23:17 +0300, Dmitry Kasatkin wrote:
> Instead of allowing public keys, with certificates signed by any
> key on the system trusted keyring, to be added to a trusted keyring,
> this patch further restricts the certificates to those signed only by
> builtin keys on the system keyring.
> 
> This patch defines a new option 'builtin' for the kernel parameter
> 'keys_ownerid' to allow trust validation using builtin keys.

Thanks, this patch works without a separate 'owned' trusted keyring, but
we need to wait until the UEFI key patches are upstreamed.

thanks,

Mimi 

> Idea belongs to Mimi Zohar.
> 
> Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
> ---
>  Documentation/kernel-parameters.txt      | 2 +-
>  crypto/asymmetric_keys/x509_public_key.c | 9 +++++++--
>  include/linux/key.h                      | 1 +
>  kernel/system_keyring.c                  | 1 +
>  4 files changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 7a810d3..336dabe 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -1437,7 +1437,7 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>  	keys_ownerid=[KEYS] This parameter identifies a specific key(s) on
>  			the system trusted keyring to be used for certificate
>  			trust validation.
> -			format: id:<keyid>
> +			format: { id:<keyid> | builtin }
> 
>  	kgdbdbgp=	[KGDB,HW] kgdb over EHCI usb debug port.
>  			Format: <Controller#>[,poll interval]
> diff --git a/crypto/asymmetric_keys/x509_public_key.c b/crypto/asymmetric_keys/x509_public_key.c
> index d46b790..c3805a8 100644
> --- a/crypto/asymmetric_keys/x509_public_key.c
> +++ b/crypto/asymmetric_keys/x509_public_key.c
> @@ -24,6 +24,7 @@
>  #include "public_key.h"
>  #include "x509_parser.h"
> 
> +static bool builtin_keys;
>  static char *owner_keyid;
>  static int __init default_owner_keyid_set(char *str)
>  {
> @@ -32,6 +33,8 @@ static int __init default_owner_keyid_set(char *str)
> 
>  	if (strncmp(str, "id:", 3) == 0)
>  		owner_keyid = str;	/* owner local key 'id:xxxxxx' */
> +	else if (strcmp(str, "builtin") == 0)
> +		builtin_keys = true;
> 
>  	return 1;
>  }
> @@ -197,8 +200,10 @@ static int x509_validate_trust(struct x509_certificate *cert,
>  					  cert->authority,
>  					  strlen(cert->authority));
>  	if (!IS_ERR(key))  {
> -		pk = key->payload.data;
> -		ret = x509_check_signature(pk, cert);
> +		if (!builtin_keys || test_bit(KEY_FLAG_BUILTIN, &key->flags)) {
> +			pk = key->payload.data;
> +			ret = x509_check_signature(pk, cert);
> +		}
>  		key_put(key);
>  	}
>  	return ret;
> diff --git a/include/linux/key.h b/include/linux/key.h
> index cd0abb8..67c8e7e 100644
> --- a/include/linux/key.h
> +++ b/include/linux/key.h
> @@ -170,6 +170,7 @@ struct key {
>  #define KEY_FLAG_INVALIDATED	7	/* set if key has been invalidated */
>  #define KEY_FLAG_TRUSTED	8	/* set if key is trusted */
>  #define KEY_FLAG_TRUSTED_ONLY	9	/* set if keyring only accepts links to trusted keys */
> +#define KEY_FLAG_BUILTIN	10	/* set if key is builtin */
> 
>  	/* the key type and key description string
>  	 * - the desc is used to match a key against search criteria
> diff --git a/kernel/system_keyring.c b/kernel/system_keyring.c
> index 52ebc70..875f64e 100644
> --- a/kernel/system_keyring.c
> +++ b/kernel/system_keyring.c
> @@ -89,6 +89,7 @@ static __init int load_system_certificate_list(void)
>  			pr_err("Problem loading in-kernel X.509 certificate (%ld)\n",
>  			       PTR_ERR(key));
>  		} else {
> +			set_bit(KEY_FLAG_BUILTIN, &key_ref_to_ptr(key)->flags);
>  			pr_notice("Loaded X.509 cert '%s'\n",
>  				  key_ref_to_ptr(key)->description);
>  			key_ref_put(key);






