Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751440Ab3KKBhp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 20:37:45 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:38867 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929Ab3KKBhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 20:37:38 -0500
Message-ID: <528034E0.4090402@hitachi.com>
Date: Mon, 11 Nov 2013 10:37:36 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Namhyung Kim <namhyung@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: Re: [PATCH] uprobes: Add uprobe_task->dup_work/dup_addr
References: <20131108190003.GA12755@redhat.com> <527FA9A3.2090905@hitachi.com> <20131110172853.GA427@redhat.com>
In-Reply-To: <20131110172853.GA427@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/11/11 2:28), Oleg Nesterov wrote:
> On 11/11, Masami Hiramatsu wrote:
>>
>> (2013/11/09 4:00), Oleg Nesterov wrote:
>>> uprobe_task->vaddr is a bit strange. First of all it is not really
>>> needed, we can move it into arch_uprobe_task. The generic code uses
>>> it only to pass the additional argument to arch_uprobe_pre_xol(),
>>> and since it is always equal to instruction_pointer() this looks
>>> even more strange.
>>>
>>> And both utask->vaddr and and utask->autask have the same scope,
>>> they only have the meaning when the task executes the probed insn
>>> out-of-line. This means it is safe to reuse both in UTASK_RUNNING
>>> state.
>>>
>>> OTOH, it is also used by uprobe_copy_process() and dup_xol_work()
>>> for another purpose, this doesn't look clean and doesn't allow to
>>> move this member into arch_uprobe_task.
>>>
>>> This patch adds the union with 2 anonymous structs into uprobe_task.
>>>
>>> The first struct is autask + vaddr, this way we "almost" move vaddr
>>> into autask.
>>>
>>> The second struct has 2 new members for uprobe_copy_process() paths:
>>> ->dup_addr which can be used instead ->vaddr, and ->dup_work which
>>> can be used to avoid kmalloc() and simplify the code.
>>
>> Hmm, I'm not so sure about uprobes implementation so deeply.
>> Is there no possibility to run xol preparing code (e.g. adding
>> new uprobe?) between the task_work_add() and task_work_run()?
> 
> No, task_work_run() must be called before the new child returns
> to user-mode.
> 
> And it obviously can't hit the breakpoint until it returns to
> user mode. "adding new uprobe" doesn't matter at all, the task
> itself runs xol preparing code when it hits the bp first time.

Ah, I misunderstood. XOL area should be placed in each process
address space, thus until it hits the probe, uprobe can't
create XOL code, I got it.

>>> Note that this union will likely have another member(s), we need
>>> something like "private_data_for_handlers" so that the tracing
>>> handlers could use it to communicate with call_fetch() methods.
>>>
>>
>> If those data structures are small, I think we don't need to
>> use such union...
> 
> Well, I disagree. First of all, to me this patch cleanups the code
> but this is subjective.
> 
> Why should we blow the size of task_struct->utask if there is no
> reason?
> 
> For example, should we instead add utask->dup_addr outiside of this
> union? Or create dup_xol_struct which holds this argument along
> with callback_head ? I don't think so. The scope of autask/vaddr and
> dup_work/addr is not interactable.

I see your point.

> The same for the new ->private (or whatever) we are going to add for
> FETCH_MTD_relative. It will only have a meaning inside the ->handler()
> paths, to me it would be strange to not reuse the "free" memory we
> already have.

Looks nice ;)

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


