Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758204AbaDXRT3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 13:19:29 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:24511 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753581AbaDXRT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 13:19:27 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+GsKjGXBQuHzc2YnJFRtsS
Date: Thu, 24 Apr 2014 10:19:19 -0700
From: Tony Lindgren <tony@atomide.com>
To: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <robherring2@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        thierry.reding@gmail.com, Rob Herring <robh@kernel.org>
Subject: Re: [PATCH 2/2] of/irq: do irq resolution in platform_get_irq
Message-ID: <20140424171918.GG22987@atomide.com>
References: <1398293861-7682-1-git-send-email-robherring2@gmail.com>
 <1398293861-7682-3-git-send-email-robherring2@gmail.com>
 <20140423234213.GE6053@atomide.com>
 <20140424161039.CF96CC40921@trevor.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140424161039.CF96CC40921@trevor.secretlab.ca>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Grant Likely <grant.likely@linaro.org> [140424 09:11]:
> On Wed, 23 Apr 2014 16:42:13 -0700, Tony Lindgren <tony@atomide.com> wrote:
> > * Rob Herring <robherring2@gmail.com> [140423 15:58]:
> > > From: Rob Herring <robh@kernel.org>
> > > 
> > > Currently we get the following kind of errors if we try to use interrupt
> > > phandles to irqchips that have not yet initialized:
> > > 
> > > irq: no irq domain found for /ocp/pinmux@48002030 !
> > > ------------[ cut here ]------------
> > > WARNING: CPU: 0 PID: 1 at drivers/of/platform.c:171 of_device_alloc+0x144/0x184()
> > > Modules linked in:
> > > CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.12.0-00038-g42a9708 #1012
> > > (show_stack+0x14/0x1c)
> > > (dump_stack+0x6c/0xa0)
> > > (warn_slowpath_common+0x64/0x84)
> > > (warn_slowpath_null+0x1c/0x24)
> > > (of_device_alloc+0x144/0x184)
> > > (of_platform_device_create_pdata+0x44/0x9c)
> > > (of_platform_bus_create+0xd0/0x170)
> > > (of_platform_bus_create+0x12c/0x170)
> > > (of_platform_populate+0x60/0x98)
> > > 
> > > This is because we're wrongly trying to populate resources that are not
> > > yet available. It's perfectly valid to create irqchips dynamically, so
> > > let's fix up the issue by resolving the interrupt resources when
> > > platform_get_irq is called.
> > > 
> > > And then we also need to accept the fact that some irqdomains do not
> > > exist that early on, and only get initialized later on. So we can
> > > make the current WARN_ON into just into a pr_debug().
> > > 
> > > We still attempt to populate irq resources when we create the devices.
> > > This allows current drivers which don't use platform_get_irq to continue
> > > to function. Once all drivers are fixed, this code can be removed.
> > > 
> > > Suggested-by: Russell King <linux@arm.linux.org.uk>
> > > Signed-off-by: Rob Herring <robh@kernel.org>
> > > Signed-off-by: Tony Lindgren <tony@atomide.com>
> > 
> > Great, works for me. Hopefully this patch is non-intrusive enough for
> > people for the -rc cycle too?
> 
> Both patches look good. I've put them in my tree and will push it out
> shortly. I want to make sure there are no regressions on PowerPC, so
> I'll give it a few days in linux-next before asking Linus to pull.

Great, sounds good to me.
 
> Tony, how far back does this need to be backported?

The issue seems to have been around ever since the start of DT with
platform_bus, and people have been probably working around it with
the initcall levels and using irq_of_parse_and_map instead of
platform_get_irq.

I noticed the issue last year around the time interrupts-extended
binding patches were posted and I was adding the irqdomain support
to pinctrl-single.c for wake-up interrupts.

So the fix should probably go back to at least v3.12 or v3.10 as
those are recent longterm kernels. The patch seems to apply to both
of them with fuzz except for include/linux/of_irq.h.

Sligthly related to this patch, also 4a43d686fe33 (of/irq: Pass
trigger type in IRQ resource flags) should also get tagged stable
too if not done already as that keeps some legacy drivers working.

Regards,

Tony
