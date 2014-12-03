Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867AbaLCSGE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 13:06:04 -0500
Received: from smtprelay0126.hostedemail.com ([216.40.44.126]:37828 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750815AbaLCSGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 13:06:02 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:857:965:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4321:4390:5007:6261:7808:7875:8603:8660:9010:9389:10004:10400:10848:11232:11658:11914:12043:12517:12519:12663:12740:13069:13146:13148:13161:13229:13230:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: bird75_8bab448d13a06
X-Filterd-Recvd-Size: 2680
Message-ID: <1417629958.2902.18.camel@perches.com>
Subject: Re: Side-effect free printk?
From: Joe Perches <joe@perches.com>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: cocci <cocci@systeme.lip6.fr>, Sebastien.Hinderer@inria.fr,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 03 Dec 2014 10:05:58 -0800
In-Reply-To: <alpine.DEB.2.10.1412031855180.2373@hadrien>
References: <1417629003.2902.14.camel@perches.com>
	 <alpine.DEB.2.10.1412031855180.2373@hadrien>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-12-03 at 19:02 +0100, Julia Lawall wrote:
> 
> On Wed, 3 Dec 2014, Joe Perches wrote:
> 
> > Most all printks uses do not have any side-effects.
> >
> > Some however modify local or global state or perform
> > IO on various ports.
> >
> > Things like:
> >
> > drivers/video/fbdev/sa1100fb.c:	dev_dbg(fbi->dev, "DBAR1: 0x%08x\n", readl_relaxed(fbi->base + DBAR1));
> > drivers/remoteproc/remoteproc_core.c:	dev_err(dev, "handling crash #%u in %s\n", ++rproc->crash_cnt,
> >
> > CONFIG_PRINTK can be set to 'n', but all direct printk
> > calls still evaluate their arguments.
> >
> > These calls can unnecessarily increase code size.
> >
> > Some printk using macros are defined like:
> >
> > #define foo_dbg(fmt, ...)	\
> > do {				\
> > 	if (0)			\
> > 		printk(...);	\
> > } while (0)
> >
> > The compiler can optimize any use away so this can
> > eliminate any side-effect.
> >
> > For the general case, printk arguments that call
> > functions that perform simple calculations should not
> > qualify unless there is some global state change or
> > additional IO.
> >
> > So, with the goal of elimination of side-effects from
> > as many of the printks as possible (and the eventual
> > removal of all of the side-effects), is it possible to
> > use coccinelle to list all printk calls that have
> > side-effects in their arguments?
> >
> > It seems coccinelle would need the entire source tree
> > to do this, so I'm not sure it's possible, but it
> > doesn't hurt to ask...
[]
> When you say "have the entire source tree", do you mean things like:
> 
> printk(..., foo(x));
> 
> where it is not clear whether foo performs a side effect or not?  That
> could indeed be harder to detect.

Yes, exactly.

The ++/-- stuff is trivial.
grep can find those easily enough.


