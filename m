Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515AbaLIRfG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 12:35:06 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:36578 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbaLIRfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 12:35:03 -0500
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        acme@kernel.org, mpe@ellerman.id.au
Cc: ananth@in.ibm.com
Subject: [RFC PATCH 5/8] perf probe powerpc: Allow matching against dot symbols
Date: Tue,  9 Dec 2014 23:04:03 +0530
Message-Id: <d23252a0bb8a34b2eac9049b34d674aa2d6a2b6a.1418146300.git.naveen.n.rao@linux.vnet.ibm.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <cover.1418146300.git.naveen.n.rao@linux.vnet.ibm.com>
References: <cover.1418146300.git.naveen.n.rao@linux.vnet.ibm.com>
In-Reply-To: <cover.1418146300.git.naveen.n.rao@linux.vnet.ibm.com>
References: <cover.1418146300.git.naveen.n.rao@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120917-0025-0000-0000-000000B14C35
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow perf probe to work on powerpc ABIv1 without the need to specify the
leading dot '.' for functions. 'perf probe do_fork' works with this patch.

Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
---
 tools/perf/util/probe-event.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index d465f7c..174c22e 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -2221,6 +2221,15 @@ static int probe_function_filter(struct map *map __maybe_unused,
 		num_matched_functions++;
 		return 0;
 	}
+#ifdef __powerpc64__
+	/* Allow matching against the dot variant */
+	if (sym->name[0] == '.' && looking_function_name[0] != '.' &&
+	    (sym->binding == STB_GLOBAL || sym->binding == STB_LOCAL) &&
+	    strcmp(looking_function_name, sym->name+1) == 0) {
+		num_matched_functions++;
+		return 0;
+	}
+#endif
 	return 1;
 }
 
-- 
2.1.3

