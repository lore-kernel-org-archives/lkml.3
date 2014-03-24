Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835AbaCXLah (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 07:30:37 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:48459 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259AbaCXLaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 07:30:35 -0400
Message-ID: <53301754.30901@hitachi.com>
Date: Mon, 24 Mar 2014 20:30:28 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Andy Honig <ahonig@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jianguo Wu <wujianguo@huawei.com>,
        David Rientjes <rientjes@google.com>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH] x86, kaslr: fix module lock ordering problem
References: <20140310204248.GA1958@www.outflux.net>
In-Reply-To: <20140310204248.GA1958@www.outflux.net>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/03/11 5:42), Kees Cook wrote:
> There was a potential lock ordering problem with the module kASLR patch
> ("x86, kaslr: randomize module base load address"). This patch removes
> the usage of the module_mutex and creates a new mutex to protect the
> module base address offset value.
> 
> Chain exists of:
>   text_mutex --> kprobe_insn_slots.mutex --> module_mutex
> 
> [    0.515561]  Possible unsafe locking scenario:
> [    0.515561]
> [    0.515561]        CPU0                    CPU1
> [    0.515561]        ----                    ----
> [    0.515561]   lock(module_mutex);
> [    0.515561]                                lock(kprobe_insn_slots.mutex);
> [    0.515561]                                lock(module_mutex);
> [    0.515561]   lock(text_mutex);
> [    0.515561]
> [    0.515561]  *** DEADLOCK ***
> 
> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> Signed-off-by: Andy Honig <ahonig@google.com>
> Signed-off-by: Kees Cook <keescook@chromium.org>

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thanks for fix that ! :)


> ---
>  arch/x86/kernel/module.c |    7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/module.c b/arch/x86/kernel/module.c
> index 49483137371f..e69f9882bf95 100644
> --- a/arch/x86/kernel/module.c
> +++ b/arch/x86/kernel/module.c
> @@ -48,6 +48,9 @@ do {							\
>  static unsigned long module_load_offset;
>  static int randomize_modules = 1;
>  
> +/* Mutex protects the module_load_offset. */
> +static DEFINE_MUTEX(module_kaslr_mutex);
> +
>  static int __init parse_nokaslr(char *p)
>  {
>  	randomize_modules = 0;
> @@ -58,7 +61,7 @@ early_param("nokaslr", parse_nokaslr);
>  static unsigned long int get_module_load_offset(void)
>  {
>  	if (randomize_modules) {
> -		mutex_lock(&module_mutex);
> +		mutex_lock(&module_kaslr_mutex);
>  		/*
>  		 * Calculate the module_load_offset the first time this
>  		 * code is called. Once calculated it stays the same until
> @@ -67,7 +70,7 @@ static unsigned long int get_module_load_offset(void)
>  		if (module_load_offset == 0)
>  			module_load_offset =
>  				(get_random_int() % 1024 + 1) * PAGE_SIZE;
> -		mutex_unlock(&module_mutex);
> +		mutex_unlock(&module_kaslr_mutex);
>  	}
>  	return module_load_offset;
>  }
> 


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


