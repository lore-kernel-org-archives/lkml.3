Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902AbaAMQ1j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:27:39 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53479 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754254AbaAMQEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:04:07 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jiang Liu <jiang.liu@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Brown <broonie@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 131/208] arm64: fix possible invalid FPSIMD initialization state
Date: Mon, 13 Jan 2014 15:59:32 +0000
Message-Id: <1389628849-1614-132-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiang Liu <jiang.liu@huawei.com>

commit 6db83cea1c975b9a102e17def7d2795814e1ae2b upstream.

If context switching happens during executing fpsimd_flush_thread(),
stale value in FPSIMD registers will be saved into current thread's
fpsimd_state by fpsimd_thread_switch(). That may cause invalid
initialization state for the new process, so disable preemption
when executing fpsimd_flush_thread().

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Jiang Liu <liuj97@gmail.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Mark Brown <broonie@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm64/kernel/fpsimd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index e8b8357..2fa308e 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -79,8 +79,10 @@ void fpsimd_thread_switch(struct task_struct *next)
 
 void fpsimd_flush_thread(void)
 {
+	preempt_disable();
 	memset(&current->thread.fpsimd_state, 0, sizeof(struct fpsimd_state));
 	fpsimd_load_state(&current->thread.fpsimd_state);
+	preempt_enable();
 }
 
 /*
-- 
1.8.3.2

