Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622Ab3LDVFg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 16:05:36 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:45727 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103Ab3LDVFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 16:05:31 -0500
Message-ID: <1386191125.20519.80.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [RFC][PATCH 4/4] ima: added support for new kernel cmdline
 parameter ima_template_fmt
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Roberto Sassu <roberto.sassu@polito.it>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ima-devel@lists.sourceforge.net, zohar@us.ibm.com,
        d.kasatkin@samsung.com, james.l.morris@oracle.com
Date: Wed, 04 Dec 2013 16:05:25 -0500
In-Reply-To: <1383832849-17125-5-git-send-email-roberto.sassu@polito.it>
References: <1383832849-17125-1-git-send-email-roberto.sassu@polito.it>
	 <1383832849-17125-5-git-send-email-roberto.sassu@polito.it>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13120421-7164-0000-0000-000003F195E2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-11-07 at 15:00 +0100, Roberto Sassu wrote:
> This patch allows users to provide a custom template format through the
> new kernel command line parameter 'ima_template_fmt'. If the supplied
> format is not valid, IMA uses the default template descriptor.
> 
> Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
> ---
>  Documentation/kernel-parameters.txt      |  4 +++
>  Documentation/security/IMA-templates.txt | 29 +++++++++---------
>  security/integrity/ima/ima_template.c    | 50 ++++++++++++++++++++++++++++++++
>  3 files changed, 68 insertions(+), 15 deletions(-)
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 1e8761c..27b14b2 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -1199,6 +1199,10 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>  			Formats: { "ima" | "ima-ng" }
>  			Default: "ima-ng"
> 
> +	ima_template_fmt=
> +	                [IMA] Define a custom template format.
> +			Format: { "field1|...|fieldN" }
> +
>  	init=		[KNL]
>  			Format: <full_path>
>  			Run specified binary instead of /sbin/init as init
> diff --git a/Documentation/security/IMA-templates.txt b/Documentation/security/IMA-templates.txt
> index a777e5f..08ea2da 100644
> --- a/Documentation/security/IMA-templates.txt
> +++ b/Documentation/security/IMA-templates.txt
> @@ -27,25 +27,22 @@ Managing templates with these structures is very simple. To support
>  a new data type, developers define the field identifier and implement
>  two functions, init() and show(), respectively to generate and display
>  measurement entries. Defining a new template descriptor requires
> -specifying the template format, a string of field identifiers separated
> -by the '|' character. While in the current implementation it is possible
> -to define new template descriptors only by adding their definition in the
> -template specific code (ima_template.c), in a future version it will be
> -possible to register a new template on a running kernel by supplying to IMA
> -the desired format string. In this version, IMA initializes at boot time
> -all defined template descriptors by translating the format into an array
> -of template fields structures taken from the set of the supported ones.
> +specifying the template format (a string of field identifiers separated
> +by the '|' character) through the 'ima_template_fmt' kernel command line
> +parameter. At boot time, IMA initializes all defined template descriptors
> +by translating the format into an array of template fields structures taken
> +from the set of the supported ones.
> 
>  After the initialization step, IMA will call ima_alloc_init_template()
>  (new function defined within the patches for the new template management
>  mechanism) to generate a new measurement entry by using the template
>  descriptor chosen through the kernel configuration or through the newly
> -introduced 'ima_template=' kernel command line parameter. It is during this
> -phase that the advantages of the new architecture are clearly shown:
> -the latter function will not contain specific code to handle a given template
> -but, instead, it simply calls the init() method of the template fields
> -associated to the chosen template descriptor and store the result (pointer
> -to allocated data and data length) in the measurement entry structure.
> +introduced 'ima_template' and 'ima_template_fmt' kernel command line parameters.
> +It is during this phase that the advantages of the new architecture are
> +clearly shown: the latter function will not contain specific code to handle
> +a given template but, instead, it simply calls the init() method of the template
> +fields associated to the chosen template descriptor and store the result
> +(pointer to allocated data and data length) in the measurement entry structure.
> 
>  The same mechanism is employed to display measurements entries.
>  The functions ima[_ascii]_measurements_show() retrieve, for each entry,
> @@ -84,4 +81,6 @@ currently the following methods are supported:
>   - select a template descriptor among those supported in the kernel
>     configuration ('ima-ng' is the default choice);
>   - specify a template descriptor name from the kernel command line through
> -   the 'ima_template=' parameter.
> +   the 'ima_template=' parameter;
> + - register a new template descriptor with custom format through the kernel
> +   command line parameter 'ima_template_fmt='.
> diff --git a/security/integrity/ima/ima_template.c b/security/integrity/ima/ima_template.c
> index bb33576..5a95d06 100644
> --- a/security/integrity/ima/ima_template.c
> +++ b/security/integrity/ima/ima_template.c
> @@ -21,6 +21,7 @@ static struct ima_template_desc defined_templates[] = {
>  	{.name = IMA_TEMPLATE_IMA_NAME, .fmt = IMA_TEMPLATE_IMA_FMT},
>  	{.name = "ima-ng",.fmt = "d-ng|n-ng"},
>  	{.name = "ima-sig",.fmt = "d-ng|n-ng|sig"},
> +	{.name = "",.fmt = ""},	/* placeholder for a custom format */
>  };
> 
>  static struct ima_template_field supported_fields[] = {
> @@ -38,12 +39,16 @@ static struct ima_template_field supported_fields[] = {
> 
>  static struct ima_template_desc *ima_template;
>  static struct ima_template_desc *lookup_template_desc(const char *name);
> +static struct ima_template_field *lookup_template_field(const char *field_id);
> 
>  static int __init ima_template_setup(char *str)
>  {
>  	struct ima_template_desc *template_desc;
>  	int template_len = strlen(str);
> 
> +	if (ima_template)
> +		return 1;
> +
>  	/*
>  	 * Verify that a template with the supplied name exists.
>  	 * If not, use CONFIG_IMA_DEFAULT_TEMPLATE.
> @@ -70,6 +75,48 @@ static int __init ima_template_setup(char *str)
>  }
>  __setup("ima_template=", ima_template_setup);
> 
> +static int __init ima_template_fmt_setup(char *str)
> +{
> +	int num_templates = ARRAY_SIZE(defined_templates);
> +	char *str_ptr_start = str;
> +	char *str_ptr_end = str_ptr_start;
> +
> +	if (ima_template)
> +		return 1;
> +
> +	while (str_ptr_start != NULL) {
> +		char field_id[IMA_TEMPLATE_FIELD_ID_MAX_LEN];
> +		int len;
> +
> +		str_ptr_end = strpbrk(str_ptr_start, "|");
> +		if (str_ptr_end == NULL)
> +			len = str + strlen(str) - str_ptr_start;
> +		else
> +			len = str_ptr_end++ - str_ptr_start;
> +
> +		if (len >= IMA_TEMPLATE_FIELD_ID_MAX_LEN) {
> +			pr_err("IMA: field too long, using template %s\n",
> +			       CONFIG_IMA_DEFAULT_TEMPLATE);
> +			return 1;
> +		}
> +
> +		memcpy(field_id, str_ptr_start, len);
> +		field_id[len] = '\0';
> +		if (lookup_template_field(field_id) == NULL) {
> +			pr_err("IMA: field '%s' not found, using template %s\n",
> +			       field_id, CONFIG_IMA_DEFAULT_TEMPLATE);
> +			return 1;
> +		}
> +
> +		str_ptr_start = str_ptr_end;
> +	}
> +

Roberto, looking this over again, I think this can be simplified by
using strsep().

Mimi

> +	defined_templates[num_templates - 1].fmt = str;
> +	ima_template = defined_templates + num_templates - 1;
> +	return 1;
> +}
> +__setup("ima_template_fmt=", ima_template_fmt_setup);
> +
>  static struct ima_template_desc *lookup_template_desc(const char *name)
>  {
>  	int i;
> @@ -160,6 +207,9 @@ static int init_defined_templates(void)
>  	for (i = 0; i < ARRAY_SIZE(defined_templates); i++) {
>  		struct ima_template_desc *template = &defined_templates[i];
> 
> +		if (strlen(template->fmt) == 0)
> +			continue;
> +
>  		result = template_desc_init_fields(template->fmt,
>  						   &(template->fields),
>  						   &(template->num_fields));


