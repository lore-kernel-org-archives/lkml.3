Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759998Ab3B0Cqd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 21:46:33 -0500
Received: from mail-oa0-f43.google.com ([209.85.219.43]:57074 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759497Ab3B0Cqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 21:46:30 -0500
Date: Tue, 26 Feb 2013 20:46:25 -0600
From: Rob Landley <rob@landley.net>
Subject: Re: [ 03/53] timeconst.pl: Eliminate Perl warning
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20130226235620.192151489@linuxfoundation.org> (from
	gregkh@linuxfoundation.org on Tue Feb 26 17:57:32 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1361933185.18483.3@driftwood>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-JI/gbqJIP5LNhZPKatJX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-JI/gbqJIP5LNhZPKatJX
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 02/26/2013 05:57:32 PM, Greg Kroah-Hartman wrote:
> 3.0-stable review patch.  If anyone has any objections, please let me =20
> know.
>=20
> ------------------
>=20
> From: "H. Peter Anvin" <hpa@linux.intel.com>
>=20
> commit 63a3f603413ffe82ad775f2d62a5afff87fd94a0 upstream.
>=20
> defined(@array) is deprecated in Perl and gives off a warning.
> Restructure the code to remove that warning.
>=20
> [ hpa: it would be interesting to revert to the timeconst.bc script.

Or, you know, the mktimeconst.c I've posted to this list several times =20
over the past few years as part of the perl removal series I maintain? =20
Most recently =20
http://lkml.indiana.edu/hypermail/linux/kernel/1212.2/00729.html but =20
before that rather a lot of times (list at =20
http://lkml.indiana.edu/hypermail/linux/kernel/1212.2/00734.html) and =20
the newest version of which is always at:

http://landley.net/hg/aboriginal/file/tip/sources/patches

I just updated them for 3.8. The mktimeconst one is attached to this =20
message.

(I'm told the balsa email program manages to break whitespace in =20
attachments. I'm aware how sad that is. I'm writing a darn python =20
script to send mail inline without doing that. I'll repost the series =20
with that. My first attempt at that script is why the posts I linked to =20
above have my name mangled. Working on it...)

Rob=

--=-JI/gbqJIP5LNhZPKatJX
Content-Type: text/x-patch; charset=us-ascii;
	name=linux-noperl-timeconst.patch
Content-Disposition: attachment; filename=linux-noperl-timeconst.patch
Content-Transfer-Encoding: quoted-printable

From: Rob Landley <rlandley@parallels.com>

Replace perl header file generator with smaller/faster/simpler C version.

Hasn't changed since last submission, which was:

Message-ID: <4D35FEF3.4070001@parallels.com>
Subject: Re: [PATCH] Use sed instead of perl to generate x86/kernel/cpu/cap=
flags.c.

Signed-off-by: Rob Landley <rlandley@parallels.com>
---

I ran the attached test script to compare the output of the C program
with the output of the perl version for every HZ from 1 to 5000 to make
sure it was producing the same constants.

 kernel/Makefile      |   10 -
 kernel/mktimeconst.c |  109 +++++++++++
 kernel/timeconst.pl  |  378 -----------------------------------------
 3 files changed, 115 insertions(+), 382 deletions(-)

diff --git a/kernel/Makefile b/kernel/Makefile
index 5669f71..ba9ce6d 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -133,11 +133,13 @@ $(obj)/config_data.h: $(obj)/config_data.gz FORCE
=20
 $(obj)/time.o: $(obj)/timeconst.h
=20
-quiet_cmd_timeconst  =3D TIMEC   $@
-      cmd_timeconst  =3D $(PERL) $< $(CONFIG_HZ) > $@
+hostprogs-y	+=3D mktimeconst
+quiet_cmd_mktimeconst =3D TIMEC   $@
+	cmd_mktimeconst =3D $(obj)/mktimeconst $(CONFIG_HZ) $@ || ( rm -f $@ && e=
xit 1 )
+
 targets +=3D timeconst.h
-$(obj)/timeconst.h: $(src)/timeconst.pl FORCE
-	$(call if_changed,timeconst)
+$(obj)/timeconst.h: $(obj)/mktimeconst FORCE
+	$(call if_changed,mktimeconst)
=20
 ifeq ($(CONFIG_MODULE_SIG),y)
 #
--- /dev/null	2011-01-13 17:00:36.470564274 -0600
+++ b/kernel/mktimeconst.c	2011-01-16 12:44:04.091168778 -0600
@@ -0,0 +1,109 @@
+/* Copyright 2010 Parallels Inc, licensed under GPLv2 */
+
+#include <inttypes.h>
+#include <stdio.h>
+#include <stdlib.h>
+
+int main(int argc, char *argv[])
+{
+	uint64_t hz, periods[] =3D {1000, 1000000};
+	char *names[] =3D {"MSEC", "USEC"};
+	FILE *file;
+	int i, j;
+
+	if (argc !=3D 3 || (hz =3D atol(argv[1])) < 1
+	    || !(file =3D fopen(argv[2], "w")))
+	{
+		fprintf(stderr, "Usage: mktimeconst HZ FILENAME\n\n");
+		fprintf(stderr, "Generate a header file with constants to convert betwee=
n\n");
+		fprintf(stderr, "decimal HZ timer ticks and milisecond or microsecond de=
lays,\n");
+		fprintf(stderr, "using reciprocal multiplication to avoid 64 bit divisio=
n.\n");
+		exit(1);
+	}
+
+	fprintf(file,
+		"/* Automatically generated by kernel/mktimeconst */\n"
+		"/* Conversion constants for HZ =3D=3D %"PRIu64" */\n\n"
+		"#ifndef __KERNEL_TIMECONST_H\n"
+		"#define __KERNEL_TIMECONST_H\n\n"
+		"#include <linux/param.h>\n"
+		"#include <linux/types.h>\n\n"
+		"#if HZ !=3D %"PRIu64"\n"
+		"#error \"kernel/timeconst.h has the wrong HZ value!\"\n"
+		"#endif\n\n", hz, hz);
+
+	/* Repeat for MSEC and USEC */
+
+	for (i =3D 0; i < 2; i++) {
+		uint64_t gcd, period;
+
+		/* Find greatest common denominator using Euclid's algorithm. */
+
+		gcd =3D hz;
+		period =3D periods[i];
+		while (period) {
+			uint64_t temp =3D gcd % period;
+			gcd =3D period;
+			period =3D temp;
+		}
+
+		/* Output both directions (HZ_TO_PERIOD and PERIOD_TO_HZ) */
+
+		for (j =3D 0; j < 2; j++) {
+			char name[16];
+			uint64_t from =3D j ? periods[i] : hz;
+			uint64_t to =3D j ? hz : periods[i];
+			uint64_t mul32 =3D 0, adj32 =3D 0, shift =3D 0;
+
+			sprintf(name, j ? "%s_TO_HZ" : "HZ_TO_%s", names[i]);
+
+			/* Figure out what shift value gives 32 significant
+			   bits of MUL32 data.  (Worst case to=3D1 from=3D1000000
+			   uses 52 bits, to<<shift won't overflow 64 bit math.)
+			*/
+
+			for (;;) {
+				mul32 =3D ((to << shift) + from - 1) / from;
+				if (mul32 >=3D (1UL<<31))
+					break;
+				shift++;
+			}
+
+			/* ADJ32 is is just (((FROM/GCD)-1)<<SHIFT)/(FROM/GCD)
+			   but this can overflow 64 bit math (examples, HZ=3D24
+			   or HZ=3D122).  Worst case scenario uses 32+20+20=3D72
+			   bits.  Workaround: split off bottom 32 bits and
+			   reassemble after calculation (32+64=3D96 bits). */
+
+			adj32 =3D from / gcd;
+
+			if (shift > 32) {
+				uint64_t upper, lower;
+
+				upper =3D (adj32 - 1) << (shift - 32);
+				lower =3D (upper % adj32) << 32;
+				adj32 =3D ((upper/adj32) << 32) + (lower/adj32);
+			} else
+				adj32 =3D ((adj32 - 1) << shift) / adj32;
+
+			/* Emit the constants into the header file. */
+
+			fprintf(file, "#define %s_MUL32\tU64_C(0x%"PRIx64")\n",
+				name, mul32);
+			fprintf(file, "#define %s_ADJ32\tU64_C(0x%"PRIx64")\n",
+				name, adj32);
+			fprintf(file, "#define %s_SHR32\t%"PRIu64"\n",
+				name, shift);
+			fprintf(file, "#define %s_NUM\t\tU64_C(%"PRIu64")\n",
+				name, to/gcd);
+			fprintf(file, "#define %s_DEN\t\tU64_C(%"PRIu64")\n\n",
+				name, from/gcd);
+		}
+	}
+	fprintf(file, "#endif /* __KERNEL_TIMECONST_H */\n");
+
+	/* Notice if the disk fills up. */
+
+	fflush(stdout);
+	return ferror(stdout);
+}
--- a/kernel/timeconst.pl	2010-12-19 11:33:53.969732934 -0600
+++ /dev/null	2011-01-13 17:00:36.470564274 -0600
@@ -1,378 +0,0 @@
-#!/usr/bin/perl
-# -----------------------------------------------------------------------
-#
-#   Copyright 2007-2008 rPath, Inc. - All Rights Reserved
-#
-#   This file is part of the Linux kernel, and is made available under
-#   the terms of the GNU General Public License version 2 or (at your
-#   option) any later version; incorporated herein by reference.
-#
-# -----------------------------------------------------------------------
-#
-
-#
-# Usage: timeconst.pl HZ > timeconst.h
-#
-
-# Precomputed values for systems without Math::BigInt
-# Generated by:
-# timeconst.pl --can 24 32 48 64 100 122 128 200 250 256 300 512 1000 1024=
 1200
-%canned_values =3D (
-	24 =3D> [
-		'0xa6aaaaab','0x2aaaaaa',26,
-		125,3,
-		'0xc49ba5e4','0x1fbe76c8b4',37,
-		3,125,
-		'0xa2c2aaab','0xaaaa',16,
-		125000,3,
-		'0xc9539b89','0x7fffbce4217d',47,
-		3,125000,
-	], 32 =3D> [
-		'0xfa000000','0x6000000',27,
-		125,4,
-		'0x83126e98','0xfdf3b645a',36,
-		4,125,
-		'0xf4240000','0x0',17,
-		31250,1,
-		'0x8637bd06','0x3fff79c842fa',46,
-		1,31250,
-	], 48 =3D> [
-		'0xa6aaaaab','0x6aaaaaa',27,
-		125,6,
-		'0xc49ba5e4','0xfdf3b645a',36,
-		6,125,
-		'0xa2c2aaab','0x15555',17,
-		62500,3,
-		'0xc9539b89','0x3fffbce4217d',46,
-		3,62500,
-	], 64 =3D> [
-		'0xfa000000','0xe000000',28,
-		125,8,
-		'0x83126e98','0x7ef9db22d',35,
-		8,125,
-		'0xf4240000','0x0',18,
-		15625,1,
-		'0x8637bd06','0x1fff79c842fa',45,
-		1,15625,
-	], 100 =3D> [
-		'0xa0000000','0x0',28,
-		10,1,
-		'0xcccccccd','0x733333333',35,
-		1,10,
-		'0x9c400000','0x0',18,
-		10000,1,
-		'0xd1b71759','0x1fff2e48e8a7',45,
-		1,10000,
-	], 122 =3D> [
-		'0x8325c53f','0xfbcda3a',28,
-		500,61,
-		'0xf9db22d1','0x7fbe76c8b',35,
-		61,500,
-		'0x8012e2a0','0x3ef36',18,
-		500000,61,
-		'0xffda4053','0x1ffffbce4217',45,
-		61,500000,
-	], 128 =3D> [
-		'0xfa000000','0x1e000000',29,
-		125,16,
-		'0x83126e98','0x3f7ced916',34,
-		16,125,
-		'0xf4240000','0x40000',19,
-		15625,2,
-		'0x8637bd06','0xfffbce4217d',44,
-		2,15625,
-	], 200 =3D> [
-		'0xa0000000','0x0',29,
-		5,1,
-		'0xcccccccd','0x333333333',34,
-		1,5,
-		'0x9c400000','0x0',19,
-		5000,1,
-		'0xd1b71759','0xfff2e48e8a7',44,
-		1,5000,
-	], 250 =3D> [
-		'0x80000000','0x0',29,
-		4,1,
-		'0x80000000','0x180000000',33,
-		1,4,
-		'0xfa000000','0x0',20,
-		4000,1,
-		'0x83126e98','0x7ff7ced9168',43,
-		1,4000,
-	], 256 =3D> [
-		'0xfa000000','0x3e000000',30,
-		125,32,
-		'0x83126e98','0x1fbe76c8b',33,
-		32,125,
-		'0xf4240000','0xc0000',20,
-		15625,4,
-		'0x8637bd06','0x7ffde7210be',43,
-		4,15625,
-	], 300 =3D> [
-		'0xd5555556','0x2aaaaaaa',30,
-		10,3,
-		'0x9999999a','0x1cccccccc',33,
-		3,10,
-		'0xd0555556','0xaaaaa',20,
-		10000,3,
-		'0x9d495183','0x7ffcb923a29',43,
-		3,10000,
-	], 512 =3D> [
-		'0xfa000000','0x7e000000',31,
-		125,64,
-		'0x83126e98','0xfdf3b645',32,
-		64,125,
-		'0xf4240000','0x1c0000',21,
-		15625,8,
-		'0x8637bd06','0x3ffef39085f',42,
-		8,15625,
-	], 1000 =3D> [
-		'0x80000000','0x0',31,
-		1,1,
-		'0x80000000','0x0',31,
-		1,1,
-		'0xfa000000','0x0',22,
-		1000,1,
-		'0x83126e98','0x1ff7ced9168',41,
-		1,1000,
-	], 1024 =3D> [
-		'0xfa000000','0xfe000000',32,
-		125,128,
-		'0x83126e98','0x7ef9db22',31,
-		128,125,
-		'0xf4240000','0x3c0000',22,
-		15625,16,
-		'0x8637bd06','0x1fff79c842f',41,
-		16,15625,
-	], 1200 =3D> [
-		'0xd5555556','0xd5555555',32,
-		5,6,
-		'0x9999999a','0x66666666',31,
-		6,5,
-		'0xd0555556','0x2aaaaa',22,
-		2500,3,
-		'0x9d495183','0x1ffcb923a29',41,
-		3,2500,
-	]
-);
-
-$has_bigint =3D eval 'use Math::BigInt qw(bgcd); 1;';
-
-sub bint($)
-{
-	my($x) =3D @_;
-	return Math::BigInt->new($x);
-}
-
-#
-# Constants for division by reciprocal multiplication.
-# (bits, numerator, denominator)
-#
-sub fmul($$$)
-{
-	my ($b,$n,$d) =3D @_;
-
-	$n =3D bint($n);
-	$d =3D bint($d);
-
-	return scalar (($n << $b)+$d-bint(1))/$d;
-}
-
-sub fadj($$$)
-{
-	my($b,$n,$d) =3D @_;
-
-	$n =3D bint($n);
-	$d =3D bint($d);
-
-	$d =3D $d/bgcd($n, $d);
-	return scalar (($d-bint(1)) << $b)/$d;
-}
-
-sub fmuls($$$) {
-	my($b,$n,$d) =3D @_;
-	my($s,$m);
-	my($thres) =3D bint(1) << ($b-1);
-
-	$n =3D bint($n);
-	$d =3D bint($d);
-
-	for ($s =3D 0; 1; $s++) {
-		$m =3D fmul($s,$n,$d);
-		return $s if ($m >=3D $thres);
-	}
-	return 0;
-}
-
-# Generate a hex value if the result fits in 64 bits;
-# otherwise skip.
-sub bignum_hex($) {
-	my($x) =3D @_;
-	my $s =3D $x->as_hex();
-
-	return (length($s) > 18) ? undef : $s;
-}
-
-# Provides mul, adj, and shr factors for a specific
-# (bit, time, hz) combination
-sub muladj($$$) {
-	my($b, $t, $hz) =3D @_;
-	my $s =3D fmuls($b, $t, $hz);
-	my $m =3D fmul($s, $t, $hz);
-	my $a =3D fadj($s, $t, $hz);
-	return (bignum_hex($m), bignum_hex($a), $s);
-}
-
-# Provides numerator, denominator values
-sub numden($$) {
-	my($n, $d) =3D @_;
-	my $g =3D bgcd($n, $d);
-	return ($n/$g, $d/$g);
-}
-
-# All values for a specific (time, hz) combo
-sub conversions($$) {
-	my ($t, $hz) =3D @_;
-	my @val =3D ();
-
-	# HZ_TO_xx
-	push(@val, muladj(32, $t, $hz));
-	push(@val, numden($t, $hz));
-
-	# xx_TO_HZ
-	push(@val, muladj(32, $hz, $t));
-	push(@val, numden($hz, $t));
-
-	return @val;
-}
-
-sub compute_values($) {
-	my($hz) =3D @_;
-	my @val =3D ();
-	my $s, $m, $a, $g;
-
-	if (!$has_bigint) {
-		die "$0: HZ =3D=3D $hz not canned and ".
-		    "Math::BigInt not available\n";
-	}
-
-	# MSEC conversions
-	push(@val, conversions(1000, $hz));
-
-	# USEC conversions
-	push(@val, conversions(1000000, $hz));
-
-	return @val;
-}
-
-sub outputval($$)
-{
-	my($name, $val) =3D @_;
-	my $csuf;
-
-	if (defined($val)) {
-	    if ($name !~ /SHR/) {
-		$val =3D "U64_C($val)";
-	    }
-	    printf "#define %-23s %s\n", $name.$csuf, $val.$csuf;
-	}
-}
-
-sub output($@)
-{
-	my($hz, @val) =3D @_;
-	my $pfx, $bit, $suf, $s, $m, $a;
-
-	print "/* Automatically generated by kernel/timeconst.pl */\n";
-	print "/* Conversion constants for HZ =3D=3D $hz */\n";
-	print "\n";
-	print "#ifndef KERNEL_TIMECONST_H\n";
-	print "#define KERNEL_TIMECONST_H\n";
-	print "\n";
-
-	print "#include <linux/param.h>\n";
-	print "#include <linux/types.h>\n";
-
-	print "\n";
-	print "#if HZ !=3D $hz\n";
-	print "#error \"kernel/timeconst.h has the wrong HZ value!\"\n";
-	print "#endif\n";
-	print "\n";
-
-	foreach $pfx ('HZ_TO_MSEC','MSEC_TO_HZ',
-		      'HZ_TO_USEC','USEC_TO_HZ') {
-		foreach $bit (32) {
-			foreach $suf ('MUL', 'ADJ', 'SHR') {
-				outputval("${pfx}_$suf$bit", shift(@val));
-			}
-		}
-		foreach $suf ('NUM', 'DEN') {
-			outputval("${pfx}_$suf", shift(@val));
-		}
-	}
-
-	print "\n";
-	print "#endif /* KERNEL_TIMECONST_H */\n";
-}
-
-# Pretty-print Perl values
-sub perlvals(@) {
-	my $v;
-	my @l =3D ();
-
-	foreach $v (@_) {
-		if (!defined($v)) {
-			push(@l, 'undef');
-		} elsif ($v =3D~ /^0x/) {
-			push(@l, "\'".$v."\'");
-		} else {
-			push(@l, $v.'');
-		}
-	}
-	return join(',', @l);
-}
-
-($hz) =3D @ARGV;
-
-# Use this to generate the %canned_values structure
-if ($hz eq '--can') {
-	shift(@ARGV);
-	@hzlist =3D sort {$a <=3D> $b} (@ARGV);
-
-	print "# Precomputed values for systems without Math::BigInt\n";
-	print "# Generated by:\n";
-	print "# timeconst.pl --can ", join(' ', @hzlist), "\n";
-	print "\%canned_values =3D (\n";
-	my $pf =3D "\t";
-	foreach $hz (@hzlist) {
-		my @values =3D compute_values($hz);
-		print "$pf$hz =3D> [\n";
-		while (scalar(@values)) {
-			my $bit;
-			foreach $bit (32) {
-				my $m =3D shift(@values);
-				my $a =3D shift(@values);
-				my $s =3D shift(@values);
-				print "\t\t", perlvals($m,$a,$s), ",\n";
-			}
-			my $n =3D shift(@values);
-			my $d =3D shift(@values);
-			print "\t\t", perlvals($n,$d), ",\n";
-		}
-		print "\t]";
-		$pf =3D ', ';
-	}
-	print "\n);\n";
-} else {
-	$hz +=3D 0;			# Force to number
-	if ($hz < 1) {
-		die "Usage: $0 HZ\n";
-	}
-
-	@val =3D @{$canned_values{$hz}};
-	if (!defined(@val)) {
-		@val =3D compute_values($hz);
-	}
-	output($hz, @val);
-}
-exit 0;

--------------070402000802050303040701
Content-Type: application/x-sh; name=3D"loopy.sh"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=3D"loopy.sh"

#!/bin/bash

gcc mktimeconst.c || exit 1

X=3D1
while [ $X -lt 5000 ]
do
  echo $X

  perl ~/linux/linux/kernel/timeconst.pl $X | sed 's/KERNEL_TIMECONST/__KER=
NEL_TIMECONST/;/Automatically generated/d;/^$/d'> temp.txt
  ./a.out $X temp2.txt
  sed -i '/Automatically generated/d;/^$/d' temp2.txt

  diff -uw temp.txt temp2.txt || exit 1

  X=3D$(($X+1))
done

--------------070402000802050303040701--
=

--=-JI/gbqJIP5LNhZPKatJX--
