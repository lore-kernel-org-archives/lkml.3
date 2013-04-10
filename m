Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964981Ab3DJItj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 04:49:39 -0400
Received: from drsnuggles.stderr.nl ([94.142.244.14]:38464 "EHLO
	drsnuggles.stderr.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936347Ab3DJIt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 04:49:29 -0400
Date: Wed, 10 Apr 2013 10:49:27 +0200
From: Matthijs Kooijman <matthijs@stdin.nl>
To: Joe Perches <joe@perches.com>, Andy Whitcroft <apw@canonical.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] checkpatch: Only warn for empty lines before closing
 braces by themselves
Message-ID: <20130410084927.GR13691@login.drsnuggles.stderr.nl>
Mail-Followup-To: Matthijs Kooijman <matthijs@stdin.nl>,
	Joe Perches <joe@perches.com>, Andy Whitcroft <apw@canonical.com>,
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

This check was intended to catch extra newlines at the end of a function
definition, but it would trigger on any closing brace, including those
of inline functions and macro definitions, triggering false positives.
Now, only closing braces on a line by themselves trigger this check.

Tested with:

$ cat test.h
/* test.h - Test file */

static inline int foo(void) { return 0; }

static inline int bar(void)
{
        return 1;

}

$ ./scripts/checkpatch.pl --strict -f test.h # Before this commit
CHECK: Blank lines aren't necessary before a close brace '}'
+
+static inline int foo(void) { return 0; }

CHECK: Blank lines aren't necessary before a close brace '}'
+
+}

total: 0 errors, 0 warnings, 2 checks, 9 lines checked

$ ./scripts/checkpatch.pl --strict -f test.h # After this commit
CHECK: Blank lines aren't necessary before a close brace '}'
+
+}

total: 0 errors, 0 warnings, 1 checks, 9 lines checked

Signed-off-by: Matthijs Kooijman <matthijs@stdin.nl>
---
 scripts/checkpatch.pl | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 532c41b..f962c30 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3236,7 +3236,7 @@ sub process {
 		}
 
 # check for unnecessary blank lines around braces
-		if (($line =~ /^..*}\s*$/ && $prevline =~ /^.\s*$/)) {
+		if (($line =~ /^.\s*}\s*$/ && $prevline =~ /^.\s*$/)) {
 			CHK("BRACES",
 			    "Blank lines aren't necessary before a close brace '}'\n" . $hereprev);
 		}
-- 
1.8.0

