Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab3FDXTL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 19:19:11 -0400
Received: from 1wt.eu ([62.212.114.60]:35324 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752585Ab3FDWlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:41:51 -0400
Message-Id: <20130604172132.548436309@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:22:24 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 054/184] xen/bootup: allow {read|write}_cr8 pvops call.
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 arch/x86/xen/enlighten.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index f1539ff..126a093 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -776,7 +776,16 @@ static void xen_write_cr4(unsigned long cr4)
 
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
@@ -942,6 +951,11 @@ static const struct pv_cpu_ops xen_cpu_ops __initdata = {
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
1.7.12.2.21.g234cd45.dirty



