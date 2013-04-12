Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044Ab3DLFrN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 01:47:13 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59563 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842Ab3DLFrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 01:47:10 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.9
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-2
Message-ID: <51679FB2.9080309@jp.fujitsu.com>
Date: Fri, 12 Apr 2013 14:46:26 +0900
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, WANG Chao <chaowang@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 3/4] x86, kdump: Change crashkernel_high/low= to crashkernel=,high/low
References: <1365622759-2133-1-git-send-email-yinghai@kernel.org> <1365622759-2133-5-git-send-email-yinghai@kernel.org>
In-Reply-To: <1365622759-2133-5-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/04/11 4:39), Yinghai Lu wrote:
<cut>
> Index: linux-2.6/kernel/kexec.c
> ===================================================================
> --- linux-2.6.orig/kernel/kexec.c
> +++ linux-2.6/kernel/kexec.c
> @@ -1368,35 +1368,108 @@ static int __init parse_crashkernel_simp
>   	return 0;
>   }
>   
> +#define SUFFIX_HIGH 0
> +#define SUFFIX_LOW  1
> +#define SUFFIX_NULL 2
> +static __initdata char *suffix_tbl[] = {
> +	[SUFFIX_HIGH] = ",high",
> +	[SUFFIX_LOW]  = ",low",
> +	[SUFFIX_NULL] = NULL,
> +};
> +
>   /*
> - * That function is the entry point for command line parsing and should be
> - * called from the arch-specific code.
> + * That function parses "suffix"  crashkernel command lines like
> + *
> + *	crashkernel=size,[high|low]
> + *
> + * It returns 0 on success and -EINVAL on failure.
>    */
> +static int __init parse_crashkernel_suffix(char *cmdline,
> +					   unsigned long long	*crash_size,
> +					   unsigned long long	*crash_base,
> +					   const char *suffix)
> +{
> +	char *cur = cmdline;
> +
> +	*crash_size = memparse(cmdline, &cur);
> +	if (cmdline == cur) {
> +		pr_warn("crashkernel: memory value expected\n");
> +		return -EINVAL;
> +	}
> +
> +	/* check with suffix */
> +	if (!strncmp(cur, suffix, strlen(suffix)))
> +		return 0;

What kind of strings do you intend to be passed here? The syntax that
matches this check would be

  [0-9]+[kmgKMG]?(,low|,high){.*(,low|,high)}*

though memparse() part might be less precise. For example, the following
one passes the check since it ends with ",low" and  ",high" follows
"12345K" to be parsed by memparse(). Is this within your intension for
ease of implementation?

  crashkernel=12345K,highfoobar,highabcd,low

> +
> +	pr_warn("crashkernel: unrecognized char\n");
> +	return -EINVAL;
> +}

I like functions checking errornous cases in the middle and ends with
successful case. How about:

/* check with suffix */
if (strncmp(cur, suffix, strlen(suffix)) {
    pr_warn("crashkernel: unrecognized char\n");
    return -EINVAL;
}

return 0;

-- 
Thanks.
HATAYAMA, Daisuke

