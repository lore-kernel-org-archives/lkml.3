Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082Ab3F1TkP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 15:40:15 -0400
Received: from smtp110.biz.mail.ne1.yahoo.com ([98.138.206.47]:22508 "HELO
	smtp110.biz.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752427Ab3F1TkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 15:40:14 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Jun 2013 15:40:13 EDT
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: Z925om4VM1lOg4bpeh7OqQ.q4U059C769SNDAQTbRAWl5eA
 RAU2SKoTuZTi78vBTM1xhKAWuRGi_MPIjfm8zXMMnxGb2LGcpw_O16O4nrKb
 zw4oDPkZp0PKROBTFC6DbSGOrL4xdhTbR867Fj5nj7Gq.EW8djgyDbDLY6GL
 zQX2.17J8.mjeRFJb7K8qArJFlzpWFWq2wHPdK4z7OWp_52fQr1xZGf8vYaZ
 XzVP59mWnIxoZ5VzWQloDCbh5Z0us4kh_A0JMmLyUUijpO3gqfmAijPBKTX1
 ij2yjdNDOS96GbZRebO9wSTv4cVzSGHQ.NhH2kF9SU2Zr62o91ibXU1KNNYz
 UvEu5h8E5ZjcOZx0ZA_Uwbc4Gu02Me4a9QGirvMBXrVWxlUQ5BZsoUH3CCX9
 _LLmf_vaf6LOiv6JUVIDr3h6jpGtMSMvuSufgsUti8BONrN3saCfEejt5QmV
 hJ3zyo6CPJWkVktZveBejXUFw3ixSKRifzEcTPJ.Am0wIZdqJWn1K6sVfUxH
 g1pyaqe2jCzx3dAD5KdP4.yDsSL3Z
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-Rocket-Received: from [192.168.0.103] (casey@24.6.250.25 with plain)
        by smtp110.biz.mail.ne1.yahoo.com with SMTP; 28 Jun 2013 12:33:32 -0700 PDT
Message-ID: <51CDE50F.80302@schaufler-ca.com>
Date: Fri, 28 Jun 2013 12:33:35 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
CC: Casey Schaufler <casey@schaufler-ca.com>,
        linux-security-module@vger.kernel.org, m.szyprowski@samsung.com,
        kyungmin.park@samsung.com, r.krypa@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] security: smack: fix memleak in smk_write_rules_list()
References: <1371137352-31273-1-git-send-email-t.stanislaws@samsung.com> <51C1BB6C.8010105@samsung.com>
In-Reply-To: <51C1BB6C.8010105@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/19/2013 7:08 AM, Tomasz Stanislawski wrote:
> >From 8497987bedf8821db3dce47a6205dfce2b0895c5 Mon Sep 17 00:00:00 2001
> From: Tomasz Stanislawski <t.stanislaws@samsung.com>
> Date: Thu, 6 Jun 2013 09:30:50 +0200
> Subject: [PATCH] security: smack: fix memleak in smk_write_rules_list()
>
> The smack_parsed_rule structure is allocated.  If a rule is successfully
> installed then the last reference to the object is lost.  This patch fixes this
> leak. Moreover smack_parsed_rule is allocated on stack because it no longer
> needed ofter smk_write_rules_list() is finished.
>
> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>

I will add this patch to the smack-next tree.

Acked-by: Casey Schaufler <casey@schaufler-ca.com>

> ---
>  security/smack/smackfs.c |   30 ++++++++++--------------------
>  1 file changed, 10 insertions(+), 20 deletions(-)
>
> diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
> index 53a08b8..08aebc2 100644
> --- a/security/smack/smackfs.c
> +++ b/security/smack/smackfs.c
> @@ -446,7 +446,7 @@ static ssize_t smk_write_rules_list(struct file *file, const char __user *buf,
>  					struct mutex *rule_lock, int format)
>  {
>  	struct smack_known *skp;
> -	struct smack_parsed_rule *rule;
> +	struct smack_parsed_rule rule;
>  	char *data;
>  	int datalen;
>  	int rc = -EINVAL;
> @@ -478,49 +478,39 @@ static ssize_t smk_write_rules_list(struct file *file, const char __user *buf,
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
>  	kfree(data);
>  	return rc;

