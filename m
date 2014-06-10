Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245AbaFJQzq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 12:55:46 -0400
Received: from smtprelay0038.hostedemail.com ([216.40.44.38]:42858 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752041AbaFJQzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 12:55:45 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:1981:2194:2197:2199:2200:2393:2559:2562:2828:3138:3139:3140:3141:3142:3354:3653:3865:3866:3868:3870:3871:3874:4250:4321:4470:5007:6119:6120:7652:7903:8603:8957:9040:10004:10400:10848:11026:11658:11914:12043:12517:12519:12555:13095:13146:13161:13181:13229:13230,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: soup76_31e5810fd3934
X-Filterd-Recvd-Size: 3197
Message-ID: <1402419340.30479.18.camel@joe-AO725>
Subject: [RFC PATCH] checkpatch: Attempt to find unnecessary 'out of memory'
 messages
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Andy Whitcroft <apw@shadowen.org>, LKML <linux-kernel@vger.kernel.org>,
        Julia Lawall <julia.lawall@lip6.fr>
Date: Tue, 10 Jun 2014 09:55:40 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Logging messages that show some type of "out of memory" error
are generally unnecessary as there is a generic message and
a stack dump done by the memory subsystem.

These messages generally increase kernel size without much
added value.

Emit a warning on these types of messages.

This test looks for any inserted message function, then looks
at the previous line for an "if (!foo)" or "if (foo == NULL)"
test and then looks at the preceding statement for an allocation
function like "foo = kmalloc()"

ie: this code matches:

	foo = kmalloc();
	if (foo == NULL) {
		printk("Out of memory\n");
		return -ENOMEM;
	}

This test is very crude and incomplete.

This test can miss quite a lot of of OOM messages that do not
have this specific form.

ie: this code does not match:

	foo = kmalloc();
	if (!foo) {
		rtn = -ENOMEM;
		printk("Out of memory!\n");
		goto out;
	}

This test could also be a false positive when the logging
message itself does not specify anything about memory, but
I did not find any false positives in my limited testing.

spatch could be a better solution but correctness seems
non-trivial for that tool too.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 010b18e..64bee42 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -4009,6 +4009,23 @@ sub process {
 			}
 		}
 
+# check for unnecessary "Out of Memory" messages
+		if ($line =~ /^\+.*\b$logFunctions\s*\(/ &&
+		    $prevline =~ /^[ \+]\s*if\s*\(\s*(\!\s*|NULL\s*==\s*)?($Lval)(\s*==\s*NULL\s*)?\s*\)/ &&
+		    (defined $1 || defined $3) &&
+		    $linenr > 3) {
+			my $testval = $2;
+			my $testline = $lines[$linenr - 3];
+
+			my ($s, $c) = ctx_statement_block($linenr - 3, $realcnt, 0);
+#			print("line: <$line>\nprevline: <$prevline>\ns: <$s>\nc: <$c>\n\n\n");
+
+			if ($c =~ /(?:^|\n)[ \+]\s*(?:$Type\s*)?\Q$testval\E\s*=\s*(?:\([^\)]*\)\s*)?\s*(?:devm_)?(?:[kv][czm]alloc(?:_node|_array)?\b|kstrdup|(?:dev_)?alloc_skb)/) {
+				WARN("OOM_MESSAGE",
+				     "Possible unnecessary 'out of memory' message\n" . $hereprev);
+			}
+		}
+
 # check for bad placement of section $InitAttribute (e.g.: __initdata)
 		if ($line =~ /(\b$InitAttribute\b)/) {
 			my $attr = $1;


