Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932207AbaJNNFF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 09:05:05 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:31977 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755138AbaJNNFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 09:05:03 -0400
Date: Tue, 14 Oct 2014 16:04:28 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Joe Perches <joe@perches.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, devel <devel@driverdev.osuosl.org>,
        Lidza Louina <lidza.louina@gmail.com>,
        DaeSeok Youn <daeseok.youn@gmail.com>,
        driverdev-devel@linuxdriverproject.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: dgap: re-arrange functions for removing forward
 declarations.
Message-ID: <20141014130428.GW23154@mwanda>
References: <20141013023425.GA15452@devel>
 <20141013032544.GA26646@kroah.com>
 <CAHb8M2A5e2akETQoWS6WfNJjUqhyu4ptfTMs9HLYgbw8XRR-Ww@mail.gmail.com>
 <1413212198.1287.9.camel@joe-AO725>
 <20141014020433.GA25433@kroah.com>
 <1413253178.3269.2.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nFreZHaLTZJo0R7j"
Content-Disposition: inline
In-Reply-To: <1413253178.3269.2.camel@joe-AO725>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 13, 2014 at 07:19:38PM -0700, Joe Perches wrote:
> I don't know of a way to compare objects when functions are
> rearranged in the source file.
> 
> Anyone else?

I have a perl script that I use to review function movement.  It barfed
on the DaeSeok's original patch so I re-wrote it, but it's still not
great.

Anyway, attached.

regards,
dan carpenter


--nFreZHaLTZJo0R7j
Content-Type: text/x-perl; charset=us-ascii
Content-Disposition: attachment; filename="move_rev.pl"

#!/usr/bin/perl

use strict;
use File::Temp qw/ tempdir /;
use File::Path qw/ rmtree /;
use File::Compare;

sub filter($) {
    my $_ = shift();

    # remove the first char
    s/^[ +-]//;
    return $_;
}

sub break_out_blocks($)
{
    my $dir = shift();
    my $block_nr = 0;

    open FILE, "<", "$dir/full";
    open OUT, ">", "$dir/$block_nr";

    while (<FILE>) {

        if ($block_nr && $_ =~ /^}/) {
            print OUT $_;
            close(OUT);
            $block_nr++;
            open OUT, ">", "$dir/$block_nr";
            next;
        }

        if ($_ =~ /^{/ || ($_ =~ /^[a-zA-Z]/ && $_ =~ / {$/)) {
            close(OUT);
            $block_nr++;
            open OUT, ">", "$dir/$block_nr";
        }

        print OUT $_;
    }
    close(OUT);
}

sub files_same($$)
{
    my $one = shift();
    my $two = shift();
    my $size_one = (stat($one))[7];
    my $size_two = (stat($two))[7];

    if ($size_one != $size_two) {
        return 0;
    }
    return compare($one, $two) == 0;
}

sub is_block($)
{
    my $file = shift();
    open LINE, "<", "$file";
    my $line = <LINE>;

    if ($line =~ /^{/ || ($line =~ /^[a-zA-Z]/ && $line =~ / {$/)) {
        return 1;
    }
    return 0;
}

sub replace_exact_blocks($$) {
    my $olddir = shift();
    my $newdir = shift();

    my $i = -1;
    while (1) {
        $i++;
        if (! -e "$olddir/$i") {
            last;
        }

        if (!is_block("$olddir/$i")) {
            next;
        }

        my $j = -1;
        while (1) {
            $j++;
            if (! -e "$newdir/$j") {
                last;
            }

            if (files_same("$olddir/$i", "$newdir/$j")) {

                open OUT, ">", "$olddir/$i";
                print OUT "- MOVED {$i}\n";
                close OUT;

                open OUT, ">", "$newdir/$j";
                print OUT "+ MOVED {$j}\n";
                close OUT;
                last;
            }

        }
    }
}

sub merge_blocks($) {
    my $dir = shift();

    open MERGED, ">", "$dir/merged";
    my $i = -1;
    while (1) {
        $i++;
        if (! -e "$dir/$i") {
            last;
        }

        open FILE, "<", "$dir/$i";
        while (<FILE>) {
            print MERGED $_;
        }
        close(FILE);
    }
    close(MERGED);
}

sub show_diff($$) {
    my $olddir = shift();
    my $newdir = shift();

    open diff, "diff -uw $olddir/merged $newdir/merged |";
    while (<diff>) {
        print $_;
    }
}

my $output;
my $inside = 0;
my $olddir = tempdir();
my $newdir = tempdir();

open oldfh, ">", "$olddir/full";
open newfh, ">", "$newdir/full";

#recreate an old file and a new file
while (<>) {
    if ($_ =~ /^(---|\+\+\+)/) {
        next;
    }

    if ($_ =~ /^@/) {
        $inside = 1;
    }
    if ($inside && !(($_ =~ /^[- @+]/) || ($_ =~ /^$/))) {
        $inside = 0;
    }
    if (!$inside) {
        next;
    }

    $output = filter($_);

    if ($_ =~ /^-/) {
        print oldfh $output;
        next;
    }
    if ($_ =~ /^\+/) {
        print newfh $output;
        next;
    }
    print oldfh $output;
    print newfh $output;

}

close(oldfh);
close(newfh);

break_out_blocks($olddir);
break_out_blocks($newdir);

replace_exact_blocks($olddir, $newdir);

merge_blocks($olddir);
merge_blocks($newdir);

show_diff($olddir, $newdir);

#print "old = $olddir/ new = $newdir/\n";
rmtree($olddir);
rmtree($newdir);

--nFreZHaLTZJo0R7j--
