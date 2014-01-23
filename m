Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932299AbaAWWwV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 17:52:21 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:43058 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753977AbaAWWwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 17:52:20 -0500
Date: Thu, 23 Jan 2014 15:52:08 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] irqchip: orion: clear stale interrupts in irq_enable
Message-ID: <20140123225208.GA24778@obsidianresearch.com>
References: <1390516686-2224-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1390516686-2224-4-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390516686-2224-4-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 11:38:06PM +0100, Sebastian Hesselbarth wrote:
> Bridge IRQ_CAUSE bits are asserted regardless of the corresponding bit in
> IRQ_MASK register. To avoid interrupt events on stale irqs, we have to clear
> them before unmask. This installs an .irq_enable callback to ensure stale
> irqs are cleared before initial unmask.

I'm not sure if putting this in irq_enable is correct. I think this
should only happen at irq_startup.

The question boils down to what is supposed to happen with this code
sequence:

disable_irq(..);
write(.. something to cause an interrupt edge ..);
.. synchronize ..
enable_irq(..);

Do we get the interrupt or not?

I found this message from Linus long ago:
 http://yarchive.net/comp/linux/edge_triggered_interrupts.html
> Btw, the "disable_irq()/enable_irq()" subsystem has been written so that
> when you disable an edge-triggered interrupt, and the edge happens while
> the interrupt is disabled, we will re-play the interrupt at enable time.
> Exactly so that drivers can have an easier time and don't have to
> normally worry about whether something is edge or level-triggered.

And found this note in Documentation/DocBook/genericirq.tmpl:

> This prevents losing edge interrupts on hardware which does
> not store an edge interrupt event while the interrupt is disabled at
> the hardware level. 

So I think it is very clear that the chip driver should not discard
edges that happened while the interrupt was disabled.

Regards,
Jason
