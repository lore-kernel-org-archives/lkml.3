Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232AbaKXRZR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 12:25:17 -0500
Received: from smtprelay0054.hostedemail.com ([216.40.44.54]:46557 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752322AbaKXRZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 12:25:15 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:69:355:379:541:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1543:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2553:2559:2562:2693:2828:2911:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4250:4321:4384:4425:5007:6261:7903:8957:9108:10004:10400:10848:10967:11026:11232:11473:11658:11914:12043:12296:12438:12517:12519:12683:12740:13146:13230:13972:14096:14097:21060:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: crime83_84c66c2f94233
X-Filterd-Recvd-Size: 3958
Message-ID: <1416849910.8797.1.camel@perches.com>
Subject: Re: [PATCH v2] ALSA: korg1212: cleanup of printk
From: Joe Perches <joe@perches.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Date: Mon, 24 Nov 2014 09:25:10 -0800
In-Reply-To: <s5hh9xottl9.wl-tiwai@suse.de>
References: <1416730251-5194-1-git-send-email-sudipm.mukherjee@gmail.com>
	 <s5hh9xottl9.wl-tiwai@suse.de>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-11-24 at 18:08 +0100, Takashi Iwai wrote:
> At Sun, 23 Nov 2014 13:40:51 +0530, Sudip Mukherjee wrote:
[]
> > replaced all references of the debug messages via printk
> > with dev_* macro (mostly dev_dbg).
> > one reference was changed to pr_err as there the card might have been
> > uninitialized.
> > 
> > this patch will generate warning from checkpatch about broken quoted
> > strings. but that was not fixed intentionally to improve the
> > readability.

I think it'd be easier to read and grep coalesced.

[]

> > in your review of v1, you said about some lines which are not ending
> > with \n. but i was not able to find them. did i miss them somewhere?
[]
> The problem is the one with multiple "\n", for example:
> 
> 	dev_dbg(korg1212->card->dev, "dspMemPhy = %08x U[%08x], "
> 		"PlayDataPhy = %08x L[%08x]\n"
> 		"korg1212: RecDataPhy = %08x L[%08x], "
> 		"VolumeTablePhy = %08x L[%08x]\n"
> 		"korg1212: RoutingTablePhy = %08x L[%08x], "
> 		"AdatTimeCodePhy = %08x L[%08x]\n",

I think these should be individual dev_dbg calls

	dev_dbg(korg1212->card->dev, "dspMemPhy = %08x U[%08x]\n", val, val2)
	dev_dbg(korg1212->card->dev, "PhyDataPhy = %08x L[%08x]\n", val, val2);
	dev_dbg(korg1212->card->dev, "RecDataPhy = %08x L[%08x]\n", val, val2);
	dev_dbg(korg1212->card->dev, "VolumeTablePhy = %08x L[%08x]\n", val, val2);

	etc..

Another possibility is to use another macro like:

#define k1212_dbg(k1212, fmt, ...)			\
	dev_dbg((k)->card->dev, fmt, ##__VA_ARGS__)

and change all these to

	k1212_dbg(korg1212, "dspMemPhy = %08x U[%08x]\n", val, val2)
	k1212_dbg(korg1212, "PhyDataPhy = %08x L[%08x]\n", val, val2);
	k1212_dbg(korg1212, "RecDataPhy = %08x L[%08x]\n", val, val2);
	k1212_dbg(korg1212, "VolumeTablePhy = %08x L[%08x]\n", val, val2);

etc.

> My biggest concern right now is, however, about the unnecessary code
> increase by this patch.  Currently, most of debug prints were simply
> not built, because of:
> 
> >  // ----------------------------------------------------------------------------
> > -// Debug Stuff
> > -// ----------------------------------------------------------------------------
> > -#define K1212_DEBUG_LEVEL		0
> > -#if K1212_DEBUG_LEVEL > 0
> > -#define K1212_DEBUG_PRINTK(fmt,args...)	printk(KERN_DEBUG fmt,##args)
> > -#else
> > -#define K1212_DEBUG_PRINTK(fmt,...)
> > -#endif
> > -#if K1212_DEBUG_LEVEL > 1
> > -#define K1212_DEBUG_PRINTK_VERBOSE(fmt,args...)	printk(KERN_DEBUG fmt,##args)
> > -#else
> > -#define K1212_DEBUG_PRINTK_VERBOSE(fmt,...)
> > -#endif
> 
> With your patch, now all these codes are compiled.

Not really.

dev_dbg is a no-op unless DEBUG is #defined
or CONFIG_DYNAMIC_DEBUG is set.

> I have no clear answer what would be the best in such a case.  I'd say
> it really depends.  If they are just silly messages that can be
> covered in a better way (like ftrace), just get rid of them.  If they
> are intended for some good register dumps, then dev_dbg() might make
> sense.

very true.

