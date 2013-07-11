Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641Ab3GKU01 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 16:26:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32874 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755174Ab3GKU0Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 16:26:24 -0400
Date: Thu, 11 Jul 2013 22:26:20 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@akamai.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Borislav Petkov <bp@alien8.de>,
        Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2 v3] x86: make jump_label use int3-based patching
In-Reply-To: <alpine.LNX.2.00.1307102213140.25858@pobox.suse.cz>
Message-ID: <alpine.LNX.2.00.1307112225060.29788@pobox.suse.cz>
References: <alpine.LNX.2.00.1307102213140.25858@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make jump labels use text_poke_bp() for text patching instead of 
text_poke_smp(), avoiding the need for stop_machine().

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
Changes:

- unchanged since v1, patch 1/2 is the one being updated

 arch/x86/kernel/jump_label.c |   16 ++++++++++++++--
 1 files changed, 14 insertions(+), 2 deletions(-)

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
-- 
1.7.3.1

