Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569AbaBJOMy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 09:12:54 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:58404 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752528AbaBJOMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 09:12:49 -0500
Date: Mon, 10 Feb 2014 14:12:07 +0000
From: Will Deacon <will.deacon@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Fabrice Gasnier <fabrice.gasnier@st.com>,
        "u.kleine-koenig@pengutronix.de" <u.kleine-koenig@pengutronix.de>,
        Jonathan Austin <Jonathan.Austin@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "nico@linaro.org" <nico@linaro.org>,
        "sboyd@codeaurora.org" <sboyd@codeaurora.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "ben.dooks@codethink.co.uk" <ben.dooks@codethink.co.uk>,
        "vgupta@synopsys.com" <vgupta@synopsys.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "maxime.coquelin@st.com" <maxime.coquelin@st.com>
Subject: Re: [RFC PATCH] ARM: Add imprecise abort enable/disable macro
Message-ID: <20140210141207.GH17766@mudshark.cambridge.arm.com>
References: <1391789955-26927-1-git-send-email-fabrice.gasnier@st.com>
 <1391789955-26927-2-git-send-email-fabrice.gasnier@st.com>
 <20140207170903.GT5976@mudshark.cambridge.arm.com>
 <52F892C8.80508@st.com>
 <20140210111710.GC17766@mudshark.cambridge.arm.com>
 <20140210135659.GU26684@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140210135659.GU26684@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 01:56:59PM +0000, Russell King - ARM Linux wrote:
> On Mon, Feb 10, 2014 at 11:17:10AM +0000, Will Deacon wrote:
> > On Mon, Feb 10, 2014 at 08:50:16AM +0000, Fabrice Gasnier wrote:
> > > On 02/07/2014 06:09 PM, Will Deacon wrote:
> > > > On Fri, Feb 07, 2014 at 04:19:15PM +0000, Fabrice GASNIER wrote:
> > > >> diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
> > > >> index 4636d56..ef15709 100644
> > > >> --- a/arch/arm/kernel/traps.c
> > > >> +++ b/arch/arm/kernel/traps.c
> > > >> @@ -900,6 +900,10 @@ void __init early_trap_init(void *vectors_base)
> > > >>   
> > > >>   	flush_icache_range(vectors, vectors + PAGE_SIZE * 2);
> > > >>   	modify_domain(DOMAIN_USER, DOMAIN_CLIENT);
> > > >> +
> > > >> +	/* Enable imprecise aborts */
> > > >> +	local_abt_enable();
> > > > Surely we want to enable this as early as possible? Now, putting this into
> > > > head.S is ugly, as it duplicating it across all the proc*.S files, so why
> > > > not setup_arch?
> > > Sorry, I'm not sure to understand your last comment.
> > > At least, I need it enabled before probing drivers (PCIe bus)
> > > I've added imprecise abort enable code in traps.c, following Russel 
> > > King's advice, please see:
> > > http://archive.arm.linux.org.uk/lurker/message/20140131.170827.d752a1cc.en.html
> > > As abort bit is local to a cpu, i've also added it in smp.c, but this 
> > > may not be the right place ?
> > > 
> > > Please elaborate,
> > 
> > I was just suggesting that we move your local_abt_enable() call to
> > setup_arch, since that's called before early_trap_init on the primary CPU.
> 
> Why would we want to enable aborts before we've setup the vectors page
> to handle an abort?  That's akin to enabling interrupts and hoping there
> isn't one pending...

I figured we'd want to fall over as quickly as possible if the bootloader
had left a pending exception for us, but you're right in that it's not very
helpful if we can't print out a diagnostic.

Fabrice, please ignore my suggestion and keep the unmasking where it is.

Will
