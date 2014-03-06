Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153AbaCFX2r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 18:28:47 -0500
Received: from smtprelay0081.hostedemail.com ([216.40.44.81]:55479 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750834AbaCFX2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 18:28:45 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3865:3866:3867:3872:4321:4605:5007:7652:10004:10400:10848:11026:11473:11658:11914:12043:12517:12519:12555:12679:13069:13161:13229:13255:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: lamp04_4c13efa71f12a
X-Filterd-Recvd-Size: 2773
Message-ID: <1394148520.16156.8.camel@joe-AO722>
Subject: [PATCH] checkpatch: net and drivers/net: Warn on missing blank line
 after variable declaration
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, kys@microsoft.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, apw@canonical.com
Date: Thu, 06 Mar 2014 15:28:40 -0800
In-Reply-To: <20140306.142919.763823800315842610.davem@davemloft.net>
References: <1394104358-23438-1-git-send-email-kys@microsoft.com>
	 <1394104390-23477-1-git-send-email-kys@microsoft.com>
	 <20140306.142919.763823800315842610.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Networking prefers this style, so warn when it's not used.

Networking uses:

void foo(int bar)
{
	int baz;

	code...
}

not

void foo(int bar)
{
	int baz;
	code...
}

There are a limited number of false positives when using
macros to declare variables like:

WARNING: networking uses a blank line after declarations
#330: FILE: net/ipv4/inet_hashtables.c:330:
+	int dif = sk->sk_bound_dev_if;
+	INET_ADDR_COOKIE(acookie, saddr, daddr)

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 3d3ef2f..a6e3048 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2248,6 +2248,21 @@ sub process {
 			     "networking block comments put the trailing */ on a separate line\n" . $herecurr);
 		}
 
+# check for missing blank lines after declarations
+		if ($realfile =~ m@^(drivers/net/|net/)@ &&
+		    $prevline =~ /^\+\s+$Declare\s+$Ident/ &&
+		    !($prevline =~ /(?:$Compare|$Assignment|$Operators)\s*$/ ||
+		      $prevline =~ /(?:\{\s*|\\)$/) &&		#extended lines
+		    $sline =~ /^\+\s+/ &&			#Not at char 1
+		    !($sline =~ /^\+\s+$Declare/ ||
+		      $sline =~ /^\+\s+$Ident\s+$Ident/ ||	#eg: typedef foo
+		      $sline =~ /^\+\s+(?:union|struct|enum|typedef)\b/ ||
+		      $sline =~ /^\+\s+(?:$|[\{\}\.\#\"\?\:\(])/ ||
+		      $sline =~ /^\+\s+\(?\s*(?:$Compare|$Assignment|$Operators)/)) {
+			WARN("SPACING",
+			     "networking uses a blank line after declarations\n" . $hereprev);
+		}
+
 # check for spaces at the beginning of a line.
 # Exceptions:
 #  1) within comments


