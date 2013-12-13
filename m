Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391Ab3LMTG2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 14:06:28 -0500
Received: from smtprelay0052.hostedemail.com ([216.40.44.52]:46288 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752606Ab3LMTG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 14:06:26 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1543:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2559:2562:2828:2898:3138:3139:3140:3141:3142:3354:3653:3865:3866:3867:3868:3870:3871:3872:3874:4321:5007:7652:7688:7903:10004:10400:10848:11026:11232:11658:11914:12043:12291:12296:12438:12517:12519:12555:13161:13229:21060,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: fan50_54a0a512a7a2a
X-Filterd-Recvd-Size: 3903
Message-ID: <1386961580.2479.42.camel@joe-AO722>
Subject: [PATCH] checkpatch: Attempt to find missing switch/case break;
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@shadowen.org>, Jiri Kosina <jkosina@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Dave Jones <davej@redhat.com>
Date: Fri, 13 Dec 2013 11:06:20 -0800
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

switch case statements missing a break statement are an unfortunately
common error.

e.g.:
commit 4a2c94c9b6c0 ("HID: kye: Add report fixup for Genius Manticore Keyboard")

case blocks should end in a break/return/goto/continue.

If a fall-through is used, it should have a comment showing
that it is intentional.  Ideally that comment should be
something like: "/* fall-through */"

Add a test to look for missing break statements.

This looks only at the context lines before an inserted case
so it's possible to have false positives when the context
contains a close brace and the break is before the brace
and not part of the patch context.

Looking at recent patches, this is a pretty rare occurrence.
The normal kernel style uses a break as the last line of the
previous block.

Signed-off-by: Joe Perches <joe@perche.com>
---

Also tested on all files in drivers/hid/

There is a hit for drivers/hid/hid-microsoft.c

I've no idea what's right here but adding a break or return
or a "fall-through" comment would be nicer.

static int ms_ergonomy_kb_quirk(struct hid_input *hi, struct hid_usage *usage,
		unsigned long **bit, int *max)
{
	struct input_dev *input = hi->input;

	switch (usage->hid & HID_USAGE) {
	case 0xfd06: ms_map_key_clear(KEY_CHAT);	break;
	case 0xfd07: ms_map_key_clear(KEY_PHONE);	break;
	case 0xff05:
		set_bit(EV_REP, input->evbit);
		ms_map_key_clear(KEY_F13);
		set_bit(KEY_F14, input->keybit);
		set_bit(KEY_F15, input->keybit);
		set_bit(KEY_F16, input->keybit);
		set_bit(KEY_F17, input->keybit);
		set_bit(KEY_F18, input->keybit);
	default:
		return 0;
	}
	return 1;
}

 scripts/checkpatch.pl | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 38be5d5..94225d2 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -4132,6 +4132,31 @@ sub process {
 			}
 		}
 
+# check for case / default statements not preceeded by break/fallthrough/switch
+		if ($line =~ /^.\s*(?:case\s+(?:$Ident|$Constant)\s*|default):/) {
+			my $has_break = 0;
+			my $has_statement = 0;
+			my $count = 0;
+			my $prevline = $linenr;
+			while ($prevline > 1 && $count < 3 && !$has_break) {
+				$prevline--;
+				my $rline = $rawlines[$prevline - 1];
+				my $fline = $lines[$prevline - 1];
+				last if ($fline =~ /^\@\@/);
+				next if ($fline =~ /^\-/);
+				next if ($fline =~ /^.(?:\s*(?:case\s+(?:$Ident|$Constant)[\s$;]*|default):[\s$;]*)*$/);
+				$has_break = 1 if ($rline =~ /fall[\s_-]*(through|thru)/i);
+				next if ($fline =~ /^.[\s$;]*$/);
+				$has_statement = 1;
+				$count++;
+				$has_break = 1 if ($fline =~ /\bswitch\b|\b(?:break\s*;[\s$;]*$|return\b|goto\b|continue\b)/);
+			}
+			if (!$has_break && $has_statement) {
+				WARN("MISSING_BREAK",
+				     "Possible switch case/default not preceeded by break or fallthrough comment\n" . $herecurr);
+			}
+		}
+
 # check for switch/default statements without a break;
 		if ($^V && $^V ge 5.10.0 &&
 		    defined $stat &&


