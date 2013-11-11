Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917Ab3KKQ7n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 11:59:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3935 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754662Ab3KKQ7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 11:59:35 -0500
Date: Mon, 11 Nov 2013 17:55:43 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Ingo Molnar <mingo@elte.hu>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uprobes: Add uprobe_task->dup_work/dup_addr
Message-ID: <20131111165543.GA12233@redhat.com>
References: <20131108190003.GA12755@redhat.com> <20131111071151.GA2559@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131111071151.GA2559@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11, Srikar Dronamraju wrote:
>
> * Oleg Nesterov <oleg@redhat.com> [2013-11-08 20:00:03]:
>
> > uprobe_task->vaddr is a bit strange. First of all it is not really
> > needed, we can move it into arch_uprobe_task. The generic code uses
> > it only to pass the additional argument to arch_uprobe_pre_xol(),
> > and since it is always equal to instruction_pointer() this looks
> > even more strange.
> >
>
> While the code changes look good, I would disagree with the above
> statement.  uprobe_task->vaddr is a bit strange only in
> uprobe_copy_process() and not in arch_uprobe_pre_xol() context.
> uprobe_task->vaddr was used to refer to the actual instruction pointer

Yes, and it is always equal to regs->ip when pre_ssout() is called,

> and do the necessary fixups after single stepping out of line.

Exactly. So it is write-only (and meaningless) to the generic uprobe
code. We can (and perhaps should) move it into autask->saved_vaddr,
arch_uprobe_pre_xol() can initialize it.

> The casual reading of this commit message, one can get an impression
> that vaddr is never needed.

See above. The changelog doesn't say we can simply remove it, it says
"move it".

> Your change still retains it.

Of course we can't kill utas->vaddr until we change x86/powerpc. And
just in case, of course I understand that this is minor and even
subjective.

But at least this patch logically "joins" autask and vaddr, and I
believe this is good because they are always used together, because,
well, logically vaddr belongs to autask ;)

> So can we
> modify the commit message accordingly?

Well, I'll try... but perhaps you can help? I mean, I am not sure
about how I can improve it. Could you suggest a better wording?

> Otherwise
> Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

Thanks!

> > @@ -72,14 +73,24 @@ enum uprobe_task_state {
> >   */
> >  struct uprobe_task {
> >  	enum uprobe_task_state		state;
> > -	struct arch_uprobe_task		autask;
> >
> > -	struct return_instance		*return_instances;
> > -	unsigned int			depth;
> > -	struct uprobe			*active_uprobe;
> > +	union {
> > +		struct {
> > +			struct arch_uprobe_task	autask;
> > +			unsigned long		vaddr;
> > +		};
> > +
> > +		struct {
> > +			struct callback_head	dup_work;
> > +			unsigned long		dup_addr;
>
> Nit:
> Can we rename dup_addr to mean that it refers to the xol; something like
> dup_xol_addr or even xol_addr. So that its more clear what address it
> refers to.

OK. How about dup_xol_work/dup_xol_vaddr ?

Oleg.

