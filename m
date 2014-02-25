Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453AbaBYTKM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 14:10:12 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45778 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534AbaBYTKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 14:10:08 -0500
Date: Tue, 25 Feb 2014 13:10:03 -0600
From: Serge Hallyn <serge.hallyn@ubuntu.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Serge Hallyn <serge.hallyn@canonical.com>,
        James Morris <james.l.morris@oracle.com>,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH 1/8] security: Use a more current logging style
Message-ID: <20140225191003.GB22246@sergelap>
References: <cover.1393279025.git.joe@perches.com>
 <c90a7238c10c2b243b10bc19632d3428e5bbb1fb.1393279025.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c90a7238c10c2b243b10bc19632d3428e5bbb1fb.1393279025.git.joe@perches.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Joe Perches (joe@perches.com):
> Convert printks to pr_<level>.
> Add pr_fmt to prefix output with "security: " or "capability: "
> Coalesce formats.
> Use a generic string for pr_debug to reduce object size.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---

Acked-by: Serge E. Hallyn <serge.hallyn@ubuntu.com>

Though should warn_setuid_and_fcaps_mixed be using
pr_info_once()?

>  security/capability.c | 16 +++++++++-------
>  security/commoncap.c  | 15 ++++++++-------
>  security/security.c   |  4 +++-
>  3 files changed, 20 insertions(+), 15 deletions(-)
> 
> diff --git a/security/capability.c b/security/capability.c
> index 8b4f24a..086af9b 100644
> --- a/security/capability.c
> +++ b/security/capability.c
> @@ -10,6 +10,8 @@
>   *
>   */
>  
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
>  #include <linux/security.h>
>  
>  static int cap_syslog(int type)
> @@ -914,13 +916,13 @@ static void cap_audit_rule_free(void *lsmrule)
>  #endif /* CONFIG_AUDIT */
>  
>  #define set_to_cap_if_null(ops, function)				\
> -	do {								\
> -		if (!ops->function) {					\
> -			ops->function = cap_##function;			\
> -			pr_debug("Had to override the " #function	\
> -				 " security operation with the default.\n");\
> -			}						\
> -	} while (0)
> +do {									\
> +	if (!ops->function) {						\
> +		ops->function = cap_##function;				\
> +		pr_debug("Had to override the %s security operation with the default\n", \
> +			 #function);					\
> +	}								\
> +} while (0)
>  
>  void __init security_fixup_ops(struct security_operations *ops)
>  {
> diff --git a/security/commoncap.c b/security/commoncap.c
> index b9d613e..b5c3bc4 100644
> --- a/security/commoncap.c
> +++ b/security/commoncap.c
> @@ -7,6 +7,8 @@
>   *
>   */
>  
> +#define pr_fmt(fmt) "capability: " fmt
> +
>  #include <linux/capability.h>
>  #include <linux/audit.h>
>  #include <linux/module.h>
> @@ -46,9 +48,8 @@ static void warn_setuid_and_fcaps_mixed(const char *fname)
>  {
>  	static int warned;
>  	if (!warned) {
> -		printk(KERN_INFO "warning: `%s' has both setuid-root and"
> -			" effective capabilities. Therefore not raising all"
> -			" capabilities.\n", fname);
> +		pr_info("warning: `%s' has both setuid-root and effective capabilities, therefore not raising all capabilities\n",
> +			fname);
>  		warned = 1;
>  	}
>  }
> @@ -448,8 +449,8 @@ static int get_file_caps(struct linux_binprm *bprm, bool *effective, bool *has_c
>  	rc = get_vfs_caps_from_disk(dentry, &vcaps);
>  	if (rc < 0) {
>  		if (rc == -EINVAL)
> -			printk(KERN_NOTICE "%s: get_vfs_caps_from_disk returned %d for %s\n",
> -				__func__, rc, bprm->filename);
> +			pr_notice("%s: get_vfs_caps_from_disk returned %d for %s\n",
> +				  __func__, rc, bprm->filename);
>  		else if (rc == -ENODATA)
>  			rc = 0;
>  		goto out;
> @@ -457,8 +458,8 @@ static int get_file_caps(struct linux_binprm *bprm, bool *effective, bool *has_c
>  
>  	rc = bprm_caps_from_vfs_caps(&vcaps, bprm, effective, has_cap);
>  	if (rc == -EINVAL)
> -		printk(KERN_NOTICE "%s: cap_from_disk returned %d for %s\n",
> -		       __func__, rc, bprm->filename);
> +		pr_notice("%s: cap_from_disk returned %d for %s\n",
> +			  __func__, rc, bprm->filename);
>  
>  out:
>  	dput(dentry);
> diff --git a/security/security.c b/security/security.c
> index 15b6928..53d1885 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -11,6 +11,8 @@
>   *	(at your option) any later version.
>   */
>  
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
>  #include <linux/capability.h>
>  #include <linux/dcache.h>
>  #include <linux/module.h>
> @@ -64,7 +66,7 @@ static void __init do_security_initcalls(void)
>   */
>  int __init security_init(void)
>  {
> -	printk(KERN_INFO "Security Framework initialized\n");
> +	pr_info("Security Framework initialized\n");
>  
>  	security_fixup_ops(&default_security_ops);
>  	security_ops = &default_security_ops;
> -- 
> 1.8.1.2.459.gbcd45b4.dirty
> 
