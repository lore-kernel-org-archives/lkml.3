Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631AbaCEMe4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 07:34:56 -0500
Received: from srv-hp10.netsons.net ([94.141.22.71]:35472 "EHLO
	srv-hp10.netsons.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753866AbaCEMew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 07:34:52 -0500
X-Greylist: delayed 2527 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Mar 2014 07:34:52 EST
MIME-Version: 1.0
In-Reply-To: <20140305004139.GT21483@n2100.arm.linux.org.uk>
References: <20140304030838.GA1872@titan.lakedaemon.net>
	<1393911160-7688-1-git-send-email-jason@lakedaemon.net>
	<20140305004139.GT21483@n2100.arm.linux.org.uk>
Date: Wed, 5 Mar 2014 12:52:07 +0100
Message-ID: <CAOQ7t2bWx+ogSDiqQBabxD2BsbePnFfUSpAVVWFThix=m4dhrQ@mail.gmail.com>
Subject: Re: [PATCH] Revert "irqchip: irq-dove: Add PMU interrupt controller."
From: Carlo Caione <carlo@caione.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jason Cooper <jason@lakedaemon.net>, Thomas Gleixner <tglx@linutronix.de>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Hans De Goede <hdegoede@redhat.com>, linux-sunxi@googlegroups.com
Content-Type: text/plain; charset=ISO-8859-1
X-OutGoing-Spam-Status: No, score=0.1
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - srv-hp10.netsons.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - caione.org
X-Get-Message-Sender-Via: srv-hp10.netsons.net: authenticated_id: carlo@caione.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 5, 2014 at 1:41 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Tue, Mar 04, 2014 at 05:32:40AM +0000, Jason Cooper wrote:
>
> Jason, Thomas,
>
> I've just been giving the above a whirl here with the RTC, and it
> doesn't seem to quite work as it should.  Not your problem, because it's
> as the code is originally.
>
> Let's say you set an alarm for 10sec time.  When the alarm fires:
>
> - we read the PMU interrupt status, mask it with the mask register,
>   and find the RTC pending.
> - we call the genirq layer for this interrupt.
> - genirq does the mask + ack thing.
> - the RTC interrupt handler is called, and there's the RTC says there's
>   an interrupt pending.
> - the RTC handler clears the interrupt, and returns.
> - genirq unmasks the interrupt, and returns.
> - dove_pmu_irq_handler() is re-entered, and again, we find that the
>   RTC interrupt is pending.
> - follow the above...
> - the RTC interrupt handler is called, but this time there's no interrupt
>   pending, so returns IRQ_NONE
> - genirq unmasks the interrupt, and returns.
>
> The reason this happens is that the attempt to "ack" - rather "clear" the
> interrupt the first time around has no effect - the RTC is still asserting
> the interrupt, so the write to clear the register results in the bit
> remaining set.
>
> The second time around, we've already cleared the RTC interrupt, so this
> time, the ack clears the interrupt down properly.
>
> In some ways, this is good news - it shows that the bits in this register
> latch '1' when an interrupt is pending, and remain '1' while the block
> continues to assert its interrupt signal - but can we say that the other
> interrupt functions in this register have that behaviour?

I don't know if this could help but I have a very similar problem with
the NMI controller found on sun6i/sun7i for which is pending the
patchset http://comments.gmane.org/gmane.comp.hardware.netbook.arm.sunxi/7554

Also in that case the first ACK has no effect and in the end I use the
unmask hook in the irqchip driver to ACK again the line before
unmasking it (the whole discussion about this problem among me, Maxime
and Hans is in this thread
http://www.spinics.net/lists/arm-kernel/msg299952.html )

I also proposed a small (and as it turned out incomplete) patch here
http://www.spinics.net/lists/arm-kernel/msg305616.html but in the end
I preferred to use the unmask hook.

-- 
Carlo Caione
