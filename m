Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830Ab3EVJhN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 05:37:13 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:60546 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755732Ab3EVJhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 05:37:04 -0400
X-AuditID: 85900ec0-d4ccab900000151e-db-519c91bdf9e5
Subject: [PATCH 2/2] [BUGFIX] kprobes/mips: Fix to check double free of insn
 slot
To: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-mips@linux-mips.org, Victor Kamensky <kamensky@cisco.com>,
        David Daney <ddaney@caviumnetworks.com>,
        Ralf Baechle <ralf@linux-mips.org>, Maneesh Soni <manesoni@cisco.com>,
        yrl.pp-manager.tt@hitachi.com, systemtap@sourceware.org
Date: Wed, 22 May 2013 18:34:13 +0900
Message-ID: <20130522093413.9084.33395.stgit@mhiramat-M0-7522>
In-Reply-To: <20130522093409.9084.63554.stgit@mhiramat-M0-7522>
References: <20130522093409.9084.63554.stgit@mhiramat-M0-7522>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix to check double free of insn_slot at arch_remove_kprobe
as other arches do.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: David Daney <ddaney@caviumnetworks.com>
Cc: Maneesh Soni <manesoni@cisco.com>
Cc: Victor Kamensky <kamensky@cisco.com>
Cc: linux-mips@linux-mips.org
---
 arch/mips/kernel/kprobes.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/mips/kernel/kprobes.c b/arch/mips/kernel/kprobes.c
index 12bc4eb..1f8187a 100644
--- a/arch/mips/kernel/kprobes.c
+++ b/arch/mips/kernel/kprobes.c
@@ -207,7 +207,10 @@ void __kprobes arch_disarm_kprobe(struct kprobe *p)
 
 void __kprobes arch_remove_kprobe(struct kprobe *p)
 {
-	free_insn_slot(p->ainsn.insn, 0);
+	if (p->ainsn.insn) {
+		free_insn_slot(p->ainsn.insn, 0);
+		p->ainsn.insn = NULL;
+	}
 }
 
 static void save_previous_kprobe(struct kprobe_ctlblk *kcb)

