Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689Ab3IZCBC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 22:01:02 -0400
Received: from smtprelay0241.hostedemail.com ([216.40.44.241]:55963 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752768Ab3IZCBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 22:01:00 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::::,RULES_HIT:41:334:355:368:369:379:541:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1431:1437:1515:1516:1518:1534:1543:1593:1594:1711:1730:1747:1777:1792:1801:2197:2199:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3355:3622:3653:3743:3865:3866:3867:3868:3870:3871
X-HE-Tag: light22_7c9547e394044
X-Filterd-Recvd-Size: 4999
Message-ID: <1380160854.17366.49.camel@joe-AO722>
Subject: [PATCH] checkpatch: Add test for #defines of ARCH_HAS_<foo>
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@au1.ibm.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>, James Hogan <james.hogan@imgtec.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Wed, 25 Sep 2013 19:00:54 -0700
In-Reply-To: <CA+55aFycQ9XJvEOsiM3txHL5bjUc8CeKWJNR_H+MiicaddB42Q@mail.gmail.com>
References: <1380125886-10341-1-git-send-email-fweisbec@gmail.com>
	 <1380125886-10341-8-git-send-email-fweisbec@gmail.com>
	 <CA+55aFzPArB0dotWZz8dLTPVM4MMT75NAb5_DVcPrNuvWu4QUA@mail.gmail.com>
	 <20130925172121.00c23e416398139f4615943c@linux-foundation.org>
	 <1380156027.17366.39.camel@joe-AO722>
	 <CA+55aFycQ9XJvEOsiM3txHL5bjUc8CeKWJNR_H+MiicaddB42Q@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-09-25 at 18:26 -0700, Linus Torvalds wrote:
> On Wed, Sep 25, 2013 at 5:40 PM, Joe Perches <joe@perches.com> wrote:
> >
> > Huh?  That matches all the ARCH_HAS_<foo> patterns.
> 
> Right. And they are all crap. lib/string.c is a prime example of
> something that should never have happened.
> 
> The ARCH_HAS_xyz pattern is totally retarded. It's wrong.
> 
> For big conceptual features, we should use Kconfig symbols.
> 
> And for smaller things - like lib/string.c - where we have
> compatibility fallback functions but want architectures able to
> override them with optimized ones one function at a time, we should
> either use weak functions (appropriate for some cases), or the symbol
> that protects them should the the SAME SYMBOL WE USE. Rather than some
> made-up crap-for-brains new ARCH_HAS_xyz symbol. That way it shows up
> in greps, and that way we don't have any question about what random
> symbol pattern we use that particular day.
> 
> So for *bad* use, see lib/string.c, and the ARCH_AS_xyz horror.
> 
> For *good* use, see lib/div64.c or lib/find_next_bit.c.
> 
> Notice how div64.c doesn't make up new ARCH_HAS_random_crap names? And
> no, you don't have to define those things as macros, you can define
> them as functions (inline or not), and then just do
> 
>     #define find_next_zero_bit find_next_zero_bit
> 
> to tell the rest of the world "Look, I have this defined".
> 
> The whole "make up a totally unrelated second name for it" means that
> we have things like __HAVE_ARCH_STRLEN but also things like
> ARCH_HAS_PREFETCHW. Ugh.
> 
>                        Linus

So, add a test for these #defines

Additionally, moved string_find_replace sub as it
screws up subsequent formatting when placed inside
another sub.

Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index c03e427..e2e7703 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1512,6 +1512,14 @@ sub rtrim {
 	return $string;
 }
 
+sub string_find_replace {
+	my ($string, $find, $replace) = @_;
+
+	$string =~ s/$find/$replace/g;
+
+	return $string;
+}
+
 sub tabify {
 	my ($leading) = @_;
 
@@ -3731,14 +3739,6 @@ sub process {
 			}
 		}
 
-sub string_find_replace {
-	my ($string, $find, $replace) = @_;
-
-	$string =~ s/$find/$replace/g;
-
-	return $string;
-}
-
 # check for bad placement of section $InitAttribute (e.g.: __initdata)
 		if ($line =~ /(\b$InitAttribute\b)/) {
 			my $attr = $1;
@@ -4196,6 +4196,12 @@ sub string_find_replace {
 			     "usage of NR_CPUS is often wrong - consider using cpu_possible(), num_possible_cpus(), for_each_possible_cpu(), etc\n" . $herecurr);
 		}
 
+# Use of __ARCH_HAS_<FOO> or ARCH_HAVE_<BAR> is wrong.
+		if ($line =~ /\+\s*#\s*define\s+((?:__)?ARCH_(?:HAS|HAVE)\w*)\b/) {
+			ERROR("DEFINE_ARCH_HAS",
+			      "#define of '$1' is wrong - use Kconfig variables or standard guards instead\n" . $herecurr);
+		}
+
 # check for %L{u,d,i} in strings
 		my $string;
 		while ($line =~ /(?:^|")([X\t]*)(?:"|$)/g) {


