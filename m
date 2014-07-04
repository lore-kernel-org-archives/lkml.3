Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756474AbaGDAxR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 20:53:17 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:60030 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755557AbaGDAxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 20:53:15 -0400
Message-ID: <53B5FAF4.2050705@hitachi.com>
Date: Fri, 04 Jul 2014 09:53:08 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH] modules: Fix build error in moduleloader.h
References: <20140703092121.082e0366@gandalf.local.home>
In-Reply-To: <20140703092121.082e0366@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/07/03 22:21), Steven Rostedt wrote:
> Fengguang Wu's build bot detected that if moduleloader.h is included in
> a C file (used by ftrace and kprobes to access module_alloc() when
> available), that it can fail to build if CONFIG_MODULES and
> CONFIG_MODULES_USE_ELF_REL is not defined.
> 
> This is because there's a printk() that dereferences struct module to
> print the name of the module. But as struct module does not exist when
> CONFIG_MODULES is not defined we get this error:
> 
>    include/linux/moduleloader.h: In function 'apply_relocate':
>>> include/linux/moduleloader.h:48:63: error: dereferencing pointer to incomplete type  
>      printk(KERN_ERR "module %s: REL relocation unsupported\n", me->name);
>                                                                   ^
> Avoid the printk if CONFIG_MODULES is not set.

Looks OK to me. BTW, CONFIG_KPROBES depends on CONFIG_MODULES,
so currently kprobes itself doesn't hit that problem.

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thank you, :)

> 
> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
> diff --git a/include/linux/moduleloader.h b/include/linux/moduleloader.h
> index 560ca53..d9da807 100644
> --- a/include/linux/moduleloader.h
> +++ b/include/linux/moduleloader.h
> @@ -45,7 +45,10 @@ static inline int apply_relocate(Elf_Shdr *sechdrs,
>  				 unsigned int relsec,
>  				 struct module *me)
>  {
> +/* me->name only exists if modules are enabled */
> +#ifdef CONFIG_MODULES
>  	printk(KERN_ERR "module %s: REL relocation unsupported\n", me->name);
> +#endif
>  	return -ENOEXEC;
>  }
>  #endif
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


