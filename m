Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586AbaIBO1A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 10:27:00 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:38252 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbaIBO06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 10:26:58 -0400
Date: Tue, 2 Sep 2014 15:26:52 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] mfd: arizona: Add additional dummy IRQ callbacks
Message-ID: <20140902142652.GE870@lee--X1>
References: <1407851483-19207-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <20140821115631.GA4266@lee--X1>
 <20140902140925.GK12043@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140902140925.GK12043@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 02 Sep 2014, Charles Keepax wrote:

> On Thu, Aug 21, 2014 at 12:56:31PM +0100, Lee Jones wrote:
> > On Tue, 12 Aug 2014, Charles Keepax wrote:
> > 
> > > We use a dummy IRQ chip to dispatch interrupts to the two seperate IRQ
> > > domains on the Arizona devices. Currently only the enable and disable
> > > callbacks are defined however, there are some situations where additional
> > > callbacks will be used from the IRQ core, which currently results in an
> > > NULL pointer deference. Add handlers for more of the IRQ callbacks and
> > > combine these into a single function since they are all identical.
> > > 
> > > Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> > > ---
> > 
> > If you provide .irq_enable(), then .irq_unmask becomes redundant
> > and/or is checked for before invoking.  There is a chance of
> > .irq_mask() being called, but if this is a problem, it should be fixed
> > in the IRQ Chip code.  There is also one unprotected invocation of
> > .irq_ack(), but I think this should be fixed rather than forcing each
> > user of IRQ Chip to provide all of these call-backs.
> 
> So I have been looking at this further and going back over things
> from when the issue was discovered and it looks like it was
> probably the unprotected irq_ack call (in handle_edge_irq) that
> was the problem. But thinking about this more I am fairly
> convinced that the call is unprotected because it is expected that
> an edge IRQ will always have an ack, as it doesn't really make
> sense for an edge IRQ to not have an ack.
> 
> The IRQ chip here is just a software device to distribute the IRQ
> to the two sub-domains. As such I think the problem lies here:
> 
> 	irq_set_chip_and_handler(virq, &arizona_irq_chip, handle_edge_irq);
> 
> I am pretty sure the correct fix is to change this to a
> handle_simple_irq as it is just a software dummy and there is
> nothing really edge triggered about it. Do you see any problems
> with that as a solution?

I don't pretend to be an expert on the IRQ framework, but this
certainly looks a lot less hacky than your previous submission.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
