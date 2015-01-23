Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179AbbAWGnF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 01:43:05 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:37733 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120AbbAWGnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 01:43:02 -0500
Subject: [PATCH -tip/urgent 2/2] [BUGFIX]kprobes: makes kprobes/enabled
 works correctly for optimized kprobes.
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: tixy@linaro.org, Wang Nan <wangnan0@huawei.com>, linux@arm.linux.org.uk,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        lizefan@huawei.com, linux-arm-kernel@lists.infradead.org
Date: Fri, 23 Jan 2015 15:42:31 +0900
Message-ID: <20150123064230.30731.29584.stgit@localhost.localdomain>
In-Reply-To: <20150123064217.30731.49156.stgit@localhost.localdomain>
References: <20150123064217.30731.49156.stgit@localhost.localdomain>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wang Nan <wangnan0@huawei.com>

debugfs/kprobes/enabled doesn't work correctly on optimized kprobes.
Masami Hiramatsu has a test report on x86_64 platform:

https://lkml.org/lkml/2015/1/19/274

This patch forces it to unoptimize kprobe if kprobes_all_disarmed
is set. It also checks the flag in unregistering path for skipping
unneeded disarming process when kprobes globally disarmed.

Signed-off-by: Wang Nan <wangnan0@huawei.com>
Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 kernel/kprobes.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 9471710..fb995ef 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -869,7 +869,8 @@ static void __disarm_kprobe(struct kprobe *p, bool reopt)
 {
 	struct kprobe *_p;
 
-	unoptimize_kprobe(p, false);	/* Try to unoptimize */
+	/* Try to unoptimize */
+	unoptimize_kprobe(p, kprobes_all_disarmed);
 
 	if (!kprobe_queued(p)) {
 		arch_disarm_kprobe(p);
@@ -1571,7 +1572,13 @@ static struct kprobe *__disable_kprobe(struct kprobe *p)
 
 		/* Try to disarm and disable this/parent probe */
 		if (p == orig_p || aggr_kprobe_disabled(orig_p)) {
-			disarm_kprobe(orig_p, true);
+			/*
+			 * If kprobes_all_disarmed is set, orig_p
+			 * should have already been disarmed, so
+			 * skip unneed disarming process.
+			 */
+			if (!kprobes_all_disarmed)
+				disarm_kprobe(orig_p, true);
 			orig_p->flags |= KPROBE_FLAG_DISABLED;
 		}
 	}

