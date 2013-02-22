Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486Ab3BVH0n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 02:26:43 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:36066 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781Ab3BVH0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 02:26:39 -0500
Date: Thu, 21 Feb 2013 23:26:35 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Linus Torvalds'" <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        "'Andrew Morton'" <akpm@linux-foundation.org>
Subject: Re: Dangerous devm_request_irq() conversions
Message-ID: <20130222072635.GB30816@core.coreip.homeip.net>
References: <20130222065345.GA30816@core.coreip.homeip.net>
 <000c01ce10cb$fdd4a4a0$f97dede0$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000c01ce10cb$fdd4a4a0$f97dede0$%han@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2013 at 04:12:36PM +0900, Jingoo Han wrote:
> On Friday, February 22, 2013 3:54 PM, Dmitry Torokhov wrote:
> > 
> > Hi,
> > 
> > It looks like a whole slew of devm_request_irq() conversions just got
> > applied to mainline and many of them are quite broken.
> > 
> > Consider fd5231ce336e038037b4f0190a6838bdd6e17c6d or
> > c1879fe80c61f3be6f2ddb82509c2e7f92a484fe: the drivers udsed first to
> > free IRQ and then unregister the corresponding device ensuring that IRQ
> > handler, while it runs, has the device available. The mechanic
> > conversion to devm_request_irq() reverses the order of these operations
> > opening the race window where IRQ can reference device (or other
> > resource) that is already gone.
> > 
> > It would be nice if these could be reverted and revioewed again for
> > correctness.
> 
> Um, other RTC drivers already have been using devm_request_threaded_irq() or
> devm_request_irq() like this, before I added these patches.
> 
> For example, 
> ./drivers/rtc/rtc-tegra.c
> ./drivers/rtc/rtc-spear.c
> ./drivers/rtc/rtc-s3c.c
> ./drivers/rtc/rtc-mxc.c
> ./drivers/rtc/rtc-ds1553.c
> ./drivers/rtc/rtc-ds1511.c
> ./drivers/rtc/rtc-snvs.c
> ./drivers/rtc/rtc-imxdi.c
> ./drivers/rtc/rtc-tx4939.c
> ./drivers/rtc/rtc-mv.c
> ./drivers/rtc/rtc-coh901331.c
> ./drivers/rtc/rtc-stk17ta8.c
> ./drivers/rtc/rtc-lpc32xx.c
> ./drivers/rtc/rtc-tps65910.c
> ./drivers/rtc/rtc-rc5t583.c
> 
> 
> Also, even more, some RTC drivers calls rtc_device_unregister() first,
> then calls free_irq() later.
> 
> For example,
> ./drivers/rtc/rtc-vr41xx.c
> ./drivers/rtc/rtc-da9052.c
> ./drivers/rtc/rtc-isl1208.c
> ./drivers/rtc/rtc-88pm860x.c
> ./drivers/rtc/rtc-tps6586x.c
> ./drivers/rtc/rtc-mpc5121.c
> ./drivers/rtc/rtc-m48t59.c
> 
> 
> Please, don't argue revert without concrete reasons.

What more concrete reason do you need? I explained to you the exact
reason on the patches I noticed before and also on the 2 commits
referenced above: blind conversion to devm_* changes order of operation
which may be deadly with IRQs (but others, like clocks and regulators,
are important too).

The fact that crap slipped in the kernel before is not the valid reason
for adding more of the same crap.

Please *understand* APIs you are using before making changes.

> 
> If these devm_request_threaded_irq() or devm_request_irq() make the problem,
> devm_free_irq() will be added later.

And the point? If you use devm_request_irq() and then call
devm_free_irq() manually in all paths what you achieved is waste of
memory required for devm_* tracking.

-- 
Dmitry
