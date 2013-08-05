Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317Ab3HELm4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 07:42:56 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:50768 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748Ab3HELmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 07:42:55 -0400
Message-ID: <51FF8FBC.2090504@hitachi.com>
Date: Mon, 05 Aug 2013 20:42:52 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Tom Zanussi <tom.zanussi@linux.intel.com>
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v4 01/11] tracing: Add support for SOFT_DISABLE to syscall
 events
References: <cover.1375111640.git.tom.zanussi@linux.intel.com> <86c82034b47fb27e30555aaf6a4a962e49581c1d.1375111640.git.tom.zanussi@linux.intel.com>
In-Reply-To: <86c82034b47fb27e30555aaf6a4a962e49581c1d.1375111640.git.tom.zanussi@linux.intel.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/07/30 1:40), Tom Zanussi wrote:
> The original SOFT_DISABLE patches didn't add support for soft disable
> of syscall events; this adds it and paves the way for future patches
> allowing triggers to be added to syscall events, since triggers are
> built on top of SOFT_DISABLE.
> 
> Add an array of ftrace_event_file pointers indexed by syscall number
> to the trace array and remove the existing enabled bitmaps, which as a
> result are now redundant.  The ftrace_event_file structs in turn
> contain the soft disable flags we need for per-syscall soft disable
> accounting; later patches add additional 'trigger' flags and
> per-syscall triggers and filters.

At this point, this looks OK for me.

Note, this could be racy after introducing event-trigger which makes
some other event soft-disabled. Currently only function tracer makes
soft-disabled and it works only on the default instance.
However introducing trigger interface, there can be events in soft-mode,
and  ftrace_event_enable_disable(file, set = 0) to those events always fail.

> 
> Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
> ---
>  kernel/trace/trace.h          |  4 ++--
>  kernel/trace/trace_syscalls.c | 34 ++++++++++++++++++++++++++++------
>  2 files changed, 30 insertions(+), 8 deletions(-)
> 
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index afaae41..3dd994e8 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -192,8 +192,8 @@ struct trace_array {
>  #ifdef CONFIG_FTRACE_SYSCALLS
>  	int			sys_refcount_enter;
>  	int			sys_refcount_exit;
> -	DECLARE_BITMAP(enabled_enter_syscalls, NR_syscalls);
> -	DECLARE_BITMAP(enabled_exit_syscalls, NR_syscalls);
> +	struct ftrace_event_file *enter_syscall_files[NR_syscalls];
> +	struct ftrace_event_file *exit_syscall_files[NR_syscalls];
>  #endif
>  	int			stop_count;
>  	int			clock_id;
> diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
> index 8fd0365..294cfe8 100644
> --- a/kernel/trace/trace_syscalls.c
> +++ b/kernel/trace/trace_syscalls.c
> @@ -302,6 +302,7 @@ static int __init syscall_exit_define_fields(struct ftrace_event_call *call)
>  static void ftrace_syscall_enter(void *data, struct pt_regs *regs, long id)
>  {
>  	struct trace_array *tr = data;
> +	struct ftrace_event_file *ftrace_file;
>  	struct syscall_trace_enter *entry;
>  	struct syscall_metadata *sys_data;
>  	struct ring_buffer_event *event;
> @@ -314,7 +315,12 @@ static void ftrace_syscall_enter(void *data, struct pt_regs *regs, long id)
>  	syscall_nr = trace_get_syscall_nr(current, regs);
>  	if (syscall_nr < 0)
>  		return;
> -	if (!test_bit(syscall_nr, tr->enabled_enter_syscalls))
> +

OK, since all tracepoint handlers run under rcu_read_lock, we can safely
use rcu_dereference_raw() here. :)
To avoid misread, I think you'd better add a comment here.

> +	ftrace_file = rcu_dereference_raw(tr->enter_syscall_files[syscall_nr]);
> +	if (!ftrace_file)
> +		return;
> +
> +	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &ftrace_file->flags))
>  		return;
>  

Thank you,


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


