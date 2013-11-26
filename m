Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751770Ab3KZCVi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 21:21:38 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:35468 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709Ab3KZCVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 21:21:37 -0500
Message-ID: <529405AC.6090401@hitachi.com>
Date: Tue, 26 Nov 2013 11:21:32 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] tracing: Add $cpu and $current probe-vars
References: <20131123201543.GA22148@redhat.com> <20131125192926.GA9737@redhat.com> <20131125192952.GB9737@redhat.com>
In-Reply-To: <20131125192952.GB9737@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/11/26 4:29), Oleg Nesterov wrote:
> The probe can dump the registers or memory, but it is not possible
> to dump, say, current->pid. This patch adds the pseudo regs table,
> currently it has only two methods to get current/smp_processor_id
> but it can be trivially extended.
> 
> The syntax is '$cpu' and '$current', we overload FETCH_MTD_reg just
> to avoid the new fetch method(s).
> 
> Test-case: 452 == offsetof(task_struct, pid), 39 == __NR_getpid,
> 
>   # perf probe 'sys_getpid%return ret=$retval:s32 pid=+452($current):s32'
>   # perf record -e probe:sys_getpid perl -e 'syscall 39'
>   # perf --no-pager script | tail -1
> 	perl   586 [001]   753.102549: probe:sys_getpid: \
> 	(ffffffff81052c00 <- ffffffff8134d012) ret=586 pid=586
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  kernel/trace/trace_probe.c |   61 +++++++++++++++++++++++++++++++++++++++++---
>  1 files changed, 57 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
> index 412e959..b066e9d 100644
> --- a/kernel/trace/trace_probe.c
> +++ b/kernel/trace/trace_probe.c
> @@ -109,13 +109,14 @@ DEFINE_FETCH_##method(u64)
>  	  (FETCH_FUNC_NAME(method, string_size) == fn)) \
>  	 && (fn != NULL))
>  
> +static unsigned long probe_get_register(struct pt_regs *, unsigned long);
> +
>  /* Data fetch function templates */
>  #define DEFINE_FETCH_reg(type)						\
>  static __kprobes void FETCH_FUNC_NAME(reg, type)(struct pt_regs *regs,	\
>  					void *offset, void *dest)	\
>  {									\
> -	*(type *)dest = (type)regs_get_register(regs,			\
> -				(unsigned int)((unsigned long)offset));	\
> +	*(type *)dest = (type)probe_get_register(regs, (long)offset);	\
>  }
>  DEFINE_BASIC_FETCH_FUNCS(reg)
>  /* No string on the register */
> @@ -513,6 +514,52 @@ int traceprobe_split_symbol_offset(char *symbol, unsigned long *offset)
>  	return 0;
>  }
>  
> +static unsigned long pseudo_reg_cpu(void)
> +{
> +	return (unsigned long)raw_smp_processor_id();
> +}
> +
> +static unsigned long pseudo_reg_current(void)
> +{
> +	return (unsigned long)current;
> +}
> +
> +static struct {
> +	const char *name;
> +	unsigned long (*fetch)(void);
> +}
> +const pseudo_reg_table[] = {
> +	{
> +		.name	= "cpu",
> +		.fetch	= pseudo_reg_cpu,
> +	},
> +	{
> +		.name	= "current",
> +		.fetch	= pseudo_reg_current,
> +	},
> +};
> +
> +#define PSEUDO_REG_OFFSET	4096	/* arbitrary value > MAX_REG_OFFSET */
> +
> +static unsigned long probe_get_register(struct pt_regs *regs, unsigned long offset)
> +{
> +	if (offset < PSEUDO_REG_OFFSET)
> +		return regs_get_register(regs, offset);
> +
> +	return pseudo_reg_table[offset - PSEUDO_REG_OFFSET].fetch();
> +}


Hmm, I don't like this, since fetch_reg is the most frequently
used fetch method, and it actually uses the offset in different
way.

Why don't you make another fetch function for vars?
Perhaps, you can make fetch_retval more generic.

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


