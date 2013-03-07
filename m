Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932413Ab3CGET4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 23:19:56 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:65105 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754643Ab3CGETy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 23:19:54 -0500
X-AuditID: 9c930197-b7cc2ae000000eb7-c9-513815694aed
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Jiri Olsa <jolsa@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/2] perf: Reset detached siblings' group_flags
Date: Thu,  7 Mar 2013 13:19:49 +0900
Message-Id: <1362629990-10053-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Currently if a group_leader event is deleted, the sibling events are
upgraded to singleton events of a same group list.  At this time, the
siblings inherit the leader's group_flags.

However, if the group has mixed hw/sw events the leader's group_flag
does not contain PERF_GROUP_SOFTWARE so sibling sw events will miss
the flag also.  Fix it.

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 kernel/events/core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 5c75791d7269..007dfe846d4d 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1107,8 +1107,9 @@ static void perf_group_detach(struct perf_event *event)
 			list_move_tail(&sibling->group_entry, list);
 		sibling->group_leader = sibling;
 
-		/* Inherit group flags from the previous leader */
-		sibling->group_flags = event->group_flags;
+		/* Reset group flags for each siblings */
+		sibling->group_flags = is_software_event(sibling) ?
+						PERF_GROUP_SOFTWARE : 0;
 	}
 
 out:
-- 
1.7.11.7

