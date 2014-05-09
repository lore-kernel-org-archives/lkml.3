Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757940AbaEIVPq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 17:15:46 -0400
Received: from mail-bn1bon0064.outbound.protection.outlook.com ([157.56.111.64]:36542
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757918AbaEIVPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 17:15:41 -0400
X-Greylist: delayed 1963 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 May 2014 17:15:41 EDT
Date: Fri, 9 May 2014 15:37:48 -0500
From: Kim Phillips <kim.phillips@freescale.com>
To: Joe Perches <joe@perches.com>
CC: Andrew Morton <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, Andy Whitcroft <apw@canonical.com>
Subject: Re: [PATCH] checkpatch: Make --strict a default for files in
 drivers/net and net/
Message-ID: <20140509153748.e2467ab487404f07e818719e@freescale.com>
In-Reply-To: <487acde009f61607863704e5dd9da7f151cf5be8.1399486274.git.joe@perches.com>
References: <487acde009f61607863704e5dd9da7f151cf5be8.1399486274.git.joe@perches.com>
Organization: Freescale Semiconductor, Inc.
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.13; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(6009001)(164054003)(24454002)(189002)(199002)(2009001)(74502001)(77096999)(46102001)(83072002)(81342001)(81542001)(36756003)(76482001)(77156001)(21056001)(50226001)(50986999)(76176999)(4396001)(31966008)(74662001)(46406003)(92726001)(92566001)(79102001)(33646001)(64706001)(20776003)(100306002)(47776003)(62966002)(80022001)(23726002)(88136002)(19580405001)(68736004)(44976005)(93916002)(84676001)(69596002)(83322001)(19580395003)(81156002)(89996001)(86362001)(87286001)(6806004)(77982001)(87936001)(50466002);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR03MB019;H:az84smr01.freescale.net;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Forefront-PRVS: 02065A9E77
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Kim.Phillips@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 May 2014 11:13:26 -0700
Joe Perches <joe@perches.com> wrote:

> Networking files are generally more strictly conformant to
> linux-kernel style

checkpatch disagrees :) :

{drivers/}net/ :            ~10.8 CHECKs per .[hc] file
everything else:            ~10   CHECKs per .[hc] file
no net, no drivers/staging:  ~8.6 CHECKs per .[hc] file

(see [1] below for details).

> +		if ($found_file) {
> +			if ($realfile =~ m@^(drivers/net/|net/)@) {

this isn't easily extensible/scalable to other subsystems, or
say something like "all Freescale drivers."  Having it configurable
in .checkpatch.conf might be a better solution, but I don't believe
networking should be the only subsystem that can take advantage of
the extra checkpatch CHECKs.

Can we enable --strict universally in the Linux kernel, maybe like
so:?

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 34eb216..60e1a39 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -228,6 +228,7 @@ if ($tree) {
                print "Must be run from the top-level dir. of a kernel tree\n";
                exit(2);
        }
+       $check = 1;
 }
 
 my $emitted_corrupt = 0;

fwiw, --strict has been set unconditionally in u-boot's
.checkpatch.conf for over a year now, and has significantly reduced
patch revision churn for simple mistakes like parenthesis alignment,
spaces after a cast and/or before a semicolon...

Thanks,

Kim

[1] the following were run on kernel v3.15-rc4-260-g38583f0:

for i in `git ls-files | grep -v '^net/' | grep -v '^drivers/net/' | grep \\\.[ch]$`; do scripts/checkpatch.pl --strict -f $i; done | grep ^CHECK: | wc -l
328329
git ls-files | grep -v '^net/' | grep -v '^drivers/net/' | grep \\\.[ch]$ | wc -l
32754
=> 32754 / 328329 ~= 10 CHECKs per file.[ch] for everything outside of {drivers/}net/.

for i in `git ls-files net/ drivers/net/ | grep \\\.[ch]$`; do scripts/checkpatch.pl --strict -f $i; done | grep ^CHECK: | wc -l
40431
git ls-files net/ drivers/net/ | grep \\\.[ch]$ | wc -l
3742
=> {drivers/}net/: 40431 / 3742 = 10.8 CHECKs per file.[hc]

for i in `git ls-files | grep -v '^net/' | grep -v '^drivers/net/' | grep -v '^drivers/staging/' | grep \\\.[ch]$`; do scripts/checkpatch.pl --strict -f $i; done | grep ^CHECK: | wc -l
262005
git ls-files | grep -v '^net/' | grep -v '^drivers/net/' | grep -v '^drivers/staging/' | grep \\\.[ch]$ | wc -l
30479
=> no net, no staging:  262005 / 30479  =  8.6 CHECKs per file.[hc]
