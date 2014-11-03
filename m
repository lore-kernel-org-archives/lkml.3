Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751376AbaKCIvQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 03:51:16 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:48978 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbaKCIvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 03:51:14 -0500
X-AuditID: cbfec7f4-b7f6c6d00000120b-f0-54574200ffc1
Message-id: <1415004670.4241.11.camel@AMDC1943>
Subject: Re: [PATCH v8 1/5] PM / Runtime: Add getter for querying the IRQ safe
 option
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Pavel Machek <pavel@ucw.cz>, Ulf Hansson <ulf.hansson@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kevin Hilman <khilman@kernel.org>
Date: Mon, 03 Nov 2014 09:51:10 +0100
In-reply-to: <1615499.6LK9Yd7Lr0@vostro.rjw.lan>
References: <1413795888-18559-1-git-send-email-k.kozlowski@samsung.com>
 <32933431.rIxraemF7M@vostro.rjw.lan>
 <20141031230452.GX27405@n2100.arm.linux.org.uk>
 <1615499.6LK9Yd7Lr0@vostro.rjw.lan>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJLMWRmVeSWpSXmKPExsVy+t/xq7oMTuEhBm1fmSyebn7MZHF51xw2
	i8+9Rxgtbl/mtbh76iibxZnTl1gtJvy+wGZxfG24A4dHS3MPm8emVZ1sHneu7WHz2HK1ncVj
	9t0fjB4rVn9n9/i8SS6APYrLJiU1J7MstUjfLoEr4+1W24LpIhWzdk5gbmC8xN/FyMEhIWAi
	sfWGThcjJ5ApJnHh3nq2LkYuDiGBpYwSl29tYgNJCAl8ZpS41MYIYvMK6Eu8u7GABcQWFgiX
	uL9sCyuIzSZgLLF5+RKwehEBbYm5PaeYQQYxCzQySfw7u4EJJMEioCrx7e9jsGZOAQOJZ6s+
	MkNsO8Yo0Xp3PztIgllAXWLSvEXMENcpSzT2u0EsFpT4MfkeC0SJvMTmNW+ZJzAKzELSMQtJ
	2SwkZQsYmVcxiqaWJhcUJ6XnGuoVJ+YWl+al6yXn525ihAT/lx2Mi49ZHWIU4GBU4uGdcDks
	RIg1say4MvcQowQHs5IIb49OeIgQb0piZVVqUX58UWlOavEhRiYOTqkGxhox3n2GSfLPZjem
	8dzo+Zn0kynxhbJTsPKVL07zjy0peh0rF3L02D57Jlf/SiedmDSOtPUGZ6bN/bBQhUFw7UEl
	h06T7BlxKn9bCnv5LgU1xe07V/37fcHF6Dn21mcCXBjV89c21cXsa9t6+t7aiXr1M1UqUiLW
	mlvsO14Ypuytbzaf50KEEktxRqKhFnNRcSIABAtAb1wCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On sob, 2014-11-01 at 01:42 +0100, Rafael J. Wysocki wrote:
> On Friday, October 31, 2014 11:04:52 PM Russell King - ARM Linux wrote:
> > On Sat, Nov 01, 2014 at 12:11:05AM +0100, Rafael J. Wysocki wrote:
> > > [CC list trimmed + added Kevin Hilman]
> > > 
> > > On Monday, October 20, 2014 11:04:44 AM Krzysztof Kozlowski wrote:
> > > > Add a simple getter pm_runtime_is_irq_safe() for querying whether runtime
> > > > PM IRQ safe was set or not.
> > > > 
> > > > Various bus drivers implementing runtime PM may use choose to suspend
> > > > differently based on IRQ safeness status of child driver (e.g. do not
> > > > unprepare the clock if IRQ safe is not set).
> > > > 
> > > > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > > > Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
> > > 
> > > So why do we need to add the wrapper?
> > > 
> > > And it goes kind of against the intention which was to set irq_safe when
> > > we knew that the callbacks were safe to be executed from interrupt context
> > > and not when we wished that to be the case.
> > 
> > This was provided in the covering email - I quote:
> > 
> > This patchset adds runtime and system PM to the pl330 driver.
> > 
> > The runtime PM of pl330 driver requires interrupt safe suspend/resume
> > callbacks which is in conflict with current amba bus driver.
> > The latter also unprepares and prepares the AMBA bus clock which
> > is not safe for atomic context.
> > 
> > The patchset solves this in patch 3/5 by handling clocks in different
> > way if device driver set interrupt safe runtime PM.
> 
> So I'm still unsure why we need the wrapper.  IMHO this check in particular:
> 
> 	WARN_ON(pcdev->irq_safe != pm_runtime_is_irq_safe(dev));
> 
> (and should that be WARN_ON_ONCE(), for that matter?), looks better this way:
> 
> 	WARN_ON(pcdev->irq_safe != dev->power.irq_safe);
> 
> and so on, pretty much.

I used the wrapper only to hide the actual code behind interface but it
don't really matter to me.

> Besides, these special "irq safe" code paths in the bus type look
> considerably ugly to me.  I'd probably use an "irq safe" PM domain for
> that device and put it in there instead of doing the
> 
> 	pcdev->irq_safe = pm_runtime_is_irq_safe(dev);
> 
> thing in amba_probe().  But that's just me. :-)

The device is not attached to any domain and there is no hardware domain
matching.

Thanks for feedback!

Best regards,
Krzysztof

> 
> There's one weak point in [3/5], but let me comment it in there.
> 
> Rafael

