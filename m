Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323Ab3A3Ovy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 09:51:54 -0500
Received: from merlin.infradead.org ([205.233.59.134]:57836 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755324Ab3A3OrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 09:47:14 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Thomas Jarosch <thomas.jarosch@intra2net.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 19/21] perf tools: Fix memory leak on error
Date: Wed, 30 Jan 2013 11:47:00 -0300
Message-Id: <1359557222-17547-20-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1359557222-17547-1-git-send-email-acme@infradead.org>
References: <1359557222-17547-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Jarosch <thomas.jarosch@intra2net.com>

cppcheck reported:
[util/event.c:480]: (error) Memory leak: event

Signed-off-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
Link: http://lkml.kernel.org/r/2717013.8dV0naNhAV@storm
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 3cf2c3e..5cd13d7 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -476,8 +476,10 @@ int perf_event__synthesize_kernel_mmap(struct perf_tool *tool,
 		}
 	}
 
-	if (kallsyms__parse(filename, &args, find_symbol_cb) <= 0)
+	if (kallsyms__parse(filename, &args, find_symbol_cb) <= 0) {
+		free(event);
 		return -ENOENT;
+	}
 
 	map = machine->vmlinux_maps[MAP__FUNCTION];
 	size = snprintf(event->mmap.filename, sizeof(event->mmap.filename),
-- 
1.8.1.1.361.gec3ae6e

