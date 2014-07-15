Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758644AbaGOKZN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 06:25:13 -0400
Received: from mga03.intel.com ([143.182.124.21]:57066 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758627AbaGOKZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 06:25:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,664,1400050800"; 
   d="scan'208";a="457118717"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>
Subject: [PATCH] perf: Fix missing vdso name in mmap events for x86
Date: Tue, 15 Jul 2014 13:24:04 +0300
Message-Id: <1405419844-3915-1-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.8.3.2
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 78d683e838a60ec4ba4591cca4364cba84a9e626
added vm_ops->name as an alternative to arch_vma_name
but did not update perf events use of arch_vma_name().

Commit a62c34bd2a8a3f159945becd57401e478818d51c
removed "[vdso]" as a name returned by the x86 version of
arch_vma_name(), so the perf event for the vdso mapping
no longer had the correct name.

Fix by making perf events also use vm_ops->name.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 kernel/events/core.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index a33d9a2b..a8740d1 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5266,6 +5266,12 @@ static void perf_event_mmap_event(struct perf_mmap_event *mmap_event)
 
 		goto got_name;
 	} else {
+		if (vma->vm_ops && vma->vm_ops->name) {
+			name = (char *)vma->vm_ops->name(vma);
+			if (name)
+				goto cpy_name;
+		}
+
 		name = (char *)arch_vma_name(vma);
 		if (name)
 			goto cpy_name;
-- 
1.8.3.2

