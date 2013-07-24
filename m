Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599Ab3GXUBc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 16:01:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6812 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001Ab3GXUBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 16:01:31 -0400
X-Authority-Analysis: v=2.0 cv=aqMw+FlV c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=4Ev8qhwGO5kA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=67j-9AyLRNQA:10 a=BT26OjkYFHH9qtcoy94A:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1374696088.3356.156.camel@gandalf.local.home>
Subject: Re: [PATCH 5/6] tracing: Introduce remove_event_file_dir()
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Alexander Z Lam <azl@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Sharp <dhsharp@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Date: Wed, 24 Jul 2013 16:01:28 -0400
In-Reply-To: <20130723205923.GA9075@redhat.com>
References: <20130723205923.GA9075@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-23 at 22:59 +0200, Oleg Nesterov wrote:

>  static void remove_event_from_tracers(struct ftrace_event_call *call)
>  {
>  	struct ftrace_event_file *file;
>  	struct trace_array *tr;
>  
>  	do_for_each_event_file_safe(tr, file) {
> -
> -		if (file->event_call != call)
> -			continue;
> -
> -		list_del(&file->list);
> -		debugfs_remove_recursive(file->dir);
> -		remove_subsystem(file->system);
> -		kmem_cache_free(file_cachep, file);
> -
> -		/*
> -		 * The do_for_each_event_file_safe() is
> -		 * a double loop. After finding the call for this
> -		 * trace_array, we use break to jump to the next
> -		 * trace_array.
> -		 */
> -		break;
> +		if (file->event_call == call) {

I don't care if you do it this way because it's just two lines, but the
reason I do the:

	if (file->event_call != call)
		continue;

is to keep the indentation down.

-- Steve

> +			remove_event_file_dir(file);
> +			/*
> +			 * The do_for_each_event_file_safe() is
> +			 * a double loop. After finding the call for this
> +			 * trace_array, we use break to jump to the next
> +			 * trace_array.
> +			 */
> +			break;
> +		}
>  	} while_for_each_event_file();
>  }
>  
> @@ -2298,12 +2300,8 @@ __trace_remove_event_dirs(struct trace_array *tr)
>  {
>  	struct ftrace_event_file *file, *next;
>  
> -	list_for_each_entry_safe(file, next, &tr->events, list) {
> -		list_del(&file->list);
> -		debugfs_remove_recursive(file->dir);
> -		remove_subsystem(file->system);
> -		kmem_cache_free(file_cachep, file);
> -	}
> +	list_for_each_entry_safe(file, next, &tr->events, list)
> +		remove_event_file_dir(file);
>  }
>  
>  static void


