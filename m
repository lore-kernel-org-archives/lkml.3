Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758722AbaGDPLN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 11:11:13 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:41752 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804AbaGDPLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 11:11:11 -0400
Date: Fri, 4 Jul 2014 16:11:28 +0100
From: Andy Whitcroft <apw@canonical.com>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] checkpatch: Emit a warning on file add/move/delete
Message-ID: <20140704151128.GC20758@bark>
References: <1404434816.6384.5.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404434816.6384.5.camel@joe-AO725>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 03, 2014 at 05:46:56PM -0700, Joe Perches wrote:
> Whenever files are added, moved, or deleted, the
> MAINTAINERS file patterns can be out of sync or
> outdated.
> 
> To try to keep MAINTAINERS more up-to-date, add a
> one-time warning whenever a patch does any of those.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  scripts/checkpatch.pl | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 496f9ab..0cf8b98 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -1679,7 +1679,7 @@ sub process {
>  
>  	my $in_header_lines = $file ? 0 : 1;
>  	my $in_commit_log = 0;		#Scanning lines before patch
> -
> +	my $reported_maintainer_file = 0;
>  	my $non_utf8_charset = 0;
>  
>  	my $last_blank_line = 0;
> @@ -2012,6 +2012,17 @@ sub process {
>  			      "Please use 12 to 16 chars for the git commit ID like: '${init_char}ommit $id (\"$desc\")'\n" . $herecurr);
>  		}
>  
> +# Check for added, moved or deleted files
> +		if (!$reported_maintainer_file && !$in_commit_log &&
> +		    ($line =~ /^(?:new|deleted) file mode\s*\d+\s*$/ ||
> +		     $line =~ /^rename (?:from|to) [\w\/\.\-]+\s*$/ ||
> +		     ($line =~ /\{\s*([\w\/\.\-]*)\s*\=\>\s*([\w\/\.\-]*)\s*\}/ &&
> +		      (defined($1) || defined($2))))) {
> +			$reported_maintainer_file = 1;
> +			WARN("FILE_PATH_CHANGES",
> +			     "added, moved or deleted file(s), does MAINTAINERS need updating?\n" . $herecurr);
> +		}
> +
>  # Check for wrappage within a valid hunk of the file
>  		if ($realcnt != 0 && $line !~ m{^(?:\+|-| |\\ No newline|$)}) {
>  			ERROR("CORRUPTED_PATCH",

That seems like a sensible plan.  Sometime we might try and work out if
any entries are affected or needed.

I think you are checking against the git ways of mentioning this only,
don't know if there is any milage in checking the dates which also
convey add/remove info via datea at the epoch.

Acked-by: Andy Whitcroft <apw@canonical.com>

-apw
