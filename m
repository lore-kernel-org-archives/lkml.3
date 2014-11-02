Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473AbaKBSQz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 13:16:55 -0500
Received: from relay2.sgi.com ([192.48.180.65]:42203 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751155AbaKBSQv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 13:16:51 -0500
From: James Custer <jcuster@sgi.com>
To: x86@kernel.org
Cc: James Custer <jcuster@sgi.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H . Peter Anvin" <hpa@zytor.com>, Russ Anderson <rja@sgi.com>
Subject: [PATCH 2/2] x86: UV BAU Avoid NULL pointer reference in ptc_seq_show
Date: Sun,  2 Nov 2014 12:16:39 -0600
Message-Id: <1414952199-185319-2-git-send-email-jcuster@sgi.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1414952199-185319-1-git-send-email-jcuster@sgi.com>
References: <1414952199-185319-1-git-send-email-jcuster@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In init_per_cpu(), when get_cpu_topology() fails, init_per_cpu_tunables()
is not called afterwards. This means that bau_control->statp is NULL.
If a user then reads /proc/sgi_uv/ptc_statistics ptc_seq_show() references
a NULL pointer. Therefore, since uv_bau_init calls set_bau_off when
init_per_cpu() fails, we add code that detects when the bau is off in
ptc_seq_show() to avoid referencing a NULL pointer.

Signed-off-by: James Custer <jcuster@sgi.com>
---
 arch/x86/platform/uv/tlb_uv.c | 4 ++++
 1 file changed, 4 insertions(+)

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
1.7.12.4

