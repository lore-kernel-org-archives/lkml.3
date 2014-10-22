Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442AbaJVHSu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 03:18:50 -0400
Received: from down.free-electrons.com ([37.187.137.238]:49871 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751022AbaJVHSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 03:18:48 -0400
Date: Wed, 22 Oct 2014 09:18:45 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Sebastian Reichel <sre@kernel.org>, linux-pm@vger.kernel.org,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        linux-arm-kernel@lists.infradead.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [PATCH 5/8] power: reset: at91-reset: use at91_ramc_shutdown
Message-ID: <20141022071845.GM10616@piout.net>
References: <1413928540-27099-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1413928540-27099-6-git-send-email-alexandre.belloni@free-electrons.com>
 <20141022090810.167c470f@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141022090810.167c470f@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/10/2014 at 09:08:10 +0200, Thomas Petazzoni wrote :
> Dear Alexandre Belloni,
> 
> On Tue, 21 Oct 2014 23:55:37 +0200, Alexandre Belloni wrote:
> 
> >  /*
> >  * unless the SDRAM is cleanly shutdown before we hit the
> >  * reset register it can be left driving the data bus and
> >  * killing the chance of a subsequent boot from NAND
> >  */
> > -static void at91sam9260_restart(enum reboot_mode mode, const char *cmd)
> > +static void at91_restart(enum reboot_mode mode, const char *cmd)
> >  {
> > -	asm volatile(
> > -		/* Align to cache lines */
> > -		".balign 32\n\t"
> > -
> > -		/* Disable SDRAM accesses */
> > -		"str	%2, [%0, #" __stringify(AT91_SDRAMC_TR) "]\n\t"
> > -
> > -		/* Power down SDRAM */
> > -		"str	%3, [%0, #" __stringify(AT91_SDRAMC_LPR) "]\n\t"
> > +	if (at91_ramc_shutdown)
> > +		at91_ramc_shutdown();
> >  
> > +	asm volatile(
> >  		/* Reset CPU */
> > -		"str	%4, [%1, #" __stringify(AT91_RSTC_CR) "]\n\t"
> > +		"str	%1, [%0, #" __stringify(AT91_RSTC_CR) "]\n\t"
> >  
> >  		"b	.\n\t"
> 
> Are you sure this is working properly? There was a reason to have the
> SDRAM controller shutdown right before resetting the CPU: the code was
> ensuring that all those assembly instructions fitted in one cache line,
> so that even if the SDRAM controller gets shutdown, the rest of the
> code can properly execute until resetting the CPU. Now, the SDRAM
> controller shutdown code and the code resetting the CPU are in
> completely separate places, which break this assumption.
> 

It it still working properly, I believe it is still fitting the cache
line.

> And also, you forgot to Cc: Maxime Ripard who did the initial work on
> this at91-reset controller.
> 

Yeah, I realized after sending the patches.

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
