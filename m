Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340AbaEIBwW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 21:52:22 -0400
Received: from netrider.rowland.org ([192.131.102.5]:50812 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754207AbaEIBwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 21:52:19 -0400
Date: Thu, 8 May 2014 21:52:18 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
cc: Linux PM list <linux-pm@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 1/3] PM / sleep: Flag to speed up suspend-resume of
 runtime-suspended devices
In-Reply-To: <2356017.WpDFDYKWcr@vostro.rjw.lan>
Message-ID: <Pine.LNX.4.44L0.1405082110330.13708-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 May 2014, Rafael J. Wysocki wrote:

> Well, no.
> 
> The reason why that doesn't work is because ->prepare() callbacks are
> executed in the reverse order, so the perent's ones will be run before
> the ->prepare() of the children.  Thus if ->prepare() sets the flag
> with the expectation that ->suspend() (and the subsequent callbacks)
> won't be executed, that expectation may not be met actually.

That's true also if the flag gets set in ->suspend(), isn't it?  A
driver may set direct_resume in its ->suspend() callback, expecting
that the subsequent callbacks won't be executed.  But if a descendant
hasn't also set its flag then the callbacks _will_ be executed.

> So I'm going to do what I said above.  I prefer it anyway. :-)

In your most recent patch (and in the earlier ones too), after you call
dev's ->suspend() routine, if dev->power.direct_resume isn't set then
you clear dev->parent->direct_resume.  But what good will that do if
dev->parent's ->suspend() routine turns the flag back on when it gets
called later?

I can think of two ways to make this work.

	Expect subsystems and drivers to set the flag during 
	->suspend().  Turn on the flag in every device during 
	device_prepare().  Then in __device_suspend(), remember the
	flag's value and turn it off before invoking the callback.  If 
	the flag is on again when the callback returns, set the flag 
	back to the remembered value.  If the flag ends up being off
	then turn off the parent's flag.

	Expect subsystems and drivers to set the flag during 
	->prepare().  Whenever a callback returns with the flag not
	set, clear the flag in all of the device's ancestors.

Both are somewhat awkward, and both involve turning the flag off after 
the callback has turned it on.

Also, how do you expect direct_resume to work with the PCI subsystem?  
Will the PCI core set the flag appropriately on behalf of the driver?  
If the core does set the flag, will it invoke the driver's ->suspend()
callback or skip the callback?  If it invokes the driver's callback but
leaves the device in runtime suspend, what happens if the driver
expects the device always to be at full power when its ->suspend()  
routine runs?  If the core skips the driver's ->suspend() callback,
what happens if one of the device's children did not set direct_resume 
and so the later PM callbacks do get invoked?

Several of these questions are a lot easier to answer if the flag gets 
set during ->prepare() rather than ->suspend().

Alan Stern

