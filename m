Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932504Ab3KLV6V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 16:58:21 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40307 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756105Ab3KLV6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 16:58:13 -0500
Date: Tue, 12 Nov 2013 13:57:52 -0800
From: tip-bot for Steven Rostedt <tipbot@zytor.com>
Message-ID: <tip-0497a9ebaf7ae4d573497b3e053ad4c3d5c9921d@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <20131111160810.0ba9df7d@gandalf.local.home>
References: <20131111160810.0ba9df7d@gandalf.local.home>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] tools lib traceevent:
  Add direct access to dynamic arrays
Git-Commit-ID: 0497a9ebaf7ae4d573497b3e053ad4c3d5c9921d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 12 Nov 2013 13:57:57 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0497a9ebaf7ae4d573497b3e053ad4c3d5c9921d
Gitweb:     http://git.kernel.org/tip/0497a9ebaf7ae4d573497b3e053ad4c3d5c9921d
Author:     Steven Rostedt <rostedt@goodmis.org>
AuthorDate: Mon, 11 Nov 2013 16:08:10 -0500
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 12 Nov 2013 17:23:44 -0300

tools lib traceevent: Add direct access to dynamic arrays

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
index 8f450ad..0362d57 100644
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
