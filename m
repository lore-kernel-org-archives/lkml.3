Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938Ab3DVM47 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 08:56:59 -0400
Received: from www.linutronix.de ([62.245.132.108]:57947 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870Ab3DVM46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 08:56:58 -0400
Date: Mon, 22 Apr 2013 14:56:08 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Takashi Iwai <tiwai@suse.de>
cc: Borislav Petkov <bp@alien8.de>, paulmck@linux.vnet.ibm.com,
        x86-ml <x86@kernel.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: irq 16: nobody cared
In-Reply-To: <s5hzjwq53ec.wl%tiwai@suse.de>
Message-ID: <alpine.LFD.2.02.1304221432570.21884@ionos>
References: <20130420185330.GA4654@pd.tnic> <20130420235206.GA3509@linux.vnet.ibm.com> <20130421103403.GA4594@pd.tnic> <20130421163002.GB3509@linux.vnet.ibm.com> <s5hfvyj55ke.wl%tiwai@suse.de> <20130422091310.GA4637@pd.tnic> <s5hzjwq53ec.wl%tiwai@suse.de>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Apr 2013, Takashi Iwai wrote:
> At Mon, 22 Apr 2013 11:13:10 +0200,
> Borislav Petkov wrote:
> > 
> > On Mon, Apr 22, 2013 at 10:32:17AM +0200, Takashi Iwai wrote:
> > > Hm, if it's really due to a stray irq, just adding the missing
> > > synchronize_irq() like below would help?
> > > 
> > > 
> > > Takashi
> > > 
> > > ---
> > > diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
> > > index 7b213d5..262dbf1 100644
> > > --- a/sound/pci/hda/hda_intel.c
> > > +++ b/sound/pci/hda/hda_intel.c
> > > @@ -2682,6 +2682,8 @@ static void azx_stop_chip(struct azx *chip)
> > >  	/* disable interrupts */
> > >  	azx_int_disable(chip);
> > >  	azx_int_clear(chip);
> > > +	if (chip->irq >= 0)
> > > +		synchronize_irq(chip->irq);
> > 
> > Nope, it doesn't help - I see the same splat.
> 
> Thanks.  Then I have no idea what's missing in the current
> azx_suspend() and azx_resume() codes.

I asked Boris to add a disable_irq() on top of the azx_suspend()
function and that does not help either, but it tells us that the
interrupt storm arrives _BEFORE_ azx_suspend() is invoked.

So some other device shuts down and causes that. The obvious question
is whether this interrupt line is shared with something else.

Boris, can you please provide the irq16 line of /proc/interrupts
before you invoke suspend? 

If it's shared we know which driver is shutdown before hda_intel and
perhaps leaves its device in a weird state.

If it's not shared, it still might be shared behind the scene. The
other device uses MSI(X) and when shutdown MSI is disabled so the
default IRQ route which points to IRQ16 would be active again.

I assume, that the RCU stuff just causes enough timing difference to
uncover the underlying issue.

Thanks,

	tglx
