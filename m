Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729Ab3KDUXi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 15:23:38 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50179 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754623Ab3KDUXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 15:23:34 -0500
Date: Mon, 4 Nov 2013 12:23:19 -0800
From: tip-bot for Steven Rostedt <tipbot@zytor.com>
Message-ID: <tip-c6c2b960b7a4105f096499fba3df65d6c0272a20@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, namhyung@kernel.org, fweisbec@gmail.com,
        rostedt@goodmis.org, akpm@linux-foundation.org, srostedt@redhat.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, namhyung@kernel.org, fweisbec@gmail.com,
        rostedt@goodmis.org, akpm@linux-foundation.org, srostedt@redhat.com,
        tglx@linutronix.de
In-Reply-To: <20131101215501.655258742@goodmis.org>
References: <20131101215501.655258742@goodmis.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent:
  Add flags NOHANDLE and PRINTRAW to individual events
Git-Commit-ID: c6c2b960b7a4105f096499fba3df65d6c0272a20
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 04 Nov 2013 12:23:25 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c6c2b960b7a4105f096499fba3df65d6c0272a20
Gitweb:     http://git.kernel.org/tip/c6c2b960b7a4105f096499fba3df65d6c0272a20
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Fri, 1 Nov 2013 17:53:59 -0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 4 Nov 2013 14:36:27 -0300

tools lib traceevent: Add flags NOHANDLE and PRINTRAW to individual events

Add the flags EVENT_FL_NOHANDLE and EVENT_FL_PRINTRAW to the event flags
to have the event either ignore the register handler or to ignore the
handler and also print the raw format respectively.

This allows a tool to force a raw format or non handle for an event.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/20131101215501.655258742@goodmis.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.c | 4 ++--
 tools/lib/traceevent/event-parse.h | 2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 85cbbdd..fc6f35f 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -4446,11 +4446,11 @@ void pevent_event_info(struct trace_seq *s, struct event_format *event,
 {
 	int print_pretty = 1;
 
-	if (event->pevent->print_raw)
+	if (event->pevent->print_raw || (event->flags & EVENT_FL_PRINTRAW))
 		print_event_fields(s, record->data, record->size, event);
 	else {
 
-		if (event->handler)
+		if (event->handler && !(event->flags & EVENT_FL_NOHANDLE))
 			print_pretty = event->handler(s, record, event,
 						      event->context);
 
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index 9ab6367..dc8539e 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -308,6 +308,8 @@ enum {
 	EVENT_FL_ISBPRINT	= 0x04,
 	EVENT_FL_ISFUNCENT	= 0x10,
 	EVENT_FL_ISFUNCRET	= 0x20,
+	EVENT_FL_NOHANDLE	= 0x40,
+	EVENT_FL_PRINTRAW	= 0x80,
 
 	EVENT_FL_FAILED		= 0x80000000
 };
