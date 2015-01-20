Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527AbbATWZW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 17:25:22 -0500
Received: from smtprelay0060.hostedemail.com ([216.40.44.60]:53468 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751037AbbATWZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 17:25:21 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1714:1730:1747:1777:1792:2197:2199:2393:2559:2562:2828:2911:3138:3139:3140:3141:3142:3351:3653:3865:3866:3870:3871:3872:4321:4425:5007:6261:10004:10400:10848:11026:11232:11658:11914:12043:12517:12519:12555:13069:13208:13229:13255:13311:13357:14093:14097:14394:21067:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: box09_68750e8df0007
X-Filterd-Recvd-Size: 2743
Message-ID: <1421792716.2724.11.camel@perches.com>
Subject: [PATCH] checkpatch: Add ability to coalesce commit descriptions on
 multiple lines
From: Joe Perches <joe@perches.com>
To: Paul Bolle <pebolle@tiscali.nl>, Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Valentin Rothberg <valentinrothberg@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Tue, 20 Jan 2015 14:25:16 -0800
In-Reply-To: <1421660338.9655.21.camel@x220>
References: <1421659937.9655.16.camel@x220> <1421660338.9655.21.camel@x220>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a git commit description is split on consecutive lines,
coalesce it before testing.

This allows:

  commit <foo> ("some long
  description")

Signed-off-by: Joe Perches <joe@perches.com>
Noticed-by: Paul Bolle <pebolle@tiscali.nl>
---
> Checkpatch in next-21050119 complains:
>     ERROR: Please use git commit description style 'commit <12+ chars of sha1> ("<title line>")' - ie: 'commit fa0ce4035d48 ("ARM: 7162/1: errata: tidy up Kconfig options for PL310 errata workarounds")'
>     #7: 
>     commit fa0ce4035d48 ("ARM: 7162/1: errata: tidy up Kconfig options for
>     
>     total: 1 errors, 0 warnings, 14 lines checked
>     
>     Your patch has style problems, please review.
> 
> Perhaps it doesn't notice the quote spans two lines. Can this be fixed
> please?

Oh bother...

 scripts/checkpatch.pl | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 41223c9..6a3baa0 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2198,6 +2198,13 @@ sub process {
 				 defined $rawlines[$linenr] &&
 				 $rawlines[$linenr] =~ /^\s*\("([^"]+)"\)/) {
 				$orig_desc = $1;
+			} elsif ($line =~ /\bcommit\s+[0-9a-f]{5,}\s+\("[^"]+$/i &&
+				 defined $rawlines[$linenr] &&
+				 $rawlines[$linenr] =~ /^\s*[^"]+"\)/) {
+				$line =~ /\bcommit\s+[0-9a-f]{5,}\s+\("([^"]+)$/i;
+				$orig_desc = $1;
+				$rawlines[$linenr] =~ /^\s*([^"]+)"\)/;
+				$orig_desc .= " " . $1;
 			}
 
 			($id, $description) = git_commit_info($orig_commit,


