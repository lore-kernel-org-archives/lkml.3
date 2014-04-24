Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343AbaDXVF2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 17:05:28 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:42351 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754272AbaDXVFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 17:05:22 -0400
Message-ID: <1398373468.3395.83.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH 12/20] ima: provide buffer hash calculation function
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Dmitry Kasatkin <d.kasatkin@samsung.com>
Cc: dhowells@redhat.com, jmorris@namei.org, roberto.sassu@polito.it,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 24 Apr 2014 17:04:28 -0400
In-Reply-To: <1b9253e91b214bb67d4fdd9297f9734d7c4cb6cc.1398259638.git.d.kasatkin@samsung.com>
References: <cover.1398259638.git.d.kasatkin@samsung.com>
	 <1b9253e91b214bb67d4fdd9297f9734d7c4cb6cc.1398259638.git.d.kasatkin@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042421-3532-0000-0000-0000014AAAE1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-04-23 at 16:30 +0300, Dmitry Kasatkin wrote: 
> This patch provides convenient buffer hash calculation function.
> 
> Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>

Where/how is it being used?  We normally don't upstream a new function
without it being used.  Is the usage in another patch?

Mimi

> ---
>  security/integrity/ima/ima.h        |  1 +
>  security/integrity/ima/ima_crypto.c | 11 +++++++++--
>  2 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
> index f4c1e8dd..a5d5ccb 100644
> --- a/security/integrity/ima/ima.h
> +++ b/security/integrity/ima/ima.h
> @@ -98,6 +98,7 @@ int ima_add_template_entry(struct ima_template_entry *entry, int violation,
>  			   const char *op, struct inode *inode,
>  			   const unsigned char *filename);
>  int ima_calc_file_hash(struct file *file, struct ima_digest_data *hash);
> +int ima_calc_buffer_hash(const void *buf, int len, struct ima_digest_data *hash);
>  int ima_calc_field_array_hash(struct ima_field_data *field_data,
>  			      struct ima_template_desc *desc, int num_fields,
>  			      struct ima_digest_data *hash);
> diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
> index 139e7f7..50c78c0 100644
> --- a/security/integrity/ima/ima_crypto.c
> +++ b/security/integrity/ima/ima_crypto.c
> @@ -434,13 +434,13 @@ static int ima_calc_field_array_hash_tfm(struct ima_field_data *field_data,
>  		u8 *data_to_hash = field_data[i].data;
>  		u32 datalen = field_data[i].len;
> 
> -		if (strcmp(td->name, IMA_TEMPLATE_IMA_NAME) != 0) {
> +		if (td && strcmp(td->name, IMA_TEMPLATE_IMA_NAME) != 0) {
>  			rc = crypto_shash_update(&desc.shash,
>  						(const u8 *) &field_data[i].len,
>  						sizeof(field_data[i].len));
>  			if (rc)
>  				break;
> -		} else if (strcmp(td->fields[i]->field_id, "n") == 0) {
> +		} else if (td && strcmp(td->fields[i]->field_id, "n") == 0) {
>  			memcpy(buffer, data_to_hash, datalen);
>  			data_to_hash = buffer;
>  			datalen = IMA_EVENT_NAME_LEN_MAX + 1;
> @@ -475,6 +475,13 @@ int ima_calc_field_array_hash(struct ima_field_data *field_data,
>  	return rc;
>  }
> 
> +int ima_calc_buffer_hash(const void *buf, int len, struct ima_digest_data *hash)
> +{
> +	struct ima_field_data fd = { .data = (u8 *)buf, .len = len };
> +
> +	return ima_calc_field_array_hash(&fd, NULL, 1, hash);
> +}
> +
>  static void __init ima_pcrread(int idx, u8 *pcr)
>  {
>  	if (!ima_used_chip)


