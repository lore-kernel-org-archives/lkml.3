Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494Ab3LJP5I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 10:57:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9436 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751687Ab3LJP5E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 10:57:04 -0500
Date: Tue, 10 Dec 2013 16:57:44 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Namhyung Kim <namhyung@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 16/17] uprobes: Allocate ->utask before handler_chain()
	for tracing handlers
Message-ID: <20131210155744.GA21466@redhat.com>
References: <1386570005-3368-1-git-send-email-namhyung@kernel.org> <1386570005-3368-17-git-send-email-namhyung@kernel.org> <52A6EFD7.8050602@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52A6EFD7.8050602@hitachi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10, Masami Hiramatsu wrote:
>
> (2013/12/09 15:20), Namhyung Kim wrote:
> > From: Oleg Nesterov <oleg@redhat.com>
> >
> > uprobe_trace_print() and uprobe_perf_print() need to pass the additional
> > info to call_fetch() methods, currently there is no simple way to do this.
> >
> > current->utask looks like a natural place to hold this info, but we need
> > to allocate it before handler_chain().
> >
> > This is a bit unfortunate, perhaps we will find a better solution later,
> > but this is simnple and should work right now.
>
> Hmm, when this will happen?

Perhaps never. Perhaps it will stay forever and we remove get_utask() from
pre_ssout() (it is not needed after this patch).

However I still think we can cleanup this. And to remind, we need to clean
the usage of utask->vaddr in trace_uprobe.c anyway. We can either try to
find another place to pass the info, or we can create a helper(s) for the
tracing handlers to access (and populate if NULL) utask->handler_data.
Note that this (probably) also makes sense because we can unexport
"struct uprobe_task" (but this needs a couple of off-topic cleanups).

We will see. Lets do the minimal change which can work right now, Namhyung
has enough more serious problems ;)

> and isn't it better to increment
> miss-hit counter of the uprobe?

What do you mean? This is not miss-hit and ->utask == NULL is quite normal.
For example, on ppc it can be always NULL because ppc likely emulates the
probed insn.

Or did you mean that if get_utask() fails we should report this somehow?
Well, GFP_KERNEL should "never" fail and even if it fails we will restart
the same insn and retry the allocation.

Or did I miss your point completely ?

Oleg.

