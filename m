Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531Ab3FOTyR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 15:54:17 -0400
Received: from smtp103.biz.mail.ne1.yahoo.com ([98.138.207.10]:42465 "HELO
	smtp103.biz.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754351Ab3FOTyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 15:54:15 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: rTQEUTEVM1ktgAkXmvN3PyQr5KZetDcq0WTJ86sI.f4azEV
 9bBrhhOnW18I89O8o_rKUMMgKLY9yHXKYsp0MJ_QjO0hVNSh2C6yAyaGIQPX
 uTlgdTUSV3DocuLRoyeCqEQXtmEiooBOm9epTQRQJo0aYv4Hg.Cs5YTBcHGV
 j.JZoXcwJVaF1T4ZMHyDC46uRoCwtxGe3V8WQHY_sXlsCzWrvkqBXqZilGei
 LAEJaS7Fmi7GWHdZP6a1CfoNtPKr_C41EyFvQydXgeEr1IZV33fT_rQzRRzW
 U.H9gOJuHVFwM64Zx6.jnWDvTxtzhtuLxhNAzeQLvUX7j.5RzQS74smhAkw.
 qaKgPan24UTm45zJg1fL_m_HuVOz9I1iO31BIfGp1jIJoHdoVcyJHJNKI98U
 9BCzy8okCWnQskpPBRhWSSb2dSl2M.MDIoXpb8eP7HFzdx8Y_ZjzolTQJL1j
 TyskkekwcWdioQBc7mfpekCI1s73QngApZBjeHmTCOoY-
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-Rocket-Received: from [192.168.0.103] (casey@24.6.250.25 with plain)
        by smtp103.biz.mail.ne1.yahoo.com with SMTP; 15 Jun 2013 12:54:14 -0700 PDT
Message-ID: <51BCC673.10302@schaufler-ca.com>
Date: Sat, 15 Jun 2013 12:54:27 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
CC: linux-security-module@vger.kernel.org, m.szyprowski@samsung.com,
        kyungmin.park@samsung.com, r.krypa@samsung.com,
        linux-kernel@vger.kernel.org, Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [RFC 3/5] security: smack: fix memleak in smk_write_rules_list()
References: <1371137352-31273-1-git-send-email-t.stanislaws@samsung.com> <1371137352-31273-4-git-send-email-t.stanislaws@samsung.com>
In-Reply-To: <1371137352-31273-4-git-send-email-t.stanislaws@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/13/2013 8:29 AM, Tomasz Stanislawski wrote:
> The smack_parsed_rule structure is allocated.  If a rule is successfully
> installed then the last reference to the object is lost.  This patch fixes this
> leak. Moreover smack_parsed_rule is allocated on stack because it no longer
> needed ofter smk_write_rules_list() is finished.
>
> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>

It looks like this was introduced with the change-rule support.
Prior to that, the rule passed into smk_set_access() was added
to the rule list if it was new. The change-rule support added a
new structure and missed the fact the rule was already allocated.

The patch needs to be rebased so that it does not depend on the
changes from patches 1 and 2 of the set.


> ---
>  security/smack/smackfs.c |   30 ++++++++++--------------------
>  1 file changed, 10 insertions(+), 20 deletions(-)
>
> diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
> index 46f111e..e8c57f3 100644
> --- a/security/smack/smackfs.c
> +++ b/security/smack/smackfs.c
> @@ -447,7 +447,7 @@ static ssize_t smk_write_rules_list(struct file *file, const char __user *buf,
>  					struct mutex *rule_lock, int format)
>  {
>  	struct smack_known *skp;
> -	struct smack_parsed_rule *rule;
> +	struct smack_parsed_rule rule;
>  	char data[SMK_LOAD2LEN + 1];
>  	int rc = -EINVAL;
>  	int load = 0;
> @@ -475,49 +475,39 @@ static ssize_t smk_write_rules_list(struct file *file, const char __user *buf,
>  		goto out;
>  	}
>  
> -	rule = kzalloc(sizeof(*rule), GFP_KERNEL);
> -	if (rule == NULL) {
> -		rc = -ENOMEM;
> -		goto out;
> -	}
> -
>  	if (format == SMK_LONG_FMT) {
>  		/*
>  		 * Be sure the data string is terminated.
>  		 */
>  		data[count] = '\0';
> -		if (smk_parse_long_rule(data, rule, 1, 0))
> -			goto out_free_rule;
> +		if (smk_parse_long_rule(data, &rule, 1, 0))
> +			goto out;
>  	} else if (format == SMK_CHANGE_FMT) {
>  		data[count] = '\0';
> -		if (smk_parse_long_rule(data, rule, 1, 1))
> -			goto out_free_rule;
> +		if (smk_parse_long_rule(data, &rule, 1, 1))
> +			goto out;
>  	} else {
>  		/*
>  		 * More on the minor hack for backward compatibility
>  		 */
>  		if (count == (SMK_OLOADLEN))
>  			data[SMK_OLOADLEN] = '-';
> -		if (smk_parse_rule(data, rule, 1))
> -			goto out_free_rule;
> +		if (smk_parse_rule(data, &rule, 1))
> +			goto out;
>  	}
>  
>  
>  	if (rule_list == NULL) {
>  		load = 1;
> -		skp = smk_find_entry(rule->smk_subject);
> +		skp = smk_find_entry(rule.smk_subject);
>  		rule_list = &skp->smk_rules;
>  		rule_lock = &skp->smk_rules_lock;
>  	}
>  
> -	rc = smk_set_access(rule, rule_list, rule_lock, load);
> -	if (rc == 0) {
> +	rc = smk_set_access(&rule, rule_list, rule_lock, load);
> +	if (rc == 0)
>  		rc = count;
> -		goto out;
> -	}
>  
> -out_free_rule:
> -	kfree(rule);
>  out:
>  	return rc;
>  }

