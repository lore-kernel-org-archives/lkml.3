Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754AbaKSEPj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 23:15:39 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:37129 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754124AbaKSEPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 23:15:38 -0500
Date: Tue, 18 Nov 2014 23:15:16 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        williams@redhat.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 2/2] ftrace/x86/extable: Add is_ftrace_trampoline()
 function
Message-ID: <20141118231516.2c3a7bdb@gandalf.local.home>
In-Reply-To: <20141119034829.497125839@goodmis.org>
References: <20141119033331.689278545@goodmis.org>
	<20141119034829.497125839@goodmis.org>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Nov 2014 22:33:33 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:


> +/*
> + * This is used by __kernel_text_address() to return true if the
> + * the address is on a dynamically allocated trampoline that would
> + * not return true for either core_kernel_text() or
> + * is_module_text_address().
> + */
> +bool is_ftrace_trampoline(unsigned long addr)
> +{
> +	struct ftrace_ops *op;
> +
> +	do_for_each_ftrace_op(op, ftrace_ops_list) {
> +		/*
> +		 * This is to check for dynamically allocated trampolines.
> +		 * Trampolines that are in kernel text will have
> +		 * core_kernel_text() return true.
> +		 */
> +		if (op->trampoline && op->trampoline_size)
> +			if (addr >= op->trampoline &&
> +			    addr < op->trampoline + op->trampoline_size)
> +				return true;
> +	} while_for_each_ftrace_op(op);
> +
> +	return false;
> +}
> +

Hmm, preemption should be disabled here. We can't guarantee that the
caller will have that. Will update.

-- Steve
