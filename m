Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023AbaBKWlv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 17:41:51 -0500
Received: from smtprelay0062.hostedemail.com ([216.40.44.62]:47129 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751071AbaBKWlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 17:41:49 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1543:1593:1594:1711:1730:1747:1777:1792:2197:2199:2393:2559:2562:2828:2915:3138:3139:3140:3141:3142:3354:3653:3865:3866:3867:3868:3871:3874:4321:4605:5007:7652:7903:8957:9010:10004:10400:10848:11026:11473:11658:11914:12043:12291:12438:12517:12519:12555:12683,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: hair33_49c5361b0d84a
X-Filterd-Recvd-Size: 3825
Message-ID: <1392158504.2511.25.camel@joe-AO722>
Subject: [PATCH] checkpatch: Add checks for constant non-octal permissions
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Tue, 11 Feb 2014 14:41:44 -0800
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

umode_t permissions are sometimes mistakenly written
with decimal constants.  Verify that numeric permissions
are using octal.

Add a list of the most commonly used functions and macros
that have umode_t permissions and the argument position.

Add a $Octal type to $Constant.
Allow $LvalOrFunc to be a pointer indirection too.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 36 ++++++++++++++++++++++++++++++++++--
 1 file changed, 34 insertions(+), 2 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 7d3bc2f..544f5e6 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -289,11 +289,12 @@ our $Int_type	= qr{(?i)llu|ull|ll|lu|ul|l|u};
 our $Binary	= qr{(?i)0b[01]+$Int_type?};
 our $Hex	= qr{(?i)0x[0-9a-f]+$Int_type?};
 our $Int	= qr{[0-9]+$Int_type?};
+our $Octal	= qr{0[0-7]+$Int_type?};
 our $Float_hex	= qr{(?i)0x[0-9a-f]+p-?[0-9]+[fl]?};
 our $Float_dec	= qr{(?i)(?:[0-9]+\.[0-9]*|[0-9]*\.[0-9]+)(?:e-?[0-9]+)?[fl]?};
 our $Float_int	= qr{(?i)[0-9]+e-?[0-9]+[fl]?};
 our $Float	= qr{$Float_hex|$Float_dec|$Float_int};
-our $Constant	= qr{$Float|$Binary|$Hex|$Int};
+our $Constant	= qr{$Float|$Binary|$Octal|$Hex|$Int};
 our $Assignment	= qr{\*\=|/=|%=|\+=|-=|<<=|>>=|&=|\^=|\|=|=};
 our $Compare    = qr{<=|>=|==|!=|<|>};
 our $Arithmetic = qr{\+|-|\*|\/|%};
@@ -378,6 +379,15 @@ our @modifierList = (
 	qr{fastcall},
 );
 
+our @mode_permission_funcs = (
+	["module_param", 3],
+	["module_param_(?:array|named|string)", 4],
+	["module_param_array_named", 5],
+	["debugfs_create_(?:file|u8|u16|u32|u64|x8|x16|x32|x64|size_t|atomic_t|bool|blob|regset32|u32_array)", 2],
+	["proc_create(?:_data|)", 2],
+	["(?:CLASS|DEVICE|SENSOR)_ATTR", 2],
+);
+
 our $allowed_asm_includes = qr{(?x:
 	irq|
 	memory
@@ -423,7 +433,7 @@ our $Typecast	= qr{\s*(\(\s*$NonptrType\s*\)){0,1}\s*};
 # Any use must be runtime checked with $^V
 
 our $balanced_parens = qr/(\((?:[^\(\)]++|(?-1))*\))/;
-our $LvalOrFunc	= qr{($Lval)\s*($balanced_parens{0,1})\s*};
+our $LvalOrFunc	= qr{((?:[\&\*]\s*)?$Lval)\s*($balanced_parens{0,1})\s*};
 our $FuncArg = qr{$Typecast{0,1}($LvalOrFunc|$Constant)};
 
 sub deparenthesize {
@@ -4462,6 +4472,28 @@ sub process {
 			WARN("EXPORTED_WORLD_WRITABLE",
 			     "Exporting world writable files is usually an error. Consider more restrictive permissions.\n" . $herecurr);
 		}
+
+		foreach my $entry (@mode_permission_funcs) {
+			my $func = $entry->[0];
+			my $arg_pos = $entry->[1];
+
+			my $skip_args = "";
+			if ($arg_pos > 1) {
+				$arg_pos--;
+				$skip_args = "(?:\\s*$FuncArg\\s*,\\s*){$arg_pos,$arg_pos}";
+			}
+			my $test = "\\b$func\\s*\\(${skip_args}([\\d]+)\\s*[,\\)]";
+			if ($^V && $^V ge 5.10.0 &&
+			    $line =~ /$test/) {
+				my $val = $1;
+				$val = $6 if ($skip_args ne "");
+
+				if ($val =~ /^$Int$/ && $val !~ /^$Octal$/) {
+					ERROR("NON_OCTAL_PERMISSIONS",
+					      "Use octal not decimal permissions\n" . $herecurr);
+				}
+			}
+		}
 	}
 
 	# If we have no input at all, then there is nothing to report on


