Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992AbaAOAvl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 19:51:41 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:14285 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750880AbaAOAvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 19:51:36 -0500
Date: Tue, 14 Jan 2014 19:51:34 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Petr Mladek <pmladek@suse.cz>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH v6 5/8] x86: do not trace __probe_kernel_read
Message-ID: <20140114195134.15555077@gandalf.local.home>
In-Reply-To: <1386690140-19941-6-git-send-email-pmladek@suse.cz>
References: <1386690140-19941-1-git-send-email-pmladek@suse.cz>
	<1386690140-19941-6-git-send-email-pmladek@suse.cz>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Dec 2013 16:42:17 +0100
Petr Mladek <pmladek@suse.cz> wrote:

> probe_kernel_read is used when modifying function calls in ftrace_replace_code,
> see arch/x86/kernel/ftrace.c. On x86, the code is replaced using int3 guard.
> All functions are patched in parallel to reduce an expensive synchronization
> of all CPUs. The result is that all affected functions are called via
> ftrace_int3_handler during the process.
> 
> ftrace_int3_handler is relatively slow because it has to check whether
> it is responsible for the handled IP. Therefore we should not modify
> functions that used during patching. It would slowdown the patching.
> 
> I tried to switch between 7 tracers: blk, branch, function_graph, wakeup_rt,
> irqsoff, function, and nop. Every tracer has also been enabled and disabled.
> With 500 cycles, I got these times before this commit:
> 
>     real    18m2.477s     18m8.654s     18m9.196s
>     user    0m0.008s      0m0.008s      0m0.012s
>     sys     0m17.316s     0m17.104s     0m17.300s
> 
> and after this commit:
> 
>     real    16m14.390s    16m15.200s    16m19.632s
>     user    0m0.028s      0m0.024s	0m0.028s
>     sys     0m23.788s     0m23.812s	0m23.804s
> 

Actually no. The benefit of tracing a function outweighs the benefit
of speeding up the conversion. If you want a fast conversion, simply:

 echo __probe_kernel_read > /sys/kernel/debug/tracing/set_ftrace_notrace
 
Try your numbers again with the above line.

-- Steve

> Signed-off-by: Petr Mladek <pmladek@suse.cz>
> ---
>  mm/maccess.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/maccess.c b/mm/maccess.c
> index d53adf9ba84b..bed9ee854ea0 100644
> --- a/mm/maccess.c
> +++ b/mm/maccess.c
> @@ -18,7 +18,7 @@
>  long __weak probe_kernel_read(void *dst, const void *src, size_t size)
>      __attribute__((alias("__probe_kernel_read")));
>  
> -long __probe_kernel_read(void *dst, const void *src, size_t size)
> +long notrace __probe_kernel_read(void *dst, const void *src, size_t size)
>  {
>  	long ret;
>  	mm_segment_t old_fs = get_fs();

