Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167Ab3CDDjN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 22:39:13 -0500
Received: from mail-ve0-f174.google.com ([209.85.128.174]:52207 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754981Ab3CDDjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:39:11 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFxA1pH_aKJc85DXuS2-Q=7b4pP-h_ms6XQiSzQcpWaO6Q@mail.gmail.com>
References: <CA+55aFx0HcOXKpxmZzM5jcbAaOroxafomX5ggMFV4A=py1qh-Q@mail.gmail.com>
	<alpine.LRH.2.00.1303040213590.11934@twin.jikos.cz>
	<CA+55aFxA1pH_aKJc85DXuS2-Q=7b4pP-h_ms6XQiSzQcpWaO6Q@mail.gmail.com>
Date: Sun, 3 Mar 2013 19:39:11 -0800
X-Google-Sender-Auth: J-QHULFLavJ_ysUy-8Fzb2e4-bM
Message-ID: <CA+55aFxVL1Nm=msUFJQY+K64aB8=CD8VCSiWY9pnKr7F6PfN4w@mail.gmail.com>
Subject: Re: Linux 3.9-rc1
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 3, 2013 at 5:42 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>     git log v3.8.. --author=Torvalds --merges |
>         egrep '^    ((Merge)|(Pull)) .* from '
>
> and then some nasty sed+sort crud, followed by some manual fixup. It's
> the kind of thing perl is perfect for, but I'm not much of a perl
> person, so I have never written a *good* script to just do this right.

Ok, this is still not good, but this at least makes my manual editing
minimal. There's a few extra lines that match the pattern that need
manual fixup, and some people with two different names (Ted vs
Theodore) but other than that it looks ok.

So do the above git long + egrep pipeline, and then pipe it to the
perl script below. I feel a git alias coming up in my future..

Real perl people may want to avert their eyes..

                Linus

---
#!/usr/bin/perl -w
use strict;

my (%map);

sub add_entry($$) {
    my ($key,$desc) = @_;

    if (exists $map{$key}) {
        my $obj = $map{$key};
        push(@$obj, $desc);
    } else {
        my @arr = ($desc);
        $map{$key} = \@arr;
    }
}

sub input {
    while (<>) {
        my ($type,$desc,$key) = (/^ *(\S*) *(.*) from *(.*)/);
        chomp($key = $3);
        chomp($desc = $2);
        chop $key if ($key =~ /(:|\.)$/);
        add_entry($key, $desc);
    }
}

sub by_name($$) {
        my ($a, $b) = @_;
        uc($a) cmp uc($b);
}

sub output {
    my ($key);

    foreach $key (sort by_name keys %map) {
        my ($obj, $desc);

        $obj = $map{$key};
        printf "%s: (%d)\n", $key, scalar(@$obj);
        print "\t$_\n" foreach @$obj;
        print "\n";
    }
}

input;
output;
exit(0)
