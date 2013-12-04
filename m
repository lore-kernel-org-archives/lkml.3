Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910Ab3LDVIw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 16:08:52 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:45782 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409Ab3LDVIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 16:08:48 -0500
Message-ID: <1386191323.20519.83.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [RFC][PATCH 3/4] ima: display template format in meas. list if
 template name length is zero
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Roberto Sassu <roberto.sassu@polito.it>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ima-devel@lists.sourceforge.net, zohar@us.ibm.com,
        d.kasatkin@samsung.com, james.l.morris@oracle.com
Date: Wed, 04 Dec 2013 16:08:43 -0500
In-Reply-To: <1383832849-17125-4-git-send-email-roberto.sassu@polito.it>
References: <1383832849-17125-1-git-send-email-roberto.sassu@polito.it>
	 <1383832849-17125-4-git-send-email-roberto.sassu@polito.it>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13120421-1542-0000-0000-000003E86FAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-11-07 at 15:00 +0100, Roberto Sassu wrote:
> With the introduction of the 'ima_template_fmt' kernel cmdline parameter,
> an user can define a new template descriptor with custom format. However,
> in this case, userspace tools will be unable to parse the measurements
> list because the new template is unknown. For this reason, this patch
> modifies the current IMA behavior to display in the list the template
> format instead of the name so that a tool can extract needed information
> if it can handle listed fields.
> 
> Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
> ---
>  security/integrity/ima/ima_fs.c | 18 ++++++++++++++----
>  1 file changed, 14 insertions(+), 4 deletions(-)
> 
> diff --git a/security/integrity/ima/ima_fs.c b/security/integrity/ima/ima_fs.c
> index d47a7c8..6db74ff 100644
> --- a/security/integrity/ima/ima_fs.c
> +++ b/security/integrity/ima/ima_fs.c
> @@ -118,6 +118,7 @@ static int ima_measurements_show(struct seq_file *m, void *v)
>  	/* the list never shrinks, so we don't need a lock here */
>  	struct ima_queue_entry *qe = v;
>  	struct ima_template_entry *e;
> +	char *template_name;
>  	int namelen;
>  	u32 pcr = CONFIG_IMA_MEASURE_PCR_IDX;
>  	int i;
> @@ -127,6 +128,10 @@ static int ima_measurements_show(struct seq_file *m, void *v)
>  	if (e == NULL)
>  		return -1;
> 
> +	template_name = e->template_desc->name;
> +	if (strlen(e->template_desc->name) == 0)
> +		template_name = e->template_desc->fmt;
> +

Hi Roberto,

The patch description unconditionally says, "this patch modifies the
current IMA behavior to display in the list the template format instead
of the name".  The code only uses the 'fmt', if the name doesn't exist.
Please update the patch description accordingly.

Nothing is wrong with the above syntax, but template_name could be
assigned once using a ternary conditional expression(?:), like:

	template_name = (strlen(e->template_desc->name) == 0) ?
		e->template_desc->name : e->template_desc->fmt;

thanks,

Mimi

>  	/*
>  	 * 1st: PCRIndex
>  	 * PCR used is always the same (config option) in
> @@ -138,14 +143,14 @@ static int ima_measurements_show(struct seq_file *m, void *v)
>  	ima_putc(m, e->digest, TPM_DIGEST_SIZE);
> 
>  	/* 3rd: template name size */
> -	namelen = strlen(e->template_desc->name);
> +	namelen = strlen(template_name);
>  	ima_putc(m, &namelen, sizeof namelen);
> 
>  	/* 4th:  template name */
> -	ima_putc(m, e->template_desc->name, namelen);
> +	ima_putc(m, template_name, namelen);
> 
>  	/* 5th:  template length (except for 'ima' template) */
> -	if (strcmp(e->template_desc->name, IMA_TEMPLATE_IMA_NAME) != 0)
> +	if (strcmp(template_name, IMA_TEMPLATE_IMA_NAME) != 0)
>  		ima_putc(m, &e->template_data_len,
>  			 sizeof(e->template_data_len));
> 
> @@ -190,6 +195,7 @@ static int ima_ascii_measurements_show(struct seq_file *m, void *v)
>  	/* the list never shrinks, so we don't need a lock here */
>  	struct ima_queue_entry *qe = v;
>  	struct ima_template_entry *e;
> +	char *template_name;
>  	int i;
> 
>  	/* get entry */
> @@ -197,6 +203,10 @@ static int ima_ascii_measurements_show(struct seq_file *m, void *v)
>  	if (e == NULL)
>  		return -1;
> 
> +	template_name = e->template_desc->name;
> +	if (strlen(e->template_desc->name) == 0)
> +		template_name = e->template_desc->fmt;
> +
>  	/* 1st: PCR used (config option) */
>  	seq_printf(m, "%2d ", CONFIG_IMA_MEASURE_PCR_IDX);
> 
> @@ -204,7 +214,7 @@ static int ima_ascii_measurements_show(struct seq_file *m, void *v)
>  	ima_print_digest(m, e->digest, TPM_DIGEST_SIZE);
> 
>  	/* 3th:  template name */
> -	seq_printf(m, " %s", e->template_desc->name);
> +	seq_printf(m, " %s", template_name);
> 
>  	/* 4th:  template specific data */
>  	for (i = 0; i < e->template_desc->num_fields; i++) {


