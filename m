Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656AbaITQH1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 12:07:27 -0400
Received: from smtprelay0022.hostedemail.com ([216.40.44.22]:48637 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750963AbaITQH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 12:07:26 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3165:3355:3622:3653:3865:3866:3867:3868:3870:3871:3872:3873:3874:4321:4605:5007:6119:6691:7652:7875:7903:8531:8828:8957:10004:10400:10848:11026:11232:11658:11914:12043:12438:12517:12519:12555:12663:12679:12740:13161:13229:13548:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: mask18_23892c244971f
X-Filterd-Recvd-Size: 3654
Message-ID: <1411229243.24444.51.camel@joe-AO725>
Subject: Re: [PATCH 1/1] checkpatch: check for subject uniqueness in git
 repository.
From: Joe Perches <joe@perches.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Date: Sat, 20 Sep 2014 09:07:23 -0700
In-Reply-To: <2022098628.197398.1411209094968.open-xchange@webmail.nmp.skynet.be>
References: <1410806637-3510-1-git-send-email-fabf@skynet.be>
	 <1410837769.18787.40.camel@joe-AO725>
	 <1685749151.185639.1410884118738.open-xchange@webmail.nmp.skynet.be>
	 <1410885094.16519.6.camel@joe-AO725>
	 <2022098628.197398.1411209094968.open-xchange@webmail.nmp.skynet.be>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-09-20 at 12:31 +0200, Fabian Frederick wrote:
> > On 16 September 2014 at 18:31 Joe Perches <joe@perches.com> wrote:
> > On Tue, 2014-09-16 at 18:15 +0200, Fabian Frederick wrote:
> > > > On 16 September 2014 at 05:22 Joe Perches <joe@perches.com> wrote:
> > > > On Mon, 2014-09-15 at 20:43 +0200, Fabian Frederick wrote:
> > > > > Adding patch subject uniqueness check in checkpatch --strict mode.
> > > > > See Documentation/SubmittingPatches/globally-unique identifier.
> > > >
> > > > Perhaps something like this?
> > []
> > > > diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> > []
> > > > +     if ($check && $#git_commits < 1 && which("git") && -e ".git") {
> > > > +             my $output = `git log --no-color --format='%H %s' 2>&1`;
> > > > +             $output =~ s/^\s*//gm;
> > > > +             @git_commits = split("\n", $output);
> > > > +     }
> >
> > > Perfect ! :)
> >
> > Except for that _really, really_ long time to do the
> > git log of all commits...
> >
> > Maybe the git log should be enabled only with another
> > command-line option.
> >
> Hello Joe,

Dag Fabian:

> checkpatck does already execute git log in seed_camelcase_includes and
> git_commit_info when .git exists

which takes almost no time

$ time git log --no-merges --pretty=format:"%h%n" -1 -- include
40182b1

real	0m0.013s
user	0m0.008s
sys	0m0.000s

and

$ time git log --no-color --format='%H %s' -1 ^HEAD 2>&1

real	0m0.013s
user	0m0.004s
sys	0m0.004s

vs

$ time git log --no-merges --pretty=format:"%H %s" > /dev/null 2>&1

real	0m19.386s
user	0m17.264s
sys	0m1.008s

> so we could add some specific option instead like --complete --verbose
> --checkduplicates or something for this test ?

Maybe.

I'm still dubious about both the git use because of
the runtime and the checkpatch use as it's after the
fact.

The concept seems more suited to a git commit-msg hook
to me.  The runtime there is still a consideration too.

In a bit more detail:

If this modified checkpatch was run on a branch where
the patch was committed, in this sort of sequence:

	git checkout -b [some_branch]
	[make changes]
	git commit [etc]
	git format-patch -1
	./scripts/checkpatch.pl <patch from git format-patch>

then this new warning would trigger which seems senseless.

And in the case where multiple patches are done and then
scanned with checkpatch in a single block, the damage has
already been done and the defect was not found when it
occurred.

Andrew? Do you have an opinion?

