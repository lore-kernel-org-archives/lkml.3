Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751202AbaALEd0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 23:33:26 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:58913 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750958AbaALEdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 23:33:23 -0500
From: Gaurav Jain <gjain@fb.com>
To: <linux-kernel@vger.kernel.org>
CC: Gaurav Jain <gjain@fb.com>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Don Zickus <dzickus@redhat.com>, Arun Sharma <asharma@fb.com>
Subject: [PATCH] perf tools: Synthesize anon MMAP records on the heap
Date: Sat, 11 Jan 2014 20:32:14 -0800
Message-ID: <1389501134-13116-1-git-send-email-gjain@fb.com>
X-Mailer: git-send-email 1.8.5.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Spam-Reason: safe
X-FB-Internal: Safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-01-12_01:2014-01-10,2014-01-12,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anon records usually do not have the 'execname' entry. However if they are on
the heap, the execname shows up as '[heap]'. The fix considers any executable
entries in the map that do not have a name or are on the heap as anon records
and sets the name to '//anon'.

This fixes JIT profiling for records on the heap.

Signed-off-by: Gaurav Jain <gjain@fb.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Arun Sharma <asharma@fb.com>
---
 tools/perf/util/event.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index bb788c1..ae9c55b 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -224,10 +224,9 @@ static int perf_event__synthesize_mmap_events(struct perf_tool *tool,
 				continue;
 
 			event->header.misc |= PERF_RECORD_MISC_MMAP_DATA;
-		}
-
-		if (!strcmp(execname, ""))
+		} if (!strcmp(execname, "") || !strcmp(execname, "[heap]")) {
 			strcpy(execname, anonstr);
+		}
 
 		size = strlen(execname) + 1;
 		memcpy(event->mmap.filename, execname, size);
-- 
1.8.1

