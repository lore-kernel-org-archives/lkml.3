Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933754Ab3LINwb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 08:52:31 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:39907 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933590Ab3LINw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 08:52:29 -0500
Message-ID: <1386597142.23828.39.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH-v2 4/6] ima: added ima_template and ima_template_fmt new
 policy options
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Roberto Sassu <roberto.sassu@polito.it>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ima-devel@lists.sourceforge.net, zohar@us.ibm.com,
        d.kasatkin@samsung.com, james.l.morris@oracle.com
Date: Mon, 09 Dec 2013 08:52:22 -0500
In-Reply-To: <1384864428-3895-5-git-send-email-roberto.sassu@polito.it>
References: <1384864428-3895-1-git-send-email-roberto.sassu@polito.it>
	 <1384864428-3895-5-git-send-email-roberto.sassu@polito.it>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13120913-3532-0000-0000-000003ADF879
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-11-19 at 13:33 +0100, Roberto Sassu wrote: 
> This patch adds the support for 'ima_template' and 'ima_template_fmt'
> policy options. They allow to define which template should be used
> and, thus, which information should be included in measurements entries
> generated from events that match other rules' criteria.
> 
> With this feature, it is possible to include for each measurement entry
> only relevant information. For example, while measurements that report
> the execution of the execve() system call may contain the credentials
> being installed on the current process (stored in the 'cred' field of the
> 'linux_binprm' structure), others should not include it (also because
> the pointer to the above structure is not available from other IMA hooks).
> 
> A sample policy to add to measurement entries the LSM label in the
> 'linux_binprm' structure only for file execution events should be:

As mentioned for the cover letter, please simplify the example.

> ---
> measure func=BPRM_CHECK mask=MAY_EXEC \
>     ima_template_fmt=d-ng|n-ng|target-subj
> measure func=FILE_MMAP mask=MAY_EXEC
> ---
> 
> where 'target-subj' is the identifier of a new field (whose code is not yet
> upstreamed) which displays the additional information.
> 
> Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
> ---
>  Documentation/ABI/testing/ima_policy     |  6 +++++-
>  Documentation/security/IMA-templates.txt | 19 +++++++++++--------
>  security/integrity/ima/ima_policy.c      | 32 +++++++++++++++++++++++++++++++-
>  3 files changed, 47 insertions(+), 10 deletions(-)
> 
> diff --git a/Documentation/ABI/testing/ima_policy b/Documentation/ABI/testing/ima_policy
> index f1c5cc9..7fbe47d 100644
> --- a/Documentation/ABI/testing/ima_policy
> +++ b/Documentation/ABI/testing/ima_policy
> @@ -23,7 +23,7 @@ Description:
>  				 [fowner]]
>  			lsm:	[[subj_user=] [subj_role=] [subj_type=]
>  				 [obj_user=] [obj_role=] [obj_type=]]
> -			option:	[[appraise_type=]]
> +			option:	[[appraise_type=] [ima_template=] [ima_template_fmt=]]
> 
>  		base: 	func:= [BPRM_CHECK][MMAP_CHECK][FILE_CHECK][MODULE_CHECK]
>  			mask:= [MAY_READ] [MAY_WRITE] [MAY_APPEND] [MAY_EXEC]
> @@ -33,6 +33,10 @@ Description:
>  			fowner:=decimal value
>  		lsm:  	are LSM specific
>  		option:	appraise_type:= [imasig]
> +			ima_template:= an already defined template
> +			ima_template_fmt:= a custom template format
> +					   (see Documentation/security/IMA-templates.txt
> +					   for more details)
> 
>  		default policy:
>  			# PROC_SUPER_MAGIC
> diff --git a/Documentation/security/IMA-templates.txt b/Documentation/security/IMA-templates.txt
> index 08ea2da..61d9f0d 100644
> --- a/Documentation/security/IMA-templates.txt
> +++ b/Documentation/security/IMA-templates.txt
> @@ -36,13 +36,14 @@ from the set of the supported ones.
>  After the initialization step, IMA will call ima_alloc_init_template()
>  (new function defined within the patches for the new template management
>  mechanism) to generate a new measurement entry by using the template
> -descriptor chosen through the kernel configuration or through the newly
> -introduced 'ima_template' and 'ima_template_fmt' kernel command line parameters.
> -It is during this phase that the advantages of the new architecture are
> -clearly shown: the latter function will not contain specific code to handle
> -a given template but, instead, it simply calls the init() method of the template
> -fields associated to the chosen template descriptor and store the result
> -(pointer to allocated data and data length) in the measurement entry structure.
> +descriptor chosen through the kernel configuration, the newly introduced
> +'ima_template' and 'ima_template_fmt' kernel command line parameters and
> +new policy options with the same names. It is during this phase that the
> +advantages of the new architecture are clearly shown: the latter function
> +will not contain specific code to handle a given template but, instead, it
> +simply calls the init() method of the template fields associated to the
> +chosen template descriptor and store the result (pointer to allocated data
> +and data length) in the measurement entry structure.
> 
>  The same mechanism is employed to display measurements entries.
>  The functions ima[_ascii]_measurements_show() retrieve, for each entry,
> @@ -83,4 +84,6 @@ currently the following methods are supported:
>   - specify a template descriptor name from the kernel command line through
>     the 'ima_template=' parameter;
>   - register a new template descriptor with custom format through the kernel
> -   command line parameter 'ima_template_fmt='.
> +   command line parameter 'ima_template_fmt=';
> + - provide desired template name or custom format for specific events through
> +   the new policy options 'ima_template=' and 'ima_template_fmt='.
> diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
> index a9c3d3c..f4b3fd0 100644
> --- a/security/integrity/ima/ima_policy.c
> +++ b/security/integrity/ima/ima_policy.c
> @@ -50,6 +50,7 @@ struct ima_rule_entry {
>  	u8 fsuuid[16];
>  	kuid_t uid;
>  	kuid_t fowner;
> +	struct ima_template_desc *desc;
>  	struct {
>  		void *rule;	/* LSM file metadata specific */
>  		void *args_p;	/* audit value */
> @@ -351,7 +352,8 @@ enum {
>  	Opt_obj_user, Opt_obj_role, Opt_obj_type,
>  	Opt_subj_user, Opt_subj_role, Opt_subj_type,
>  	Opt_func, Opt_mask, Opt_fsmagic, Opt_uid, Opt_fowner,
> -	Opt_appraise_type, Opt_fsuuid
> +	Opt_appraise_type, Opt_fsuuid,
> +	Opt_ima_template, Opt_ima_template_fmt
>  };
> 
>  static match_table_t policy_tokens = {
> @@ -373,6 +375,8 @@ static match_table_t policy_tokens = {
>  	{Opt_uid, "uid=%s"},
>  	{Opt_fowner, "fowner=%s"},
>  	{Opt_appraise_type, "appraise_type=%s"},
> +	{Opt_ima_template, "ima_template=%s"},
> +	{Opt_ima_template_fmt, "ima_template_fmt=%s"},
>  	{Opt_err, NULL}
>  };
> 
> @@ -621,6 +625,32 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
>  			else
>  				result = -EINVAL;
>  			break;
> +		case Opt_ima_template:
> +			ima_log_string(ab, "ima_template", args[0].from);
> +
> +			if (entry->desc) {
> +				result = -EINVAL;
> +				break;
> +			}
> +

Right, this prevents overwriting a prior defined template.  Perhaps add
a short comment on the 'if (entry->desc) {' statement.

thanks,

Mimi

> +			entry->desc = ima_get_template_desc(args[0].from, NULL);
> +			if (entry->desc == NULL)
> +				result = -EINVAL;
> +
> +			break;
> +		case Opt_ima_template_fmt:
> +			ima_log_string(ab, "ima_template_fmt", args[0].from);
> +
> +			if (entry->desc) {
> +				result = -EINVAL;
> +				break;
> +			}
> +
> +			entry->desc = ima_get_template_desc(NULL, args[0].from);
> +			if (entry->desc == NULL)
> +				result = -EINVAL;
> +
> +			break;
>  		case Opt_err:
>  			ima_log_string(ab, "UNKNOWN", p);
>  			result = -EINVAL;


