Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933338AbaBEUql (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:46:41 -0500
Received: from mail.windriver.com ([147.11.1.11]:55057 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754862AbaBEUGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:06:19 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 114/213] xen/bootup: allow {read|write}_cr8 pvops call.
Date: Wed, 5 Feb 2014 15:01:09 -0500
Message-ID: <1391630568-49251-115-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 1a7bbda5b1ab0e02622761305a32dc38735b90b2 upstream.

We actually do not do anything about it. Just return a default
value of zero and if the kernel tries to write anything but 0
we BUG_ON.

This fixes the case when an user tries to suspend the machine
and it blows up in save_processor_state b/c 'read_cr8' is set
to NULL and we get:

kernel BUG at /home/konrad/ssd/linux/arch/x86/include/asm/paravirt.h:100!
invalid opcode: 0000 [#1] SMP
Pid: 2687, comm: init.late Tainted: G           O 3.6.0upstream-00002-gac264ac-dirty #4 Bochs Bochs
RIP: e030:[<ffffffff814d5f42>]  [<ffffffff814d5f42>] save_processor_state+0x212/0x270

.. snip..
Call Trace:
 [<ffffffff810733bf>] do_suspend_lowlevel+0xf/0xac
 [<ffffffff8107330c>] ? x86_acpi_suspend_lowlevel+0x10c/0x150
 [<ffffffff81342ee2>] acpi_suspend_enter+0x57/0xd5

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/x86/xen/enlighten.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 7fa0dc02b939..1b7d744f6f30 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -779,7 +779,16 @@ static void xen_write_cr4(unsigned long cr4)
 
 	native_write_cr4(cr4);
 }
-
+#ifdef CONFIG_X86_64
+static inline unsigned long xen_read_cr8(void)
+{
+	return 0;
+}
+static inline void xen_write_cr8(unsigned long val)
+{
+	BUG_ON(val);
+}
+#endif
 static int xen_write_msr_safe(unsigned int msr, unsigned low, unsigned high)
 {
 	int ret;
@@ -945,6 +954,11 @@ static const struct pv_cpu_ops xen_cpu_ops __initdata = {
 	.read_cr4_safe = native_read_cr4_safe,
 	.write_cr4 = xen_write_cr4,
 
+#ifdef CONFIG_X86_64
+	.read_cr8 = xen_read_cr8,
+	.write_cr8 = xen_write_cr8,
+#endif
+
 	.wbinvd = native_wbinvd,
 
 	.read_msr = native_read_msr_safe,
-- 
1.8.5.2

