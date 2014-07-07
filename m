Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974AbaGGL44 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 07:56:56 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:58583 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718AbaGGL4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 07:56:53 -0400
Message-ID: <1404734207.3029.22.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH v3 1/3] ima: use ahash API for file hash calculation
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Dmitry Kasatkin <d.kasatkin@samsung.com>
Cc: linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, dmitry.kasatkin@gmail.com
Date: Mon, 07 Jul 2014 07:56:47 -0400
In-Reply-To: <dc5977267c662c98f02cd637dd44c42be850916f.1404475462.git.d.kasatkin@samsung.com>
References: <cover.1404475462.git.d.kasatkin@samsung.com>
	 <dc5977267c662c98f02cd637dd44c42be850916f.1404475462.git.d.kasatkin@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070711-1542-0000-0000-0000031690AC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-07-04 at 15:05 +0300, Dmitry Kasatkin wrote: 
> Async hash API allows to use HW acceleration for hash calculation.
> It may give significant performance gain or/and reduce power consumption,
> which might be very beneficial for battery powered devices.
> 
> This patch introduces hash calculation using ahash API.
> 
> ahash performance depends on data size and particular HW. Under certain
> limit, depending on the system, shash performance may be better.
> 
> This patch defines 'ahash_minsize' module parameter which can be used to
> define minimal file size to use with ahash. When file size is not set
> or smaller than defined by the parameter, shash will be used.
> 
> Changes in v3:
> - kernel parameter replaced with module parameter
> - pr_crit replaced with pr_crit_ratelimited
> 
> Changes in v2:
> - ima_ahash_size became as ima_ahash
> - ahash pre-allocation moved out from __init code to be able to use
>   ahash crypto modules. Ahash allocated once on the first use.
> - hash calculation falls back to shash if ahash allocation/calculation fails
> - complex initialization separated from variable declaration
> - improved comments
> 
> Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
> ---
>  Documentation/kernel-parameters.txt |   9 ++
>  security/integrity/ima/ima_crypto.c | 185 +++++++++++++++++++++++++++++++++++-
>  2 files changed, 190 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 5a214a3..03c8452 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -1318,6 +1318,15 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>  			Formats: { "ima" | "ima-ng" }
>  			Default: "ima-ng"
> 
> +	ima.ahash_minsize= [IMA] Minimum file size for asynchronous hash usage
> +			Format: <min_file_size>
> +			Set the minimal file size for using asynchronous hash.
> +			If left unspecified, ahash usage is disabled.
> +
> +			ahash performance varies for different data sizes on
> +			different crypto accelerators. This option can be used
> +			to achieve best performance for particular HW.
> +
>  	init=		[KNL]
>  			Format: <full_path>
>  			Run specified binary instead of /sbin/init as init
> diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
> index f82d1d7..bc38160 100644
> --- a/security/integrity/ima/ima_crypto.c
> +++ b/security/integrity/ima/ima_crypto.c
> @@ -16,6 +16,8 @@
>  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> 
>  #include <linux/kernel.h>
> +#include <linux/moduleparam.h>
> +#include <linux/ratelimit.h>
>  #include <linux/file.h>
>  #include <linux/crypto.h>
>  #include <linux/scatterlist.h>
> @@ -25,7 +27,18 @@
>  #include <crypto/hash_info.h>
>  #include "ima.h"
> 
> +struct ahash_completion {
> +	struct completion completion;
> +	int err;
> +};
> +
> +/* minimum file size for ahash use */
> +static unsigned long ima_ahash_minsize;
> +module_param_named(ahash_minsize, ima_ahash_minsize, ulong, 0644);
> +MODULE_PARM_DESC(ahash_minsize, "Minimum file size for ahash use");
> +
>  static struct crypto_shash *ima_shash_tfm;
> +static struct crypto_ahash *ima_ahash_tfm;
> 
>  /**
>   * ima_kernel_read - read file content
> @@ -93,9 +106,146 @@ static void ima_free_tfm(struct crypto_shash *tfm)
>  		crypto_free_shash(tfm);
>  }
> 
> -/*
> - * Calculate the MD5/SHA1 file digest
> - */
> +static struct crypto_ahash *ima_alloc_atfm(enum hash_algo algo)
> +{
> +	struct crypto_ahash *tfm = ima_ahash_tfm;
> +	int rc;
> +
> +	if ((algo != ima_hash_algo && algo < HASH_ALGO__LAST) || !tfm) {
> +		tfm = crypto_alloc_ahash(hash_algo_name[algo], 0, 0);
> +		if (!IS_ERR(tfm)) {
> +			if (algo == ima_hash_algo)
> +				ima_ahash_tfm = tfm;
> +		} else {
> +			rc = PTR_ERR(tfm);
> +			pr_err("Can not allocate %s (reason: %d)\n",
> +			       hash_algo_name[algo], rc);
> +		}
> +	}
> +	return tfm;
> +}
> +
> +static void ima_free_atfm(struct crypto_ahash *tfm)
> +{
> +	if (tfm != ima_ahash_tfm)
> +		crypto_free_ahash(tfm);
> +}
> +
> +static void ahash_complete(struct crypto_async_request *req, int err)
> +{
> +	struct ahash_completion *res = req->data;
> +
> +	if (err == -EINPROGRESS)
> +		return;
> +	res->err = err;
> +	complete(&res->completion);
> +}
> +
> +static int ahash_wait(int err, struct ahash_completion *res)
> +{
> +	switch (err) {
> +	case 0:
> +		break;
> +	case -EINPROGRESS:
> +	case -EBUSY:
> +		wait_for_completion(&res->completion);
> +		reinit_completion(&res->completion);
> +		err = res->err;
> +		/* fall through */
> +	default:
> +		pr_crit_ratelimited("ahash calculation failed: err: %d\n", err);
> +	}
> +
> +	return err;
> +}
> +
> +static int ima_calc_file_hash_atfm(struct file *file,
> +				   struct ima_digest_data *hash,
> +				   struct crypto_ahash *tfm)
> +{
> +	loff_t i_size, offset;
> +	char *rbuf;
> +	int rc, read = 0, rbuf_len;
> +	struct ahash_request *req;
> +	struct scatterlist sg[1];
> +	struct ahash_completion res;
> +
> +	hash->length = crypto_ahash_digestsize(tfm);
> +
> +	req = ahash_request_alloc(tfm, GFP_KERNEL);
> +	if (!req)
> +		return -ENOMEM;
> +
> +	init_completion(&res.completion);
> +	ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG |
> +				   CRYPTO_TFM_REQ_MAY_SLEEP,
> +				   ahash_complete, &res);
> +
> +	rc = ahash_wait(crypto_ahash_init(req), &res);
> +	if (rc)
> +		goto out1;
> +
> +	i_size = i_size_read(file_inode(file));
> +
> +	if (i_size == 0)
> +		goto out2;
> +
> +	rbuf = kzalloc(PAGE_SIZE, GFP_KERNEL);
> +	if (!rbuf) {
> +		rc = -ENOMEM;
> +		goto out1;
> +	}
> +
> +	if (!(file->f_mode & FMODE_READ)) {
> +		file->f_mode |= FMODE_READ;
> +		read = 1;
> +	}
> +
> +	for (offset = 0; offset < i_size; offset += rbuf_len) {
> +		rbuf_len = ima_kernel_read(file, offset, rbuf, PAGE_SIZE);
> +		if (rbuf_len < 0) {
> +			rc = rbuf_len;
> +			break;
> +		}
> +		if (rbuf_len == 0)
> +			break;
> +
> +		sg_init_one(&sg[0], rbuf, rbuf_len);
> +		ahash_request_set_crypt(req, sg, NULL, rbuf_len);
> +
> +		rc = ahash_wait(crypto_ahash_update(req), &res);
> +		if (rc)
> +			break;
> +	}
> +	if (read)
> +		file->f_mode &= ~FMODE_READ;
> +	kfree(rbuf);
> +out2:
> +	if (!rc) {
> +		ahash_request_set_crypt(req, NULL, hash->digest, 0);
> +		rc = ahash_wait(crypto_ahash_final(req), &res);
> +	}
> +out1:
> +	ahash_request_free(req);
> +	return rc;
> +}
> +
> +static int ima_calc_file_ahash(struct file *file, struct ima_digest_data *hash)
> +{
> +	struct crypto_ahash *tfm;
> +	int rc;
> +
> +	tfm = ima_alloc_atfm(hash->algo);
> +	if (IS_ERR(tfm))
> +		return PTR_ERR(tfm);
> +
> +	rc = ima_calc_file_hash_atfm(file, hash, tfm);
> +
> +	ima_free_atfm(tfm);
> +
> +	return rc;
> +}
> +
>  static int ima_calc_file_hash_tfm(struct file *file,
>  				  struct ima_digest_data *hash,
>  				  struct crypto_shash *tfm)
> @@ -156,7 +306,7 @@ out:
>  	return rc;
>  }
> 
> -int ima_calc_file_hash(struct file *file, struct ima_digest_data *hash)
> +static int ima_calc_file_shash(struct file *file, struct ima_digest_data *hash)
>  {
>  	struct crypto_shash *tfm;
>  	int rc;
> @@ -172,6 +322,33 @@ int ima_calc_file_hash(struct file *file, struct ima_digest_data *hash)
>  	return rc;
>  }
> 
> +/**

This is the kernel-doc delimiter.

> + * ima_calc_file_hash - calculae file hash
> + *

Missing kernel-doc argument descriptions.  Refer to
Documentation/kernel-doc-nano-HOWTO.txt.

> + * if ima_ahash_minsize parameter is non-zero, this function uses
> + * ahash for hash caclulation. ahash performance varies for different
> + * data sizes on different crypto accelerators. shash performance might
> + * be better for small file. 'ima.ahash_minsize' module parameter allows
> + * to specify the best value for the system.
> + *
> + * If ahash fails, it fallbacks to shash.
> + */
> +int ima_calc_file_hash(struct file *file, struct ima_digest_data *hash)
> +{
> +	loff_t i_size;
> +	int rc;
> +
> +	i_size = i_size_read(file_inode(file));
> +
> +	if (ima_ahash_minsize && i_size >= ima_ahash_minsize) {
> +		rc = ima_calc_file_ahash(file, hash);
> +		if (!rc)
> +			return 0;
> +	}
> +
> +	return ima_calc_file_shash(file, hash);
> +}

If the crypto accelerator fails, it falls back to using shash.  Is their
any indication that the HW error is intermittent or persistent?  Should
ima_ahash_minsize be reset?

If the crypto accelerator, built as a kernel module, is removed,
ima_ahash_minsize would still be set.  It would continue to use ahash.
Is this the correct behavior? Or should ima_ahash_minsize be reset?

thanks,

Mimi

> +
>  /*
>   * Calculate the hash of template data
>   */


