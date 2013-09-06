Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168Ab3IFMml (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 08:42:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15302 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540Ab3IFMmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 08:42:39 -0400
X-Authority-Analysis: v=2.0 cv=ddwCLAre c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=ZFx7X6yEILAA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=pL6CU3c6K6sA:10 a=3nbZYyFuAAAA:8 a=QyXUC8HyAAAA:8 a=VFR2DjBfAJN64wr-zNwA:9 a=CjuIK1q_8ugA:10 a=EvKJbDF4Ut8A:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Fri, 6 Sep 2013 08:42:38 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Tom Zanussi <tom.zanussi@linux.intel.com>, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v8 03/10] tracing: Add 'traceon' and 'traceoff' event
 trigger commands
Message-ID: <20130906084238.5fc10b72@gandalf.local.home>
In-Reply-To: <5229CCA6.2060105@hitachi.com>
References: <cover.1378176577.git.tom.zanussi@linux.intel.com>
	<33cc30439cc2c729abb1644c2696d54d03ac6548.1378176577.git.tom.zanussi@linux.intel.com>
	<20130905164621.40f92270@gandalf.local.home>
	<5229CCA6.2060105@hitachi.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Sep 2013 21:37:58 +0900
Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> (2013/09/06 5:46), Steven Rostedt wrote:
> > On Mon,  2 Sep 2013 22:52:19 -0500
> > Tom Zanussi <tom.zanussi@linux.intel.com> wrote:
> >>  extern void destroy_preds(struct ftrace_event_call *call);
> >> diff --git a/kernel/trace/trace_events_trigger.c b/kernel/trace/trace_events_trigger.c
> >> index 85319cf..5388d55 100644
> >> --- a/kernel/trace/trace_events_trigger.c
> >> +++ b/kernel/trace/trace_events_trigger.c
> >> @@ -28,6 +28,13 @@
> >>  static LIST_HEAD(trigger_commands);
> >>  static DEFINE_MUTEX(trigger_cmd_mutex);
> >>  
> >> +static void
> >> +trigger_data_free(struct event_trigger_data *data)
> >> +{
> >> +	synchronize_sched(); /* make sure current triggers exit before free */
> > 
> > Again, I think this can and should be synchronize_rcu().
> > 
> 
> As in the previous patch, event triggers called under preempt disabled.

Yeah, my fault. I was thinking tracepoints used rcu_read_lock(). This
is fine.

> 
> > +void event_triggers_call(struct ftrace_event_file *file)
> > +{
> > +	struct event_trigger_data *data;
> > +
> > +	if (list_empty(&file->triggers))
> > +		return;
> > +
> > +	preempt_disable_notrace();
> > +	list_for_each_entry_rcu(data, &file->triggers, list)
> > +		data->ops->func(data);
> > +	preempt_enable_notrace();
> > +}
> 
> In this case, I think synchronize_sched() is correct. Of course,
> we need to discuss why it needs to disable preempt here. :)
> 

Yeah, that is confusing.

-- Steve

