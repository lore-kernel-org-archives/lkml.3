Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754427Ab3GDEWf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 00:22:35 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:51118 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab3GDEWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 00:22:34 -0400
Message-ID: <51D4F885.3040105@hitachi.com>
Date: Thu, 04 Jul 2013 13:22:29 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH 1/4] tracing: Add ref count to ftrace_event_call
References: <20130704033347.807661713@goodmis.org> <20130704034038.501144114@goodmis.org>
In-Reply-To: <20130704034038.501144114@goodmis.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/07/04 12:33), Steven Rostedt wrote:
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index 7d85429..90cf243 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -391,6 +391,28 @@ static void __get_system_dir(struct ftrace_subsystem_dir *dir)
>  	__get_system(dir->subsystem);
>  }
>  
> +static int ftrace_event_call_get(struct ftrace_event_call *call)
> +{
> +	int ret = 0;
> +
> +	mutex_lock(&event_mutex);
> +	if ((call->flags & TRACE_EVENT_FL_REF_MASK) == TRACE_EVENT_FL_REF_MAX - 1)
> +		ret = -EBUSY;
> +	else
> +		call->flags++;
> +	mutex_unlock(&event_mutex);
> +
> +	return ret;
> +}
> +
> +static void ftrace_event_call_put(struct ftrace_event_call *call)
> +{
> +	mutex_lock(&event_mutex);
> +	if (!WARN_ON_ONCE(!(call->flags & TRACE_EVENT_FL_REF_MASK)))
> +		call->flags--;
> +	mutex_unlock(&event_mutex);
> +}

Hmm, I might misunderstand, but it seems that there is a small unsafe
time slot.

> @@ -424,7 +446,15 @@ static int tracing_open_generic_file(struct inode *inode, struct file *filp)
>  
>  	ret = tracing_open_generic(inode, filp);
>  	if (ret < 0)
> -		trace_array_put(tr);
> +		goto fail;
> +
> +	ret = ftrace_event_call_get(file->event_call);
> +	if (ret < 0)
> +		goto fail;
> +
> +	return 0;
> + fail:
> +	trace_array_put(tr);
>  	return ret;
>  }
>  
> @@ -433,12 +463,40 @@ static int tracing_release_generic_file(struct inode *inode, struct file *filp)
>  	struct ftrace_event_file *file = inode->i_private;
>  	struct trace_array *tr = file->tr;
>  
> +	ftrace_event_call_put(file->event_call);
>  	trace_array_put(tr);
>  
>  	return 0;
>  }

Here, at first we get an event_file from inode->i_private, and then locks
event_mutex and get/put refcount. This should be safe if we get (find) the object
from some list of event_file under the mutex, but we just use inode->i_private.

This can cause a race as below scenario,

CPU0                              CPU1
open(kprobe_events)
  trace_remove_event_call()    open(enable)
    lock event_mutex             refer event_file
      event_remove()             wait for unlock event_mutex
        ...
        free event_file
    unlock event_mutex
                                 lock event_mutex
                                    add refcount of event_file->call (*)

So, at (*) point, the event_file is already freed. Thus there still be
an unsafe time slot. Or, did I miss something (possibly..)?

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


