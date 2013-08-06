Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004Ab3HFK2m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 06:28:42 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:45362 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755772Ab3HFK2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 06:28:41 -0400
X-AuditID: cbfec7f5-b7f5f6d00000105f-c8-5200cfd6d402
From: Phil Carmody <phil.carmody@partner.samsung.com>
To: apw@canonical.com, joe@perches.com
Cc: linux-kernel@vger.kernel.org,
        Phil Carmody <phil.carmody@partner.samsung.com>
Subject: [[RFC]] scripts/robopatch.pl: the mechanical bride of checkpatch.pl
Date: Tue, 06 Aug 2013 13:27:09 +0300
Message-id: <1375784829-5974-1-git-send-email-phil.carmody@partner.samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBJMWRmVeSWpSXmKPExsVy+t/xy7rXzjMEGbxap2bxYa2Gxez7j1ks
	Lu+aw2ax+9VSVgcWj1kNvWweB9/tYfL4suoas8fnTXIBLFFcNimpOZllqUX6dglcGSf3b2As
	2NTAWLH7TTtTA+OblC5GTg4JAROJd+uuskHYYhIX7q0Hsrk4hASWMkp8PvOCBcLpZJLoXnON
	BaSKTcBUYsqKb0wgtoiAmkRLzzR2EJtZIFji8dsZzF2MHBzCAj4S706rgoRZBFQljs7/C9bK
	K+Av8fPZRbASCQEFiTmTbCYwci9gZFjFKJpamlxQnJSea6RXnJhbXJqXrpecn7uJEeL7rzsY
	lx6zOsQowMGoxMO74/r/QCHWxLLiytxDjBIczEoivCo7GYKEeFMSK6tSi/Lji0pzUosPMTJx
	cEo1MHLf6Fwc+9hZLD710OUF3xPDeYWmGnJOi/Paor7nocbBm3+jg1a7Od9OzuQWm+c09dQl
	r8QlEYcrzgu7sNw/27J84k33vA9Ze/Y0RlZ2yR6q+LpdM/q6ln8C05eeD45cfouNBS5eM35j
	2sxg9bJ//ufW2CMrijYdupQwa92eSz/uSl5tefCraJUSS3FGoqEWc1FxIgCYW8YB2wEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Checkpatch knows a lot about the linux coding style. It's very
helpful in telling us humans what to change in order to improve
our C code. However, as lazy humans, we rarely do that.

That's where robopatch steps in - it will take the output
of checkpatch, and attempt to perform all the changes that
it feels confident it can do without breaking the code.

Think of it like a 'roid-raged indent/Lindent or cleanfile.

Yes, that's like them on steroids, and with all the mindlessness
that implies. It really doesn't attempt to understand much C at
all, it relies on checkpatch knowing about those kinds of things,
and then just blindly obeys orders. ALWAYS CHECK ITS CHANGES.

Signed-off-by: Phil Carmody <phil.carmody@partner.samsung.com>
---
 scripts/robopatch.pl |  465 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 465 insertions(+)
 create mode 100755 scripts/robopatch.pl

diff --git a/scripts/robopatch.pl b/scripts/robopatch.pl
new file mode 100755
index 0000000..784f355
--- /dev/null
+++ b/scripts/robopatch.pl
@@ -0,0 +1,465 @@
+#!/usr/bin/perl -w
+#
+# robopatch.pl
+#
+# Author: Phil Carmody <phil.carmody@partner.samsung.com>
+# Copyright 2013- Samsung Electronics Ltd.
+# Licensed under the terms of the GNU GPL License version 2
+
+# Attempt to clean files mentioned in checkpatch output.
+# It relies on checkpatch having all the intelligence,
+# isolating the problems very specifically, so the actual
+# fixes can be done relatively safely. However, you should
+# always check the output.
+
+# Error handling is on a fail-early and fail-often policy.
+# Verbose logging goes to stderr presently, while this is WIP.
+
+# Typical usage:
+# $ scripts/checkpatch.pl WHATEVER > /tmpcheckpatch.log
+# $ scripts/robopatch.pl < /tmp/checkpatch.log
+# $ git diff
+#
+
+use strict qw(refs subs vars);
+use warnings;
+
+# This script edits files in place unless --dryrun is set
+my $dryrun=0;
+
+# TODO: permit filtering of which rules you want to act upon.
+my $filtered=0;
+
+while(@ARGV and $ARGV[0] =~ m/^-/) {
+    my $arg=shift(@ARGV);
+    if($arg =~ m/--dryrun/) {
+	$dryrun=1;
+    }
+    if($arg =~ m/--filter=(.+)/) {
+	# TODO: parse a filter file
+	$filtered=1;
+    }
+    if($arg =~ m/--/) { last; }
+}
+
+my %aliases;    # short name -> full path
+my %files;      # short name -> array of changes
+my @files;      # short name in order seen
+
+my $lastfile=undef;
+my $lastline=undef;
+my $state=0;
+my $build=undef;
+while(<>) {
+    chomp;
+    my $handled=0;
+    if($state==0
+       and m/^total: (\d+) errors, (\d+) warnings, (\d+) lines checked/) {
+	if(defined($lastfile)) {
+	    print STDERR "$lastfile: E/W/L=$1/$2/$3\n" if($1 or $2 or $3);
+	    $state=4;
+	} else {
+	    $state=5;
+	}
+	$handled=1;
+    } elsif($state==0 and m/^(?:WARNING|ERROR): .*/) {
+	die("unknown state before: $_") if($build);
+	$build={ message => $_ };
+	$state=1;
+	$handled=1;
+    } elsif($state==0 and 
+	    m/^(If any of these errors are false|them to the maintainer)/) {
+	$handled=1;
+    } elsif($state==1 and m/^#\d+: FILE: (.+):(\d+):$/) {
+	my ($f, $l)=($1, $2);
+	die("file confusion, lf=$lastfile f=$f") if(defined($lastfile) and $lastfile ne $f);
+	if(!defined($files{$f})) { push @files, $f; $files{$f}=[]; }
+	if(defined($lastfile) and defined($lastline) and ($lastline eq $l)
+	   and ($files{$lastfile}->[-1]->{'message'} eq $build->{'message'})) {
+	    # This message is identical to the previous one, just tally.
+	    $build->{'tally'}=$files{$lastfile}->[-1]->{'tally'}+1;
+	    pop(@{$files{$lastfile}});
+	} else {
+	    $build->{'tally'}=1;
+	}
+	$build->{'file'}=$f;
+	$build->{'line'}=$l;
+	$build->{'fileline'}=$_;
+	$build->{'lines'}=[];
+	$lastfile=$f;
+	$lastline=$l;
+	$state=2;
+	$handled=1;
+    } elsif($state==2 and m/^(\+|\[\.\.\.\]$)/) {
+	push @{$build->{'lines'}}, $_;
+	$handled=1;
+    } elsif($state==2 and m/^ (\s*)\^/) {
+	if(@{$build->{'lines'}} != 1 or defined($build->{'column'})) {
+	    die("column confusion") 
+	}
+	$build->{'column'}=$_;
+	$handled=1;
+    } elsif(($state==2 or $state==3) and m/^$/) {
+	push @{$files{$lastfile}}, $build;
+	$build=undef;
+	$state=0;
+	$handled=1;
+    } elsif($state==4 and m/^(.+) has style problems, please review/) {
+	$aliases{$lastfile}=$1;
+	$lastfile=undef;
+	$lastline=undef;
+	$state=0;
+	$handled=1;
+    } elsif($state==4 or $state==5 or $state==0 and m/^$/) {
+	$handled=1;
+    } else {
+	die("in state $state (lf=$lastfile), what's: $_");
+    }
+}
+
+# Stub - currently process everything possible
+sub msg_is_OK($)
+{
+    if(!$filtered) { return 1; }
+    return 1;
+}
+
+sub handle_message($$$$)
+{
+    my ($rfn,$whref,$inref,$outref)=@_;
+    my $handled=0;
+    my ($msg, $line)=@{$whref}{'message', 'line'};
+    my $tail=$#{$whref->{'lines'}};
+
+    # Zillions of these, and really can't or don't want to fix them - ignore them
+    if($msg =~ m/^WARNING: line over \d+ characters/ or
+       $msg =~ m/^WARNING: quoted string split across lines/ or
+       $msg =~ m/^WARNING: Too many leading tabs - consider code refactoring/ or
+       $msg =~ m/^WARNING: Avoid CamelCase: / or
+       $msg =~ m{^ERROR: do not use C99 // comments}) {
+	return 0;
+    }
+
+    # Purely for debugging...
+    print STDERR ("$rfn:$line: ($whref->{'tally'}) $msg\n",
+	  join("\n", @{$whref->{'lines'}}),"\n");
+    if($whref->{'column'}) {
+	print STDERR ("$whref->{'column'}\n");
+    }
+
+    # Now the ones we can handle
+
+    if($msg =~ m/^ERROR: trailing whitespace/) {
+	# cleanfile should clean these
+	my $work = $outref->[$line] // $inref->[$line];
+	if($work !~ m/\s+$/) {
+	    print STDERR "$rfn:$line: no trailing space to kill\n";
+	    return 0;
+	}
+	$work =~ s/\s+$/\n/;
+	$outref->[$line]=$work;
+	$handled=1;
+    }
+
+    elsif($msg =~ m/^ERROR: code indent should use tabs where possible/) {
+	# cleanfile doesn't fix these.
+	my $work = $outref->[$line] // $inref->[$line];
+	if($work !~ m/ \s/) { # two spaces or space tab
+	    print STDERR "$rfn:$line: no indenting space to kill\n";
+	    return 0;
+	}
+	# Fix excessive spaces after known tab-aligned columns
+	while($work =~ s/(^|\t)        /$1\t/) { $handled=1; }
+	# This kills spaces at known tab-aligned columns before other tabs
+	while($work =~ s/(^|\t) +\t/$1\t/) { $handled=1; }
+	# The combination attempts to not mess up ascii art/tables.
+	$outref->[$line]=$work if($handled);
+    }
+
+    elsif($msg =~ m/^WARNING: please, no space before tabs/) {
+	# cleanfile will fix these, and do a better job.
+	my $work = $outref->[$line] // $inref->[$line];
+	if($work !~ m/ \t/) {
+	    # the above code indent fix may already have kicked in
+	    print STDERR "$rfn:$line: no pre-tab space to kill\n"
+		if(!defined($outref->[$line]));
+	    return 0;
+	}
+	# tabify excessive spaces before tabs
+	while($work =~ s/        \t/\t\t/) { $handled=1; }
+	# kill or tabify short runs of spaces
+	while($work =~ m/^(.*\t?)([^\t]*)( +)(\t.*)/s) {
+	    my $addtab = (length($2)%8+length($3))>=8 ? "\t" : "";
+	    $work = "$1$2$addtab$4";
+	    $handled=1;
+	}
+	# The combination attempts to not mess up ascii art/tables.
+	$outref->[$line]=$work if($handled);
+    }
+
+    elsif($msg =~ m/^WARNING: please, no spaces at the start of a line/) {
+	# cleanfile doesn't fix these.
+	my $work = $outref->[$line] // $inref->[$line];
+	if($work !~ m/^( +)/) {
+	    # code indent should use tabs may already have operated
+	    print STDERR "$rfn:$line: no leading space to kill\n" 
+		if(!defined($outref->[$line]));
+	    return 0;
+	}
+	my $spaces=length($1)%8;
+	my $tabs=(length($1)-$spaces)/8;
+	if(!$tabs) { $tabs=1; $spaces=0; }
+	my $subst=("\t"x$tabs).(" "x$spaces);
+	$work =~ s/^ +/$subst/;
+	$outref->[$line] = $work;
+	$handled=1;
+    }
+
+    elsif($msg =~ m{^WARNING: Use #include <linux/(\w+)\.h> instead of <asm/(\w+)\.h>}) {
+	my $hunt="<asm/$1.h>";
+	my $replace="<linux/$2.h>";
+	my $work = $outref->[$line] // $inref->[$line];
+	my $index=index($work, $hunt);
+	if($index<0) {
+	    print STDERR "$rfn:$line: erronious asm/ include not found\n";
+	    return 0;
+	}
+	substr($work,$index,length($hunt)) = $replace;
+	$outref->[$line] = $work;
+	$handled=1;
+    }
+
+    elsif($msg =~ m/WARNING: braces {} are not necessary for single statement blocks/) {
+	my $work = $outref->[$line] // $inref->[$line];
+	my $work2 = $outref->[$line+$tail] // $inref->[$line+$tail];
+	if($tail <= 1 or
+	   $work !~ m/\s*{\s*$/ or
+	   $work2 !~ m/^\s*}\s*$/) {
+	    print STDERR "$rfn:$line: cannot handle single statement braces\n";
+	    return 0;
+	}
+	$work =~ s/\s*{\s*$/\n/;
+	$outref->[$line] = $work;
+	$outref->[$line+$tail] = '';
+	$handled=1;
+    }
+
+    elsif($msg =~ m/^ERROR: that open brace { should be on the previous line/) {
+	my $work = $outref->[$line+$tail-1] // $inref->[$line+$tail-1];
+	my $work2 = $outref->[$line+$tail] // $inref->[$line+$tail];
+	if(!$tail or $work2 !~ m/^\s*\{\s*(\\?)$/) {
+	    print STDERR "$rfn:$line: cannot move open brace to previous line\n";
+	    return 0;
+	}
+	my $backslash=$1;
+	if(!$backslash) {
+	    $work =~ s/\s*$/ {/;
+	} else {
+	    $work =~ s/\s*(\\?)$/ { \\/;
+	}
+	$outref->[$line+$tail-1] = $work;
+	$outref->[$line+$tail] = '';
+	$handled=1;
+    }
+
+    elsif($msg =~ m/ERROR: return is not a function, parentheses are not required/) {
+	my $work = $outref->[$line] // $inref->[$line];
+	if($tail or ($work !~ m/return\s*\((.*)\)\s*;/) or ($1 =~ m/[()]/)) {
+	    print STDERR "$rfn:$line: cannot simplify return\n";
+	    return 0;
+	}
+	$work =~ s/return\s*\((.*)\)\s*;/return $1;/;
+	$outref->[$line] = $work;
+	$handled=1;
+    }
+
+    elsif($msg =~ m/^ERROR: "foo \* bar" should be "foo \*bar"/) {
+	my $work = $outref->[$line] // $inref->[$line];
+	my @segments=split(/(\s+\*\s+)/, $work);
+	if($tail or (scalar(@segments)>>1 != $whref->{'tally'})) {
+	    print STDERR "$rfn:$line: cannot fix $whref->{'tally'} 'foo * bar' instances in $work {", join(":", @segments), "}\n";
+	    return 0;
+	}
+	for(my $i=1; $i<scalar(@segments); $i+=2) {
+	    $segments[$i] = ' *';
+	}
+	$outref->[$line] = join('', @segments);
+	$handled=$whref->{'tally'};
+    }
+
+    elsif($msg =~ m/ERROR: spaces required around that '(\S+?)' \(ctx:(.x.)\)/) {
+	# the column is given to us, if the line's otherwise unmodified
+	# however, we can probably just work it out ourselves
+	my $work = $outref->[$line] // $inref->[$line];
+	my $op=$1;
+	if($tail or !$whref->{'column'} or
+	   ($work !~ m/(\S(\Q$op\E)\S?|\Q$op\E\S)/)) {
+	    print STDERR "$rfn:$line: cannot find '$op' without spacing\n";
+	    return 0;
+	}
+	my $opstart=$-[2] // $-[1]; # = start of op
+	if(defined($2)) {
+	    # have no leading space, may have trailing space
+	    substr($work, $opstart, length($op)) = " $op" .
+		((length($1)==length($op)+1) ? "" : " ");
+	} else {
+	    # have leading space, can't have trailing space
+	    substr($work, $opstart, length($op)) = "$op ";
+	}
+	$outref->[$line]=$work;
+	$handled=1;
+    }
+
+    elsif($msg =~ m/ERROR: space required before that '(\S+?)' \(ctx:(.)x.\)/) {
+	# the column is given to us, if the line's otherwise unmodified
+	# however, we can probably just work it out ourselves.
+	# foo==-1 will be fixed by the above correction of '=='
+	my $work = $outref->[$line] // $inref->[$line];
+	my ($op, $prior)=($1,$2);
+	if($tail or !$whref->{'column'} or ($work !~ m/\S(\Q$op\E)/)
+	   or ($work =~ m/\S\Q$op\E.*\S\Q$op\E/)) {
+	    print STDERR "$rfn:$line: cannot identify '$op' without spacing\n"
+		if($prior ne 'O' and !defined($outref->[$line]));
+	    return 0;
+	}
+	# This is fragile, naively it will separate perfectly valid a->b.
+	# Ensure that if we know we're after an operator, we don't even 
+	# think about changing a->b
+	if($prior eq 'O') {
+	    $work =~ s{([-*/%+=])\Q$op\E}{$1 $op} and $handled=1;
+	} else {
+	    $work =~ s/(\S)\Q$op\E/$1 $op/ and $handled=1;
+	}
+	# We really should use the column info we're given.
+	$outref->[$line]=$work if($handled);	
+    }
+
+    if($msg =~ m/^ERROR: space prohibited before that '(\S+)' \(ctx:(.x.)\)/) {
+	# the column is given to us, if the line's otherwise unmodified
+	# however, we can probably just work it out ourselves.
+	my $work = $outref->[$line] // $inref->[$line];
+	my $op=$1;
+	if($tail or !$whref->{'column'} or ($work !~ m/\s+\Q$op\E/) or
+	   ($work =~ m/\s+\Q$op\E.*?\s+\Q$op\E/)) {
+	    print STDERR "$rfn:$line: cannot identify '$op' with spacing\n";
+	    return 0;
+	}
+	$work =~ s/\s+\Q$op\E/$op/;
+	$outref->[$line]=$work;
+	$handled=1;
+    }
+
+    elsif($msg =~ m/^ERROR: space prohibited after that '(\S+)' \(ctx:(.x.)\)/) {
+	# the column is given to us, if the line's otherwise unmodified
+	# however, we can probably just work it out ourselves.
+	my $work = $outref->[$line] // $inref->[$line];
+	my $op=$1;
+	if($tail or !$whref->{'column'} or ($work !~ m/\Q$op\E\s+/) or
+	   ($work =~ m/\Q$op\E\s+.*?\Q$op\E\s+/)) {
+	    print STDERR "$rfn:$line: cannot identify '$op' with spacing\n";
+	    return 0;
+	}
+	$work =~ s/\Q$op\E\s+/$op/;
+	$outref->[$line]=$work;
+	$handled=1;
+    }
+
+    elsif($msg =~ m/^WARNING: space prohibited before semicolon/) {
+	my $work = $outref->[$line] // $inref->[$line];
+	my @segments = split(/(\s+;)/, $work);
+	if($tail or (scalar(@segments)>>1 != $whref->{'tally'})) {
+	    # FIXME: Alas this fails to correct for(... ; ... ; ...)
+	    # which only only one checkpatch warning.
+	    print STDERR "$rfn:$line: cannot fix $whref->{'tally'} semicolons"
+		. " in $work {", join(":", @segments), "}\n";
+	    return 0;
+	}
+	for(my $i=1; $i<scalar(@segments); $i+=2) {
+	    # Don't squish ';'s next to comment ends
+	    $segments[$i] = ';' if($segments[$i-1] !~ m{\*/});
+	}
+	$outref->[$line] = join('', @segments);
+	$handled=$whref->{'tally'};
+    }
+
+    elsif($msg =~ m/^WARNING: space prohibited between function name and open parenthesis '\('/) {
+	my $work = $outref->[$line] // $inref->[$line];
+	my @segments = split(/(\b\s+\()/, $work);
+	# Try first, bail later
+	my $notkeyword=0;
+	for(my $i=1; $i<scalar(@segments); $i+=2) {
+	    if($segments[$i-1] !~ m/\b(?:if|while|for|switch)/) {
+		$segments[$i] = '(';
+		++$notkeyword;
+	    }
+	}
+	# Did that work?
+	if($tail or ($notkeyword != $whref->{'tally'})) {
+	    print STDERR "$rfn:$line: cannot fix $whref->{'tally'} function calls"
+		. " in $work {", join(":", @segments), "}\n";
+	    return 0;
+	}
+	$outref->[$line] = join('', @segments);
+	$handled=$whref->{'tally'};
+    }
+
+    # Purely for debugging, let's see before and after
+    if($handled) {
+	print STDERR ("CHANGED:\n");
+	for(my $i=0; $i<=$tail; ++$i) {
+	    print STDERR
+		(defined($outref->[$line+$i])?"-":" ", 
+		 $inref->[$line+$i]);
+	}
+	for(my $i=0; $i<=$tail; ++$i) {
+	    print STDERR 
+		(!defined($outref->[$line+$i]) ? " $inref->[$line+$i]"
+		 : !length($outref->[$line+$i]) ? ""
+		 : "+$outref->[$line+$i]");
+	}
+	print("\n");
+    }
+    return $handled;
+}
+
+sub process_file($)
+{
+    my $fn=$_[0];
+    my $rfn=$aliases{$fn};
+    my @inp=(undef);
+    my @outp=(0);
+
+    open(FH, "<$rfn") or die("can't open $rfn");
+    while(<FH>) { push @inp, $_; }
+    close(FH);
+    my $changed=0;
+    my $aref=$files{$fn};
+    foreach my $whref (@$aref) {
+	if(!msg_is_OK($whref->{'message'})) {
+	    next;
+	}
+	my $tally=$whref->{'tally'};
+	while($tally>0) {
+	    my $handled=handle_message($rfn, $whref, \@inp, \@outp);
+	    last if (!$handled);
+	    $changed+=$handled;
+	    $tally-=$handled;
+	}
+    }
+    if($changed && !$dryrun) {
+	my $tmpname="$rfn.tmp.$$.bocp";
+	open(FH, ">$tmpname") or die("can't open $tmpname");
+	for(my $i=1; $i<=$#inp; ++$i) {
+	    print FH ($outp[$i] // $inp[$i]);
+	}
+	close(FH);
+	if(!-s $tmpname) { die("couldn't write $tmpname"); }
+	rename($tmpname, $rfn);
+    }
+}
+
+# Now actually do the work...
+foreach my $fn (@files) {
+    process_file($fn);
+}
+
-- 
1.7.9.5

