Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244Ab3ARTvk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 14:51:40 -0500
Received: from mga11.intel.com ([192.55.52.93]:36578 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750867Ab3ARTvj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 14:51:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,494,1355126400"; 
   d="scan'208";a="278771718"
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: acme@redhat.com
Cc: linux-kernel@vger.kernel.org, Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: [PATCH 1/4] perf/tools: reinstate 'signed' field flag for tracepoints
Date: Fri, 18 Jan 2013 13:51:25 -0600
Message-Id: <1471b5968821a455cf5168bb4567964e74ecf530.1358527965.git.tom.zanussi@linux.intel.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <cover.1358527965.git.tom.zanussi@linux.intel.com>
References: <cover.1358527965.git.tom.zanussi@linux.intel.com>
In-Reply-To: <cover.1358527965.git.tom.zanussi@linux.intel.com>
References: <cover.1358527965.git.tom.zanussi@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For some reason the libtraceevent tracepoint-parsing code is missing
the FIELD_IS_SIGNED flag-setting code, which causes problems for the
Perl trace event binding at least, since it ends up unable to
recognize negative numbers.  Things like checking for negative return
values therefore fail, causing scripts like rwtop to instead interpret
the negative return value as a large positive value, which in turn get
added to e.g. read totals with insanely invalid results.

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
---
 tools/lib/traceevent/event-parse.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 5a824e3..cbb48e4 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -1463,7 +1463,8 @@ static int event_read_fields(struct event_format *event, struct format_field **f
 			if (read_expect_type(EVENT_ITEM, &token))
 				goto fail;
 
-			/* add signed type */
+			if (strtoul(token, NULL, 0))
+				field->flags |= FIELD_IS_SIGNED;
 
 			free_token(token);
 			if (read_expected(EVENT_OP, ";") < 0)
-- 
1.7.11.4

