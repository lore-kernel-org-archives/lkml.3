Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933230AbaDBTx1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 15:53:27 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:33584 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933034AbaDBTxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 15:53:20 -0400
Subject: Re: [PATCH 5/7] uprobes/x86: Gather "riprel" functions together
From: Jim Keniston <jkenisto@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20140331194409.GA9297@redhat.com>
References: <20140331194409.GA9297@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Apr 2014 12:53:15 -0700
Message-ID: <1396468395.4659.59.camel@oc7886638347.ibm.com.usor.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-30.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14040219-7164-0000-0000-000000C01E33
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-03-31 at 21:44 +0200, Oleg Nesterov wrote:
...
> +static void
> +handle_riprel_post_xol(struct arch_uprobe *auprobe, struct pt_regs *regs, long *correction)
> +{
> +	if (auprobe->fixups & (UPROBE_FIX_RIP_AX | UPROBE_FIX_RIP_CX)) {
> +		struct arch_uprobe_task *autask;
> +
> +		autask = &current->utask->autask;
> +		if (auprobe->fixups & UPROBE_FIX_RIP_AX)
> +			regs->ax = autask->saved_scratch_register;
> +		else
> +			regs->cx = autask->saved_scratch_register;
> +
> +		/*
> +		 * The original instruction includes a displacement, and so
> +		 * is 4 bytes longer than what we've just single-stepped.
> +		 * Fall through to handle stuff like "jmpq *...(%rip)" and
> +		 * "callq *...(%rip)".
> +		 */
> +		if (correction)
> +			*correction += 4;
> +	}
> +}

This is another case of a glitch in the code being moved.  Since this
code was moved to its own function, the "Fall through" comment makes no
sense.  Maybe
		 * Caller may need to apply other fixups to handle stuff
		 * like "jmpq *...(%rip)" and "callq *...(%rip)".

Jim

