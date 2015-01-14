Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398AbbANWNH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 17:13:07 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:51080 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754302AbbANWND convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 17:13:03 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Nicolas FERRE <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] ARM: at91: pm: rework cpu detection
Date: Wed, 14 Jan 2015 23:12:48 +0100
Message-ID: <3173260.kaXht7OIt1@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20150114210734.GO3843@piout.net>
References: <1421097825-396-1-git-send-email-alexandre.belloni@free-electrons.com> <217DB987-13E3-4D5D-A9BE-D17662A19E26@jcrosoft.com> <20150114210734.GO3843@piout.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
X-Provags-ID: V03:K0:JbhkZaqb9jWnDspBtlyxc0vzRBxzplpeJTJ19XVd66ZyQyZbnZh
 9VB/Br35st0Dk0EUH/jqUamjU58Jg6hz3gOq4XXgSFWd+RMH6Bgr0lduVL53RMpEXPeuuBl
 Yd39vvPshCwGRWcCRbF0/daJ+DKIh6ytxfqKCTWT21JnIHc5QXl11k+Q9GbuYpU/qxn3fbV
 0PK6lpHy46PfAi6tPt5aA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 January 2015 22:07:34 Alexandre Belloni wrote:
> Hi,
> 
> (Adding Arnd in Cc)
> 
> On 15/01/2015 at 04:37:14 +0800, Jean-Christophe PLAGNIOL-VILLARD wrote :
> > >>> -	/* AT91RM9200 SDRAM low-power mode cannot be used with self-refresh. */
> > >>> -	if (cpu_is_at91rm9200())
> > >>> +	at91_pm_data.memctrl = AT91_MEMCTRL_SDRAMC;
> > >>> +
> > >>> +	if (of_machine_is_compatible("atmel,at91rm9200")) {
> > >>> +		/*
> > >>> +		 * AT91RM9200 SDRAM low-power mode cannot be used with
> > >>> +		 * self-refresh.
> > >>> +		 */
> > >>> 		at91_ramc_write(0, AT91RM9200_SDRAMC_LPR, 0);
> > >>> -	
> > >>> +
> > >>> +		at91_pm_data.uhp_udp_mask = AT91RM9200_PMC_UHP |
> > >>> +					    AT91RM9200_PMC_UDP;
> > >>> +		at91_pm_data.memctrl = AT91_MEMCTRL_MC;
> > >>> +	} else if (of_machine_is_compatible("atmel,at91sam9260") ||
> > >>> +		   of_machine_is_compatible("atmel,at91sam9g20") ||
> > >>> +		   of_machine_is_compatible("atmel,at91sam9261") ||
> > >>> +		   of_machine_is_compatible("atmel,at91sam9g10") ||
> > >>> +		   of_machine_is_compatible("atmel,at91sam9263")) {
> > >> nack here
> > >> 
> > >> you switch for runtime information from the SOC register store in ram to DT
> > >> 
> > >> DT is great but I do prefer to rely on the SoC register here as the whole was
> > >> also to check that the is correct
> > > 
> > > Well, cpu_is_xxx macros are defined in a mach specific header, and we're
> > > currently trying to enable multi platform support. 
> > 
> > Yes does not mean we can not move this, use the REAL hardware detected cpu is better
> > as you can check that the DT is valid for this SoC and also have fixup for a specific
> > SoC version without having to have x DT per SoC

We should definitely be able to confine the SoC detection to at91sam9 though,
because in the three other cases (rm9200, sama5d3, sama5d4), we already have
separate machine descriptors and don't need to do any detection.

> > >> wihich is way slower
> > > 
> > > Hmm, this SoC detection has been move from the suspend path (where, as
> > > you stated, speed is a real concern) to the pm init function (which is
> > > only called once at startup), and I doubt the boot time penalty will
> > > even be noticeable…
> > 
> > except if your table is boot as quick as possible avoid useless string compare is always a good choice
> > 
> > IIRC we had in the past RFC to have the drivers compatible compare switch to HASH
> > for this purpose too
> > 
> 
> Following a discussion with Arnd, the whole SoC detection will be remove
> which will be completely faster than mapping the dbgu registers.
> 
> Also, the of_machine_is_compatible are supposed to be removed soon,
> waiting for the pm code to be reworked. What is done here is to allow us
> to go forward with switching to multiplatform and cleaning up the
> mach-at91 directory.
> 
> I have follow up patches coming up and they already remove some of the
> of_machine_is_compatible.

As you have already confined the of_machine_is_compatible() checks
to one top-level function, and we have found that this function
should not be an unconditional arch_initcall, I think the easiest
way forward is to split at91_pm_init into multiple functions,
one per case you need to handle, and then use a machine_descriptor
with a list of compatible strings to match it.

I think that just means we need an extra machine descriptor to
handle the at91sam9g45, but that will get folded again over time.

	Arnd
