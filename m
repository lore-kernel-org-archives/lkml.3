Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933722Ab3LINfj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 08:35:39 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:32944 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933431Ab3LINfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 08:35:37 -0500
Message-ID: <1386596132.23828.30.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH-v2 3/6] ima: added ima_get_template_desc() for templates
 dynamic registration
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Roberto Sassu <roberto.sassu@polito.it>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ima-devel@lists.sourceforge.net, zohar@us.ibm.com,
        d.kasatkin@samsung.com, james.l.morris@oracle.com
Date: Mon, 09 Dec 2013 08:35:32 -0500
In-Reply-To: <1384864428-3895-4-git-send-email-roberto.sassu@polito.it>
References: <1384864428-3895-1-git-send-email-roberto.sassu@polito.it>
	 <1384864428-3895-4-git-send-email-roberto.sassu@polito.it>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13120913-0928-0000-0000-0000043D968E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-11-19 at 13:33 +0100, Roberto Sassu wrote: 
> This patch introduces the ima_get_template_desc() function which returns
> a template descriptor depending on the template name and format passed
> as arguments (at least one argument should be not NULL). If the first
> argument is not NULL, the new function searches an existing template
> descriptor by name among those defined and returns it to the caller.
> Instead, if the second argument is not NULL and the first is NULL,
> it does a template lookup by format and, if not found, creates a new one
> before returning the pointer to the caller. Newly created templates
> are cached to avoid duplicates.
> 
> Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
> ---
>  security/integrity/ima/ima.h          |  2 ++
>  security/integrity/ima/ima_template.c | 45 +++++++++++++++++++++++++++++++++++
>  2 files changed, 47 insertions(+)
> 
> diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
> index 8b4a4f3..632d92e 100644
> --- a/security/integrity/ima/ima.h
> +++ b/security/integrity/ima/ima.h
> @@ -109,6 +109,8 @@ int ima_init_crypto(void);
>  void ima_putc(struct seq_file *m, void *data, int datalen);
>  void ima_print_digest(struct seq_file *m, u8 *digest, int size);
>  struct ima_template_desc *ima_template_desc_current(void);
> +struct ima_template_desc *ima_get_template_desc(char *template_name,
> +						char *template_fmt);
>  int ima_init_template(void);
> 
>  int ima_init_template(void);
> diff --git a/security/integrity/ima/ima_template.c b/security/integrity/ima/ima_template.c
> index c849723..9bec7d4 100644
> --- a/security/integrity/ima/ima_template.c
> +++ b/security/integrity/ima/ima_template.c
> @@ -41,6 +41,8 @@ static struct ima_template_desc *ima_template;
>  static struct ima_template_desc *lookup_template_desc_by_name(const char *name);
>  static struct ima_template_field *lookup_template_field(const char *field_id);
> 
> +static DEFINE_MUTEX(ima_templates_mutex);
> +
>  static int __init ima_template_setup(char *str)
>  {
>  	struct ima_template_desc *template_desc;
> @@ -248,6 +250,49 @@ struct ima_template_desc *ima_template_desc_current(void)
>  	return ima_template;
>  }
> 
> +struct ima_template_desc *ima_get_template_desc(char *template_name,
> +						char *template_fmt)
> +{
> +	struct ima_template_desc *desc;
> +	int result;
> +
> +	if (template_name == NULL && template_fmt == NULL)
> +		return NULL;

Originally, before using a variable, we checked that it wasn't NULL.
This changed, at some point. (Can someone supply a reference, please?)
As the only code calling ima_get_template_desc() will be IMA, this check
shouldn't be required.

> +
> +	if (template_name)
> +		desc = lookup_template_desc_by_name(template_name);
> +	else {
> +		mutex_lock(&ima_templates_mutex);
> +		desc = lookup_template_desc_by_fmt(template_fmt);
> +		if (desc == NULL) {
> +			desc = kzalloc(sizeof(*desc), GFP_KERNEL);
> +			if (desc == NULL)
> +				goto out_unlock;
> +		}
> +		desc->name = "";

What's this?

> +		desc->fmt = kstrdup(template_fmt, GFP_KERNEL);
> +		if (desc->fmt == NULL)
> +			goto out_free;
> +
> +		result = template_desc_init_fields(desc->fmt, &(desc->fields),
> +						   &(desc->num_fields));
> +		if (result < 0)
> +			goto out_free_fmt;
> +

This patch set was posted before the new cleanup functions were defined.
Reminder, to use your new cleanup function.

> +		list_add_tail(&desc->list, &defined_templates[0].list);
> +		mutex_unlock(&ima_templates_mutex);

Right, as new template formats can only be added, not deleted, locking
just here, to prevent duplicates, should be fine.  Perhaps add a short
comment, indicating this is safe, because templates are not ever
removed.

thanks,

Mimi

> +	}
> +
> +	return desc;
> +out_free_fmt:
> +	kfree(desc->fmt);
> +out_free:
> +	kfree(desc);
> +out_unlock:
> +	mutex_unlock(&ima_templates_mutex);
> +	return NULL;
> +}
> +
>  int ima_init_template(void)
>  {
>  	int result;


