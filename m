Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751569AbaLIRfP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 12:35:15 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:36593 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545AbaLIRfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 12:35:11 -0500
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        acme@kernel.org, mpe@ellerman.id.au
Cc: ananth@in.ibm.com
Subject: [RFC PATCH 8/8] perf probe powerpc: Fixup function entry if using kallsyms lookup
Date: Tue,  9 Dec 2014 23:04:06 +0530
Message-Id: <e5bfde8d51546041e50699c4ed3bad8c3c1bf84f.1418146300.git.naveen.n.rao@linux.vnet.ibm.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <cover.1418146300.git.naveen.n.rao@linux.vnet.ibm.com>
References: <cover.1418146300.git.naveen.n.rao@linux.vnet.ibm.com>
In-Reply-To: <cover.1418146300.git.naveen.n.rao@linux.vnet.ibm.com>
References: <cover.1418146300.git.naveen.n.rao@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120917-0025-0000-0000-000000B14C40
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On powerpc ABIv2, if no debug-info is found and we use kallsyms,
we need to fixup the function entry to point to the local entry point.
Use offset of 8 since current toolchains always generate 2
instructions (8 bytes).

Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
---
 tools/perf/util/probe-event.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index adcdbd2..0970e2a 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -2318,6 +2318,15 @@ static int find_probe_trace_events_from_map(struct perf_probe_event *pev,
 		}
 		/* Add one probe point */
 		tp->address = map->unmap_ip(map, sym->start) + pp->offset;
+#if defined(__powerpc64__) && defined(_CALL_ELF) && _CALL_ELF == 2
+		/*
+		 * If we used kallsyms, we should fixup the function entry address here.
+		 * ppc64le ABIv2 local entry point is currently always 2 instructions (8 bytes)
+		 * after the global entry point. Fix this if it ever changes.
+		 */
+		if (!pev->uprobes && map->dso->symtab_type == DSO_BINARY_TYPE__KALLSYMS)
+			tp->address += 8;
+#endif
 		if (reloc_sym) {
 			tp->symbol = strdup_or_goto(reloc_sym->name, nomem_out);
 			tp->offset = tp->address - reloc_sym->addr;
-- 
2.1.3

