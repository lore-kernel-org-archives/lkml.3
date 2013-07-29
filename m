Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384Ab3G2UGK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 16:06:10 -0400
Received: from mga03.intel.com ([143.182.124.21]:39273 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754147Ab3G2UGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 16:06:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,772,1367996400"; 
   d="scan'208";a="338632671"
Subject: [PATCH] checkpatch: enforce sane perl version
To: Andy Whitcroft <apw@canonical.com>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Mon, 29 Jul 2013 13:06:06 -0700
Message-Id: <20130729200606.2651EE1E@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

I got a bug report from a couple of users who said
checkpatch.pl was broken for them.  It was erroring out on
fairly random lines most commonly with messages like:

	Nested quantifiers in regex; marked by <--HERE in m/(\((?:[^\(\)]++ <-- HERE |(?-1))*\))/ at ./checkpatch.pl line 340.

The bug reporter was running a version of perl 5.8 which was
end-of-lifed in 2008: http://www.cpan.org/src/.  Versions of perl
this old are at _best_ quite untested.  At worst, they are crusty
and known to be completely broken.

If folks have a system _that_ old, then we should have mercy on
them and give them a half-decent error message rather than fail
with nutty error messages.

This patch enforces that checkpatch.pl is run with perl 5.10,
which was end-of-lifed in 2009.  The new --ignore-perl-version
command-line switch will let folks override this if they want.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
---

 linux.git-davehans/scripts/checkpatch.pl |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-enforce-perl-version scripts/checkpatch.pl
--- linux.git/scripts/checkpatch.pl~checkpatch-enforce-perl-version	2013-07-29 10:54:11.525133577 -0700
+++ linux.git-davehans/scripts/checkpatch.pl	2013-07-29 12:52:41.461121333 -0700
@@ -37,6 +37,8 @@ my @ignore = ();
 my $help = 0;
 my $configuration_file = ".checkpatch.conf";
 my $max_line_length = 80;
+my $ignore_perl_version = 0;
+my $minimum_perl_version = 5.10.0;
 
 sub help {
 	my ($exitcode) = @_;
@@ -71,6 +73,8 @@ Options:
                              "<inputfile>.EXPERIMENTAL-checkpatch-fixes"
                              with potential errors corrected to the preferred
                              checkpatch style
+  --ignore-perl-version      override checking of perl version.  expect
+                             runtime errors.
   -h, --help, --version      display this help and exit
 
 When FILE is - read standard input.
@@ -123,6 +127,7 @@ GetOptions(
 	'mailback!'	=> \$mailback,
 	'summary-file!'	=> \$summary_file,
 	'fix!'		=> \$fix,
+	'ignore-perl-version!' => \$ignore_perl_version,
 	'debug=s'	=> \%debug,
 	'test-only=s'	=> \$tst_only,
 	'h|help'	=> \$help,
@@ -133,6 +138,13 @@ help(0) if ($help);
 
 my $exit = 0;
 
+if ($^V && $^V lt $minimum_perl_version) {
+	printf "$P: requires at least perl version %vd\n", $minimum_perl_version;
+	if (!$ignore_perl_version) {
+		exit(1);
+	}
+}
+
 if ($#ARGV < 0) {
 	print "$P: no input files\n";
 	exit(1);
_
