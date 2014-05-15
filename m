Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232AbaEOOn6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 10:43:58 -0400
Received: from mail-bn1blp0183.outbound.protection.outlook.com ([207.46.163.183]:24123
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752793AbaEOOn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 10:43:57 -0400
From: Ivo Sieben <meltedpianoman@gmail.com>
To: <linux-kernel@vger.kernel.org>, Andy Whitcroft <apw@canonical.com>,
        "Joe Perches" <joe@perches.com>
CC: Ivo Sieben <meltedpianoman@gmail.com>
Subject: [PATCH] [checkpatch.pl] Suspicious indentation detection after conditional statement
Date: Thu, 15 May 2014 16:43:45 +0200
Message-ID: <1400165025-8688-1-git-send-email-meltedpianoman@gmail.com>
X-Mailer: git-send-email 1.7.9.5
X-OriginalArrivalTime: 15 May 2014 14:43:47.0461 (UTC) FILETIME=[1421AB50:01CF704C]
X-EOPAttributedMessage: 0
X-Matching-Connectors: 130446386361211780;(ede6e1f7-176b-4c99-8942-08d118f12784);()
X-Forefront-Antispam-Report: CIP:193.138.13.20;CTRY:DE;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(679001)(689001)(6009001)(189002)(199002)(87572001)(82202001)(50466002)(50986999)(88136002)(92566001)(48376002)(36756003)(87286001)(20776003)(99396002)(19580395003)(85852003)(102836001)(83072002)(92726001)(47776003)(62966002)(89996001)(53416003)(33646001)(87936001)(19580405001)(44976005)(86362001)(93916002)(55446002)(50226001)(31966008)(73972005)(80022001)(73392001)(79102001)(61266001)(74502001)(77156001)(46102001)(77982001)(81342001)(71816001)(81442001)(4396001)(81542001)(74662001);DIR:OUT;SFP:;SCL:1;SRVR:BN1AFFO11HUB012;H:oce-exbhcs03b.oce.net;FPR:;MLV:nov;PTR:smtp02.oce.com;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Forefront-PRVS: 0212BDE3BE
Authentication-Results: spf=softfail (sender IP is 193.138.13.20)
 smtp.mailfrom=meltedpianoman@gmail.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Raise a SUSPICIOUS_CODE_INDENT warning when unexpected indentation is found
after a conditional statement. This can be used to find missing braces or
wrong indentation in/after a conditional statement.

For example the following error is caught;

	if (foo)
		bar();
		return;

Which can be either intended by the programmer as:

	if (foo)
		bar();
	return;

or
	if (foo) {
		bar();
		return;
	}

Signed-off-by: Ivo Sieben <meltedpianoman@gmail.com>
---

Request for comments:
I think this is a nice warning to have, since you can get into a buggy situation
when you want to add extra statements to a one line condition, but you forget
to add the {} around the multiline statement block.

 scripts/checkpatch.pl |   41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index e7bca89..3ca3923 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2565,6 +2565,47 @@ sub process {
 				WARN("SUSPECT_CODE_INDENT",
 				     "suspect code indent for conditional statements ($indent, $sindent)\n" . $herecurr . "$stat_real\n");
 			}
+
+# Also check if the next statement after the previous condition has the same indent
+			my ($stat_next, undef, $line_nr_next_next) =
+				ctx_statement_block($line_nr_next, $remain_next, $off_next);
+			my $s_next = $stat_next;
+
+			# Remove line prefixes
+			$s_next =~ s/\n./\n/gs;
+
+			# Remove any comments
+			$s_next =~ s/$;//g;
+
+			# Skip this check for in case next statement starts with 'else'
+			if ($s_next !~ /\s*\belse\b/) {
+
+				# Remove while that belongs to a do {} while
+				if ($stat =~ /\bdo\b/) {
+					$s_next =~ s/^.*\bwhile\b\s*($balanced_parens)\s*?//;
+				}
+
+				# Remove blank lines
+				$s_next =~ s/\s*\\?\n//g;
+
+				# Get the real next lines
+				my $next_nof_lines = $line_nr_next_next - $line_nr_next;
+				my $stat_next_real = raw_line($line_nr_next, $next_nof_lines);
+				if (!defined($stat_next_real)) {
+					$stat_next_real = "";
+				} elsif ($next_nof_lines > 1) {
+					$stat_next_real = "[...]\n$stat_next_real";
+				}
+				my (undef, $nindent) = line_stats('+' . $s_next);
+
+				#print "stat_next<$stat_next> stat<$stat> indent<$indent> nindent<$nindent> s_next<$s_next> stat_next_real<$stat_next_real>\n";
+
+				if ($nindent > $indent) {
+					WARN("SUSPICIOUS_CODE_INDENT",
+					     "suspicious code indentation after conditional statements\n" .
+					     $herecurr . "$stat_real\n$stat_next_real\n");
+				}
+			}
 		}
 
 		# Track the 'values' across context and added lines.
-- 
1.7.9.5

