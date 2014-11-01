Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759920AbaKAAVp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 20:21:45 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:54392 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753399AbaKAAVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 20:21:44 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>, Pavel Machek <pavel@ucw.cz>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kevin Hilman <khilman@kernel.org>
Subject: Re: [PATCH v8 1/5] PM / Runtime: Add getter for querying the IRQ safe option
Date: Sat, 01 Nov 2014 01:42:24 +0100
Message-ID: <1615499.6LK9Yd7Lr0@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141031230452.GX27405@n2100.arm.linux.org.uk>
References: <1413795888-18559-1-git-send-email-k.kozlowski@samsung.com> <32933431.rIxraemF7M@vostro.rjw.lan> <20141031230452.GX27405@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, October 31, 2014 11:04:52 PM Russell King - ARM Linux wrote:
> On Sat, Nov 01, 2014 at 12:11:05AM +0100, Rafael J. Wysocki wrote:
> > [CC list trimmed + added Kevin Hilman]
> > 
> > On Monday, October 20, 2014 11:04:44 AM Krzysztof Kozlowski wrote:
> > > Add a simple getter pm_runtime_is_irq_safe() for querying whether runtime
> > > PM IRQ safe was set or not.
> > > 
> > > Various bus drivers implementing runtime PM may use choose to suspend
> > > differently based on IRQ safeness status of child driver (e.g. do not
> > > unprepare the clock if IRQ safe is not set).
> > > 
> > > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > > Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
> > 
> > So why do we need to add the wrapper?
> > 
> > And it goes kind of against the intention which was to set irq_safe when
> > we knew that the callbacks were safe to be executed from interrupt context
> > and not when we wished that to be the case.
> 
> This was provided in the covering email - I quote:
> 
> This patchset adds runtime and system PM to the pl330 driver.
> 
> The runtime PM of pl330 driver requires interrupt safe suspend/resume
> callbacks which is in conflict with current amba bus driver.
> The latter also unprepares and prepares the AMBA bus clock which
> is not safe for atomic context.
> 
> The patchset solves this in patch 3/5 by handling clocks in different
> way if device driver set interrupt safe runtime PM.

So I'm still unsure why we need the wrapper.  IMHO this check in particular:

	WARN_ON(pcdev->irq_safe != pm_runtime_is_irq_safe(dev));

(and should that be WARN_ON_ONCE(), for that matter?), looks better this way:

	WARN_ON(pcdev->irq_safe != dev->power.irq_safe);

and so on, pretty much.

Besides, these special "irq safe" code paths in the bus type look
considerably ugly to me.  I'd probably use an "irq safe" PM domain for
that device and put it in there instead of doing the

	pcdev->irq_safe = pm_runtime_is_irq_safe(dev);

thing in amba_probe().  But that's just me. :-)

There's one weak point in [3/5], but let me comment it in there.

Rafael

