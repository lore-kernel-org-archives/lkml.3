Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680AbaCRMpo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 08:45:44 -0400
Received: from smtprelay0116.hostedemail.com ([216.40.44.116]:55667 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752454AbaCRMpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 08:45:42 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2194:2198:2199:2200:2393:2553:2559:2562:2828:2915:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4250:4321:5007:6119:7652:8660:10004:10400:10848:11026:11232:11658:11914:12043:12296:12517:12519:12663:12679:12740:13018:13019:13148:13230,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,D
X-HE-Tag: spoon91_67a9231212a03
X-Filterd-Recvd-Size: 3479
Message-ID: <1395146702.2812.47.camel@joe-AO722>
Subject: Re: [PATCH 00/12] scsi/NCR5380: fix debugging macros and #include
 structure
From: Joe Perches <joe@perches.com>
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, Sam Creasey <sammy@sammy.net>,
        Russell King <linux@arm.linux.org.uk>,
        Michael Schmitz <schmitz@debian.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-m68k@vger.kernel.org
Date: Tue, 18 Mar 2014 05:45:02 -0700
In-Reply-To: <alpine.LNX.2.00.1403182208590.2018@nippy.intranet>
References: <20140318002822.372705594@telegraphics.com.au>
	 <1395112756.20860.1.camel@joe-AO722>
	 <alpine.LNX.2.00.1403182208590.2018@nippy.intranet>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-03-18 at 23:00 +1100, Finn Thain wrote:
> On Mon, 17 Mar 2014, Joe Perches wrote:
> > My preference would be to change dprintk to scsi_dbg
> Can you be more specific? I gather you're not referring to the debugging 
> routines in include/scsi/scsi_dbg.h as they aren't equivalent.
> 
> Is it the name "dprintk" you object to?

It's not an objection, just a preference.

I'm happy you're trying to wade through it and
promote some consistency in scsi.  Thank you.

> I went looking in drivers/scsi/ for some kind of naming convention for a 
> conditional printk. There are some other variations on the theme (DEBUG, 
> PDEBUG, PERROR, etc) but dprintk() seems to be the most popular.

True.  scsi is not what I would call an exemplar
for style consistency in linux-kernel.

Where is DEBUG #defined for this code?
git grep -w DEBUG drivers/scsi isn't pretty.

I suggest that dprintk be converted to something
that integrates well with the dynamic_debug
facility.  Most of the helper functions that
are integrated with dynamic_debug are named
something like <some_prefix>_dbg.

Most of the scsi dprintk defines (not NCR)
are similar to:

drivers/scsi/hptiop.h-#if 0
drivers/scsi/hptiop.h:#define dprintk(fmt, args...) do { printk(fmt, ##args); } while(0)
drivers/scsi/hptiop.h-#else
drivers/scsi/hptiop.h:#define dprintk(fmt, args...)
drivers/scsi/hptiop.h-#endif

No dynamic_debug, no format/arg mismatch checking
if not compiled in, no KERN_DEBUG level, etc.

NCR does use pr_debug for the dprintk call, but
it also doesn't verify fmt/arg matching when not
compiled in

drivers/scsi/NCR5380.h-#if NDEBUG
drivers/scsi/NCR5380.h:#define dprintk(flg, fmt, args...) \
drivers/scsi/NCR5380.h- do { if ((NDEBUG) & (flg)) pr_debug(fmt, ## args); } while (0)
[]
drivers/scsi/NCR5380.h-#else
drivers/scsi/NCR5380.h:#define dprintk(flg, fmt, args...)     do {} while (0)

It'd be nice to change the last do {} while (0)
to something like:

#define dprintk(flg, fmt, args...) \
do { if (0) pr_debug(fmt, ## args); } while (0)

so the compiler can always verify but not emit any
actual code or format strings.

Also, using macros with ... and __VA_ARGS__ is
a bit more modern.

#define dprintk(flg, fmt, ...) \
do { if (0) pr_debug(fmt, ##__VA_ARGS__); } while (0)




