Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978AbaJWRRD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 13:17:03 -0400
Received: from mga11.intel.com ([192.55.52.93]:36381 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751737AbaJWRRB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 13:17:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,776,1406617200"; 
   d="scan'208";a="619304945"
From: Jani Nikula <jani.nikula@intel.com>
To: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>, Kees Cook <keescook@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: regression: checkpatch.pl fails when called via symlink
In-Reply-To: <1413998015.18654.10.camel@perches.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <874muwv0ym.fsf@intel.com> <1413980418.18654.8.camel@perches.com> <87ppdktewn.fsf@intel.com> <1413998015.18654.10.camel@perches.com>
User-Agent: Notmuch/0.18.1+133~g83c61fa (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Thu, 23 Oct 2014 20:16:53 +0300
Message-ID: <87siieoge2.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Oct 2014, Joe Perches <joe@perches.com> wrote:
> On Wed, 2014-10-22 at 16:25 +0300, Jani Nikula wrote:
>> On Wed, 22 Oct 2014, Joe Perches <joe@perches.com> wrote:
>> > On Wed, 2014-10-22 at 13:43 +0300, Jani Nikula wrote:
>> >> Since commit 66b47b4a9dad00e45c049d79966de9a3a1f4d337
>> >> Author: Kees Cook <keescook@chromium.org>
>> >> Date:   Mon Oct 13 15:51:57 2014 -0700
>> >>     checkpatch: look for common misspellings
>> >> checkpatch.pl dies with
>> >> checkpatch.pl: Can't open /path/to/spelling.txt for reading: No such file or directory
>> >> 
>> >> if it's called through a symlink in /path/to/checkpatch.pl pointing at
>> >> the actual script.
>> >> 
>> >> Please fail graciously, and just ignore spelling if you can't find
>> >> spelling.txt. Or better yet, follow the links if you can.
>> >
>> > I agree it should fail better, but I'm also curious.
>> > Why you want to use a symlink?
>> 
>> Simply because I think having $HOME/bin in $PATH and a symlink there is
>> better than the alternatives.
> []
>> Reference: http://xkcd.com/1172/
>
> :)
>
> Try this:

Tested-by: Jani Nikula <jani.nikula@intel.com>

Thanks,
Jani.


>
>  scripts/checkpatch.pl | 38 +++++++++++++++++++++-----------------
>  1 file changed, 21 insertions(+), 17 deletions(-)
>
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index d94f5d8..a6354ec 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -7,10 +7,11 @@
>  
>  use strict;
>  use POSIX;
> +use File::Basename;
> +use Cwd 'abs_path';
>  
>  my $P = $0;
> -$P =~ s@(.*)/@@g;
> -my $D = $1;
> +my $D = dirname(abs_path($P));
>  
>  my $V = '0.32';
>  
> @@ -438,26 +439,29 @@ our $allowed_asm_includes = qr{(?x:
>  
>  # Load common spelling mistakes and build regular expression list.
>  my $misspellings;
> -my @spelling_list;
>  my %spelling_fix;
> -open(my $spelling, '<', $spelling_file)
> -    or die "$P: Can't open $spelling_file for reading: $!\n";
> -while (<$spelling>) {
> -	my $line = $_;
>  
> -	$line =~ s/\s*\n?$//g;
> -	$line =~ s/^\s*//g;
> +if (open(my $spelling, '<', $spelling_file)) {
> +	my @spelling_list;
> +	while (<$spelling>) {
> +		my $line = $_;
>  
> -	next if ($line =~ m/^\s*#/);
> -	next if ($line =~ m/^\s*$/);
> +		$line =~ s/\s*\n?$//g;
> +		$line =~ s/^\s*//g;
>  
> -	my ($suspect, $fix) = split(/\|\|/, $line);
> +		next if ($line =~ m/^\s*#/);
> +		next if ($line =~ m/^\s*$/);
> +
> +		my ($suspect, $fix) = split(/\|\|/, $line);
>  
> -	push(@spelling_list, $suspect);
> -	$spelling_fix{$suspect} = $fix;
> +		push(@spelling_list, $suspect);
> +		$spelling_fix{$suspect} = $fix;
> +	}
> +	close($spelling);
> +	$misspellings = join("|", @spelling_list);
> +} else {
> +	warn "No typos will be found - file '$spelling_file': $!\n";
>  }
> -close($spelling);
> -$misspellings = join("|", @spelling_list);
>  
>  sub build_types {
>  	my $mods = "(?x:  \n" . join("|\n  ", @modifierList) . "\n)";
> @@ -2246,7 +2250,7 @@ sub process {
>  		}
>  
>  # Check for various typo / spelling mistakes
> -		if ($in_commit_log || $line =~ /^\+/) {
> +		if (defined($misspellings) && ($in_commit_log || $line =~ /^\+/)) {
>  			while ($rawline =~ /(?:^|[^a-z@])($misspellings)(?:$|[^a-z@])/gi) {
>  				my $typo = $1;
>  				my $typo_fix = $spelling_fix{lc($typo)};
>
>

-- 
Jani Nikula, Intel Open Source Technology Center
