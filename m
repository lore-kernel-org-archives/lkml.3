Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305AbaCJVPR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 17:15:17 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34662 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbaCJVPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 17:15:15 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Don Zickus <dzickus@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 3/3] perf machine: Use map as success in ip__resolve_ams
Date: Mon, 10 Mar 2014 18:15:08 -0300
Message-Id: <1394486108-5974-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1394486108-5974-1-git-send-email-acme@infradead.org>
References: <1394486108-5974-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Don Zickus <dzickus@redhat.com>

When trying to map a bunch of instruction addresses to their respective
threads, I kept getting a lot of bogus entries [I forget the exact
reason as I patched my code months ago].

Looking through ip__resolve_ams, I noticed the check for

  if (al.sym)

and realized, most times I have an al.map definition but sometimes an
al.sym is undefined.  In the cases where al.sym is undefined, the loop
keeps going even though a valid al.map exists.

Modify this check to use the more reliable al.map.  This fixed my bogus
entries.

Signed-off-by: Don Zickus <dzickus@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1393386227-149412-2-git-send-email-dzickus@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/machine.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index c872991e0f65..620a1983b76b 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1213,7 +1213,7 @@ static void ip__resolve_ams(struct machine *machine, struct thread *thread,
 		 */
 		thread__find_addr_location(thread, machine, m, MAP__FUNCTION,
 				ip, &al);
-		if (al.sym)
+		if (al.map)
 			goto found;
 	}
 found:
-- 
1.8.1.4

