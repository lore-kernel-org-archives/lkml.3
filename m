Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751814AbaGFRmU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 13:42:20 -0400
Received: from mail-wi0-f201.google.com ([209.85.212.201]:43963 "EHLO
	mail-wi0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbaGFRmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 13:42:18 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Michael Lentine <mlentine@google.com>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] tools: perf: prefer clarity in setup_pager
Date: Sun,  6 Jul 2014 19:42:11 +0200
Message-Id: <1404668531-31550-1-git-send-email-mina86@mina86.com>
X-Mailer: git-send-email 2.0.0.526.g5318336
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

“!(pager || access(…))” is indeed pretty smart way to write
“!pager && access(…) == 0” but other than being clever it gives
no advantages and merely confuses the reader who needs to wonder
what is actually going on.

As such, replace the checks with much cleaner ones.

Also, while at it, merge the lest “!pager” test with the next
test that yields true after the “!pager” if's body is executed.
---
 tools/perf/util/pager.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/pager.c b/tools/perf/util/pager.c
index 31ee02d..14da1b0 100644
--- a/tools/perf/util/pager.c
+++ b/tools/perf/util/pager.c
@@ -57,13 +57,11 @@ void setup_pager(void)
 	}
 	if (!pager)
 		pager = getenv("PAGER");
-	if (!(pager || access("/usr/bin/pager", X_OK)))
+	if (!pager && access("/usr/bin/pager", X_OK) == 0)
 		pager = "/usr/bin/pager";
-	if (!(pager || access("/usr/bin/less", X_OK)))
+	if (!pager && access("/usr/bin/less", X_OK) == 0)
 		pager = "/usr/bin/less";
-	if (!pager)
-		pager = "cat";
-	if (!*pager || !strcmp(pager, "cat"))
+	if (!pager || !*pager || !strcmp(pager, "cat"))
 		return;
 
 	spawned_pager = 1; /* means we are emitting to terminal */
-- 
2.0.0.526.g5318336

