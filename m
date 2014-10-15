Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183AbaJOUxf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 16:53:35 -0400
Received: from mail.kernel.org ([198.145.19.201]:35493 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752112AbaJOUxd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 16:53:33 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Yasser Shalabi <yassershalabi@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 08/15] perf evlist: Fix for double free in tools/perf stat
Date: Wed, 15 Oct 2014 17:52:41 -0300
Message-Id: <1413406368-26245-9-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1413406368-26245-1-git-send-email-acme@kernel.org>
References: <1413406368-26245-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yasser Shalabi <yassershalabi@gmail.com>

Fix for double free bug in tools/perf due to dangling thread_map pointer
in perf_evlist struct.

Code path excercised when perf stat -C switch is used but not set and is
followed by another switch.

Example:

  perf stat -C -e.

Signed-off-by: Yasser Shalabi <yassershalabi@gmail.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1412437077-13109-1-git-send-email-yassershalabi@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index b4b54d84e9b0..3c9e77d6b4c2 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -1003,6 +1003,7 @@ int perf_evlist__create_maps(struct perf_evlist *evlist, struct target *target)
 
 out_delete_threads:
 	thread_map__delete(evlist->threads);
+	evlist->threads = NULL;
 	return -1;
 }
 
-- 
1.9.3

