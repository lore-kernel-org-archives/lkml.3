Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211AbaBJE0z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 23:26:55 -0500
Received: from usmamail.tilera.com ([12.216.194.151]:63772 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612AbaBJE0y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 23:26:54 -0500
X-Greylist: delayed 327 seconds by postgrey-1.27 at vger.kernel.org; Sun, 09 Feb 2014 23:26:53 EST
From: Tony Lu <zlu@tilera.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tony Lu <zlu@tilera.com>, Chris Metcalf <cmetcalf@tilera.com>
Subject: [PATCH] perf tools: Fix the logic of thread__fork
Thread-Topic: [PATCH] perf tools: Fix the logic of thread__fork
Thread-Index: Ac8mF47F18qUD7qqQNWZn8NHmpAOmg==
Date: Mon, 10 Feb 2014 04:21:23 +0000
Message-ID: <BAB94DBB0E89D8409949BC28AC95914C5D67EA30@USMAExch1.tad.internal.tilera.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Revert the logic of checking the return value of thread__set_comm().

If thread__set_comm() returns zero without errors, we should not return
immediately, instead we should finish the rest of the clone work.
Otherwise, perf report would fail to resolve symbols sampled in forked
threads.

Signed-off-by: Zhigang Lu <zlu@tilera.com>
---
 tools/perf/util/thread.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index 49eaf1d..e394861 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -126,7 +126,7 @@ int thread__fork(struct thread *thread, struct thread *parent, u64 timestamp)
 		if (!comm)
 			return -ENOMEM;
 		err = thread__set_comm(thread, comm, timestamp);
-		if (!err)
+		if (err)
 			return err;
 		thread->comm_set = true;
 	}
-- 
1.7.1
