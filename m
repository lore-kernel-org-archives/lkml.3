Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708AbaJMRdc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 13:33:32 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:49447 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945AbaJMRd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 13:33:29 -0400
Message-ID: <1413221603.13530.18.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH v3 5/6] ima: require signature based appraisal
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Dmitry Kasatkin <d.kasatkin@samsung.com>
Cc: viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
        linux-security-module@vger.kernel.org,
        linux-ima-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        dmitry.kasatkin@gmail.com
Date: Mon, 13 Oct 2014 13:33:23 -0400
In-Reply-To: <4dd050e33e489d3b563075a9ea4e3d15675f6550.1412950047.git.d.kasatkin@samsung.com>
References: <cover.1412950047.git.d.kasatkin@samsung.com>
	 <4dd050e33e489d3b563075a9ea4e3d15675f6550.1412950047.git.d.kasatkin@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14101317-0013-0000-0000-0000058129FD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-10-10 at 17:09 +0300, Dmitry Kasatkin wrote: 
> This patch provides kernel parameter CONFIG_IMA_APPRAISE_SIGNED_INIT
> to force IMA appraisal using signatures. This is useful, when EVM key
> is not initalized yet and we want securely initialize integrity or any
> other functionality.

Instead of "kernel parameter", I think you meant "config option".  A new
kernel parameter would need to be documented in
Documentation/kernel-parameters.

Mimi

> It forces embedded policy to require signature. Signed initialization
> script can initialize EVM key, update the IMA policy and change further
> requirement of everything to be signed.
> 
> Changes in v2:
> * policy change of this patch separated from the key loading patch
> 
> Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
> ---
>  security/integrity/ima/Kconfig      | 7 +++++++
>  security/integrity/ima/ima_policy.c | 5 +++++
>  2 files changed, 12 insertions(+)
> 
> diff --git a/security/integrity/ima/Kconfig b/security/integrity/ima/Kconfig
> index 44941c1..6a1971f 100644
> --- a/security/integrity/ima/Kconfig
> +++ b/security/integrity/ima/Kconfig
> @@ -146,3 +146,10 @@ config IMA_X509_PATH
>  	default "/etc/ima/x509_ima.der"
>  	help
>  	   This option defines IMA X509 certificate path.
> +
> +config IMA_APPRAISE_SIGNED_INIT
> +	bool "Require signed user-space initialization"
> +	depends on IMA_LOAD_X509
> +	default n
> +	help
> +	   This option requires user-space init to be signed.
> diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
> index 0d14d25..222ff79 100644
> --- a/security/integrity/ima/ima_policy.c
> +++ b/security/integrity/ima/ima_policy.c
> @@ -100,7 +100,12 @@ static struct ima_rule_entry default_appraise_rules[] = {
>  	{.action = DONT_APPRAISE, .fsmagic = SECURITYFS_MAGIC, .flags = IMA_FSMAGIC},
>  	{.action = DONT_APPRAISE, .fsmagic = SELINUX_MAGIC, .flags = IMA_FSMAGIC},
>  	{.action = DONT_APPRAISE, .fsmagic = CGROUP_SUPER_MAGIC, .flags = IMA_FSMAGIC},
> +#ifndef CONFIG_IMA_APPRAISE_SIGNED_INIT
>  	{.action = APPRAISE, .fowner = GLOBAL_ROOT_UID, .flags = IMA_FOWNER},
> +#else
> +	/* force signature */
> +	{.action = APPRAISE, .fowner = GLOBAL_ROOT_UID, .flags = IMA_FOWNER | IMA_DIGSIG_REQUIRED},
> +#endif
>  };
> 
>  static LIST_HEAD(ima_default_rules);


