Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751205Ab3GQBTC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 21:19:02 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33328 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122Ab3GQBS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 21:18:58 -0400
Date: Tue, 16 Jul 2013 18:18:40 -0700
From: tip-bot for Jiri Kosina <tipbot@zytor.com>
Message-ID: <tip-51b2c07b22261f19188d9a9071943d60a067481c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jkosina@suse.cz, masami.hiramatsu.pt@hitachi.com, rostedt@goodmis.org,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jkosina@suse.cz, masami.hiramatsu.pt@hitachi.com, rostedt@goodmis.org,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <alpine.LNX.2.00.1307121120250.29788@pobox.suse.cz>
References: <alpine.LNX.2.00.1307121120250.29788@pobox.suse.cz>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/jumplabel] x86: Make jump_label use int3-based patching
Git-Commit-ID: 51b2c07b22261f19188d9a9071943d60a067481c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 16 Jul 2013 18:18:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  51b2c07b22261f19188d9a9071943d60a067481c
Gitweb:     http://git.kernel.org/tip/51b2c07b22261f19188d9a9071943d60a067481c
Author:     Jiri Kosina <jkosina@suse.cz>
AuthorDate: Fri, 12 Jul 2013 11:22:09 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 16 Jul 2013 17:55:37 -0700

x86: Make jump_label use int3-based patching

Make jump labels use text_poke_bp() for text patching instead of
text_poke_smp(), avoiding the need for stop_machine().

Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Link: http://lkml.kernel.org/r/alpine.LNX.2.00.1307121120250.29788@pobox.suse.cz
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/jump_label.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/jump_label.c b/arch/x86/kernel/jump_label.c
index 2889b3d..460f5d9 100644
--- a/arch/x86/kernel/jump_label.c
+++ b/arch/x86/kernel/jump_label.c
@@ -37,7 +37,19 @@ static void __jump_label_transform(struct jump_entry *entry,
 	} else
 		memcpy(&code, ideal_nops[NOP_ATOMIC5], JUMP_LABEL_NOP_SIZE);
 
-	(*poker)((void *)entry->code, &code, JUMP_LABEL_NOP_SIZE);
+	/*
+	 * Make text_poke_bp() a default fallback poker.
+	 *
+	 * At the time the change is being done, just ignore whether we
+	 * are doing nop -> jump or jump -> nop transition, and assume
+	 * always nop being the 'currently valid' instruction
+	 *
+	 */
+	if (poker)
+		(*poker)((void *)entry->code, &code, JUMP_LABEL_NOP_SIZE);
+	else
+		text_poke_bp((void *)entry->code, &code, JUMP_LABEL_NOP_SIZE,
+			     (void *)entry->code + JUMP_LABEL_NOP_SIZE);
 }
 
 void arch_jump_label_transform(struct jump_entry *entry,
@@ -45,7 +57,7 @@ void arch_jump_label_transform(struct jump_entry *entry,
 {
 	get_online_cpus();
 	mutex_lock(&text_mutex);
-	__jump_label_transform(entry, type, text_poke_smp);
+	__jump_label_transform(entry, type, NULL);
 	mutex_unlock(&text_mutex);
 	put_online_cpus();
 }
