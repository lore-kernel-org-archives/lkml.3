Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179AbaBINsr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 08:48:47 -0500
Received: from mail.skyhub.de ([78.46.96.112]:47113 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751424AbaBINsf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 08:48:35 -0500
From: Borislav Petkov <bp@alien8.de>
To: X86 ML <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: [RFC PATCH 1/3] x86: Add another set of MSR accessor functions
Date: Sun,  9 Feb 2014 14:48:27 +0100
Message-Id: <1391953709-15400-2-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.5.2.192.g7794a68
In-Reply-To: <1391953709-15400-1-git-send-email-bp@alien8.de>
References: <1391953709-15400-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

We very often need to set or clear a bit in an MSR as a result of doing
some sort of a hardware configuration. Add generic versions of that
repeated functionality in order to save us a bunch of duplicated code in
the early CPU vendor detection/config code.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/include/asm/msr.h |   2 +
 arch/x86/lib/msr.c         | 107 ++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 108 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index e139b13f2a33..de36f22eb0b9 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -214,6 +214,8 @@ do {                                                            \
 
 struct msr *msrs_alloc(void);
 void msrs_free(struct msr *msrs);
+int msr_set_bit(u32 msr, u8 bit);
+int msr_clear_bit(u32 msr, u8 bit);
 
 #ifdef CONFIG_SMP
 int rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h);
diff --git a/arch/x86/lib/msr.c b/arch/x86/lib/msr.c
index 8f8eebdca7d4..ebab60c549ae 100644
--- a/arch/x86/lib/msr.c
+++ b/arch/x86/lib/msr.c
@@ -8,7 +8,7 @@ struct msr *msrs_alloc(void)
 
 	msrs = alloc_percpu(struct msr);
 	if (!msrs) {
-		pr_warning("%s: error allocating msrs\n", __func__);
+		pr_warn("%s: error allocating msrs\n", __func__);
 		return NULL;
 	}
 
@@ -21,3 +21,108 @@ void msrs_free(struct msr *msrs)
 	free_percpu(msrs);
 }
 EXPORT_SYMBOL(msrs_free);
+
+/**
+ * Read an MSR with error handling
+ *
+ * @msr: MSR to read
+ * @m: value to read into
+ *
+ * It returns read data only on success, otherwise it doesn't change the output
+ * argument @m.
+ *
+ */
+int msr_read(u32 msr, struct msr *m)
+{
+	int err;
+	u64 val;
+
+	val = native_read_msr_safe(msr, &err);
+	if (err)
+		pr_warn("%s: Error reading MSR 0x%08x\n", __func__, msr);
+	else
+		m->q = val;
+
+	return err;
+}
+
+/**
+ * Write an MSR with error handling
+ *
+ * @msr: MSR to write
+ * @m: value to write
+ */
+int msr_write(u32 msr, struct msr *m)
+{
+	int err;
+
+	err = native_write_msr_safe(msr, m->l, m->h);
+	if (err)
+		pr_warn("%s: Error writing MSR 0x%08x\n", __func__, msr);
+
+	return err;
+}
+
+static int __flip_bit(u32 msr, u8 bit, bool set)
+{
+	struct msr m;
+
+	if (bit > 63)
+		return -1;
+
+	if (msr_read(msr, &m))
+		return -1;
+
+	if (set) {
+		if ((BIT_64(bit) | m.q) == m.q)
+			return 0;
+
+		m.q |= BIT_64(bit);
+	} else {
+		if ((m.q & ~BIT_64(bit)) == m.q)
+			return 0;
+
+		m.q &= ~BIT_64(bit);
+	}
+
+	if (msr_write(msr, &m))
+		return -1;
+
+	return 1;
+}
+
+/**
+ * Set @bit in a MSR @msr.
+ *
+ * Retval:
+ * < 0: An error was encountered.
+ * = 0: Bit was already set.
+ * > 0: Hardware accepted the MSR write.
+ */
+int msr_set_bit(u32 msr, u8 bit)
+{
+	int err = __flip_bit(msr, bit, true);
+	if (err < 0)
+		pr_err("%s: Error setting bit %d in MSR 0x%08x.\n",
+			__func__, bit, msr);
+
+	return err;
+}
+
+/**
+ * Clear @bit in a MSR @msr.
+ *
+ * Retval:
+ * < 0: An error was encountered.
+ * = 0: Bit was already cleared.
+ * > 0: Hardware accepted the MSR write.
+ */
+int msr_clear_bit(u32 msr, u8 bit)
+{
+	int err = __flip_bit(msr, bit, false);
+	if (err < 0)
+		pr_err("%s: Error clearing bit %d in MSR 0x%08x.\n",
+			__func__, bit, msr);
+
+	return err;
+}
-- 
1.8.5.2.192.g7794a68

