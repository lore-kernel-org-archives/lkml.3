Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751855AbaIYFD6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 01:03:58 -0400
Received: from smtprelay0251.hostedemail.com ([216.40.44.251]:42979 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751574AbaIYFD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 01:03:57 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2197:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3353:3653:3865:3866:3867:3868:3871:3872:4823:5007:7652:7903:10004:10400:10848:11232:11658:11914:12043:12517:12519:12555:13069:13221:13229:13311:13357:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: ocean09_3f5e1fffa2405
X-Filterd-Recvd-Size: 2725
Message-ID: <1411621434.4026.9.camel@joe-AO725>
Subject: [PATCH] checkpatch: Add exception to return then else test
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Elshad Mustafayev <elshadimo@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>,
        Andy Whitcroft <apw@canonical.com>
Date: Wed, 24 Sep 2014 22:03:54 -0700
In-Reply-To: <1411619466.4026.2.camel@joe-AO725>
References: <E1XX0bN-00032o-0x@feisty.vs19.net>
	 <1411619466.4026.2.camel@joe-AO725>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an exception to the return before else warning
when the line following it is also a return like:

	if (foo)
		return bar;
	else
		return baz;

This form of a test then return is at least as readable as

	if (foo)
		return bar;
	return baz;

so don't emit a warning on the first form.

Signed-off-by: Joe Perches <joe@perches.com>
Reported-by: Al Viro <viro@ZenIV.linux.org.uk>
---
> > Just what makes the replacement easier to follow?
> > 	if (foo)
> > 		return bar;
> > 	else
> > 		return baz;
> > is no less idiomatic than
> > 	if (foo)
> > 		return bar;
> > 	return baz;
> > 
> > Al, really annoyed by how the words "coding style issue" are getting used as
> > a magic incantation...
> 
> I agree.
> 
> I'll see about updating checkpatch to avoid warning on it

 scripts/checkpatch.pl | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 74bba23..52a223e 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2641,10 +2641,14 @@ sub process {
 		next if ($realfile !~ /\.(h|c)$/);
 
 # check indentation of any line with a bare else
+# (but not if it is a multiple line "if (foo) return bar; else return baz;")
 # if the previous line is a break or return and is indented 1 tab more...
 		if ($sline =~ /^\+([\t]+)(?:}[ \t]*)?else(?:[ \t]*{)?\s*$/) {
 			my $tabs = length($1) + 1;
-			if ($prevline =~ /^\+\t{$tabs,$tabs}(?:break|return)\b/) {
+			if ($prevline =~ /^\+\t{$tabs,$tabs}break\b/ ||
+			    ($prevline =~ /^\+\t{$tabs,$tabs}return\b/ &&
+			     defined $lines[$linenr] &&
+			     $lines[$linenr] !~ /^[ \+]\t{$tabs,$tabs}return/)) {
 				WARN("UNNECESSARY_ELSE",
 				     "else is not generally useful after a break or return\n" . $hereprev);
 			}


