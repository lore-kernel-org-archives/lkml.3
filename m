Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051Ab3GBBZJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 21:25:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15514 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755797Ab3GBBZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 21:25:07 -0400
X-Authority-Analysis: v=2.0 cv=Tr1kdUrh c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=P84HKLajjusA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=PCnuL9RVHEUA:10 a=1XWaLZrsAAAA:8 a=pGLkceISAAAA:8 a=eTuon03C81no0s9xlFsA:9 a=QEXdDO2ut3YA:10 a=UTB_XpHje0EA:10 a=MSl-tDqOz04A:10 a=_ycpXvkj5AM897QH:21 a=6qZAx9HtIDj8rpxW:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1372728304.22688.32.camel@gandalf.local.home>
Subject: Re: [PATCH 3/3] tracing: Protect ftrace_trace_arrays list in
 trace_events.c
From: Steven Rostedt <rostedt@goodmis.org>
To: Alexander Z Lam <azl@google.com>
Cc: linux-kernel@vger.kernel.org, David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Alexander Z Lam <lambchop468@gmail.com>
Date: Mon, 01 Jul 2013 21:25:04 -0400
In-Reply-To: <1372717885-4543-3-git-send-email-azl@google.com>
References: <1372717885-4543-1-git-send-email-azl@google.com>
	 <1372717885-4543-3-git-send-email-azl@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-01 at 15:31 -0700, Alexander Z Lam wrote:
> There are multiple places where the ftrace_trace_arrays list is accessed in
> trace_events.c without the trace_types_lock held.

Hmm, doesn't compile. Not a complete patch? trace_types_lock is local to
trace.c, and needs to be in trace.h and non static.

-- Steve

> 
> Cc: David Sharp <dhsharp@google.com>
> Cc: Alexander Z Lam <lambchop468@gmail.com>
> Signed-off-by: Alexander Z Lam <azl@google.com>
> ---
>  kernel/trace/trace_events.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index 6db3290..26351cc 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -1586,6 +1586,7 @@ static void __add_event_to_tracers(struct ftrace_event_call *call,
>  int trace_add_event_call(struct ftrace_event_call *call)
>  {
>  	int ret;
> +	mutex_lock(&trace_types_lock);
>  	mutex_lock(&event_mutex);
>  
>  	ret = __register_event(call, NULL);
> @@ -1593,11 +1594,13 @@ int trace_add_event_call(struct ftrace_event_call *call)
>  		__add_event_to_tracers(call, NULL);
>  
>  	mutex_unlock(&event_mutex);
> +	mutex_unlock(&trace_types_lock);
>  	return ret;
>  }
>  
>  /*
> - * Must be called under locking both of event_mutex and trace_event_sem.
> + * Must be called under locking of trace_types_lock, event_mutex and
> + * trace_event_sem.
>   */
>  static void __trace_remove_event_call(struct ftrace_event_call *call)
>  {
> @@ -1609,11 +1612,13 @@ static void __trace_remove_event_call(struct ftrace_event_call *call)
>  /* Remove an event_call */
>  void trace_remove_event_call(struct ftrace_event_call *call)
>  {
> +	mutex_lock(&trace_types_lock);
>  	mutex_lock(&event_mutex);
>  	down_write(&trace_event_sem);
>  	__trace_remove_event_call(call);
>  	up_write(&trace_event_sem);
>  	mutex_unlock(&event_mutex);
> +	mutex_unlock(&trace_types_lock);
>  }
>  
>  #define for_each_event(event, start, end)			\
> @@ -1757,6 +1762,7 @@ static int trace_module_notify(struct notifier_block *self,
>  {
>  	struct module *mod = data;
>  
> +	mutex_lock(&trace_types_lock);
>  	mutex_lock(&event_mutex);
>  	switch (val) {
>  	case MODULE_STATE_COMING:
> @@ -1767,6 +1773,7 @@ static int trace_module_notify(struct notifier_block *self,
>  		break;
>  	}
>  	mutex_unlock(&event_mutex);
> +	mutex_unlock(&trace_types_lock);
>  
>  	return 0;
>  }


