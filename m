Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757695AbaEIU4U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 16:56:20 -0400
Received: from smtprelay0249.hostedemail.com ([216.40.44.249]:48055 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757249AbaEIU4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 16:56:18 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:800:960:966:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2196:2199:2393:2553:2559:2562:2691:2828:3138:3139:3140:3141:3142:3355:3622:3653:3865:3866:3867:3868:3870:3872:3874:4321:4385:4470:4605:5007:6119:7652:7903:8531:10004:10400:10848:10967:11232:11658:11914:12219:12295:12517:12519:12555:12740:13184:13229:13255:13870:14093:14097,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: sofa81_8e29de349de02
X-Filterd-Recvd-Size: 3873
Message-ID: <1399668975.2912.14.camel@joe-AO725>
Subject: Re: [PATCH] checkpatch: Make --strict a default for files in
 drivers/net and net/
From: Joe Perches <joe@perches.com>
To: Kim Phillips <kim.phillips@freescale.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Andy Whitcroft <apw@canonical.com>
Date: Fri, 09 May 2014 13:56:15 -0700
In-Reply-To: <20140509153748.e2467ab487404f07e818719e@freescale.com>
References: <487acde009f61607863704e5dd9da7f151cf5be8.1399486274.git.joe@perches.com>
	 <20140509153748.e2467ab487404f07e818719e@freescale.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-05-09 at 15:37 -0500, Kim Phillips wrote:
> On Wed, 7 May 2014 11:13:26 -0700
> Joe Perches <joe@perches.com> wrote:
> 
> > Networking files are generally more strictly conformant to
> > linux-kernel style
> 
> checkpatch disagrees :) :
> 
> {drivers/}net/ :            ~10.8 CHECKs per .[hc] file
> everything else:            ~10   CHECKs per .[hc] file
> no net, no drivers/staging:  ~8.6 CHECKs per .[hc] file
> 
> (see [1] below for details).
> 
> > +		if ($found_file) {
> > +			if ($realfile =~ m@^(drivers/net/|net/)@) {
> 
> this isn't easily extensible/scalable to other subsystems, or
> say something like "all Freescale drivers."  Having it configurable
> in .checkpatch.conf might be a better solution, but I don't believe
> networking should be the only subsystem that can take advantage of
> the extra checkpatch CHECKs.

staging probably could too.

> Can we enable --strict universally in the Linux kernel, maybe like
> so:?

I don't think that's appropriate (yet?).

Anyone that wants --strict checking can either add
it on the command line or create a .checkpatch.conf
file with --strict in it.

> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
[]
> @@ -228,6 +228,7 @@ if ($tree) {
>                 print "Must be run from the top-level dir. of a kernel tree\n";
>                 exit(2);
>         }
> +       $check = 1;
>  }
>  
>  my $emitted_corrupt = 0;
> 
> fwiw, --strict has been set unconditionally in u-boot's
> .checkpatch.conf for over a year now, and has significantly reduced
> patch revision churn for simple mistakes like parenthesis alignment,
> spaces after a cast and/or before a semicolon...

Good to know.

> [1] the following were run on kernel v3.15-rc4-260-g38583f0:
> 
> for i in `git ls-files | grep -v '^net/' | grep -v '^drivers/net/' | grep \\\.[ch]$`; do scripts/checkpatch.pl --strict -f $i; done | grep ^CHECK: | wc -l
> 328329
> git ls-files | grep -v '^net/' | grep -v '^drivers/net/' | grep \\\.[ch]$ | wc -l
> 32754
> => 32754 / 328329 ~= 10 CHECKs per file.[ch] for everything outside of {drivers/}net/.
> 
> for i in `git ls-files net/ drivers/net/ | grep \\\.[ch]$`; do scripts/checkpatch.pl --strict -f $i; done | grep ^CHECK: | wc -l
> 40431
> git ls-files net/ drivers/net/ | grep \\\.[ch]$ | wc -l
> 3742
> => {drivers/}net/: 40431 / 3742 = 10.8 CHECKs per file.[hc]
> 
> for i in `git ls-files | grep -v '^net/' | grep -v '^drivers/net/' | grep -v '^drivers/staging/' | grep \\\.[ch]$`; do scripts/checkpatch.pl --strict -f $i; done | grep ^CHECK: | wc -l
> 262005
> git ls-files | grep -v '^net/' | grep -v '^drivers/net/' | grep -v '^drivers/staging/' | grep \\\.[ch]$ | wc -l
> 30479
> => no net, no staging:  262005 / 30479  =  8.6 CHECKs per file.[hc]

Try that with a per-file "wc -l" for checks per LOC


