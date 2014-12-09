Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751632AbaLIRfv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 12:35:51 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:44320 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbaLIRfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 12:35:07 -0500
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        acme@kernel.org, mpe@ellerman.id.au
Cc: ananth@in.ibm.com
Subject: [RFC PATCH 7/8] perf probe powerpc: Use DWARF info only if necessary
Date: Tue,  9 Dec 2014 23:04:05 +0530
Message-Id: <50dd0fedb50e3a56ff8f25c44098db3e2a2d6374.1418146300.git.naveen.n.rao@linux.vnet.ibm.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <cover.1418146300.git.naveen.n.rao@linux.vnet.ibm.com>
References: <cover.1418146300.git.naveen.n.rao@linux.vnet.ibm.com>
In-Reply-To: <cover.1418146300.git.naveen.n.rao@linux.vnet.ibm.com>
References: <cover.1418146300.git.naveen.n.rao@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120917-0033-0000-0000-000000B44AA8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use symbol table lookups by default if DWARF is not necessary, since
powerpc ABIv2 encodes local entry points in the symbol table and the
function entry address in DWARF may not be appropriate for kprobes,
as described here:
https://sourceware.org/bugzilla/show_bug.cgi?id=17638

Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
---
 tools/perf/util/probe-event.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 174c22e..adcdbd2 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -2382,6 +2382,14 @@ static int convert_to_probe_trace_events(struct perf_probe_event *pev,
 		}
 	}
 
+#if defined(__powerpc64__) && defined(_CALL_ELF) && _CALL_ELF == 2
+	if (!perf_probe_event_need_dwarf(pev)) {
+		ret = find_probe_trace_events_from_map(pev, tevs, max_tevs, target);
+		if (ret > 0)
+			return ret;	/* Found in symbol table */
+	}
+#endif
+
 	/* Convert perf_probe_event with debuginfo */
 	ret = try_to_find_probe_trace_events(pev, tevs, max_tevs, target);
 	if (ret != 0)
-- 
2.1.3

