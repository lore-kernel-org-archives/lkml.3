Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759Ab3HLTCA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 15:02:00 -0400
Received: from smtp106.biz.mail.bf1.yahoo.com ([98.139.244.54]:43254 "HELO
	smtp106.biz.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750986Ab3HLTB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 15:01:56 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: LOcRubsVM1mu52G1VfiQWwCGr4vwN01AnDFuaU2IyPIkEBn
 LB42K9jwCRKRb9R6dNEL83uwMUAsD4OqRVDUc6pks4dNrnAJFi4XTc2McayH
 MbUYT8C1.filkb0sn5F0eoq9grgxtJt4kns7Z5Nj1eQnn7zEBJ0nwesvKogH
 ZbcV.SirpDmjnxjeZk0Eqref2B20i8mPIeCjhXqdPT.mIuEtUuTQ_eYNSIlH
 FSkvWUh1_kvUwkWQTFZXg2JWvLxqXXYTcgafsWlUUeQiLtVN.ENLmyNVkpnC
 _MVqPmAK22E6fp3bcPNZdyYIcIEXjV0Oa8twlIe8vEilywpBd_w_OIW1Dq49
 YWIxcbQEEjHlsv2iyRW5mWkdbo1T27PJLti.bllx3S3xPxkuZRby50hGxLym
 mPo719g7y1DAI92c5wC49WfBt3cfyAnqraqnGXANMYlME4Yqkf4yLeZ52vJD
 Ew7AmNFNv7dbyE4t36pK8fW3ETAGOlM1ZYJOSQ7TZcJDNFVcBPxXeHxms6Px
 1GhyGS0unv7D7FycvXGFsB1qpowwRAGkaT24VZZGnC.B6qV0Qoxxss2q1VhL
 9cEJgiAoZR5mQHgZsI0oYhtVsAx1yNm0jYh5ZCXbgTB6f2hzrIWwvBi5K9FS
 kvXYpSCqKh.NewEu0kEmNDujtYrvm1w--
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-Rocket-Received: from [192.168.0.103] (casey@24.6.250.25 with )
        by smtp106.biz.mail.bf1.yahoo.com with SMTP; 12 Aug 2013 12:01:55 -0700 PDT
Message-ID: <52093122.2050506@schaufler-ca.com>
Date: Mon, 12 Aug 2013 12:01:54 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Rafal Krypa <r.krypa@samsung.com>
CC: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH] Smack: parse multiple rules per write to load2, up to
 PAGE_SIZE-1 bytes
References: <1376041627-20016-1-git-send-email-r.krypa@samsung.com>
In-Reply-To: <1376041627-20016-1-git-send-email-r.krypa@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/9/2013 2:47 AM, Rafal Krypa wrote:
> Smack interface for loading rules has always parsed only single rule from
> data written to it. This requires user program to call one write() per
> each rule it wants to load.
> This change makes it possible to write multiple rules, separated by new
> line character. Smack will load at most PAGE_SIZE-1 characters and properly
> return number of processed bytes. In case when user buffer is larger, it
> will be additionally truncated. All characters after last \n will not get
> parsed to avoid partial rule near input buffer boundary.
>
> Signed-off-by: Rafal Krypa <r.krypa@samsung.com>

Acked-by: Casey Schaufler <casey@schaufler-ca.com>

Applied to git://git.gitorious.org/smack-next/kernel.git smack-for-3.12

> ---
>  security/smack/smackfs.c |  167 +++++++++++++++++++++++-----------------------
>  1 file changed, 82 insertions(+), 85 deletions(-)
>
> diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
> index a07e93f..80f4b4a 100644
> --- a/security/smack/smackfs.c
> +++ b/security/smack/smackfs.c
> @@ -368,56 +368,43 @@ static int smk_parse_rule(const char *data, struct smack_parsed_rule *rule,
>   * @data: string to be parsed, null terminated
>   * @rule: Will be filled with Smack parsed rule
>   * @import: if non-zero, import labels
> - * @change: if non-zero, data is from /smack/change-rule
> + * @tokens: numer of substrings expected in data
>   *
> - * Returns 0 on success, -1 on failure
> + * Returns number of processed bytes on success, -1 on failure.
>   */
> -static int smk_parse_long_rule(const char *data, struct smack_parsed_rule *rule,
> -				int import, int change)
> +static ssize_t smk_parse_long_rule(char *data, struct smack_parsed_rule *rule,
> +				int import, int tokens)
>  {
> -	char *subject;
> -	char *object;
> -	char *access1;
> -	char *access2;
> -	int datalen;
> -	int rc = -1;
> +	ssize_t cnt = 0;
> +	char *tok[4];
> +	int i;
>  
> -	/* This is inefficient */
> -	datalen = strlen(data);
> +	/*
> +	 * Parsing the rule in-place, filling all white-spaces with '\0'
> +	 */
> +	for (i = 0; i < tokens; ++i) {
> +		while (isspace(data[cnt]))
> +			data[cnt++] = '\0';
>  
> -	/* Our first element can be 64 + \0 with no spaces */
> -	subject = kzalloc(datalen + 1, GFP_KERNEL);
> -	if (subject == NULL)
> -		return -1;
> -	object = kzalloc(datalen, GFP_KERNEL);
> -	if (object == NULL)
> -		goto free_out_s;
> -	access1 = kzalloc(datalen, GFP_KERNEL);
> -	if (access1 == NULL)
> -		goto free_out_o;
> -	access2 = kzalloc(datalen, GFP_KERNEL);
> -	if (access2 == NULL)
> -		goto free_out_a;
> -
> -	if (change) {
> -		if (sscanf(data, "%s %s %s %s",
> -			subject, object, access1, access2) == 4)
> -			rc = smk_fill_rule(subject, object, access1, access2,
> -				rule, import, 0);
> -	} else {
> -		if (sscanf(data, "%s %s %s", subject, object, access1) == 3)
> -			rc = smk_fill_rule(subject, object, access1, NULL,
> -				rule, import, 0);
> +		if (data[cnt] == '\0')
> +			/* Unexpected end of data */
> +			return -1;
> +
> +		tok[i] = data + cnt;
> +
> +		while (data[cnt] && !isspace(data[cnt]))
> +			++cnt;
>  	}
> +	while (isspace(data[cnt]))
> +		data[cnt++] = '\0';
>  
> -	kfree(access2);
> -free_out_a:
> -	kfree(access1);
> -free_out_o:
> -	kfree(object);
> -free_out_s:
> -	kfree(subject);
> -	return rc;
> +	while (i < 4)
> +		tok[i++] = NULL;
> +
> +	if (smk_fill_rule(tok[0], tok[1], tok[2], tok[3], rule, import, 0))
> +		return -1;
> +
> +	return cnt;
>  }
>  
>  #define SMK_FIXED24_FMT	0	/* Fixed 24byte label format */
> @@ -449,9 +436,10 @@ static ssize_t smk_write_rules_list(struct file *file, const char __user *buf,
>  {
>  	struct smack_parsed_rule rule;
>  	char *data;
> -	int datalen;
> -	int rc = -EINVAL;
> -	int load = 0;
> +	int rc;
> +	int trunc = 0;
> +	int tokens;
> +	ssize_t cnt = 0;
>  
>  	/*
>  	 * No partial writes.
> @@ -466,11 +454,14 @@ static ssize_t smk_write_rules_list(struct file *file, const char __user *buf,
>  		 */
>  		if (count != SMK_OLOADLEN && count != SMK_LOADLEN)
>  			return -EINVAL;
> -		datalen = SMK_LOADLEN;
> -	} else
> -		datalen = count + 1;
> +	} else {
> +		if (count >= PAGE_SIZE) {
> +			count = PAGE_SIZE - 1;
> +			trunc = 1;
> +		}
> +	}
>  
> -	data = kzalloc(datalen, GFP_KERNEL);
> +	data = kmalloc(count + 1, GFP_KERNEL);
>  	if (data == NULL)
>  		return -ENOMEM;
>  
> @@ -479,36 +470,49 @@ static ssize_t smk_write_rules_list(struct file *file, const char __user *buf,
>  		goto out;
>  	}
>  
> -	if (format == SMK_LONG_FMT) {
> -		/*
> -		 * Be sure the data string is terminated.
> -		 */
> -		data[count] = '\0';
> -		if (smk_parse_long_rule(data, &rule, 1, 0))
> -			goto out;
> -	} else if (format == SMK_CHANGE_FMT) {
> -		data[count] = '\0';
> -		if (smk_parse_long_rule(data, &rule, 1, 1))
> -			goto out;
> -	} else {
> -		/*
> -		 * More on the minor hack for backward compatibility
> -		 */
> -		if (count == (SMK_OLOADLEN))
> -			data[SMK_OLOADLEN] = '-';
> -		if (smk_parse_rule(data, &rule, 1))
> +	/*
> +	 * In case of parsing only part of user buf,
> +	 * avoid having partial rule at the data buffer
> +	 */
> +	if (trunc) {
> +		while (count > 0 && (data[count - 1] != '\n'))
> +			--count;
> +		if (count == 0) {
> +			rc = -EINVAL;
>  			goto out;
> +		}
>  	}
>  
> -	if (rule_list == NULL) {
> -		load = 1;
> -		rule_list = &rule.smk_subject->smk_rules;
> -		rule_lock = &rule.smk_subject->smk_rules_lock;
> +	data[count] = '\0';
> +	tokens = (format == SMK_CHANGE_FMT ? 4 : 3);
> +	while (cnt < count) {
> +		if (format == SMK_FIXED24_FMT) {
> +			rc = smk_parse_rule(data, &rule, 1);
> +			if (rc != 0) {
> +				rc = -EINVAL;
> +				goto out;
> +			}
> +			cnt = count;
> +		} else {
> +			rc = smk_parse_long_rule(data + cnt, &rule, 1, tokens);
> +			if (rc <= 0) {
> +				rc = -EINVAL;
> +				goto out;
> +			}
> +			cnt += rc;
> +		}
> +
> +		if (rule_list == NULL)
> +			rc = smk_set_access(&rule, &rule.smk_subject->smk_rules,
> +				&rule.smk_subject->smk_rules_lock, 1);
> +		else
> +			rc = smk_set_access(&rule, rule_list, rule_lock, 0);
> +
> +		if (rc)
> +			goto out;
>  	}
>  
> -	rc = smk_set_access(&rule, rule_list, rule_lock, load);
> -	if (rc == 0)
> -		rc = count;
> +	rc = cnt;
>  out:
>  	kfree(data);
>  	return rc;
> @@ -1829,7 +1833,6 @@ static ssize_t smk_user_access(struct file *file, const char __user *buf,
>  {
>  	struct smack_parsed_rule rule;
>  	char *data;
> -	char *cod;
>  	int res;
>  
>  	data = simple_transaction_get(file, buf, count);
> @@ -1842,18 +1845,12 @@ static ssize_t smk_user_access(struct file *file, const char __user *buf,
>  		res = smk_parse_rule(data, &rule, 0);
>  	} else {
>  		/*
> -		 * Copy the data to make sure the string is terminated.
> +		 * simple_transaction_get() returns null-terminated data
>  		 */
> -		cod = kzalloc(count + 1, GFP_KERNEL);
> -		if (cod == NULL)
> -			return -ENOMEM;
> -		memcpy(cod, data, count);
> -		cod[count] = '\0';
> -		res = smk_parse_long_rule(cod, &rule, 0, 0);
> -		kfree(cod);
> +		res = smk_parse_long_rule(data, &rule, 0, 3);
>  	}
>  
> -	if (res)
> +	if (res < 0)
>  		return -EINVAL;
>  
>  	res = smk_access(rule.smk_subject, rule.smk_object,

