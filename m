Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761303Ab3DJTOh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 15:14:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63350 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759504Ab3DJTOf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 15:14:35 -0400
Date: Wed, 10 Apr 2013 15:14:16 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, WANG Chao <chaowang@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: Re: [PATCH v4 3/4] x86, kdump: Change crashkernel_high/low= to
 crashkernel=,high/low
Message-ID: <20130410191416.GE6602@redhat.com>
References: <1365537710-1176-1-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365537710-1176-1-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 09, 2013 at 01:01:50PM -0700, Yinghai Lu wrote:
> Per hpa, use crashkernel=X,high crashkernel=Y,low instead of
> crashkernel_hign=X crashkernel_low=Y. As that could be extensible.
> 
> -v2: according to Vivek, change delimiter to ;
> -v3: let hign and low only handle simple form and it conforms to
> 	description in kernel-parameters.txt
>      still keep crashkernel=X override any crashkernel=X,high
>         crashkernel=Y,low
> -v4: update get_last_crashkernel returning and add more strict
>      checking in parse_crashkernel_simple() found by HATAYAMA.
> -v5: Change delimiter back to , according to HPA.
>      also separate parse_suffix from parse_simper according to vivek.
> 	so we can avoid @pos in that path.
> 
> Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

This one looks good to me. Looks like you posted this one independet of
previous series.

Can you repost the final version in a series again. I will do some
more testing and ack it.

Thanks
Vivek

> 
> ---
>  Documentation/kernel-parameters.txt |   10 +--
>  arch/x86/kernel/setup.c             |    6 +-
>  kernel/kexec.c                      |  103 +++++++++++++++++++++++++++++++-----
>  3 files changed, 98 insertions(+), 21 deletions(-)
> 
> Index: linux-2.6/Documentation/kernel-parameters.txt
> ===================================================================
> --- linux-2.6.orig/Documentation/kernel-parameters.txt
> +++ linux-2.6/Documentation/kernel-parameters.txt
> @@ -603,16 +603,16 @@ bytes respectively. Such letter suffixes
>  			a memory unit (amount[KMG]). See also
>  			Documentation/kdump/kdump.txt for an example.
>  
> -	crashkernel_high=size[KMG]
> +	crashkernel=size[KMG],high
>  			[KNL, x86_64] range could be above 4G. Allow kernel
>  			to allocate physical memory region from top, so could
>  			be above 4G if system have more than 4G ram installed.
>  			Otherwise memory region will be allocated below 4G, if
>  			available.
>  			It will be ignored if crashkernel=X is specified.
> -	crashkernel_low=size[KMG]
> -			[KNL, x86_64] range under 4G. When crashkernel_high= is
> -			passed, kernel could allocate physical memory region
> +	crashkernel=size[KMG],low
> +			[KNL, x86_64] range under 4G. When crashkernel=X,high
> +			is passed, kernel could allocate physical memory region
>  			above 4G, that cause second kernel crash on system
>  			that require some amount of low memory, e.g. swiotlb
>  			requires at least 64M+32K low memory.  Kernel would
> @@ -620,7 +620,7 @@ bytes respectively. Such letter suffixes
>  			This one let user to specify own low range under 4G
>  			for second kernel instead.
>  			0: to disable low allocation.
> -			It will be ignored when crashkernel_high=X is not used
> +			It will be ignored when crashkernel=X,high is not used
>  			or memory reserved is below 4G.
>  
>  	cs89x0_dma=	[HW,NET]
> Index: linux-2.6/arch/x86/kernel/setup.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/setup.c
> +++ linux-2.6/arch/x86/kernel/setup.c
> @@ -526,7 +526,7 @@ static void __init reserve_crashkernel_l
>  	int ret;
>  
>  	total_low_mem = memblock_mem_size(1UL<<(32-PAGE_SHIFT));
> -	/* crashkernel_low=YM */
> +	/* crashkernel=Y,low */
>  	ret = parse_crashkernel_low(boot_command_line, total_low_mem,
>  						&low_size, &base);
>  	if (ret != 0) {
> @@ -539,7 +539,7 @@ static void __init reserve_crashkernel_l
>  		low_size = swiotlb_size_or_default() + (8UL<<20);
>  		auto_set = true;
>  	} else {
> -		/* passed with crashkernel_low=0 ? */
> +		/* passed with crashkernel=0,low ? */
>  		if (!low_size)
>  			return;
>  	}
> @@ -579,7 +579,7 @@ static void __init reserve_crashkernel(v
>  	ret = parse_crashkernel(boot_command_line, total_mem,
>  			&crash_size, &crash_base);
>  	if (ret != 0 || crash_size <= 0) {
> -		/* crashkernel_high=XM */
> +		/* crashkernel=X,high */
>  		ret = parse_crashkernel_high(boot_command_line, total_mem,
>  				&crash_size, &crash_base);
>  		if (ret != 0 || crash_size <= 0)
> Index: linux-2.6/kernel/kexec.c
> ===================================================================
> --- linux-2.6.orig/kernel/kexec.c
> +++ linux-2.6/kernel/kexec.c
> @@ -1368,35 +1368,108 @@ static int __init parse_crashkernel_simp
>  	return 0;
>  }
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
>  /*
> - * That function is the entry point for command line parsing and should be
> - * called from the arch-specific code.
> + * That function parses "suffix"  crashkernel command lines like
> + *
> + *	crashkernel=size,[high|low]
> + *
> + * It returns 0 on success and -EINVAL on failure.
>   */
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
> +
> +	pr_warn("crashkernel: unrecognized char\n");
> +	return -EINVAL;
> +}
> +
> +static __init char *get_last_crashkernel(char *cmdline,
> +			     const char *name,
> +			     const char *suffix)
> +{
> +	char *p = cmdline, *ck_cmdline = NULL;
> +
> +	/* find crashkernel and use the last one if there are more */
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
> +next:
> +		p = strstr(p+1, name);
> +	}
> +
> +	if (!ck_cmdline)
> +		return NULL;
> +
> +	return ck_cmdline;
> +}
> +
>  static int __init __parse_crashkernel(char *cmdline,
>  			     unsigned long long system_ram,
>  			     unsigned long long *crash_size,
>  			     unsigned long long *crash_base,
> -				const char *name)
> +			     const char *name,
> +			     const char *suffix)
>  {
> -	char 	*p = cmdline, *ck_cmdline = NULL;
>  	char	*first_colon, *first_space;
> +	char	*ck_cmdline;
>  
>  	BUG_ON(!crash_size || !crash_base);
>  	*crash_size = 0;
>  	*crash_base = 0;
>  
> -	/* find crashkernel and use the last one if there are more */
> -	p = strstr(p, name);
> -	while (p) {
> -		ck_cmdline = p;
> -		p = strstr(p+1, name);
> -	}
> +	ck_cmdline = get_last_crashkernel(cmdline, name, suffix);
>  
>  	if (!ck_cmdline)
>  		return -EINVAL;
>  
>  	ck_cmdline += strlen(name);
>  
> +	if (suffix)
> +		return parse_crashkernel_suffix(ck_cmdline, crash_size,
> +				crash_base, suffix);
>  	/*
>  	 * if the commandline contains a ':', then that's the extended
>  	 * syntax -- if not, it must be the classic syntax
> @@ -1413,13 +1486,17 @@ static int __init __parse_crashkernel(ch
>  	return 0;
>  }
>  
> +/*
> + * That function is the entry point for command line parsing and should be
> + * called from the arch-specific code.
> + */
>  int __init parse_crashkernel(char *cmdline,
>  			     unsigned long long system_ram,
>  			     unsigned long long *crash_size,
>  			     unsigned long long *crash_base)
>  {
>  	return __parse_crashkernel(cmdline, system_ram, crash_size, crash_base,
> -					"crashkernel=");
> +					"crashkernel=", NULL);
>  }
>  
>  int __init parse_crashkernel_high(char *cmdline,
> @@ -1428,7 +1505,7 @@ int __init parse_crashkernel_high(char *
>  			     unsigned long long *crash_base)
>  {
>  	return __parse_crashkernel(cmdline, system_ram, crash_size, crash_base,
> -					"crashkernel_high=");
> +				"crashkernel=", suffix_tbl[SUFFIX_HIGH]);
>  }
>  
>  int __init parse_crashkernel_low(char *cmdline,
> @@ -1437,7 +1514,7 @@ int __init parse_crashkernel_low(char *c
>  			     unsigned long long *crash_base)
>  {
>  	return __parse_crashkernel(cmdline, system_ram, crash_size, crash_base,
> -					"crashkernel_low=");
> +				"crashkernel=", suffix_tbl[SUFFIX_LOW]);
>  }
>  
>  static void update_vmcoreinfo_note(void)
