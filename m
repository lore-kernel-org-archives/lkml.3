Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751707Ab3KVGFg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 01:05:36 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:44228 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726Ab3KVGFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 01:05:33 -0500
X-AuditID: 9c93017d-b7b24ae000002834-f1-528ef42b5de6
From: Namhyung Kim <namhyung@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei\(Jovi\)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH 2/2] tracing/probes: Fix basic print type functions
References: <1384749649-31447-1-git-send-email-namhyung@kernel.org>
	<1384749649-31447-2-git-send-email-namhyung@kernel.org>
	<20131120152245.GB24734@redhat.com>
Date: Fri, 22 Nov 2013 15:05:31 +0900
In-Reply-To: <20131120152245.GB24734@redhat.com> (Oleg Nesterov's message of
	"Wed, 20 Nov 2013 16:22:45 +0100")
Message-ID: <87k3g1t1hw.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oleg,

On Wed, 20 Nov 2013 16:22:45 +0100, Oleg Nesterov wrote:
> On 11/18, Namhyung Kim wrote:
>>
>> -DEFINE_BASIC_PRINT_TYPE_FUNC(u8, "%x", unsigned int)
>> -DEFINE_BASIC_PRINT_TYPE_FUNC(u16, "%x", unsigned int)
>> -DEFINE_BASIC_PRINT_TYPE_FUNC(u32, "%lx", unsigned long)
>> +DEFINE_BASIC_PRINT_TYPE_FUNC(u8 , "%x", unsigned char)
>> +DEFINE_BASIC_PRINT_TYPE_FUNC(u16, "%x", unsigned short)
>> +DEFINE_BASIC_PRINT_TYPE_FUNC(u32, "%x", unsigned int)
>> +DEFINE_BASIC_PRINT_TYPE_FUNC(s8,  "%d", signed char)
>> +DEFINE_BASIC_PRINT_TYPE_FUNC(s16, "%d", short)
>> +DEFINE_BASIC_PRINT_TYPE_FUNC(s32, "%d", int)
>> +#if BITS_PER_LONG == 32
>>  DEFINE_BASIC_PRINT_TYPE_FUNC(u64, "%llx", unsigned long long)
>> -DEFINE_BASIC_PRINT_TYPE_FUNC(s8, "%d", int)
>> -DEFINE_BASIC_PRINT_TYPE_FUNC(s16, "%d", int)
>> -DEFINE_BASIC_PRINT_TYPE_FUNC(s32, "%ld", long)
>>  DEFINE_BASIC_PRINT_TYPE_FUNC(s64, "%lld", long long)
>> +#else /* BITS_PER_LONG == 64 */
>> +DEFINE_BASIC_PRINT_TYPE_FUNC(u64, "%lx", unsigned long)
>> +DEFINE_BASIC_PRINT_TYPE_FUNC(s64, "%ld", long)
>> +#endif
>
> I must have missed something... Not only I do not understand why
> do we need "#if BITS_PER_LONG", I can't understand why
> DEFINE_BASIC_PRINT_TYPE_FUNC() needs "cast" argument.
>
> IOW, how about the patch below instead?

Looks good to me.

Masami, did you have any issue regarding the casts?

Thanks,
Namhyung

>
> --- x/kernel/trace/trace_probe.c
> +++ x/kernel/trace/trace_probe.c
> @@ -40,23 +40,23 @@ const char *reserved_field_names[] = {
>  #define PRINT_TYPE_FMT_NAME(type)	print_type_format_##type
>  
>  /* Printing  in basic type function template */
> -#define DEFINE_BASIC_PRINT_TYPE_FUNC(type, fmt, cast)			\
> +#define DEFINE_BASIC_PRINT_TYPE_FUNC(type, fmt)				\
>  static __kprobes int PRINT_TYPE_FUNC_NAME(type)(struct trace_seq *s,	\
>  						const char *name,	\
> -						void *data, void *ent)\
> +						void *data, void *ent)	\
>  {									\
> -	return trace_seq_printf(s, " %s=" fmt, name, (cast)*(type *)data);\
> +	return trace_seq_printf(s, " %s=" fmt, name, *(type *)data);	\
>  }									\
>  static const char PRINT_TYPE_FMT_NAME(type)[] = fmt;
>  
> -DEFINE_BASIC_PRINT_TYPE_FUNC(u8, "%x", unsigned int)
> -DEFINE_BASIC_PRINT_TYPE_FUNC(u16, "%x", unsigned int)
> -DEFINE_BASIC_PRINT_TYPE_FUNC(u32, "%lx", unsigned long)
> -DEFINE_BASIC_PRINT_TYPE_FUNC(u64, "%llx", unsigned long long)
> -DEFINE_BASIC_PRINT_TYPE_FUNC(s8, "%d", int)
> -DEFINE_BASIC_PRINT_TYPE_FUNC(s16, "%d", int)
> -DEFINE_BASIC_PRINT_TYPE_FUNC(s32, "%ld", long)
> -DEFINE_BASIC_PRINT_TYPE_FUNC(s64, "%lld", long long)
> +DEFINE_BASIC_PRINT_TYPE_FUNC(u8, "%x")
> +DEFINE_BASIC_PRINT_TYPE_FUNC(u16, "%x")
> +DEFINE_BASIC_PRINT_TYPE_FUNC(u32, "%x")
> +DEFINE_BASIC_PRINT_TYPE_FUNC(u64, "%Lx")
> +DEFINE_BASIC_PRINT_TYPE_FUNC(s8, "%d")
> +DEFINE_BASIC_PRINT_TYPE_FUNC(s16, "%d")
> +DEFINE_BASIC_PRINT_TYPE_FUNC(s32, "%d")
> +DEFINE_BASIC_PRINT_TYPE_FUNC(s64, "%Ld")
>  
>  static inline void *get_rloc_data(u32 *dl)
>  {
