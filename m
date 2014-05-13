Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965088AbaEMPIm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 11:08:42 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:50756 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760052AbaEMPIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 11:08:40 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [RFC][PATCH 0/3] PM / sleep: Avoid resuming runtime-suspended devices during system suspend
Date: Tue, 13 May 2014 17:25:26 +0200
Message-ID: <1881168.eI1v8ceYmq@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <Pine.LNX.4.44L0.1405131038220.1098-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1405131038220.1098-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, May 13, 2014 10:45:38 AM Alan Stern wrote:
> On Tue, 13 May 2014, Rafael J. Wysocki wrote:
> 
> > Hi All,
> > 
> > We've discussed that at length here:
> > 
> > http://marc.info/?t=139950469000003&r=1&w=4
> > 
> > but I'm starting a new thread to refresh things a bit.
> > 
> > This is about adding a mechanism allowing us to avoid runtime-suspended
> > devices during system suspend.  The reason why it has to touch the PM core
> > is because that needs to be coordinated across the device hierarchy.
> > 
> > The idea is to add a new device PM flag and to modify the PM core as follows.
> > 
> >  - If ->prepare() returns a positive number for a device, that means "this
> >    device is runtime-suspended and you can leave it like that if you do the
> >    same for all of its descendants".
> > 
> >  - If that happens, the PM core sets the new flag for the device in
> >    question *if* the device is indeed runtime-suspended *and* *if*
> >    the transition is a suspend (and not hibernation, for example).
> >    Otherwise, it clears the flag for the device.  All of that happens in
> >    device_prepare().
> > 
> >  - In __device_suspend() the PM core clears the new flag for the device's
> >    parent if it is clear for the device to ensure that the flag will only
> >    be set for a device if it is also set for all of its descendants.
> 
> There's nothing to prevent a runtime-suspended device from being 
> resumed in between the ->prepare() and ->suspend() callbacks.

I'm moving the barrier from __device_suspend() to device_prepare(), so there
shouldn't be surprise resumes in that time frame.

> (Ulf mentioned this too.)

Ulf was talking about pm_wakeup_pending(), which is tangentially related.

> Therefore it makes little sense to check the device's runtime status in 
> device_prepare().  The check should be done in __device_suspend().

If we do the barrier in device_prepare(), then I'm not sure what mechanism
would cause the device to resume.

If there is one, the whole approach is in danger, because ->prepare() has to
check if devices are runtime-suspended and has to be sure that their status
won't change after it has returned 1.

> >  - PM core skips ->suspend/late/noirq and ->resume/early/noirq for all devices
> >    having the flag set - so the flag can be called "direct_complete" as it
> >    causes the PM core to go directy for the ->complete() callback when set.
> > 
> >  - The ->complete() callback has to check direct_complete if ->prepare()
> >    returned a positive number previously and is responsible for further
> >    handling of the device.
> > 
> > That is introduced by patch [2/3].
> > 
> > To simplify things slightly it is helpful to move the invocation of
> > pm_runtime_barrier() from __device_suspend() to device_prepare(), but still
> > under pm_runtime_get_noresume() beforehand (patch [1/3]).
> 
> If the check is moved to __device_suspend() then the barrier can remain 
> where it is now.

The check also needs to be done in ->prepare().

> > Patch [3/3] shows how this can be used by adding support for it to the ACPI
> > PM comain.
> > 
> > Thanks!
> 
> Aside from this one matter, everything seems pretty good.

Well, that's a quite a big issue.

Rafael

