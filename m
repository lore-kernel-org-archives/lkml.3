Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617Ab3KKHRK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 02:17:10 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:47196 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab3KKHRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 02:17:04 -0500
Date: Mon, 11 Nov 2013 12:41:51 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Ingo Molnar <mingo@elte.hu>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uprobes: Add uprobe_task->dup_work/dup_addr
Message-ID: <20131111071151.GA2559@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20131108190003.GA12755@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20131108190003.GA12755@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111107-7164-0000-0000-0000032FB24D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2013-11-08 20:00:03]:

> uprobe_task->vaddr is a bit strange. First of all it is not really
> needed, we can move it into arch_uprobe_task. The generic code uses
> it only to pass the additional argument to arch_uprobe_pre_xol(),
> and since it is always equal to instruction_pointer() this looks
> even more strange.
> 

While the code changes look good, I would disagree with the above
statement.  uprobe_task->vaddr is a bit strange only in
uprobe_copy_process() and not in arch_uprobe_pre_xol() context.
uprobe_task->vaddr was used to refer to the actual instruction pointer
and do the necessary fixups after single stepping out of line.

The casual reading of this commit message, one can get an impression
that vaddr is never needed.  Your change still retains it. So can we
modify the commit message accordingly? 

> And both utask->vaddr and and utask->autask have the same scope,
> they only have the meaning when the task executes the probed insn
> out-of-line. This means it is safe to reuse both in UTASK_RUNNING
> state.
> 
> OTOH, it is also used by uprobe_copy_process() and dup_xol_work()
> for another purpose, this doesn't look clean and doesn't allow to
> move this member into arch_uprobe_task.
> 
> This patch adds the union with 2 anonymous structs into uprobe_task.
> 
> The first struct is autask + vaddr, this way we "almost" move vaddr
> into autask.
> 
> The second struct has 2 new members for uprobe_copy_process() paths:
> ->dup_addr which can be used instead ->vaddr, and ->dup_work which
> can be used to avoid kmalloc() and simplify the code.
> 
> Note that this union will likely have another member(s), we need
> something like "private_data_for_handlers" so that the tracing
> handlers could use it to communicate with call_fetch() methods.

One nit below + request for change in the above commit message. 
Otherwise 
Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  include/linux/uprobes.h |   21 ++++++++++++++++-----
>  kernel/events/uprobes.c |   16 ++++------------
>  2 files changed, 20 insertions(+), 17 deletions(-)
> 
> diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
> index 319eae7..366b8b2 100644
> --- a/include/linux/uprobes.h
> +++ b/include/linux/uprobes.h
> @@ -26,6 +26,7 @@
> 
>  #include <linux/errno.h>
>  #include <linux/rbtree.h>
> +#include <linux/types.h>
> 
>  struct vm_area_struct;
>  struct mm_struct;
> @@ -72,14 +73,24 @@ enum uprobe_task_state {
>   */
>  struct uprobe_task {
>  	enum uprobe_task_state		state;
> -	struct arch_uprobe_task		autask;
> 
> -	struct return_instance		*return_instances;
> -	unsigned int			depth;
> -	struct uprobe			*active_uprobe;
> +	union {
> +		struct {
> +			struct arch_uprobe_task	autask;
> +			unsigned long		vaddr;
> +		};
> +
> +		struct {
> +			struct callback_head	dup_work;
> +			unsigned long		dup_addr;

Nit:
Can we rename dup_addr to mean that it refers to the xol; something like
dup_xol_addr or even xol_addr. So that its more clear what address it
refers to.


-- 
Thanks and Regards
Srikar Dronamraju

