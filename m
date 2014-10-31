Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758285AbaJaFTN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 01:19:13 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:36325 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406AbaJaFTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 01:19:12 -0400
Message-ID: <54531BC7.4030307@hitachi.com>
Date: Fri, 31 Oct 2014 14:19:03 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Josh Poimboeuf <jpoimboe@redhat.com>,
        Vojtech Pavlik <vojtech@suse.cz>, Seth Jennings <sjenning@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [for-next][PATCH 1/4] ftrace/x86: Add dynamic allocated trampoline
 for ftrace_ops
References: <20141027182702.778680710@goodmis.org> <20141027182948.284867581@goodmis.org>
In-Reply-To: <20141027182948.284867581@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

(2014/10/28 3:27), Steven Rostedt wrote:
> +static unsigned long create_trampoline(struct ftrace_ops *ops)
> +{
> +	unsigned const char *jmp;
> +	unsigned long start_offset;
> +	unsigned long end_offset;
> +	unsigned long op_offset;
> +	unsigned long offset;
> +	unsigned long size;
> +	unsigned long ip;
> +	unsigned long *ptr;
> +	void *trampoline;
> +	/* 48 8b 15 <offset> is movq <offset>(%rip), %rdx */
> +	unsigned const char op_ref[] = { 0x48, 0x8b, 0x15 };
> +	union ftrace_op_code_union op_ptr;
> +	int ret;
> +
> +	if (ops->flags & FTRACE_OPS_FL_SAVE_REGS) {
> +		start_offset = (unsigned long)ftrace_regs_caller;
> +		end_offset = (unsigned long)ftrace_regs_caller_end;
> +		op_offset = (unsigned long)ftrace_regs_caller_op_ptr;
> +	} else {
> +		start_offset = (unsigned long)ftrace_caller;
> +		end_offset = (unsigned long)ftrace_caller_end;
> +		op_offset = (unsigned long)ftrace_caller_op_ptr;
> +	}
> +
> +	size = end_offset - start_offset;
> +
> +	/*
> +	 * Allocate enough size to store the ftrace_caller code,
> +	 * the jmp to ftrace_return, as well as the address of
> +	 * the ftrace_ops this trampoline is used for.
> +	 */
> +	trampoline = alloc_tramp(size + MCOUNT_INSN_SIZE + sizeof(void *));
> +	if (!trampoline)
> +		return 0;
> +
> +	/* Copy ftrace_caller onto the trampoline memory */
> +	ret = probe_kernel_read(trampoline, (void *)start_offset, size);
> +	if (WARN_ON(ret < 0)) {
> +		tramp_free(trampoline);
> +		return 0;
> +	}
> +
> +	ip = (unsigned long)trampoline + size;
> +
> +	/* The trampoline ends with a jmp to ftrace_return */
> +	jmp = ftrace_jmp_replace(ip, (unsigned long)ftrace_return);
> +	memcpy(trampoline + size, jmp, MCOUNT_INSN_SIZE);
> +
> +	/*
> +	 * The address of the ftrace_ops that is used for this trampoline
> +	 * is stored at the end of the trampoline. This will be used to
> +	 * load the third parameter for the callback. Basically, that
> +	 * location at the end of the trampoline takes the place of
> +	 * the global function_trace_op variable.
> +	 */
> +
> +	ptr = (unsigned long *)(trampoline + size + MCOUNT_INSN_SIZE);
> +	*ptr = (unsigned long)ops;
> +
> +	op_offset -= start_offset;
> +	memcpy(&op_ptr, trampoline + op_offset, OP_REF_SIZE);
> +
> +	/* Are we pointing to the reference? */
> +	if (WARN_ON(memcmp(op_ptr.op, op_ref, 3) != 0)) {
> +		tramp_free(trampoline);
> +		return 0;
> +	}
> +
> +	/* Load the contents of ptr into the callback parameter */
> +	offset = (unsigned long)ptr;
> +	offset -= (unsigned long)trampoline + op_offset + OP_REF_SIZE;
> +
> +	op_ptr.offset = offset;
> +
> +	/* put in the new offset to the ftrace_ops */
> +	memcpy(trampoline + op_offset, &op_ptr, OP_REF_SIZE);

Would we better call flush_icache_range here?

Thank you,

> +
> +	/* ALLOC_TRAMP flags lets us know we created it */
> +	ops->flags |= FTRACE_OPS_FL_ALLOC_TRAMP;
> +
> +	return (unsigned long)trampoline;
> +}


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


