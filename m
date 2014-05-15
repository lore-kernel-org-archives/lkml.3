Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924AbaEOO6H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 10:58:07 -0400
Received: from mail-by2lp0242.outbound.protection.outlook.com ([207.46.163.242]:37423
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752729AbaEOO6F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 10:58:05 -0400
X-Greylist: delayed 862 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 May 2014 10:58:05 EDT
From: Ivo Sieben <meltedpianoman@gmail.com>
To: <linux-kernel@vger.kernel.org>, Andy Whitcroft <apw@canonical.com>,
        "Joe Perches" <joe@perches.com>
CC: Ivo Sieben <meltedpianoman@gmail.com>
Subject: [PATCH] [checkpatch.pl] ctx_statement_block #if/#else/#endif fix
Date: Thu, 15 May 2014 16:43:15 +0200
Message-ID: <1400164995-8652-1-git-send-email-meltedpianoman@gmail.com>
X-Mailer: git-send-email 1.7.9.5
X-OriginalArrivalTime: 15 May 2014 14:43:25.0163 (UTC) FILETIME=[06D743B0:01CF704C]
X-EOPAttributedMessage: 0
X-Matching-Connectors: 130446386078113434;(ede6e1f7-176b-4c99-8942-08d118f12784);()
X-Forefront-Antispam-Report: CIP:193.138.13.20;CTRY:DE;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199002)(87286001)(89996001)(44976005)(50986999)(74502001)(92726001)(48376002)(73392001)(88136002)(77982001)(50466002)(83072002)(33646001)(92566001)(53416003)(79102001)(87572001)(102836001)(19580395003)(46102001)(47776003)(55446002)(31966008)(4396001)(93916002)(19580405001)(81342001)(81542001)(73972005)(36756003)(77156001)(20776003)(81442001)(61266001)(87936001)(99396002)(85852003)(82202001)(50226001)(62966002)(80022001)(74662001)(86362001)(71816001);DIR:OUT;SFP:;SCL:1;SRVR:BL2FFO11HUB028;H:oce-exbhcs03b.oce.net;FPR:;MLV:nov;PTR:smtp02.oce.com;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Forefront-PRVS: 0212BDE3BE
Authentication-Results: spf=softfail (sender IP is 193.138.13.20)
 smtp.mailfrom=meltedpianoman@gmail.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When picking up a complete statement block #if/#else/#endif prepocesor
boundaries are taken into account by pushing current level & type on a stack.
But on an #else the level was read from stack again (without actually popping it
from stack) causing the statement block to end too early on the next ';'.
Fixed this.

For example the following code:

 	if (!test()) {
 #ifdef NEVER
 		foo();
 		bar();
 #else
 		bar();
 		foo();
 #endif
 	}

Results in statement block:

 STATEMENT<+    if (!test()) {
 +#ifdef NEVER
 +              foo();
 +              bar();
 +#else
 +              bar();>
 CONDITION<+    if (!test())>

While you would expect:

 STATEMENT<+    if (!test()) {
 +#ifdef NEVER
 +              foo();
 +              bar();
 +#else
 +              bar();
 +              foo();
 +#endif
 +       }>
 CONDITION<+     if (!test())>

Signed-off-by: Ivo Sieben <meltedpianoman@gmail.com>
---

Request for comments:
I think I fixed a problem here that I encountered while I was working on another
changeset in which I check the statement block after a condition.
Somehow the statement block did not contain everything I expected.

 scripts/checkpatch.pl |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 34eb216..e7bca89 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -878,7 +878,7 @@ sub ctx_statement_block {
 		if ($remainder =~ /^#\s*(?:ifndef|ifdef|if)\s/) {
 			push(@stack, [ $type, $level ]);
 		} elsif ($remainder =~ /^#\s*(?:else|elif)\b/) {
-			($type, $level) = @{$stack[$#stack - 1]};
+			# no changes to stack: type & level remain the same
 		} elsif ($remainder =~ /^#\s*endif\b/) {
 			($type, $level) = @{pop(@stack)};
 		}
@@ -1050,7 +1050,7 @@ sub ctx_block_get {
 		if ($lines[$line] =~ /^.\s*#\s*(?:ifndef|ifdef|if)\s/) {
 			push(@stack, $level);
 		} elsif ($lines[$line] =~ /^.\s*#\s*(?:else|elif)\b/) {
-			$level = $stack[$#stack - 1];
+			# no changes to stack: type & level remain the same
 		} elsif ($lines[$line] =~ /^.\s*#\s*endif\b/) {
 			$level = pop(@stack);
 		}
-- 
1.7.9.5

