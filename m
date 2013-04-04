Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932930Ab3DDGzk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 02:55:40 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51368 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932888Ab3DDGzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 02:55:38 -0400
Message-ID: <515D23D5.70805@jp.fujitsu.com>
Date: Thu, 04 Apr 2013 15:55:17 +0900
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, WANG Chao <chaowang@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/4] x86, kdump: Change crashkernel_high/low= to crashkernel=;high/low
References: <1365035906-3208-1-git-send-email-yinghai@kernel.org> <1365035906-3208-5-git-send-email-yinghai@kernel.org>
In-Reply-To: <1365035906-3208-5-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/04/04 9:38), Yinghai Lu wrote:

> Index: linux-2.6/kernel/kexec.c
> ===================================================================
> --- linux-2.6.orig/kernel/kexec.c
> +++ linux-2.6/kernel/kexec.c
> @@ -1360,7 +1360,7 @@ static int __init parse_crashkernel_simp
>   
>   	if (*cur == '@')
>   		*crash_base = memparse(cur+1, &cur);
> -	else if (*cur != ' ' && *cur != '\0') {
> +	else if (*cur != ' ' && *cur != ';' && *cur != '\0') {
>   		pr_warning("crashkernel: unrecognized char\n");
>   		return -EINVAL;
>   	}

As I said below, ";high" or ";low" check should be here. It would be
enough to replace the condition *cur != ';' by strncmp(cur, ";high", 5)
|| strncmp(cur, ";low", 4).

> @@ -1368,58 +1368,108 @@ static int __init parse_crashkernel_simp
>   	return 0;
>   }
>   
> -/*
> - * That function is the entry point for command line parsing and should be
> - * called from the arch-specific code.
> - */
> +#define SUFFIX_HIGH 0
> +#define SUFFIX_LOW  1
> +#define SUFFIX_NULL 2
> +static __initdata char *suffix_tbl[] = {
> +	[SUFFIX_HIGH] = ";high",
> +	[SUFFIX_LOW]  = ";low",
> +	[SUFFIX_NULL] = NULL,
> +};
> +
> +static __init char *get_last_crashkernel(char *cmdline,
> +			     const char *name,
> +			     const char *suffix)
> +{
> +	char *p = cmdline, *ck_cmdline = NULL;
> +
> +	/* find crashkernel and use the last one if there are more */

Why did you choose the last one? Is there any reason you didn't choose
the first one?

Also, it's better to describe this bahaviour in
Documentations/kernel-parameter.txt.

> +	p = strstr(p, name);
> +	while (p) {
> +		char *end_p = strchr(p, ' ');
> +		char *q;
> +
> +		if (!end_p)
> +			end_p = p + strlen(p);
> +
> +		if (!suffix) {
> +			int i;
> +
> +			/* skip the one with any known suffix */
> +			for (i = 0; suffix_tbl[i]; i++) {
> +				q = end_p - strlen(suffix_tbl[i]);
> +				if (!strncmp(q, suffix_tbl[i],
> +					     strlen(suffix_tbl[i])))
> +					goto next;
> +			}
> +			ck_cmdline = p;
> +		} else {
> +			q = end_p - strlen(suffix);
> +			if (!strncmp(q, suffix, strlen(suffix)))
> +				ck_cmdline = p;
> +		}

It looks to me that this function does more than its name suggests. It
seems to me enough to get the last occurence of "crashkernel=<some
value>" and to leave the "<some value>" unknown for now.

The current code of yours checks if each "crashkernel=<some value>"
detected by strstr() ends with each of ";high" or ";low", but doesn't
check the formeter letters at all; e.g, "crashkernel=foobar;high" is passed.

Also, this function can be called in different contexts: from a variant
of parse_crashkernel_*(). Is it better to move this function in
reserve_crashkernel() and then pass the obtained "crashkernel=<some
value>" to a variant of parse_crashkernel_*() functions?

Thanks.
HATAYAMA, Daisuke




