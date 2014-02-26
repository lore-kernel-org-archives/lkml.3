Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347AbaBZDoE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 22:44:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11514 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752127AbaBZDn6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 22:43:58 -0500
From: Don Zickus <dzickus@redhat.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: acme@ghostprotocols.net, jolsa@redhat.com, eranian@google.com,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 1/3] perf, machine: Use map as success in ip__resolve_ams
Date: Tue, 25 Feb 2014 22:43:45 -0500
Message-Id: <1393386227-149412-2-git-send-email-dzickus@redhat.com>
In-Reply-To: <1393386227-149412-1-git-send-email-dzickus@redhat.com>
References: <1393386227-149412-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When trying to map a bunch of instruction addresses to their respective
threads, I kept getting a lot of bogus entries [I forget the exact reason
as I patched my code months ago].

Looking through ip__resovle_ams, I noticed the check for

if (al.sym)

and realized, most times I have an al.map definition but sometimes an
al.sym is undefined.  In the cases where al.sym is undefined, the loop
keeps going even though a valid al.map exists.

Modify this check to use the more reliable al.map.  This fixed my bogus
entries.

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 tools/perf/util/machine.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index ac37d78..813e94e 100644
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
1.7.11.7

