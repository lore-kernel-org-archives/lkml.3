Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969AbaIZSkz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 14:40:55 -0400
Received: from lists.s-osg.org ([54.187.51.154]:37950 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753865AbaIZSky (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 14:40:54 -0400
Message-ID: <5425B333.4090109@osg.samsung.com>
Date: Fri, 26 Sep 2014 12:40:51 -0600
From: Shuah Khan <shuahkh@osg.samsung.com>
Organization: Samsung Open Source Group
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
CC: Randy Dunlap <rdunlap@infradead.org>, Shuah Khan <shuah.kh@samsung.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH v2] init: Add strictinit to disable init= fallbacks
References: <f93b6d019337edb73c13d80f8c2495d238922538.1411754556.git.luto@amacapital.net>
In-Reply-To: <f93b6d019337edb73c13d80f8c2495d238922538.1411754556.git.luto@amacapital.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2014 12:04 PM, Andy Lutomirski wrote:
> If a user puts init=/whatever on the command line and /whatever
> can't be run, then the kernel will try a few default options before
> giving up.  If init=/whatever came from a bootloader prompt, then
> this probably makes sense.  On the other hand, if it comes from a
> script (e.g. a tool like virtme or perhaps a future kselftest
> script), then the fallbacks are likely to exist, but they'll do the
> wrong thing.  For example, they might unexpectedly invoke systemd.
> 
> This adds a new option called strictinit.  If init= and strictinit
> are both set, and the init= binary is not executable, then the
> kernel will panic immediately.  If strictinit is set but init= is
> not set, then strictinit will have no effect, because the only real
> alternative would be to panic regardless of the contents of the root
> fs.
> 
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> ---
> 
> Now cc-ing Rusty (who probably cares more about startup options than
> anyone else) and Shuah (who might want to use this at some point).
> 
> Changes from v1:
>  - Add missing "if" to the docs (Randy Dunlap)
> 
>  Documentation/kernel-parameters.txt |  8 ++++++++
>  init/main.c                         | 10 ++++++++++
>  2 files changed, 18 insertions(+)
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 10d51c2f10d7..3dc921714002 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -3236,6 +3236,14 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>  	stifb=		[HW]
>  			Format: bpp:<bpp1>[:<bpp2>[:<bpp3>...]]
>  
> +	strictinit	[KNL,BOOT]
> +			Normally, if the kernel can't find the init binary
> +			specified by rdinit= and/or init=, then it will
> +			try several fallbacks.  If strictinit is set
> +			and the value specified by init= does not work,
> +			then the kernel will panic instead.
> +			This has no effect if init= is not specified.
> +
>  	sunrpc.min_resvport=
>  	sunrpc.max_resvport=
>  			[NFS,SUNRPC]
> diff --git a/init/main.c b/init/main.c
> index bb1aed928f21..4fd80dcef9d0 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -131,6 +131,7 @@ static char *initcall_command_line;
>  
>  static char *execute_command;
>  static char *ramdisk_execute_command;
> +static bool strictinit;
>  
>  /*
>   * Used to generate warnings if static_key manipulation functions are used
> @@ -347,6 +348,13 @@ static int __init rdinit_setup(char *str)
>  }
>  __setup("rdinit=", rdinit_setup);
>  
> +static int __init strictinit_setup(char *str)
> +{
> +	strictinit = true;
> +	return 1;
> +}
> +__setup("strictinit", strictinit_setup);
> +
>  #ifndef CONFIG_SMP
>  static const unsigned int setup_max_cpus = NR_CPUS;
>  #ifdef CONFIG_X86_LOCAL_APIC
> @@ -962,6 +970,8 @@ static int __ref kernel_init(void *unused)
>  			return 0;
>  		pr_err("Failed to execute %s (error %d).  Attempting defaults...\n",
>  			execute_command, ret);
> +		if (strictinit)
> +			panic("Requested init failed and strictinit was set.");

It would make sense to not print Attempting defaults for strictinit
case. I would recommend making it an else case and changing the
strictinit message to or something along the lines:

panic("Failed to execute %s (error %d). Not attempting defaults in
strictinit mode...\n", execute_command, ret);


-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
