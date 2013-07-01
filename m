Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185Ab3GANE1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 09:04:27 -0400
Received: from www.linutronix.de ([62.245.132.108]:54995 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945Ab3GANE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 09:04:26 -0400
Date: Mon, 1 Jul 2013 15:04:24 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Stehle Vincent-B46079 <B46079@freescale.com>
cc: Stephen Boyd <sboyd@codeaurora.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Subject: RE: next-20130627 breaks i.MX6 sabre sd UART console
In-Reply-To: <F7C43F8B2814514CA05F3436BC68046EF2EF29@039-SN2MPN1-011.039d.mgd.msft.net>
Message-ID: <alpine.DEB.2.02.1307011425500.4013@ionos.tec.linutronix.de>
References: <F7C43F8B2814514CA05F3436BC68046EF1EB72@039-SN2MPN1-013.039d.mgd.msft.net> <alpine.DEB.2.02.1306281403530.4013@ionos.tec.linutronix.de> <51CDB26A.9060500@codeaurora.org> <F7C43F8B2814514CA05F3436BC68046EF2297D@039-SN2MPN1-013.039d.mgd.msft.net>
 <51CDC2B3.1030907@codeaurora.org> <20130629020738.GG11625@codeaurora.org> <F7C43F8B2814514CA05F3436BC68046EF2EF29@039-SN2MPN1-011.039d.mgd.msft.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Jul 2013, Stehle Vincent-B46079 wrote:

So up to this point everything looks ok. mxc timer is the broadcast
and the local timer is preferred over the dummy timer.

But after switching the clocksource:

> Switched to clocksource mxc_timer1
> ------------[ cut here ]------------
> WARNING: CPU: 2 PID: 0 at kernel/time/clockevents.c:212 clockevents_program_event+0x134/0x148()

That's when clockevents_program_event() is called with a negative
expiry time.

And its called from:

[<800613f4>] (clockevents_program_event+0x134/0x148) from [<80061900>]
(tick_handle_periodic+0x64/0x88)

Which calculates the expiry value via:
      
      next = ktime_add(dev->next_event, tick_period);

So something is hosed there.

Can you please apply the patch below and provide the output?

Thanks,

	tglx
---
diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index edd45f6..5617628 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -94,6 +94,13 @@ void tick_handle_periodic(struct clock_event_device *dev)
 	 */
 	next = ktime_add(dev->next_event, tick_period);
 	for (;;) {
+		if (next.tv64 < 0) {
+			pr_err("next %llx nevt %llx per %llx nxtp %llx now %llx\n",
+			       next.tv64, dev->next_event.tv64,
+			       tick_period.tv64, tick_next_period.tv64,
+			       ktime_get().tv64);
+		}
+
 		if (!clockevents_program_event(dev, next, false))
 			return;
 		/*
