Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932419AbaJUNC0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 09:02:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21912 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755351AbaJUNCZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 09:02:25 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>, Andy Whitcroft <apw@canonical.com>,
        Joe Perches <joe@perches.com>
Subject: [PATCH V3] scripts, checkpatch.pl, provide a better output message for commit id format
Date: Tue, 21 Oct 2014 09:02:17 -0400
Message-Id: <1413896537-8045-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I tested this using both lower and upper case 'c' with the following commit
text:

Derp, derpy derp.   Derps derpy derpy derp derp derp derp.
Some other text besides derp.
Stuff.

11 chars, SHOULD FAIL due to size
commit 1234567890a

12 chars, SHOULD FAIL with missing commit info warning
commit 1234567890ab

13 chars, SHOULD FAIL with missing commit info warning
commit 1234567890abc

14 chars, SHOULD FAIL with missing commit info warning
commit 1234567890abcd

11 chars, SHOULD FAIL due to size
commit 1234567890a, xxxx

12 chars, SHOULD FAIL with missing commit info warning
commit 1234567890ab, yyyy

13 chars, SHOULD FAIL with missing commit info warning
commit 1234567890abc, yyyy

14 chars, SHOULD FAIL with missing commit info warning
commit 1234567890abcd, yyyy

commit 1234567890f
("11 chars, separated into two lines SHOULD FAIL")

commit 1234567890af
("12 chars, separated into two lines")

commit 1234567890abf
("13 chars, separated into two lines")

commit 1234567890abcf
("14 chars, separated into two lines")

commit 1234567890f ("11 chars, one line SHOULD FAIL")

commit 1234567890af ("12 chars, one line")

commit 1234567890abf ("13 chars, one line")

commit 1234567890abcf ("14 chars, one line")

P.
----8<----

I put together a patch with an incorrect format and the following error
was returned by checkpatch.pl:

ERROR: Please use 12 or more chars for the git commit ID like: 'Commit
09ec54429c6d ("clocksource: Move cycle_last validation to core code")'
Commit 09ec54429c6d10f87d1f084de53ae2c1c3a81108, clocksource: Move

As can be seen by the output the commit ID length is accurate, and it is the
formatting that is generating an error.  The message is confusing and should
be separated into two warnings, one for the git commit ID length, and the other
for the format.

Cc: Andy Whitcroft <apw@canonical.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Prarit Bhargava <prarit@redhat.com>

[v2]: Add separate messages for warnings instead of one global format
warning.
[v3]: Add check for improperly formatted git ids as well.
---
 scripts/checkpatch.pl |   26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 374abf4..5bdbadd 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2160,21 +2160,27 @@ sub process {
 			      "Remove Gerrit Change-Id's before submitting upstream.\n" . $herecurr);
 		}
 
-# Check for improperly formed commit descriptions
+# Check for git id commit length and improperly formed commit descriptions
 		if ($in_commit_log &&
-		    $line =~ /\bcommit\s+[0-9a-f]{5,}/i &&
-		    !($line =~ /\b[Cc]ommit [0-9a-f]{12,40} \("/ ||
-		      ($line =~ /\b[Cc]ommit [0-9a-f]{12,40}\s*$/ &&
-		       defined $rawlines[$linenr] &&
-		       $rawlines[$linenr] =~ /^\s*\("/))) {
-			$line =~ /\b(c)ommit\s+([0-9a-f]{5,})/i;
+		    $line =~ /\b[Cc]ommit\s+[0-9a-f]{5,}/i &&
+		    !($line =~ /\b[Cc]ommit [0-9a-f]{12,40}/ )) {
+			ERROR("GIT_COMMIT_ID_12_CHARS",
+			      "Please use 12 or more chars for the git commit ID\n" . $herecurr);
+		} elsif ($in_commit_log &&
+			 $line =~ /\b[Cc]ommit [0-9a-f]{12,40}/ &&
+			 !($line =~ /\b[Cc]ommit [0-9a-f]{12,40} \("/ ||
+			   ($line =~ /\b[Cc]ommit [0-9a-f]{12,40}\s*$/ &&
+			    defined $rawlines[$linenr] &&
+			    $rawlines[$linenr] =~ /^\s*\("/))) {
+			$line =~ /\b(c)ommit\s+([0-9a-f]{12,40})/i;
 			my $init_char = $1;
 			my $orig_commit = lc($2);
 			my $id = '01234567890ab';
 			my $desc = 'commit description';
-		        ($id, $desc) = git_commit_info($orig_commit, $id, $desc);
-			ERROR("GIT_COMMIT_ID",
-			      "Please use 12 or more chars for the git commit ID like: '${init_char}ommit $id (\"$desc\")'\n" . $herecurr);
+			($id, $desc) = git_commit_info($orig_commit,
+						       $id, $desc);
+			ERROR("GIT_COMMIT_ID_DESCRIPTION_FORMAT",
+			      "Please format the git commit ID like: '${init_char}ommit $id (\"$desc\")'\n" . $herecurr);
 		}
 
 # Check for added, moved or deleted files
-- 
1.7.9.3

