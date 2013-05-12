Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629Ab3ELQSE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 12:18:04 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:46667 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754559Ab3ELQSB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 12:18:01 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] checkpatch: Warn when using gcc's binary constant extension
Date: Sun, 12 May 2013 09:17:49 -0700
Message-Id: <a82ac91a1cd99ce20092c5459dde88932f75a779.1368375304.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <a8ee80e0453181086992b11d34de77fb06609fe5.1368375304.git.joe@perches.com>
References: <a8ee80e0453181086992b11d34de77fb06609fe5.1368375304.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The gcc extension for binary constants that start with 0b
is only supported with gcc version 4.3 or higher.

The kernel can still be compiled with earlier versions of
gcc, so have checkpatch emit a warning for these constants.

Restructure checkpatch's constant finding code a bit to
support finding these binary constants.

Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index f1aad19..517da26 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -230,11 +230,15 @@ our $Inline	= qr{inline|__always_inline|noinline};
 our $Member	= qr{->$Ident|\.$Ident|\[[^]]*\]};
 our $Lval	= qr{$Ident(?:$Member)*};
 
+our $Int_type	= qr{(?i)llu|ull|ll|lu|ul|l|u};
+our $Binary	= qr{(?i)0b[01]+$Int_type?};
+our $Hex	= qr{(?i)0x[0-9a-f]+$Int_type?};
+our $Int	= qr{[0-9]+$Int_type?};
 our $Float_hex	= qr{(?i)0x[0-9a-f]+p-?[0-9]+[fl]?};
 our $Float_dec	= qr{(?i)(?:[0-9]+\.[0-9]*|[0-9]*\.[0-9]+)(?:e-?[0-9]+)?[fl]?};
 our $Float_int	= qr{(?i)[0-9]+e-?[0-9]+[fl]?};
 our $Float	= qr{$Float_hex|$Float_dec|$Float_int};
-our $Constant	= qr{$Float|(?i)(?:0x[0-9a-f]+|[0-9]+)[ul]*};
+our $Constant	= qr{$Float|$Binary|$Hex|$Int};
 our $Assignment	= qr{\*\=|/=|%=|\+=|-=|<<=|>>=|&=|\^=|\|=|=};
 our $Compare    = qr{<=|>=|==|!=|<|>};
 our $Operators	= qr{
@@ -2934,9 +2938,17 @@ sub process {
 			}
 		}
 
-#CamelCase
+#Specific variable tests
 		while ($line =~ m{($Constant|$Lval)}g) {
 			my $var = $1;
+
+#gcc binary extension
+			if ($var =~ /^$Binary$/) {
+				WARN("GCC_BINARY_CONSTANT",
+				     "Avoid gcc v4.3+ binary constant extension: <$var>\n" . $herecurr);
+			}
+
+#CamelCase
 			if ($var !~ /$Constant/ &&
 			    $var =~ /[A-Z][a-z]|[a-z][A-Z]/ &&
 			    $var !~ /"^(?:Clear|Set|TestClear|TestSet|)Page[A-Z]/ &&
-- 
1.8.1.2.459.gbcd45b4.dirty

