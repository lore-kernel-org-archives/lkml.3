Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751645Ab3LKBah (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 20:30:37 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:62727 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989Ab3LKBag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 20:30:36 -0500
X-AuditID: 9c93017e-b7bb9ae000000ec8-63-52a7c03b1572
From: Namhyung Kim <namhyung@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        "zhangwei\(Jovi\)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 16/17] uprobes: Allocate ->utask before handler_chain() for tracing handlers
References: <1386570005-3368-1-git-send-email-namhyung@kernel.org>
	<1386570005-3368-17-git-send-email-namhyung@kernel.org>
	<52A6EFD7.8050602@hitachi.com> <20131210155744.GA21466@redhat.com>
Date: Wed, 11 Dec 2013 10:30:35 +0900
In-Reply-To: <20131210155744.GA21466@redhat.com> (Oleg Nesterov's message of
	"Tue, 10 Dec 2013 16:57:44 +0100")
Message-ID: <87eh5ki37o.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oleg,

On Tue, 10 Dec 2013 16:57:44 +0100, Oleg Nesterov wrote:
> On 12/10, Masami Hiramatsu wrote:
>>
>> (2013/12/09 15:20), Namhyung Kim wrote:
>> > From: Oleg Nesterov <oleg@redhat.com>
>> >
>> > uprobe_trace_print() and uprobe_perf_print() need to pass the additional
>> > info to call_fetch() methods, currently there is no simple way to do this.
>> >
>> > current->utask looks like a natural place to hold this info, but we need
>> > to allocate it before handler_chain().
>> >
>> > This is a bit unfortunate, perhaps we will find a better solution later,
>> > but this is simnple and should work right now.
>>
>> Hmm, when this will happen?
>
> Perhaps never. Perhaps it will stay forever and we remove get_utask() from
> pre_ssout() (it is not needed after this patch).
>
> However I still think we can cleanup this. And to remind, we need to clean
> the usage of utask->vaddr in trace_uprobe.c anyway. We can either try to
> find another place to pass the info, or we can create a helper(s) for the
> tracing handlers to access (and populate if NULL) utask->handler_data.
> Note that this (probably) also makes sense because we can unexport
> "struct uprobe_task" (but this needs a couple of off-topic cleanups).
>
> We will see. Lets do the minimal change which can work right now, Namhyung
> has enough more serious problems ;)

Very true. :)

>
>> and isn't it better to increment
>> miss-hit counter of the uprobe?
>
> What do you mean? This is not miss-hit and ->utask == NULL is quite normal.
> For example, on ppc it can be always NULL because ppc likely emulates the
> probed insn.

Yes, for x86, it's always NULL at first but then populated after doing
single-step.  What we try to do is just moving the allocation before
calling handler since we need to carry some information through it.

Thanks,
Namhyung

>
> Or did you mean that if get_utask() fails we should report this somehow?
> Well, GFP_KERNEL should "never" fail and even if it fails we will restart
> the same insn and retry the allocation.
>
> Or did I miss your point completely ?
>
> Oleg.
