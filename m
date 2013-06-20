Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935716Ab3FTDzK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 23:55:10 -0400
Received: from [133.145.228.5] ([133.145.228.5]:37623 "EHLO
	mail4.hitachi.co.jp" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S935546Ab3FTDzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 23:55:09 -0400
Message-ID: <51C27D05.3070301@hitachi.com>
Date: Thu, 20 Jun 2013 12:54:45 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: [PATCH] tracing/kprobes: Don't pass addr=ip to perf_trace_buf_submit()
References: <20130616172149.GA8540@redhat.com> <51BE97C0.1070203@hitachi.com> <20130617151841.GA32267@redhat.com> <51BFD6EF.1060805@hitachi.com> <20130618192414.GA19488@redhat.com> <20130619203005.GA19750@redhat.com> <20130619203433.GB19750@redhat.com>
In-Reply-To: <20130619203433.GB19750@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/06/20 5:34), Oleg Nesterov wrote:
> On 06/19, Oleg Nesterov wrote:
>>
>> So. I'll resend this series, will you ack the v2 below?
> 
> Also. Could you please review the new patch I am going to include
> into this series?

It looks OK for me. BTW, IIRC, I had reviewed same one previously...

> 
> This is copy-and-paste of 32520b2c6 which you reviewed and acked.
> 
> And please note that kprobes is the last user of
> perf_trace_buf_submit(addr != 0), we can make some cleanups on top.

Agreed,

> 
> -------------------------------------------------------------------------------
> Subject: [PATCH] tracing/kprobes: Don't pass addr=ip to perf_trace_buf_submit()
> 
> kprobe_perf_func() and kretprobe_perf_func() pass addr=ip to
> perf_trace_buf_submit() for no reason.
> 
> This sets perf_sample_data->addr for PERF_SAMPLE_ADDR, we already
> have perf_sample_data->ip initialized if PERF_SAMPLE_IP.
> 

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thank you!

> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  kernel/trace/trace_kprobe.c |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
> index 3432652..141c682 100644
> --- a/kernel/trace/trace_kprobe.c
> +++ b/kernel/trace/trace_kprobe.c
> @@ -1163,8 +1163,7 @@ kprobe_perf_func(struct trace_probe *tp, struct pt_regs *regs)
>  	entry->ip = (unsigned long)tp->rp.kp.addr;
>  	memset(&entry[1], 0, dsize);
>  	store_trace_args(sizeof(*entry), tp, regs, (u8 *)&entry[1], dsize);
> -	perf_trace_buf_submit(entry, size, rctx,
> -					entry->ip, 1, regs, head, NULL);
> +	perf_trace_buf_submit(entry, size, rctx, 0, 1, regs, head, NULL);
>  }
>  
>  /* Kretprobe profile handler */
> @@ -1197,8 +1196,7 @@ kretprobe_perf_func(struct trace_probe *tp, struct kretprobe_instance *ri,
>  	entry->func = (unsigned long)tp->rp.kp.addr;
>  	entry->ret_ip = (unsigned long)ri->ret_addr;
>  	store_trace_args(sizeof(*entry), tp, regs, (u8 *)&entry[1], dsize);
> -	perf_trace_buf_submit(entry, size, rctx,
> -					entry->ret_ip, 1, regs, head, NULL);
> +	perf_trace_buf_submit(entry, size, rctx, 0, 1, regs, head, NULL);
>  }
>  #endif	/* CONFIG_PERF_EVENTS */
>  
> 


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


