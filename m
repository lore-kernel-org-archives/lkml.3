Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739Ab3LJLAb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 06:00:31 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:51476 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705Ab3LJLA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 06:00:29 -0500
Message-ID: <52A6F455.4070807@hitachi.com>
Date: Tue, 10 Dec 2013 20:00:37 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 12/17] tracing/probes: Implement 'memory' fetch method
 for uprobes
References: <1386570005-3368-1-git-send-email-namhyung@kernel.org> <1386570005-3368-13-git-send-email-namhyung@kernel.org>
In-Reply-To: <1386570005-3368-13-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/12/09 15:20), Namhyung Kim wrote:

> diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
> index b4f28bc39959..d0b4a42dafcf 100644
> --- a/kernel/trace/trace_probe.c
> +++ b/kernel/trace/trace_probe.c
> @@ -103,83 +103,6 @@ DEFINE_BASIC_FETCH_FUNCS(retval)
>  #define fetch_retval_string		NULL
>  #define fetch_retval_string_size	NULL
>  
> -#define DEFINE_FETCH_memory(type)					\
> -__kprobes void FETCH_FUNC_NAME(memory, type)(struct pt_regs *regs,	\
> -					  void *addr, void *dest)	\
> -{									\
> -	type retval;							\
> -	if (probe_kernel_address(addr, retval))				\
> -		*(type *)dest = 0;					\
> -	else								\
> -		*(type *)dest = retval;					\
> -}
> -DEFINE_BASIC_FETCH_FUNCS(memory)
> -/*
> - * Fetch a null-terminated string. Caller MUST set *(u32 *)dest with max
> - * length and relative data location.
> - */
> -__kprobes void FETCH_FUNC_NAME(memory, string)(struct pt_regs *regs,
> -						      void *addr, void *dest)
> -{
> -	long ret;
> -	int maxlen = get_rloc_len(*(u32 *)dest);
> -	u8 *dst = get_rloc_data(dest);
> -	u8 *src = addr;
> -	mm_segment_t old_fs = get_fs();
> -
> -	if (!maxlen)
> -		return;
> -
> -	/*
> -	 * Try to get string again, since the string can be changed while
> -	 * probing.
> -	 */
> -	set_fs(KERNEL_DS);
> -	pagefault_disable();
> -
> -	do
> -		ret = __copy_from_user_inatomic(dst++, src++, 1);
> -	while (dst[-1] && ret == 0 && src - (u8 *)addr < maxlen);
> -
> -	dst[-1] = '\0';
> -	pagefault_enable();
> -	set_fs(old_fs);
> -
> -	if (ret < 0) {	/* Failed to fetch string */
> -		((u8 *)get_rloc_data(dest))[0] = '\0';
> -		*(u32 *)dest = make_data_rloc(0, get_rloc_offs(*(u32 *)dest));
> -	} else {
> -		*(u32 *)dest = make_data_rloc(src - (u8 *)addr,
> -					      get_rloc_offs(*(u32 *)dest));
> -	}
> -}
> -
> -/* Return the length of string -- including null terminal byte */
> -__kprobes void FETCH_FUNC_NAME(memory, string_size)(struct pt_regs *regs,
> -							void *addr, void *dest)
> -{
> -	mm_segment_t old_fs;
> -	int ret, len = 0;
> -	u8 c;
> -
> -	old_fs = get_fs();
> -	set_fs(KERNEL_DS);
> -	pagefault_disable();
> -
> -	do {
> -		ret = __copy_from_user_inatomic(&c, (u8 *)addr + len, 1);
> -		len++;
> -	} while (c && ret == 0 && len < MAX_STRING_SIZE);
> -
> -	pagefault_enable();
> -	set_fs(old_fs);
> -
> -	if (ret < 0)	/* Failed to check the length */
> -		*(u32 *)dest = 0;
> -	else
> -		*(u32 *)dest = len;
> -}
> -
>  /* Dereference memory access function */
>  struct deref_fetch_param {
>  	struct fetch_param	orig;
> @@ -493,7 +416,7 @@ static int parse_probe_arg(char *arg, const struct fetch_type *t,
>  			dprm->offset = offset;
>  			dprm->fetch = t->fetch[FETCH_MTD_memory];
>  			dprm->fetch_size = get_fetch_size_function(t,
> -							dprm->fetch, ttbl);
> +							dprm->fetch, ftbl);

What is this change? I guess it should be included in 11/17...
The rest of this patch is good for me.

Thank you,


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


