Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756858Ab3GRIKM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 04:10:12 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:18915 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751972Ab3GRIJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 04:09:59 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19t742o6zOP+6Iy1kV5aQMF
Date: Thu, 18 Jul 2013 01:09:53 -0700
From: Tony Lindgren <tony@atomide.com>
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Kevin Hilman <khilman@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Benoit Cousson <benoit.cousson@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCH 3/3] ARM: dts: omap4-sdp: add dynamic pin states for
 uart3/4
Message-ID: <20130718080953.GR7656@atomide.com>
References: <1374061312-25469-1-git-send-email-grygorii.strashko@ti.com>
 <1374061312-25469-4-git-send-email-grygorii.strashko@ti.com>
 <20130717153248.GI7656@atomide.com>
 <51E6C939.40208@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E6C939.40208@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Grygorii Strashko <grygorii.strashko@ti.com> [130717 09:48]:
> Hi,
> 
> On 07/17/2013 06:32 PM, Tony Lindgren wrote:
> >* Grygorii Strashko <grygorii.strashko@ti.com> [130717 04:49]:
> >>Add dynamic "active"/"idle" pin states for uart3/4 which will be applied
> >>when uart3/4 state is switched from active to idle and back by Runtime
> >>PM or during system suspend.
> >
> >This is good for testing code, but should not be merged because
> >omap4 has the iopad wake-ups available for uarts. So those can
> >be always enabled.
> 
> In this case, 2 IRQ will be received per each UART RX event - one from
> PRCM and from UART - and that's not good from PM perspective (It will
> affect on CPUIdle and CPUFreq at least).

Oh I see, that's because I accidentally left the debug code enabled
to make it easier to test the wake-up events without having to
have working off-idle. The wake flags can be kept on always for
sure.

The patch below should sort out the issue of getting wake-up interrupts
during runtime as long as you don't have DEBUG defined.

Regards,

Tony

--- a/drivers/pinctrl/pinctrl-single-omap.c
+++ b/drivers/pinctrl/pinctrl-single-omap.c
@@ -140,9 +140,17 @@ static irqreturn_t pcs_omap_handle_irq(int irq, void *data)
 		if ((val & OMAP_WAKEUP_EVENT_MASK) == OMAP_WAKEUP_EVENT_MASK)
 			generic_handle_irq(wakeirq);
 	}
-
+#ifdef DEBUG
+	/*
+	 * This enables wake-up interrupts during runtime also
+	 * causing duplicate interrupts. But it also makes debugging
+	 * the wake-up events easy as deeper idle states often are
+	 * not working for new devices while the drivers are being
+	 * developed.
+	 */
 	if (pcso->reconfigure_io_chain)
 		pcso->reconfigure_io_chain();
+#endif
 
 	return IRQ_HANDLED;
 }
