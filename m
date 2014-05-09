Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756528AbaEIJNv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 05:13:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40888 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753897AbaEIJNt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 05:13:49 -0400
From: Petr Mladek <pmladek@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Dave Anderson <anderson@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Kay Sievers <kay@vrfy.org>, Jiri Kosina <jkosina@suse.cz>,
        Michal Hocko <mhocko@suse.cz>, Jan Kara <jack@suse.cz>,
        linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.cz>
Subject: [RFC PATCH 05/11] printk: allow to modify NMI log buffer size using boot parameter
Date: Fri,  9 May 2014 11:10:59 +0200
Message-Id: <1399626665-29817-6-git-send-email-pmladek@suse.cz>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1399626665-29817-1-git-send-email-pmladek@suse.cz>
References: <1399626665-29817-1-git-send-email-pmladek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Having NMI log buffer of the same size as the main log buffer might
be considered as a waste of memory. Especially when the main buffer
is increased to a big value. So create a separate kernel parameters
to set nmi_log_buf_len.

Some users might want to avoid the buffer entirely. It can be done
by the zero value. In this case, the printk will stay safe in the
NMI context but there will be higher chance that some message could
get lost.

The maximum size is tested when the NMI log buffer is allocated. Note
that even the default size might be too big if there is not enough
bytes to store the index.

Signed-off-by: Petr Mladek <pmladek@suse.cz>
---
 Documentation/kernel-parameters.txt | 19 +++++++++++++++++--
 kernel/printk/printk.c              | 22 +++++++++++++++++-----
 2 files changed, 34 insertions(+), 7 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 296e6da5ce6c..5e90eab4d696 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -211,8 +211,9 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			    acpi.debug_layer=0x2 acpi.debug_level=0xffffffff
 
 			Some values produce so much output that the system is
-			unusable.  The "log_buf_len" parameter may be useful
-			if you need to capture more output.
+			unusable.  The "log_buf_len" and "nmi_log_buf_len"
+			parameters may be useful if you need to capture more
+			output.
 
 	acpi_irq_balance [HW,ACPI]
 			ACPI will balance active IRQs
@@ -2052,6 +2053,20 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			when a NMI is triggered.
 			Format: [state][,regs][,debounce][,die]
 
+	nmi_log_buf_len=n[KMG]	Sets the size of a helper ring buffer for
+			printk messages in NMI context. It is used only as
+			fallback when the lock for the main ring buffer is
+			already taken. The content is merged into the main
+			buffer when possible.
+
+			The size is in bytes and must be a power of two. The
+			default size is the same as for the main printk ring
+			buffer.
+
+			The size 0 can be used to disable the extra buffer
+			entirely. It saves space but there is a higher risk
+			that some messages will get lost.
+
 	nmi_watchdog=	[KNL,BUGS=X86] Debugging features for SMP kernels
 			Format: [panic,][nopanic,][num]
 			Valid num: 0
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index e8d0df2d3e01..7d0d5c714f71 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -1013,6 +1013,18 @@ static int __init log_buf_len_setup(char *str)
 }
 early_param("log_buf_len", log_buf_len_setup);
 
+/* NMI log buffer can be completely disabled by setting 0 value */
+static int __init nmi_log_buf_len_setup(char *str)
+{
+	nmi_log.buf_len = memparse(str, &str);
+
+	if (nmi_log.buf_len)
+		nmi_log.buf_len = roundup_pow_of_two(nmi_log.buf_len);
+
+	return 0;
+}
+early_param("nmi_log_buf_len", nmi_log_buf_len_setup);
+
 char * __init alloc_log_buf(int early, unsigned len)
 {
 	if (early)
@@ -1028,13 +1040,13 @@ void __init setup_log_buf(int early)
 	int free;
 
 	if (!nmi_log.buf) {
-		/* use the same size that will be used for normal buffer */
-		if (new_log_buf_len > nmi_log.buf_len)
-			nmi_log.buf_len = new_log_buf_len;
 		if (nmi_log.buf_len > NMI_MAX_LEN)
 			nmi_log.buf_len = NMI_MAX_LEN;
-		nmi_log.buf = alloc_log_buf(early, nmi_log.buf_len);
-		if (!nmi_log.buf)
+		/* zero length means that the feature is disabled */
+		if (nmi_log.buf_len)
+			nmi_log.buf = alloc_log_buf(early, nmi_log.buf_len);
+
+		if (!nmi_log.buf && nmi_log.buf_len)
 			pr_err("%d bytes not available for NMI ring buffer\n",
 			       nmi_log.buf_len);
 		else
-- 
1.8.4

