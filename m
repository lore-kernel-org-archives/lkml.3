Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927Ab3EIObs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 10:31:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11972 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222Ab3EIObr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 10:31:47 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=OF0BmyLs-1YA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=Kfn0_i_Y4z8A:10 a=3nbZYyFuAAAA:8 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=QyXUC8HyAAAA:8 a=0P8YjRj644Lh5uG7nk8A:9 a=QEXdDO2ut3YA:10 a=EvKJbDF4Ut8A:10 a=jeBq3FmKZ4MA:10 a=MSl-tDqOz04A:10 a=jEp0ucaQiEUA:10 a=dGJ0OcVc7YAA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1368109905.7373.99.camel@gandalf.local.home>
Subject: Re: [PATCH 01/11] [BUGFIX] tracing: Return 0 if event_enable_func
 succeeded
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com, Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Tom Zanussi <tom.zanussi@intel.com>
Date: Thu, 09 May 2013 10:31:45 -0400
In-Reply-To: <20130509054413.30398.55650.stgit@mhiramat-M0-7522>
References: <20130509054405.30398.73831.stgit@mhiramat-M0-7522>
	 <20130509054413.30398.55650.stgit@mhiramat-M0-7522>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-05-09 at 14:44 +0900, Masami Hiramatsu wrote:
> Return 0 instead of the number of activated ftrace if
> event_enable_func succeeded and return an error code if failed,
> beacuse 0 is success code at caller (ftrace_regex_write).
> 
> Without this fix, writing enable_event trigger on set_ftrace_filter
> always doesn't work, since event_enable_func returns 1 to
> ftrace_regex_write, it consumes 1 byte and pass input string
> without the first character again. This makes event_enable_func
> fail and disables event entry.
> 
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Tom Zanussi <tom.zanussi@intel.com>
> ---
>  kernel/trace/trace_events.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index 53582e9..44ac836 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -2061,8 +2061,11 @@ event_enable_func(struct ftrace_hash *hash,
>  	if (ret < 0)
>  		goto out_put;
>  	ret = register_ftrace_function_probe(glob, ops, data);
> -	if (!ret)
> +	if (!ret) {
> +		ret = -ENOENT;
>  		goto out_disable;
> +	} else
> +		ret = 0;

I think you meant:

	if (ret < 0)
		goto out_disable;
	ret = 0;

Otherwise, I don't see how you fixed anything, as you still return error
if ret is something other than zero.

Or am I missing something?

-- Steve

>   out:
>  	mutex_unlock(&event_mutex);
>  	return ret;


