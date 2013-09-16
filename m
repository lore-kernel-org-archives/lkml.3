Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932177Ab3IPCfA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 22:35:00 -0400
Received: from smtprelay0122.hostedemail.com ([216.40.44.122]:36374 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755568Ab3IPCe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 22:34:59 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1431:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2197:2199:2393:2559:2562:2693:2828:3138:3139:3140:3141:3142:3353:3653:3865:3866:3867:3868:3870:3872:4250:4321:5007:7652:8957:9592:10004:10400:10848:11232:11658:11914:12043:12291:12296:12517:12519:12555:12683,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: tree36_82799bf9f6a4a
X-Filterd-Recvd-Size: 3382
Message-ID: <1379298894.3641.8.camel@joe-AO722>
Subject: [PATCH v2] checkpatch: add rules to check init attribute and const
 defects
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: apw@canonical.com, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, Andi Kleen <andi@firstfloor.org>
Date: Sun, 15 Sep 2013 19:34:54 -0700
In-Reply-To: <20130915210433.GV18242@two.firstfloor.org>
References: <1375740651-7716-1-git-send-email-andi@firstfloor.org>
	 <1379276783.3641.3.camel@joe-AO722>
	 <20130915210433.GV18242@two.firstfloor.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

People get this regularly wrong and it breaks the LTO builds,
as it causes a section attribute conflict.

Add --fix capability too.

Original-patch-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Joe Perches <joe@perches.com>
---

V2: Move it closer to the other attribute check
    and add the --fix options too.

 scripts/checkpatch.pl | 36 ++++++++++++++++++++++++++++++++++--
 1 file changed, 34 insertions(+), 2 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 47016c3..69443d9 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -241,8 +241,11 @@ our $Sparse	= qr{
 			__ref|
 			__rcu
 		}x;
-
-our $InitAttribute = qr{__(?:mem|cpu|dev|net_|)(?:initdata|initconst|init\b)};
+our $InitAttributePrefix = qr{__(?:mem|cpu|dev|net_|)};
+our $InitAttributeData = qr{$InitAttributePrefix(?:initdata\b)};
+our $InitAttributeConst = qr{$InitAttributePrefix(?:initconst\b)};
+our $InitAttributeInit = qr{$InitAttributePrefix(?:init\b)};
+our $InitAttribute = qr{$InitAttributeData|$InitAttributeConst|$InitAttributeInit};
 
 # Notes to $Attribute:
 # We need \b after 'init' otherwise 'initconst' will cause a false positive in a check
@@ -3751,6 +3754,35 @@ sub string_find_replace {
 			}
 		}
 
+# check for $InitAttributeData (ie: __initdata) with const
+		if ($line =~ /\bconst\b/ && $line =~ /($InitAttributeData)/) {
+			my $attr = $1;
+			$attr =~ /($InitAttributePrefix)(.*)/;
+			my $attr_prefix = $1;
+			my $attr_type = $2;
+			if (ERROR("INIT_ATTRIBUTE",
+				  "Use of const init definition must use ${attr_prefix}initconst\n" . $herecurr) &&
+			    $fix) {
+				$fixed[$linenr - 1] =~
+				    s/$InitAttributeData/${attr_prefix}initconst/;
+			}
+		}
+
+# check for $InitAttributeConst (ie: __initconst) without const
+		if ($line !~ /\bconst\b/ && $line =~ /($InitAttributeConst)/) {
+			my $attr = $1;
+			if (ERROR("INIT_ATTRIBUTE",
+				  "Use of $attr requires a separate use of const\n" . $herecurr) &&
+			    $fix) {
+				my $lead = $fixed[$linenr - 1] =~
+				    /(^\+\s*(?:static\s+))/;
+				$lead = rtrim($1);
+				$lead = "$lead " if ($lead !~ /^\+$/);
+				$lead = "${lead}const ";
+				$fixed[$linenr - 1] =~ s/(^\+\s*(?:static\s+))/$lead/;
+			}
+		}
+
 # prefer usleep_range over udelay
 		if ($line =~ /\budelay\s*\(\s*(\d+)\s*\)/) {
 			# ignore udelay's < 10, however


