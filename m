Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543Ab3JLNI4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 09:08:56 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:47653 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723Ab3JLNIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 09:08:54 -0400
Date: Sat, 12 Oct 2013 14:08:52 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Joe Perches <joe@perches.com>
cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>
Subject: Re: [PATCH 2/2] framebuffer: Remove pmag-aa-fb
In-Reply-To: <alpine.LFD.2.03.1309201946430.8379@linux-mips.org>
Message-ID: <alpine.LFD.2.03.1310121308310.10951@linux-mips.org>
References: <c94f3e342947923f20d4c12932f382aa5200511b.1379641901.git.joe@perches.com>         <6f500d88eb23fd9a4cfc5583f5ca17bc5f58fe24.1379641901.git.joe@perches.com>         <CAMuHMdW6R5qTJ0uvsUUaYBZAqFcNshPsXeMbz5hwqq5UOkJr-g@mail.gmail.com>        
 <alpine.LFD.2.03.1309201907380.8379@linux-mips.org> <1379702587.2301.12.camel@joe-AO722> <alpine.LFD.2.03.1309201946430.8379@linux-mips.org>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe,

 Just a quick update.

On Sun, 22 Sep 2013, Maciej W. Rozycki wrote:

>  As to the PMAG-AA board itself -- well, this is indeed a very rare item, 
> but I happen to have a specimen.  To support it properly I'll first have 
> to wire it to a monitor somehow though; signalling is standard, 1.0 Vpp 
> composite monochrome, but what looks to me like a type F connector is used 
> for video output, quite unusually for a graphics card (and for DEC itself 
> too as 3W3 was their usual video socket).  It looks to me like converting 
> it to BNC and then a standard DE-15 VGA connector (via the green line) 
> will be the easiest way to get image produced by the adapter on a 
> contemporary monitor (sync-on-green required of course, but with LCD 
> devices being the norm now that seems less of a problem these days).

 So more weirdly even that's actually a TNC connector rather than a type F 
one.  I've got a suitable TNC->BNC adapter now (although regrettably such 
adapters seem to be available as 50Ù parts only; hopefully any distortion 
won't be too significant or maybe my digital monitor will even be able to 
compensate it, but at £1.76 (~$2.64) per item it's certainly worth trying 
before resorting to the original DEC TNC->BNC cable still apparently 
available from second-hand part suppliers at ~£80/$120 per a mere 1ft 
part) and a BNC->DE-15 cable is on the way.

> > --- a/drivers/video/pmag-aa-fb.c
> > +++ b/drivers/video/pmag-aa-fb.c
> > @@ -459,7 +459,7 @@ static int __init init_one(int slot)
> >  		return -EINVAL;
> >  
> >  	printk(KERN_INFO "fb%d: %s frame buffer in TC slot %d\n",
> > -	       GET_FB_IDX(ip->info.node), ip->info.modename, slot);
> > +	       ip->info.node, ip->info.modename, slot);
> >  
> >  	return 0;
> >  }
> 
>  Thanks, but the changes required are actually much more than that -- the 
> driver has never been converted to the modern TURBOchannel API.  I have 
> now dug out an old patch I was working on back in 2006 to convert this 
> driver as well as drivers/video/maxinefb.c.  I'll try to complete the two 
> drivers as soon as possible (unfortunately I can't test the latter at all; 
> it's for an onboard graphics adapter of another DECstation model), 
> although I now remember the main reason I didn't complete them back then 
> was they used an old internal API that was removed and no suitable 
> replacement provided.  I need to investigate again what that actually was 
> though (hw cursor probably).

 So I think I've got all the basic stuff covered now, including a change 
similar to your proposal as well as a conversion to the driver model/new 
TURBOchannel support infrastructure.  But what I remembered is actually 
right, the issue is wiring hardware cursor support into fbcon.  The driver 
uses its own display_switch structure with its own aafbcon_cursor handler 
to use the twin onboard Bt431 chips for cursor generation (there's also 
aafbcon_set_font that pokes at the Bt431s for cursor dimension changes).  
I need to figure out what the best way will be to make the fbcon subsystem 
support such an arrangement and that'll take me a little bit yet, so 
please be patient.

 Note that the board is weird enough to have a 1-bit (true monochrome) 
graphics plane, however the Bt455 used by the MX graphics adapter for 
screen image generation is a 4-bit grey-scale video RAMDAC (only the LSB 
inputs of its pixel port are wired to the graphics plane) and the twin 
Bt431s use the overlay plane to produce a 2-bit grey-scale cursor.  So we 
do want to use the hardware cursor to be able to make it prominent among 
the characters displayed throughout the screen and a software-generated 
cursor cannot really substitute what hardware provides.

  Maciej
