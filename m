Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752396AbaBZW6U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 17:58:20 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:52636 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751761AbaBZW6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 17:58:19 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] PM / sleep: New flag to speed up suspend-resume of suspended devices
Date: Thu, 27 Feb 2014 00:13:19 +0100
Message-ID: <4633671.dBN1DXCk1F@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <Pine.LNX.4.44L0.1402261708030.1308-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1402261708030.1308-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, February 26, 2014 05:17:03 PM Alan Stern wrote:
> On Wed, 26 Feb 2014, Rafael J. Wysocki wrote:
> 
> > > > Still, I think that something like power.fast_suspend is needed to indicate
> > > > that .suspend_late(), .suspend_noirq(), .resume_noirq() and .resume_early()
> > > > should be skipped for it (in my opinion the core may very well skip them then)
> > > > and so that .resume() knows how to handle the device.
> > > 
> > > I don't follow.  Why would you skip these routines without also
> > > skipping .suspend and .resume?
> > 
> > Because .suspend will set the flag and then it would be reasonable to call .resume,
> > for symmetry and to let it decide what to do (e.g. call pm_runtime_resume(dev) or
> > do something else, depending on the subsystem).
> 
> In the original patch, ->prepare returned the flag.  When it was set,
> you would skip ->suspend, ->suspend_late, and ->suspend_noirq (and the
> corresponding resume callbacks).  Did you decide to change this?

Yes, I did.

After these patches:

https://patchwork.kernel.org/patch/3705261/
https://patchwork.kernel.org/patch/3705271/

the decision doesn't have to be made until ->suspend (I'm ingoring the
power.ignore_children set special case), because that's when
pm_runtime_resume(dev) is now called (by ACPI and PCI).

> > > However, the second may indeed be a problem.  I don't know how you
> > > intend to handle it.  Apply the patch, like you did for ACPI and PCI
> > > above, and then see what happens?
> > 
> > For starters, I'd just make the parent's ->resume call pm_runtime_resume(dev).
> > That will make the parent be ready before the child's ->resume is called.
> > And then it may be optimized further going forward, possibly by replacing
> > the pm_runtime_resume() with pm_request_resume() for some devices and by
> > leaving some devices in RPM_SUSPENDED.
> 
> Of course, this would not be possible with the original version of the 
> patch, because it wouldn't invoke the parent's ->resume.

Right.

> > > A simple solution is to use fast_suspend only for devices that have no
> > > children.  But that would not be optimal.
> > > 
> > > Another possibility is always to call pm_runtime_resume(dev->parent)
> > > before invoking dev's ->resume callback.  But that might not solve the
> > > entire problem (it wouldn't help dev's ->resume_early callback, for
> > > instance) and it also might be sub-optimal.
> > 
> > The child's ->resume_early may be a problem indeed (or its ->resume_noirq
> > for that matter).
> 
> If the child knows about the problem beforehand, it can runtime-resume 
> the parent during its ->suspend.

Well, it even should do that in those cases.  We may need to deal with children
that don't do that, though.

> > Well, if power.fast_suspend set guarantees that ->suspend_late, ->suspend_noirq,
> > ->resume_noirq, and ->resume_early will be skipped for a device, then we may
> > restrict setting it for devices whose children have it set (or that have no
> > children).  Initially, that will be equivalent to setting it for leaf devices
> > only, but it might be extended over time in a natural way.
> 
> Initially, maybe.

Of course initially.

> But it's the wrong approach in general.

In the long run - I agree.

> The right approach is to restrict setting fast_suspend for devices whose
> children don't mind their parent being suspended when their resume callbacks 
> run -- not for devices whose children also have fast_suspend set.

I agree, but we need to know which children are OK with the parent being
suspended.  Having fast_suspend set is a good indication of that. :-)

Of course, we may introduce a separate flag for that just fine if you prefer.

> That's the point I've been trying to express all along.

I see.

Rafael

