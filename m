Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428Ab3DWH5l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 03:57:41 -0400
Received: from co9ehsobe004.messaging.microsoft.com ([207.46.163.27]:49690
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755255Ab3DWH5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 03:57:38 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275bhz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1155h)
X-WSS-ID: 0MLP7F9-02-408-02
X-M-MSG: 
From: Jacob Shin <jacob.shin@amd.com>
To: Ingo Molnar <mingo@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        <x86@kernel.org>, Stephane Eranian <eranian@google.com>,
        Jiri Olsa <jolsa@redhat.com>, <linux-kernel@vger.kernel.org>,
        Jacob Shin <jacob.shin@amd.com>
Subject: [PATCH V2 1/4] perf: Add hardware breakpoint address mask
Date: Tue, 23 Apr 2013 02:57:02 -0500
Message-ID: <1366703825-19373-2-git-send-email-jacob.shin@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1366703825-19373-1-git-send-email-jacob.shin@amd.com>
References: <1366703825-19373-1-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some architectures (for us, AMD Family 16h) allow for "don't care" bit
mask to further qualify a hardware breakpoint address, in order to
trap on range of addresses. Update perf uapi to add bp_addr_mask field.

Signed-off-by: Jacob Shin <jacob.shin@amd.com>
---
 include/uapi/linux/perf_event.h |    5 ++++-
 kernel/events/hw_breakpoint.c   |    9 +++++++++
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index fb104e5..e22e1d1 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -286,7 +286,10 @@ struct perf_event_attr {
 		__u64		config1; /* extension of config */
 	};
 	union {
-		__u64		bp_len;
+		struct {
+			__u32		bp_len;
+			__u32		bp_addr_mask;
+		};
 		__u64		config2; /* extension of config1 */
 	};
 	__u64	branch_sample_type; /* enum perf_branch_sample_type */
diff --git a/kernel/events/hw_breakpoint.c b/kernel/events/hw_breakpoint.c
index a64f8ae..c454880 100644
--- a/kernel/events/hw_breakpoint.c
+++ b/kernel/events/hw_breakpoint.c
@@ -385,6 +385,11 @@ int dbg_release_bp_slot(struct perf_event *bp)
 	return 0;
 }
 
+__weak int arch_validate_hwbkpt_addr_mask(struct perf_event *bp)
+{
+	return bp->attr.bp_addr_mask == 0;
+}
+
 static int validate_hw_breakpoint(struct perf_event *bp)
 {
 	int ret;
@@ -393,6 +398,10 @@ static int validate_hw_breakpoint(struct perf_event *bp)
 	if (ret)
 		return ret;
 
+	ret = arch_validate_hwbkpt_addr_mask(bp);
+	if (ret)
+		return ret;
+
 	if (arch_check_bp_in_kernelspace(bp)) {
 		if (bp->attr.exclude_kernel)
 			return -EINVAL;
-- 
1.7.9.5


