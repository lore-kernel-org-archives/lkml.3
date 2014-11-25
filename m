Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751592AbaKYGVq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 01:21:46 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:42666 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbaKYGVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 01:21:45 -0500
Date: Tue, 25 Nov 2014 11:51:32 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ALSA: korg1212: cleanup of printk
Message-ID: <20141125062132.GA3380@sudip-PC>
References: <1416730251-5194-1-git-send-email-sudipm.mukherjee@gmail.com>
 <s5hh9xottl9.wl-tiwai@suse.de>
 <1416849910.8797.1.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416849910.8797.1.camel@perches.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2014 at 09:25:10AM -0800, Joe Perches wrote:
> On Mon, 2014-11-24 at 18:08 +0100, Takashi Iwai wrote:
> > At Sun, 23 Nov 2014 13:40:51 +0530, Sudip Mukherjee wrote:
> []
> > > replaced all references of the debug messages via printk
> > > with dev_* macro (mostly dev_dbg).
> > > one reference was changed to pr_err as there the card might have been
> > > uninitialized.
> > > 
> > > this patch will generate warning from checkpatch about broken quoted
> > > strings. but that was not fixed intentionally to improve the
> > > readability.
> 
> I think it'd be easier to read and grep coalesced.
or maybe better will be individual dev_dbg calls ....
> 
> []
> 
> > > in your review of v1, you said about some lines which are not ending
> > > with \n. but i was not able to find them. did i miss them somewhere?
> []
> > The problem is the one with multiple "\n", for example:
> > 
> > 	dev_dbg(korg1212->card->dev, "dspMemPhy = %08x U[%08x], "
> > 		"PlayDataPhy = %08x L[%08x]\n"
> > 		"korg1212: RecDataPhy = %08x L[%08x], "
> > 		"VolumeTablePhy = %08x L[%08x]\n"
> > 		"korg1212: RoutingTablePhy = %08x L[%08x], "
> > 		"AdatTimeCodePhy = %08x L[%08x]\n",
> 
> I think these should be individual dev_dbg calls
> 
> 	dev_dbg(korg1212->card->dev, "dspMemPhy = %08x U[%08x]\n", val, val2)
> 	dev_dbg(korg1212->card->dev, "PhyDataPhy = %08x L[%08x]\n", val, val2);
> 	dev_dbg(korg1212->card->dev, "RecDataPhy = %08x L[%08x]\n", val, val2);
> 	dev_dbg(korg1212->card->dev, "VolumeTablePhy = %08x L[%08x]\n", val, val2);
> 
> 	etc..
> 
> Another possibility is to use another macro like:
> 
> #define k1212_dbg(k1212, fmt, ...)			\
> 	dev_dbg((k)->card->dev, fmt, ##__VA_ARGS__)
> 
> and change all these to
> 
> 	k1212_dbg(korg1212, "dspMemPhy = %08x U[%08x]\n", val, val2)
> 	k1212_dbg(korg1212, "PhyDataPhy = %08x L[%08x]\n", val, val2);
> 	k1212_dbg(korg1212, "RecDataPhy = %08x L[%08x]\n", val, val2);
> 	k1212_dbg(korg1212, "VolumeTablePhy = %08x L[%08x]\n", val, val2);
> 
> etc.
> 
> > My biggest concern right now is, however, about the unnecessary code
> > increase by this patch.  Currently, most of debug prints were simply
> > not built, because of:
> > 
> > >  // ----------------------------------------------------------------------------
> > > -// Debug Stuff
> > > -// ----------------------------------------------------------------------------
> > > -#define K1212_DEBUG_LEVEL		0
> > > -#if K1212_DEBUG_LEVEL > 0
> > > -#define K1212_DEBUG_PRINTK(fmt,args...)	printk(KERN_DEBUG fmt,##args)
> > > -#else
> > > -#define K1212_DEBUG_PRINTK(fmt,...)
> > > -#endif
> > > -#if K1212_DEBUG_LEVEL > 1
> > > -#define K1212_DEBUG_PRINTK_VERBOSE(fmt,args...)	printk(KERN_DEBUG fmt,##args)
> > > -#else
> > > -#define K1212_DEBUG_PRINTK_VERBOSE(fmt,...)
> > > -#endif
> > 
> > With your patch, now all these codes are compiled.
> 
> Not really.
> 
> dev_dbg is a no-op unless DEBUG is #defined
> or CONFIG_DYNAMIC_DEBUG is set.
> 
> > I have no clear answer what would be the best in such a case.  I'd say
> > it really depends.  If they are just silly messages that can be
> > covered in a better way (like ftrace), just get rid of them.  If they
> > are intended for some good register dumps, then dev_dbg() might make
> > sense.
> 
> very true.
there are many dev_dbg which can be removed, they are just printing status message along with the statename of the card, and some dev_dbg is printing the arguments that the function has received.

in the exising file we already have the macro:
#define K1212_DEBUG_PRINTK(fmt,args...)        printk(KERN_DEBUG fmt,##args)

we can just modify the macro to:
#define K1212_DEBUG_PRINTK(fmt,args...)        dev_dbg(korg1212->card->dev, fmt,##args)

then we will have very little thing to change in the code. and concerns of Takashi about size will also be taken care of, and at the same time all printk will be cleared.

problems with this way:
1) macro name is little misleading - macro says printk, but we are using dev_dbg
2) if some one later wants to add something to this file, and doesnot want to use the variable name korg1212 in his function.

any suggestions ?

thanks
sudip
> 
