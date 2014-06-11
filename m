Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434AbaFKJ5Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 05:57:16 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:60073 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763AbaFKJ5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 05:57:15 -0400
Date: Wed, 11 Jun 2014 10:57:11 +0100
From: Andy Whitcroft <apw@canonical.com>
To: Ivo Sieben <meltedpianoman@gmail.com>
Cc: linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>
Subject: Re: [PATCH] [checkpatch.pl] ctx_statement_block #if/#else/#endif fix
Message-ID: <20140611095711.GL6819@bark>
References: <1400164995-8652-1-git-send-email-meltedpianoman@gmail.com>
 <20140611091640.GK6819@bark>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140611091640.GK6819@bark>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 10:16:40AM +0100, Andy Whitcroft wrote:

> It doesn't seem right to remove the restore of the state.  If you
> consider the effect of an #if/#else/#endif combination the state of the
> statement parser should be reset to the state at #if at the #else as the
> code there is an alternative for the code in the other branch(s) of the
> preprocessor, either is a continuation of the statement in progress when
> reached.  This contrived example should make it clear we need to
> restore:
> 
> 	c = (d +
> #if A
> 	a)
> #else
> 	b)
> #endif
> 
> 
> That said it appears to be doing something wrong in your example.
> 
> /me will have a poke and get back to you.

Ok, the fundamental issue seems to have been an off by one thinko in the
attempt to restore the state to the previous level ($@array is the index
of the late element not the length of the array).  The patch below seems
to sort out the issue.  Could you give it a try and confirm it covers
your primary cases, and if so I will push it to akpm.

Thanks.

-apw

>From b47b6f4934471bcc4d653b53be0950b9dc590c87 Mon Sep 17 00:00:00 2001
From: Andy Whitcroft <apw@canonical.com>
Date: Wed, 11 Jun 2014 10:51:13 +0100
Subject: [PATCH] checkpatch: fix handling of stacked state for preprocessor if
 branches

When reaching an alternative branch of a preprocessor directive we need to
reset statement state to that at the start of the if as this new segment
is logically ajacent to it.  Currently we inadvertantly take the state
for the containing block (read off by one error).  Pick the correct state.

This fixes statement parsing for the below style constructs:

    if (!test()) {
    #ifdef NEVER
	    foo();
	    bar();
    #else
	    bar();
	    foo();
    #endif
    }

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 scripts/checkpatch.pl | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 010b18e..d3c0126 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -885,7 +885,7 @@ sub ctx_statement_block {
 		if ($remainder =~ /^#\s*(?:ifndef|ifdef|if)\s/) {
 			push(@stack, [ $type, $level ]);
 		} elsif ($remainder =~ /^#\s*(?:else|elif)\b/) {
-			($type, $level) = @{$stack[$#stack - 1]};
+			($type, $level) = @{$stack[$#stack]};
 		} elsif ($remainder =~ /^#\s*endif\b/) {
 			($type, $level) = @{pop(@stack)};
 		}
@@ -1057,7 +1057,7 @@ sub ctx_block_get {
 		if ($lines[$line] =~ /^.\s*#\s*(?:ifndef|ifdef|if)\s/) {
 			push(@stack, $level);
 		} elsif ($lines[$line] =~ /^.\s*#\s*(?:else|elif)\b/) {
-			$level = $stack[$#stack - 1];
+			$level = $stack[$#stack];
 		} elsif ($lines[$line] =~ /^.\s*#\s*endif\b/) {
 			$level = pop(@stack);
 		}
-- 
2.0.0

