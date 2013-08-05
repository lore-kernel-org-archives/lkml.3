Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675Ab3HEGDx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 02:03:53 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:35235 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817Ab3HEGDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 02:03:52 -0400
Message-ID: <51FF4044.4080703@hitachi.com>
Date: Mon, 05 Aug 2013 15:03:48 +0900
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
Subject: Re: [PATCH 06/13] tracing/kprobes: Move common functions to trace_probe.c
References: <1375261410-11219-1-git-send-email-namhyung@kernel.org> <1375261410-11219-7-git-send-email-namhyung@kernel.org>
In-Reply-To: <1375261410-11219-7-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/07/31 18:03), Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> The __get_data_size() and store_trace_args() will be used by uprobes
> too.  Move them to a common location.

Hmm, could you move this into trace_probe.h? Since this will
be used in fast path, I'd like to keep it as inlined.

> 
> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  kernel/trace/trace_kprobe.c | 48 ---------------------------------------------
>  kernel/trace/trace_probe.c  | 46 +++++++++++++++++++++++++++++++++++++++++++
>  kernel/trace/trace_probe.h  |  4 ++++
>  3 files changed, 50 insertions(+), 48 deletions(-)
> 
> diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
> index 21d85a40740c..d4c10fb8b8f8 100644
> --- a/kernel/trace/trace_kprobe.c
> +++ b/kernel/trace/trace_kprobe.c
> @@ -845,54 +845,6 @@ const struct fetch_type kprobes_fetch_type_table[] = {
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
> diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
> index c123a890c5b1..5e491d82b6ad 100644
> --- a/kernel/trace/trace_probe.c
> +++ b/kernel/trace/trace_probe.c
> @@ -701,3 +701,49 @@ out:
>  
>  	return ret;
>  }
> +
> +/* Sum up total data length for dynamic arraies (strings) */
> +__kprobes int __get_data_size(struct trace_probe *tp, struct pt_regs *regs)
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
> +__kprobes void store_trace_args(int ent_size, struct trace_probe *tp,
> +				struct pt_regs *regs, u8 *data, int maxlen)
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
> diff --git a/kernel/trace/trace_probe.h b/kernel/trace/trace_probe.h
> index a939b7114e78..888cd7d4cd3c 100644
> --- a/kernel/trace/trace_probe.h
> +++ b/kernel/trace/trace_probe.h
> @@ -297,3 +297,7 @@ extern ssize_t traceprobe_probes_write(struct file *file,
>  		int (*createfn)(int, char**));
>  
>  extern int traceprobe_command(const char *buf, int (*createfn)(int, char**));
> +
> +extern int __get_data_size(struct trace_probe *tp, struct pt_regs *regs);
> +extern void store_trace_args(int ent_size, struct trace_probe *tp,
> +			     struct pt_regs *regs, u8 *data, int maxlen);
> 


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


