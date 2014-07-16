Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934720AbaGPQoB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 12:44:01 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:21467 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933645AbaGPQn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 12:43:58 -0400
Date: Wed, 16 Jul 2014 12:43:56 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Petr Mladek <pmladek@suse.cz>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] ring-buffer: Race when writing and swapping cpu
 buffer in parallel
Message-ID: <20140716124356.398e21f4@gandalf.local.home>
In-Reply-To: <1405501084-16135-1-git-send-email-pmladek@suse.cz>
References: <1405501084-16135-1-git-send-email-pmladek@suse.cz>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jul 2014 10:58:04 +0200
Petr Mladek <pmladek@suse.cz> wrote:


> +/**
> + * ring_buffer_swap_cpu - swap a CPU buffer between two ring buffers
> + * @buffer_a: One buffer to swap with
> + * @buffer_b: The other buffer to swap with
> + *
> + * This function is useful for tracers that want to take a "snapshot"
> + * of a CPU buffer and has another back up buffer lying around.
> + * It is expected that the tracer handles the cpu buffer not being
> + * used at the moment.
> + */
> +int ring_buffer_swap_cpu(struct ring_buffer *buffer_a,
> +			 struct ring_buffer *buffer_b, int cpu)
> +{
> +	struct ring_buffer_swap_info rb_swap_info = {
> +		.buffer_a = buffer_a,
> +		.buffer_b = buffer_b,
> +	};
> +	int ret;
> +
> +	/*
> +	 * Swap the CPU buffer on the same CPU. Recording has to be fast
> +	 * and and this helps to avoid memory barriers.
> +	 */
> +	ret = smp_call_function_single(cpu, ring_buffer_swap_this_cpu,
> +				       (void *)&rb_swap_info, 1);
> +	if (ret)
> +		return ret;
> +
> +	return rb_swap_info.ret;

We need to check if the cpu is on the current CPU and if so, just call
the function directly. Otherwise this can't be done from interrupt
disabled context.

Enable IRQSOFF_TRACER and FTRACE_STARTUP_TEST to see why.

[    2.098008] Testing tracer irqsoff: 
[    2.351020] ------------[ cut here ]------------
[    2.352000] WARNING: CPU: 3 PID: 0 at /home/rostedt/work/git/linux-trace.git/kernel/smp.c:283 smp_call_function_single+0x66/0xad()
[    2.352000] Modules linked in:
[    2.352000] CPU: 3 PID: 0 Comm: swapper/3 Not tainted 3.16.0-rc3-test+ #93
[    2.352000] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./To be filled by O.E.M., BIOS SDBLI944.86P 05/08/2007
[    2.352000]  0000000000000000 ffffffff810058cb ffffffff81503d20 0000000000000000
[    2.352000]  ffffffff81040ca1 0000000000000000 ffffffff8109712f 0000000000000001
[    2.352000]  0000000000000003 ffffffff810bf9db ffff88007a3c3e30 0000000000000001
[    2.352000] Call Trace:
[    2.352000]  [<ffffffff810058cb>] ? show_stack+0x5/0x3e
[    2.352000]  [<ffffffff81503d20>] ? dump_stack+0x4a/0x75
[    2.352000]  [<ffffffff81040ca1>] ? warn_slowpath_common+0x7e/0x97
[    2.352000]  [<ffffffff8109712f>] ? smp_call_function_single+0x66/0xad
[    2.352000]  [<ffffffff810bf9db>] ? ring_buffer_swap_cpu+0x45/0x45
[    2.352000]  [<ffffffff8109712f>] ? smp_call_function_single+0x66/0xad
[    2.352000]  [<ffffffff810970ce>] ? smp_call_function_single+0x5/0xad
[    2.352000]  [<ffffffff810bf9ce>] ? ring_buffer_swap_cpu+0x38/0x45
[    2.352000]  [<ffffffff810c6c64>] ? update_max_tr_single+0xb6/0x11f
[    2.352000]  [<ffffffff8100ae3e>] ? default_idle+0x1d/0x30
[    2.352000]  [<ffffffff810cd2ac>] ? stop_critical_timing+0x139/0x20d
[    2.352000]  [<ffffffff8100ae3e>] ? default_idle+0x1d/0x30
[    2.352000]  [<ffffffff81072d35>] ? cpu_startup_entry+0x115/0x220
[    2.352000]  [<ffffffff81027610>] ? start_secondary+0x21c/0x222
[    2.352000] ---[ end trace a712676a9f9a53a0 ]---


-- Steve
