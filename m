Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751919AbaGOOCJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 10:02:09 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:53170 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbaGOOCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 10:02:06 -0400
Message-ID: <1405432915.21720.22.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH v1 2/3] evm: skip integrity verification for newly
 created files
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Dmitry Kasatkin <d.kasatkin@samsung.com>
Cc: linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        dmitry.kasatkin@gmail.com
Date: Tue, 15 Jul 2014 10:01:55 -0400
In-Reply-To: <5e9ede3ece0eb19bf5468826ea05aed5d8207cf1.1405078844.git.d.kasatkin@samsung.com>
References: <cover.1405078844.git.d.kasatkin@samsung.com>
	 <5e9ede3ece0eb19bf5468826ea05aed5d8207cf1.1405078844.git.d.kasatkin@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14071514-8236-0000-0000-000003DA4BAB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-07-11 at 14:47 +0300, Dmitry Kasatkin wrote: 
> Newly created files do not get initial security.ima until close.
> Setting xattr value before close fails because EVM fails to verify
> integrity due to missing xattrs. Following is the example when it
> happens:
>   fd = open("foo", O_CREAT | O_WRONLY, 0644);
>   setxattr("foo", "security.SMACK64", value, sizeof(value), 0);
>   close(fd);
> 
> This patch skips integrity verification if IMA_NEW_FILE flag is set.

Right, unless the LSM initially created the security xattr at
d_instantiate(), security.evm will not have been created.

Mimi

> 
> Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
> ---
>  security/integrity/evm/evm_main.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
> index 3bcb80d..682e640 100644
> --- a/security/integrity/evm/evm_main.c
> +++ b/security/integrity/evm/evm_main.c
> @@ -248,10 +248,14 @@ EXPORT_SYMBOL_GPL(evm_verifyxattr);
>  static enum integrity_status evm_verify_current_integrity(struct dentry *dentry)
>  {
>  	struct inode *inode = dentry->d_inode;
> +	struct integrity_iint_cache *iint;
> 
>  	if (!evm_initialized || !S_ISREG(inode->i_mode) || evm_fixmode)
>  		return 0;
> -	return evm_verify_hmac(dentry, NULL, NULL, 0, NULL);
> +	iint = integrity_iint_find(inode);
> +	if (iint && (iint->flags & IMA_NEW_FILE))
> +		return 0;
> +	return evm_verify_hmac(dentry, NULL, NULL, 0, iint);
>  }
> 
>  /*


