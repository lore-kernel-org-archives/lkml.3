Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751765Ab3LLTpt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 14:45:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1413 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751558Ab3LLTpr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 14:45:47 -0500
Date: Thu, 12 Dec 2013 20:46:28 +0100
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
Subject: Re: Re: [PATCH 16/17] uprobes: Allocate ->utask before
	handler_chain() for tracing handlers
Message-ID: <20131212194628.GA5786@redhat.com>
References: <1386570005-3368-1-git-send-email-namhyung@kernel.org> <1386570005-3368-17-git-send-email-namhyung@kernel.org> <52A6EFD7.8050602@hitachi.com> <20131210155744.GA21466@redhat.com> <52A7C347.1060402@hitachi.com> <20131211181155.GA25144@redhat.com> <52A94FED.3020705@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52A94FED.3020705@hitachi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12, Masami Hiramatsu wrote:
>
> (2013/12/12 3:11), Oleg Nesterov wrote:
> > On 12/11, Masami Hiramatsu wrote:
> >>
> >> But it could skip the handler_chain silently. It could confuse users
> >> why their probe doesn't hit as expected.
> >
> > No, we will restart the same (probed) instruction, handle_swbp()
> > will be called again, get_utask() will be called again.
>
> Hmm, in that case, how would you avoid infinite recursive loop??

Masami, I do not understand your concerns ;) see below.

> Would you repeat it until get_utask() != NULL?

Yes, the task will loop until kmalloc(GFP_KERNEL) succeeds, and I see
nothing wrong here.

Just in case, let me remind that it won't loop in kernel mode, it can
take a signal, it can be killed. And it is not recursive, this is
like restart after page fault (which btw can fault again if the page
was unmapped again, and "in theory" this loop can be infinite too).

And why this is bad? Once again, this is GFP_KERNEL allocation, if it
loops "indefinitely" there is something wrong. Even a single GFP_KERNEL
failure likely means the task is already killed by oom, so it will
simply exit when it returns to user-mode.

And how this differs from, say, the "endless" should_alloc_retry() loop
in __alloc_pages_slowpath() ? And note that in this case we loop in
kernel mode. Of course this is not possible "in practice", but the same
is true for the "endless" loop you are worried about.

> >> Hmm, in that case, should uprobes handlers never be called on ppc with
> >> this change?
> >
> > Why? With this change ppc will have ->utask != NULL even if it doesn't
> > need it at all.
>
> Ah, I see. This changes that.

Yes, this is why the changelog says "a bit unfortunate", we allocate the
memory even there is no trace_uprobe consumer. So it would be nice to
cleanup this later somehow, but imho this is a low priority problem and
perhaps we will simply postulate that uprobe_consumer->handler() can
rely on task->utask != NULL and remove get_utask() from pre_ssout().
The only necessary cleanup (in my opinion) is that we should add another
member into the union in uprobe_task for trace_uprobe.c, but again I
think we should do this later to avoid the (potentially conflicting)
changes in this series.

Oleg.

