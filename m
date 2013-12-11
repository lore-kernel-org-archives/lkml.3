Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015Ab3LKLEE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 06:04:04 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60083 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626Ab3LKLD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 06:03:58 -0500
Date: Wed, 11 Dec 2013 03:03:40 -0800
From: tip-bot for David Ahern <tipbot@zytor.com>
Message-ID: <tip-3160565f0e005d2ec736ae25cf0a79988c0cbe71@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1386211302-31303-4-git-send-email-dsahern@gmail.com>
References: <1386211302-31303-4-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace:
  Fix summary percentage when processing files
Git-Commit-ID: 3160565f0e005d2ec736ae25cf0a79988c0cbe71
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 11 Dec 2013 03:03:47 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3160565f0e005d2ec736ae25cf0a79988c0cbe71
Gitweb:     http://git.kernel.org/tip/3160565f0e005d2ec736ae25cf0a79988c0cbe71
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Wed, 4 Dec 2013 19:41:41 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 5 Dec 2013 10:09:58 -0300

perf trace: Fix summary percentage when processing files

Getting a divide by 0 when events are processed from a file:

   perf trace -i perf.data -s
   ...
   dnsmasq (1684), 10 events, inf%, 0.000 msec

The problem is that the event count is not incremented as events are
processed. With this patch:

   perf trace -i perf.data -s
   ...
   dnsmasq (1684), 10 events, 8.9%, 0.000 msec

Signed-off-by: David Ahern <dsahern@gmail.com>
Link: http://lkml.kernel.org/r/1386211302-31303-4-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index a7aa771..56bbca5 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1770,8 +1770,10 @@ static int trace__process_sample(struct perf_tool *tool,
 	if (!trace->full_time && trace->base_time == 0)
 		trace->base_time = sample->time;
 
-	if (handler)
+	if (handler) {
+		++trace->nr_events;
 		handler(trace, evsel, sample);
+	}
 
 	return err;
 }
