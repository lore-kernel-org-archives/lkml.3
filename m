Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357Ab3IMVKW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 17:10:22 -0400
Received: from mga02.intel.com ([134.134.136.20]:40741 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753354Ab3IMVKV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 17:10:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,900,1371106800"; 
   d="scan'208";a="377927588"
Message-ID: <1379106619.1558.45.camel@empanada>
Subject: Re: [PATCH v9 04/10] tracing: Add 'snapshot' event trigger command
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: masami.hiramatsu.pt@hitachi.com, linux-kernel@vger.kernel.org
Date: Fri, 13 Sep 2013 16:10:19 -0500
In-Reply-To: <20130913160100.30686d60@gandalf.local.home>
References: <cover.1378565610.git.tom.zanussi@linux.intel.com>
	 <c1245b886d62b5154f20480c63d41a368af7cffa.1378565610.git.tom.zanussi@linux.intel.com>
	 <20130913160100.30686d60@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.1 (3.4.1-2.fc17) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-09-13 at 16:01 -0400, Steven Rostedt wrote:
> On Sat,  7 Sep 2013 10:29:00 -0500
> Tom Zanussi <tom.zanussi@linux.intel.com> wrote:
> 
> 
> > --- a/kernel/trace/trace_events_trigger.c
> > +++ b/kernel/trace/trace_events_trigger.c
> > @@ -696,6 +696,74 @@ static struct event_command trigger_traceoff_cmd = {
> >  	.get_trigger_ops	= onoff_get_trigger_ops,
> >  };
> >  
> > +static void
> > +snapshot_trigger(struct event_trigger_data *data)
> > +{
> > +	tracing_snapshot();
> > +}
> 
> If CONFIG_TRACER_SNAPSHOT is not defined, then we should not bother
> implementing the snapshot trigger. This should be encapsulated around
> ifdefs.

OK, I guess I was just trying to avoid the ifdef since
tracing_snapshot() is already ifdef'ed out (but with a WARN_ONCE()) if
CONFIG_TRACER_SNAPSHOT isn't defined.

I agree though, it would be better to just ignore all the snapshot
trigger code if that's the case.  Same for the stacktrace trigger,
though as much as I hate to put big ifdefs in the main code...

> 
> > +
> > +static void
> > +snapshot_count_trigger(struct event_trigger_data *data)
> > +{
> > +	if (!data->count)
> > +		return;
> > +
> > +	if (data->count != -1)
> > +		(data->count)--;
> > +
> > +	snapshot_trigger(data);
> > +}
> > +
> > +static int
> > +register_snapshot_trigger(char *glob, struct event_trigger_ops *ops,
> > +			  struct event_trigger_data *data,
> > +			  struct ftrace_event_file *file)
> > +{
> > +	int ret = register_trigger(glob, ops, data, file);
> > +
> > +	if (ret > 0)
> > +		ftrace_alloc_snapshot();
> > +
> > +	return ret;
> > +}
> > +
> > +static int
> > +snapshot_trigger_print(struct seq_file *m, struct event_trigger_ops *ops,
> > +		       struct event_trigger_data *data)
> > +{
> > +	return event_trigger_print("snapshot", m, (void *)data->count,
> > +				   data->filter_str);
> > +}
> > +
> > +static struct event_trigger_ops snapshot_trigger_ops = {
> > +	.func			= snapshot_trigger,
> > +	.print			= snapshot_trigger_print,
> > +	.init			= event_trigger_init,
> > +	.free			= event_trigger_free,
> > +};
> > +
> > +static struct event_trigger_ops snapshot_count_trigger_ops = {
> > +	.func			= snapshot_count_trigger,
> > +	.print			= snapshot_trigger_print,
> > +	.init			= event_trigger_init,
> > +	.free			= event_trigger_free,
> > +};
> > +
> > +static struct event_trigger_ops *
> > +snapshot_get_trigger_ops(char *cmd, char *param)
> > +{
> > +	return param ? &snapshot_count_trigger_ops : &snapshot_trigger_ops;
> > +}
> > +
> > +static struct event_command trigger_snapshot_cmd = {
> > +	.name			= "snapshot",
> > +	.trigger_type		= ETT_SNAPSHOT,
> > +	.func			= event_trigger_callback,
> > +	.reg			= register_snapshot_trigger,
> > +	.unreg			= unregister_trigger,
> > +	.get_trigger_ops	= snapshot_get_trigger_ops,
> > +};
> > +
> >  static __init void unregister_trigger_traceon_traceoff_cmds(void)
> >  {
> >  	unregister_event_command(&trigger_traceon_cmd);
> > @@ -726,5 +794,11 @@ __init int register_trigger_cmds(void)
> >  		return ret;
> >  	}
> >  
> > +	ret = register_event_command(&trigger_snapshot_cmd);
> > +	if (WARN_ON(ret < 0)) {
> > +		unregister_trigger_traceon_traceoff_cmds();
> 
> If the snapshot trigger fails, why remove the traceon_traceoff trigger
> if it succeeded? Is there some dependency that we should be worried
> about?
> 
> Or is this just saying "if once trigger fails, they all fail!"?
> 

Right, that's all its saying, there's no dependency.  I guess it would
be fine to just continue with whatever triggers did/will register
successfully - the WARN_ON() will show the failure for a given trigger,
no need to disable everything.

Tom

> -- Steve
> 
> > +		return ret;
> > +	}
> > +
> >  	return 0;
> >  }
> 


