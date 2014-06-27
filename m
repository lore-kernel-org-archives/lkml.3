Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422AbaF0XSg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 19:18:36 -0400
Received: from mga03.intel.com ([143.182.124.21]:57621 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753317AbaF0XQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 19:16:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,564,1400050800"; 
   d="scan'208";a="450941287"
From: Andi Kleen <andi@firstfloor.org>
To: jolsa@redhat.com
Cc: linux-kernel@vger.kernel.org, namhyung@kernel.org, acme@infradead.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 6/9] perf, tools: Allow events with dot
Date: Fri, 27 Jun 2014 16:16:01 -0700
Message-Id: <1403910964-11017-7-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1403910964-11017-1-git-send-email-andi@firstfloor.org>
References: <1403910964-11017-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

The Intel events use a dot to separate event name and unit mask.
Allow dot in names in the scanner, and remove special handling
of dot as EOF. Also remove the hack in jevents to replace dot
with underscore. This way dotted events can be specified
directly by the user.

I'm not fully sure this change to the scanner is correct
(what was the dot special case good for?), but I haven't
found anything that breaks with it so far at least.

Acked-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/util/jevents.c      | 9 +--------
 tools/perf/util/parse-events.l | 3 +--
 2 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/tools/perf/util/jevents.c b/tools/perf/util/jevents.c
index 1fae0b7..43550f7 100644
--- a/tools/perf/util/jevents.c
+++ b/tools/perf/util/jevents.c
@@ -100,15 +100,8 @@ static void addfield(char *map, char **dst, const char *sep,
 
 static void fixname(char *s)
 {
-	for (; *s; s++) {
+	for (; *s; s++)
 		*s = tolower(*s);
-		/*
-		 * Remove '.' for now, until the parser
-		 * can deal with it.
-		 */
-		if (*s == '.')
-			*s = '_';
-	}
 }
 
 static void fixdesc(char *s)
diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
index 3432995..709fa3b 100644
--- a/tools/perf/util/parse-events.l
+++ b/tools/perf/util/parse-events.l
@@ -81,7 +81,7 @@ num_dec		[0-9]+
 num_hex		0x[a-fA-F0-9]+
 num_raw_hex	[a-fA-F0-9]+
 name		[a-zA-Z_*?][a-zA-Z0-9_*?]*
-name_minus	[a-zA-Z_*?][a-zA-Z0-9\-_*?]*
+name_minus	[a-zA-Z_*?][a-zA-Z0-9\-_*?.]*
 /* If you add a modifier you need to update check_modifier() */
 modifier_event	[ukhpGHSD]+
 modifier_bp	[rwx]{1,3}
@@ -119,7 +119,6 @@ modifier_bp	[rwx]{1,3}
 			return PE_EVENT_NAME;
 		}
 
-.		|
 <<EOF>>		{
 			BEGIN(INITIAL); yyless(0);
 		}
-- 
1.9.3

