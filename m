Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759952Ab3ICKuc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 06:50:32 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:35631 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759915Ab3ICKub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 06:50:31 -0400
Message-ID: <5225BEF4.5030901@hitachi.com>
Date: Tue, 03 Sep 2013 19:50:28 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH 10/13] tracing/uprobes: Fetch args before reserving a
 ring buffer
References: <1378187054-27401-1-git-send-email-namhyung@kernel.org> <1378187054-27401-11-git-send-email-namhyung@kernel.org>
In-Reply-To: <1378187054-27401-11-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/09/03 14:44), Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> Fetching from user space should be done in a non-atomic context.  So
> use a per-cpu buffer and copy its content to the ring buffer
> atomically.  Note that we can migrate during accessing user memory
> thus use a per-cpu mutex to protect concurrent accesses.
> 
> This is needed since we'll be able to fetch args from an user memory
> which can be swapped out.  Before that uprobes could fetch args from
> registers only which saved in a kernel space.
> 
> While at it, use __get_data_size() and store_trace_args() to reduce
> code duplication.
> 
> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  kernel/trace/trace_uprobe.c | 97 +++++++++++++++++++++++++++++++++++++--------
>  1 file changed, 81 insertions(+), 16 deletions(-)
> 
> diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
> index 9f2d12d2311d..9ede401759ab 100644
> --- a/kernel/trace/trace_uprobe.c
> +++ b/kernel/trace/trace_uprobe.c
> @@ -530,21 +530,46 @@ static const struct file_operations uprobe_profile_ops = {
>  	.release	= seq_release,
>  };
>  
> +static atomic_t uprobe_buffer_ref = ATOMIC_INIT(0);
> +static void __percpu *uprobe_cpu_buffer;
> +static DEFINE_PER_CPU(struct mutex, uprobe_cpu_mutex);
> +
>  static void uprobe_trace_print(struct trace_uprobe *tu,
>  				unsigned long func, struct pt_regs *regs)
>  {
>  	struct uprobe_trace_entry_head *entry;
>  	struct ring_buffer_event *event;
>  	struct ring_buffer *buffer;
> -	void *data;
> -	int size, i;
> +	struct mutex *mutex;
> +	void *data, *arg_buf;
> +	int size, dsize, esize;
> +	int cpu;
>  	struct ftrace_event_call *call = &tu->p.call;
>  
> -	size = SIZEOF_TRACE_ENTRY(is_ret_probe(tu));
> +	dsize = __get_data_size(&tu->p, regs);
> +	esize = SIZEOF_TRACE_ENTRY(is_ret_probe(tu));
> +
> +	if (WARN_ON_ONCE(!uprobe_cpu_buffer || tu->p.size + dsize > PAGE_SIZE))
> +		return;
> +
> +	cpu = raw_smp_processor_id();
> +	mutex = &per_cpu(uprobe_cpu_mutex, cpu);
> +	arg_buf = per_cpu_ptr(uprobe_cpu_buffer, cpu);
> +
> +	/*
> +	 * Use per-cpu buffers for fastest access, but we might migrate
> +	 * so the mutex makes sure we have sole access to it.
> +	 */
> +	mutex_lock(mutex);
> +	store_trace_args(esize, &tu->p, regs, arg_buf, dsize);
> +
> +	size = esize + tu->p.size + dsize;
>  	event = trace_current_buffer_lock_reserve(&buffer, call->event.type,
> -						  size + tu->p.size, 0, 0);
> -	if (!event)
> +						  size, 0, 0);
> +	if (!event) {
> +		mutex_unlock(mutex);
>  		return;

Just for a maintenance reason, I personally like to use "goto" in this case
to fold up the mutex_unlock. :)

Other parts are good for me.

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thank you!


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


