Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751573Ab3IZF2D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 01:28:03 -0400
Received: from mail-vb0-f74.google.com ([209.85.212.74]:47174 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112Ab3IZF2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 01:28:00 -0400
From: Sonny Rao <sonnyrao@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Sonny Rao <sonnyrao@chromium.org>
Subject: [PATCH] perf: fix infinite loop with corrupted header
Date: Wed, 25 Sep 2013 22:20:36 -0700
Message-Id: <1380172836-13936-1-git-send-email-sonnyrao@chromium.org>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We recently ran into a corrupt perf data file which mostly looked okay
but the section size for data was set to 0.  This caused perf report to
get into an infinite loop in __perf_session_process_events().  Let's
just avoid this by bailing early and reporting it if there's an
invalid header.

Signed-off-by: Sonny Rao <sonnyrao@chromium.org>
---
 tools/perf/util/header.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 26441d0..085ef76 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2582,6 +2582,10 @@ int perf_file_header__read(struct perf_file_header *header,
 	ph->data_offset  = header->data.offset;
 	ph->data_size	 = header->data.size;
 	ph->feat_offset  = header->data.offset + header->data.size;
+
+	if (!header->data.size)
+		die("corrupted header, invalid size 0 for data section\n");
+
 	return 0;
 }
 
-- 
1.8.4

