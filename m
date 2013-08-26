Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992Ab3HZGeO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 02:34:14 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:52996 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755800Ab3HZGeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 02:34:13 -0400
Message-ID: <521AF6DF.7010609@hitachi.com>
Date: Mon, 26 Aug 2013 15:34:07 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Tom Zanussi <tom.zanussi@linux.intel.com>
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 02/10] tracing: add basic event trigger framework
References: <cover.1377213245.git.tom.zanussi@linux.intel.com> <923484a1826a9c5b872450dc60fe41a6815a1709.1377213245.git.tom.zanussi@linux.intel.com>
In-Reply-To: <923484a1826a9c5b872450dc60fe41a6815a1709.1377213245.git.tom.zanussi@linux.intel.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tom,

This patch basically good for me.

Unfortunately, I've found a small build issue on this patch.

  CC      kernel/trace/trace_events_filter.o
/home/mhiramat/ksrc/linux-3/kernel/trace/trace_events.c:1864:1: error: static declaration of 'find_event_file' follows non-static declaration
/home/mhiramat/ksrc/linux-3/kernel/trace/trace.h:1019:34: note: previous declaration of 'find_event_file' was here
make[3]: *** [kernel/trace/trace_events.o] Error 1


> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index b1227b9..1733ac9 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -1016,9 +1016,184 @@ extern void trace_event_enable_cmd_record(bool enable);
>  extern int event_trace_add_tracer(struct dentry *parent, struct trace_array *tr);
>  extern int event_trace_del_tracer(struct trace_array *tr);
>
> +extern struct ftrace_event_file *find_event_file(struct trace_array *tr,
> +						 const char *system,
> +						 const char *event);
> +

Here, you exposed find_event_file, but forgot to remove static from the definition
in kernel/trace/trace_events.c.
And even if it solved, I also hit an error and many warnings.

  LD      arch/x86/built-in.o
/home/mhiramat/ksrc/linux-3/kernel/trace/trace_events_trigger.c: In function 'event_trigger_callback':
/home/mhiramat/ksrc/linux-3/kernel/trace/trace_events_trigger.c:510:14: error: 'struct event_trigger_data' has no member named 'post_trigger'
/home/mhiramat/ksrc/linux-3/kernel/trace/trace_events_trigger.c: At top level:
/home/mhiramat/ksrc/linux-3/kernel/trace/trace_events_trigger.c:242:19: warning: 'register_event_command' defined but not used [-Wunused-function]
/home/mhiramat/ksrc/linux-3/kernel/trace/trace_events_trigger.c:267:19: warning: 'unregister_event_command' defined but not used [-Wunused-function]
/home/mhiramat/ksrc/linux-3/kernel/trace/trace_events_trigger.c:297:1: warning: 'event_trigger_print' defined but not used [-Wunused-function]
/home/mhiramat/ksrc/linux-3/kernel/trace/trace_events_trigger.c:326:1: warning: 'event_trigger_init' defined but not used [-Wunused-function]
/home/mhiramat/ksrc/linux-3/kernel/trace/trace_events_trigger.c:344:1: warning: 'event_trigger_free' defined but not used [-Wunused-function]
/home/mhiramat/ksrc/linux-3/kernel/trace/trace_events_trigger.c:412:12: warning: 'register_trigger' defined but not used [-Wunused-function]
/home/mhiramat/ksrc/linux-3/kernel/trace/trace_events_trigger.c:451:13: warning: 'unregister_trigger' defined but not used [-Wunused-function]
/home/mhiramat/ksrc/linux-3/kernel/trace/trace_events_trigger.c:482:1: warning: 'event_trigger_callback' defined but not used [-Wunused-function]
make[3]: *** [kernel/trace/trace_events_trigger.o] Error 1

The post_trigger member is introduced in 7/10, and all warning helper functions
are used in the next (3/10) patch. So, I recommend you to move all post_trigger
related code into 7/10 or merge it into this patch, and move all helper functions
into 3/10 for fixing these warnings and an error. :)

(2013/08/23 8:27), Tom Zanussi wrote:
> +/**
> + * struct event_command - callbacks and data members for event commands
> + *
[...]
> + * @post_trigger: A flag that says whether or not this command needs
[...]
> +	trigger_data->count = -1;
> +	trigger_data->ops = trigger_ops;
> +	trigger_data->cmd_ops = cmd_ops;
> +	trigger_data->mode = cmd_ops->trigger_mode;
> +	trigger_data->post_trigger = cmd_ops->post_trigger;

BTW, why the trigger_data has a copy of trigger_mode and post_trigger?
It seems redundant... :(
Also, the "trigger_mode" name is not good for me, because we already has
FTRACE_EVENT_FL_TRIGGER_MODE_BIT bitflag. Perhaps, trigger_group or just
group_id may be better, I think.

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


