Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932700Ab3BKWKW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 17:10:22 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:35411 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932253Ab3BKWKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 17:10:20 -0500
Message-ID: <1360620614.3524.223.camel@falcor1.watson.ibm.com>
Subject: Re: [PATCH 2/2] ima: Support appraise_type=imasig_optional
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 11 Feb 2013 17:10:14 -0500
In-Reply-To: <1360613493-11969-3-git-send-email-vgoyal@redhat.com>
References: <1360613493-11969-1-git-send-email-vgoyal@redhat.com>
	 <1360613493-11969-3-git-send-email-vgoyal@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13021122-5806-0000-0000-00001F7D064A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-02-11 at 15:11 -0500, Vivek Goyal wrote:
> appraise_type=imasig_optional will allow appraisal to pass even if no
> signatures are present on the file. If signatures are present, then it
> has to be valid digital signature, otherwise appraisal will fail.
> 
> This can allow to selectively sign executables in the system and based
> on appraisal results, signed executables with valid signatures can be
> given extra capability to perform priviliged operations in secureboot
> mode.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Thanks, Vivek, the patch looks a lot better.  Here are a couple of
suggestions:  
- the patch description needs to start with the problem description, not
the solution.
- the patch name should reflect the problem.

A few comments are inline below.

thanks,

Mimi

> ---
>  Documentation/ABI/testing/ima_policy  |    2 +-
>  security/integrity/ima/ima_appraise.c |   24 +++++++++++++++++++-----
>  security/integrity/ima/ima_policy.c   |    2 ++
>  security/integrity/integrity.h        |    1 +
>  4 files changed, 23 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/ABI/testing/ima_policy b/Documentation/ABI/testing/ima_policy
> index de16de3..5ca0c23 100644
> --- a/Documentation/ABI/testing/ima_policy
> +++ b/Documentation/ABI/testing/ima_policy
> @@ -30,7 +30,7 @@ Description:
>  			uid:= decimal value
>  			fowner:=decimal value
>  		lsm:  	are LSM specific
> -		option:	appraise_type:= [imasig]
> +		option:	appraise_type:= [imasig] | [imasig_optional]
> 
>  		default policy:
>  			# PROC_SUPER_MAGIC
> diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
> index 3710f44..222ade0 100644
> --- a/security/integrity/ima/ima_appraise.c
> +++ b/security/integrity/ima/ima_appraise.c
> @@ -124,19 +124,26 @@ int ima_appraise_measurement(int func, struct integrity_iint_cache *iint,
>  	enum integrity_status status = INTEGRITY_UNKNOWN;
>  	const char *op = "appraise_data";
>  	char *cause = "unknown";
> -	int rc;
> +	int rc, audit_info = 0;
> 
>  	if (!ima_appraise)
>  		return 0;
> -	if (!inode->i_op->getxattr)
> +	if (!inode->i_op->getxattr) {
> +		/* getxattr not supported. file couldn't have been signed */
> +		if (iint->flags & IMA_DIGSIG_OPTIONAL)
> +			return INTEGRITY_PASS;
>  		return INTEGRITY_UNKNOWN;
> +	}
> 

Please don't change the result of the appraisal like this.  A single
change can be made towards the bottom of process_measurement().

>  	rc = vfs_getxattr_alloc(dentry, XATTR_NAME_IMA, (char **)&xattr_value,
>  				0, GFP_NOFS);
>  	if (rc <= 0) {
>  		/* File system does not support security xattr */
> -		if (rc == -EOPNOTSUPP)
> +		if (rc == -EOPNOTSUPP) {
> +			if (iint->flags & IMA_DIGSIG_OPTIONAL)
> +				return INTEGRITY_PASS;
>  			return INTEGRITY_UNKNOWN;
> +		}

ditto 

> 
>  		if (rc && rc != -ENODATA)
>  			goto out;
> @@ -158,7 +165,8 @@ int ima_appraise_measurement(int func, struct integrity_iint_cache *iint,
>  	}
>  	switch (xattr_value->type) {
>  	case IMA_XATTR_DIGEST:
> -		if (iint->flags & IMA_DIGSIG_REQUIRED) {
> +		if (iint->flags & IMA_DIGSIG_REQUIRED ||
> +		    iint->flags & IMA_DIGSIG_OPTIONAL) {
>  			cause = "IMA signature required";
>  			status = INTEGRITY_FAIL;
>  			break;
> @@ -201,8 +209,14 @@ out:
>  			if (!ima_fix_xattr(dentry, iint))
>  				status = INTEGRITY_PASS;
>  		}
> +		if (status == INTEGRITY_NOLABEL &&
> +		    iint->flags & IMA_DIGSIG_OPTIONAL) {
> +			status = INTEGRITY_PASS;
> +			/* Don't flood audit logs with skipped appraise */
> +			audit_info = 1;
> +		}
>  		integrity_audit_msg(AUDIT_INTEGRITY_DATA, inode, filename,
> -				    op, cause, rc, 0);
> +				    op, cause, rc, audit_info);
>  	} else {
>  		ima_cache_flags(iint, func);
>  	}
> diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
> index 4adcd0f..8b8cd5f 100644
> --- a/security/integrity/ima/ima_policy.c
> +++ b/security/integrity/ima/ima_policy.c
> @@ -598,6 +598,8 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
>  			ima_log_string(ab, "appraise_type", args[0].from);
>  			if ((strcmp(args[0].from, "imasig")) == 0)
>  				entry->flags |= IMA_DIGSIG_REQUIRED;
> +			else if ((strcmp(args[0].from, "imasig_optional")) == 0)
> +				entry->flags |= IMA_DIGSIG_OPTIONAL;

By setting IMA_DIGSIG_REQUIRED, here, as well, you'll be able to clean
up the code a bit more.

>  			else
>  				result = -EINVAL;
>  			break;
> diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
> index 84c37c4..2ba736b 100644
> --- a/security/integrity/integrity.h
> +++ b/security/integrity/integrity.h
> @@ -30,6 +30,7 @@
>  #define IMA_ACTION_FLAGS	0xff000000
>  #define IMA_DIGSIG		0x01000000
>  #define IMA_DIGSIG_REQUIRED	0x02000000
> +#define IMA_DIGSIG_OPTIONAL	0x04000000
> 
>  #define IMA_DO_MASK		(IMA_MEASURE | IMA_APPRAISE | IMA_AUDIT | \
>  				 IMA_APPRAISE_SUBMASK)



