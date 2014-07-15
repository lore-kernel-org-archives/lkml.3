Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751553AbaGOOMQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 10:12:16 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:58407 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbaGOOMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 10:12:12 -0400
Message-ID: <1405432827.21720.20.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH v1 1/3] ima: provide flag to identify new empty files
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Dmitry Kasatkin <d.kasatkin@samsung.com>
Cc: linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        dmitry.kasatkin@gmail.com
Date: Tue, 15 Jul 2014 10:00:27 -0400
In-Reply-To: <ac60392e0118902ce9b308fdae09d633da1682af.1405078844.git.d.kasatkin@samsung.com>
References: <cover.1405078844.git.d.kasatkin@samsung.com>
	 <ac60392e0118902ce9b308fdae09d633da1682af.1405078844.git.d.kasatkin@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14071514-8236-0000-0000-000003DA5EFD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-07-11 at 14:46 +0300, Dmitry Kasatkin wrote: 
> Newly created empty files do not get initial security.ima
> value because iversion does not change. It can be checked from
> the shell as:
> 
>   $ (exec >foo)
>   $ getfattr -h -e hex -d -m security foo
> 
> This patch defines IMA_NEW_FILE flag which is set when IMA detects that new
> file is created. It is checked upon ima_file_free hook to set initial
> security.ima value.

Other than rebasing on top of #next, this patch set looks good.

thanks,

Mimi

> Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>

> ---
>  security/integrity/ima/ima_appraise.c |  7 +++++--
>  security/integrity/ima/ima_main.c     | 12 +++++++-----
>  security/integrity/integrity.h        |  1 +
>  3 files changed, 13 insertions(+), 7 deletions(-)
> 
> diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
> index 9dd18b5..3a4beb3 100644
> --- a/security/integrity/ima/ima_appraise.c
> +++ b/security/integrity/ima/ima_appraise.c
> @@ -194,8 +194,11 @@ int ima_appraise_measurement(int func, struct integrity_iint_cache *iint,
>  			goto out;
> 
>  		cause = "missing-hash";
> -		status =
> -		    (inode->i_size == 0) ? INTEGRITY_PASS : INTEGRITY_NOLABEL;
> +		status = INTEGRITY_NOLABEL;
> +		if (inode->i_size == 0) {
> +			iint->flags |= IMA_NEW_FILE;
> +			status = INTEGRITY_PASS;
> +		}
>  		goto out;
>  	}
> 
> diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
> index e51e0d5..5a870e7 100644
> --- a/security/integrity/ima/ima_main.c
> +++ b/security/integrity/ima/ima_main.c
> @@ -124,11 +124,13 @@ static void ima_check_last_writer(struct integrity_iint_cache *iint,
>  		return;
> 
>  	mutex_lock(&iint->mutex);
> -	if (atomic_read(&inode->i_writecount) == 1 &&
> -	    iint->version != inode->i_version) {
> -		iint->flags &= ~IMA_DONE_MASK;
> -		if (iint->flags & IMA_APPRAISE)
> -			ima_update_xattr(iint, file);
> +	if (atomic_read(&inode->i_writecount) == 1) {
> +		if ((iint->version != inode->i_version) ||
> +		    (iint->flags & IMA_NEW_FILE)) {
> +			iint->flags &= ~(IMA_DONE_MASK | IMA_NEW_FILE);
> +			if (iint->flags & IMA_APPRAISE)
> +				ima_update_xattr(iint, file);
> +		}
>  	}
>  	mutex_unlock(&iint->mutex);
>  }
> diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
> index 92c1083..7656d47 100644
> --- a/security/integrity/integrity.h
> +++ b/security/integrity/integrity.h
> @@ -30,6 +30,7 @@
>  #define IMA_ACTION_FLAGS	0xff000000
>  #define IMA_DIGSIG_REQUIRED	0x01000000
>  #define IMA_PERMIT_DIRECTIO	0x02000000
> +#define IMA_NEW_FILE		0x04000000
> 
>  #define IMA_DO_MASK		(IMA_MEASURE | IMA_APPRAISE | IMA_AUDIT | \
>  				 IMA_APPRAISE_SUBMASK)


