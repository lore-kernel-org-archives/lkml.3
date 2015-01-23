Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088AbbAWGm6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 01:42:58 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:35607 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120AbbAWGmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 01:42:55 -0500
Subject: [PATCH -tip/urgent 1/2] [BUGFIX]kprobes: set kprobes_all_disarmed
 earlier to enable re-optimization.
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: tixy@linaro.org, Wang Nan <wangnan0@huawei.com>, linux@arm.linux.org.uk,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        lizefan@huawei.com, linux-arm-kernel@lists.infradead.org
Date: Fri, 23 Jan 2015 15:42:24 +0900
Message-ID: <20150123064224.30731.30127.stgit@localhost.localdomain>
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

In original code, the probed instruction doesn't get optimized after

echo 0 > /sys/kernel/debug/kprobes/enabled
echo 1 > /sys/kernel/debug/kprobes/enabled

This is because original code checks kprobes_all_disarmed in
optimize_kprobe(), but this flag is turned off after calling that
function. Therefore, optimize_kprobe() will see
kprobes_all_disarmed == true and doesn't do the optimization.

This patch simply turns off kprobes_all_disarmed earlier to enable
optimization.

Signed-off-by: Wang Nan <wangnan0@huawei.com>
Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 kernel/kprobes.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 06f5830..9471710 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -2320,6 +2320,12 @@ static void arm_all_kprobes(void)
 	if (!kprobes_all_disarmed)
 		goto already_enabled;
 
+	/*
+	 * optimize_kprobe() called by arm_kprobe() checks
+	 * kprobes_all_disarmed, so set kprobes_all_disarmed before
+	 * arm_kprobe.
+	 */
+	kprobes_all_disarmed = false;
 	/* Arming kprobes doesn't optimize kprobe itself */
 	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
 		head = &kprobe_table[i];
@@ -2328,7 +2334,6 @@ static void arm_all_kprobes(void)
 				arm_kprobe(p);
 	}
 
-	kprobes_all_disarmed = false;
 	printk(KERN_INFO "Kprobes globally enabled\n");
 
 already_enabled:

