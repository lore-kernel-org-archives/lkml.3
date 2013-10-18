Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757739Ab3JRXkA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 19:40:00 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:52737 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754406Ab3JRXj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 19:39:58 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/ms4L+s+tytrLVrHMmCSj7
Date: Fri, 18 Oct 2013 16:39:51 -0700
From: Tony Lindgren <tony@atomide.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Randy Dunlap <rdunlap@infradead.org>, Mark Brown <broonie@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "pinctl-single.c" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for Oct 17 (pinctrl-single.c)
Message-ID: <20131018233951.GU15154@atomide.com>
References: <20131018003847.GH2443@sirena.org.uk>
 <5261792C.7030203@infradead.org>
 <CACRpkdaz22N8-9Rg8vR=KGOEL5P6sZm6Hh5PT4Uq381+QmPs7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdaz22N8-9Rg8vR=KGOEL5P6sZm6Hh5PT4Uq381+QmPs7g@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Walleij <linus.walleij@linaro.org> [131018 12:43]:
> On Fri, Oct 18, 2013 at 8:08 PM, Randy Dunlap <rdunlap@infradead.org> wrote:
> > On 10/17/13 17:38, Mark Brown wrote:
> >> Hi all,
> >>
> >> I've uploaded today's linux-next tree to the master branch of the
> >> repository below:
> >>
> >>         git://gitorious.org/thierryreding/linux-next.git
> >>
> >> A next-20131017 tag is also provided for convenience.
> >>
> >> One new conflict today but otherwise uneventful.  x86_64 allmodconfigs
> >> build after each merge but no other build tests were done.
> >
> > on i386:
> >
> > drivers/pinctrl/pinctrl-single.c: In function 'pcs_irqdomain_map':
> > drivers/pinctrl/pinctrl-single.c:1750:2: error: implicit declaration of function 'set_irq_flags' [-Werror=implicit-function-declaration]
> > drivers/pinctrl/pinctrl-single.c:1750:21: error: 'IRQF_VALID' undeclared (first use in this function)
> > drivers/pinctrl/pinctrl-single.c:1750:34: error: 'IRQF_PROBE' undeclared (first use in this function)
> 
> Hmmmm this looks like Tony's baby and the offending patch is
> not in the pinctrl tree, I bet he'll have a fix for it in no time.

Ouch sorry about that. I'll send a pull request for the
following fix ASAP. Build tested with Randy's randconfig.

Regards,

Tony

8< ------------------------
From: Tony Lindgren <tony@atomide.com>
Date: Fri, 18 Oct 2013 16:20:05 -0700
Subject: [PATCH] pinctrl: single: Fix build when not built on ARM

Looks like we need a little bit of arch specific handling
with the generic IRQ. Fix the issue with an ifdef the
same way as other drivers do.

ARM needs things set to IRQF_VALID, which also then sets
noprobe. Others seem to use just irq_set_noprobe().

Otherwise we can get:

drivers/pinctrl/pinctrl-single.c: In function 'pcs_irqdomain_map':
drivers/pinctrl/pinctrl-single.c:1750:2: error: implicit declaration of function 'set_irq_flags' [-Werror=implicit-function-declaration]
drivers/pinctrl/pinctrl-single.c:1750:21: error: 'IRQF_VALID' undeclared (first use in this function)
drivers/pinctrl/pinctrl-single.c:1750:34: error: 'IRQF_PROBE' undeclared (first use in this function)

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Tony Lindgren <tony@atomide.com>

--- a/drivers/pinctrl/pinctrl-single.c
+++ b/drivers/pinctrl/pinctrl-single.c
@@ -1743,7 +1743,12 @@ static int pcs_irqdomain_map(struct irq_domain *d, unsigned int irq,
 	irq_set_chip_data(irq, pcs_soc);
 	irq_set_chip_and_handler(irq, &pcs->chip,
 				 handle_level_irq);
-	set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
+
+#ifdef CONFIG_ARM
+	set_irq_flags(irq, IRQF_VALID);
+#else
+	irq_set_noprobe(irq);
+#endif
 
 	return 0;
 }
