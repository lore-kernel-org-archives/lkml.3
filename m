Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751684Ab3IFMiC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 08:38:02 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:44475 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334Ab3IFMiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 08:38:00 -0400
Message-ID: <5229CCA6.2060105@hitachi.com>
Date: Fri, 06 Sep 2013 21:37:58 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Tom Zanussi <tom.zanussi@linux.intel.com>, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v8 03/10] tracing: Add 'traceon' and 'traceoff' event
 trigger commands
References: <cover.1378176577.git.tom.zanussi@linux.intel.com> <33cc30439cc2c729abb1644c2696d54d03ac6548.1378176577.git.tom.zanussi@linux.intel.com> <20130905164621.40f92270@gandalf.local.home>
In-Reply-To: <20130905164621.40f92270@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/09/06 5:46), Steven Rostedt wrote:
> On Mon,  2 Sep 2013 22:52:19 -0500
> Tom Zanussi <tom.zanussi@linux.intel.com> wrote:
>>  extern void destroy_preds(struct ftrace_event_call *call);
>> diff --git a/kernel/trace/trace_events_trigger.c b/kernel/trace/trace_events_trigger.c
>> index 85319cf..5388d55 100644
>> --- a/kernel/trace/trace_events_trigger.c
>> +++ b/kernel/trace/trace_events_trigger.c
>> @@ -28,6 +28,13 @@
>>  static LIST_HEAD(trigger_commands);
>>  static DEFINE_MUTEX(trigger_cmd_mutex);
>>  
>> +static void
>> +trigger_data_free(struct event_trigger_data *data)
>> +{
>> +	synchronize_sched(); /* make sure current triggers exit before free */
> 
> Again, I think this can and should be synchronize_rcu().
> 

As in the previous patch, event triggers called under preempt disabled.

> +void event_triggers_call(struct ftrace_event_file *file)
> +{
> +	struct event_trigger_data *data;
> +
> +	if (list_empty(&file->triggers))
> +		return;
> +
> +	preempt_disable_notrace();
> +	list_for_each_entry_rcu(data, &file->triggers, list)
> +		data->ops->func(data);
> +	preempt_enable_notrace();
> +}

In this case, I think synchronize_sched() is correct. Of course,
we need to discuss why it needs to disable preempt here. :)

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


