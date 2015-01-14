Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892AbbANVHi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 16:07:38 -0500
Received: from down.free-electrons.com ([37.187.137.238]:47995 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751225AbbANVHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 16:07:37 -0500
Date: Wed, 14 Jan 2015 22:07:34 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
        Nicolas FERRE <nicolas.ferre@atmel.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] ARM: at91: pm: rework cpu detection
Message-ID: <20150114210734.GO3843@piout.net>
References: <1421097825-396-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1421097825-396-2-git-send-email-alexandre.belloni@free-electrons.com>
 <20150114191412.GA14457@ns203013.ovh.net>
 <20150114212139.0ad297eb@bbrezillon>
 <217DB987-13E3-4D5D-A9BE-D17662A19E26@jcrosoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <217DB987-13E3-4D5D-A9BE-D17662A19E26@jcrosoft.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

(Adding Arnd in Cc)

On 15/01/2015 at 04:37:14 +0800, Jean-Christophe PLAGNIOL-VILLARD wrote :
> >>> -	/* AT91RM9200 SDRAM low-power mode cannot be used with self-refresh. */
> >>> -	if (cpu_is_at91rm9200())
> >>> +	at91_pm_data.memctrl = AT91_MEMCTRL_SDRAMC;
> >>> +
> >>> +	if (of_machine_is_compatible("atmel,at91rm9200")) {
> >>> +		/*
> >>> +		 * AT91RM9200 SDRAM low-power mode cannot be used with
> >>> +		 * self-refresh.
> >>> +		 */
> >>> 		at91_ramc_write(0, AT91RM9200_SDRAMC_LPR, 0);
> >>> -	
> >>> +
> >>> +		at91_pm_data.uhp_udp_mask = AT91RM9200_PMC_UHP |
> >>> +					    AT91RM9200_PMC_UDP;
> >>> +		at91_pm_data.memctrl = AT91_MEMCTRL_MC;
> >>> +	} else if (of_machine_is_compatible("atmel,at91sam9260") ||
> >>> +		   of_machine_is_compatible("atmel,at91sam9g20") ||
> >>> +		   of_machine_is_compatible("atmel,at91sam9261") ||
> >>> +		   of_machine_is_compatible("atmel,at91sam9g10") ||
> >>> +		   of_machine_is_compatible("atmel,at91sam9263")) {
> >> nack here
> >> 
> >> you switch for runtime information from the SOC register store in ram to DT
> >> 
> >> DT is great but I do prefer to rely on the SoC register here as the whole was
> >> also to check that the is correct
> > 
> > Well, cpu_is_xxx macros are defined in a mach specific header, and we're
> > currently trying to enable multi platform support. 
> 
> Yes does not mean we can not move this, use the REAL hardware detected cpu is better
> as you can check that the DT is valid for this SoC and also have fixup for a specific
> SoC version without having to have x DT per SoC
> 
> > 
> >> 
> >> wihich is way slower
> > 
> > Hmm, this SoC detection has been move from the suspend path (where, as
> > you stated, speed is a real concern) to the pm init function (which is
> > only called once at startup), and I doubt the boot time penalty will
> > even be noticeable…
> 
> except if your table is boot as quick as possible avoid useless string compare is always a good choice
> 
> IIRC we had in the past RFC to have the drivers compatible compare switch to HASH
> for this purpose too
> 

Following a discussion with Arnd, the whole SoC detection will be remove
which will be completely faster than mapping the dbgu registers.

Also, the of_machine_is_compatible are supposed to be removed soon,
waiting for the pm code to be reworked. What is done here is to allow us
to go forward with switching to multiplatform and cleaning up the
mach-at91 directory.


I have follow up patches coming up and they already remove some of the
of_machine_is_compatible.

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
