Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715AbaKLXJQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 18:09:16 -0500
Received: from gate.crashing.org ([63.228.1.57]:45777 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753675AbaKLXJP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 18:09:15 -0500
Message-ID: <1415833725.5124.53.camel@kernel.crashing.org>
Subject: Re: [PATCH]  of/base: Fix PowerPC address parsing hack
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Rob Herring <robherring2@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Olof Johansson <olof@lixom.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, linuxppc-dev@ozlabs.org
Date: Thu, 13 Nov 2014 10:08:45 +1100
In-Reply-To: <20141113091036.4e9ec43d@canb.auug.org.au>
References: <1415771461.5124.33.camel@kernel.crashing.org>
	 <20141113091036.4e9ec43d@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-11-13 at 09:10 +1100, Stephen Rothwell wrote:
> Hi Ben,
> 
> Urk!  :-)
> 
> How about:
> 
> On Wed, 12 Nov 2014 16:51:01 +1100 Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> >
> > diff --git a/drivers/of/address.c b/drivers/of/address.c
> > index e371825..e37f017 100644
> > --- a/drivers/of/address.c
> > +++ b/drivers/of/address.c
> > @@ -7,6 +7,10 @@
> >  #include <linux/pci_regs.h>
> >  #include <linux/string.h>
> >  
> > +#ifdef CONFIG_PPC
> > +#include <asm/machdep.h>
> 
> #define IS_PMAC	machine_is(pmac)
> #else
> #define IS_PMAC	(0)

I'll just do an of machine compatible check instead, so there's no ifdef
at all, I'll send a new patch later today.

> > +#endif
> > +
> >  /* Max address size we deal with */
> >  #define OF_MAX_ADDR_CELLS	4
> >  #define OF_CHECK_ADDR_COUNT(na)	((na) > 0 && (na) <= OF_MAX_ADDR_CELLS)
> > @@ -428,12 +432,13 @@ static int of_translate_one(struct device_node *parent, struct of_bus *bus,
> >  	 * This code is only enabled on powerpc. --gcl
> >  	 */
> >  	ranges = of_get_property(parent, rprop, &rlen);
> > -#if !defined(CONFIG_PPC)
> > +#if defined(CONFIG_PPC)
> > +	if (!machine_is(powermac))
> > +#endif /* defined(CONFIG_PPC) */
> >  	if (ranges == NULL) {
> 
> if ((!IS_PMAC) && (ranges == NULL)) {
> 
> > -		pr_err("OF: no ranges; cannot translate\n");
> > +		pr_debug("OF: no ranges; cannot translate\n");
> >  		return 1;
> >  	}
> > -#endif /* !defined(CONFIG_PPC) */
> >  	if (ranges == NULL || rlen == 0) {
> >  		offset = of_read_number(addr, na);
> >  		memset(addr, 0, pna * 4);
> 
> There might be a better identifier than IS_PMAC ...
> 


