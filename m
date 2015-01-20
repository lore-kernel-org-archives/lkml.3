Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751811AbbATC63 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 21:58:29 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:65005 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410AbbATC62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 21:58:28 -0500
From: Wang Nan <wangnan0@huawei.com>
To: <masami.hiramatsu.pt@hitachi.com>
CC: <tixy@linaro.org>, <linux@arm.linux.org.uk>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <lizefan@huawei.com>
Subject: [PATCH] kprobes: bugfix: makes kprobes/enabled works correctly for optimized kprobes.
Date: Tue, 20 Jan 2015 10:51:51 +0800
Message-ID: <1421722311-30455-1-git-send-email-wangnan0@huawei.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <54BCFC6E.1080007@hitachi.com>
References: <54BCFC6E.1080007@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

debugfs/kprobes/enabled doesn't work correctly on optimized kprobes.
Masami Hiramatsu has a test report on x86_64 platform:

https://lkml.org/lkml/2015/1/19/274

This patch forces it to unoptimize kprobe if kprobes_all_disarmed
is set. It also checks the flag in unregistering path for skipping
unneeded disarming process when kprobes globally disarmed.

Signed-off-by: Wang Nan <wangnan0@huawei.com>
---
 kernel/kprobes.c | 11 +++++++++--
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
-- 
1.8.4

