Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395AbbAEMiR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 07:38:17 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:44022 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753135AbbAEMiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 07:38:16 -0500
From: Wang Nan <wangnan0@huawei.com>
To: <masami.hiramatsu.pt@hitachi.com>, <tixy@linaro.org>,
        <linux@arm.linux.org.uk>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <lizefan@huawei.com>
Subject: [PATCH] kprobes: bugfix: force unoptimize when disable kprobes.
Date: Mon, 5 Jan 2015 20:32:20 +0800
Message-ID: <1420461140-27153-1-git-send-email-wangnan0@huawei.com>
X-Mailer: git-send-email 1.8.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020204.50F2CDBD.0090,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: c5b0f7242290f3cd7460b973d5ddb2d9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Original code failed to disarm the probed instruction after

echo 0 > /sys/kernel/debug/kprobes/enabled

if OPTPROBE is enabled.

This is caused by a piece of logically inconsistent code:

	unoptimize_kprobe(p, false);
	if (!kprobe_queued(p)) {
		...
	}

unoptimize_kprobe() with 'force' == false queues p onto
unoptimizing_list, so following kprobe_queued() check always fail unless
another core schedules optimizer and does the unoptimization very soon.
This logic causes arch_disarm_kprobe() failed to get execute, lefts a
breakpoint at the probed address, instead of restoring it.

This patch uses force unoptimize instead.

Signed-off-by: Wang Nan <wangnan0@huawei.com>
---
 kernel/kprobes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index b185464..9fbe0c3 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -869,7 +869,7 @@ static void __disarm_kprobe(struct kprobe *p, bool reopt)
 {
 	struct kprobe *_p;
 
-	unoptimize_kprobe(p, false);	/* Try to unoptimize */
+	unoptimize_kprobe(p, true);	/* Try to unoptimize */
 
 	if (!kprobe_queued(p)) {
 		arch_disarm_kprobe(p);
-- 
1.8.4

