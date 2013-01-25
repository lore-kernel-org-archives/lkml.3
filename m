Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545Ab3AYMIa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 07:08:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42334 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755504Ab3AYMI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 07:08:28 -0500
Date: Fri, 25 Jan 2013 04:08:15 -0800
From: tip-bot for Tom Zanussi <tom.zanussi@linux.intel.com>
Message-ID: <tip-10ee9fa3b92dece36209a3786d7bd558d459635f@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, tom.zanussi@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, tglx@linutronix.de, tom.zanussi@linux.intel.com
In-Reply-To: <1471b5968821a455cf5168bb4567964e74ecf530.1358527965.git.tom.zanussi@linux.intel.com>
References: <1471b5968821a455cf5168bb4567964e74ecf530.1358527965.git.tom.zanussi@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Reinstate 'signed'
  field flag for tracepoints
Git-Commit-ID: 10ee9fa3b92dece36209a3786d7bd558d459635f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 25 Jan 2013 04:08:20 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  10ee9fa3b92dece36209a3786d7bd558d459635f
Gitweb:     http://git.kernel.org/tip/10ee9fa3b92dece36209a3786d7bd558d459635f
Author:     Tom Zanussi <tom.zanussi@linux.intel.com>
AuthorDate: Fri, 18 Jan 2013 13:51:25 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 24 Jan 2013 16:40:52 -0300

perf tools: Reinstate 'signed' field flag for tracepoints

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
