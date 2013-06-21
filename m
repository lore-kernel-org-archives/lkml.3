Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161349Ab3FUAt4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 20:49:56 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:48857 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757600Ab3FUAtz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 20:49:55 -0400
Message-ID: <1371775793.16278.16.camel@joe-AO722>
Subject: [PATCH] checkpatch: Ignore existing CamelCase uses from include/...
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>, LKML <linux-kernel@vger.kernel.org>
Date: Thu, 20 Jun 2013 17:49:53 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using --strict, CamelCase uses are described
with CHECK: messages.  These CamelCase uses may
be acceptable and should not generate these messages
when the variable is already defined in a file from
the include/... path.

So, change checkpatch to read all the .h files in
include/... and look for preexisting CamelCase uses
and ignore all of the preexisting CamelCase
#defines, typedefs and functions.

There are currently ~3500 files in include/ and
it takes about 10 cpu seconds on my little netbook
to grep for and preseed these existing uses.

This preseeding is only done once when using --strict
and only when there is a CamelCase use found.

If a .git directory is found, it uses git ls-files include
If not, it uses 'find $root/include -name "*.h"

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 57 ++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 50 insertions(+), 7 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 1034c9b..a753492 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -31,6 +31,7 @@ my $fix = 0;
 my $root;
 my %debug;
 my %ignore_type = ();
+my %camelcase = ();
 my @ignore = ();
 my $help = 0;
 my $configuration_file = ".checkpatch.conf";
@@ -349,7 +350,6 @@ sub build_types {
 }
 build_types();
 
-
 our $Typecast	= qr{\s*(\(\s*$NonptrType\s*\)){0,1}\s*};
 
 # Using $balanced_parens, $LvalOrFunc, or $FuncArg
@@ -369,6 +369,48 @@ sub deparenthesize {
 	return $string;
 }
 
+sub seed_camelcase_file {
+	my ($file) = @_;
+
+	return if (!(-f $file));
+
+	local $/;
+
+	open(my $include_file, '<', "$file")
+	    or warn "$P: Can't read '$file' $!\n";
+	my $text = <$include_file>;
+	close($include_file);
+
+	my @lines = split('\n', $text);
+
+	foreach my $line (@lines) {
+		next if ($line !~ /(?:[A-Z][a-z]|[a-z][A-Z])/);
+		if ($line =~ /^[ \t]*(?:#[ \t]*define|typedef\s+$Type)\s+(\w*(?:[A-Z][a-z]|[a-z][A-Z])\w*)\s+/) {
+			$camelcase{$1} = 1;
+		}
+	        elsif ($line =~ /^\s*$Declare\s+(\w*(?:[A-Z][a-z]|[a-z][A-Z])\w*)\s*\(/) {
+			$camelcase{$1} = 1;
+		}
+	}
+}
+
+my $camelcase_seeded = 0;
+sub seed_camelcase_includes {
+	return if ($camelcase_seeded);
+
+	my $files;
+	if (-d ".git") {
+		$files = `git ls-files include`;
+	} else {
+		$files = `find $root/include -name "*.h"`;
+	}
+	my @include_files = split('\n', $files);
+	foreach my $file (@include_files) {
+		seed_camelcase_file($file);
+	}
+	$camelcase_seeded = 1;
+}
+
 $chk_signoff = 0 if ($file);
 
 my @rawlines = ();
@@ -1448,7 +1490,6 @@ sub process {
 	my %suppress_export;
 	my $suppress_statement = 0;
 
-	my %camelcase = ();
 
 	# Pre-scan the patch sanitizing the lines.
 	# Pre-scan the patch looking for any __setup documentation.
@@ -3198,11 +3239,13 @@ sub process {
 #Ignore Page<foo> variants
 			    $var !~ /^(?:Clear|Set|TestClear|TestSet|)Page[A-Z]/ &&
 #Ignore SI style variants like nS, mV and dB (ie: max_uV, regulator_min_uA_show)
-			    $var !~ /^(?:[a-z_]*?)_?[a-z][A-Z](?:_[a-z_]+)?$/ &&
-			    !defined $camelcase{$var}) {
-				$camelcase{$var} = 1;
-				CHK("CAMELCASE",
-				    "Avoid CamelCase: <$var>\n" . $herecurr);
+			    $var !~ /^(?:[a-z_]*?)_?[a-z][A-Z](?:_[a-z_]+)?$/) {
+				seed_camelcase_includes() if ($check);
+				if (!defined $camelcase{$var}) {
+					$camelcase{$var} = 1;
+					CHK("CAMELCASE",
+					    "Avoid CamelCase: <$var>\n" . $herecurr);
+				}
 			}
 		}
 


