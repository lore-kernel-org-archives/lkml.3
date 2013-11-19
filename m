Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083Ab3KSUmM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 15:42:12 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48628 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471Ab3KSUmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 15:42:08 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 5/5] tools lib traceevent: Fix conversion of pointer to integer of different size
Date: Tue, 19 Nov 2013 17:41:58 -0300
Message-Id: <1384893718-18762-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1384893718-18762-1-git-send-email-acme@infradead.org>
References: <1384893718-18762-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

gcc complaint on 32-bit system:

  /home/acme/git/linux/tools/lib/traceevent/event-parse.c: In function ‘eval_num_arg’:
  /home/acme/git/linux/tools/lib/traceevent/event-parse.c:3468:9: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]

This is because the eval_num_arg returns everything as an 'unsigned long long',
so it converts a void pointer to a wider integer, fix it by converting the void
pointer to an integer of the same size, 'unsigned long', before casting it to
'unsigned long long'.

Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-yllx4aqcg06v5n4vjpwiiuld@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 8a5b65df6efb..217c82ee3665 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -3465,7 +3465,7 @@ eval_num_arg(void *data, int size, struct event_format *event, struct print_arg
 		 * is in the bottom half of the 32 bit field.
 		 */
 		offset &= 0xffff;
-		val = (unsigned long long)(data + offset);
+		val = (unsigned long long)((unsigned long)data + offset);
 		break;
 	default: /* not sure what to do there */
 		return 0;
-- 
1.8.1.4

