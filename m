Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282AbaFRADv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 20:03:51 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:44940 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955AbaFRADt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 20:03:49 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>,
        Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH/RFC] scripts: Add stack-o-meter
Date: Wed, 18 Jun 2014 02:03:33 +0200
Message-Id: <1403049813-32668-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the wake of the stack bloat story, I looked for an easy way to
track the change in stack usage between
revisions/compilers/.configs. At first, I tried parsing output from
checkpatch.pl, but for a number of reasons, that didn't quite fit the
bill. So I decided to write a single script which would both do the
"record stack usage" and the "compute delta".

The usage is dead simple, and I've tried to make it DWYM. Records are
kept under .tmp_stackometer (inspired from objdiff), using either a
user-supplied id or the default `git rev-parse HEAD`. To make a
record, simply invoke the script with the object files as
arguments. To print the delta between two records, invoke the script
with two record ids as arguments.

Examples:

  (1) Compare two revisions
  git checkout master
  <some build command>
  scripts/stack-o-meter.pl <object files>

  git checkout somebranch
  <some build command>
  scripts/stack-o-meter.pl <object files>

  scripts/stack-o-meter.pl master somebranch

  (2) Compare compilers, same source, same .config
  make clean
  make CC=gcc-4.6 mm/
  scripts/stack-o-meter.pl --id gcc4.6 mm/built-in.o

  make clean
  make CC=gcc-4.7 mm/
  scripts/stack-o-meter.pl --id gcc4.7 mm/built-in.o

  scripts/stack-o-meter.pl --sort delta gcc4.6 gcc4.7

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 scripts/stack-o-meter.pl | 482 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 482 insertions(+)
 create mode 100755 scripts/stack-o-meter.pl

diff --git a/scripts/stack-o-meter.pl b/scripts/stack-o-meter.pl
new file mode 100755
index 0000000..5038cdec
--- /dev/null
+++ b/scripts/stack-o-meter.pl
@@ -0,0 +1,482 @@
+#!/usr/bin/perl
+
+require 5.10.0;
+
+use strict;
+use warnings;
+
+# Inspiration and/or code stolen from objdiff, checkstack.pl, bloat-o-meter
+
+my $P = $0;
+
+use Getopt::Long qw(:config);
+use File::Basename;
+
+my $mode = '';
+sub set_mode { $mode = $_[0]; }
+my $tmpd;
+my $arch;
+my $sortkey; # func, old, new, delta
+my $machine_friendly = 0;
+my $print_dynamic = 0;
+my $record_id;
+
+my ($re, $dre, $funcre);
+
+
+GetOptions(# mode selection
+	   'list'         => \&set_mode,
+	   'clean'        => \&set_mode,
+	   'record'       => \&set_mode,
+	   'delta'        => \&set_mode,
+	   'usage|help'   => \&set_mode,
+	   # options for record mode
+	   'arch=s'       => \$arch, # default `uname -m`
+	   'id=s'         => \$record_id, # default `git rev-parse HEAD`
+	   # options for delta mode
+	   'machine!'     => \$machine_friendly,
+	   'dynamic!'     => \$print_dynamic,
+	   'sort=s'       => \$sortkey,
+	   # options for all modes
+	   'tmpdir=s'     => \$tmpd,
+	  )
+    or die "$P: invalid argument - use --usage if necessary\n";
+
+
+if ($mode eq 'usage') {
+    usage();
+    exit 0;
+}
+
+
+if (!$tmpd) {
+    chomp($tmpd = qx(git rev-parse --git-dir 2> /dev/null));
+    if ($? || !(-d $tmpd && $tmpd =~ s/\.git$/.tmp_stackometer/)) {
+	die "$P: git directory not found\n";
+    }
+}
+-d $tmpd or mkdir($tmpd) or die "$P: unable to create directory $tmpd: $!\n";
+
+if ($mode eq 'list') {
+    do_list();
+    exit 0;
+}
+if ($mode eq 'clean') {
+    do_clean();
+    exit 0;
+}
+
+
+if ($mode eq 'delta') {
+    die "$P: delta mode requires exactly two arguments (use --list to get a list)\n"
+	if (@ARGV != 2);
+    do_delta(@ARGV);
+    exit(0);
+}
+
+if ($mode eq 'record') {
+    die "$P: no object files given\n" if (@ARGV == 0);
+    do_record(@ARGV);
+}
+
+# If there are no remaining arguments, print usage and exit 1
+if (@ARGV == 0) {
+    usage();
+    exit(1);
+}
+
+# If there are two arguments, and if appropriate files exist in $tmpd (possibly after converting to an SHA1), do delta.
+if (@ARGV == 2 && all(map {my $sha1; -e "$tmpd/$_" || (defined($sha1 = full_sha1($_)) && -e "$tmpd/$sha1") } @ARGV)) {
+    do_delta(@ARGV);
+}
+else {
+    do_record(@ARGV);
+}
+
+sub do_record {
+    my $out;
+    my $outfile;
+
+    chomp($arch = qx(uname -m)) unless defined $arch;
+    ($re, $dre, $funcre) = get_regexps($arch);
+    die "$P: unknown architecture '$arch'\n" unless defined $re;
+
+    if (!defined $record_id) {
+	chomp($record_id = qx(git rev-parse HEAD));
+    }
+
+    $outfile = "$tmpd/$record_id";
+    open($out, '>', $outfile)
+	or die "$P: could not open $outfile for writing: $!\n";
+
+    foreach my $objfile (@_) {
+	my $stack = get_stack($objfile);
+	next if (!keys %$stack);
+	print $out "# file: $objfile\n";
+	for (keys %$stack) {
+	    if (defined $stack->{$_}) {
+		printf $out "%s\t%d\n", $_, $stack->{$_};
+	    }
+	    else {
+		printf $out "%s\tdynamic\n", $_;
+	    }
+	}
+    }
+    close($out);
+}
+
+sub read_records {
+    my $idref = shift;
+    my $name = ${$idref};
+    if (!-e "$tmpd/$name") {
+	$name = full_sha1($name);
+	die "no record with id '${$idref}', and no such git revision\n"
+	    unless defined($name);
+	die "no record with id '$name' (expanded from ${$idref})\n"
+	    unless (-e "$tmpd/$name");
+	${$idref} = $name;
+    }
+    my $file;
+    my %rec;
+    open(my $fh, '<', "$tmpd/$name")
+	or die "$P: could not open $tmpd/$name for reading: $!";
+    while (<$fh>) {
+	chomp;
+	if (m/^# file: (.*)$/) {
+	    $file = $1;
+	    next;
+	}
+	my ($func, $size) = split /\s+/, $_;
+	$rec{$file}{$func} = $size eq 'dynamic' ? undef : $size;
+    }
+    close($fh);
+    return %rec;
+}
+
+sub do_delta {
+    my %cmpfuncs = (func  => \&cmp_func,
+		    old   => \&cmp_old,
+		    new   => \&cmp_new,
+		    delta => \&cmp_delta,);
+    my $cmpfunc = undef;
+    if (defined $sortkey) {
+	if (!exists $cmpfuncs{$sortkey}) {
+	    die sprintf("$P: invalid sort key '$sortkey'; valid values are %s\n", join(',', sort keys %cmpfuncs));
+	}
+	$cmpfunc = $cmpfuncs{$sortkey};
+    }
+
+    my $old_id = shift;
+    my $new_id = shift;
+    my %old = read_records(\$old_id);
+    my %new = read_records(\$new_id);
+    my @normal;
+    my @dynamic;
+    # Fixme: What to do about files/functions present in one but not the other?
+    for my $file (keys %old) {
+	my $afile = abbrev_file($file);
+	next if !exists $new{$file};
+	for my $func (keys %{$old{$file}}) {
+	    next if !exists $new{$file}{$func};
+	    my $o = $old{$file}{$func};
+	    my $n = $new{$file}{$func};
+	    if (defined $o && defined $n) {
+		if ($o != $n) {
+		    push @normal, {file => $afile, func => $func,
+				   old => $o, new => $n, delta => $n - $o};
+		}
+	    }
+	    elsif (defined $o || defined $n) {
+		push @dynamic, {file => $afile, func => $func,
+				old => $o // 'dyn', new => $n // 'dyn', delta => '?'};
+	    }
+	}
+    }
+    @normal = sort $cmpfunc @normal if (defined $cmpfunc);
+    if (!$machine_friendly) {
+	printf "old: %s\n", $old_id;
+	printf "new: %s\n", $new_id;
+	printf "%-20s %-30s %-4s %-4s %-4s\n", 'file', 'function', 'old', 'new', 'delta';
+    }
+    my $nfmt = $machine_friendly ? "%s\t%s\t%d\t%d\t%d\n" : "%-20s %-30s %4d %4d %+4d\n";
+    my $dfmt = $machine_friendly ? "%s\t%s\t%s\t%s\t?\n" : "%-20s %-30s %4s %4s ?\n";
+    for (@normal) {
+	printf $nfmt, $_->{file}, $_->{func}, $_->{old}, $_->{new}, $_->{delta};
+    }
+    if ($print_dynamic) {
+	for (@dynamic) {
+	    printf $dfmt, $_->{file}, $_->{func}, $_->{old}, $_->{new};
+	}
+    }
+}
+
+sub abbrev_file {
+    my $f = shift;
+    return $f if ($machine_friendly);
+    return $f if length($f) <= 20;
+    return basename($f);
+}
+
+sub full_sha1 {
+    my $rev = shift;
+    my $sha1 = qx(git rev-parse --verify --quiet $rev);
+    if ($?) {
+	return undef;
+    }
+    chomp($sha1);
+    return $sha1;
+}
+
+
+sub get_stack {
+    my $file = shift;
+    my %s;
+    my $func = undef;
+    open(my $fh, '-|', "objdump -d $file")
+	or die "$P: could not objdump $file: $!\n";
+    while (my $line = <$fh>) {
+	if ($line =~ m/$funcre/) {
+	    if (defined $func && !exists $s{$func}) {
+		$s{$func} = 0;
+	    }
+	    $func = $1;
+	}
+	elsif ($line =~ m/$re/) {
+	    my $size = sane_size($1);
+	    if ($size < 0) {
+		warn "$P: unable to make sense of stack adjustment $1 in function $func\n";
+		next;
+	    }
+
+	    # We use the maximal change in stack size. Depending on
+	    # the control flow in the function, it might be more
+	    # appropriate to use the sum, but there's no way we can
+	    # know. Also, we'd have to distinguish "sub %rsp" and "add
+	    # %rsp", with all the arch-fun that would bring.
+	    if (!exists $s{$func} || $size > $s{$func}) {
+		$s{$func} = $size;
+	    }
+	}
+	elsif (defined $dre && $line =~ m/$dre/) {
+	    $s{$func} = undef if !exists $s{$func};
+	}
+    }
+
+    return \%s;
+}
+
+sub sane_size {
+    # objdump sometimes shows apparently huge constants, but that is
+    # just gcc being smart. For example, on x86_64, when gcc needs a
+    # stack frame of 128 bytes, it doesn't subtract 128 from %rsp,
+    # which would be:
+    #
+    # 48 81 ec 80 00 00 00    sub    $0x80,%rsp
+    #
+    # Instead, it adds -128, which is slightly shorter, since -128 fits in imm8:
+    #
+    # 48 83 c4 80             add    $0xffffffffffffff80,%rsp
+    #
+    # [This trick is only applicable when the adjustment is exactly
+    # 128 bytes]. As can be seen, objdump does the sign-extension when
+    # showing the immediate. But this means we need to translate large
+    # unsigned values to the negative of their interpretation as
+    # signed n-bit integer. We can safely assume that no stack frame
+    # is >= 2^15.
+
+    no warnings 'portable'; # silence "Hexadecimal number > 0xffffffff non-portable"
+    my $str = shift;
+    my $size = $str =~ m/^0x/ ? hex($str) : $str;
+    if ($size < 0x8000) {
+	return $size;
+    }
+    if (0x8000 <= $size && $size <= 0xffff) {
+	# 16 bit integer with sign bit set, return 2^16-$size.
+	return (~$size & 0xffff)+1;
+    }
+    if (0x8000_0000 <= $size && $size <= 0xffff_ffff) {
+	# 32 bit integer with sign bit set, return 2^32-$size.
+	return (~$size & 0xffffffff)+1;
+    }
+    if (0x8000_0000_0000_0000 <= $size) {
+	# 64 bit integer with sign bit set, return 2^64-$size.
+	return (~$size) + 1
+    }
+    # If we can't make sense of it, return a sentinel value.
+    return -1;
+}
+
+
+sub cmp_func { return $a->{func} cmp $b->{func}; } # prefix with "$a->{file} cmp $b->{file} || " ?
+# We want the largest on top.
+sub cmp_old { return $b->{old} <=> $a->{old}; }
+sub cmp_new { return $b->{new} <=> $a->{new}; }
+sub cmp_delta { return $b->{delta} <=> $a->{delta}; }
+sub all { $_ || return 0 for @_; 1 }
+
+sub get_regexps {
+    my $arch = shift;
+    my $re = undef;
+    my $dre = undef;
+
+    my $x = "[0-9a-f]";	# hex character
+
+    my $funcre = qr/^$x* <(.*)>:$/;
+
+    if ($arch eq 'arm') {
+	#c0008ffc:	e24dd064	sub	sp, sp, #100	; 0x64
+	$re = qr/.*sub.*sp, sp, #(([0-9]{2}|[3-9])[0-9]{2})/o;
+    } elsif ($arch eq 'avr32') {
+	#8000008a:       20 1d           sub sp,4
+	#80000ca8:       fa cd 05 b0     sub sp,sp,1456
+	$re = qr/^.*sub.*sp.*,([0-9]{1,8})/o;
+    } elsif ($arch =~ /^i[3456]86$/) {
+	#c0105234:       81 ec ac 05 00 00       sub    $0x5ac,%esp
+	$re = qr/^.*[as][du][db]    \$(0x$x{1,8}),\%esp$/o;
+	$dre = qr/^.*[as][du][db]    (%.*),\%esp$/o;
+    } elsif ($arch eq 'x86_64') {
+	#    2f60:	48 81 ec e8 05 00 00 	sub    $0x5e8,%rsp
+	$re = qr/^.*(?:add|sub)    \$(0x$x{1,16}),\%rsp$/o;
+	$dre = qr/^.*(?:add|sub)    (\%.*),\%rsp$/o;
+    } elsif ($arch eq 'ia64') {
+	#e0000000044011fc:       01 0f fc 8c     adds r12=-384,r12
+	$re = qr/.*adds.*r12=-(([0-9]{2}|[3-9])[0-9]{2}),r12/o;
+    } elsif ($arch eq 'm68k') {
+	#    2b6c:       4e56 fb70       linkw %fp,#-1168
+	#  1df770:       defc ffe4       addaw #-28,%sp
+	$re = qr/.*(?:linkw %fp,|addaw )#-([0-9]{1,4})(?:,%sp)?$/o;
+    } elsif ($arch eq 'metag') {
+	#400026fc:       40 00 00 82     ADD       A0StP,A0StP,#0x8
+	$re = qr/.*ADD.*A0StP,A0StP,\#(0x$x{1,8})/o;
+	$funcre = qr/^$x* <[^\$](.*)>:$/;
+    } elsif ($arch eq 'mips64') {
+	#8800402c:       67bdfff0        daddiu  sp,sp,-16
+	$re = qr/.*daddiu.*sp,sp,-(([0-9]{2}|[3-9])[0-9]{2})/o;
+    } elsif ($arch eq 'mips') {
+	#88003254:       27bdffe0        addiu   sp,sp,-32
+	$re = qr/.*addiu.*sp,sp,-(([0-9]{2}|[3-9])[0-9]{2})/o;
+    } elsif ($arch eq 'parisc' || $arch eq 'parisc64') {
+	$re = qr/.*ldo ($x{1,8})\(sp\),sp/o;
+    } elsif ($arch eq 'ppc') {
+	#c00029f4:       94 21 ff 30     stwu    r1,-208(r1)
+	$re = qr/.*stwu.*r1,-($x{1,8})\(r1\)/o;
+    } elsif ($arch eq 'ppc64') {
+	#XXX
+	$re = qr/.*stdu.*r1,-($x{1,8})\(r1\)/o;
+    } elsif ($arch eq 'powerpc') {
+	$re = qr/.*st[dw]u.*r1,-($x{1,8})\(r1\)/o;
+    } elsif ($arch =~ /^s390x?$/) {
+	#   11160:       a7 fb ff 60             aghi   %r15,-160
+	# or
+	#  100092:	 e3 f0 ff c8 ff 71	 lay	 %r15,-56(%r15)
+	$re = qr/.*(?:lay|ag?hi).*\%r15,-(([0-9]{2}|[3-9])[0-9]{2})
+		 (?:\(\%r15\))?$/ox;
+    } elsif ($arch =~ /^sh64$/) {
+	#XXX: we only check for the immediate case presently,
+	#     though we will want to check for the movi/sub
+	#     pair for larger users. -- PFM.
+	#a00048e0:       d4fc40f0        addi.l  r15,-240,r15
+	$re = qr/.*addi\.l.*r15,-(([0-9]{2}|[3-9])[0-9]{2}),r15/o;
+    } elsif ($arch =~ /^blackfin$/) {
+	#   0:   00 e8 38 01     LINK 0x4e0;
+	$re = qr/.*[[:space:]]LINK[[:space:]]*(0x$x{1,8})/o;
+    } elsif ($arch eq 'sparc' || $arch eq 'sparc64') {
+	# f0019d10:       9d e3 bf 90     save  %sp, -112, %sp
+	$re = qr/.*save.*%sp, -(([0-9]{2}|[3-9])[0-9]{2}), %sp/o;
+    }
+
+    return ($re, $dre, $funcre);
+}
+
+sub do_list {
+    use POSIX qw(strftime);
+    my @records = get_record_list();
+    printf "%-40s %s\n", 'record id', 'mtime';
+    for (@records) {
+	printf "%-40s %s\n", $_->{id}, strftime("%Y-%m-%d %H:%M:%S", localtime($_->{mtime}));
+    }
+}
+
+sub do_clean {
+    my @ids = map {$_->{id}} get_record_list();
+    for (@ids) {
+	unlink "$tmpd/$_" or
+	    die "could not unlink $tmpd/$_: $!\n";
+    }
+    rmdir $tmpd or
+	die "could not rmdir $tmpd: $!\n";
+}
+
+sub get_record_list {
+    opendir(my $dh, $tmpd)
+	or die "$P: could not open directory $tmpd: $!\n";
+    my @records =
+	map { {id => $_, mtime => (stat "$tmpd/$_")[9]} }
+	grep { -f "$tmpd/$_"} readdir($dh);
+    @records = sort {$a->{mtime} <=> $b->{mtime}} @records;
+    return @records;
+}
+
+
+sub usage {
+    print <<EOT;
+$P: Compare the stack usage in two sets of object files.
+
+    $P [options] [--record] <object file(s)>
+    $P [options] [--delta] old_id new_id
+
+There are two main modes of operation, record and delta, but the
+script will mostly DWYM without an explicit --record or --delta.
+
+In record mode, the script makes a record of the stack usage of the
+functions in the object files given as trailing arguments. The record
+is stored under an id, which by default is `git rev-parse HEAD`. If
+this is unsuitable (e.g., because you're compiling the same source but
+with different compilers or .configs), you can use the --id option.
+
+In delta mode, the script takes two record ids (abbreviated SHA1s
+allowed) and displays a list of the functions whose stack usage
+changed, in a format similar to that of bloat-o-meter.
+
+Options relevant for record mode:
+  -a,--arch ARCH  assume architecture ARCH
+  --id ID         store the record using id ID
+
+Options relevant for delta mode:
+  -m,--machine    produce machine-friendly output (no header,
+                  five tab-separated columns)
+  -d,--dynamic    include functions which have changed from/to
+                  dynamic stack usage
+  -s,--sort KEY   sort output by KEY, which may be func, old,
+                  new, delta.
+
+Other modes:
+  --list          show a list of the stored records (id and mtime)
+  --clean         remove all records and the .tmp_stackometer directory
+
+Examples:
+
+  (1) Compare two revisions
+  git checkout REV1
+  <some build command>
+  scripts/stack-o-meter.pl <object files>
+
+  git checkout REV2
+  <some build command>
+  scripts/stack-o-meter.pl <object files>
+
+  scripts/stack-o-meter.pl REV1 REV2
+
+  (2) Compare compilers, same source, same .config
+  make clean
+  make CC=gcc-4.6 mm/
+  scripts/stack-o-meter.pl --id gcc4.6 mm/built-in.o
+
+  make clean
+  make CC=gcc-4.7 mm/
+  scripts/stack-o-meter.pl --id gcc4.7 mm/built-in.o
+
+  scripts/stack-o-meter.pl --sort delta gcc4.6 gcc4.7
+EOT
+}
+
-- 
1.9.2

