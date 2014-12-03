Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751665AbaLCRuL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 12:50:11 -0500
Received: from smtprelay0149.hostedemail.com ([216.40.44.149]:54743 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751482AbaLCRuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 12:50:09 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:857:965:973:988:989:1260:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3865:3866:3867:3868:3870:3871:3872:3874:4250:4390:5007:6261:7808:8603:8660:9010:9389:10004:10400:10848:11658:11914:12043:12517:12519:12663:12679:13069:13146:13148:13161:13229:13230:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: steam76_9f0d7f7ca5d
X-Filterd-Recvd-Size: 1925
Message-ID: <1417629003.2902.14.camel@perches.com>
Subject: Side-effect free printk?
From: Joe Perches <joe@perches.com>
To: Julia Lawall <julia.lawall@lip6.fr>, cocci <cocci@systeme.lip6.fr>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Wed, 03 Dec 2014 09:50:03 -0800
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most all printks uses do not have any side-effects.

Some however modify local or global state or perform
IO on various ports.

Things like:

drivers/video/fbdev/sa1100fb.c:	dev_dbg(fbi->dev, "DBAR1: 0x%08x\n", readl_relaxed(fbi->base + DBAR1));
drivers/remoteproc/remoteproc_core.c:	dev_err(dev, "handling crash #%u in %s\n", ++rproc->crash_cnt,

CONFIG_PRINTK can be set to 'n', but all direct printk
calls still evaluate their arguments.

These calls can unnecessarily increase code size.

Some printk using macros are defined like:

#define foo_dbg(fmt, ...)	\
do {				\
	if (0)			\
		printk(...);	\
} while (0)

The compiler can optimize any use away so this can
eliminate any side-effect.

For the general case, printk arguments that call
functions that perform simple calculations should not
qualify unless there is some global state change or
additional IO.

So, with the goal of elimination of side-effects from
as many of the printks as possible (and the eventual
removal of all of the side-effects), is it possible to
use coccinelle to list all printk calls that have
side-effects in their arguments?

It seems coccinelle would need the entire source tree
to do this, so I'm not sure it's possible, but it
doesn't hurt to ask...

