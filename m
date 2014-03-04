Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071AbaCDCkF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 21:40:05 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:34888 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756021AbaCDCkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 21:40:02 -0500
Message-ID: <1393900797.10148.41.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH 8/8] evm: introduce EVM hmac xattr list
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Dmitry Kasatkin <d.kasatkin@samsung.com>
Cc: linux-security-module@vger.kernel.org, jmorris@namei.org,
        linux-kernel@vger.kernel.org, casey.schaufler@intel.com,
        dmitry.kasatkin@gmail.com
Date: Mon, 03 Mar 2014 21:39:57 -0500
In-Reply-To: <20312cf18c698d0e918bde022a76edf2705f1e17.1393599538.git.d.kasatkin@samsung.com>
References: <cover.1393599538.git.d.kasatkin@samsung.com>
	 <20312cf18c698d0e918bde022a76edf2705f1e17.1393599538.git.d.kasatkin@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14030402-0928-0000-0000-0000001C7D19
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-02-28 at 16:59 +0200, Dmitry Kasatkin wrote: 
> EVM currently uses source hard coded list of xattrs which needs to be
> included into the HMAC calculation. This is very unflexible.
> Adding new attributes requires modifcation of the source code and
> prevents building the kernel which works with previously labeled
> filesystems.
> 
> Early versions of Smack used only one xattr security.SMACK64,
> which is protected by EVM. Now Smack has a few more attributes and
> they are not protected. Adding support to the source code makes it
> impossible to use new kernel with previousely labeled filesystems.

I think this patch will break any existing filesystems labeled with
'security.smack64'.  Details inline.

> This patch replaces hardcoded xattr array with dynamic list which is
> initialized from CONFIG_EVM_HMAC_XATTRS variable. It allows to build
> kernel with with support of older and newer EVM HMAC formats.
> 
> Possible future extension will be to read xattr list from the kernel
> command line or from securityfs entry.
> 
> Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
> ---
>  security/integrity/evm/Kconfig      | 10 ++++++
>  security/integrity/evm/evm.h        |  7 +++-
>  security/integrity/evm/evm_crypto.c |  8 ++---
>  security/integrity/evm/evm_main.c   | 69 +++++++++++++++++++------------------
>  4 files changed, 55 insertions(+), 39 deletions(-)
> 
> diff --git a/security/integrity/evm/Kconfig b/security/integrity/evm/Kconfig
> index 2be51fa..06237b8 100644
> --- a/security/integrity/evm/Kconfig
> +++ b/security/integrity/evm/Kconfig
> @@ -25,3 +25,13 @@ config EVM_HMAC_ATTRS
>  	  WARNING: changing the HMAC calculation method or adding 
>  	  additional info to the calculation, requires existing EVM
>  	  labeled file systems to be relabeled.
> +
> +config EVM_HMAC_XATTRS
> +	string "HMAC xattrs"
> +	default "security.selinux security.SMACK64 security.ima security.capability"
> +	help
> +	  This options allows to specify list of extended attributes included into HMAC
> +	  calculation. It makes it possible easily upgrade to newer kernels.
> +
> +	  Default value:
> +	    security.selinux, security.SMACK64, security.ima, security.capability
> diff --git a/security/integrity/evm/evm.h b/security/integrity/evm/evm.h
> index c8fa0aa..4d1c51e 100644
> --- a/security/integrity/evm/evm.h
> +++ b/security/integrity/evm/evm.h
> @@ -31,8 +31,13 @@ extern struct crypto_shash *hash_tfm;
> 
>  #define EVM_HMAC_ATTR_FSUUID		0x0001
> 
> +struct evm_hmac_xattr {
> +	struct list_head list;
> +	char *xattr;
> +};
> +
>  /* List of EVM protected security xattrs */
> -extern char *evm_config_xattrnames[];
> +extern struct list_head evm_hmac_xattrs;
> 
>  int evm_init_key(void);
>  int evm_update_evmxattr(struct dentry *dentry,
> diff --git a/security/integrity/evm/evm_crypto.c b/security/integrity/evm/evm_crypto.c
> index ab034e5..7e5bfb7 100644
> --- a/security/integrity/evm/evm_crypto.c
> +++ b/security/integrity/evm/evm_crypto.c
> @@ -133,7 +133,7 @@ static int evm_calc_hmac_or_hash(struct dentry *dentry,
>  {
>  	struct inode *inode = dentry->d_inode;
>  	struct shash_desc *desc;
> -	char **xattrname;
> +	struct evm_hmac_xattr *entry;
>  	size_t xattr_size = 0;
>  	char *xattr_value = NULL;
>  	int error;
> @@ -146,15 +146,15 @@ static int evm_calc_hmac_or_hash(struct dentry *dentry,
>  		return PTR_ERR(desc);
> 
>  	error = -ENODATA;
> -	for (xattrname = evm_config_xattrnames; *xattrname != NULL; xattrname++) {
> +	list_for_each_entry(entry, &evm_hmac_xattrs, list) {
>  		if ((req_xattr_name && req_xattr_value)
> -		    && !strcmp(*xattrname, req_xattr_name)) {
> +		    && !strcmp(entry->xattr, req_xattr_name)) {
>  			error = 0;
>  			crypto_shash_update(desc, (const u8 *)req_xattr_value,
>  					     req_xattr_value_len);
>  			continue;
>  		}
> -		size = vfs_getxattr_alloc(dentry, *xattrname,
> +		size = vfs_getxattr_alloc(dentry, entry->xattr,
>  					  &xattr_value, xattr_size, GFP_NOFS);
>  		if (size == -ENOMEM) {
>  			error = -ENOMEM;
> diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
> index 9c05929..13e03ad 100644
> --- a/security/integrity/evm/evm_main.c
> +++ b/security/integrity/evm/evm_main.c
> @@ -34,19 +34,7 @@ char *evm_hmac = "hmac(sha1)";
>  char *evm_hash = "sha1";
>  int evm_hmac_attrs;
> 
> -char *evm_config_xattrnames[] = {
> -#ifdef CONFIG_SECURITY_SELINUX
> -	XATTR_NAME_SELINUX,
> -#endif
> -#ifdef CONFIG_SECURITY_SMACK
> -	XATTR_NAME_SMACK,
> -#endif
> -#ifdef CONFIG_IMA_APPRAISE
> -	XATTR_NAME_IMA,
> -#endif
> -	XATTR_NAME_CAPS,
> -	NULL
> -};
> +LIST_HEAD(evm_hmac_xattrs);
> 
>  static int evm_fixmode;
>  static int __init evm_set_fixmode(char *str)
> @@ -61,27 +49,53 @@ static int __init evm_init_config(void)
>  {
>  	char *attrs = CONFIG_EVM_HMAC_ATTRS;
>  	char *p;
> +	char *xattrs = CONFIG_EVM_HMAC_XATTRS;
> +	struct evm_hmac_xattr *entry;
> 
>  	while ((p = strsep(&attrs, ", \t"))) {
>  		if (!strcmp(p, "fsuuid"))
>  			evm_hmac_attrs |= EVM_HMAC_ATTR_FSUUID;
>  	}
>  	pr_info("HMAC attrs: 0x%x\n", evm_hmac_attrs);
> +	while ((p = strsep(&xattrs, ", \t"))) {
> +#ifndef CONFIG_SECURITY_SELINUX
> +		if (!strcmp(p, XATTR_NAME_SELINUX))
> +			continue;
> +#endif
> +#ifndef CONFIG_SECURITY_SMACK
> +		if (strstr(p, "SMACK64"))
> +			continue;
> +#endif

As you mentioned, filesystems previously only included
'security.smack64' in the HMAC calculation.  This patch includes all
xattrs prefixed with smack64.  All previously labeled filesystems would
need to be relabeled.

Mimi

> +#ifndef CONFIG_IMA_APPRAISE
> +		if (!strcmp(p, XATTR_NAME_IMA))
> +			continue;
> +#endif
> +		entry = kmalloc(sizeof(*entry), GFP_KERNEL);
> +		if (!entry)
> +			return -ENOMEM;
> +		INIT_LIST_HEAD(&entry->list);
> +		entry->xattr = kstrdup(p, GFP_KERNEL);
> +		if (!entry->xattr)
> +			return -ENOMEM;
> +		list_add_tail(&entry->list, &evm_hmac_xattrs);
> +	}
> +	list_for_each_entry(entry, &evm_hmac_xattrs, list)
> +		pr_info("%s\n", entry->xattr);
>  	return 0;
>  }
> 
>  static int evm_find_protected_xattrs(struct dentry *dentry)
>  {
>  	struct inode *inode = dentry->d_inode;
> -	char **xattr;
> +	struct evm_hmac_xattr *entry;
>  	int error;
>  	int count = 0;
> 
>  	if (!inode->i_op || !inode->i_op->getxattr)
>  		return -EOPNOTSUPP;
> 
> -	for (xattr = evm_config_xattrnames; *xattr != NULL; xattr++) {
> -		error = inode->i_op->getxattr(dentry, *xattr, NULL, 0);
> +	list_for_each_entry(entry, &evm_hmac_xattrs, list) {
> +		error = inode->i_op->getxattr(dentry, entry->xattr, NULL, 0);
>  		if (error < 0) {
>  			if (error == -ENODATA)
>  				continue;
> @@ -183,19 +197,19 @@ out:
> 
>  static int evm_protected_xattr(const char *req_xattr_name)
>  {
> -	char **xattrname;
> +	struct evm_hmac_xattr *entry;
>  	int namelen;
>  	int found = 0;
> 
>  	namelen = strlen(req_xattr_name);
> -	for (xattrname = evm_config_xattrnames; *xattrname != NULL; xattrname++) {
> -		if ((strlen(*xattrname) == namelen)
> -		    && (strncmp(req_xattr_name, *xattrname, namelen) == 0)) {
> +	list_for_each_entry(entry, &evm_hmac_xattrs, list) {
> +		if ((strlen(entry->xattr) == namelen)
> +		    && (strncmp(req_xattr_name, entry->xattr, namelen) == 0)) {
>  			found = 1;
>  			break;
>  		}
>  		if (strncmp(req_xattr_name,
> -			    *xattrname + XATTR_SECURITY_PREFIX_LEN,
> +			    entry->xattr + XATTR_SECURITY_PREFIX_LEN,
>  			    strlen(req_xattr_name)) == 0) {
>  			found = 1;
>  			break;
> @@ -462,19 +476,6 @@ err:
>  	return error;
>  }
> 
> -/*
> - * evm_display_config - list the EVM protected security extended attributes
> - */
> -static int __init evm_display_config(void)
> -{
> -	char **xattrname;
> -
> -	for (xattrname = evm_config_xattrnames; *xattrname != NULL; xattrname++)
> -		pr_info("%s\n", *xattrname);
> -	return 0;
> -}
> -
> -pure_initcall(evm_display_config);
>  late_initcall(init_evm);
> 
>  MODULE_DESCRIPTION("Extended Verification Module");


