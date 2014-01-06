Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757261AbaAFXC4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 18:02:56 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48534 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933208AbaAFWl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:41:59 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jiang Liu <jiang.liu@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 3.10 122/129] arm64: fix possible invalid FPSIMD initialization state
Date: Mon,  6 Jan 2014 14:39:11 -0800
Message-Id: <20140106223903.083057736@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223859.589799655@linuxfoundation.org>
References: <20140106223859.589799655@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/kernel/fpsimd.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -79,8 +79,10 @@ void fpsimd_thread_switch(struct task_st
 
 void fpsimd_flush_thread(void)
 {
+	preempt_disable();
 	memset(&current->thread.fpsimd_state, 0, sizeof(struct fpsimd_state));
 	fpsimd_load_state(&current->thread.fpsimd_state);
+	preempt_enable();
 }
 
 /*


