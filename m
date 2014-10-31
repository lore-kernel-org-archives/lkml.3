Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760615AbaJaVuU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 17:50:20 -0400
Received: from relay1.sgi.com ([192.48.180.66]:49245 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760555AbaJaVuQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 17:50:16 -0400
From: James Custer <jcuster@sgi.com>
To: x86@kernel.org
Cc: James Custer <jcuster@sgi.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H . Peter Anvin" <hpa@zytor.com>, Russ Anderson <rja@sgi.com>
Subject: [PATCH] x86: UV BAU Increase maximum CPUs per socket/hub
Date: Fri, 31 Oct 2014 16:49:40 -0500
Message-Id: <1414792180-102802-1-git-send-email-jcuster@sgi.com>
X-Mailer: git-send-email 1.7.12.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have encountered hardware with 18 cores/socket that gives 36 CPUs/socket
with hyperthreading enabled. This exceeds the current MAX_CPUS_PER_SOCKET
causing a failure in get_cpu_topology. Increase MAX_CPUS_PER_SOCKET to 64
and MAX_CPUS_PER_UVHUB to 128.

Additionally, this exposed another bug. When get_cpu_topology fails, we
need to make sure that we do not use bau_control->statp (e.g. when a
user reads /proc/sgi_uv/ptc_statistics causing ptc_seq_show to be
invoked). In uv_bau_init we call set_bau_off() when
init_per_cpu()->get_cpu_topology() fails -- therefore, to avoid
referencing a NULL pointer we add code that detects when the bau is off
and print out the bau is disabled.

Signed-off-by: James Custer <jcuster@sgi.com>
---
 arch/x86/include/asm/uv/uv_bau.h | 4 ++--
 arch/x86/platform/uv/tlb_uv.c    | 4 ++++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/uv/uv_bau.h b/arch/x86/include/asm/uv/uv_bau.h
index 2d60a78..fc808b8 100644
--- a/arch/x86/include/asm/uv/uv_bau.h
+++ b/arch/x86/include/asm/uv/uv_bau.h
@@ -33,8 +33,8 @@
  * Each of the descriptors is 64 bytes in size (8*64 = 512 bytes in a set).
  */
 
-#define MAX_CPUS_PER_UVHUB		64
-#define MAX_CPUS_PER_SOCKET		32
+#define MAX_CPUS_PER_UVHUB		128
+#define MAX_CPUS_PER_SOCKET		64
 #define ADP_SZ				64 /* hardware-provided max. */
 #define UV_CPUS_PER_AS			32 /* hardware-provided max. */
 #define ITEMS_PER_DESC			8
diff --git a/arch/x86/platform/uv/tlb_uv.c b/arch/x86/platform/uv/tlb_uv.c
index 3968d67..570b1b1 100644
--- a/arch/x86/platform/uv/tlb_uv.c
+++ b/arch/x86/platform/uv/tlb_uv.c
@@ -1384,6 +1384,10 @@ static int ptc_seq_show(struct seq_file *file, void *data)
 	}
 	if (cpu < num_possible_cpus() && cpu_online(cpu)) {
 		bcp = &per_cpu(bau_control, cpu);
+		if (bcp->nobau) {
+			seq_printf(file, "cpu %d bau disabled\n", cpu);
+			return 0;
+		}
 		stat = bcp->statp;
 		/* source side statistics */
 		seq_printf(file,
-- 
1.8.2.1

