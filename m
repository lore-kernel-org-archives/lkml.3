Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097Ab3AXUTb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:19:31 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:54084
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755909Ab3AXUIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:08:46 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Tom Zanussi <tom.zanussi@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 68/74] perf tools: Reinstate 'signed' field flag for tracepoints
Date: Thu, 24 Jan 2013 17:08:17 -0300
Message-Id: <1359058103-31645-69-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1359058103-31645-1-git-send-email-acme@infradead.org>
References: <1359058103-31645-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tom Zanussi <tom.zanussi@linux.intel.com>

For some reason the libtraceevent tracepoint-parsing code is missing
the FIELD_IS_SIGNED flag-setting code, which causes problems for the
Perl trace event binding at least, since it ends up unable to
recognize negative numbers.

Things like checking for negative return values therefore fail, causing
scripts like rwtop to instead interpret the negative return value as a
large positive value, which in turn get added to e.g. read totals with
insanely invalid results.

So set the FIELD_IS_SIGNED flag for tracepoint events that specify
"signed:1".

Before:

  # perf script record rw-by-pid
  # perf script report rw-by-pid

  read counts by pid:

     pid                  comm     # reads  bytes_requested  bytes_read
  ------  --------------------  -----------  ----------  ----------
     753  Xorg                          88      512000  7.74763251095801e+20
    1619  firefox                       42         462  2.58254417031934e+20
    1232  gnome-shell                   11         176  1.10680464442257e+20
    1471  gnome-terminal                 3       16366  18446744073709551615
    1408  libsocialweb-co                2          32  18446744073709551613

After:

  # perf script report rw-by-pid

  read counts by pid:

     pid                  comm     # reads  bytes_requested  bytes_read
  ------  --------------------  -----------  ----------  ----------
     753  Xorg                          88      512000        2764
    1619  firefox                       42         462         126
    1232  gnome-shell                   11         176          40
    1471  gnome-terminal                 3       16366          10
    1408  libsocialweb-co                2          32           8

Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
Link: http://lkml.kernel.org/r/1471b5968821a455cf5168bb4567964e74ecf530.1358527965.git.tom.zanussi@linux.intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index f504619..bb8b3db 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -1462,7 +1462,8 @@ static int event_read_fields(struct event_format *event, struct format_field **f
 			if (read_expect_type(EVENT_ITEM, &token))
 				goto fail;
 
-			/* add signed type */
+			if (strtoul(token, NULL, 0))
+				field->flags |= FIELD_IS_SIGNED;
 
 			free_token(token);
 			if (read_expected(EVENT_OP, ";") < 0)
-- 
1.8.1.1.361.gec3ae6e

