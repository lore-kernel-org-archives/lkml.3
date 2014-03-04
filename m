Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060AbaCDCDY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 21:03:24 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:60311 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756044AbaCDCDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 21:03:20 -0500
Message-ID: <1393898595.10148.21.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH 5/8] ima: skip memory allocation for empty files
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Dmitry Kasatkin <d.kasatkin@samsung.com>
Cc: linux-security-module@vger.kernel.org, jmorris@namei.org,
        linux-kernel@vger.kernel.org, casey.schaufler@intel.com,
        dmitry.kasatkin@gmail.com
Date: Mon, 03 Mar 2014 21:03:15 -0500
In-Reply-To: <3402bee04915e67f3d6c9db797edef0616d64d56.1393599538.git.d.kasatkin@samsung.com>
References: <cover.1393599538.git.d.kasatkin@samsung.com>
	 <3402bee04915e67f3d6c9db797edef0616d64d56.1393599538.git.d.kasatkin@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14030402-8236-0000-0000-0000006759EE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-02-28 at 16:59 +0200, Dmitry Kasatkin wrote: 
> Memory allocation is unnecessary for empty files.
> This patch finalize the hash without memory allocation.
> 
> Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>

Thanks.

Mimi 
> ---
>  security/integrity/ima/ima_crypto.c | 20 ++++++++++++--------
>  1 file changed, 12 insertions(+), 8 deletions(-)
> 
> diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
> index d257e36..1bde8e6 100644
> --- a/security/integrity/ima/ima_crypto.c
> +++ b/security/integrity/ima/ima_crypto.c
> @@ -87,16 +87,20 @@ static int ima_calc_file_hash_tfm(struct file *file,
>  	if (rc != 0)
>  		return rc;
> 
> -	rbuf = kzalloc(PAGE_SIZE, GFP_KERNEL);
> -	if (!rbuf) {
> -		rc = -ENOMEM;
> +	i_size = i_size_read(file_inode(file));
> +
> +	if (i_size == 0)
>  		goto out;
> -	}
> +
> +	rbuf = kzalloc(PAGE_SIZE, GFP_KERNEL);
> +	if (!rbuf)
> +		return -ENOMEM;
> +
>  	if (!(file->f_mode & FMODE_READ)) {
>  		file->f_mode |= FMODE_READ;
>  		read = 1;
>  	}
> -	i_size = i_size_read(file_inode(file));
> +
>  	while (offset < i_size) {
>  		int rbuf_len;
> 
> @@ -113,12 +117,12 @@ static int ima_calc_file_hash_tfm(struct file *file,
>  		if (rc)
>  			break;
>  	}
> -	kfree(rbuf);
> -	if (!rc)
> -		rc = crypto_shash_final(&desc.shash, hash->digest);
>  	if (read)
>  		file->f_mode &= ~FMODE_READ;
> +	kfree(rbuf);
>  out:
> +	if (!rc)
> +		rc = crypto_shash_final(&desc.shash, hash->digest);
>  	return rc;
>  }
> 


