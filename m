Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603AbaCCNpv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 08:45:51 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:51201 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102AbaCCNps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 08:45:48 -0500
Message-ID: <1393854343.32410.18.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH 3/8] ima: return d_name.name if d_path fails
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Dmitry Kasatkin <d.kasatkin@samsung.com>
Cc: linux-security-module@vger.kernel.org, jmorris@namei.org,
        linux-kernel@vger.kernel.org, casey.schaufler@intel.com,
        dmitry.kasatkin@gmail.com
Date: Mon, 03 Mar 2014 08:45:43 -0500
In-Reply-To: <16a69bfbb1b120e0f9520fdbc5422bc6e2f811c3.1393599538.git.d.kasatkin@samsung.com>
References: <cover.1393599538.git.d.kasatkin@samsung.com>
	 <16a69bfbb1b120e0f9520fdbc5422bc6e2f811c3.1393599538.git.d.kasatkin@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14030313-7164-0000-0000-0000068E7A69
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-02-28 at 16:59 +0200, Dmitry Kasatkin wrote: 
> Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>

Nice refactoring.  Please add a patch description.

Mimi 
> ---
>  security/integrity/ima/ima_api.c  | 2 +-
>  security/integrity/ima/ima_main.c | 7 +------
>  2 files changed, 2 insertions(+), 7 deletions(-)
> 
> diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
> index c6b4a73..ba9e4d7 100644
> --- a/security/integrity/ima/ima_api.c
> +++ b/security/integrity/ima/ima_api.c
> @@ -332,5 +332,5 @@ const char *ima_d_path(struct path *path, char **pathbuf)
>  			pathname = NULL;
>  		}
>  	}
> -	return pathname;
> +	return pathname ?: (const char *)path->dentry->d_name.name;
>  }
> diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
> index 50413d0..52ac6cf 100644
> --- a/security/integrity/ima/ima_main.c
> +++ b/security/integrity/ima/ima_main.c
> @@ -79,7 +79,6 @@ __setup("ima_hash=", hash_setup);
>   */
>  static void ima_rdwr_violation_check(struct file *file)
>  {
> -	struct dentry *dentry = file->f_path.dentry;
>  	struct inode *inode = file_inode(file);
>  	fmode_t mode = file->f_mode;
>  	int must_measure;
> @@ -111,8 +110,6 @@ out:
>  		return;
> 
>  	pathname = ima_d_path(&file->f_path, &pathbuf);
> -	if (!pathname || strlen(pathname) > IMA_EVENT_NAME_LEN_MAX)
> -		pathname = dentry->d_name.name;
> 
>  	if (send_tomtou)
>  		ima_add_violation(file, pathname, "invalid_pcr", "ToMToU");
> @@ -220,9 +217,7 @@ static int process_measurement(struct file *file, const char *filename,
>  	if (rc != 0)
>  		goto out_digsig;
> 
> -	pathname = !filename ? ima_d_path(&file->f_path, &pathbuf) : filename;
> -	if (!pathname)
> -		pathname = (const char *)file->f_dentry->d_name.name;
> +	pathname = filename ?: ima_d_path(&file->f_path, &pathbuf);
> 
>  	if (action & IMA_MEASURE)
>  		ima_store_measurement(iint, file, pathname,


