Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751452AbaHHTdJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 15:33:09 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:42244 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751002AbaHHTdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 15:33:03 -0400
Date: Fri, 8 Aug 2014 15:33:01 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Josef Bacik <jbacik@fb.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] trace-cmd: make sure we have a pending pid in
 trace-hist
Message-ID: <20140808153301.2ca99357@gandalf.local.home>
In-Reply-To: <1406753685-10590-1-git-send-email-jbacik@fb.com>
References: <1406753685-10590-1-git-send-email-jbacik@fb.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jul 2014 16:54:45 -0400
Josef Bacik <jbacik@fb.com> wrote:

> I have a trace.dat file where we lost some events and so we didn't have the
> corresponding event to go with the stack trace.  This made trace-cmd hist
> segfault because it unconditionally pushes the pending_pid's function onto the
> stack trace.  In this case pending_pid < 0, which means we didn't have a pending
> stack trace, so we got garbage in the call chain and hilarity ensued.  Fix this
> by only pushing the pending call chain if there actually is one, and also don't
> reset the current call chain if there isn't actually one there either.  This
> fixed my segfault.  Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@fb.com>
> ---
>  Makefile      |  9 +++++----
>  trace-cmd.c   |  3 +++
>  trace-hist.c  | 14 +++++++++-----
>  trace-local.h |  2 ++
>  trace-usage.c |  5 +++++
>  5 files changed, 24 insertions(+), 9 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index cbe0eb9..0a46125 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -81,7 +81,7 @@ ifndef NO_PYTHON
>  PYTHON		:= ctracecmd.so
>  PYTHON_GUI	:= ctracecmd.so ctracecmdgui.so
>  
> -PYTHON_VERS ?= python
> +PYTHON_VERS ?= python-2.7
>  
>  # Can build python?
>  ifeq ($(shell sh -c "pkg-config --cflags $(PYTHON_VERS) > /dev/null 2>&1 && echo y"), y)
> @@ -164,6 +164,7 @@ LIBS = -L. -ltracecmd -ldl
>  LIB_FILE = libtracecmd.a
>  
>  PACKAGES= gtk+-2.0 libxml-2.0 gthread-2.0
> +NOGUI_PACKAGES= glib-2.0
>  
>  ifndef BUILDGUI
>   BUILDGUI = 0
> @@ -194,8 +195,8 @@ N 		= @/bin/true ||
>  CONFIG_FLAGS	+= $(HELP_DIR_SQ)
>  else
>  
> -CONFIG_INCLUDES = 
> -CONFIG_LIBS	=
> +CONFIG_INCLUDES = $(shell pkg-config --cflags $(NOGUI_PACKAGES))
> +CONFIG_LIBS	= $(shell pkg-config --libs $(NOGUI_PACKAGES))
>  CONFIG_FLAGS	=
>  
>  VERSION		= $(TC_VERSION)
> @@ -307,7 +308,7 @@ $(obj)/%.o: $(src)/%.c
>  TRACE_GUI_OBJS = trace-filter.o trace-compat.o trace-hash.o trace-dialog.o \
>  		trace-xml.o
>  TRACE_CMD_OBJS = trace-cmd.o trace-record.o trace-read.o trace-split.o trace-listen.o \
> -	 trace-stack.o trace-hist.o trace-mem.o trace-snapshot.o
> +	 trace-stack.o trace-hist.o trace-mem.o trace-snapshot.o trace-latency.o
>  TRACE_VIEW_OBJS = trace-view.o trace-view-store.o
>  TRACE_GRAPH_OBJS = trace-graph.o trace-plot.o trace-plot-cpu.o trace-plot-task.o
>  TRACE_VIEW_MAIN_OBJS = trace-view-main.o $(TRACE_VIEW_OBJS) $(TRACE_GUI_OBJS)
> diff --git a/trace-cmd.c b/trace-cmd.c
> index ebf9c7a..a8ecad6 100644
> --- a/trace-cmd.c
> +++ b/trace-cmd.c
> @@ -432,6 +432,9 @@ int main (int argc, char **argv)
>  	} else if (strcmp(argv[1], "stack") == 0) {
>  		trace_stack(argc, argv);
>  		exit(0);
> +	} else if (strcmp(argv[1], "latency") == 0) {
> +		trace_latency(argc, argv);
> +		exit(0);
>  	} else if (strcmp(argv[1], "check-events") == 0) {
>  		char *tracing;
>  		int ret;
> diff --git a/trace-hist.c b/trace-hist.c
> index 73820de..574549e 100644
> --- a/trace-hist.c
> +++ b/trace-hist.c
> @@ -453,9 +453,11 @@ process_kernel_stack(struct pevent *pevent, struct pevent_record *record)
>  		}
>  	} else {
>  		/* function stack trace? */
> -		copy_stack_to_pending(current_pid);
> -		free(ips);
> -		reset_stack();
> +		if (current_pid >= 0) {
> +			copy_stack_to_pending(current_pid);
> +			free(ips);
> +			reset_stack();
> +		}
>  	}
>  
>  	current_pid = pid;
> @@ -482,8 +484,10 @@ process_kernel_stack(struct pevent *pevent, struct pevent_record *record)
>  			push_stack_func(func);
>  	}
>  
> -	push_stack_func(pending_ips[pending_ips_idx - 1]);
> -	reset_pending_stack();
> +	if (pending_pid >= 0) {
> +		push_stack_func(pending_ips[pending_ips_idx - 1]);
> +		reset_pending_stack();
> +	}
>  	save_call_chain(current_pid, ips, ips_idx, 1);
>  	if (do_restore)
>  		restore_stack(current_pid);

This blob looks to be what the change log suggest. I think you added a
bunch more than the fix.

Can you resend please with just the change from the change log. If you
want to add more, please send separate patches. This shouldn't be like
congress adding earmarks now, is it ;-)

Thanks!

-- Steve


> diff --git a/trace-local.h b/trace-local.h
> index 3c82c2f..1d6d69b 100644
> --- a/trace-local.h
> +++ b/trace-local.h
> @@ -57,6 +57,8 @@ void trace_snapshot(int argc, char **argv);
>  
>  void trace_mem(int argc, char **argv);
>  
> +void trace_latency(int argc, char **argv);
> +
>  /* --- instance manipulation --- */
>  
>  struct func_list {
> diff --git a/trace-usage.c b/trace-usage.c
> index 0dec87e..ef73551 100644
> --- a/trace-usage.c
> +++ b/trace-usage.c
> @@ -231,6 +231,11 @@ static struct usage_help usage_help[] = {
>  		"          -N do not load any plugins\n"
>  	},
>  	{
> +		"latency",
> +		"parse latency events",
> +		""
> +	},
> +	{
>  		NULL, NULL, NULL
>  	}
>  };

