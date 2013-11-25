Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004Ab3KYG7Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 01:59:24 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:42142 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab3KYG7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 01:59:23 -0500
X-AuditID: 9c930197-b7caaae000001cef-91-5292f54882dd
From: Namhyung Kim <namhyung@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei\(Jovi\)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCHSET 00/13] tracing/uprobes: Add support for more fetch methods (v6)
References: <20131104155131.GD4440@redhat.com>
	<20131104162229.GA8921@redhat.com> <20131104184741.GA15945@redhat.com>
	<87sivbz65t.fsf@sejong.aot.lge.com> <20131105174535.GA6385@redhat.com>
	<20131105192401.GA772@redhat.com> <87vc05x5zf.fsf@sejong.aot.lge.com>
	<20131106173754.GA11299@redhat.com>
	<87a9hgwqal.fsf@sejong.aot.lge.com> <527DA997.4080306@hitachi.com>
	<20131109152313.GA14630@redhat.com>
	<87siv2uk1q.fsf@sejong.aot.lge.com>
Date: Mon, 25 Nov 2013 15:59:20 +0900
In-Reply-To: <87siv2uk1q.fsf@sejong.aot.lge.com> (Namhyung Kim's message of
	"Tue, 12 Nov 2013 17:00:01 +0900")
Message-ID: <87siulrmpj.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oleg,

On Tue, 12 Nov 2013 17:00:01 +0900, Namhyung Kim wrote:
> For @+addr syntax: user-space uses relative symbol address from a loaded
>                    base address and kernel calculates the base address
>                    using "current->utask->vaddr - tu->offset".

I tried this approach and realized that current->utask is not set or has
an invalid vaddr when handler_chain() is called.  So I had to apply
following patch and it seems to work well for me.  Could you confirm it?

Thanks,
Namhyung


diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index ad8e1bdca70e..e63748d3520e 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1456,7 +1456,7 @@ static void prepare_uretprobe(struct uprobe *uprobe, struct pt_regs *regs)
 
 /* Prepare to single-step probed instruction out of line. */
 static int
-pre_ssout(struct uprobe *uprobe, struct pt_regs *regs, unsigned long bp_vaddr)
+pre_ssout(struct uprobe *uprobe, struct pt_regs *regs)
 {
 	struct uprobe_task *utask;
 	unsigned long xol_vaddr;
@@ -1471,7 +1471,6 @@ pre_ssout(struct uprobe *uprobe, struct pt_regs *regs, unsigned long bp_vaddr)
 		return -ENOMEM;
 
 	utask->xol_vaddr = xol_vaddr;
-	utask->vaddr = bp_vaddr;
 
 	err = arch_uprobe_pre_xol(&uprobe->arch, regs);
 	if (unlikely(err)) {
@@ -1701,6 +1700,7 @@ static bool handle_trampoline(struct pt_regs *regs)
 static void handle_swbp(struct pt_regs *regs)
 {
 	struct uprobe *uprobe;
+	struct uprobe_task *utask;
 	unsigned long bp_vaddr;
 	int uninitialized_var(is_swbp);
 
@@ -1744,11 +1744,17 @@ static void handle_swbp(struct pt_regs *regs)
 	if (unlikely(!test_bit(UPROBE_COPY_INSN, &uprobe->flags)))
 		goto out;
 
+	utask = get_utask();
+	if (!utask)
+		goto out;
+
+	utask->vaddr = bp_vaddr;
+
 	handler_chain(uprobe, regs);
 	if (can_skip_sstep(uprobe, regs))
 		goto out;
 
-	if (!pre_ssout(uprobe, regs, bp_vaddr))
+	if (!pre_ssout(uprobe, regs))
 		return;
 
 	/* can_skip_sstep() succeeded, or restart if can't singlestep */
