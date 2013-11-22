Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932111Ab3KVQg0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 11:36:26 -0500
Received: from e06smtp18.uk.ibm.com ([195.75.94.114]:57683 "EHLO
	e06smtp18.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755484Ab3KVQgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 11:36:25 -0500
Date: Fri, 22 Nov 2013 17:35:02 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Roberto Sassu <roberto.sassu@polito.it>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [BUG] 3ce1217d6cd5 ima patch causes s390 to crash on boot
Message-ID: <20131122163502.GE4208@osiris>
References: <20131122114819.GB4208@osiris>
 <528F5C01.8020304@polito.it>
 <20131122141314.GC4208@osiris>
 <528F8515.7040201@polito.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <528F8515.7040201@polito.it>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13112216-6892-0000-0000-000006FC116E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 05:23:49PM +0100, Roberto Sassu wrote:
> Another problem that I found is that strsep()
> modifies the source buffer by replacing the separator
> character with '\0'. In particular, this function
> modifies static data initialized at the beginning
> of the ima_template.c file. Maybe, this is causing
> the kernel panic. I already sent a patch to fix this
> problem (attached to the email) even if it is not
> supposed to land on the 3.13 kernel. Let me know
> if this fixes the issue. Otherwise, I will check
> the code more in depth.

With your patch below applied the kernel boots again.
So it should go into 3.13 (or a different fix).

Thanks!

> From 2d3aa1c0328c44ecc3af7de162791c8cddfb6dfd Mon Sep 17 00:00:00 2001
> From: Roberto Sassu <roberto.sassu@polito.it>
> Date: Wed, 6 Nov 2013 13:51:35 +0100
> Subject: [RFC][PATCH 2/4] ima: make a copy of template_fmt in
>  template_desc_init_fields()
> 
> This patch makes a copy of the 'template_fmt' function argument so that
> the latter will not be modified by strsep(), which does the splitting by
> replacing the given separator with '\0'.
> 
> Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
> ---
>  security/integrity/ima/ima_template.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/security/integrity/ima/ima_template.c b/security/integrity/ima/ima_template.c
> index 7bcff5c..bb33576 100644
> --- a/security/integrity/ima/ima_template.c
> +++ b/security/integrity/ima/ima_template.c
> @@ -113,13 +113,19 @@ static int template_desc_init_fields(char *template_fmt,
>  				     struct ima_template_field ***fields,
>  				     int *num_fields)
>  {
> -	char *c, *template_fmt_ptr = template_fmt;
> +	char *c, *template_fmt_ptr, *template_fmt_copy = NULL;
>  	int template_num_fields = template_fmt_size(template_fmt);
>  	int i, result = 0;
> 
>  	if (template_num_fields > IMA_TEMPLATE_NUM_FIELDS_MAX)
>  		return -EINVAL;
> 
> +	/* copying is needed as strsep() modifies the original buffer */
> +	template_fmt_copy = kstrdup(template_fmt, GFP_KERNEL);
> +	if (template_fmt_copy == NULL)
> +		return -ENOMEM;
> +
> +	template_fmt_ptr = template_fmt_copy;
>  	*fields = kzalloc(template_num_fields * sizeof(*fields), GFP_KERNEL);
>  	if (*fields == NULL) {
>  		result = -ENOMEM;
> @@ -139,6 +145,7 @@ static int template_desc_init_fields(char *template_fmt,
>  	*num_fields = i;
>  	return 0;
>  out:
> +	kfree(template_fmt_copy);
>  	kfree(*fields);
>  	*fields = NULL;
>  	return result;
> -- 
> 1.8.1.4
> 

