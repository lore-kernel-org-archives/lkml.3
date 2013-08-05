Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482Ab3HEJEO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 05:04:14 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:33649 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754354Ab3HEJEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 05:04:13 -0400
Message-ID: <51FF6A89.9020404@hitachi.com>
Date: Mon, 05 Aug 2013 18:04:09 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH 03/13] tracing/kprobes: Make stack and memory fetch functions
 static
References: <1375261410-11219-1-git-send-email-namhyung@kernel.org> <1375261410-11219-4-git-send-email-namhyung@kernel.org>
In-Reply-To: <1375261410-11219-4-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/07/31 18:03), Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> Those fetch functions need to be implemented differently for kprobes
> and uprobes.  Since the symbol and deref fetch functions don't call
> those directly anymore, we can make them static and implement them
> separately.

Hmm, I think this should be done in 1/13, since this is partially
reverted it in the same series. If you concern about tweaking other
one's patch, you can add you singed-off-by to it. :)

Thank you,

> 
> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  kernel/trace/trace_kprobe.c |  8 ++++----
>  kernel/trace/trace_probe.h  | 10 +---------
>  2 files changed, 5 insertions(+), 13 deletions(-)
> 
> diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
> index c91eca015758..174c30e47c41 100644
> --- a/kernel/trace/trace_kprobe.c
> +++ b/kernel/trace/trace_kprobe.c
> @@ -753,7 +753,7 @@ static const struct file_operations kprobe_profile_ops = {
>   * kprobes-specific fetch functions
>   */
>  #define DEFINE_FETCH_stack(type)					\
> -__kprobes void FETCH_FUNC_NAME(stack, type)(struct pt_regs *regs,	\
> +static __kprobes void FETCH_FUNC_NAME(stack, type)(struct pt_regs *regs,\
>  					  void *offset, void *dest)	\
>  {									\
>  	*(type *)dest = (type)regs_get_kernel_stack_nth(regs,		\
> @@ -765,7 +765,7 @@ DEFINE_BASIC_FETCH_FUNCS(stack)
>  #define fetch_stack_string_size	NULL
>  
>  #define DEFINE_FETCH_memory(type)					\
> -__kprobes void FETCH_FUNC_NAME(memory, type)(struct pt_regs *regs,	\
> +static __kprobes void FETCH_FUNC_NAME(memory, type)(struct pt_regs *regs,\
>  					  void *addr, void *dest)	\
>  {									\
>  	type retval;							\
> @@ -779,7 +779,7 @@ DEFINE_BASIC_FETCH_FUNCS(memory)
>   * Fetch a null-terminated string. Caller MUST set *(u32 *)dest with max
>   * length and relative data location.
>   */
> -__kprobes void FETCH_FUNC_NAME(memory, string)(struct pt_regs *regs,
> +static __kprobes void FETCH_FUNC_NAME(memory, string)(struct pt_regs *regs,
>  					       void *addr, void *dest)
>  {
>  	long ret;
> @@ -816,7 +816,7 @@ __kprobes void FETCH_FUNC_NAME(memory, string)(struct pt_regs *regs,
>  }
>  
>  /* Return the length of string -- including null terminal byte */
> -__kprobes void FETCH_FUNC_NAME(memory, string_size)(struct pt_regs *regs,
> +static __kprobes void FETCH_FUNC_NAME(memory, string_size)(struct pt_regs *regs,
>  						    void *addr, void *dest)
>  {
>  	mm_segment_t old_fs;
> diff --git a/kernel/trace/trace_probe.h b/kernel/trace/trace_probe.h
> index 1c37c813e5e5..50f152eb7ef0 100644
> --- a/kernel/trace/trace_probe.h
> +++ b/kernel/trace/trace_probe.h
> @@ -171,24 +171,16 @@ DECLARE_FETCH_FUNC(method, u32);		\
>  DECLARE_FETCH_FUNC(method, u64)
>  
>  /*
> - * Declare fetch functions
> + * Declare common fetch functions for both of kprobes and uprobes
>   */
>  DECLARE_BASIC_FETCH_FUNCS(reg);
>  #define fetch_reg_string		NULL
>  #define fetch_reg_string_size		NULL
>  
> -DECLARE_BASIC_FETCH_FUNCS(stack);
> -#define fetch_stack_string		NULL
> -#define fetch_stack_string_size		NULL
> -
>  DECLARE_BASIC_FETCH_FUNCS(retval);
>  #define fetch_retval_string		NULL
>  #define fetch_retval_string_size	NULL
>  
> -DECLARE_BASIC_FETCH_FUNCS(memory);
> -DECLARE_FETCH_FUNC(memory, string);
> -DECLARE_FETCH_FUNC(memory, string_size);
> -
>  DECLARE_BASIC_FETCH_FUNCS(symbol);
>  DECLARE_FETCH_FUNC(symbol, string);
>  DECLARE_FETCH_FUNC(symbol, string_size);
> 


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


