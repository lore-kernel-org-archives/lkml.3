Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757561Ab3KYOLk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 09:11:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32574 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932088Ab3KYOLf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 09:11:35 -0500
Date: Mon, 25 Nov 2013 15:12:02 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH] uprobes: Allocate ->utask before handler_chain() for
	tracing handlers
Message-ID: <20131125141202.GA28937@redhat.com>
References: <87sivbz65t.fsf@sejong.aot.lge.com> <20131105174535.GA6385@redhat.com> <20131105192401.GA772@redhat.com> <87vc05x5zf.fsf@sejong.aot.lge.com> <20131106173754.GA11299@redhat.com> <87a9hgwqal.fsf@sejong.aot.lge.com> <527DA997.4080306@hitachi.com> <20131109152313.GA14630@redhat.com> <87siv2uk1q.fsf@sejong.aot.lge.com> <87siulrmpj.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87siulrmpj.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Namhyung,

On 11/25, Namhyung Kim wrote:
>
> Hi Oleg,
>
> On Tue, 12 Nov 2013 17:00:01 +0900, Namhyung Kim wrote:
> > For @+addr syntax: user-space uses relative symbol address from a loaded
> >                    base address and kernel calculates the base address
> >                    using "current->utask->vaddr - tu->offset".
>
> I tried this approach and realized that current->utask is not set

Aaah, I am stipid. Yes, I forgot that it is always NULL until the
task does xol or prepare_uretprobe() for the 1st time.... And on
powerpc it can be always NULL because it can likely emulate the
probed insn.

> or has
> an invalid vaddr when handler_chain() is called.

But this should not matter at all? you should not rely on the value of
->vaddr, you should use at as uninitialized scratchpad. And in fact we
were going to add another member into the union which should be used
instead later (but lets ignore this for now).

> So I had to apply
> following patch and it seems to work well for me.  Could you confirm it?

I don't think we need this patch, see below.

> @@ -1744,11 +1744,17 @@ static void handle_swbp(struct pt_regs *regs)
>  	if (unlikely(!test_bit(UPROBE_COPY_INSN, &uprobe->flags)))
>  		goto out;
>
> +	utask = get_utask();

Yes, we need this until we find another way to pass the additional info
to ->fetch() methods. This is a bit unfortunate, may be we fill find a
better solution later.

But until then we can probably tolerate the hack below, what do you
think?

Oleg.
---

Subject: [PATCH] uprobes: Allocate ->utask before handler_chain() for tracing handlers

uprobe_trace_print() and uprobe_perf_print() need to pass the additional
info to call_fetch() methods, currently there is no simple way to do this.

current->utask looks like a natural place to hold this info, but we need
to allocate it before handler_chain().

This is a bit unfortunate, perhaps we will find a better solution later,
but this is simple and should work right now.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/events/uprobes.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index b886a5e..307d87c 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1854,6 +1854,10 @@ static void handle_swbp(struct pt_regs *regs)
 	if (unlikely(!test_bit(UPROBE_COPY_INSN, &uprobe->flags)))
 		goto out;
 
+	/* Tracing handlers use ->utask to communicate with fetch methods */
+	if (!get_utask())
+		goto out;
+
 	handler_chain(uprobe, regs);
 	if (can_skip_sstep(uprobe, regs))
 		goto out;
-- 
1.5.5.1


