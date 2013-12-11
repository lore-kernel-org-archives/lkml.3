Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751715Ab3LKTIT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 14:08:19 -0500
Received: from smtp105.biz.mail.bf1.yahoo.com ([98.139.221.43]:43138 "HELO
	smtp105.biz.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751646Ab3LKTIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 14:08:16 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Dec 2013 14:08:16 EST
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 5BYgVpMVM1m5IdINgO50E_TcCYvlpw5NaPFp5fKFjTtkZb5
 xs0of96N_o9.GyL5N.3eOb3rNSGoD6DLy3sjA1EVWn5VlZJrgYHQBn4h5uDp
 yfMTqkpIFiBhfLKo0U5VaVCmVXEMTRU4mRcqd15wWN9HvXZnP9Vhu_12qIF2
 xouxkcL8YgttZcyS_F5fYqgkZmWMSF.WlZJbRvKjP1we3nqc5uKoiRaXc0ev
 TPRETUR7rpsrBFkkMfU8vHOtTDQztnWpdDfQajzjWcSmyzh.EkpUMFLSlBg8
 41Ly6GIZKLf2CaPSHIOvRBWSuD3VXZAbJ4iFEt6.Tvosl4qrrP6y_ErQ5f1T
 sMmBbah7NmqB3TgUgf3sWVZmJMrU38EniyhHNrwz6_uoY2i6t11gi7XvY7nG
 qbQYQx7v3l1AiOIMXc_NggwIGl_tXSpOum1G7TGXtiAmDrsaRurzKgw23aFL
 ZrGlcPGArllCOLFrqW24olG6UrIIwkL7fpLdtoW7j2njQFNjIlDawphCqKL0
 HmaQeL74xZvhb.HunuM4rZ_zHSMQbJTBbxuytVraUhwvZ56CWqpvB5.DMA4P
 wGcyM2fF4gdG8Ngk9ppwP8TK6dGuMwyJJBUWsY5QLdTi7IzP7B6n5hXAz5HT
 c.1olAemwGGy6ZSZwVM0EkSa2NFSTG4zkKg--
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-Rocket-Received: from [192.168.0.105] (casey@67.180.103.242 with )
        by smtp105.biz.mail.bf1.yahoo.com with SMTP; 11 Dec 2013 11:01:35 -0800 PST
Message-ID: <52A8B68F.4010006@schaufler-ca.com>
Date: Wed, 11 Dec 2013 11:01:35 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: jarkko.sakkinen@linux.intel.com
CC: james.l.morris@oracle.com, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH] smack: fix: allow either entry be missing on access/access2
 check (v2)
References: <1385659006-5016-1-git-send-email-jarkko.sakkinen@linux.intel.com>
In-Reply-To: <1385659006-5016-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28/2013 9:16 AM, jarkko.sakkinen@linux.intel.com wrote:
> From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
>
> This is a regression caused by f7112e6c. When either subject or
> object is not found the answer for access should be no. This
> patch fixes the situation. '0' is written back instead of failing
> with -EINVAL.
>
> v2: cosmetic style fixes
>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

Applied to git://git.gitorious.org/smack-next/kernel.git#smack-for-3.14

> ---
>  security/smack/smackfs.c |   29 +++++++++++++++--------------
>  1 file changed, 15 insertions(+), 14 deletions(-)
>
> diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
> index 80f4b4a..e97fac7 100644
> --- a/security/smack/smackfs.c
> +++ b/security/smack/smackfs.c
> @@ -297,7 +297,8 @@ static int smk_perm_from_str(const char *string)
>   * @import: if non-zero, import labels
>   * @len: label length limit
>   *
> - * Returns 0 on success, -1 on failure
> + * Returns 0 on success, -EINVAL on failure and -ENOENT when either subject
> + * or object is missing.
>   */
>  static int smk_fill_rule(const char *subject, const char *object,
>  				const char *access1, const char *access2,
> @@ -310,28 +311,28 @@ static int smk_fill_rule(const char *subject, const char *object,
>  	if (import) {
>  		rule->smk_subject = smk_import_entry(subject, len);
>  		if (rule->smk_subject == NULL)
> -			return -1;
> +			return -EINVAL;
>  
>  		rule->smk_object = smk_import(object, len);
>  		if (rule->smk_object == NULL)
> -			return -1;
> +			return -EINVAL;
>  	} else {
>  		cp = smk_parse_smack(subject, len);
>  		if (cp == NULL)
> -			return -1;
> +			return -EINVAL;
>  		skp = smk_find_entry(cp);
>  		kfree(cp);
>  		if (skp == NULL)
> -			return -1;
> +			return -ENOENT;
>  		rule->smk_subject = skp;
>  
>  		cp = smk_parse_smack(object, len);
>  		if (cp == NULL)
> -			return -1;
> +			return -EINVAL;
>  		skp = smk_find_entry(cp);
>  		kfree(cp);
>  		if (skp == NULL)
> -			return -1;
> +			return -ENOENT;
>  		rule->smk_object = skp->smk_known;
>  	}
>  
> @@ -377,6 +378,7 @@ static ssize_t smk_parse_long_rule(char *data, struct smack_parsed_rule *rule,
>  {
>  	ssize_t cnt = 0;
>  	char *tok[4];
> +	int rc;
>  	int i;
>  
>  	/*
> @@ -401,10 +403,8 @@ static ssize_t smk_parse_long_rule(char *data, struct smack_parsed_rule *rule,
>  	while (i < 4)
>  		tok[i++] = NULL;
>  
> -	if (smk_fill_rule(tok[0], tok[1], tok[2], tok[3], rule, import, 0))
> -		return -1;
> -
> -	return cnt;
> +	rc = smk_fill_rule(tok[0], tok[1], tok[2], tok[3], rule, import, 0);
> +	return rc == 0 ? cnt : rc;
>  }
>  
>  #define SMK_FIXED24_FMT	0	/* Fixed 24byte label format */
> @@ -1850,11 +1850,12 @@ static ssize_t smk_user_access(struct file *file, const char __user *buf,
>  		res = smk_parse_long_rule(data, &rule, 0, 3);
>  	}
>  
> -	if (res < 0)
> +	if (res >= 0)
> +		res = smk_access(rule.smk_subject, rule.smk_object,
> +				 rule.smk_access1, NULL);
> +	else if (res != -ENOENT)
>  		return -EINVAL;
>  
> -	res = smk_access(rule.smk_subject, rule.smk_object,
> -				rule.smk_access1, NULL);
>  	data[0] = res == 0 ? '1' : '0';
>  	data[1] = '\0';
>  

