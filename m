Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966028Ab3HIJnF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 05:43:05 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:51005 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965376Ab3HIJnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 05:43:03 -0400
Message-ID: <5204B9A0.4090905@hitachi.com>
Date: Fri, 09 Aug 2013 18:42:56 +0900
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
Subject: Re: [PATCH 08/13] tracing/kprobes: Move common functions to trace_probe.h
References: <1376037909-17797-1-git-send-email-namhyung@kernel.org> <1376037909-17797-9-git-send-email-namhyung@kernel.org>
In-Reply-To: <1376037909-17797-9-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/08/09 17:45), Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> The __get_data_size() and store_trace_args() will be used by uprobes
> too.  Move them to a common location.
> 

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thanks!

> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  kernel/trace/trace_kprobe.c | 48 ---------------------------------------------
>  kernel/trace/trace_probe.h  | 48 +++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 48 insertions(+), 48 deletions(-)
> 
> diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
> index d3f60d29c765..ede99332b255 100644
> --- a/kernel/trace/trace_kprobe.c
> +++ b/kernel/trace/trace_kprobe.c
> @@ -904,54 +904,6 @@ const struct fetch_type kprobes_fetch_type_table[] = {
>  	ASSIGN_FETCH_TYPE(s64, u64, 1),
>  };
>  
> -/* Sum up total data length for dynamic arraies (strings) */
> -static __kprobes int __get_data_size(struct trace_probe *tp,
> -				     struct pt_regs *regs)
> -{
> -	int i, ret = 0;
> -	u32 len;
> -
> -	for (i = 0; i < tp->nr_args; i++)
> -		if (unlikely(tp->args[i].fetch_size.fn)) {
> -			call_fetch(&tp->args[i].fetch_size, regs, &len);
> -			ret += len;
> -		}
> -
> -	return ret;
> -}
> -
> -/* Store the value of each argument */
> -static __kprobes void store_trace_args(int ent_size, struct trace_probe *tp,
> -				       struct pt_regs *regs,
> -				       u8 *data, int maxlen)
> -{
> -	int i;
> -	u32 end = tp->size;
> -	u32 *dl;	/* Data (relative) location */
> -
> -	for (i = 0; i < tp->nr_args; i++) {
> -		if (unlikely(tp->args[i].fetch_size.fn)) {
> -			/*
> -			 * First, we set the relative location and
> -			 * maximum data length to *dl
> -			 */
> -			dl = (u32 *)(data + tp->args[i].offset);
> -			*dl = make_data_rloc(maxlen, end - tp->args[i].offset);
> -			/* Then try to fetch string or dynamic array data */
> -			call_fetch(&tp->args[i].fetch, regs, dl);
> -			/* Reduce maximum length */
> -			end += get_rloc_len(*dl);
> -			maxlen -= get_rloc_len(*dl);
> -			/* Trick here, convert data_rloc to data_loc */
> -			*dl = convert_rloc_to_loc(*dl,
> -				 ent_size + tp->args[i].offset);
> -		} else
> -			/* Just fetching data normally */
> -			call_fetch(&tp->args[i].fetch, regs,
> -				   data + tp->args[i].offset);
> -	}
> -}
> -
>  /* Kprobe handler */
>  static __kprobes void
>  __kprobe_trace_func(struct trace_kprobe *tp, struct pt_regs *regs,
> diff --git a/kernel/trace/trace_probe.h b/kernel/trace/trace_probe.h
> index 63e5da4e3073..189a40baea98 100644
> --- a/kernel/trace/trace_probe.h
> +++ b/kernel/trace/trace_probe.h
> @@ -302,3 +302,51 @@ extern ssize_t traceprobe_probes_write(struct file *file,
>  		int (*createfn)(int, char**));
>  
>  extern int traceprobe_command(const char *buf, int (*createfn)(int, char**));
> +
> +/* Sum up total data length for dynamic arraies (strings) */
> +static inline __kprobes int
> +__get_data_size(struct trace_probe *tp, struct pt_regs *regs)
> +{
> +	int i, ret = 0;
> +	u32 len;
> +
> +	for (i = 0; i < tp->nr_args; i++)
> +		if (unlikely(tp->args[i].fetch_size.fn)) {
> +			call_fetch(&tp->args[i].fetch_size, regs, &len);
> +			ret += len;
> +		}
> +
> +	return ret;
> +}
> +
> +/* Store the value of each argument */
> +static inline __kprobes void
> +store_trace_args(int ent_size, struct trace_probe *tp, struct pt_regs *regs,
> +		 u8 *data, int maxlen)
> +{
> +	int i;
> +	u32 end = tp->size;
> +	u32 *dl;	/* Data (relative) location */
> +
> +	for (i = 0; i < tp->nr_args; i++) {
> +		if (unlikely(tp->args[i].fetch_size.fn)) {
> +			/*
> +			 * First, we set the relative location and
> +			 * maximum data length to *dl
> +			 */
> +			dl = (u32 *)(data + tp->args[i].offset);
> +			*dl = make_data_rloc(maxlen, end - tp->args[i].offset);
> +			/* Then try to fetch string or dynamic array data */
> +			call_fetch(&tp->args[i].fetch, regs, dl);
> +			/* Reduce maximum length */
> +			end += get_rloc_len(*dl);
> +			maxlen -= get_rloc_len(*dl);
> +			/* Trick here, convert data_rloc to data_loc */
> +			*dl = convert_rloc_to_loc(*dl,
> +				 ent_size + tp->args[i].offset);
> +		} else
> +			/* Just fetching data normally */
> +			call_fetch(&tp->args[i].fetch, regs,
> +				   data + tp->args[i].offset);
> +	}
> +}
> 


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


