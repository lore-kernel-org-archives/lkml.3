Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752387AbaAXKz6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 05:55:58 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:47132 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752064AbaAXKz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 05:55:56 -0500
Date: Fri, 24 Jan 2014 10:55:39 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Jason Cooper <jason@lakedaemon.net>,
        linux-kernel@vger.kernel.org,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/3] irqchip: orion: clear stale interrupts in
	irq_enable
Message-ID: <20140124105539.GD15937@n2100.arm.linux.org.uk>
References: <1390516686-2224-1-git-send-email-sebastian.hesselbarth@gmail.com> <1390516686-2224-4-git-send-email-sebastian.hesselbarth@gmail.com> <20140123225208.GA24778@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140123225208.GA24778@obsidianresearch.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 03:52:08PM -0700, Jason Gunthorpe wrote:
> On Thu, Jan 23, 2014 at 11:38:06PM +0100, Sebastian Hesselbarth wrote:
> > Bridge IRQ_CAUSE bits are asserted regardless of the corresponding bit in
> > IRQ_MASK register. To avoid interrupt events on stale irqs, we have to clear
> > them before unmask. This installs an .irq_enable callback to ensure stale
> > irqs are cleared before initial unmask.
> 
> I'm not sure if putting this in irq_enable is correct. I think this
> should only happen at irq_startup.
> 
> The question boils down to what is supposed to happen with this code
> sequence:
> 
> disable_irq(..);
> write(.. something to cause an interrupt edge ..);
> .. synchronize ..
> enable_irq(..);
> 
> Do we get the interrupt or not?

The answer is... yes, the interrupt should be delivered after the
interrupt is re-enabled.

> I found this message from Linus long ago:
>  http://yarchive.net/comp/linux/edge_triggered_interrupts.html
> > Btw, the "disable_irq()/enable_irq()" subsystem has been written so that
> > when you disable an edge-triggered interrupt, and the edge happens while
> > the interrupt is disabled, we will re-play the interrupt at enable time.
> > Exactly so that drivers can have an easier time and don't have to
> > normally worry about whether something is edge or level-triggered.
> 
> And found this note in Documentation/DocBook/genericirq.tmpl:
> 
> > This prevents losing edge interrupts on hardware which does
> > not store an edge interrupt event while the interrupt is disabled at
> > the hardware level. 
> 
> So I think it is very clear that the chip driver should not discard
> edges that happened while the interrupt was disabled.

Correct.

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
