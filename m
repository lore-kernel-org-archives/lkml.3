Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759799Ab3BZPeo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 10:34:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10329 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759746Ab3BZPem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 10:34:42 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH] perf: Fix vmalloc ring buffer free function
Date: Tue, 26 Feb 2013 16:34:21 +0100
Message-Id: <1361892861-11070-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we allocate perf ring buffer with the size of single page,
we will get memory corruption when releasing it. It's caused
by rb_free_work function (the CONFIG_PERF_USE_VMALLOC option
variant).

For single page sized ring buffer the page_order is -1 (because
nr_pages is 0). This needs to be recognized in the rb_free_work
function and set 'nr' to 0 in this case, so only the user page
gets freed.

Reported-by: Jan Stancek <jstancek@redhat.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 kernel/events/ring_buffer.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
index 23cb34f..21159fb 100644
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -336,7 +336,8 @@ static void rb_free_work(struct work_struct *work)
 	int i, nr;
 
 	rb = container_of(work, struct ring_buffer, work);
-	nr = 1 << page_order(rb);
+	/* -1 if there's only user page */
+	nr = page_order(rb) == -1 ? 0 : 1 << page_order(rb);
 
 	base = rb->user_page;
 	for (i = 0; i < nr + 1; i++)
-- 
1.7.11.7

