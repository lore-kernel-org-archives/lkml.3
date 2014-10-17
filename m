Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003AbaJQUBd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 16:01:33 -0400
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:31968 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753826AbaJQUBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 16:01:32 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhIOACB0QVRXQz/c/2dsb2JhbABbgw6BK7hjAQEBAQEBBQFzmi2BFRcBfYRfI4EaN4hDAb9Gjl0shiKKKx2ENQWdWZYlgUcBNiCBWzsvgksBAQE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org
Subject: [PATCH 1/4 linux-next] x86, msr: define msr chunksize
Date: Fri, 17 Oct 2014 22:01:29 +0200
Message-Id: <1413576089-27014-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

define MSR_CHUNK_SIZE instead of hard-coded value (8).

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 arch/x86/include/asm/msr.h |  2 ++
 arch/x86/kernel/msr.c      | 18 +++++++++---------
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index de36f22..f28a5a2 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -39,6 +39,8 @@ static inline unsigned long long native_read_tscp(unsigned int *aux)
 	return low | ((u64)high << 32);
 }
 
+#define MSR_CHUNK_SIZE 8
+
 /*
  * both i386 and x86_64 returns 64-bit value in edx:eax, but gcc's "A"
  * constraint has different meanings. For i386, "A" means exactly
diff --git a/arch/x86/kernel/msr.c b/arch/x86/kernel/msr.c
index c9603ac..f1f3ed0 100644
--- a/arch/x86/kernel/msr.c
+++ b/arch/x86/kernel/msr.c
@@ -75,19 +75,19 @@ static ssize_t msr_read(struct file *file, char __user *buf,
 	int err = 0;
 	ssize_t bytes = 0;
 
-	if (count % 8)
+	if (count % MSR_CHUNK_SIZE)
 		return -EINVAL;	/* Invalid chunk size */
 
-	for (; count; count -= 8) {
+	for (; count; count -= MSR_CHUNK_SIZE) {
 		err = rdmsr_safe_on_cpu(cpu, reg, &data[0], &data[1]);
 		if (err)
 			break;
-		if (copy_to_user(tmp, &data, 8)) {
+		if (copy_to_user(tmp, &data, MSR_CHUNK_SIZE)) {
 			err = -EFAULT;
 			break;
 		}
 		tmp += 2;
-		bytes += 8;
+		bytes += MSR_CHUNK_SIZE;
 	}
 
 	return bytes ? bytes : err;
@@ -103,11 +103,11 @@ static ssize_t msr_write(struct file *file, const char __user *buf,
 	int err = 0;
 	ssize_t bytes = 0;
 
-	if (count % 8)
+	if (count % MSR_CHUNK_SIZE)
 		return -EINVAL;	/* Invalid chunk size */
 
-	for (; count; count -= 8) {
-		if (copy_from_user(&data, tmp, 8)) {
+	for (; count; count -= MSR_CHUNK_SIZE) {
+		if (copy_from_user(&data, tmp, MSR_CHUNK_SIZE)) {
 			err = -EFAULT;
 			break;
 		}
@@ -115,7 +115,7 @@ static ssize_t msr_write(struct file *file, const char __user *buf,
 		if (err)
 			break;
 		tmp += 2;
-		bytes += 8;
+		bytes += MSR_CHUNK_SIZE;
 	}
 
 	return bytes ? bytes : err;
@@ -124,7 +124,7 @@ static ssize_t msr_write(struct file *file, const char __user *buf,
 static long msr_ioctl(struct file *file, unsigned int ioc, unsigned long arg)
 {
 	u32 __user *uregs = (u32 __user *)arg;
-	u32 regs[8];
+	u32 regs[MSR_CHUNK_SIZE];
 	int cpu = iminor(file_inode(file));
 	int err;
 
-- 
1.9.3

