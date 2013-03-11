Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853Ab3CKOIS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 10:08:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10140 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033Ab3CKOIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 10:08:16 -0400
X-Authority-Analysis: v=2.0 cv=UN5f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=wKN_jQIjfZgA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=x1EhfJ_RtQAA:10 a=i0EeH86SAAAA:8 a=2Tsw5TUgiclBmYE8OqsA:9 a=PUjeQqilurYA:10 a=hPjdaMEvmhQA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1363010894.12608.5.camel@gandalf.local.home>
Subject: Re: [PATCH 06/13] tracing: remove dump_ran check in __ftrace_dump
From: Steven Rostedt <rostedt@goodmis.org>
To: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Date: Mon, 11 Mar 2013 10:08:14 -0400
In-Reply-To: <513D8433.8000806@huawei.com>
References: <513D8433.8000806@huawei.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-03-11 at 15:13 +0800, zhangwei(Jovi) wrote:
> It's reasonable to call __ftrace_dump function not only once,
> so remove the dump_ran variable checking.

This needs a little more work. On an oops, I only want it dumped once,
because a crash can cause another crash while its dumping, and without
that check in will corrupt the buffer.

Now, we have things like ctrl^z that also does a dump where we don't
want to disable it. Cleaning this up has been on my todo list for a
while. I may go ahead and clean that up myself.

-- Steve

> 
> Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
> ---
>  kernel/trace/trace.c |    6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 090eddb..4cec7b8 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -5106,17 +5106,12 @@ __ftrace_dump(bool disable_tracing, enum ftrace_dump_mode oops_dump_mode)
>  	/* use static because iter can be a bit big for the stack */
>  	static struct trace_iterator iter;
>  	unsigned int old_userobj;
> -	static int dump_ran;
>  	unsigned long flags;
>  	int cnt = 0, cpu;
> 
>  	/* only one dump */
>  	local_irq_save(flags);
>  	arch_spin_lock(&ftrace_dump_lock);
> -	if (dump_ran)
> -		goto out;
> -
> -	dump_ran = 1;
> 
>  	tracing_off();
> 
> @@ -5206,7 +5201,6 @@ __ftrace_dump(bool disable_tracing, enum ftrace_dump_mode oops_dump_mode)
>  		tracing_on();
>  	}
> 
> - out:
>  	arch_spin_unlock(&ftrace_dump_lock);
>  	local_irq_restore(flags);
>  }


