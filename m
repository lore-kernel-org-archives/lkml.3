Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813AbaF3O7L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 10:59:11 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:32242 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734AbaF3O7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 10:59:06 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-69-53b17b36cf49
Message-id: <53B17AFC.80001@samsung.com>
Date: Mon, 30 Jun 2014 17:58:04 +0300
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmitry.kasatkin@gmail.com
Subject: Re: [PATCH v1 1/3] ima: use ahash API for file hash calculation
References: <cover.1403191191.git.d.kasatkin@samsung.com>
 <7b884b2597badabadf50ebf9120fe76754e1516c.1403191191.git.d.kasatkin@samsung.com>
 <1403783690.2017.58.camel@dhcp-9-2-203-236.watson.ibm.com>
In-reply-to: <1403783690.2017.58.camel@dhcp-9-2-203-236.watson.ibm.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Originating-IP: [106.122.1.121]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOLMWRmVeSWpSXmKPExsVy+t/xK7pm1RuDDRpnWlt8WVpncf/eTyaL
	lzPmsVtc3jWHzeJDzyM2i08rJjE7sHnsnHWX3ePBoc0sHrsXfGby+LxJLoAlissmJTUnsyy1
	SN8ugSvj87z3zAWT3Sru3lrA2sD40ryLkZNDQsBEYunfi6wQtpjEhXvr2boYuTiEBJYySvxe
	eRwsISTQyCSx7rYPRGIWo8Tky8fAErwCGhITr71mB7FZBFQl3h9axgRiswnoSWxo/gEWFxWI
	kDjQ9wyqXlDix+R7LCC2iICmxLHWj4wgNrPAakaJdd/EQWxhAQ+JbytvMkMsO8ko0XdpOtAg
	Dg5OAXeJxSusIerVJSbNW8QMYctLbF7zlhniUFWJ7rVr2SC+UZQ4Pfkc8wRG4VlIVs9C0j4L
	SfsCRuZVjKKppckFxUnpuUZ6xYm5xaV56XrJ+bmbGCGR8XUH49JjVocYBTgYlXh4LbZsCBZi
	TSwrrsw9xCjBwawkwnvTZ2OwEG9KYmVValF+fFFpTmrxIUYmDk6pBkbr3QtO7ny/g/fG8QCJ
	dT3VZof2nCmS+WVeZF/+7EdDYUVf0XnFUzY+gX97rQ8xX5z/LuYq5/GXWTOf+X+d6ZGi9Dio
	tvi3j9gT9/eihjnzuJcGnxfcruCXHJZov/G7cd+61giHbcVXw/s1XaRfcGT90Leu0gqWNd5T
	aKNxQvDyNLaFLhWXHiqxFGckGmoxFxUnAgACQgJVagIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/06/14 14:54, Mimi Zohar wrote:
> On Thu, 2014-06-19 at 18:20 +0300, Dmitry Kasatkin wrote:
>> Async hash API allows to use HW acceleration for hash calculation.
>> It may give significant performance gain or/and reduce power consumption,
>> which might be very beneficial for battery powered devices.
>>
>> This patch introduces hash calculation using ahash API.
>>
>> ahash peformance depends on data size and particular HW. Under certain
>> limit, depending on the system, shash performance may be better.
>>
>> This patch also introduces 'ima_ahash_size' kernel parameter which can
>> be used to defines minimal data size to use with ahash. When this
>> parameter is not set or file size is smaller than defined by this
>> parameter, shash will be used. Thus, by defult, original shash
>> implementation is used.
>>
>> Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
>> ---
>>  Documentation/kernel-parameters.txt |   3 +
>>  security/integrity/ima/ima_crypto.c | 182 +++++++++++++++++++++++++++++++++++-
>>  2 files changed, 181 insertions(+), 4 deletions(-)
>>
>> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
>> index a0c155c..f8efb01 100644
>> --- a/Documentation/kernel-parameters.txt
>> +++ b/Documentation/kernel-parameters.txt
>> @@ -1286,6 +1286,9 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>>  	ihash_entries=	[KNL]
>>  			Set number of hash buckets for inode cache.
>>
>> +	ima_ahash_size=size [IMA]
>> +			Set the minimal file size when use ahash API.
>> +
>>  	ima_appraise=	[IMA] appraise integrity measurements
>>  			Format: { "off" | "enforce" | "fix" }
>>  			default: "enforce"
>> diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
>> index ccd0ac8..b7a8650 100644
>> --- a/security/integrity/ima/ima_crypto.c
>> +++ b/security/integrity/ima/ima_crypto.c
>> @@ -25,7 +25,25 @@
>>  #include <crypto/hash_info.h>
>>  #include "ima.h"
>>
>> +
>> +struct ahash_completion {
>> +	struct completion completion;
>> +	int err;
>> +};
>> +
>>  static struct crypto_shash *ima_shash_tfm;
>> +static struct crypto_ahash *ima_ahash_tfm;
>> +
>> +/* data size for ahash use */
>> +static loff_t ima_ahash_size;
>> +
>> +static int __init ima_ahash_setup(char *str)
>> +{
>> +	int rc = kstrtoll(str, 10, &ima_ahash_size);
> In general, variable definitions should be separated from code.  A
> simple initialization is fine.  Please separate variable definitions
> from code with a blank line. 
>
>> +	pr_info("ima_ahash_size = %lld\n", ima_ahash_size);
>> +	return !rc;
>> +}
>> +__setup("ima_ahash_size=", ima_ahash_setup);
> This boot parameter name doesn't reflect its purpose, defining the
> minimum file size for using ahash. The next patch defines an additional
> boot parameter ima_ahash_bufsize. Perhaps defining a single boot
> parameter (eg. ima_ahash=) with multiple fields would be better. 
>
>>  /**
>>   * ima_kernel_read - read file content
>> @@ -68,6 +86,14 @@ int ima_init_crypto(void)
>>  		       hash_algo_name[ima_hash_algo], rc);
>>  		return rc;
>>  	}
>> +	ima_ahash_tfm = crypto_alloc_ahash(hash_algo_name[ima_hash_algo], 0, 0);
>> +	if (IS_ERR(ima_ahash_tfm)) {
>> +		rc = PTR_ERR(ima_ahash_tfm);
>> +		crypto_free_shash(ima_shash_tfm);
> Only crypto_alloc_ahash() failed, not crypto_alloc_shash(). shash has
> worked fine up to now. Why require both shash and ahash to succeed? 


>> +		pr_err("Can not allocate %s (reason: %ld)\n",
>> +		       hash_algo_name[ima_hash_algo], rc);
>> +		return rc;
>> +	}
>>  	return 0;
>>  }
>>
>> @@ -93,9 +119,143 @@ static void ima_free_tfm(struct crypto_shash *tfm)
>>  		crypto_free_shash(tfm);
>>  }
>>
>> -/*
>> - * Calculate the MD5/SHA1 file digest
>> - */
>> +static struct crypto_ahash *ima_alloc_atfm(enum hash_algo algo)
>> +{
>> +	struct crypto_ahash *tfm = ima_ahash_tfm;
>> +	int rc;
>> +
>> +	if (algo != ima_hash_algo && algo < HASH_ALGO__LAST) {
>> +		tfm = crypto_alloc_ahash(hash_algo_name[algo], 0, 0);
>> +		if (IS_ERR(tfm)) {
>> +			rc = PTR_ERR(tfm);
>> +			pr_err("Can not allocate %s (reason: %d)\n",
>> +			       hash_algo_name[algo], rc);
>> +		}
>> +	}
>> +	return tfm;
>> +}
>> +
>> +static void ima_free_atfm(struct crypto_ahash *tfm)
>> +{
>> +	if (tfm != ima_ahash_tfm)
>> +		crypto_free_ahash(tfm);
>> +}
>> +
>> +static void ahash_complete(struct crypto_async_request *req, int err)
>> +{
>> +	struct ahash_completion *res = req->data;
>> +
>> +	if (err == -EINPROGRESS)
>> +		return;
>> +	res->err = err;
>> +	complete(&res->completion);
>> +}
>> +
>> +static int ahash_wait(int err, struct ahash_completion *res)
>> +{
>> +	switch (err) {
>> +	case 0:
>> +		break;
>> +	case -EINPROGRESS:
>> +	case -EBUSY:
>> +		wait_for_completion(&res->completion);
>> +		reinit_completion(&res->completion);
>> +		err = res->err;
>> +		/* fall through */
>> +	default:
>> +		pr_crit("ahash calculation failed: err: %d\n", err);
>> +	}
>> +
>> +	return err;
>> +}
>> +
>> +static int ima_calc_file_hash_atfm(struct file *file,
>> +				   struct ima_digest_data *hash,
>> +				   struct crypto_ahash *tfm)
>> +{
>> +	loff_t i_size, offset;
>> +	char *rbuf;
>> +	int rc, read = 0, rbuf_len;
>> +	struct ahash_request *req;
>> +	struct scatterlist sg[1];
>> +	struct ahash_completion res;
>> +
>> +	hash->length = crypto_ahash_digestsize(tfm);
>> +
>> +	req = ahash_request_alloc(ima_ahash_tfm, GFP_KERNEL);
> This should be tfm not ima_ahash_tfm.
>
>> +	if (!req)
>> +		return -ENOMEM;
>> +
>> +	init_completion(&res.completion);
>> +	ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG |
>> +				   CRYPTO_TFM_REQ_MAY_SLEEP,
>> +				   ahash_complete, &res);
>> +
>> +	rc = ahash_wait(crypto_ahash_init(req), &res);
>> +	if (rc)
>> +		goto out1;
>> +
>> +	i_size = i_size_read(file_inode(file));
>> +
>> +	if (i_size == 0)
>> +		goto out2;
>> +
>> +	rbuf = kzalloc(PAGE_SIZE, GFP_KERNEL);
>> +	if (!rbuf) {
>> +		rc = -ENOMEM;
>> +		goto out1;
>> +	}
>> +
>> +	if (!(file->f_mode & FMODE_READ)) {
>> +		file->f_mode |= FMODE_READ;
>> +		read = 1;
>> +	}
>> +
>> +	for (offset = 0; offset < i_size; offset += rbuf_len) {
>> +		rbuf_len = ima_kernel_read(file, offset, rbuf, PAGE_SIZE);
>> +		if (rbuf_len < 0) {
>> +			rc = rbuf_len;
>> +			break;
>> +		}
>> +		if (rbuf_len == 0)
>> +			break;
>> +
>> +		sg_init_one(&sg[0], rbuf, rbuf_len);
>> +		ahash_request_set_crypt(req, sg, NULL, rbuf_len);
>> +
>> +		rc = ahash_wait(crypto_ahash_update(req), &res);
>> +		if (rc)
>> +			break;
>> +	}
>> +	if (read)
>> +		file->f_mode &= ~FMODE_READ;
>> +	kfree(rbuf);
>> +out2:
>> +	if (!rc) {
>> +		ahash_request_set_crypt(req, NULL, hash->digest, 0);
>> +		rc = ahash_wait(crypto_ahash_final(req), &res);
>> +	}
>> +out1:
>> +	ahash_request_free(req);
>> +	return rc;
>> +}
>> +
>> +static int ima_calc_file_ahash(struct file *file, struct ima_digest_data *hash)
>> +{
>> +	struct crypto_ahash *tfm;
>> +	int rc;
>> +
>> +	tfm = ima_alloc_atfm(hash->algo);
>> +	if (IS_ERR(tfm))
>> +		return PTR_ERR(tfm);
>> +
>> +	rc = ima_calc_file_hash_atfm(file, hash, tfm);
>> +
>> +	ima_free_atfm(tfm);
>> +
>> +	return rc;
>> +}
>> +
>>  static int ima_calc_file_hash_tfm(struct file *file,
>>  				  struct ima_digest_data *hash,
>>  				  struct crypto_shash *tfm)
>> @@ -156,7 +316,7 @@ out:
>>  	return rc;
>>  }
>>
>> -int ima_calc_file_hash(struct file *file, struct ima_digest_data *hash)
>> +static int ima_calc_file_shash(struct file *file, struct ima_digest_data *hash)
>>  {
>>  	struct crypto_shash *tfm;
>>  	int rc;
>> @@ -172,6 +332,20 @@ int ima_calc_file_hash(struct file *file, struct ima_digest_data *hash)
>>  	return rc;
>>  }
>>
>> +int ima_calc_file_hash(struct file *file, struct ima_digest_data *hash)
>> +{
>> +	loff_t i_size = i_size_read(file_inode(file));
>> +
>> +	/* shash is more efficient small data
>> +	 * ahash performance depends on data size and particular HW
>> +	 * ima_ahash_size allows to specify the best value for the system
>> +	 */
>> +	if (ima_ahash_size && i_size >= ima_ahash_size)
>> +		return ima_calc_file_ahash(file, hash);
>> +	else
>> +		return ima_calc_file_shash(file, hash);
>> +}
> If calculating the file hash using ahash fails, should it fall back to
> using shash?

If ahash fails, then it could be a HW error, which should not happen.
IF HW fails device is broken.

Do you really want to fallback to shash?

Thanks,

Dmitry

> Mimi
>
>>  /*
>>   * Calculate the hash of template data
>>   */
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

