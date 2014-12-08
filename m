Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551AbaLHUVF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 15:21:05 -0500
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:60298 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750998AbaLHUVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 15:21:03 -0500
Message-ID: <1418070059.2058.39.camel@x220>
Subject: Re: [PATCH 0/3] remove undocumented type definition alias
From: Paul Bolle <pebolle@tiscali.nl>
To: Christoph Jaeger <cj@linux.com>
Cc: yann.morin.1998@free.fr, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, dborkman@redhat.com
Date: Mon, 08 Dec 2014 21:20:59 +0100
In-Reply-To: <cover.1418003065.git.cj@linux.com>
References: <cover.1418003065.git.cj@linux.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Dec 2014 20:20:59.0036 (UTC) FILETIME=[7A9945C0:01D01324]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-12-07 at 20:49 -0500, Christoph Jaeger wrote:
> This patchset removes support for the undocumented type definition keyword
> 'boolean', that is used in some config option definitions, in favor of the
> much more widely used 'bool'. Both are semantically equivalent.
> 
> % git grep -w bool -- '*Kconfig*' | wc -l
> 7065
> % git grep -w boolean -- '*Kconfig*' | wc -l
> 94

(Side note: I _always_ use: $SOME_GIT_GREP $(git ls-files "*Kconfig*").
Have I been typing too much all those years?)

> Having this alias is more confusing than helpful.

Agree. (boolean is a better keyword than bool. Changing 7065 lines
instead of 94 for that reason alone would be overdoing it.)

> This change was suggested by Daniel Borkmann <dborkman@redhat.com>.
> 
> 
> Patch 3/3 is purely cosmetic and therefore optional.
> 
> Christoph Jaeger (3):
>   kconfig: regenerate parser
>   kconfig: remove undocumented type definition alias 'boolean'
>   kconfig: rename S_BOOLEAN to S_BOOL for consistency

For the record. I tested these three patches, on top of next-20141208,
with this bit of perl:

use 5.016;
use warnings;
use autodie;

exit main ( @ARGV );

sub main {
	my ($tree) = @ARGV;

	open( my $git_ls_tree, "-|", "git", "ls-tree", "-r", $tree );
	my $slurp = do { local $/ = undef; <$git_ls_tree> };
	my @lines = split( /\n/, $slurp );
	foreach my $line ( @lines ) {
		my ( @tmp ) = split( /\s/, $line );
		if ($tmp[3] =~ 'defconfig$' ) {
			my $arch;
			my $defconfig = $tmp[3];
			($arch = $tmp[3]) =~ s/arch\/(\w+)\/.*/$1/;

			`cp $defconfig .config`;
			`yes "" | make ARCH=$arch oldconfig`;
			my $out = `md5sum .config`;
			my (@tmp) = split( /\s/, $out );
			say( $tmp[0] );
		}
	}
	close( $git_ls_tree );

	0;
}

Note how I have trouble following my own whitespace rules. If someone
spots a flaw in this approach I'm all ears.

I'll add further feedback on the patches themselves.

Thanks,


Paul Bolle

