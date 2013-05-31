Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155Ab3EaRO1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 13:14:27 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:47616 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311Ab3EaROT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 13:14:19 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: David Gibson <david@gibson.dropbear.id.au>, jdl@jdl.com
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, mmarek@suse.cz, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, linux-kbuild@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH] dtc: Ensure #line directives don't consume data from the next line
Date: Fri, 31 May 2013 11:14:10 -0600
Message-Id: <1370020450-18136-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.10.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

Previously, the #line parsing regex ended with ({WS}+[0-9]+)?. The {WS}
could match line-break characters. If the #line directive did not contain
the optional flags field at the end, this could cause any integer data on
the next line to be consumed as part of the #line directive parsing. This
could cause syntax errors (i.e. #line parsing consuming the leading 0
from a hex constant 0x1234, leaving x1234 to be parsed as cell data,
which is a syntax error), or invalid compilation results (i.e. simply
consuming integer 1234 as part of the #line processing, thus removing it
from the cell data).

Fix this by replacing {WS} with [ \t] so that it can't match line-breaks.

Reported-by: Ian Campbell <Ian.Campbell@citrix.com>
Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
This is a patch for dtc upstream, in response to thread "DTB build
failure due to preproccessing". If/when it's accepted into dtc, I'll
follow up with a kernel patch that makes the same fix.

 dtc-lexer.l               |    2 +-
 tests/line_directives.dts |   10 ++++++++++
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/dtc-lexer.l b/dtc-lexer.l
index 254d5af..a3a4c69 100644
--- a/dtc-lexer.l
+++ b/dtc-lexer.l
@@ -71,7 +71,7 @@ static int pop_input_file(void);
 			push_input_file(name);
 		}
 
-<*>^"#"(line)?{WS}+[0-9]+{WS}+{STRING}({WS}+[0-9]+)? {
+<*>^"#"(line)?{WS}+[0-9]+{WS}+{STRING}([ \t]+[0-9]+)? {
 			char *line, *tmp, *fn;
 			/* skip text before line # */
 			line = yytext;
diff --git a/tests/line_directives.dts b/tests/line_directives.dts
index e9d0800..046ef37 100644
--- a/tests/line_directives.dts
+++ b/tests/line_directives.dts
@@ -8,4 +8,14 @@
 # 6 "bar.dts"
 
 / {
+/*
+ * Make sure optional flags don't consume integer data on next line. The issue
+ * was that the {WS} in the trailing ({WS}+[0-9]+)? could cross the * line-
+ * break, and consume the leading "0" of the hex constant, leaving "x12345678"
+ * to be parsed as a number, which is invalid syntax.
+ */
+	prop1 = <
+# 10 "qux.dts"
+		0x12345678
+	>;
 };
-- 
1.7.10.4

