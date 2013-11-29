Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917Ab3K2NtS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 08:49:18 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:55205 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755309Ab3K2NtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 08:49:15 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Kevin Hilman <khilman@linaro.org>
Subject: Re: [PATCH 0/5] PM: Enable option of re-use runtime PM callbacks at system suspend
Date: Fri, 29 Nov 2013 15:02:07 +0100
Message-ID: <4064706.R9zKA4hcfi@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <3006899.CPLMC2kU1a@vostro.rjw.lan>
References: <1385566500-7666-1-git-send-email-ulf.hansson@linaro.org> <CAPDyKFrRjB7gPpQ4c1U5e-BTHEt6k=kDqo7q1Grc04v-SDrsDw@mail.gmail.com> <3006899.CPLMC2kU1a@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, November 29, 2013 02:52:20 PM Rafael J. Wysocki wrote:
> On Friday, November 29, 2013 10:32:06 AM Ulf Hansson wrote:

[...]

> > For the same reasons, I believe we should trust drivers/subsystems, to
> > understand when it makes sense for them to re-use all of the runtime
> > PM callbacks during system suspend and not just the .runtime_suspend
> > callback.
> > 
> > That is in principle what I and Alan, who came up with this idea, are
> > suggesting.
> 
> The problem with it is, as I said, the subsystem-level code you're calling
> back through pm_generic_suspend_late_runtime() (and the other resume function)
> has to be implemented in a specific way for things to work.  So it goes like
> this: "OK, now I'm not runtime-suspended, so I need to do something about that.
> Why don't I call back to the layer above me that has just called me (and that
> surely won't do anything after I return, right?), so that it does the right
> thing (which it surely will do, of course?) and calls my runtime PM callback
> as expected".
> 
> And now suppose that your subsystem-level callbacks look like this (pseudo code):
> 
> a_suspend_late(dev)
> {
> 	if (successful(pm_generic_suspend_late(dev)))
> 		do_X(dev);
> }
> 
> a_runtime_suspend(dev)
> {
> 	if (successful(pm_generic_runtime_suspend(dev)))
> 		do_Y(dev);
> }
> 
> Then, if the driver uses your pm_generic_suspend_late_runtime(), the actually
> executed code will be (assuming dev is not runtime-suspended):
> 
> 	a_suspend_late(dev)
> 		driver->suspend_late(dev)
> 			a_runtime_suspend(dev)
> 				driver->runtime_suspend(dev)
> 				do_Y(dev)
> 	do_X(dev)
> 
> So what if do_X(dev) after do_Y(dev) doesn't actually work?
> 
> And what you actually want is
> 
> 	driver->runtime_suspend(dev)
> 	do_Y(dev)

That should have been

 	driver->runtime_suspend(dev)
 	do_X(dev)

because do_Y(dev) is for runtime suspend.  Sorry.

And of course, the subsystem-level code you're developing the driver for may not
do the do_X(dev) thing at all, in which case all will work.  But what if someone
tries to use the driver with a different subsystem-level code (like a new PM
domain)?

Rafael

