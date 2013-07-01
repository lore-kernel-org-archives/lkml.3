Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899Ab3GAWW0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 18:22:26 -0400
Received: from www.linutronix.de ([62.245.132.108]:57492 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754218Ab3GAWWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 18:22:25 -0400
Date: Tue, 2 Jul 2013 00:22:25 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Stephen Boyd <sboyd@codeaurora.org>
cc: Stehle Vincent-B46079 <B46079@freescale.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: next-20130627 breaks i.MX6 sabre sd UART console
In-Reply-To: <51D1FF40.2030805@codeaurora.org>
Message-ID: <alpine.DEB.2.02.1307020016580.4013@ionos.tec.linutronix.de>
References: <F7C43F8B2814514CA05F3436BC68046EF1EB72@039-SN2MPN1-013.039d.mgd.msft.net> <alpine.DEB.2.02.1306281403530.4013@ionos.tec.linutronix.de> <51CDB26A.9060500@codeaurora.org> <F7C43F8B2814514CA05F3436BC68046EF2297D@039-SN2MPN1-013.039d.mgd.msft.net>
 <51CDC2B3.1030907@codeaurora.org> <20130629020738.GG11625@codeaurora.org> <F7C43F8B2814514CA05F3436BC68046EF2EF29@039-SN2MPN1-011.039d.mgd.msft.net> <alpine.DEB.2.02.1307011425500.4013@ionos.tec.linutronix.de> <F7C43F8B2814514CA05F3436BC68046EF2F708@039-SN2MPN1-011.039d.mgd.msft.net>
 <alpine.DEB.2.02.1307011531210.4013@ionos.tec.linutronix.de> <51D1DD6D.8050805@codeaurora.org> <alpine.DEB.2.02.1307012153060.4013@ionos.tec.linutronix.de> <51D1EC8C.4050101@codeaurora.org> <alpine.DEB.2.02.1307012259460.4013@ionos.tec.linutronix.de>
 <51D1FF40.2030805@codeaurora.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Jul 2013, Stephen Boyd wrote:
> On 07/01/13 14:24, Thomas Gleixner wrote:
> > On Mon, 1 Jul 2013, Stephen Boyd wrote:
> >> On 07/01/13 13:14, Thomas Gleixner wrote:
> >>> The issue is very subtle. What happens is:
> >>>
> >>> CPU0						CPU1
> >>>
> >>> Switch to oneshot mode
> >>>
> >>>  Copy the bits from tick_broadcast_mask to
> >>>  tick_broadcast_oneshot_mask. We need to do
> >>>  that so the other cpus reach the timer irq
> >>>  and the softirq which switches them to
> >>>  oneshot.
> >>>
> >>>  Kick the broadcast device into oneshot.
> >>>
> >>> 						Timer interrupt fires
> >>> 						
> >>> 						irq_enter sees the cpu in
> >>> 						tick_broadcast_oneshot_mask and
> >>> 						sets the device to oneshot mode
> >>> 						
> >>> 						handle_periodic:
> >>> 						 Sees oneshot mode and adds
> >>> 						 period to
> >>> 						 dev->next_event(KTIME_MAX)
> >>> 			
> >> Yep. It is also racing with the timer interrupt so having more than two
> >> CPUs must help widen the window (which is why we see it on the higher
> >> numbered CPUs).
> > The race above is about the timer interrupt. You mean the broadcast
> > one which is still enabled due to the dummy -> functional transition
> > issue, right? That helps a lot to make this more visible, because we
> > double the number of events.
> 
> I was thinking that tick_check_oneshot_broadcast() is racing with
> tick_switch_to_oneshot() and because we have more CPUs we're more likely
> to have a CPU fix up the handler in tick_switch_to_oneshot() after
> tick_check_oneshot_broadcast() forces that CPU to oneshot mode and the
> periodic handler runs. I wonder if I can reproduce it locally by making
> tick_switch_to_oneshot() spin for a jiffy or two on CPU1.

tick_switch_to_oneshot() is invoked with interrupts disabled, so that
wont help. 

