Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760814AbaGYQpk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 12:45:40 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:52689 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752683AbaGYQpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 12:45:38 -0400
Date: Fri, 25 Jul 2014 17:45:19 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Vinod Koul <vinod.koul@intel.com>, andriy.shevchenko@intel.com,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        zhuzhenhua@allwinnertech.com, dmaengine@vger.kernel.org,
        linux-sunxi@googlegroups.com, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        Dan Williams <dan.j.williams@intel.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v11 0/2] Add support for the Allwinner A31 DMA
	Controller
Message-ID: <20140725164518.GQ21766@n2100.arm.linux.org.uk>
References: <1405626376-471-1-git-send-email-maxime.ripard@free-electrons.com> <20140725131217.GS8181@intel.com> <20140725163746.GC20328@lukather>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140725163746.GC20328@lukather>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2014 at 06:37:46PM +0200, Maxime Ripard wrote:
> Hi Vinod,
> 
> On Fri, Jul 25, 2014 at 06:42:17PM +0530, Vinod Koul wrote:
> > - don't use devm_request_irq(). You have irq enabled and you have killed
> >   tasklet. This is too racy. You need to ensure no irqs can be generated before killing
> >   tasklets.
> 
> Ok, would calling disable_irq before killing the tasklet an option for
> you ? that would allow to keep the devm_request_irq.

That's not really an acceptable approach if you can use shared interrupts.
A better alternative would be devm_free_irq() to give a definite point
that the interrupt is unregistered in the driver remove sequence.  That
allows you to keep the advantage of devm_request_irq() to clean up during
the initialisation side.

An alternative approach would be to ensure that the hardware is quiesced,
and interrupts are disabled.  Then call synchronize_irq() on it, and at
that point, you should be certain that your interrupt handler should not
process any further interrupts for your device (though, in a shared
interrupt environment, it would still be called should a different device
on the shared line raise its interrupt.)

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
