Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780AbaI2QOk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 12:14:40 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:53413 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605AbaI2QOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 12:14:39 -0400
Message-ID: <1412007271.3508.46.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH 1/4] evm: skip replacing EVM signature with HMAC on
 read-only filesystem
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-ima-devel@lists.sourceforge.net, dmitry.kasatkin@gmail.com,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Joe Perches <joe@perches.com>, Andy Whitcroft <apw@canonical.com>,
        Greg KH <gregkh@linuxfoundation.org>
Date: Mon, 29 Sep 2014 12:14:31 -0400
In-Reply-To: <aa21c2c52e3cd17825be21aa29ca88019296a712.1411560295.git.d.kasatkin@samsung.com>
References: <cover.1411560295.git.d.kasatkin@samsung.com>
	 <aa21c2c52e3cd17825be21aa29ca88019296a712.1411560295.git.d.kasatkin@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14092916-1542-0000-0000-00000530B33A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-09-24 at 15:07 +0300, Dmitry Kasatkin wrote: 
> If filesystem is mounted read-only or file is immutable, updating
> xattr will fail. This is a usual case during early boot until
> filesystem is remount read-write. This patch verifies conditions
> to skip unnecessary attempt to calculate HMAC and set xattr.
> 
> Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
> ---
>  security/integrity/evm/evm_main.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
> index 9685af3..a30be77 100644
> --- a/security/integrity/evm/evm_main.c
> +++ b/security/integrity/evm/evm_main.c
> @@ -162,9 +162,14 @@ static enum integrity_status evm_verify_hmac(struct dentry *dentry,
>  					(const char *)xattr_data, xattr_len,
>  					calc.digest, sizeof(calc.digest));
>  		if (!rc) {
> -			/* we probably want to replace rsa with hmac here */
> -			evm_update_evmxattr(dentry, xattr_name, xattr_value,
> -				   xattr_value_len);
> +			/* Replace RSA with HMAC if not mounted readonly and
> +			 * not immutable
> +			 */
> +			if (!IS_RDONLY(dentry->d_inode) &&
> +					!IS_IMMUTABLE(dentry->d_inode))

Previously patches conformed to Lindent, unless there was a valid reason
not to use it, like conflicting with checkpatch.pl.  Joe Perches
submitted a patch to remove it from the Documentation/CodingStyle a
while ago -  https://lkml.org/lkml/2013/2/11/390 and recommends using
"checkpatch.pl --fix" instead.

Andrew, Greg, what is the current best practice?

thanks,

Mimi

> +				evm_update_evmxattr(dentry, xattr_name,
> +						    xattr_value,
> +						    xattr_value_len);
>  		}
>  		break;
>  	default:


