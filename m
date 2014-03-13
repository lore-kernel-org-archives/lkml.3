Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754985AbaCMXSu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 19:18:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45319 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754565AbaCMXSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 19:18:48 -0400
Date: Thu, 13 Mar 2014 16:18:31 -0700
From: tip-bot for Borislav Petkov <tipbot@zytor.com>
Message-ID: <tip-22085a66c2fab6cf9b9393c056a3600a6b4735de@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, bp@suse.de, hpa@linux.intel.com
In-Reply-To: <1394384725-10796-2-git-send-email-bp@alien8.de>
References: <1394384725-10796-2-git-send-email-bp@alien8.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86: Add another set of MSR accessor functions
Git-Commit-ID: 22085a66c2fab6cf9b9393c056a3600a6b4735de
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  22085a66c2fab6cf9b9393c056a3600a6b4735de
Gitweb:     http://git.kernel.org/tip/22085a66c2fab6cf9b9393c056a3600a6b4735de
Author:     Borislav Petkov <bp@suse.de>
AuthorDate: Sun, 9 Mar 2014 18:05:23 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 13 Mar 2014 15:34:45 -0700

x86: Add another set of MSR accessor functions

We very often need to set or clear a bit in an MSR as a result of doing
some sort of a hardware configuration. Add generic versions of that
repeated functionality in order to save us a bunch of duplicated code in
the early CPU vendor detection/config code.

Signed-off-by: Borislav Petkov <bp@suse.de>
Link: http://lkml.kernel.org/r/1394384725-10796-2-git-send-email-bp@alien8.de
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/msr.h |  2 ++
 arch/x86/lib/msr.c         | 89 +++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 90 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index e139b13..de36f22 100644
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
index 8f8eebd..db9db44 100644
--- a/arch/x86/lib/msr.c
+++ b/arch/x86/lib/msr.c
@@ -8,7 +8,7 @@ struct msr *msrs_alloc(void)
 
 	msrs = alloc_percpu(struct msr);
 	if (!msrs) {
-		pr_warning("%s: error allocating msrs\n", __func__);
+		pr_warn("%s: error allocating msrs\n", __func__);
 		return NULL;
 	}
 
@@ -21,3 +21,90 @@ void msrs_free(struct msr *msrs)
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
+	err = rdmsrl_safe(msr, &val);
+	if (!err)
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
+	return wrmsrl_safe(msr, m->q);
+}
+
+static inline int __flip_bit(u32 msr, u8 bit, bool set)
+{
+	struct msr m, m1;
+	int err = -EINVAL;
+
+	if (bit > 63)
+		return err;
+
+	err = msr_read(msr, &m);
+	if (err)
+		return err;
+
+	m1 = m;
+	if (set)
+		m1.q |=  BIT_64(bit);
+	else
+		m1.q &= ~BIT_64(bit);
+
+	if (m1.q == m.q)
+		return 0;
+
+	err = msr_write(msr, &m);
+	if (err)
+		return err;
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
+	return __flip_bit(msr, bit, true);
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
+	return __flip_bit(msr, bit, false);
+}
