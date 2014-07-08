Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237AbaGHCvh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 22:51:37 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:36482 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108AbaGHCvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 22:51:35 -0400
Message-ID: <53BB5CAF.5040303@hitachi.com>
Date: Tue, 08 Jul 2014 11:51:27 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH] modules: Fix build error in moduleloader.h
References: <20140703092121.082e0366@gandalf.local.home> <87wqbo7n6u.fsf@rustcorp.com.au>
In-Reply-To: <87wqbo7n6u.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/07/08 8:40), Rusty Russell wrote:
> Steven Rostedt <rostedt@goodmis.org> writes:
>> Fengguang Wu's build bot detected that if moduleloader.h is included in
>> a C file (used by ftrace and kprobes to access module_alloc() when
>> available), that it can fail to build if CONFIG_MODULES and
>> CONFIG_MODULES_USE_ELF_REL is not defined.
>>
>> This is because there's a printk() that dereferences struct module to
>> print the name of the module. But as struct module does not exist when
>> CONFIG_MODULES is not defined we get this error:
> 
> First, we have module_name() for exactly this.
> 
> Second, there are two places like this: you hit
> CONFIG_MODULES_USE_ELF_REL and not CONFIG_MODULES_USE_ELF_RELA.
> 
> (We could uninline them, and put them in module.c, but I think having
> them in the header is nice and self-documenting.)
> 
> So does this work for you?
> 
> Thanks,
> Rusty.
> PS.  Masami Hiramatsu, your review should have caught the second case,
>      at least :(

Oops, sorry, I missed the second one ... and this version seems good to me.

Thank you,

> 
> Subject: modules: Fix build error in moduleloader.h
> 
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
>>> include/linux/moduleloader.h:48:63: error: dereferencing pointer to
>>> incomplete type  
>      printk(KERN_ERR "module %s: REL relocation unsupported\n", me->name);
> 								  ^
> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> Based-on-the-true-story-by: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> 
> diff --git a/include/linux/moduleloader.h b/include/linux/moduleloader.h
> index 560ca53a75fa..7eeb9bbfb816 100644
> --- a/include/linux/moduleloader.h
> +++ b/include/linux/moduleloader.h
> @@ -45,7 +45,8 @@ static inline int apply_relocate(Elf_Shdr *sechdrs,
>  				 unsigned int relsec,
>  				 struct module *me)
>  {
> -	printk(KERN_ERR "module %s: REL relocation unsupported\n", me->name);
> +	printk(KERN_ERR "module %s: REL relocation unsupported\n",
> +	       module_name(me));
>  	return -ENOEXEC;
>  }
>  #endif
> @@ -67,7 +68,8 @@ static inline int apply_relocate_add(Elf_Shdr *sechdrs,
>  				     unsigned int relsec,
>  				     struct module *me)
>  {
> -	printk(KERN_ERR "module %s: REL relocation unsupported\n", me->name);
> +	printk(KERN_ERR "module %s: REL relocation unsupported\n",
> +	       module_name(me));
>  	return -ENOEXEC;
>  }
>  #endif
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


