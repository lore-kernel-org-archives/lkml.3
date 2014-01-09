Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523AbaAIWpn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 17:45:43 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:41315 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736AbaAIWpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 17:45:35 -0500
Date: Wed, 8 Jan 2014 17:30:14 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Tom Zanussi <tom.zanussi@linux.intel.com>,
        kbuild test robot <fengguang.wu@intel.com>
Subject: Re: [PATCH 2/2] tracing: Fix rcu handling of event_trigger_data
 filter field
Message-ID: <20140109013014.GL10038@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131222030759.339128630@goodmis.org>
 <20131222031147.984230034@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131222031147.984230034@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14010922-0928-0000-0000-0000053E98F2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 21, 2013 at 10:08:01PM -0500, Steven Rostedt wrote:
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> The filter field of the event_trigger_data structure is protected under
> RCU sched locks. It was not annotated as such, and after doing so,
> sparse pointed out several locations that required fix ups.
> 
> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Looks good to me!

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> ---
>  kernel/trace/trace.h                | 2 +-
>  kernel/trace/trace_events_trigger.c | 8 +++++---
>  2 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index 0380cab..02b592f 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -1057,7 +1057,7 @@ struct event_trigger_data {
>  	int				ref;
>  	struct event_trigger_ops	*ops;
>  	struct event_command		*cmd_ops;
> -	struct event_filter		*filter;
> +	struct event_filter __rcu	*filter;
>  	char				*filter_str;
>  	void				*private_data;
>  	struct list_head		list;
> diff --git a/kernel/trace/trace_events_trigger.c b/kernel/trace/trace_events_trigger.c
> index 12ac8a5..f6dd115 100644
> --- a/kernel/trace/trace_events_trigger.c
> +++ b/kernel/trace/trace_events_trigger.c
> @@ -67,6 +67,7 @@ event_triggers_call(struct ftrace_event_file *file, void *rec)
>  {
>  	struct event_trigger_data *data;
>  	enum event_trigger_type tt = ETT_NONE;
> +	struct event_filter *filter;
> 
>  	if (list_empty(&file->triggers))
>  		return tt;
> @@ -76,7 +77,8 @@ event_triggers_call(struct ftrace_event_file *file, void *rec)
>  			data->ops->func(data);
>  			continue;
>  		}
> -		if (data->filter && !filter_match_preds(data->filter, rec))
> +		filter = rcu_dereference(data->filter);
> +		if (filter && !filter_match_preds(filter, rec))
>  			continue;
>  		if (data->cmd_ops->post_trigger) {
>  			tt |= data->cmd_ops->trigger_type;
> @@ -703,7 +705,7 @@ static int set_trigger_filter(char *filter_str,
>  	if (ret)
>  		goto out;
>   assign:
> -	tmp = data->filter;
> +	tmp = rcu_access_pointer(data->filter);
> 
>  	rcu_assign_pointer(data->filter, filter);
> 
> @@ -719,7 +721,7 @@ static int set_trigger_filter(char *filter_str,
>  	if (filter_str) {
>  		data->filter_str = kstrdup(filter_str, GFP_KERNEL);
>  		if (!data->filter_str) {
> -			free_event_filter(data->filter);
> +			free_event_filter(rcu_access_pointer(data->filter));
>  			data->filter = NULL;
>  			ret = -ENOMEM;
>  		}
> -- 
> 1.8.4.3
> 
> 

