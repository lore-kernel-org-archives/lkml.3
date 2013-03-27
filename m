Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586Ab3C0Of1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 10:35:27 -0400
Received: from multi.imgtec.com ([194.200.65.239]:39972 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751643Ab3C0OfX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 10:35:23 -0400
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>,
        Paul Clothier <Paul.Clothier@imgtec.com>
Subject: [PATCH 1/3] metag: ptrace: Implement NT_METAG_TLS
Date: Wed, 27 Mar 2013 14:35:12 +0000
Message-ID: <1364394914-21257-2-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364394914-21257-1-git-send-email-james.hogan@imgtec.com>
References: <1364394914-21257-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_03_27_14_35_23
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Clothier <Paul.Clothier@imgtec.com>

Implement functionality to get the TLS pointer for the metag
architecture using regsets.

This provides multi-threaded debug support for GDB.

Signed-off-by: Paul Clothier <Paul.Clothier@imgtec.com>
---
 arch/metag/kernel/ptrace.c | 34 ++++++++++++++++++++++++++++++++++
 include/uapi/linux/elf.h   |  1 +
 2 files changed, 35 insertions(+)

diff --git a/arch/metag/kernel/ptrace.c b/arch/metag/kernel/ptrace.c
index 47a8828..7563628 100644
--- a/arch/metag/kernel/ptrace.c
+++ b/arch/metag/kernel/ptrace.c
@@ -288,10 +288,36 @@ static int metag_rp_state_set(struct task_struct *target,
 	return metag_rp_state_copyin(regs, pos, count, kbuf, ubuf);
 }
 
+static int metag_tls_get(struct task_struct *target,
+			const struct user_regset *regset,
+			unsigned int pos, unsigned int count,
+			void *kbuf, void __user *ubuf)
+{
+	void __user *tls = target->thread.tls_ptr;
+	return user_regset_copyout(&pos, &count, &kbuf, &ubuf, &tls, 0, -1);
+}
+
+static int metag_tls_set(struct task_struct *target,
+			const struct user_regset *regset,
+			unsigned int pos, unsigned int count,
+			const void *kbuf, const void __user *ubuf)
+{
+	int ret;
+	void __user *tls;
+
+	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf, &tls, 0, -1);
+	if (ret)
+		return ret;
+
+	target->thread.tls_ptr = tls;
+	return ret;
+}
+
 enum metag_regset {
 	REGSET_GENERAL,
 	REGSET_CBUF,
 	REGSET_READPIPE,
+	REGSET_TLS,
 };
 
 static const struct user_regset metag_regsets[] = {
@@ -319,6 +345,14 @@ static const struct user_regset metag_regsets[] = {
 		.get = metag_rp_state_get,
 		.set = metag_rp_state_set,
 	},
+	[REGSET_TLS] = {
+		.core_note_type = NT_METAG_TLS,
+		.n = 1,
+		.size = sizeof(void *),
+		.align = sizeof(void *),
+		.get = metag_tls_get,
+		.set = metag_tls_set,
+	},
 };
 
 static const struct user_regset_view user_metag_view = {
diff --git a/include/uapi/linux/elf.h b/include/uapi/linux/elf.h
index 8072d35..ef6103b 100644
--- a/include/uapi/linux/elf.h
+++ b/include/uapi/linux/elf.h
@@ -397,6 +397,7 @@ typedef struct elf64_shdr {
 #define NT_ARM_HW_WATCH	0x403		/* ARM hardware watchpoint registers */
 #define NT_METAG_CBUF	0x500		/* Metag catch buffer registers */
 #define NT_METAG_RPIPE	0x501		/* Metag read pipeline state */
+#define NT_METAG_TLS	0x502		/* Metag TLS pointer */
 
 
 /* Note header in a PT_NOTE section */
-- 
1.8.1.2


