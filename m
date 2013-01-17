Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756287Ab3AQS5l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 13:57:41 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:36870 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755841Ab3AQS5j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 13:57:39 -0500
Message-ID: <1358449049.2689.87.camel@falcor1>
Subject: Re: [PATCH 2/3] KEYS: Separate the kernel signature checking
 keyring from module signing
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: dmitry.kasatkin@intel.com, linux-kernel@vger.kernel.org,
        keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        linux-crypto@vger.kernel.org
Date: Thu, 17 Jan 2013 13:57:29 -0500
In-Reply-To: <20130117180400.27885.2973.stgit@warthog.procyon.org.uk>
References: <20130117180352.27885.79893.stgit@warthog.procyon.org.uk>
	 <20130117180400.27885.2973.stgit@warthog.procyon.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011718-7182-0000-0000-00000485D975
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-01-17 at 18:04 +0000, David Howells wrote:
> Separate the kernel signature checking keyring from module signing so that it
> can be used by code other than the module-signing code.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>

Sounds good, but comment below...

> ---
> 
>  init/Kconfig                 |   13 +++++
>  kernel/Makefile              |   17 ++++---
>  kernel/modsign_certificate.S |   18 -------
>  kernel/modsign_pubkey.c      |  104 ------------------------------------------
>  kernel/module-internal.h     |    2 -
>  kernel/module_signing.c      |    3 +
>  kernel/system_certificates.S |   18 +++++++
>  kernel/system_keyring.c      |  101 +++++++++++++++++++++++++++++++++++++++++
>  8 files changed, 145 insertions(+), 131 deletions(-)
>  delete mode 100644 kernel/modsign_certificate.S
>  delete mode 100644 kernel/modsign_pubkey.c
>  create mode 100644 kernel/system_certificates.S
>  create mode 100644 kernel/system_keyring.c
> 
> 
> diff --git a/init/Kconfig b/init/Kconfig
> index 7d30240..a5363d2 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -1568,6 +1568,18 @@ config BASE_SMALL
>  	default 0 if BASE_FULL
>  	default 1 if !BASE_FULL
> 
> +config SYSTEM_TRUSTED_KEYRING
> +	bool "Provide system-wide ring of trusted keys"
> +	select KEYS
> +	help
> +	  Provide a system keyring to which trusted keys can be added.  Keys in
> +	  the keyring are considered to be trusted.  Keys may be added at will
> +	  by the kernel from compiled-in data and from hardware key stores, but
> +	  userspace may only add extra keys if those keys can be verified by
> +	  keys already in the keyring.
> +

Lets assume accepting built in keys should is acceptable for all use
cases.  Adding additional keys from userspace is probably not acceptable
for all use cases.  Those keys should be added to specific 'trusted'
keyrings.

EVM and IMA-appraisal have separate keyrings for this reason.  I might
be interested in allowing third party packages to be installed and
executed, but that doesn't imply that a security.evm extended attribute,
signed by a third party application, is acceptable.

thanks,

Mimi

