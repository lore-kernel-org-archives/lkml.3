Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757420Ab3EHQvL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 12:51:11 -0400
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:53292 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755356Ab3EHQvJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 12:51:09 -0400
From: Stephen GALLIMORE <stephen.gallimore@st.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>,
        Stuart MENEFY <stuart.menefy@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Wed, 8 May 2013 18:50:40 +0200
Subject: RE: [RFC 5/8] ARM:stih41x: Add STiH415 SOC support
Thread-Topic: [RFC 5/8] ARM:stih41x: Add STiH415 SOC support
Thread-Index: Ac5MB7Pqfcc4F7ohTemoiEIMS9/bXQAATyMw
Message-ID: <A3BF01DB4A606149A4C20C4C4C808F6C3189E576E2@SAFEX1MAIL1.st.com>
References: <1368022187-1633-1-git-send-email-srinivas.kandagatla@st.com>
 <1368022297-2334-1-git-send-email-srinivas.kandagatla@st.com>
 <201305081818.01927.arnd@arndb.de>
In-Reply-To: <201305081818.01927.arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

Thank you for the feedback so far.

> +/*
> + * A basic implementation of irq_set_wake that ensures wakeup source
> + * interrupts are not disabled during PM_SUSPEND_FREEZE.
> + */
> +static int stih41x_set_wake(struct irq_data *d, unsigned int on) {
> +	struct irq_desc *desc = irq_to_desc(d->irq);
> +
> +	if (on) {
> +		if (desc->action)
> +			desc->action->flags |= IRQF_NO_SUSPEND;
> +	} else {
> +		if (desc->action)
> +			desc->action->flags &= ~IRQF_NO_SUSPEND;
> +	}
> +	return 0;
> +}
> +
> +static void __init stih41x_irq_init(void) {
> +	gic_arch_extn.irq_set_wake = stih41x_set_wake;
> +	gic_arch_extn.flags = IRQCHIP_MASK_ON_SUSPEND;
> +
> +	irqchip_init();
> +}
>
>This looks like it should be generic. Why do you need this?

On this point, I wrote it so I am happy to take some advice. Basically this was to allow us to wakeup from the new PM_SUSPEND_FREEZE state that was added at the beginning of the year, without having to pollute individual drivers (particularly the serial driver) with having to somehow change the IRQ flags, or uninstall/re-install the interrupt handler on suspend/resume when marked as a wakeup source with different flags. Those approaches all seemed too messy and not really the driver's responsibility and installing the interrupt handlers of all possible wakeup sources with IRQF_NO_SUSPEND regardless of if they are currently activated as a wakeup source or not also seemed wrong. The code I ended up with was inspired by the existing mach-mmp (mmp2) PM support which does the same thing, so it is not without precedent.

If you have a better solution, or a way to generalize this that would make sense for the ARM architecture as a whole, then we are more than happy to change.

Regards,
-stephen
