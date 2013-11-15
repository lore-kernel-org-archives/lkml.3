Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215Ab3KOHZ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 02:25:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50326 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754939Ab3KOHZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 02:25:12 -0500
Date: Thu, 14 Nov 2013 23:24:59 -0800
From: tip-bot for Don Zickus <tipbot@zytor.com>
Message-ID: <tip-bo4akalno7579shpz29u867j@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, jmario@redhat.com, rfowles@redhat.com,
        jolsa@redhat.com, tglx@linutronix.de, bgray@redhat.com,
        dzickus@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, jmario@redhat.com,
        jolsa@redhat.com, rfowles@redhat.com, bgray@redhat.com,
        tglx@linutronix.de, dzickus@redhat.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: Synthesize anon MMAP records again
Git-Commit-ID: 9d4ecc8893832337daf241236841db966fa53489
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 14 Nov 2013 23:25:05 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9d4ecc8893832337daf241236841db966fa53489
Gitweb:     http://git.kernel.org/tip/9d4ecc8893832337daf241236841db966fa53489
Author:     Don Zickus <dzickus@redhat.com>
AuthorDate: Wed, 13 Nov 2013 15:32:06 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 14 Nov 2013 16:00:01 -0300

perf tools: Synthesize anon MMAP records again

When introducing the PERF_RECORD_MMAP2 in:

5c5e854bc760 perf tools: Add attr->mmap2 support

A check for the number of entries parsed by sscanf was introduced that
assumed all of the 8 fields needed to be correctly parsed so that
particular /proc/pid/maps line would be considered synthesizable.

That broke anon records synthesizing, as it doesn't have the 'execname'
field.

Fix it by keeping the sscanf return check, changing it to not require
that the 'execname' variable be parsed, so that the preexisting logic
can kick in and set it to '//anon'.

This should get things like JIT profiling working again.

Signed-off-by: Don Zickus <dzickus@redhat.com>
Cc: Bill Gray <bgray@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Joe Mario <jmario@redhat.com>
Cc: Richard Fowles <rfowles@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: stable@vger.kernel.org
Link: http://lkml.kernel.org/n/tip-bo4akalno7579shpz29u867j@git.kernel.org
[ commit log message is mine, dzickus reported the problem with a patch ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 6e3a846..bb788c1 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -209,8 +209,10 @@ static int perf_event__synthesize_mmap_events(struct perf_tool *tool,
 		       &event->mmap.start, &event->mmap.len, prot,
 		       &event->mmap.pgoff,
 		       execname);
-
-		if (n != 5)
+		/*
+ 		 * Anon maps don't have the execname.
+ 		 */
+		if (n < 4)
 			continue;
 		/*
 		 * Just like the kernel, see __perf_event_mmap in kernel/perf_event.c
