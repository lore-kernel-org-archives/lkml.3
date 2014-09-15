Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758823AbaIOVCP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 17:02:15 -0400
Received: from smtprelay0049.hostedemail.com ([216.40.44.49]:49382 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754950AbaIOVCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 17:02:09 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2197:2199:2393:2559:2562:2693:2828:2892:2895:2899:3138:3139:3140:3141:3142:3165:3354:3622:3653:3865:3867:3868:3870:3871:3872:3874:4321:4605:5007:6119:6691:7652:7903:8957:9140:9545:10004:10400:10848:10946:11026:11232:11473:11658:11914:12043:12517:12519:12663:12679:12740:13161:13229:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: net10_86d881a1b0500
X-Filterd-Recvd-Size: 3269
Message-ID: <1410814924.18787.37.camel@joe-AO725>
Subject: Re: [PATCH 1/1] checkpatch: check for subject uniqueness in git
 repository.
From: Joe Perches <joe@perches.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 15 Sep 2014 14:02:04 -0700
In-Reply-To: <1410806637-3510-1-git-send-email-fabf@skynet.be>
References: <1410806637-3510-1-git-send-email-fabf@skynet.be>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-09-15 at 20:43 +0200, Fabian Frederick wrote:
> Adding patch subject uniqueness check in checkpatch --strict mode.
> See Documentation/SubmittingPatches/globally-unique identifier.

I'm not sold on the concept as I'm not sure that
global subject uniqueness is all that important.

There are many "update defconfig" type patches that
have identical subjects.  There really isn't a need
to have more information or add a numeric sequence #
to a subject like that.

> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
[]
> +# Check patch subject on subjective/strict check mode
> +		if ($check && $line =~ /^Subject: \[(.*)\](.*)/) {
> +			my $subject = $2;
> +			if ($quiet == 0) {
> +				print "Looking for patches with the same subject in git repository ...\n";
> +			}
> +			$git_samesubjects = `git log --oneline | grep -m1 "$subject\$" | wc  -l`;

checkpatch doesn't require a git repository to be
successfully used.

Please add a new function, something like the existing
"sub git_commit_info", for this so that if git is not
installed, there will not be a runtime failure.

Store the output in a perl array and use perl's grep
mechanism rather than the grep command line tool.

This will be _very_ slow.

On my computer with an ssd it takes > 20 seconds
just to do:

$ git --no-pager log --nocolor --no-merges --format='%H %s'

fyi: there are already > ~3500 commits with duplicate titles.

This will not find duplicate titles in a patch series unless
the patches were created with git and the current branch is
the same one that was used to create the series.

$ git checkout -b <name>
while (more changes to make) {
  [ modify / compile / test]
  $ git commit ...
}
$ git format-patch -o <dir> --cover-letter master
$ git checkout master
$ ./scripts/checkpatch.pl <dir>/*

No problem would be found...

Now for a patch series, it would be useful/better to scan
directories for patches with duplicate titles using
something like:

$ ./scripts/checkpatch.pl <dir>/*.patch

and compare the "^Subject:" lines for duplicates without
using git at all.

> @@ -5091,6 +5101,10 @@ sub process {
>  		ERROR("MISSING_SIGN_OFF",
>  		      "Missing Signed-off-by: line(s)\n");
>  	}
> +	if ($is_patch && $git_samesubjects > 0)  {
> +		WARN("NOT_UNIQUE_SUBJECT",
> +		     "similar subjects found in git repository\n");

s/similar subjects/identical patch subjects/


