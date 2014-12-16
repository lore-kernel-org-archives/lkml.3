Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751489AbaLPM4s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 07:56:48 -0500
Received: from www.linutronix.de ([62.245.132.108]:49898 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434AbaLPM4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 07:56:46 -0500
Date: Tue, 16 Dec 2014 13:56:26 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        Mike Turquette <mturquette@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] ARM: at91: fix irq_pm_install_action WARNING
In-Reply-To: <20141216122503.77c5632f@bbrezillon>
Message-ID: <alpine.DEB.2.11.1412161349420.17382@nanos>
References: <1418660152-17185-1-git-send-email-boris.brezillon@free-electrons.com> <2662748.NJbkr6jW7r@vostro.rjw.lan> <3542278.8lcJeXLMFm@vostro.rjw.lan> <20141216100715.57baeb65@bbrezillon> <alpine.DEB.2.11.1412161013570.17382@nanos>
 <20141216122503.77c5632f@bbrezillon>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Dec 2014, Boris Brezillon wrote:
> Thomas Gleixner <tglx@linutronix.de> wrote:
> > Install the timer interrupt as a demultiplexing interrupt.
> 
> I can try to hack the AIC irqchip driver to implement this demux logic,
> but this logic can't be placed in the PIT (Periodic Interval Timer)
> driver itself, because the shared IRQ line is used by the at91 clock
> controller (PMC) which is providing the clock to the PIT device.
> This gives the following dependency graph:
> 
> PIT =depends-on=> Master Clock =provided-by=> PMC =needs=> PMC IRQ.

It never can be a part of a device driver. This is a property of the
interrupt controller which fails to provide a proper demux for this
irq line in the first place.

So you fake the demux in the irq chip driver, where you provide the
pseudo chip and the demux logic. None of the device drivers (PIT, PMC,
UART ...) even knows about that.

|--------|             |--------|
| AIC    |-------------| Pseudo |---- PIT
|        |             | chip   |---- PMC
|        |             |        |---- UART
|        |             |--------|
|        |--- devX
|        |--- devY
|        |--- devZ
|--------|

So PIT, PMC and UART get interrupt numbers handed out which are
outside of the interrupt space of AIC.

Thanks,

	tglx
