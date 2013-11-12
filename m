Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799Ab3KLUrW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 15:47:22 -0500
Received: from merlin.infradead.org ([205.233.59.134]:41955 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756130Ab3KLUqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 15:46:39 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 13/13] tools lib traceevent: Add direct access to dynamic arrays
Date: Tue, 12 Nov 2013 17:46:18 -0300
Message-Id: <1384289178-31374-14-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1384289178-31374-1-git-send-email-acme@infradead.org>
References: <1384289178-31374-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>

Jiri Olsa was writing a plugin for the cfg80211_tx_mlme_mgmt trace
event, and was not able to get the implemented function working.
The event's print fmt looks like:

   "netdev:%s(%d), ftype:0x%.2x", REC->name, REC->ifindex,
            __le16_to_cpup((__le16 *)__get_dynamic_array(frame))

As there's no helper function for __le16_to_cpup(), Jiri was creating one
with a plugin. But unfortunately, it would not work even though he set
up the plugin correctly.

The problem is that the function parameters do not handle the helper
function "__get_dynamic_array()", and that passes in a NULL pointer.

Adding PRINT_DYNAMIC_ARRAY direct support to eval_num_arg() allows the
use of __get_dynamic_array() in function parameters.

Reported-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Tested-by: Jiri Olsa <jolsa@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/20131111160810.0ba9df7d@gandalf.local.home
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 8f450adaa9c2..0362d575de7d 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -3435,6 +3435,19 @@ eval_num_arg(void *data, int size, struct event_format *event, struct print_arg
 			goto out_warning_op;
 		}
 		break;
+	case PRINT_DYNAMIC_ARRAY:
+		/* Without [], we pass the address to the dynamic data */
+		offset = pevent_read_number(pevent,
+					    data + arg->dynarray.field->offset,
+					    arg->dynarray.field->size);
+		/*
+		 * The actual length of the dynamic array is stored
+		 * in the top half of the field, and the offset
+		 * is in the bottom half of the 32 bit field.
+		 */
+		offset &= 0xffff;
+		val = (unsigned long long)(data + offset);
+		break;
 	default: /* not sure what to do there */
 		return 0;
 	}
-- 
1.8.1.4

