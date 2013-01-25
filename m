Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756319Ab3AYKVI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 05:21:08 -0500
Received: from re04.intra2net.com ([82.165.46.26]:55554 "EHLO
	re04.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756213Ab3AYKVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 05:21:04 -0500
From: Thomas Jarosch <thomas.jarosch@intra2net.com>
To: acme@ghostprotocols.net
Cc: linux-kernel@vger.kernel.org
Subject: [perf PATCH 1/3] Fix memory leak on error
Date: Fri, 25 Jan 2013 11:20:47 +0100
Message-ID: <2717013.8dV0naNhAV@storm>
User-Agent: KMail/4.9.5 (Linux/3.6.11-5.fc17.x86_64; KDE/4.9.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cppcheck reported:
[util/event.c:480]: (error) Memory leak: event

Signed-off-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
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
1.7.11.7

