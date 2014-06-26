Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757620AbaFZL6T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 07:58:19 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:41641 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757248AbaFZL6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 07:58:09 -0400
Message-ID: <1403783882.2017.60.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH v1 3/3] ima: provide double buffering for hash
 calculation
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Dmitry Kasatkin <d.kasatkin@samsung.com>
Cc: linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmitry.kasatkin@gmail.com
Date: Thu, 26 Jun 2014 07:58:02 -0400
In-Reply-To: <ce794ff88aeda05b6b41264d64903d204c1a008b.1403191191.git.d.kasatkin@samsung.com>
References: <cover.1403191191.git.d.kasatkin@samsung.com>
	 <ce794ff88aeda05b6b41264d64903d204c1a008b.1403191191.git.d.kasatkin@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14062611-6688-0000-0000-000002D7E859
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2014-06-19 at 18:20 +0300, Dmitry Kasatkin wrote:
> Asynchronous hash API allows initiate hash calculation and perform
> other tasks while hash is calculated.
> 
> This patch introduces usage of double buffering for simultenous
							^simultaneous
> hashing and reading of the next chunk of data from the storage.
> 
> Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
> ---
>  security/integrity/ima/ima_crypto.c | 59 +++++++++++++++++++++++++++----------
>  1 file changed, 43 insertions(+), 16 deletions(-)
> 
> diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
> index 9e9414e..e6bef4b 100644
> --- a/security/integrity/ima/ima_crypto.c
> +++ b/security/integrity/ima/ima_crypto.c
> @@ -244,12 +244,12 @@ static int ima_calc_file_hash_atfm(struct file *file,
>  				   struct crypto_ahash *tfm)
>  {
>  	loff_t i_size, offset;
> -	char *rbuf;
> -	int rc, read = 0, rbuf_len;
> +	char *rbuf[2] = { NULL, };
> +	int rc, read = 0, rbuf_len, active = 0, ahash_rc = 0;
>  	struct ahash_request *req;
>  	struct scatterlist sg[1];
>  	struct ahash_completion res;
> -	size_t rbuf_size;
> +	size_t rbuf_size[2];
> 
>  	hash->length = crypto_ahash_digestsize(tfm);
> 
> @@ -275,36 +275,63 @@ static int ima_calc_file_hash_atfm(struct file *file,
>  	 * Try to allocate maximum size of memory, fail if not even single
>  	 * page cannot be allocated.
>  	 */
> -	rbuf = ima_alloc_pages(i_size, &rbuf_size, 1);
> -	if (!rbuf) {
> +	rbuf[0] = ima_alloc_pages(i_size, &rbuf_size[0], 1);
> +	if (!rbuf[0]) {
>  		rc = -ENOMEM;
>  		goto out1;
>  	}
> 
> +	/* Only allocate one buffer if that is enough. */
> +	if (i_size > rbuf_size[0]) {
> +		/*
> +		 * Try to allocate secondary buffer if that fails fallback to
> +		 * using single buffering. Use previous memory allocation size
> +		 * as baseline for possible allocation size.
> +		 */
> +		rbuf[1] = ima_alloc_pages(i_size - rbuf_size[0],
> +					  &rbuf_size[1], 0);
> +	}
> +
>  	if (!(file->f_mode & FMODE_READ)) {
>  		file->f_mode |= FMODE_READ;
>  		read = 1;
>  	}
> 
>  	for (offset = 0; offset < i_size; offset += rbuf_len) {
> -		rbuf_len = ima_kernel_read(file, offset, rbuf, PAGE_SIZE);
> -		if (rbuf_len < 0) {
> -			rc = rbuf_len;
> -			break;
> +		if (offset && !rbuf[1]) {
> +			/* wait for completion of previous request */

This comment and the same ones below don't help clarify the code.  Here,
only one buffer is available, so we're waiting for the hash calculation
to complete before reading more data.

> +			rc = ahash_wait(ahash_rc, &res);
> +			if (rc)
> +				goto out3;
> +		}
> +		/* read buffer */
> +		rbuf_len = min_t(loff_t, i_size - offset, rbuf_size[active]);
> +		rc = ima_kernel_read(file, offset, rbuf[active], rbuf_len);
> +		if (rc != rbuf_len)
> +			goto out3;
> +
> +		if (offset && rbuf[1]) {
> +			/* wait for completion of previous request */

Where as here, we finished reading more data and are waiting for the
hash calculation for the prior buffer to complete. 

Mimi

> +			rc = ahash_wait(ahash_rc, &res);
> +			if (rc)
> +				goto out3;
>  		}
> -		if (rbuf_len == 0)
> -			break;
> 
> -		sg_init_one(&sg[0], rbuf, rbuf_len);
> +		sg_init_one(&sg[0], rbuf[active], rbuf_len);
>  		ahash_request_set_crypt(req, sg, NULL, rbuf_len);
> 
> -		rc = ahash_wait(crypto_ahash_update(req), &res);
> -		if (rc)
> -			break;
> +		ahash_rc = crypto_ahash_update(req);
> +
> +		if (rbuf[1])
> +			active = !active; /* swap buffers. */
>  	}
> +	/* wait for the last request to complete */
> +	rc = ahash_wait(ahash_rc, &res);
> +out3:
>  	if (read)
>  		file->f_mode &= ~FMODE_READ;
> -	ima_free_pages(rbuf, rbuf_size);
> +	ima_free_pages(rbuf[0], rbuf_size[0]);
> +	ima_free_pages(rbuf[1], rbuf_size[1]);
>  out2:
>  	if (!rc) {
>  		ahash_request_set_crypt(req, NULL, hash->digest, 0);



