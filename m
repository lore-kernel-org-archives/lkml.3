Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936018Ab3DILag (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 07:30:36 -0400
Received: from drsnuggles.stderr.nl ([94.142.244.14]:37103 "EHLO
	drsnuggles.stderr.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758447Ab3DILaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 07:30:35 -0400
Date: Tue, 9 Apr 2013 13:19:58 +0200
From: Matthijs Kooijman <matthijs@stdin.nl>
To: Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>
Cc: Paul Zimmerman <Paul.Zimmerman@synopsys.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] checkpatch: Check block comments outside of net
Message-ID: <20130409111958.GG13691@login.drsnuggles.stderr.nl>
Mail-Followup-To: Matthijs Kooijman <matthijs@stdin.nl>,
	Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>,
	Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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
but nothing to check the regular block comment style.

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

$ ./scripts/checkpatch.pl -f test.c
WARNING: block comments put the leading /* on a separate line
+
+/* foo

WARNING: block comments put the leading /* on a separate line
+
+/* foo

WARNING: block comments put the trailing */ on a separate line
+ * bar */

WARNING: block comments put the leading /* on a separate line
+
+/**

WARNING: block comments put the leading /* on a separate line
+
+/****************************

total: 0 errors, 5 warnings, 25 lines checked

Signed-off-by: Matthijs Kooijman <matthijs@stdin.nl>
---


Note that this patch rejects /** comments, since those are not mentioned
in Codingstyle. They are used in practice though (around 1000 occurences
in kernel/ alone), so perhaps they should be allowed and documented?

Also, the new check only fires when the previous line is empty, just
like the start of block comment check for net/. However, I couldn't find
any documentation on why this restriction is needed?


 scripts/checkpatch.pl | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index b28cc38..64080ad 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1884,13 +1884,21 @@ sub process {
 			     "networking block comments don't use an empty /* line, use /* Comment...\n" . $hereprev);
 		}
 
-		if ($realfile =~ m@^(drivers/net/|net/)@ &&
-		    $rawline !~ m@^\+[ \t]*\*/[ \t]*$@ &&	#trailing */
+		if ($realfile !~ m@^(drivers/net/|net/)@ &&
+		    $rawline !~ m@^\+.*/\*.*\*/[ \t]*$@ &&	#inline /*...*/
+		    $rawline !~ /^\+[ \t]*\/\*[ \t]*$/ &&	#blank /*
+		    $rawline =~ /^\+[ \t]*\/\*.+$/ &&
+		    $prevrawline =~ /^\+[ \t]*$/) {
+			WARN("BLOCK_COMMENT_STYLE",
+			     "block comments use an empty /* line\n" . $hereprev);
+		}
+
+		if ($rawline !~ m@^\+[ \t]*\*/[ \t]*$@ &&	#trailing */
 		    $rawline !~ m@^\+.*/\*.*\*/[ \t]*$@ &&	#inline /*...*/
 		    $rawline !~ m@^\+.*\*{2,}/[ \t]*$@ &&	#trailing **/
 		    $rawline =~ m@^\+[ \t]*.+\*\/[ \t]*$@) {	#non blank */
-			WARN("NETWORKING_BLOCK_COMMENT_STYLE",
-			     "networking block comments put the trailing */ on a separate line\n" . $herecurr);
+			WARN("BLOCK_COMMENT_STYLE",
+			     "block comments put the trailing */ on a separate line\n" . $herecurr);
 		}
 
 # check for spaces at the beginning of a line.
-- 
1.8.0

