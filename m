Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751385Ab3KKVI1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 16:08:27 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:18896 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750961Ab3KKVIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 16:08:20 -0500
Date: Mon, 11 Nov 2013 16:08:10 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH] tools lib traceevent: Add direct access to dynamic arrays
Message-ID: <20131111160810.0ba9df7d@gandalf.local.home>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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
-- 
1.8.4.rc3

