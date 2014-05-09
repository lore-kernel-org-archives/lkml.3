Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007AbaEIWcq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 18:32:46 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:49721 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754728AbaEIWco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 18:32:44 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 1/3] PM / sleep: Flag to speed up suspend-resume of runtime-suspended devices
Date: Sat, 10 May 2014 00:49:25 +0200
Message-ID: <1599191.L8hnSpOETp@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <Pine.LNX.4.44L0.1405082110330.13708-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.1405082110330.13708-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 08, 2014 09:52:18 PM Alan Stern wrote:
> On Thu, 8 May 2014, Rafael J. Wysocki wrote:
> 
> > Well, no.
> > 
> > The reason why that doesn't work is because ->prepare() callbacks are
> > executed in the reverse order, so the perent's ones will be run before
> > the ->prepare() of the children.  Thus if ->prepare() sets the flag
> > with the expectation that ->suspend() (and the subsequent callbacks)
> > won't be executed, that expectation may not be met actually.
> 
> That's true also if the flag gets set in ->suspend(), isn't it?  A
> driver may set direct_resume in its ->suspend() callback, expecting
> that the subsequent callbacks won't be executed.  But if a descendant
> hasn't also set its flag then the callbacks _will_ be executed.

No, that's not possible with the current patch, because __device_suspend() is
executed for descendants first and then for ancestors and it clears
direct_suspend for the parents of devices that don't have it set.  This means
that the ancestor's ->suspend() will see the flag clear if it is unset for
any of its descendants.

IOW, the only case in which the ancestor's ->suspend() sees the flag set is
when it has been set for all of its descendants.  Thus, if it leaves the
flag set, the late/early and noirq callbacks won't be executed for it.

Now, there is a reason for concern in that, because ->suspend() may set the
flag as a result of an error and that may lead to unexpected consequences.

> > So I'm going to do what I said above.  I prefer it anyway. :-)
> 
> In your most recent patch (and in the earlier ones too), after you call
> dev's ->suspend() routine, if dev->power.direct_resume isn't set then
> you clear dev->parent->direct_resume.  But what good will that do if
> dev->parent's ->suspend() routine turns the flag back on when it gets
> called later?

In fact, ->suspend() is not supposed to set the flag when it is clear.
It can clear it when it is set, which means that we have "normal" suspend.

> I can think of two ways to make this work.
> 
> 	Expect subsystems and drivers to set the flag during 
> 	->suspend().  Turn on the flag in every device during 
> 	device_prepare().  Then in __device_suspend(), remember the
> 	flag's value and turn it off before invoking the callback.

That doesn't work, because ->suspend() has to decide whether or not
to resume the device and do things it would do normally, so it needs to know
the value of the flag.

>       If the flag is on again when the callback returns, set the flag 
> 	back to the remembered value.  If the flag ends up being off
> 	then turn off the parent's flag.

That'd be too late.  The only thing we can do to kind of protect the PM
core from errors in drivers in that case would be to remember the value of
the flag before calling ->suspend() and return an error if it the flag after
->suspend() is set, but it wasn't before.

> 	Expect subsystems and drivers to set the flag during 
> 	->prepare().  Whenever a callback returns with the flag not
> 	set, clear the flag in all of the device's ancestors.
> 
> Both are somewhat awkward, and both involve turning the flag off after 
> the callback has turned it on.

After the callback set it on while it shouldn't, it might have done something
wrong already.

> Also, how do you expect direct_resume to work with the PCI subsystem?  
> Will the PCI core set the flag appropriately on behalf of the driver?

Yes.

> If the core does set the flag, will it invoke the driver's ->suspend()
> callback or skip the callback?

It will skip the driver's callback.  [It would actually help if you looked
at patch [3/3] which is there to illustrate my idea of how to do those
things in a subsystem.]

> If it invokes the driver's callback but
> leaves the device in runtime suspend, what happens if the driver
> expects the device always to be at full power when its ->suspend()  
> routine runs?  If the core skips the driver's ->suspend() callback,
> what happens if one of the device's children did not set direct_resume 
> and so the later PM callbacks do get invoked?

Then the parent will have direct_resume unset.  That is not a concern.
The only concern to me is possible errors in ->suspend() setting the
flag when it shouldn't.

> Several of these questions are a lot easier to answer if the flag gets 
> set during ->prepare() rather than ->suspend().

I agree with that, but I have one concern about this approach.  Namely,
in that case the PM core has to use pm_runtime_resume() or equivalent to
resume devices with the flag set during the device resume stage.  Now,
in the next step we may want to leave certain devices suspended at that
point and the PM core has no way to tell which ones.  Also subsystems
don't really have a chance to tell it about that (they would need to
know in advance during ->prepare(), which is kind of unrealistic, or
perhaps it isn't).

However, if ->resume() is called for devices with the flag set, like in
my most recent patch, the subsystem may decide not to resume the device
if it knows enough about it.

This pretty much is my only concern here, so I'm open to ideas how to deal
with leaving devices suspended (if possible) during the device resume stage. :-)

For one, postponing the resume to ->complete() is an option, but it will have
to be done with care, because the ->complete() callbacks are executed
sequentially, so calling pm_runtime_resume() from there is rather out of the
question.

Rafael

