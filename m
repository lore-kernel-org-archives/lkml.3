Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564Ab3FOTlD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 15:41:03 -0400
Received: from smtp102.biz.mail.gq1.yahoo.com ([98.137.12.177]:31397 "HELO
	smtp102.biz.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754351Ab3FOTlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 15:41:01 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: hkg4oFQVM1mjLusSgdue90wAqsEw_oVfMpZY7jzDWvf.Hk8
 srRKo4RortHvJXpHa8Ak.yYtJHw9wJrBSc0qyqPBA6t1816gqfotzF.oqcRi
 DiSBsj9a6aBEpWo_oXwuNQKPnw5JW_PWCvxgxTdYLeODT4IuSuCvqZimNE3R
 C4x.SKpa94ZOv.D3YNCPZ4VqKGk8wy8gUgaInNvXXygIYud7NeyOONSQ_qlV
 eKi01QXF8FH9RejJSSVNoYqeQ7xGvLRYUt6ZLsKzrMSYr4aW3KKBPDN8LZ7r
 iVzcyYOqPiTyMGfy8inyJElyc4zOHlsXrhrmjK_SBjmfLccjOPM5bSwyz85n
 pDxMuUW4xmSPq1JAeRzbfyazZlzxqqY8oDr0Joeu9OJrSf_blGoxOrN_Ceyl
 ORXVFW3g6BhrWhigbwNRPBLpiNsnymokroeqzJhGlY9YTWKNR3OyyNtYQIh3
 y75m2le5FDb2zgIyRKPKcpH3Mqc8l72NzS_.E0KK6c91Ky8g-
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-Rocket-Received: from [192.168.0.103] (casey@24.6.250.25 with plain)
        by smtp102.biz.mail.gq1.yahoo.com with SMTP; 15 Jun 2013 12:41:00 -0700 PDT
Message-ID: <51BCC359.2070300@schaufler-ca.com>
Date: Sat, 15 Jun 2013 12:41:13 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
CC: linux-security-module@vger.kernel.org, m.szyprowski@samsung.com,
        kyungmin.park@samsung.com, r.krypa@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 2/5] security: smack: avoid kmalloc() in smk_parse_long_rule()
References: <1371137352-31273-1-git-send-email-t.stanislaws@samsung.com> <1371137352-31273-3-git-send-email-t.stanislaws@samsung.com>
In-Reply-To: <1371137352-31273-3-git-send-email-t.stanislaws@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/13/2013 8:29 AM, Tomasz Stanislawski wrote:
> Function smk_parse_long_rule() allocates a number of temporary strings on heap
> (kmalloc cache). Moreover, the sizes of those allocations might be large if
> user calls write() for a long chunk. A big kmalloc triggers a heavy reclaim
> havoc and it is very likely to fail.
>
> This patch introduces smk_parse_substrings() function that parses a string into
> substring separated by whitespaces.  The buffer for substring is preallocated.
> It must store substring the worst case scenario which is SMK_LOAD2LEN in case
> of long rule parsing.
>
> The buffer is allocated on stack what is slightly faster than kmalloc().
>
> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>

There is hope for this patch, but it will need changes.

> ---
>  security/smack/smackfs.c |   67 +++++++++++++++++++++++-----------------------
>  1 file changed, 33 insertions(+), 34 deletions(-)
>
> diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
> index 9a3cd0d..46f111e 100644
> --- a/security/smack/smackfs.c
> +++ b/security/smack/smackfs.c
> @@ -364,6 +364,33 @@ static int smk_parse_rule(const char *data, struct smack_parsed_rule *rule,
>  }
>  
>  /**
> + * smk_parse_strings - parse white-space separated substring from a string
> + * @src: a long string to be parsed, null terminated
> + * @dst: a buffer for substrings, should be at least strlen(src)+1 bytes
> + * @args: table for parsed substring
> + * @size: number of slots in args table
> + *
> + * Returns number of parsed substrings
> + */
> +static int smk_parse_substrings(const char *src, char *dst,
> +	char *args[], int size)
> +{
> +	int cnt;
> +
> +	for (cnt = 0; cnt < size; ++cnt) {
> +		src = skip_spaces(src);
> +		if (*src == 0)
> +			break;
> +		args[cnt] = dst;
> +		for (; *src && !isspace(*src); ++src, ++dst)
> +			*dst = *src;
> +		*(dst++) = 0;
> +	}
> +
> +	return cnt;
> +}
> +
> +/**
>   * smk_parse_long_rule - parse Smack rule from rule string
>   * @data: string to be parsed, null terminated
>   * @rule: Will be filled with Smack parsed rule
> @@ -375,48 +402,20 @@ static int smk_parse_rule(const char *data, struct smack_parsed_rule *rule,
>  static int smk_parse_long_rule(const char *data, astruct smack_parsed_rule *rule,
>  				int import, int change)
>  {
> -	char *subject;
> -	char *object;
> -	char *access1;
> -	char *access2;
> -	int datalen;
> +	char tmp[SMK_LOAD2LEN + 1];

As mentioned in patch 1 of this set, you can't put something this
large on the stack. You could however use the same logic below on
a single allocated buffer and reduce the number of kzallocs from
four to one. That would get most of the improvement you're looking
for.

> +	char *args[4];
>  	int rc = -1;
>  
> -	/* This is inefficient */
> -	datalen = strlen(data);
> -
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
>  	if (change) {
> -		if (sscanf(data, "%s %s %s %s",
> -			subject, object, access1, access2) == 4)
> -			rc = smk_fill_rule(subject, object, access1, access2,
> +		if (smk_parse_substrings(data, tmp, args, 4) == 4)
> +			rc = smk_fill_rule(args[0], args[1], args[2], args[3],
>  				rule, import, 0);
>  	} else {
> -		if (sscanf(data, "%s %s %s", subject, object, access1) == 3)
> -			rc = smk_fill_rule(subject, object, access1, NULL,
> +		if (smk_parse_substrings(data, tmp, args, 3) == 3)
> +			rc = smk_fill_rule(args[0], args[1], args[2], NULL,
>  				rule, import, 0);
>  	}
>  
> -	kfree(access2);
> -free_out_a:
> -	kfree(access1);
> -free_out_o:
> -	kfree(object);
> -free_out_s:
> -	kfree(subject);
>  	return rc;
>  }
>  

