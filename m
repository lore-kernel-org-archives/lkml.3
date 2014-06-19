Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756966AbaFSUSk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 16:18:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51272 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756643AbaFSUSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 16:18:39 -0400
Date: Thu, 19 Jun 2014 13:18:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Anish Bhatt <anish@chelsio.com>
Subject: Re: [PATCH V2] checkpatch: Warn on unnecessary void function return
 statements
Message-Id: <20140619131837.b13ab73f682469ff852cee49@linux-foundation.org>
In-Reply-To: <1403113484.3839.13.camel@joe-AO725>
References: <1401728316.5770.9.camel@joe-AO725>
	<1403113484.3839.13.camel@joe-AO725>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jun 2014 10:44:44 -0700 Joe Perches <joe@perches.com> wrote:

> With some exceptions, warn on void functions that end with a
> "return;", because it's unnecessary.
> 
> Check the closing brace at the start of a line.
> If the line before that has a single tab, then return;
> look at the line before that.  If it's not a label,
> emit a warning.
> 
> So, emit a warning on:
> 
> void function(...)
> {
> 	[...]
> 	return;
> }
> 
> but do not emit a warning on the below because
> gcc requires any statement (including a bare
> semicolon) before the closing function brace:
> 
> void function(...)
> {
> 	[...]
> 		goto label;
> 	[...]
> 
> label:
> 	return;
> }
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
> 
> V2: The previous patch had a few too many false positives
>     on styles that should be acceptable.

Previous patch is now in mainline, so I did this:


From: Joe Perches <joe@perches.com>
Subject: checkpatch: reduce false positives when checking void function return statements

The previous patch had a few too many false positives on styles that
should be acceptable.

Signed-off-by: Joe Perches <joe@perches.com>
Tested-by: Anish Bhatt <anish@chelsio.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-reduce-false-positives-when-checking-void-function-return-statements scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-reduce-false-positives-when-checking-void-function-return-statements
+++ a/scripts/checkpatch.pl
@@ -3484,12 +3484,17 @@ sub process {
 			}
 		}
 
-# unnecessary return in a void function? (a single leading tab, then return;)
-		if ($sline =~ /^\+\treturn\s*;\s*$/ &&
-		    $prevline =~ /^\+/) {
+# unnecessary return in a void function
+# at end-of-function, with the previous line a single leading tab, then return;
+# and the line before that not a goto label target like "out:"
+		if ($sline =~ /^[ \+]}\s*$/ &&
+		    $prevline =~ /^\+\treturn\s*;\s*$/ &&
+		    $linenr >= 3 &&
+		    $lines[$linenr - 3] =~ /^[ +]/ &&
+		    $lines[$linenr - 3] !~ /^[ +]\s*$Ident\s*:/) {
 			WARN("RETURN_VOID",
-			     "void function return statements are not generally useful\n" . $herecurr);
-		}
+			     "void function return statements are not generally useful\n" . $hereprev);
+               }
 
 # if statements using unnecessary parentheses - ie: if ((foo == bar))
 		if ($^V && $^V ge 5.10.0 &&
_

