Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751364AbaENXqU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 19:46:20 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:49747 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbaENXqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 19:46:16 -0400
Message-ID: <1400111124.6068.85.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH 17/20] ima: make IMA policy replaceable at runtime
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Dmitry Kasatkin <d.kasatkin@samsung.com>
Cc: dhowells@redhat.com, jmorris@namei.org, roberto.sassu@polito.it,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 14 May 2014 19:45:24 -0400
In-Reply-To: <37308b997a49c67605cd1357a34c8cb6738ecd3e.1398259638.git.d.kasatkin@samsung.com>
References: <cover.1398259638.git.d.kasatkin@samsung.com>
	 <37308b997a49c67605cd1357a34c8cb6738ecd3e.1398259638.git.d.kasatkin@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14051423-1542-0000-0000-000001CF1606
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-04-23 at 16:30 +0300, Dmitry Kasatkin wrote: 
> This patch provides functionality to replace the IMA policy at runtime.
> 
> By default, the IMA policy can be successfully updated only once,
> but with this patch when the kernel configuration option
> CONFIG_IMA_POLICY_REPLACEABLE is enabled, the IMA policy can be replaced
> multiple times at runtime.
> 
> Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>

I have a couple of concerns with replacing the IMA policy.

- Currently opened files might now be in policy, that previously
weren't.  Do these files need to be measured, appraised, or audited?
These files could have been modified, but the 'security.ima' xattr
hasn't been updated yet. In such cases, appraisal would fail.

- At minimum, after replacing the policy, the iint cache entry flags
need to be reset.

Please provide the motivation for such a use case scenario.

Mimi

> ---
>  security/integrity/ima/Kconfig      |  8 ++++++++
>  security/integrity/ima/ima_fs.c     |  2 ++
>  security/integrity/ima/ima_policy.c | 23 +++++++++++++++++++----
>  3 files changed, 29 insertions(+), 4 deletions(-)
> 
> diff --git a/security/integrity/ima/Kconfig b/security/integrity/ima/Kconfig
> index b00044f..b60a315 100644
> --- a/security/integrity/ima/Kconfig
> +++ b/security/integrity/ima/Kconfig
> @@ -160,3 +160,11 @@ config IMA_KERNEL_POLICY
>  	default n
>  	help
>  	  This option enables IMA policy loading from the kernel.
> +
> +config IMA_POLICY_REPLACEABLE
> +	bool "Allows to replace policy at runtime"
> +	depends on IMA_POLICY_LOADER
> +	default n
> +	help
> +	  Enabling this option allows to replace policy at runtime.
> +	  Only signed policy is allowed.
> diff --git a/security/integrity/ima/ima_fs.c b/security/integrity/ima/ima_fs.c
> index d050a5c..b4144b4 100644
> --- a/security/integrity/ima/ima_fs.c
> +++ b/security/integrity/ima/ima_fs.c
> @@ -304,11 +304,13 @@ static int ima_open_policy(struct inode *inode, struct file *filp)
>  		return -EACCES;
>  	if (test_and_set_bit(IMA_FS_BUSY, &ima_fs_flags))
>  		return -EBUSY;
> +#ifndef CONFIG_IMA_POLICY_REPLACEABLE
>  	if (!ima_default_policy()) {
>  		/* policy was already set*/
>  		clear_bit(IMA_FS_BUSY, &ima_fs_flags);
>  		return -EACCES;
>  	}
> +#endif
>  	return 0;
>  }
> 
> diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
> index c6da801..981e953 100644
> --- a/security/integrity/ima/ima_policy.c
> +++ b/security/integrity/ima/ima_policy.c
> @@ -108,11 +108,14 @@ static struct ima_rule_entry default_appraise_rules[] = {
> 
>  static LIST_HEAD(ima_default_rules);
>  static LIST_HEAD(ima_policy_rules);
> +static LIST_HEAD(ima_active_rules);
>  static struct list_head *ima_rules;
>  static bool path_rules;
> 
>  static DEFINE_MUTEX(ima_rules_mutex);
> 
> +static void ima_do_delete_rules(struct list_head *rules);
> +
>  static bool ima_use_tcb __initdata;
>  static int __init default_measure_policy_setup(char *str)
>  {
> @@ -367,7 +370,14 @@ void ima_update_policy(void)
>  	int result = 0;
>  	int audit_info = 0;
> 
> -	ima_rules = &ima_policy_rules;
> +	if (ima_default_policy()) {
> +		/* set new policy head */
> +		ima_rules = &ima_active_rules;
> +	} else {
> +		/* FIXME: must be protected by lock */
> +		ima_do_delete_rules(ima_rules);
> +	}
> +	list_replace_init(&ima_policy_rules, ima_rules);
> 
>  	integrity_audit_msg(AUDIT_INTEGRITY_STATUS, NULL,
>  			    NULL, op, cause, result, audit_info);
> @@ -734,14 +744,14 @@ ssize_t ima_parse_add_rule(char *rule)
>  	return len;
>  }
> 
> -/* ima_delete_rules called to cleanup invalid policy */
> -void ima_delete_rules(void)
> +/* ima_delete_rules called to cleanup invalid or old policy */
> +static void ima_do_delete_rules(struct list_head *rules)
>  {
>  	struct ima_rule_entry *entry, *tmp;
>  	int i;
> 
>  	mutex_lock(&ima_rules_mutex);
> -	list_for_each_entry_safe(entry, tmp, &ima_policy_rules, list) {
> +	list_for_each_entry_safe(entry, tmp, rules, list) {
>  		for (i = 0; i < MAX_LSM_RULES; i++)
>  			kfree(entry->lsm[i].args_p);
> 
> @@ -751,6 +761,11 @@ void ima_delete_rules(void)
>  	mutex_unlock(&ima_rules_mutex);
>  }
> 
> +void ima_delete_rules(void)
> +{
> +	ima_do_delete_rules(&ima_policy_rules);
> +}
> +
>  #ifdef CONFIG_IMA_POLICY_LOADER
> 
>  ssize_t ima_read_policy(char *path)


