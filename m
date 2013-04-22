Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932259Ab3DVOop (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 10:44:45 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:57884 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754989Ab3DVOon (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 10:44:43 -0400
Date: Mon, 22 Apr 2013 07:44:02 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, Takashi Iwai <tiwai@suse.de>,
        x86-ml <x86@kernel.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: irq 16: nobody cared
Message-ID: <20130422144402.GK3509@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130420185330.GA4654@pd.tnic>
 <20130420235206.GA3509@linux.vnet.ibm.com>
 <20130421103403.GA4594@pd.tnic>
 <20130421163002.GB3509@linux.vnet.ibm.com>
 <s5hfvyj55ke.wl%tiwai@suse.de>
 <20130422091310.GA4637@pd.tnic>
 <s5hzjwq53ec.wl%tiwai@suse.de>
 <alpine.LFD.2.02.1304221432570.21884@ionos>
 <20130422142356.GA4658@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130422142356.GA4658@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042214-5806-0000-0000-000020D1E6EC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 22, 2013 at 04:23:56PM +0200, Borislav Petkov wrote:
> On Mon, Apr 22, 2013 at 02:56:08PM +0200, Thomas Gleixner wrote:
> > Boris, can you please provide the irq16 line of /proc/interrupts
> > before you invoke suspend?
> >
> > If it's shared we know which driver is shutdown before hda_intel and
> > perhaps leaves its device in a weird state.
> >
> > If it's not shared, it still might be shared behind the scene. The
> > other device uses MSI(X) and when shutdown MSI is disabled so the
> > default IRQ route which points to IRQ16 would be active again.
> >
> > I assume, that the RCU stuff just causes enough timing difference to
> > uncover the underlying issue.
> 
> Hmm, as Takashi reminded me, this box has two audio controllers. So
> could it be that when we shutdown and disable MSI, the interrupts get
> routed to to IRQ16 and they overflow there? Just a wild guess, I guess.

Would it make sense to try shutting off the hardware, waiting (say)
100 milliseconds, then diabling the irq?  (Hey, had to ask!)

							Thanx, Paul

> I very well can imagine that those two audio controllers to be one where
> some f*cked up BIOS shim switches between the two but can't keep them
> apart properly.
> 
> Something like the HPET fiascos...
> 
> * This is irq counts with my patch to expedite RCU grace periods:
> 
> - before suspend:
> # grep snd /proc/interrupts
>   16:       1304       1340       1335       1329       1293       1348       1357       1363   IO-APIC-fasteoi   snd_hda_intel
>   90:          3          3          4          4          4          4          3          3   PCI-MSI-edge      snd_hda_intel
> 
> - after resume:
> # grep snd /proc/interrupts
>   16:       1354       1389       1386       1380       1344       1400       1409       1495   IO-APIC-fasteoi   snd_hda_intel
>   90:          0          0          0          0          0          0          0          5   PCI-MSI-edge      snd_hda_intel
> 
> 
> * "normal" RCU grace periods:
> 
> - before suspend:
> # grep snd /proc/interrupts
>   16:        109        108        107        108        108        108        109        111   IO-APIC-fasteoi   snd_hda_intel
>   90:          3          3          4          4          4          4          3          3   PCI-MSI-edge      snd_hda_intel
> 
> - after resume:
> # grep snd /proc/interrupts
>   16:        154        154        153        155        157        157        235        164   IO-APIC-fasteoi   snd_hda_intel
>   90:          0          0          0          0          0          0          5          0   PCI-MSI-edge      snd_hda_intel
> 
> More "hmm.."
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> Sent from a fat crate under my desk. Formatting is fine.
> --
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

