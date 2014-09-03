Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932668AbaICNQv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 09:16:51 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:34309 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932418AbaICNQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 09:16:49 -0400
Message-ID: <1409750203.21827.71.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH 7/8] ima: remove usage of filename parameter
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Dmitry Kasatkin <d.kasatkin@samsung.com>
Cc: linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmitry.kasatkin@gmail.com
Date: Wed, 03 Sep 2014 09:16:43 -0400
In-Reply-To: <33e79df19a7c5347be058864339d7698b0bd167a.1409728712.git.d.kasatkin@samsung.com>
References: <cover.1409728712.git.d.kasatkin@samsung.com>
	 <33e79df19a7c5347be058864339d7698b0bd167a.1409728712.git.d.kasatkin@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14090313-0928-0000-0000-000004993705
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-09-03 at 10:20 +0300, Dmitry Kasatkin wrote: 
> In all cases except ima_bprm_check() filename was not defined and
> ima_d_path() was used to find full path.
> 
> ima_bprm_check() used to select between bprm->interp and bprm->filename.
> Following dump demonstrates differences between using filename and interp.
> 
> bprm->filename
>  filename: ./foo.sh, pathname: /root/bin/foo.sh
>  filename: ./foo.sh, pathname: /bin/dash
> 
> bprm->interp
>  filename: ./foo.sh, pathname: /root/bin/foo.sh
>  filename: /bin/sh, pathname: /bin/dash
> 
> In both cases pathnames are the same.
> This patch removes usage of filename and interp in favor of d_path.
> 
> Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>

Thanks, this has been on my list to do.  My only concern is whether we
should be using d_path() or one of the other variants (eg.
dentry_path(), d_absolute_path()).  For namespaces, we would want to be
able to differentiate the files.

Please include in this patch description why d_path(), if it is the
case, the best option.

thanks,

Mimi

> ---
>  security/integrity/ima/ima_main.c | 19 ++++++++-----------
>  1 file changed, 8 insertions(+), 11 deletions(-)
> 
> diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
> index aaf5552..673a37e 100644
> --- a/security/integrity/ima/ima_main.c
> +++ b/security/integrity/ima/ima_main.c
> @@ -156,8 +156,8 @@ void ima_file_free(struct file *file)
>  	ima_check_last_writer(iint, inode, file);
>  }
> 
> -static int process_measurement(struct file *file, const char *filename,
> -			       int mask, int function, int opened)
> +static int process_measurement(struct file *file, int mask, int function,
> +			       int opened)
>  {
>  	struct inode *inode = file_inode(file);
>  	struct integrity_iint_cache *iint;
> @@ -218,7 +218,7 @@ static int process_measurement(struct file *file, const char *filename,
>  		goto out_digsig;
>  	}
> 
> -	pathname = filename ?: ima_d_path(&file->f_path, &pathbuf);
> +	pathname = ima_d_path(&file->f_path, &pathbuf);
> 
>  	if (action & IMA_MEASURE)
>  		ima_store_measurement(iint, file, pathname,
> @@ -254,7 +254,7 @@ out:
>  int ima_file_mmap(struct file *file, unsigned long prot)
>  {
>  	if (file && (prot & PROT_EXEC))
> -		return process_measurement(file, NULL, MAY_EXEC, MMAP_CHECK, 0);
> +		return process_measurement(file, MAY_EXEC, MMAP_CHECK, 0);
>  	return 0;
>  }
> 
> @@ -273,10 +273,7 @@ int ima_file_mmap(struct file *file, unsigned long prot)
>   */
>  int ima_bprm_check(struct linux_binprm *bprm)
>  {
> -	return process_measurement(bprm->file,
> -				   (strcmp(bprm->filename, bprm->interp) == 0) ?
> -				   bprm->filename : bprm->interp,
> -				   MAY_EXEC, BPRM_CHECK, 0);
> +	return process_measurement(bprm->file, MAY_EXEC, BPRM_CHECK, 0);
>  }
> 
>  /**
> @@ -292,7 +289,7 @@ int ima_bprm_check(struct linux_binprm *bprm)
>  int ima_file_check(struct file *file, int mask, int opened)
>  {
>  	ima_rdwr_violation_check(file);
> -	return process_measurement(file, NULL,
> +	return process_measurement(file,
>  				   mask & (MAY_READ | MAY_WRITE | MAY_EXEC),
>  				   FILE_CHECK, opened);
>  }
> @@ -317,7 +314,7 @@ int ima_module_check(struct file *file)
>  #endif
>  		return 0;	/* We rely on module signature checking */
>  	}
> -	return process_measurement(file, NULL, MAY_EXEC, MODULE_CHECK, 0);
> +	return process_measurement(file, MAY_EXEC, MODULE_CHECK, 0);
>  }
> 
>  int ima_fw_from_file(struct file *file, char *buf, size_t size)
> @@ -328,7 +325,7 @@ int ima_fw_from_file(struct file *file, char *buf, size_t size)
>  			return -EACCES;	/* INTEGRITY_UNKNOWN */
>  		return 0;
>  	}
> -	return process_measurement(file, NULL, MAY_EXEC, FIRMWARE_CHECK, 0);
> +	return process_measurement(file, MAY_EXEC, FIRMWARE_CHECK, 0);
>  }
> 
>  static int __init init_ima(void)


