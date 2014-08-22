Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383AbaHVAK6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 20:10:58 -0400
Received: from smtprelay0192.hostedemail.com ([216.40.44.192]:49817 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751512AbaHVAK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 20:10:56 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:967:968:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1431:1437:1515:1516:1518:1535:1544:1593:1594:1605:1711:1730:1747:1777:1792:2197:2199:2393:2525:2553:2560:2563:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3622:3653:3657:3865:3866:3867:3868:3870:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:4605:4641:5007:6119:6248:6299:7652:7875:7903:8531:8599:8985:9010:9025:9040:93
X-HE-Tag: book59_24c662c53b72a
X-Filterd-Recvd-Size: 5282
Message-ID: <1408666251.22832.33.camel@joe-AO725>
Subject: Re: [PATCH] checkpatch: look for common misspellings
From: Joe Perches <joe@perches.com>
To: Kees Cook <keescook@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Andy Whitcroft <apw@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Antti Palosaari <crope@iki.fi>, Masanari Iida <standby24x7@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-doc <linux-doc@vger.kernel.org>
Date: Thu, 21 Aug 2014 17:10:51 -0700
In-Reply-To: <CAGXu5jJmp4-sposMxjTobEj0xzueQY54OzvdDQg-GC-HhJuBwQ@mail.gmail.com>
References: <20140821162050.GA1323@www.outflux.net>
	 <1408641520.23250.71.camel@joe-AO725>
	 <CAGXu5jJmp4-sposMxjTobEj0xzueQY54OzvdDQg-GC-HhJuBwQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-08-21 at 18:01 -0500, Kees Cook wrote:
> On Thu, Aug 21, 2014 at 12:18 PM, Joe Perches <joe@perches.com> wrote:
> > On Thu, 2014-08-21 at 09:20 -0700, Kees Cook wrote:
> >> Check for misspellings, based on Debian's lintian list. Several false
> >> positives were removed, and several additional words added that were
> >> common in the kernel:
> > []
> >> diff --git a/MAINTAINERS b/MAINTAINERS
> > []
> >> @@ -2311,6 +2311,7 @@ M:      Andy Whitcroft <apw@canonical.com>
> >>  M:   Joe Perches <joe@perches.com>
> >>  S:   Maintained
> >>  F:   scripts/checkpatch.pl
> >> +F:   scripts/spelling.txt
> >
> > I don't want to be responsible for misspellings.
> >
> > Maybe this should be moved to another section
> > and you could be added as a maintainer for that.
> 
> Okay, sure. Happy to do so. Or maybe some -docs folks want to join me? :)

Masanari Iida does a lot of these (added to cc)
Maybe he's interested in helping out or adding
his collection of misspellings to spelling.txt.

Maybe Geert Uytterhoeven too (also cc'd)

Maybe the lintian list should also be added if it's
around somewhere instead of trying to duplicate it.

http://anonscm.debian.org/cgit/lintian/lintian.git/tree/data/spelling/corrections

[]

> Cool, let me grok your suggested patch and reply. Thanks for looking this over!

A defect was it checked only for all lower-case uses.

Here's what I have now.  It:

o relocates the check above specific file extension tests
o checks lines in the commit log and any added lines
o checks case-insensitive misspellings
o does Proper case corrections for start of sentences
o adds a working --fix option.

Maybe you could merge it with your other changes.

You could add some tag like improved-by: / signed-off-by,
acked-by: for me if you want.

---
 scripts/checkpatch.pl | 41 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 40 insertions(+), 1 deletion(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index b385bcb..9075ed5 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -9,7 +9,8 @@ use strict;
 use POSIX;
 
 my $P = $0;
-$P =~ s@.*/@@g;
+$P =~ s@(.*)/@@g;
+my $D = $1;
 
 my $V = '0.32';
 
@@ -43,6 +44,7 @@ my $configuration_file = ".checkpatch.conf";
 my $max_line_length = 80;
 my $ignore_perl_version = 0;
 my $minimum_perl_version = 5.10.0;
+my $spelling_file = "$D/spelling.txt";
 
 sub help {
 	my ($exitcode) = @_;
@@ -429,6 +431,29 @@ our $allowed_asm_includes = qr{(?x:
 )};
 # memory.h: ARM has a custom one
 
+# Load common spelling mistakes and build regular expression list.
+my $misspellings;
+my @spelling_list;
+my %spelling_fix;
+open(my $spelling, '<', $spelling_file)
+    or die "$P: Can't open $spelling_file for reading: $!\n";
+while (<$spelling>) {
+	my $line = $_;
+
+	$line =~ s/\s*\n?$//g;
+	$line =~ s/^\s*//g;
+
+	next if ($line =~ m/^\s*#/);
+	next if ($line =~ m/^\s*$/);
+
+	my ($suspect, $fix) = split(/\|\|/, $line);
+
+	push(@spelling_list, $suspect);
+	$spelling_fix{$suspect} = $fix;
+}
+close($spelling);
+$misspellings = join("|", @spelling_list);
+
 sub build_types {
 	my $mods = "(?x:  \n" . join("|\n  ", @modifierList) . "\n)";
 	my $all = "(?x:  \n" . join("|\n  ", @typeList) . "\n)";
@@ -2337,6 +2362,20 @@ sub process {
 			}
 		}
 
+# Check for various spelling / typo mistakes
+		if ($in_commit_log || $line =~ /^\+/) {
+			while ($rawline =~ /(?:^|[^a-z@])($misspellings)(?:\$|[^a-z@])/gi) {
+				my $typo = $1;
+				my $fixed = $spelling_fix{lc($typo)};
+				$fixed = ucfirst($fixed) if ($typo =~ /^[A-Z]/);
+				if (WARN("TYPO_SPELLING",
+					 "'$typo' may be misspelled - perhaps '$fixed'?\n" . $herecurr) &&
+				    $fix) {
+					$fixed[$fixlinenr] =~ s/(^|[^A-Za-z@])($typo)(\$|[^A-Za-z@])/$1$fixed$3/;
+				}
+			}
+		}
+
 # check we are in a valid source file if not then ignore this hunk
 		next if ($realfile !~ /\.(h|c|s|S|pl|sh)$/);
 


