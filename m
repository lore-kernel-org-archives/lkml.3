Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553Ab3FOTca (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 15:32:30 -0400
Received: from smtp105.biz.mail.gq1.yahoo.com ([98.137.12.180]:47624 "HELO
	smtp105.biz.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754502Ab3FOTc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 15:32:29 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 0M2S4n8VM1meZhjwJZTJfopTZIFGy0whKWakkX6MRzh7HAg
 JUqD1nokq4J3fYrJw3EQjWjwobb9TTPzt6ctXhXY2jcLLFKRkmCG5yMdvf5J
 r5vGClsQoMmRkgsoNzIN3R5rG9vd0zX9Dx3Alc21EuTYLMcmOlUWFjHn1R4z
 7SMisfarVM2b9D5WLdvibF_igdocLS.LpxCIBx8_tHpDt_B8DUSJCnSwR9xI
 Gu0VIXhm7LN50RFhqB7vmyES2OxVjmeGa.qrs0aeciKz4f807WkdMsGmlP3i
 5fGDfus86tY3hQLqneMn1W2Ab8uZaszNgWYLh6XA0eQohymnyQZHE0tQiMjK
 BWmoMeT83Xb4uL8zcCUUbB6WclCLV6q_C2zZxKj4JbyZ1fe6AuxVuqZQ_fn5
 bEHguSyAnoNvupJPrhvbeaPaO_hyARl0V54CiJ4LEHtnHrWYZ3v2WQqa6NQA
 Ek5LKpk3qwToFaDpNJFj93NixIhlW6PV6kwtCzrkfaPIBefM-
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-Rocket-Received: from [192.168.0.103] (casey@24.6.250.25 with plain)
        by smtp105.biz.mail.gq1.yahoo.com with SMTP; 15 Jun 2013 12:32:28 -0700 PDT
Message-ID: <51BCC159.6090001@schaufler-ca.com>
Date: Sat, 15 Jun 2013 12:32:41 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
CC: linux-security-module@vger.kernel.org, m.szyprowski@samsung.com,
        kyungmin.park@samsung.com, r.krypa@samsung.com,
        linux-kernel@vger.kernel.org, Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [RFC 1/5] security: smack: avoid kmalloc allocations while loading
 a rule string
References: <1371137352-31273-1-git-send-email-t.stanislaws@samsung.com> <1371137352-31273-2-git-send-email-t.stanislaws@samsung.com>
In-Reply-To: <1371137352-31273-2-git-send-email-t.stanislaws@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/13/2013 8:29 AM, Tomasz Stanislawski wrote:
> The maximal length for a rule line for long format is introduced as
> SMK_LOAD2LEN. This allows a buffer for a rule string to be allocated
> on a stack instead of a heap (aka kmalloc cache).
>
> Limiting the length of a rule line helps to avoid allocations of a very long
> contiguous buffer from a heap if user calls write() for a very long chunk.
> Such an allocation often causes a lot swapper/writeback havoc and it is very
> likely to fails.
>
> Moreover, stack allocation is slightly faster than from kmalloc.
>
> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>

Please see the explanation below.

Nacked-by: Casey Schaufler <casey@schaufler-ca.com>

> ---
>  security/smack/smackfs.c |   15 ++++++---------
>  1 file changed, 6 insertions(+), 9 deletions(-)
>
> diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
> index 53a08b8..9a3cd0d 100644
> --- a/security/smack/smackfs.c
> +++ b/security/smack/smackfs.c
> @@ -137,6 +137,7 @@ const char *smack_cipso_option = SMACK_CIPSO_OPTION;
>   * SMK_ACCESS: Maximum possible combination of access permissions
>   * SMK_ACCESSLEN: Maximum length for a rule access field
>   * SMK_LOADLEN: Smack rule length
> + * SMK_LOAD2LEN: Smack maximal long rule length excluding \0
>   */
>  #define SMK_OACCESS	"rwxa"
>  #define SMK_ACCESS	"rwxat"
> @@ -144,6 +145,7 @@ const char *smack_cipso_option = SMACK_CIPSO_OPTION;
>  #define SMK_ACCESSLEN	(sizeof(SMK_ACCESS) - 1)
>  #define SMK_OLOADLEN	(SMK_LABELLEN + SMK_LABELLEN + SMK_OACCESSLEN)
>  #define SMK_LOADLEN	(SMK_LABELLEN + SMK_LABELLEN + SMK_ACCESSLEN)
> +#define SMK_LOAD2LEN	(2 * SMK_LONGLABEL + SMK_ACCESSLEN + 2)
>  
>  /*
>   * Stricly for CIPSO level manipulation.
> @@ -447,8 +449,7 @@ static ssize_t smk_write_rules_list(struct file *file, const char __user *buf,
>  {
>  	struct smack_known *skp;
>  	struct smack_parsed_rule *rule;
> -	char *data;
> -	int datalen;
> +	char data[SMK_LOAD2LEN + 1];

That puts over 512 bytes on the stack. The reason that the code
uses a temporary allocation is that 512 bytes to considerably
beyond what is considered reasonable to put on the kernel stack.
As reasonable as this approach is in user space code, it is not
appropriate in the kernel.

>  	int rc = -EINVAL;
>  	int load = 0;
>  
> @@ -465,13 +466,10 @@ static ssize_t smk_write_rules_list(struct file *file, const char __user *buf,
>  		 */
>  		if (count != SMK_OLOADLEN && count != SMK_LOADLEN)
>  			return -EINVAL;
> -		datalen = SMK_LOADLEN;
> -	} else
> -		datalen = count + 1;
> +	}
>  
> -	data = kzalloc(datalen, GFP_KERNEL);
> -	if (data == NULL)
> -		return -ENOMEM;
> +	if (count > SMK_LOAD2LEN)
> +		count = SMK_LOAD2LEN;
>  
>  	if (copy_from_user(data, buf, count) != 0) {
>  		rc = -EFAULT;
> @@ -522,7 +520,6 @@ static ssize_t smk_write_rules_list(struct file *file, const char __user *buf,
>  out_free_rule:
>  	kfree(rule);
>  out:
> -	kfree(data);
>  	return rc;
>  }
>  

