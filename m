Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935380Ab3DJJFU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 05:05:20 -0400
Received: from drsnuggles.stderr.nl ([94.142.244.14]:44278 "EHLO
	drsnuggles.stderr.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415Ab3DJJFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 05:05:16 -0400
Date: Wed, 10 Apr 2013 11:05:05 +0200
From: Matthijs Kooijman <matthijs@stdin.nl>
To: Joe Perches <joe@perches.com>, Andy Whitcroft <apw@canonical.com>,
        Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4] checkpatch: check block comments outside of net
Message-ID: <20130410090505.GT13691@login.drsnuggles.stderr.nl>
Mail-Followup-To: Matthijs Kooijman <matthijs@stdin.nl>,
	Joe Perches <joe@perches.com>, Andy Whitcroft <apw@canonical.com>,
	Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
	linux-kernel@vger.kernel.org
References: <20130409111958.GG13691@login.drsnuggles.stderr.nl>
 <1365507174.6865.31.camel@joe-AO722>
 <20130410085937.GS13691@login.drsnuggles.stderr.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130410085937.GS13691@login.drsnuggles.stderr.nl>
X-PGP-Fingerprint: 7F6A 9F44 2820 18E2 18DE  24AA CF49 D0E6 8A2F AFBC
X-PGP-Key: http://www.stderr.nl/static/files/gpg_pubkey.asc
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Spam-Score: -2.6 (--)
X-Spam-Report: Spamchecked on "mail.drsnuggles.stderr.nl"
	pts  rule name              description
	---- ---------------------- -------------------------------------------
	-2.6 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There was some code checking block comments in net/ and drivers/net/,
but nothing for regular comments.

The end of a block comment is the same as inside net, so that check can
just be generalized.

The start of block comment must not have any comment after the leading
/*, which requires a new check.

Tested with:

$ cat test.c
/* foo */

/*
 * foo
 */

/* foo
 */

/* foo
 * bar */

/**
 * foo
 * bar
 */

/****************************
 * some long block comment
 ****************************/

struct foo {
        int bar;        /* another test */
};

$ ./scripts/checkpatch.pl --strict -f test.c
CHECK: block comments put the leading /* on a separate line
+
+/* foo

CHECK: block comments put the leading /* on a separate line
+
+/* foo

CHECK: block comments put the trailing */ on a separate line
+ * bar */

total: 0 errors, 0 warnings, 3 checks, 25 lines checked

test.c has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Signed-off-by: Matthijs Kooijman <matthijs@stdin.nl>

---

v2: change the error message for consistency
    add a comment
v3: allow /** as well
v4: allow /*{2,} as well
    convert to CHK

I've also allowed /******************** since that seems to be used in
a lot of places as well.

v3 was wrong, it only allowed /** (even though it advertised allowing
/*** as well....). Sorry for the noise...
---
 scripts/checkpatch.pl | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index b28cc38..b0a9211 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1884,13 +1884,21 @@ sub process {
 			     "networking block comments don't use an empty /* line, use /* Comment...\n" . $hereprev);
 		}
 
-		if ($realfile =~ m@^(drivers/net/|net/)@ &&
-		    $rawline !~ m@^\+[ \t]*\*/[ \t]*$@ &&	#trailing */
+		if ($realfile !~ m@^(drivers/net/|net/)@ &&
+		    $rawline !~ m@^\+.*/\*.*\*/[ \t]*$@ &&	#inline /*...*/
+		    $rawline !~ /^\+[ \t]*\/\*{1,}[ \t]*$/ &&	#blank /* (or more stars)
+		    $rawline =~ /^\+[ \t]*\/\*.+$/ &&		#non blank /*
+		    $prevrawline =~ /^\+[ \t]*$/) {
+			CHK("BLOCK_COMMENT_STYLE",
+			     "block comments put the leading /* on a separate line\n" . $hereprev);
+		}
+
+		if ($rawline !~ m@^\+[ \t]*\*/[ \t]*$@ &&	#trailing */
 		    $rawline !~ m@^\+.*/\*.*\*/[ \t]*$@ &&	#inline /*...*/
 		    $rawline !~ m@^\+.*\*{2,}/[ \t]*$@ &&	#trailing **/
 		    $rawline =~ m@^\+[ \t]*.+\*\/[ \t]*$@) {	#non blank */
-			WARN("NETWORKING_BLOCK_COMMENT_STYLE",
-			     "networking block comments put the trailing */ on a separate line\n" . $herecurr);
+			CHK("BLOCK_COMMENT_STYLE",
+			     "block comments put the trailing */ on a separate line\n" . $herecurr);
 		}
 
 # check for spaces at the beginning of a line.
-- 
1.8.0

