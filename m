Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968AbaJHPjh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 11:39:37 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:49866 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029AbaJHPjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 11:39:35 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ley Foon Tan <lftan@altera.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        lftan.linux@gmail.com, cltang@codesourcery.com
Subject: Re: [PATCH v4 21/29] nios2: Time keeping
Date: Wed, 08 Oct 2014 17:39:26 +0200
Message-ID: <2785501.FjgXQVl8Ik@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <alpine.DEB.2.11.1410081719340.4292@nanos>
References: <1412760595-3935-1-git-send-email-lftan@altera.com> <3820417.zXtDk8QPj1@wuerfel> <alpine.DEB.2.11.1410081719340.4292@nanos>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:hYOAfza0FsnFD2nkcazss7RKgJTp/WBjqBouF/C7HB9
 xo5XOMBpeI4Pehz+9GFwnEeZvDUay/qawkdzt5S3wzCLqDnIWo
 CpPtKgXCiYXOPvy/QrdzPTe74HEqNoF4hE1bEkVf82xboZZAOi
 3cHNjsOwj5ElpCSZtbIC0AlUr+AG6+uwjWCo5vbq6wpgU4WyXv
 NLKiKNdHzk2MmVE5WmYBN5SP035ubVoEO2122ZxM+ef3KiZCTX
 WSf4t0VAuOuRGy0sPCru7k9LwVGNRZKWpSGV4C2HgbwMuzhRR3
 9/XISg3K6PJibepYrPiGCRohrf0Cce01pXjpkVERPdaIVOU590
 uDQtp94mVPfXEZTRHjrQ=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 October 2014 17:20:44 Thomas Gleixner wrote:
> On Wed, 8 Oct 2014, Arnd Bergmann wrote:
> > On Wednesday 08 October 2014 12:44:32 Thomas Gleixner wrote:
> > > > +static int num_called;
> > > > +static void __init nios2_time_init(struct device_node *timer)
> > > > +{
> > > > +     switch (num_called) {
> > > > +     case 0:
> > > > +             nios2_clockevent_init(timer);
> > > > +             break;
> > > > +     case 1:
> > > > +             nios2_clocksource_init(timer);
> > > > +             break;
> > > > +     default:
> > > > +             break;
> > > > +     }
> > > > +
> > > > +     num_called++;
> > > > +}
> > > 
> > > Eew. So this depends on the DT ordering. If thats wrong, then stuff
> > > will be initialized in the wrong oder. 
> > > 
> > > > +CLOCKSOURCE_OF_DECLARE(nios2_timer, "altr,timer-1.0", nios2_time_init);
> > > 
> > > Why can't you have separate match entries with where one calls
> > > nios2_clockevent_init and the other nios2_clocksource_init?
> > 
> > I believe we have the same logic in other drivers as well, the intention
> > being that if you have multiple identical timers, the first one will
> > be used as clockevent and the second one (if there is more than one)
> > becomes the clocksource.
> > 
> > If the hardware is really identical, I would argue that the comaptible
> > string ought to be the same as well, as the DT is not supposed to
> > care about what the timers are used for in Linux.
> 
> So why do we need two calls at all if we have one piece of hardware
> which has two functions? We know that already, don't we?

It's not one piece of hardware with two functions, but multiple (n >= 1)
pieces of identical hardware at different register locations.

The usual case is that you have one hardware block that may exist in
any number of instances, but each instance can only be used for
either clockevent or clocksource but not both.

If we have only one instance in an FPGA, the code above will use
it as a clockevent. If there are two or more instances, the second
one gets used as clocksource and all others are unused, until we
change the kernel to come up with a third use case.

	Arnd
