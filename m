Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932462AbaEIVe0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 17:34:26 -0400
Received: from mail-by2on0083.outbound.protection.outlook.com ([207.46.100.83]:63115
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757470AbaEIVeW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 17:34:22 -0400
X-Greylist: delayed 2155 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 May 2014 17:34:21 EDT
Date: Fri, 9 May 2014 16:29:14 -0500
From: Kim Phillips <kim.phillips@freescale.com>
To: Joe Perches <joe@perches.com>
CC: Andrew Morton <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, Andy Whitcroft <apw@canonical.com>
Subject: Re: [PATCH] checkpatch: Make --strict a default for files in
 drivers/net and net/
Message-ID: <20140509162914.8f8ac84b3a973820a21e5c2d@freescale.com>
In-Reply-To: <1399668975.2912.14.camel@joe-AO725>
References: <487acde009f61607863704e5dd9da7f151cf5be8.1399486274.git.joe@perches.com>
	<20140509153748.e2467ab487404f07e818719e@freescale.com>
	<1399668975.2912.14.camel@joe-AO725>
Organization: Freescale Semiconductor, Inc.
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.13; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(6009001)(24454002)(199002)(189002)(51704005)(377424004)(164054003)(87936001)(88136002)(89996001)(81342001)(81156002)(33646001)(81542001)(87286001)(44976005)(79102001)(19580395003)(62966002)(23726002)(6806004)(83322001)(74662001)(74502001)(93916002)(50226001)(4396001)(36756003)(31966008)(20776003)(47776003)(69596002)(84676001)(68736004)(80022001)(50466002)(64706001)(77156001)(83072002)(2009001)(86362001)(92726001)(50986999)(46406003)(19580405001)(76482001)(76176999)(77096999)(21056001)(92566001)(100306002)(77982001)(46102001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB028;H:az84smr01.freescale.net;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Forefront-PRVS: 02065A9E77
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Kim.Phillips@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 May 2014 13:56:15 -0700
Joe Perches <joe@perches.com> wrote:

> On Fri, 2014-05-09 at 15:37 -0500, Kim Phillips wrote:
> > On Wed, 7 May 2014 11:13:26 -0700
> > Joe Perches <joe@perches.com> wrote:
> > 
> > > Networking files are generally more strictly conformant to
> > > linux-kernel style
> > 
> > checkpatch disagrees :) :
> > 
> > {drivers/}net/ :            ~10.8 CHECKs per .[hc] file
> > everything else:            ~10   CHECKs per .[hc] file
> > no net, no drivers/staging:  ~8.6 CHECKs per .[hc] file
> > 
> > (see [1] below for details).
> > 
> > > +		if ($found_file) {
> > > +			if ($realfile =~ m@^(drivers/net/|net/)@) {
> > 
> > this isn't easily extensible/scalable to other subsystems, or
> > say something like "all Freescale drivers."  Having it configurable
> > in .checkpatch.conf might be a better solution, but I don't believe
> > networking should be the only subsystem that can take advantage of
> > the extra checkpatch CHECKs.
> 
> staging probably could too.

why call staging out to be subject to stricter checks than the rest
of the kernel, when it's code that's _known_ to be non-compliant?

> > Can we enable --strict universally in the Linux kernel, maybe like
> > so:?
> 
> I don't think that's appropriate (yet?).

why not?  checkpatch CHECKs seem reasonably stable AFAICT.

> Anyone that wants --strict checking can either add
> it on the command line

most aren't aware of --strict, and even if they are, easily forget
to add it.

> or create a .checkpatch.conf
> file with --strict in it.

right, but since checkpatch already has internal knowledge of the
linux kernel, I thought it inappropriate to add a .checkpatch.conf,
and use the $tree switch.

> > diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> []
> > @@ -228,6 +228,7 @@ if ($tree) {
> >                 print "Must be run from the top-level dir. of a kernel tree\n";
> >                 exit(2);
> >         }
> > +       $check = 1;
> >  }
> >  
> >  my $emitted_corrupt = 0;
> > 
> > fwiw, --strict has been set unconditionally in u-boot's
> > .checkpatch.conf for over a year now, and has significantly reduced
> > patch revision churn for simple mistakes like parenthesis alignment,
> > spaces after a cast and/or before a semicolon...
> 
> Good to know.

would an alternative option be to promote CHECKs like parentheses
alignment to WARN status?

> > [1] the following were run on kernel v3.15-rc4-260-g38583f0:
> > 
> > for i in `git ls-files | grep -v '^net/' | grep -v '^drivers/net/' | grep \\\.[ch]$`; do scripts/checkpatch.pl --strict -f $i; done | grep ^CHECK: | wc -l
> > 328329
> > git ls-files | grep -v '^net/' | grep -v '^drivers/net/' | grep \\\.[ch]$ | wc -l
> > 32754
> > => 32754 / 328329 ~= 10 CHECKs per file.[ch] for everything outside of {drivers/}net/.
> > 
> > for i in `git ls-files net/ drivers/net/ | grep \\\.[ch]$`; do scripts/checkpatch.pl --strict -f $i; done | grep ^CHECK: | wc -l
> > 40431
> > git ls-files net/ drivers/net/ | grep \\\.[ch]$ | wc -l
> > 3742
> > => {drivers/}net/: 40431 / 3742 = 10.8 CHECKs per file.[hc]
> > 
> > for i in `git ls-files | grep -v '^net/' | grep -v '^drivers/net/' | grep -v '^drivers/staging/' | grep \\\.[ch]$`; do scripts/checkpatch.pl --strict -f $i; done | grep ^CHECK: | wc -l
> > 262005
> > git ls-files | grep -v '^net/' | grep -v '^drivers/net/' | grep -v '^drivers/staging/' | grep \\\.[ch]$ | wc -l
> > 30479
> > => no net, no staging:  262005 / 30479  =  8.6 CHECKs per file.[hc]
> 
> Try that with a per-file "wc -l" for checks per LOC

good point, that reinforces the statement back for networking :) :

{drivers/}net/ :            0.013 CHECKs per .[hc] file line
everything else:            0.43  CHECKs per .[hc] file line
no net, no drivers/staging: 0.38  CHECKs per .[hc] file line

Thanks,

Kim
