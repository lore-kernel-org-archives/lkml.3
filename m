Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277Ab3H1OU0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 10:20:26 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:42924 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753852Ab3H1OUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 10:20:24 -0400
Message-ID: <1377655732.3619.19.camel@joe-AO722>
Subject: [PATCH] checkpatch:  Add test for positional misuse of section
 specifiers like __initdata
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Guenter Roeck <linux@roeck-us.net>, Jean Delvare <khali@linux-fr.org>,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Tue, 27 Aug 2013 19:08:52 -0700
Mime-Version: 1.0
X-Mailer: Evolution 3.6.4-0ubuntu1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As discussed recently on the arm [1] and lm-sensors [2] lists, it is
possible to use section markers on variables in a way which gcc doesn't
understand (or at least not the way the developer intended):

static struct __initdata samsung_pll_clock exynos4_plls[nr_plls] = {

does NOT put exynos4_plls in the .initdata section. The __initdata
marker can be virtually anywhere on the line, EXCEPT right after
"struct". The preferred location is before the "=" sign if there is
one, or before the trailing ";" otherwise.

[1] http://permalink.gmane.org/gmane.linux.ports.arm.kernel/258149
[2] http://lists.lm-sensors.org/pipermail/lm-sensors/2013-August/039836.html

So, update checkpatch to find these misuses and report an
error when it's immediately after struct or union, and a
warning when it's otherwise not immediately before the ; or =.

A similar patch was suggested by Andi Kleen
https://lkml.org/lkml/2013/8/5/648

Suggested-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Joe Perches <joe@perches.com>
Tested-by: Guenter Roeck <linux@roeck-us.net>
---
 scripts/checkpatch.pl | 47 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 46 insertions(+), 1 deletion(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 9ba4fc4..47016c3 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -242,6 +242,8 @@ our $Sparse	= qr{
 			__rcu
 		}x;
 
+our $InitAttribute = qr{__(?:mem|cpu|dev|net_|)(?:initdata|initconst|init\b)};
+
 # Notes to $Attribute:
 # We need \b after 'init' otherwise 'initconst' will cause a false positive in a check
 our $Attribute	= qr{
@@ -262,7 +264,7 @@ our $Attribute	= qr{
 			__deprecated|
 			__read_mostly|
 			__kprobes|
-			__(?:mem|cpu|dev|)(?:initdata|initconst|init\b)|
+			$InitAttribute|
 			____cacheline_aligned|
 			____cacheline_aligned_in_smp|
 			____cacheline_internodealigned_in_smp|
@@ -292,6 +294,7 @@ our $Operators	= qr{
 		  }x;
 
 our $NonptrType;
+our $NonptrTypeWithAttr;
 our $Type;
 our $Declare;
 
@@ -354,6 +357,12 @@ our @typeList = (
 	qr{${Ident}_handler},
 	qr{${Ident}_handler_fn},
 );
+our @typeListWithAttr = (
+	@typeList,
+	qr{struct\s+$InitAttribute\s+$Ident},
+	qr{union\s+$InitAttribute\s+$Ident},
+);
+
 our @modifierList = (
 	qr{fastcall},
 );
@@ -367,6 +376,7 @@ our $allowed_asm_includes = qr{(?x:
 sub build_types {
 	my $mods = "(?x:  \n" . join("|\n  ", @modifierList) . "\n)";
 	my $all = "(?x:  \n" . join("|\n  ", @typeList) . "\n)";
+	my $allWithAttr = "(?x:  \n" . join("|\n  ", @typeListWithAttr) . "\n)";
 	$Modifier	= qr{(?:$Attribute|$Sparse|$mods)};
 	$NonptrType	= qr{
 			(?:$Modifier\s+|const\s+)*
@@ -377,6 +387,15 @@ sub build_types {
 			)
 			(?:\s+$Modifier|\s+const)*
 		  }x;
+	$NonptrTypeWithAttr	= qr{
+			(?:$Modifier\s+|const\s+)*
+			(?:
+				(?:typeof|__typeof__)\s*\([^\)]*\)|
+				(?:$typeTypedefs\b)|
+				(?:${allWithAttr}\b)
+			)
+			(?:\s+$Modifier|\s+const)*
+		  }x;
 	$Type	= qr{
 			$NonptrType
 			(?:(?:\s|\*|\[\])+\s*const|(?:\s|\*|\[\])+|(?:\s*\[\s*\])+)?
@@ -3706,6 +3725,32 @@ sub process {
 			}
 		}
 
+sub string_find_replace {
+	my ($string, $find, $replace) = @_;
+
+	$string =~ s/$find/$replace/g;
+
+	return $string;
+}
+
+# check for bad placement of section $InitAttribute (e.g.: __initdata)
+		if ($line =~ /(\b$InitAttribute\b)/) {
+			my $attr = $1;
+			if ($line =~ /^\+\s*static\s+(?:const\s+)?(?:$attr\s+)?($NonptrTypeWithAttr)\s+(?:$attr\s+)?($Ident(?:\[[^]]*\])?)\s*[=;]/) {
+				my $ptr = $1;
+				my $var = $2;
+				if ((($ptr =~ /\b(union|struct)\s+$attr\b/ &&
+				      ERROR("MISPLACED_INIT",
+					    "$attr should be placed after $var\n" . $herecurr)) ||
+				     ($ptr !~ /\b(union|struct)\s+$attr\b/ &&
+				      WARN("MISPLACED_INIT",
+					   "$attr should be placed after $var\n" . $herecurr))) &&
+				    $fix) {
+					$fixed[$linenr - 1] =~ s/(\bstatic\s+(?:const\s+)?)(?:$attr\s+)?($NonptrTypeWithAttr)\s+(?:$attr\s+)?($Ident(?:\[[^]]*\])?)\s*([=;])\s*/"$1" . trim(string_find_replace($2, "\\s*$attr\\s*", " ")) . " " . trim(string_find_replace($3, "\\s*$attr\\s*", "")) . " $attr" . ("$4" eq ";" ? ";" : " = ")/e;
+				}
+			}
+		}
+
 # prefer usleep_range over udelay
 		if ($line =~ /\budelay\s*\(\s*(\d+)\s*\)/) {
 			# ignore udelay's < 10, however


