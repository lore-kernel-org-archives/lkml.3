Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063Ab3EPO6G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 10:58:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:12790 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767Ab3EPO6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 10:58:03 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=qovGGtoVS-MA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=kFn1qA8OeE4A:10 a=3nbZYyFuAAAA:8 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=MEJV5nf_ePttVjV8-1oA:9 a=QEXdDO2ut3YA:10 a=EvKJbDF4Ut8A:10 a=jeBq3FmKZ4MA:10 a=MSl-tDqOz04A:10 a=jEp0ucaQiEUA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1368716282.6828.100.camel@gandalf.local.home>
Subject: Re: [PATCH 1/5] [BUGFIX] tracing: Returns -EBUSY when
 event_enable_func fails to get module
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com, Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Tom Zanussi <tom.zanussi@intel.com>
Date: Thu, 16 May 2013 10:58:02 -0400
In-Reply-To: <20130516114848.13508.97899.stgit@mhiramat-M0-7522>
References: <20130516114839.13508.92844.stgit@mhiramat-M0-7522>
	 <20130516114848.13508.97899.stgit@mhiramat-M0-7522>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-05-16 at 20:48 +0900, Masami Hiramatsu wrote:
> Since try_module_get returns false( = 0) when it fails to
> pindown a module, event_enable_func() returns 0 which means
> "succeed". This can cause a kernel panic when the entry
> is removed, because the event is already released.
> 
> This fixes the bug by returning -EBUSY, because the reason
> why it fails is under removing module at that time.
> 

Thanks, this looks to be something that needs to go in right away.

-- Steve

> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> ---
>  kernel/trace/trace_events.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index 7a0cf68..27963e2 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -2072,8 +2072,10 @@ event_enable_func(struct ftrace_hash *hash,
>   out_reg:
>  	/* Don't let event modules unload while probe registered */
>  	ret = try_module_get(file->event_call->mod);
> -	if (!ret)
> +	if (!ret) {
> +		ret = -EBUSY;
>  		goto out_free;
> +	}
>  
>  	ret = __ftrace_event_enable_disable(file, 1, 1);
>  	if (ret < 0)


