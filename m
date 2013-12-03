Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353Ab3LCC2g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 21:28:36 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:49742 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597Ab3LCC2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 21:28:32 -0500
Message-ID: <1386037703.5151.20.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH] ima: properly free ima_template_entry structures
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Roberto Sassu <roberto.sassu@polito.it>
Cc: jmorris@namei.org, d.kasatkin@samsung.com,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 02 Dec 2013 21:28:23 -0500
In-Reply-To: <1386009638-32590-1-git-send-email-roberto.sassu@polito.it>
References: <1386009638-32590-1-git-send-email-roberto.sassu@polito.it>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13120302-0928-0000-0000-00000400485F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-12-02 at 19:40 +0100, Roberto Sassu wrote:
> The new templates management mechanism records information associated
> to an event into an array of 'ima_field_data' structures and makes it
> available through the 'template_data' field of the 'ima_template_entry'
> structure (the element of the measurements list created by IMA).
> 
> Since 'ima_field_data' contains dynamically allocated data (which length
> varies depending on the data associated to a selected template field),
> it is not enough to just free the memory reserved for a
> 'ima_template_entry' structure if something goes wrong.
> 
> This patch creates the new function ima_free_template_entry() which
> walks the array of 'ima_field_data' structures, frees the memory
> referenced by the 'data' pointer and finally the space reserved for
> the 'ima_template_entry' structure. Further, it replaces existing kfree()
> that have a pointer to an 'ima_template_entry' structure as argument
> with calls to the new function.
> 
> Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>

Thanks, Roberto.  James, I've been running with this patch since the end
of last week without problems.  Both Christoph Paasch's patch and this
patch are available from linux-security/next-free-memory.

thanks,

Mimi

> ---
>  security/integrity/ima/ima.h      |  1 +
>  security/integrity/ima/ima_api.c  | 21 +++++++++++++++++----
>  security/integrity/ima/ima_init.c |  2 +-
>  3 files changed, 19 insertions(+), 5 deletions(-)
> 
> diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
> index 9636e17..0356e1d 100644
> --- a/security/integrity/ima/ima.h
> +++ b/security/integrity/ima/ima.h
> @@ -148,6 +148,7 @@ int ima_alloc_init_template(struct integrity_iint_cache *iint,
>  			    int xattr_len, struct ima_template_entry **entry);
>  int ima_store_template(struct ima_template_entry *entry, int violation,
>  		       struct inode *inode, const unsigned char *filename);
> +void ima_free_template_entry(struct ima_template_entry *entry);
>  const char *ima_d_path(struct path *path, char **pathbuf);
> 
>  /* rbtree tree calls to lookup, insert, delete
> diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
> index 8037484..c38bbce 100644
> --- a/security/integrity/ima/ima_api.c
> +++ b/security/integrity/ima/ima_api.c
> @@ -22,6 +22,19 @@
>  #include "ima.h"
> 
>  /*
> + * ima_free_template_entry - free an existing template entry
> + */
> +void ima_free_template_entry(struct ima_template_entry *entry)
> +{
> +	int i;
> +
> +	for (i = 0; i < entry->template_desc->num_fields; i++)
> +		kfree(entry->template_data[i].data);
> +
> +	kfree(entry);
> +}
> +
> +/*
>   * ima_alloc_init_template - create and initialize a new template entry
>   */
>  int ima_alloc_init_template(struct integrity_iint_cache *iint,
> @@ -37,6 +50,7 @@ int ima_alloc_init_template(struct integrity_iint_cache *iint,
>  	if (!*entry)
>  		return -ENOMEM;
> 
> +	(*entry)->template_desc = template_desc;
>  	for (i = 0; i < template_desc->num_fields; i++) {
>  		struct ima_template_field *field = template_desc->fields[i];
>  		u32 len;
> @@ -51,10 +65,9 @@ int ima_alloc_init_template(struct integrity_iint_cache *iint,
>  		(*entry)->template_data_len += sizeof(len);
>  		(*entry)->template_data_len += len;
>  	}
> -	(*entry)->template_desc = template_desc;
>  	return 0;
>  out:
> -	kfree(*entry);
> +	ima_free_template_entry(*entry);
>  	*entry = NULL;
>  	return result;
>  }
> @@ -134,7 +147,7 @@ void ima_add_violation(struct file *file, const unsigned char *filename,
>  	}
>  	result = ima_store_template(entry, violation, inode, filename);
>  	if (result < 0)
> -		kfree(entry);
> +		ima_free_template_entry(entry);
>  err_out:
>  	integrity_audit_msg(AUDIT_INTEGRITY_PCR, inode, filename,
>  			    op, cause, result, 0);
> @@ -269,7 +282,7 @@ void ima_store_measurement(struct integrity_iint_cache *iint,
>  	if (!result || result == -EEXIST)
>  		iint->flags |= IMA_MEASURED;
>  	if (result < 0)
> -		kfree(entry);
> +		ima_free_template_entry(entry);
>  }
> 
>  void ima_audit_measurement(struct integrity_iint_cache *iint,
> diff --git a/security/integrity/ima/ima_init.c b/security/integrity/ima/ima_init.c
> index 76b8e2c..3712276 100644
> --- a/security/integrity/ima/ima_init.c
> +++ b/security/integrity/ima/ima_init.c
> @@ -75,7 +75,7 @@ static void __init ima_add_boot_aggregate(void)
>  	result = ima_store_template(entry, violation, NULL,
>  				    boot_aggregate_name);
>  	if (result < 0)
> -		kfree(entry);
> +		ima_free_template_entry(entry);
>  	return;
>  err_out:
>  	integrity_audit_msg(AUDIT_INTEGRITY_PCR, NULL, boot_aggregate_name, op,


