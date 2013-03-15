Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585Ab3COVMx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 17:12:53 -0400
Received: from nm25-vm0.access.bullet.mail.mud.yahoo.com ([66.94.236.191]:45554
	"EHLO nm25-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754610Ab3COVMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 17:12:52 -0400
X-Yahoo-Newman-Id: 604779.52923.bm@smtp104.biz.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: Ctt6M7kVM1n.WD6D0OeNMIrIbaBUpfomZyEA7MJnj2hDEo0
 kTChIcRplF5daoZZmiALNBbK3lGCrJVWhK.TxTOdMLccCqtAOBEKUiOgtA.v
 xKDm5BeproAc.5YB0lVNI156T12GbycYeoqfMQN85t3B4S97jijXbAfTCzfM
 k_eymTGP5KxCw2EwUcMxVAv6q2yhuQBWDNdZCI2KHik5H2GDFP6JwYY6Ae1h
 wlxmWybkAKzNSmoJHGEmw8E7rMatQXxxgd.7ptOkJ6cxWLU1nClNmghdywW1
 AcF2is5wpMKnGLRizhVKguQcOz1WX73pn5MgB_N02yapPpErfi74pzQDwOBY
 XPAUB_BcIx6fE_IfQ0dgWHfDs6yp5dEeECy_.I9ErmCdFPOnxf.pV.PkvCTt
 4.Rfa8joTmQsfHV7DqFMwKu0LJWNyKzGY1TwSzsEudllJw4DCQiDbaiMQRlH
 QG6Id
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-Rocket-Received: from [192.168.0.103] (casey@50.131.111.212 with plain)
        by smtp104.biz.mail.bf1.yahoo.com with SMTP; 15 Mar 2013 14:12:50 -0700 PDT
Message-ID: <51438EDB.3050300@schaufler-ca.com>
Date: Fri, 15 Mar 2013 14:12:59 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        zohar@linux.vnet.ibm.com, dmitry.kasatkin@intel.com,
        akpm@linux-foundation.org, ebiederm@xmission.com,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH 3/4] capability: Create a new capability CAP_SIGNED
References: <1363379758-10071-1-git-send-email-vgoyal@redhat.com> <1363379758-10071-4-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1363379758-10071-4-git-send-email-vgoyal@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/15/2013 1:35 PM, Vivek Goyal wrote:
> Create a new capability CAP_SIGNED which can be given to signed executables.

This would drive anyone who is trying to use
capabilities as the privilege mechanism it is
intended to be absolutely crazy.

Capabilities aren't just random attribute bits. They
indicate that a task has permission to violate a
system policy (e.g. change the mode bits of a file
the user doesn't own). Think about how this will
interact with programs using file based capabilities.

>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  include/uapi/linux/capability.h |   12 +++++++++++-
>  kernel/cred.c                   |    7 +++++++
>  security/commoncap.c            |    2 ++
>  3 files changed, 20 insertions(+), 1 deletions(-)
>
> diff --git a/include/uapi/linux/capability.h b/include/uapi/linux/capability.h
> index ba478fa..1bbe671 100644
> --- a/include/uapi/linux/capability.h
> +++ b/include/uapi/linux/capability.h
> @@ -343,7 +343,17 @@ struct vfs_cap_data {
>  
>  #define CAP_BLOCK_SUSPEND    36
>  
> -#define CAP_LAST_CAP         CAP_BLOCK_SUSPEND
> +/*
> + * Allow certain kernel services with secureboot enabled. One of such
> + * service is sys_kexec() which can be invoked by process only if it
> + * has CAP_SIGNED capability (with secureboot enabled).
> + *
> + * This capability is given by kernel automatically if executable
> + * file is validly signed.
> + */
> +#define CAP_SIGNED    37
> +
> +#define CAP_LAST_CAP         CAP_SIGNED
>  
>  #define cap_valid(x) ((x) >= 0 && (x) <= CAP_LAST_CAP)
>  
> diff --git a/kernel/cred.c b/kernel/cred.c
> index e0573a4..f554d1b 100644
> --- a/kernel/cred.c
> +++ b/kernel/cred.c
> @@ -555,6 +555,12 @@ void revert_creds(const struct cred *old)
>  }
>  EXPORT_SYMBOL(revert_creds);
>  
> +static void remove_cap_signed_init_cred(void)
> +{
> +	cap_lower((&init_cred)->cap_bset, CAP_SIGNED);
> +	cap_lower((&init_cred)->cap_permitted, CAP_SIGNED);
> +}
> +
>  /*
>   * initialise the credentials stuff
>   */
> @@ -563,6 +569,7 @@ void __init cred_init(void)
>  	/* allocate a slab in which we can store credentials */
>  	cred_jar = kmem_cache_create("cred_jar", sizeof(struct cred),
>  				     0, SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
> +	remove_cap_signed_init_cred();
>  }
>  
>  /**
> diff --git a/security/commoncap.c b/security/commoncap.c
> index c44b6fe..4190eb9 100644
> --- a/security/commoncap.c
> +++ b/security/commoncap.c
> @@ -272,6 +272,8 @@ int cap_capset(struct cred *new,
>  	new->cap_effective   = *effective;
>  	new->cap_inheritable = *inheritable;
>  	new->cap_permitted   = *permitted;
> +	if (cap_raised(old->cap_effective, CAP_SIGNED))
> +		cap_raise(new->cap_effective, CAP_SIGNED);
>  	return 0;
>  }
>  

